#!/usr/bin/env python3
# =============================================================================
#  ANALISI DEL QUADRUPOLO DI H0 SUI DATI PANTHEON+ REALI
#  Test della predizione del modello brana-MP-AdS5, con le NOSTRE lenti.
#
#  Cosa fa, in breve:
#   1. Scarica il catalogo Pantheon+ (pubblico) - SN per SN: posizione, z, mu
#   2. Calcola i residui di Hubble (mu osservato - mu LCDM) per ogni SN
#   3. FILTRA a z > 0.15  -> toglie la dipendenza dalle correzioni di velocita'
#      peculiare (regola 8 nello spirito: meno assunzioni altrui) e isola la
#      scala cosmologica (regola 5). A z>0.15 bulk flow e moto locale sono ~spenti:
#      un quadrupolo che sopravvive li' NON puo' essere effetto locale.
#   4. Fa l'espansione MULTIPOLARE sul cielo: estrae monopolo, dipolo, QUADRUPOLO
#   5. Misura ampiezza e ASSI del quadrupolo (i nostri: tri-assiale, cieco al verso)
#   6. TEST DI SIGNIFICATIVITA' per permutazioni: mescola le posizioni e vede se
#      il quadrupolo trovato e' piu' forte del caso (regola 7: verifica vera, non
#      un verdetto auto-generato)
#   7. Controlla la NON-CORRELAZIONE col dipolo cinematico CMB (se il nostro asse
#      coincide col dipolo CMB -> non e' nostro, e' moto)
#
#  Come si LEGGE il risultato (regola: numeri > verdetto):
#   - p-value del quadrupolo: se < ~0.05, c'e' un quadrupolo significativo.
#   - ampiezza: confronta con la nostra predizione ~1-3%.
#   - asse: NON deve coincidere col dipolo CMB (l,b ~ 264,48).
#   - profilo in z (bonus): se rifai con z>0.05 e z>0.25 e il quadrupolo PERSISTE
#     o cresce relativamente, e' la nostra firma cosmologica; se svanisce, e' locale.
# =============================================================================

import numpy as np
import urllib.request
import sys

# -----------------------------------------------------------------------------
# PASSO 1 - scarico il catalogo Pantheon+ (pubblico, GitHub)
# -----------------------------------------------------------------------------
URL = ("https://raw.githubusercontent.com/PantheonPlusSH0ES/DataRelease/"
       "main/Pantheon%2B_Data/4_DISTANCES_AND_COVAR/Pantheon%2BSH0ES.dat")
FNAME = "PantheonPlusSH0ES.dat"

def scarica():
    try:
        print("Scarico il catalogo Pantheon+ ...")
        urllib.request.urlretrieve(URL, FNAME)
        print("  OK, salvato in", FNAME)
    except Exception as e:
        print("  Download fallito:", e)
        print("  ALTERNATIVA: scarica il file a mano da questo URL e mettilo")
        print("  nella stessa cartella di questo script, col nome", FNAME, ":")
        print("  ", URL.replace("%2B", "+"))
        sys.exit(1)

import os
if not os.path.exists(FNAME):
    scarica()
else:
    print("Uso il file gia' presente:", FNAME)

# -----------------------------------------------------------------------------
# PASSO 2 - leggo i dati. Colonne che ci servono (dal README ufficiale):
#   CID, IDSURVEY, zHD (redshift Hubble-diagram), RA, DEC, MU_SH0ES, MU_SH0ES_ERR_DIAG
# Nota: il file e' a colonne con header sulla prima riga.
# -----------------------------------------------------------------------------
print("\nLeggo i dati ...")
# leggo l'header per trovare gli indici delle colonne (robusto a riordini)
with open(FNAME) as f:
    header = f.readline().split()
col = {name: i for i, name in enumerate(header)}
# nomi attesi (alcuni cataloghi usano RA/DEC, altri minuscolo): provo varianti
def find(*names):
    for n in names:
        if n in col: return col[n]
    raise KeyError(f"Nessuna di queste colonne trovata: {names}. Header: {header}")

i_z   = find("zHD", "zCMB")
i_ra  = find("RA", "ra")
i_dec = find("DEC", "DECL", "dec")
i_mu  = find("MU_SH0ES", "MU")
i_err = find("MU_SH0ES_ERR_DIAG", "MUERR", "MU_SH0ES_ERR")
i_cal = col.get("IS_CALIBRATOR", None)  # per escludere i calibratori Cepheidi

data = np.genfromtxt(FNAME, skip_header=1, usecols=(i_z, i_ra, i_dec, i_mu, i_err,
                     i_cal if i_cal is not None else i_z))
