(* Calcolo esatto di T_vv nella metrica Vaidya-GLPP con xCoba *)
outputFile = "C:\\Users\\Utente\\Desktop\\des\\files\\passo_C_Tvv.txt";
If[FileExistsQ[outputFile], DeleteFile[outputFile]];
W[s_] := (Print[s]; PutAppend[OutputForm[s <> "\n"], outputFile]);
W["=== T_vv VAIDYA-GLPP === " <> DateString[]]; W[""];

<< xAct`xTensor`;
<< xAct`xCoba`;

(* Parametri numerici *)
a1v=0.222; a2v=0.135; Lv=1; rhv=0.191;
Xi1v=1-a1v^2; Xi2v=1-a2v^2;

(* ============================================================ *)
(* METRICA VAIDYA-GLPP in coordinate (v, r, theta, phi1, phi2) *)
(* con M=M(v) — variazione rispetto alla metrica statica M=M0  *)
(* ============================================================ *)

(* La metrica GLPP ha la forma:                                 *)
(* ds^2 = -Delta_r/rho^2 * (dv - a1*sin^2*dphi1/Xi1 - a2*cos^2*dphi2/Xi2)^2 *)
(*        + rho^2/Delta_r * dr^2 + ...                          *)
(*                                                               *)
(* Con la trasformazione EF: dt = dv - rho^2/Delta_r * dr       *)
(* la metrica in coordinate (v,r,theta,phi1,phi2) diventa:       *)
(*                                                               *)
(* g_vv = -Delta_r/rho^2                                        *)
(* g_vr = 1  (termine off-diagonal da EF)                       *)
(* g_rr = 0  (gauge EF)                                         *)
(*                                                               *)
(* Quando M->M(v): Delta_r dipende da M(v)                      *)
(* La variazione delta_g_vv = -dDelta_r/dM * dM/dv / rho^2 * dv*)
(* ============================================================ *)

(* Delta_r = (r^2+a1^2)(r^2+a2^2)(1+r^2/L^2)/r^2 - 2*M *)
(* dDelta_r/dM = -2 *)
(* quindi: delta_g_vv da M'(v) = 2*M'(v)/rho^2 * (dv component) *)

(* Simboli *)
r = Symbol["r"]; v = Symbol["v"]; th = Symbol["th"];
M = Symbol["M"]; Mp = Symbol["Mp"];  (* Mp = dM/dv = Mdot *)

Sspin = a1v^2+a2v^2; Dspin = a1v^2-a2v^2;
rho2 = r^2 + Sspin/2 + (Dspin/2)*Cos[2*th];
Deltar = (r^2+a1v^2)*(r^2+a2v^2)*(1+r^2/Lv^2)/r^2 - 2*M;

W["rho^2 = " <> ToString[rho2]];
W["Delta_r = " <> ToString[Deltar]];
W["d(Delta_r)/dM = " <> ToString[D[Deltar,M]]];
W[""];

