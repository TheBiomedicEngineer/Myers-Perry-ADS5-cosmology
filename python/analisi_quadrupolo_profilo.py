#!/usr/bin/env python3
# =============================================================================
#  PROFILO IN Z del quadrupolo di H0 - Pantheon+  (versione automatica)
#  Fa in un colpo solo: tante soglie cumulative E tante fette indipendenti,
#  ognuna con p-value, ampiezza e numero di SNe. Finestra con pausa finale.
# =============================================================================
import traceback
def _main():
    import numpy as np, urllib.request, os, sys
    trapz = np.trapezoid if hasattr(np,'trapezoid') else np.trapz

    URL=("https://raw.githubusercontent.com/PantheonPlusSH0ES/DataRelease/"
         "main/Pantheon%2B_Data/4_DISTANCES_AND_COVAR/Pantheon%2BSH0ES.dat")
    FN="PantheonPlusSH0ES.dat"
    if not os.path.exists(FN):
        print("Scarico il catalogo..."); urllib.request.urlretrieve(URL,FN); print(" OK")
    else:
        print("Uso il file gia' presente:",FN)

    with open(FN) as f: header=f.readline().split()
    col={n:i for i,n in enumerate(header)}
    def find(*names):
        for n in names:
            if n in col: return col[n]
        raise KeyError(f"colonne non trovate {names}; header={header}")
    iz=find("zHD","zCMB"); ira=find("RA","ra"); idec=find("DEC","DECL","dec")
    imu=find("MU_SH0ES","MU"); ierr=find("MU_SH0ES_ERR_DIAG","MUERR")
    ical=col.get("IS_CALIBRATOR",None)
    usec=(iz,ira,idec,imu,ierr, ical if ical is not None else iz)
    d=np.genfromtxt(FN,skip_header=1,usecols=usec)
    z,ra,dec,mu,err=d[:,0],d[:,1],d[:,2],d[:,3],d[:,4]
    cal=d[:,5] if ical is not None else np.zeros_like(z)

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
        m=(z>zmin)&(z<zmax)&(cal<0.5)&np.isfinite(mu)&(err>0)
        if m.sum()<40: return (m.sum(),None,None)
        zz,raa,dee,muu,ee=z[m],ra[m],dec[m],mu[m],err[m]
        res=muu-mu_lcdm(zz); W=1/ee**2; res=res-np.average(res,weights=W)
        n=versori(raa,dee)
        def strength(r,nn,w):
            A=design(nn); p=np.linalg.solve(A.T@(w[:,None]*A),A.T@(w*r)); return np.sum(p[4:9]**2),p
        obs,p=strength(res,n,W)
        # ampiezza in dH/H
        q1,q2,q3,q4,q5=p[4:9]
        Q=np.array([[q1,q3,q4],[q3,q2,q5],[q4,q5,-(q1+q2)]])
        ev=np.linalg.eigvalsh(Q); amp=np.max(np.abs(ev))*np.log(10)/5*100
        rng=np.random.default_rng(42); null=np.empty(nperm)
        for i in range(nperm):
            idx=rng.permutation(len(res)); null[i],_=strength(res,n[idx],W)
        return (m.sum(), np.mean(null>=obs), amp)

    print("\n================ SOGLIE CUMULATIVE (tutto sopra zmin) ================")
    print(f"{'zmin':>6} {'zmax':>6} {'N_SNe':>7} {'p-value':>9} {'ampiezza%':>10}")
    for zmin in [0.02,0.05,0.10,0.15,0.20,0.25,0.30,0.35,0.40]:
        N,pv,amp=analizza(zmin,0.8)
        if pv is None: print(f"{zmin:>6.2f} {0.8:>6.2f} {N:>7} {'(poche SNe)':>9}")
        else: print(f"{zmin:>6.2f} {0.8:>6.2f} {N:>7} {pv:>9.4f} {amp:>9.2f}%")

    print("\n================ FETTE INDIPENDENTI (bin separati) ================")
    print(f"{'zmin':>6} {'zmax':>6} {'N_SNe':>7} {'p-value':>9} {'ampiezza%':>10}")
    bins=[(0.02,0.10),(0.10,0.20),(0.20,0.30),(0.30,0.45),(0.45,0.80)]
    for zmin,zmax in bins:
        N,pv,amp=analizza(zmin,zmax)
        if pv is None: print(f"{zmin:>6.2f} {zmax:>6.2f} {N:>7} {'(poche SNe)':>9}")
        else: print(f"{zmin:>6.2f} {zmax:>6.2f} {N:>7} {pv:>9.4f} {amp:>9.2f}%")

    print("""
COME LEGGERE:
- p-value < 0.05 = segnale significativo. Sopra = compatibile col rumore.
- CUMULATIVE: se il p scende alzando zmin -> il segnale e' a z alto (nostra firma cosmologica).
  Se sale -> e' locale (svanisce). 
- FETTE: dicono DOVE vive il segnale. La nostra firma sta nelle fette a z medio-alto, non nella prima.
- L'ampiezza conta solo se il p e' basso; se p e' alto l'ampiezza e' rumore.
""")

try:
    _main()
except Exception:
    print("\n*** ERRORE - copia tutto e mandalo a Claude: ***\n"); traceback.print_exc()
input("\n\n>>> FATTO. Premi INVIO per chiudere <<<")
