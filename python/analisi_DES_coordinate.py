#!/usr/bin/env python3
# =============================================================================
#  DES-SN5YR: estrai RA/DEC dalle curve di luce, unisci alle distanze, ANALIZZA
#  Versione che lavora su file GIA' SCARICATI A MANO (niente download da Python,
#  cosi' evitiamo l'errore SSL del tuo PC). Pausa finale: la finestra resta aperta.
#
#  COSA TI SERVE PRIMA DI LANCIARE (vedi istruzioni che ti ho dato in chat):
#   1. Il file delle distanze che hai gia' (quello con CID,zHD,MU...).
#      Mettilo nella stessa cartella di questo script. Nome atteso: DES_distanze.txt
#      (rinominalo cosi', o cambia DIST_FILE qui sotto.)
#   2. La cartella con le curve di luce DES scaricata da Zenodo ed ESTRATTA (unzippata).
#      Mettila nella stessa cartella. Lo script la cerca da solo (cerca file FITS o .dat
#      che contengono gli header con RA/DEC).
# =============================================================================
import traceback
def _main():
    import os, glob, sys
    import numpy as np

    DIST_FILE = "DES_distanze.txt"   # <-- il tuo file distanze (rinominalo cosi')

    # ----- 1. cerco le curve di luce nella cartella corrente (ricorsivo) -----
    print("Cerco i file delle curve di luce DES nella cartella...")
    # SNANA puo' essere in FITS (HEAD/PHOT) o in file di testo. Provo entrambi.
    fits_head = glob.glob("**/*HEAD*.FITS", recursive=True) + glob.glob("**/*HEAD*.fits", recursive=True)
    txt_lc    = glob.glob("**/*.dat", recursive=True) + glob.glob("**/*.DAT", recursive=True) + \
                glob.glob("**/des*.txt", recursive=True)
    print(f"  trovati {len(fits_head)} file HEAD.FITS e {len(txt_lc)} possibili file di testo")

    coords = {}  # SNID -> (RA, DEC)

    # ----- 2a. estraggo RA/DEC dai FITS HEAD (caso piu' probabile per DES) -----
    if fits_head:
        try:
            from astropy.io import fits
        except ImportError:
            print("\n!! Manca astropy. Installalo col comando:  py -m pip install astropy")
            print("   poi rilancia lo script.")
            return
        for hf in fits_head:
            try:
                with fits.open(hf) as hdul:
                    data = hdul[1].data
                    names = [c.upper() for c in data.columns.names]
                    # cerco le colonne SNID, RA, DEC (nomi variabili)
                    def col(*opts):
                        for o in opts:
                            if o in names: return data.columns.names[names.index(o)]
                        return None
                    c_id = col("SNID","CID")
                    c_ra = col("RA","RA_DEG")
                    c_de = col("DEC","DECL","DEC_DEG")
                    if c_id and c_ra and c_de:
                        for i in range(len(data)):
                            sid = str(data[c_id][i]).strip()
                            coords[sid] = (float(data[c_ra][i]), float(data[c_de][i]))
            except Exception as e:
                print(f"  (salto {hf}: {e})")

    # ----- 2b. se niente FITS, provo a leggere header testuali SNANA -----
    if not coords and txt_lc:
        for tf in txt_lc:
            try:
                sid=ra=de=None
                with open(tf, errors='ignore') as f:
                    for line in f:
                        u=line.strip().upper()
                        if u.startswith("SNID:"):  sid=line.split(":")[1].split()[0].strip()
                        elif u.startswith("RA:"):   ra=float(line.split(":")[1].split()[0])
                        elif u.startswith("DEC:") or u.startswith("DECL:"): de=float(line.split(":")[1].split()[0])
                        if sid and ra is not None and de is not None: break
                if sid and ra is not None and de is not None:
                    coords[sid]=(ra,de)
            except Exception:
                continue

    print(f"\nEstratte coordinate per {len(coords)} supernove.")
    if len(coords) < 50:
        print("!! Poche/nessuna coordinata trovata. Possibili cause:")
        print("   - la cartella delle curve di luce non e' estratta/presente qui")
        print("   - i file hanno un formato diverso dal previsto")
        print("   Mandami a Claude: il nome di qualche file che vedi nella cartella DES,")
        print("   cosi' adatto lo script. (Lista qui sotto i primi file trovati:)")
        for p in (fits_head+txt_lc)[:10]: print("    ", p)
        if len(coords)==0: return

    # ----- 3. leggo il file delle distanze (CID, zHD, MU, MUERR) -----
    if not os.path.exists(DIST_FILE):
        print(f"\n!! Non trovo {DIST_FILE}. Rinomina il tuo file distanze in '{DIST_FILE}'")
        print("   e mettilo in questa cartella.")
        return
    print(f"\nLeggo le distanze da {DIST_FILE} ...")
    z=[]; mu=[]; err=[]; ra=[]; dec=[]; n_match=0; n_nomatch=0
    with open(DIST_FILE, errors='ignore') as f:
        for line in f:
            if not line.strip() or line.lstrip().startswith("#"): continue
            parts=line.split()
            # formato: SN: <CID> <IDSURVEY> <zHD> <zHEL> <MU> <MUERR> ...
            if parts[0] in ("SN:","SN") and len(parts)>=7:
                cid=parts[1].strip()
                try:
                    z_=float(parts[3]); mu_=float(parts[5]); err_=float(parts[6])
                except ValueError: continue
                if cid in coords:
                    ra.append(coords[cid][0]); dec.append(coords[cid][1])
                    z.append(z_); mu.append(mu_); err.append(err_ if err_>0 else 0.15)
                    n_match+=1
                else:
                    n_nomatch+=1
    z=np.array(z); mu=np.array(mu); err=np.array(err); ra=np.array(ra); dec=np.array(dec)
    print(f"  SNe con coordinate abbinate (per CID): {n_match}")
    print(f"  SNe senza match (coordinata non trovata): {n_nomatch}")
    if n_match<50:
        print("  Pochi match. Forse i CID nei due file sono scritti diversamente. Mandami a Claude")
        print("  un CID dal file distanze e uno dalle curve di luce, li allineo.")
        return

    # pulizia: tolgo SNe spazzatura (errori enormi viste nel file, es. MUERR~200)
    good=(err<5)&np.isfinite(mu)&np.isfinite(ra)&np.isfinite(dec)
    z,mu,err,ra,dec=z[good],mu[good],err[good],ra[good],dec[good]
    print(f"  dopo pulizia (tolti errori>5 mag): {len(z)} SNe.  z: {z.min():.3f}-{z.max():.3f}")

    # ----- 4. analisi: LCDM, residui, multipoli -----
    c_km=299792.458; Om=0.3
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
        if m.sum()<40: return (int(m.sum()),None,None,None)
        zz,rr,dd,mm,ee=z[m],ra[m],dec[m],mu[m],err[m]
        res=mm-mu_lcdm(zz);W=1/ee**2;res=res-np.average(res,weights=W)
        n=vers(rr,dd)
        def strq(r,nn,w):
            A=design(nn);p=np.linalg.solve(A.T@(w[:,None]*A),A.T@(w*r));return np.sum(p[4:9]**2),p
        def strd(r,nn,w):  # potenza nel DIPOLO
            A=design(nn);p=np.linalg.solve(A.T@(w[:,None]*A),A.T@(w*r));return np.sum(p[1:4]**2)
        obsq,p=strq(res,n,W); obsd=strd(res,n,W)
        rng=np.random.default_rng(42);nq=np.empty(nperm);nd=np.empty(nperm)
        for i in range(nperm):
            idx=rng.permutation(len(res))
            nq[i],_=strq(res,n[idx],W); nd[i]=strd(res,n[idx],W)
        pq=float(np.mean(nq>=obsq)); pd=float(np.mean(nd>=obsd))
        return (int(m.sum()), pq, pd, None)

    print("\n"+"="*64)
    print("ANALISI DES (coi nostri occhi). NB: copertura 10 campi -> quadrupolo")
    print("mal condizionato (gia' calcolato). Misuro anche il DIPOLO (= rivali/bulk).")
    print("="*64)
    print(f"{'zmin':>6} {'zmax':>6} {'N':>6} {'p_QUAD':>8} {'p_DIP':>8}")
    for zmin in [0.10,0.20,0.30,0.40,0.50]:
        N,pq,pd,_=analizza(zmin,1.2)
        if pq is None: print(f"{zmin:>6.2f} {1.2:>6.2f} {N:>6}  (poche SNe)")
        else: print(f"{zmin:>6.2f} {1.2:>6.2f} {N:>6} {pq:>8.4f} {pd:>8.4f}")
    print("""
LETTURA:
- p_QUAD: quadrupolo. Ma copertura DES scarsa -> prendere con le pinze (mal condizionato).
- p_DIP: dipolo. Se basso = c'e' un dipolo (bulk flow locale, NON nostro: noi siamo ciechi al verso).
- la cosa pulita che DES puo' dire e' sul DIPOLO/bulk della sua regione, non sul nostro quadrupolo.
""")

try:
    _main()
except Exception:
    print("\n*** ERRORE - copia tutto e mandalo a Claude: ***\n"); traceback.print_exc()
input("\n\n>>> FATTO. Premi INVIO per chiudere <<<")
