#!/usr/bin/env python3
# =============================================================================
#  DES-SN5YR: estrai RA/DEC dal HEAD.FITS, unisci alle distanze, ANALIZZA
#  VERSIONE A PERCORSI ESPLICITI: niente ricerca automatica, gli dici tu dove
#  sono i file. Cosi' non c'e' ambiguita' su quale cartella guarda.
#  Pausa finale: la finestra resta aperta.
# =============================================================================
import traceback
def _main():
    import os
    import numpy as np

    # ========================================================================
    #  >>> METTI QUI I PERCORSI DEI TUOI FILE <<<
    #  Per copiare il percorso in Windows: tieni premuto SHIFT, tasto destro
    #  sul file, "Copia come percorso". Incolla tra le virgolette qui sotto.
    #  IMPORTANTE: lascia la 'r' prima delle virgolette (gestisce i backslash).
    # ========================================================================
    HEAD_FITS  = r"DES-SN5YR_DES_HEAD.FITS"      # il file HEAD con le coordinate
    DIST_FILE  = r"DES_distanze.txt"             # il tuo file distanze (CID,zHD,MU...)
    # Se i file NON sono nella stessa cartella dello script, metti il percorso
    # completo, es: r"C:\Users\TuoNome\Downloads\DES-SN5YR\data\DES\DES-SN5YR_DES_HEAD.FITS"
    # ========================================================================

    # --- astropy ---
    try:
        from astropy.io import fits
    except ImportError:
        print("Manca astropy. Installalo con:   py -m pip install astropy")
        print("poi rilancia lo script.")
        return

    # --- 1. leggo il HEAD.FITS ed estraggo SNID, RA, DEC ---
    if not os.path.exists(HEAD_FITS):
        print(f"!! Non trovo il file HEAD: {HEAD_FITS}")
        print("   Controlla il percorso in cima allo script (HEAD_FITS).")
        return
    print(f"Apro {HEAD_FITS} ...")
    coords = {}
    with fits.open(HEAD_FITS) as hdul:
        data = hdul[1].data
        cols = list(data.columns.names)
        print("Colonne disponibili nel HEAD.FITS:")
        print(" ", cols)
        up = [c.upper() for c in cols]
        def col(*opts):
            for o in opts:
                if o in up: return cols[up.index(o)]
            return None
        c_id = col("SNID","CID")
        c_ra = col("RA","RA_DEG","RAJ2000")
        c_de = col("DEC","DECL","DEC_DEG","DECJ2000")
        print(f"  uso: SNID='{c_id}'  RA='{c_ra}'  DEC='{c_de}'")
        if not (c_id and c_ra and c_de):
            print("!! Non trovo SNID/RA/DEC tra le colonne. Mandami a Claude la lista colonne qui sopra.")
            return
        for i in range(len(data)):
            sid = str(data[c_id][i]).strip()
            coords[sid] = (float(data[c_ra][i]), float(data[c_de][i]))
    print(f"Estratte coordinate per {len(coords)} supernove DES.")
    # mostro un paio di esempi per controllo
    for k in list(coords)[:3]:
        print(f"   esempio: SNID={k} -> RA={coords[k][0]:.4f}, DEC={coords[k][1]:.4f}")

    # --- 2. leggo le distanze e abbino per CID ---
    if not os.path.exists(DIST_FILE):
        print(f"\n!! Non trovo {DIST_FILE}. Rinomina il tuo file distanze cosi', stessa cartella.")
        return
    print(f"\nLeggo distanze da {DIST_FILE} e abbino per CID ...")
    z=[];mu=[];err=[];ra=[];dec=[];nm=0;nn=0
    with open(DIST_FILE, errors='ignore') as f:
        for line in f:
            s=line.strip()
            if not s or s.startswith("#"): continue
            p=line.split()
            if p[0] in ("SN:","SN") and len(p)>=7:
                cid=p[1].strip()
                try: z_=float(p[3]);mu_=float(p[5]);err_=float(p[6])
                except ValueError: continue
                if cid in coords:
                    ra.append(coords[cid][0]);dec.append(coords[cid][1])
                    z.append(z_);mu.append(mu_);err.append(err_ if err_>0 else 0.15);nm+=1
                else: nn+=1
    z=np.array(z);mu=np.array(mu);err=np.array(err);ra=np.array(ra);dec=np.array(dec)
    print(f"  abbinate per CID: {nm}   senza match: {nn}")
    if nm<50:
        print("  Pochi match: i CID nei due file forse sono scritti diversi.")
        print("  Mandami a Claude un SNID dal FITS (vedi esempi sopra) e un CID dal file distanze.")
        return
    good=(err<5)&np.isfinite(mu)&np.isfinite(ra)&np.isfinite(dec)
    z,mu,err,ra,dec=z[good],mu[good],err[good],ra[good],dec[good]
    print(f"  dopo pulizia: {len(z)} SNe.  z range: {z.min():.3f}-{z.max():.3f}")

    # --- 3. analisi multipolare (dipolo + quadrupolo) ---
    c_km=299792.458;Om=0.3
    trapz=np.trapezoid if hasattr(np,'trapezoid') else np.trapz
    def mu_lcdm(zz):
        out=np.empty_like(zz)
        for k,zi in enumerate(zz):
            zg=np.linspace(0,zi,200);E=np.sqrt(Om*(1+zg)**3+(1-Om))
            dL=(1+zi)*c_km/70.0*trapz(1/E,zg);out[k]=5*np.log10(dL*1e5)
        return out
    def vers(r,d):
        r=np.radians(r);d=np.radians(d)
        return np.vstack([np.cos(d)*np.cos(r),np.cos(d)*np.sin(r),np.sin(d)]).T
    def design(n):
        nx,ny,nz=n[:,0],n[:,1],n[:,2];N=len(n)
        return np.vstack([np.ones(N),nx,ny,nz,nx*nx-nz*nz,ny*ny-nz*nz,nx*ny,nx*nz,ny*nz]).T
    def analizza(zmin,zmax,nperm=2000):
        m=(z>zmin)&(z<zmax)
        if m.sum()<40: return (int(m.sum()),None,None)
        zz,rr,dd,mm,ee=z[m],ra[m],dec[m],mu[m],err[m]
        res=mm-mu_lcdm(zz);W=1/ee**2;res=res-np.average(res,weights=W)
        n=vers(rr,dd)
        def stq(r,nn,w):
            A=design(nn);p=np.linalg.solve(A.T@(w[:,None]*A),A.T@(w*r));return np.sum(p[4:9]**2)
        def sd(r,nn,w):
            A=design(nn);p=np.linalg.solve(A.T@(w[:,None]*A),A.T@(w*r));return np.sum(p[1:4]**2)
        oq=stq(res,n,W);od=sd(res,n,W)
        rng=np.random.default_rng(42);nq=np.empty(nperm);nd=np.empty(nperm)
        for i in range(nperm):
            idx=rng.permutation(len(res));nq[i]=stq(res,n[idx],W);nd[i]=sd(res,n[idx],W)
        return (int(m.sum()),float(np.mean(nq>=oq)),float(np.mean(nd>=od)))
    print("\n"+"="*60)
    print("ANALISI DES (coi nostri occhi)")
    print("NB: 10 campi -> quadrupolo mal condizionato (p_QUAD da prendere con le pinze).")
    print("Il DIPOLO (p_DIP) e' cio' che DES vincola meglio (= bulk flow locale, non nostro).")
    print("="*60)
    print(f"{'zmin':>6} {'zmax':>6} {'N':>6} {'p_QUAD':>8} {'p_DIP':>8}")
    for zmin in [0.10,0.20,0.30,0.40,0.50]:
        N,pq,pd=analizza(zmin,1.2)
        if pq is None: print(f"{zmin:>6.2f} {1.2:>6.2f} {N:>6}  (poche SNe)")
        else: print(f"{zmin:>6.2f} {1.2:>6.2f} {N:>6} {pq:>8.4f} {pd:>8.4f}")
    print("\nLETTURA: p<0.05 = significativo. p_QUAD inaffidabile (copertura). p_DIP = bulk locale.")

try:
    _main()
except Exception:
    print("\n*** ERRORE - copia tutto e mandalo a Claude: ***\n");traceback.print_exc()
input("\n\n>>> FATTO. Premi INVIO per chiudere <<<")
