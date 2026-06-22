#!/usr/bin/env python3
"""
CLASSE DI BULK AMMESSI + BLINDATURA + FEEDBACK
================================================
Tre conti di queste sessioni, eseguibili e conservati:
1) finestra 1<p<7/3 per accrescimento da riserva finita
2) blindatura: la finestra dipende dall'asintotico senza scala, non dalla
   potenza pura (test taglio morbido vs esponenziale)
3) nodo feedback S<->H (letale vs innocuo) + argomento di plausibilita'
"""
import numpy as np
from scipy.integrate import odeint

Om = 0.31
ag = np.linspace(0.02, 1.0, 4000); lna = np.log(ag)
def t_of_a(a): return a**1.5

def w0_for(Sfunc, target=0.69, feedback=None):
    def integr(A):
        def f(r, a):
            r = max(r, 1e-300); H = np.sqrt(Om/a**3 + r)
            S = Sfunc(a)
            if feedback is not None: S = S * feedback(H)
            return -3*r/a + A*S/(a*H)
        return odeint(f, 1e-12, ag, mxstep=20000)[:, 0]
    lo, hi = 1e-8, 1e8
    for _ in range(70):
        mid = np.sqrt(lo*hi)
        if integr(mid)[-1] > target: hi = mid
        else: lo = mid
    r = integr(np.sqrt(lo*hi))
    w = -1 - np.gradient(np.log(np.clip(r,1e-300,None)),lna)/3
    OmDE = r[-1]/(Om/ag[-1]**3 + r[-1])
    return w[-1], (1+3*OmDE*w[-1])<0

def finestra():
    print("="*64)
    print("1) FINESTRA della classe di bulk (riserva finita + accelera oggi)")
    print("="*64)
    print("""
Bulk = accrescimento da riserva finita, coda a potenza S(t)~t^-p.
 - riserva finita (int S dt converge):  p > 1
 - accelera oggi (n=-3p/2 > -7/2):       p < 7/3
 => FINESTRA  1 < p < 7/3 (~2.33). Fallback reali dentro:
    TDE p=5/3, viscoso p=4/3, raffreddamento p=9/4 (bordo). Bondi/exp fuori.
""")

def blindatura():
    print("="*64)
    print("2) BLINDATURA: asintotico senza scala, non potenza pura")
    print("="*64)
    tau_a = 0.3**1.5
    print(f"{'forma':<34}{'p':>5}{'w0':>8}{'accel?':>9}")
    for p in [4/3,5/3,2.0]:
        w0,ac=w0_for(lambda a,p=p: t_of_a(a)**(-p))
        print(f"{'potenza pura':<34}{p:>5.2f}{w0:>8.2f}{('SI' if ac else 'no'):>9}")
    for p in [4/3,5/3,2.0]:
        w0,ac=w0_for(lambda a,p=p,tau=tau_a: 1.0/(1+t_of_a(a)/tau)**p)
        print(f"{'(1+t/tau)^-p morbido':<34}{p:>5.2f}{w0:>8.2f}{('SI' if ac else 'no'):>9}")
    for p in [4/3,5/3,2.0]:
        w0,ac=w0_for(lambda a,p=p,tau=tau_a: t_of_a(a)**(-p)*np.exp(-t_of_a(a)/tau))
        print(f"{'t^-p exp(-t/tau)':<34}{p:>5.2f}{w0:>8.2f}{('SI' if ac else 'no'):>9}")
    print("""
=> morbido come potenza pura (asintotico = potenza); esponenziale fuori
   (scala tau uccide la coda). La condizione e' l'ASINTOTICO SENZA SCALA.
""")

def feedback():
    print("="*64)
    print("3) NODO FEEDBACK S<->H (letale vs innocuo)")
    print("="*64)
    base = lambda a: t_of_a(a)**(-5/3)
    H0 = np.sqrt(Om+0.69)
    for nome,fb in [("nessuno",None),("S~H",lambda H:H/H0),
                    ("S~1/H",lambda H:H0/H),("S~H^2",lambda H:(H/H0)**2)]:
        w0,ac=w0_for(base,feedback=fb)
        print(f"  {nome:<10}{w0:>8.2f}{('  SI' if ac else '  no')}")
    print("""
=> S~H, S~H^2 rompono (no accel). S~1/H ok. Feedback FORTE letale.
PLAUSIBILITA': la coda di fallback e' materiale LEGATO al buco, DISACCOPPIATO
dall'espansione (come oggetti legati non seguono Hubble). t_acc/t_H << 1 per
quasi tutta la storia => feedback DEBOLE/innocuo. Letale solo se accrescimento
controllato dall'espansione globale (non previsto dalla fisica del fallback).
Argomento di plausibilita', non dimostrazione. Nodo aperto da blindare.
""")

if __name__=="__main__":
    finestra(); blindatura(); feedback()