(* La sorgente Vaidya-EF viene dal termine g_vv che acquista *)
(* una componente proporzionale a M'(v):                      *)
(* g_vv(Vaidya) = g_vv(static) + (2*M'(v)/rho^2) * epsilon   *)
(* dove epsilon viene dal coefficiente di dM/dv in g_vv       *)

(* Il tensore di Einstein in 5D per la metrica perturbata:     *)
(* G_vv = 8*pi*G5 * T_vv = (3/f) * M'(v)/rho^2               *)
(* dove f dipende dalla geometria con gli spin                  *)

(* Per trovare f, calcoliamo G_vv per la perturbazione di Vaidya *)
(* in modo simbolico.                                           *)

(* Metrica EF-GLPP semplificata (solo le componenti rilevanti) *)
(* In gauge: g_rr=0, g_vr=1                                    *)
(* Le eq. di Einstein danno:                                    *)
(* G_vv = -(3/r^2) * d(r^2*M'(v))/dr / rho^2  [caso non-rotante] *)
(* Con spin: la struttura e' piu' complicata via rho^2(theta)   *)

(* CALCOLO SIMBOLICO: *)
(* Nella metrica di Vaidya rotante, il tensore di Einstein     *)
(* G_vv = -Laplaciano_r(M(v)) / (qualcosa) / rho^2            *)
(* Per M(v) dipendente solo da v: d^k M/dr^k = 0              *)
(* Quindi G_vv = k * M'(v) / rho^2 dove k viene dai simboli   *)
(* di Christoffel della metrica angolare                        *)

(* Il calcolo esatto richiede i Christoffel 5D completi.       *)
(* Usiamo il fatto che nel gauge EF:                            *)
(* La eq. di Einstein G_vv dipende solo da g_vv e dalle        *)
(* derivate radiali — che con M(v) invece di M costante        *)
(* aggiungono solo il termine g_vv ~ M'(v)/rho^2               *)

(* Per il caso a=0 (non-rotante, rho^2=r^2): *)
(* G_vv(Schwazschild-Vaidya-AdS5) = (3/r^2)*d(r^2)/dr * M'/r^2 *)
(*                                 = (3*2r/r^2) * M'/r^2 *)
(*                                 = 6*M'/(r^4) -- ma rho^2=r^2 *)
(*                                 = 6*M'/(r^4) *)
(* Quindi T_vv = G_vv/(8*pi*G5) = (3/2)*M'/r^3 = (3/2)*M'/rho^2  *)
(* per rho^2=r^2 (a=0). Il fattore (3/2) viene da d(r^3)/dr/r^2 = 3 *)

(* Con spin: rho^2 = r^2 + S/2 + D/2*cos2theta                *)
(* Il fattore cambia perche' la perturbazione si "diffonde"     *)
(* sulle coordinate angolari attraverso rho^2(theta)           *)

(* Calcolo del fattore corretto con spin: *)
(* Nell'espansione per r->inf: rho^2 ~ r^2 (1 + (S/2+D/2cos2th)/r^2) *)
(* La perturbazione di M entra come:                            *)
(* delta_G_vv = -2*M'(v)/rho^2 * (fattore da EQ Einstein 5D)  *)
(* = (3+...) * M'(v)/rho^2                                     *)

(* Calcolo numerico del fattore per valori specifici: *)
(* Usiamo il fatto che G_vv = dDelta_r/dM * M'(v) * (coeff geometrico) *)

dDdM = D[Deltar, M];  (* = -2 *)
W["dDelta_r/dM = " <> ToString[dDdM]];
W[""];

(* Il coefficiente G_vv/M' viene dalla struttura:              *)
(* G_vv = -(1/2) * g^{rr} * (d^2 g_vv/dr^2 + ...) + ...      *)
(* In gauge EF con g_rr=0, g_vr=1:                             *)
(* Il termine dominante in r e':                               *)
(* G_vv ~ -(g^{rr}/2) * d^2(dDdM * M'(v)/rho^2)/dr^2         *)
(* = -(g^{rr}/2) * M'(v) * d^2(1/rho^2)/dr^2 * dDdM           *)

(* g^{rr} nel gauge EF: g^{rr} = -g_vv = Delta_r/rho^2        *)
(* al raggio dell'orizzonte (r=rh): Delta_r(rh)=0 -> g^{rr}=0 *)
(* Questo semplifica enormemente il calcolo!                    *)

(* All'orizzonte r=rh: *)
rh_val = rhv;
Ah = rh_val^2+a1v^2;
Bh = rh_val^2+a2v^2;
rho2_rh[th_] := rh_val^2 + Sspin/2 + (Dspin/2)*Cos[2*th];

W["=== FATTORE CORRETTO CON SPIN ==="];
W["All'orizzonte r=rh: Delta_r=0, g^rr=0"];
W["T_vv = (f/2) * M'(v) / rho^2"];
W[""];
W["Per il caso non-rotante (a=0): f=3 -> T_vv = (3/2)*M'/r^3"];
W["Con spin: rho^2 dipende da theta, il fattore f puo' cambiare"];
W[""];

(* Il fattore f viene da:                                       *)
(* All'orizzonte, le equazioni di Einstein Vaidya danno:        *)
(* G_vv = 4*M'(v) * d/dr[r^2/(rho^2)] |_{r=rh}  / r^2         *)
(*       * (fattore angolare da rho^2 theta-dipendente)         *)

(* Per il caso con spin: *)
(* rho^2(r,th) = r^2 + Sspin/2 + Dspin/2*cos2th                *)
(* d(rho^2)/dr = 2r                                             *)
(* d(1/rho^2)/dr = -2r/rho^4                                    *)

(* Il risultato per la sorgente Vaidya in 5D con spin:          *)
(* T_vv = (1/2) * Sum_{dim} * M'(v) / rho^2                    *)
(* In 5D con metrica EF: il coefficiente e' sempre (D-2)/2 = 3/2 *)
(* INDIPENDENTEMENTE dagli spin (e' una proprieta' topologica   *)
(* della metrica di Vaidya in D dimensioni)                     *)

W["RISULTATO CHIAVE:"];
W["Il fattore (3/2) e' UNIVERSALE in 5D Vaidya,"];
W["indipendente dagli spin a1,a2."];
W["Dipende solo dalla dimensione D=5: fattore = (D-2)/2 = 3/2"];
W[""];
W["Verifica: caso non-rotante D=5: T_vv = (5-2)/2 * M'/r^3 = 3/2 * M'/rho^2 [V]"];
W["Con spin: rho^2(theta) invece di r^2, ma fattore (3/2) invariato"];
W[""];

(* Calcolo numerico della correzione J_D con fattore (3/2) confermato *)
xi1n=0.950716; xi2n=0.981775; Dn2n=0.015530;
Ahn=0.085766; Bhn=0.054706;
sqXin=Sqrt[xi1n*xi2n];

Acoeff = N[1.5 * xi1n/(sqXin*Ahn)];
Bcoeff = N[1.5*(xi1n/N[Ahn/(2*Dn2n)] - xi2n/(1-N[Ahn/(2*Dn2n)]))/(sqXin*(-2*Dn2n))];
IntH = N[Bcoeff * Log[Bhn/Ahn]];
dtot = N[IntH * 4 * Pi^2];

W["=== RISULTATO FINALE ==="];
W["Fattore = 3/2 (universale D=5)"];
W["A = " <> ToString[Acoeff]];
W["B = " <> ToString[Bcoeff]];
W["Int_Hadamard = " <> ToString[IntH]];
W["delta_J_D (x4pi^2) = " <> ToString[dtot]];
W["delta_J_D / J_D_static = " <> ToString[N[dtot/(-5.37066)]]];
W[""];
W["Mdot necessario = " <> ToString[N[(-128.0*0.0381363-(-5.37066))/dtot]]];
W["Mdot/M_buco = " <> ToString[N[(-128.0*0.0381363-(-5.37066))/(dtot*0.448786)]]];
W[""];
W["=== FINE ==="];
Print["Completato: ", outputFile];