z   = data[:,0]
ra  = data[:,1]   # gradi
dec = data[:,2]   # gradi
mu  = data[:,3]
err = data[:,4]
cal = data[:,5] if i_cal is not None else np.zeros_like(z)

print(f"  {len(z)} righe lette.")

# -----------------------------------------------------------------------------
# PASSO 3 - taglio: z > 0.15 (scala cosmologica, via dalle correzioni PV),
#           escludo i calibratori Cepheidi (sono a z bassissimo, servono ad altro)
# -----------------------------------------------------------------------------
ZMIN = 0.15          # <-- la soglia chiave. Cambiala (0.05, 0.25) per il test di profilo.
ZMAX = 0.8           # sopra, le SNe sono poche e rumorose; teniamo la zona ricca
mask = (z > ZMIN) & (z < ZMAX) & (cal < 0.5) & np.isfinite(mu) & (err > 0)
z, ra, dec, mu, err = z[mask], ra[mask], dec[mask], mu[mask], err[mask]
print(f"\nDopo il taglio {ZMIN}<z<{ZMAX} (no calibratori): {len(z)} SNe.")
if len(z) < 50:
    print("  Poche SNe: i risultati saranno rumorosi. (Normale per z alto.)")

# -----------------------------------------------------------------------------
# PASSO 4 - residui di Hubble: mu_osservato - mu_LCDM(z)
#   mu_LCDM = 5 log10(d_L/10pc). Uso LCDM piatto Om=0.3. H0 si assorbe in un
#   offset costante (monopolo), che NON ci interessa: a noi serve la parte
#   ANGOLARE (quadrupolo), insensibile all'offset globale.
# -----------------------------------------------------------------------------
c_km = 299792.458
Om   = 0.3
def mu_lcdm(z, H0=70.0):
    zz = np.atleast_1d(z)
    out = np.empty_like(zz)
    for k, zi in enumerate(zz):
        zg = np.linspace(0, zi, 200)
        E  = np.sqrt(Om*(1+zg)**3 + (1-Om))
        dC = c_km/H0 * np.trapezoid(1/E, zg)   # Mpc, comovente
        dL = (1+zi)*dC
        out[k] = 5*np.log10(dL*1e5)            # dL in Mpc -> /10pc = *1e5
    return out

resid = mu - mu_lcdm(z)
# tolgo il monopolo (offset globale: dipende da H0/M, non ci interessa)
resid = resid - np.average(resid, weights=1/err**2)
print(f"  Residui calcolati. RMS = {np.std(resid):.3f} mag.")

# -----------------------------------------------------------------------------
# PASSO 5 - espansione multipolare sul cielo.
#   Converto (RA,DEC) in versori n. Poi fitto i residui con:
#     resid ~ monopolo + dipolo.n + quadrupolo:(n n)
#   Un residuo in mu si traduce in una variazione di H: dmu = -5/ln10 * dH/H.
#   Quindi un quadrupolo nei residui = quadrupolo in H0 (con segno/fattore noto).
# -----------------------------------------------------------------------------
def versori(ra_deg, dec_deg):
    ra_r  = np.radians(ra_deg); dec_r = np.radians(dec_deg)
    x = np.cos(dec_r)*np.cos(ra_r)
    y = np.cos(dec_r)*np.sin(ra_r)
    z_ = np.sin(dec_r)
    return np.vstack([x,y,z_]).T   # (N,3)

n = versori(ra, dec)

# base delle funzioni: 1 (mono), 3 dipolo (nx,ny,nz), 5 quadrupolo (componenti
# simmetriche a traccia nulla). Costruisco la matrice di disegno A.
def design(n):
    N = len(n); nx,ny,nz = n[:,0],n[:,1],n[:,2]
    cols = [np.ones(N),                      # monopolo
            nx, ny, nz,                      # dipolo
            nx*nx - nz*nz, ny*ny - nz*nz,    # quadrupolo (2 diag indip, traccia nulla)
            nx*ny, nx*nz, ny*nz]             # quadrupolo (off-diagonali)
    return np.vstack(cols).T

A = design(n)
W = 1/err**2
# fit pesato ai minimi quadrati: (A^T W A) p = A^T W resid
ATA = A.T @ (W[:,None]*A)
ATy = A.T @ (W*resid)
p   = np.linalg.solve(ATA, ATy)
# p = [mono, d1,d2,d3, q1,q2,q3,q4,q5]
dip  = p[1:4]
quad_params = p[4:9]
# ricostruisco il tensore quadrupolare 3x3 simmetrico a traccia nulla
q1,q2,q3,q4,q5 = quad_params
Q = np.array([[q1,        q3,       q4],
              [q3,        q2,       q5],
              [q4,        q5, -(q1+q2)]])
