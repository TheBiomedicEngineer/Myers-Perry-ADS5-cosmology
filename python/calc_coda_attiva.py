#!/usr/bin/env python3
"""
CRITERIO DELLA CODA ATTIVA  -  modello cosmologico a flusso attivo
====================================================================
Conto analitico + numerico, INDIPENDENTE dal nodo del bulk.

Domanda: quale decadimento della sorgente S(a) separa le sorgenti che
fanno accelerare l'universo OGGI da quelle che no? E quel confine e' in
tensione col vincolo "non disturbare CMB/BBN"?

Equazione del modello (dark energy = flusso attivo):
    d(rho_DE)/dt + 3 H rho_DE = S(a)

Riferimenti letteratura (early dark energy):
  Hollenstein et al. arXiv:2001.10252  (Omega_eDE < 0.4% al last scattering)
  Sola et al.        arXiv:2107.11065
  Pettorino et al.   arXiv:1301.5279
"""
import numpy as np
import sympy as sp

def parte_analitica():
    """Soluzione esatta in regime materia, sorgente a potenza S ~ a^n."""
    print("="*64)
    print("PARTE ANALITICA  (sympy, soluzione esatta in regime materia)")
    print("="*64)
    a, n, k = sp.symbols('a n k', positive=True)
    rho = sp.Function('rho')
    # In regime materia H = H0 sqrt(Om) a^-3/2; passando a variabile a
    # (d/dt = aH d/da) l'equazione diventa lineare del prim'ordine:
    #   rho'(a) + (3/a) rho = k a^(n+1/2)     [k = S0/(H0 sqrt(Om))]
    ode = sp.Eq(rho(a).diff(a) + 3/a*rho(a), k*a**(n + sp.Rational(1, 2)))
    sol = sp.dsolve(ode, rho(a))
    print("Soluzione generale rho_DE(a):")
    sp.pprint(sol)
    print("""
Lettura:
  - termine OMOGENEO  ~ C * a^-3        (memoria iniziale, si diluisce come materia)
  - termine PARTICOLARE ~ a^(n+3/2)     (sostenuto dalla sorgente attiva)

La densita' DE sostenuta scala come rho ~ a^s con  s = n + 3/2.
Per una componente rho ~ a^s :  w_eff = -1 - s/3.
""")

def confine_e_tabella():
    """Il confine n=-7/2 e la frazione di DE nel passato."""
    print("="*64)
    print("CONFINE E TABELLA")
    print("="*64)
    print(f"{'sorgente S~a^n':<22}{'s=n+3/2':>9}{'w_eff':>8}   comportamento")
    print("-"*64)
    casi = [(-1.5,"n=-3/2 (lentissima)"), (-5/3,"n=-5/3"), (-2.5,"n=-5/2 FALLBACK"),
            (-3,"n=-3"), (-3.5,"n=-7/2 CONFINE"), (-4.5,"n=-9/2"), (-6,"n=-6 (ripida)")]
    for nval, lab in casi:
        s = nval + 1.5
        w = -1 - s/3
        beh = "ACCELERA (w<-1/3)" if w < -1/3 else "NO (come materia)"
        print(f"{lab:<22}{s:>+9.2f}{w:>+8.2f}   {beh}")
    print("""
CONFINE: accelera oggi  <=>  w_eff < -1/3  <=>  s < -2  <=>  n > -7/2.
  - code piu' LENTE di a^-3.5 (n>-7/2): accelerano oggi.
  - code piu' RIPIDE (n<-7/2): no.
""")

