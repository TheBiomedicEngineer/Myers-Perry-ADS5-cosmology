#!/usr/bin/env python3
# =============================================================================
#  QUADRUPOLO di H0 su DES-SN5YR  (z 0.05-1.13: la fascia che a Pantheon+ mancava)
#  Versione ROBUSTA: si adatta ai nomi di colonna, prova piu' file, e se non
#  trova le coordinate (RA/DEC) te lo dice chiaramente invece di crashare.
#  Finestra con pausa finale: resta aperta finche' premi INVIO.
# =============================================================================
import traceback
def _main():
    import numpy as np, urllib.request, os, csv, io
    trapz = np.trapezoid if hasattr(np,'trapezoid') else np.trapz

    # --- possibili posizioni del file Hubble-diagram DES (provo in ordine) ---
    BASE = "https://raw.githubusercontent.com/des-science/DES-SN5YR/main/4_DISTANCES_COVMAT/"
    CANDIDATI = [
        BASE+"DES-SN5YR_HD.csv",
        BASE+"DES-SN5YR_HD%2BMetaData.csv",
        BASE+"DES-SN5YR_HD+MetaData.csv",
        BASE+"DES-SN5YR_HD.txt",
    ]
    FN = "DES-SN5YR_HD.csv"

    if not os.path.exists(FN):
        scaricato=False
        for url in CANDIDATI:
            try:
                print("Provo a scaricare:", url)
                urllib.request.urlretrieve(url, FN)
                # controllo che non sia una pagina di errore html
                with open(FN) as f: testa=f.read(200)
                if "<html" in testa.lower() or "404" in testa[:20]:
                    print("  (non e' il file giusto, continuo)"); continue
                print("  OK scaricato."); scaricato=True; break
            except Exception as e:
                print("  fallito:", e)
        if not scaricato:
            print("\nNON sono riuscito a scaricare automaticamente.")
            print("Scarica a mano la cartella '4_DISTANCES_COVMAT' da:")
            print("  https://github.com/des-science/DES-SN5YR")
            print("trova il file che finisce in _HD.csv (o simile), mettilo qui col nome", FN)
            return
    else:
        print("Uso il file gia' presente:", FN)

    # --- leggo l'header e capisco il separatore ---
    with open(FN) as f:
        prima = f.readline()
    sep = ',' if prima.count(',') >= prima.count(' ') else None  # None = whitespace
    # rileggo header pulito
    header = [h.strip() for h in (prima.split(',') if sep==',' else prima.split())]
    header = [h for h in header if h != '']
    print("\nHEADER del file (le colonne disponibili):")
    print(" ", header)

    colidx = {name:i for i,name in enumerate(header)}
    def trova(*nomi, obbligatorio=True):
        for n in nomi:
            for h in header:
                if h.lower()==n.lower(): return colidx[h]
        if obbligatorio:
            return None
        return None

    iz   = trova("zHD","zCMB","z")
    imu  = trova("MU","MU_SH0ES","mu")
    ira  = trova("RA","RA_deg","ra","RAJ2000")
    idec = trova("DEC","DECL","dec","DEJ2000","DECJ2000")
    ierr = trova("MUERR","MU_SH0ES_ERR_DIAG","MUERR_FINAL","MU_ERR","muerr", obbligatorio=False)

    if iz is None or imu is None:
        print("\n!! Non trovo redshift o MU. Manda a Claude l'header qui sopra.")
        return
    if ira is None or idec is None:
        print("\n!! ATTENZIONE: questo file NON contiene le coordinate RA/DEC.")
        print("   Servono per l'analisi del quadrupolo. Le coordinate stanno")
        print("   probabilmente in un file separato (curve di luce / metadata).")
        print("   Manda a Claude l'header qui sopra: ti dico quale file in piu' serve.")
        return

    # --- carico i dati (gestendo csv o whitespace) ---
    rows=[]
    with open(FN) as f:
        rdr = csv.reader(f) if sep==',' else (line.split() for line in f)
        next(rdr)  # salto header
        for r in rdr:
            if not r: continue
            try:
                z_=float(r[iz]); mu_=float(r[imu]); ra_=float(r[ira]); dec_=float(r[idec])
                err_=float(r[ierr]) if (ierr is not None and r[ierr] not in ('','nan')) else 0.15
                rows.append((z_,ra_,dec_,mu_,err_))
            except (ValueError,IndexError):
                continue
    d=np.array(rows)
    z,ra,dec,mu,err = d[:,0],d[:,1],d[:,2],d[:,3],d[:,4]
    print(f"\n{len(z)} SNe lette. Range z: {z.min():.3f} - {z.max():.3f}")

    # --- LCDM, residui, multipoli (identico all'analisi Pantheon) ---
    c_km=299792.458; Om=0.3
    def mu_lcdm(zz):
        out=np.empty_like(zz)
        for k,zi in enumerate(zz):
            zg=np.linspace(0,zi,200); E=np.sqrt(Om*(1+zg)**3+(1-Om))
            dL=(1+zi)*c_km/70.0*trapz(1/E,zg); out[k]=5*np.log10(dL*1e5)
        return out
    def versori(ra_,dec_):
        r=np.radians(ra_); dn=np.radians(dec_)
        return np.vstack([np.cos(dn)*np.cos(r),np.cos(dn)*np.sin(r),np.sin(dn)]).T
    def design(n):
        nx,ny,nz=n[:,0],n[:,1],n[:,2]; N=len(n)
        return np.vstack([np.ones(N),nx,ny,nz,nx*nx-nz*nz,ny*ny-nz*nz,nx*ny,nx*nz,ny*nz]).T
    def analizza(zmin,zmax,nperm=2000):
        m=(z>zmin)&(z<zmax)&np.isfinite(mu)&(err>0)
        if m.sum()<40: return (int(m.sum()),None,None)
        zz,raa,dee,muu,ee=z[m],ra[m],dec[m],mu[m],err[m]
        res=muu-mu_lcdm(zz); W=1/ee**2; res=res-np.average(res,weights=W)
        n=versori(raa,dee)
        def strength(r,nn,w):
            A=design(nn); p=np.linalg.solve(A.T@(w[:,None]*A),A.T@(w*r)); return np.sum(p[4:9]**2),p
        obs,p=strength(res,n,W)
        q1,q2,q3,q4,q5=p[4:9]
        Q=np.array([[q1,q3,q4],[q3,q2,q5],[q4,q5,-(q1+q2)]])
        ev=np.linalg.eigvalsh(Q); amp=np.max(np.abs(ev))*np.log(10)/5*100
        rng=np.random.default_rng(42); null=np.empty(nperm)
        for i in range(nperm):
            idx=rng.permutation(len(res)); null[i],_=strength(res,n[idx],W)
        return (int(m.sum()), float(np.mean(null>=obs)), float(amp))

    print("\n================ SOGLIE CUMULATIVE (DES) ================")
    print(f"{'zmin':>6} {'zmax':>6} {'N_SNe':>7} {'p-value':>9} {'ampiezza%':>10}")
    for zmin in [0.05,0.10,0.15,0.20,0.30,0.40,0.50]:
        N,pv,amp=analizza(zmin,1.2)
        if pv is None: print(f"{zmin:>6.2f} {1.2:>6.2f} {N:>7} {'(poche SNe)':>9}")
        else: print(f"{zmin:>6.2f} {1.2:>6.2f} {N:>7} {pv:>9.4f} {amp:>9.2f}%")

    print("\n================ FETTE INDIPENDENTI (DES) ================")
    print(f"{'zmin':>6} {'zmax':>6} {'N_SNe':>7} {'p-value':>9} {'ampiezza%':>10}")
    for zmin,zmax in [(0.05,0.20),(0.20,0.35),(0.35,0.55),(0.55,0.80),(0.80,1.20)]:
        N,pv,amp=analizza(zmin,zmax)
        if pv is None: print(f"{zmin:>6.2f} {zmax:>6.2f} {N:>7} {'(poche SNe)':>9}")
        else: print(f"{zmin:>6.2f} {zmax:>6.2f} {N:>7} {pv:>9.4f} {amp:>9.2f}%")

    print("""
COME LEGGERE (uguale a Pantheon):
- p<0.05 = segnale significativo; sopra = rumore.
- la nostra firma vive a z MEDIO-ALTO e cresce/persiste con z. DES copre bene 0.2-1.1.
- ampiezza significativa SOLO se p e' basso.
- confronta con Pantheon+: se DES vede a z>0.3 quello che Pantheon non poteva, e' informazione nuova.
""")

try:
    _main()
except Exception:
    print("\n*** ERRORE - copia tutto e mandalo a Claude: ***\n"); traceback.print_exc()
input("\n\n>>> FATTO. Premi INVIO per chiudere <<<")