eigval, eigvec = np.linalg.eigh(Q)
# ampiezza del quadrupolo in mag, poi convertita in dH/H
amp_mag = np.max(np.abs(eigval))
amp_H = amp_mag * np.log(10)/5     # dmu = -5/ln10 dH/H  -> dH/H = ln10/5 * dmu
print("\n--- QUADRUPOLO TROVATO ---")
print(f"  ampiezza (autovalore max) = {amp_mag:.4f} mag  ->  dH/H ~ {amp_H*100:.2f}%")
print(f"  autovalori del quadrupolo (mag): {eigval}")
print(f"  -> tri-assiale se i tre sono distinti; assisimmetrico se due uguali.")

# asse principale del quadrupolo (autovettore dell'autovalore di modulo max)
ax = eigvec[:, np.argmax(np.abs(eigval))]
# converto in coordinate galattiche/equatoriali (l,b) per confronto col dipolo CMB
b_ax = np.degrees(np.arcsin(ax[2]))
l_ax = np.degrees(np.arctan2(ax[1], ax[0])) % 360
print(f"  asse principale del quadrupolo: (RA,DEC) ~ ({l_ax:.0f}, {b_ax:.0f}) deg")

# -----------------------------------------------------------------------------
# PASSO 6 - TEST DI SIGNIFICATIVITA' per permutazioni (regola 7).
#   Mescolo le posizioni sul cielo tenendo fissi i residui: distruggo ogni
#   correlazione angolare reale. Se il quadrupolo vero e' piu' forte del 95%
#   dei mescolamenti casuali -> e' significativo (p < 0.05).
# -----------------------------------------------------------------------------
print("\n--- TEST DI SIGNIFICATIVITA' (permutazioni) ---")
def quad_strength(resid_, n_, W_):
    A_ = design(n_)
    ATA_ = A_.T @ (W_[:,None]*A_); ATy_ = A_.T @ (W_*resid_)
    p_ = np.linalg.solve(ATA_, ATy_)
    Qp = p_[4:9]
    return np.sum(Qp**2)   # potenza nel quadrupolo

obs = quad_strength(resid, n, W)
NPERM = 2000
rng = np.random.default_rng(42)
null = np.empty(NPERM)
for i in range(NPERM):
    idx = rng.permutation(len(resid))
    null[i] = quad_strength(resid, n[idx], W)   # mescolo le posizioni
pval = np.mean(null >= obs)
print(f"  potenza quadrupolo osservata = {obs:.3e}")
print(f"  p-value = {pval:.4f}")
print(f"  -> {'SIGNIFICATIVO (p<0.05)' if pval<0.05 else 'NON significativo (compatibile col caso)'}")

# -----------------------------------------------------------------------------
# PASSO 7 - controllo: l'asse coincide col dipolo cinematico CMB?
#   Dipolo CMB ~ (l,b)=(264,48) galattico ~ (RA,DEC)~(168,-7). Se il nostro
#   asse coincide -> e' moto, NON nostro. Se e' diverso -> coerente con noi.
# -----------------------------------------------------------------------------
cmb_dipole_radec = np.array([167.9, -6.9])  # approssimato in equatoriali
ax_radec = np.array([l_ax, b_ax])
def angsep(a,b):
    ra1,de1,ra2,de2 = map(np.radians,[a[0],a[1],b[0],b[1]])
    return np.degrees(np.arccos(np.sin(de1)*np.sin(de2)+np.cos(de1)*np.cos(de2)*np.cos(ra1-ra2)))
sep = angsep(ax_radec, cmb_dipole_radec)
# per un quadrupolo conta l'asse mod 90 gradi (e' un asse, non una freccia)
sep = min(sep, 180-sep)
print("\n--- CONTROLLO ASSE vs DIPOLO CMB ---")
print(f"  separazione asse-quadrupolo da dipolo CMB: {sep:.0f} deg")
print(f"  -> {'VICINO al dipolo (sospetto: potrebbe essere moto)' if sep<25 else 'LONTANO dal dipolo (coerente con firma nostra, non cinematica)'}")

# -----------------------------------------------------------------------------
# COME PROCEDERE (test del PROFILO IN Z, la nostra firma piu' forte):
#   Rilancia lo script cambiando ZMIN in cima: prova 0.05, 0.15, 0.25.
#   - se il quadrupolo SVANISCE alzando ZMIN -> era locale (NON nostro).
#   - se PERSISTE o resta stabile a z alto -> firma cosmologica (NOSTRA).
#   Annota ampiezza e p-value per ogni ZMIN e portali alla prossima sessione.
# -----------------------------------------------------------------------------
print("\n" + "="*60)
print("FATTO. Per il test del profilo in z: cambia ZMIN (0.05/0.15/0.25)")
print("in cima allo script e rilancia. Annota ampiezza e p-value per ognuno.")
print("="*60)