def fallback_e_passato():
    """Conversione fallback t^-5/3 -> a, e frazione DE al last scattering."""
    print("="*64)
    print("FALLBACK e VINCOLO DEL PASSATO (CMB/BBN)")
    print("="*64)
    print("""
ATTENZIONE (errore facile): il fallback classico e' t^-5/3 in TEMPO.
In regime materia t ~ a^(3/2), quindi:
   t^-5/3  ->  a^(3/2 * -5/3) = a^-5/2.
Quindi la sorgente di fallback in funzione di a e'  S ~ a^-5/2  (n=-5/2),
NON a^-5/3.  -5/2 > -7/2  =>  sta nella classe che accelera, con margine.
""")
    # Frazione di DE nel passato: rho_DE/rho_m ~ a^(s+3) = a^(n+9/2)
    # I due vincoli (accelera oggi / non rompe il passato) NON sono in tensione:
    # se n>-7/2 allora n>-9/2, quindi la frazione DE -> 0 nel passato.
    Om_DE, Om_m = 0.69, 0.31
    a_ls = 1/1101.0  # last scattering, z~1100
    print(f"Frazione di DE al last scattering (z=1100), bound osservativo ~0.4%:")
    print(f"{'n':<10}{'frazione DE a z=1100':>24}   stato")
    for n in [-1.5, -2.0, -2.5, -3.0, -3.5]:
        ratio = (Om_DE/Om_m) * a_ls**(n + 4.5)
        frac = ratio/(1+ratio)
        flag = "OK (<0.4%)" if frac < 0.004 else "VIOLA"
        print(f"n={n:<8}{frac*100:>22.2e}%   {flag}")
    print("""
RISULTATO NON-OVVIO: i due vincoli non sono in tensione. La stessa
condizione (coda piu' lenta di a^-7/2 per accelerare) implica n>-9/2,
e quindi la frazione DE svanisce nel passato come a^(n+9/2). Una sola
condizione le garantisce entrambe. Il fallback (n=-5/2) sta dentro con
margine: a z=1100 la DE pesa ~2e-4 %, ben sotto il bound 0.4%.
""")

def verifica_numerica():
    """Integra l'ODE completa (non solo regime materia) per qualche n."""
    from scipy.integrate import odeint
    print("="*64)
    print("VERIFICA NUMERICA (ODE completa, H da materia+DE autoconsistente)")
    print("="*64)
    Om = 0.31
    ag = np.linspace(0.02, 1.0, 4000); lna = np.log(ag)
    def w0_di(nval, ap=0.4, target=0.69):
        # sorgente con coda a^nval: S = (a/ap)^q / (1+(a/ap)^(q-nval)), coda -> a^nval
        q = 1.5
        Sf = lambda a: (a/ap)**q / (1 + (a/ap)**(q-nval))
        def integr(A):
            def f(r, a):
                r = max(r, 1e-300); H = np.sqrt(Om/a**3 + r)
                return -3*r/a + A*Sf(a)/(a*H)
            return odeint(f, 1e-10, ag, mxstep=20000)[:, 0]
        lo, hi = 1e-6, 1e6
        for _ in range(60):
            mid = np.sqrt(lo*hi)
            if integr(mid)[-1] > target: hi = mid
            else: lo = mid
        r = integr(np.sqrt(lo*hi))
        w = -1 - np.gradient(np.log(np.clip(r,1e-300,None)), lna)/3
        OmDE = r[-1]/(Om/ag[-1]**3 + r[-1])
        return w[-1], OmDE, (1+3*OmDE*w[-1]) < 0
    print(f"{'coda n':<10}{'w0':>8}{'OmDE':>8}{'accel?':>9}")
    for n in [-1.5, -2.5, -3.5, -5.0]:
        w0, OmDE, acc = w0_di(n)
        print(f"n={n:<8}{w0:>8.2f}{OmDE:>8.2f}{('SI' if acc else 'NO'):>9}")
    print("""
Nota: il w0 numerico dipende dalla forma esatta della sorgente usata
(qui una forma giocattolo con coda a^n). Il fit completo a due assi del
documento principale dava w0~-0.84 per il fallback; qui con la forma
giocattolo n=-2.5 esce ~-0.67. NON e' incoerenza: sono parametrizzazioni
diverse. Cio' che conta e robusto e' il CONFINE (n=-7/2): n=-1.5,-2.5
accelerano, n=-3.5,-5.0 no, esattamente come predetto dall'analitico.
L'analitico da' la CLASSE, il numerico il VALORE (che dipende dalla forma).
""")

if __name__ == "__main__":
    parte_analitica()
    confine_e_tabella()
    fallback_e_passato()
    verifica_numerica()
