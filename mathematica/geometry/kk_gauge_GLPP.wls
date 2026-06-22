#!/usr/bin/env wolframscript
(* ============================================================
   Estrazione ESATTA dei campi di gauge Kaluza-Klein dalla
   metrica Myers-Perry-AdS5 a due spin (GLPP, hep-th/0404008).
   Verifica del ponte interi->cariche: A^i_t(r_h) = Omega_i.
   Ambiente di Matte: Wolfram Engine. Gold standard (r.5).
   ============================================================ *)

(* --- file di output (stessa directory degli altri script) --- *)
outFile = "C:\\Users\\Utente\\Desktop\\des\\files\\kk_gauge_GLPP_risultati.txt";
stream = OpenWrite[outFile];
emit[args__] := (Print[args]; WriteString[stream, StringJoin[ToString /@ {args}], "\n"]);

(* --- coordinate e parametri --- *)
(* coords: t, r, th(eta), ph(i), ps(i). fibra KK = {ph, ps} (le due fasi). *)
(* parametri: a,b = due spin; m = massa; g = 1/L (curvatura AdS). *)

Xa = 1 - a^2 g^2;
Xb = 1 - b^2 g^2;
rho2 = r^2 + a^2 Cos[th]^2 + b^2 Sin[th]^2;
DeltaTh = 1 - a^2 g^2 Cos[th]^2 - b^2 g^2 Sin[th]^2;

(* --- metrica GLPP in coordinate Boyer-Lindquist (Chen-Lu-Pope) --- *)
(* componenti non nulle (forma standard hep-th/0404008 eq. 4-5) *)
gtt   = -(DeltaTh (1 + g^2 r^2)/(Xa Xb)) + (2 m/rho2);
gtph  = -(2 m a Sin[th]^2)/(rho2 Xa);
gtps  = -(2 m b Cos[th]^2)/(rho2 Xb);
gphph = (r^2 + a^2) Sin[th]^2/Xa + (2 m a^2 Sin[th]^4)/(rho2 Xa^2);
gpsps = (r^2 + b^2) Cos[th]^2/Xb + (2 m b^2 Cos[th]^4)/(rho2 Xb^2);
gphps = (2 m a b Sin[th]^2 Cos[th]^2)/(rho2 Xa Xb);

(* --- riduzione KK: la fibra e' {ph,ps}, la base {t,r,th} --- *)
(* metrica della fibra (2x2) *)
Gfib = {{gphph, gphps}, {gphps, gpsps}};
(* vettori misti base-fibra: solo la componente t e' non banale per il gauge elettrico *)
mixT = {gtph, gtps};

(* campo di gauge KK: A^i_mu = (Gfib^{-1})^{ij} g_{mu j}  *)
GfibInv = Inverse[Gfib];
At = Simplify[GfibInv . mixT];   (* {A^ph_t, A^ps_t} *)

emit["=== A^i_t ESATTO (fuori orizzonte) ==="];
emit["A^phi_t = ", Simplify[At[[1]]]];
emit["A^psi_t = ", Simplify[At[[2]]]];

(* --- valutazione all'orizzonte: r = r_h, con Delta_r(r_h)=0 --- *)
(* Delta_r = (r^2+a^2)(r^2+b^2)(1+g^2 r^2)/r^2 - 2m ; r_h = radice esterna *)
Deltar = (r^2+a^2)(r^2+b^2)(1+g^2 r^2)/r^2 - 2 m;

(* velocita' angolari note (target): Omega_a = a(1+g^2 r_h^2)/(r_h^2+a^2) *)
OmA = a (1 + g^2 rh^2)/(rh^2 + a^2);
OmB = b (1 + g^2 rh^2)/(rh^2 + b^2);

(* sostituisco r->rh e uso la condizione di orizzonte 2m = (rh^2+a^2)(rh^2+b^2)(1+g^2 rh^2)/rh^2 *)
mHor = (rh^2+a^2)(rh^2+b^2)(1+g^2 rh^2)/(2 rh^2);
AtHor = Simplify[ At /. {r->rh, m->mHor} ];

emit["=== A^i_t all'orizzonte (r=r_h, usando Delta_r=0) ==="];
emit["A^phi_t(r_h) = ", Simplify[AtHor[[1]]]];
emit["A^psi_t(r_h) = ", Simplify[AtHor[[2]]]];

(* verifica: A^i_t(r_h) - Omega_i == 0 ? *)
emit["=== CHECK: A^i_t(r_h) == Omega_i ? ==="];
chkA = Simplify[ AtHor[[1]] - OmA ];
chkB = Simplify[ AtHor[[2]] - OmB ];
emit["A^phi_t(r_h) - Omega_a = ", chkA, "   (atteso 0)"];
emit["A^psi_t(r_h) - Omega_b = ", chkB, "   (atteso 0)"];

(* --- la 1-forma di gauge e' chiusa? F = dA, campo di forza --- *)
(* test minimo: il campo NON e' puro gauge (F != 0) -> gauge field genuino *)
Aph = At[[1]]; (* A^ph_t come funzione di (r,th) *)
Fph[mu_] := D[Aph, mu];
emit["=== F^phi non banale (campo genuino, non puro gauge) ==="];
emit["dA^phi_t/dr = ", Simplify[D[Aph, r]], " (se !=0 -> campo di forza reale)"];

emit["=== FINE. Se i due CHECK danno 0, il campo di gauge KK = frame-dragging,"];
emit["    e il suo potenziale all'orizzonte = Omega_i. Ponte criterio (1) chiuso ESATTO. ==="];

Close[stream];
Print["Risultati salvati in: ", outFile];
