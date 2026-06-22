(* ============================================================
   asym_MP_AdS5_due_spin.wls
   Calcolo di asym(r_h) per MP-AdS5 a due spin (a1, a2, L=1)
   
   OBIETTIVO: estendere lo script A.3 (Kerr 4D) al caso MP-AdS5 5D
   a due spin indipendenti. Calcola asym come funzione di r_h per
   verificare se asym varia significativamente durante il BBN
   rispetto al valore attrattore oggi.
   
   FORMULA BASE (Hawking-Hunter-Taylor, hep-th/9907003):
   asym = (N_mat - N_anti)/(N_mat + N_anti)
   con N = 1/(exp((w - m*Omega_H)/T_H) + 1) per materia
       N = 1/(exp((w + m*Omega_H)/T_H) + 1) per antimateria
   dove w = energia, m = massa particella
   
   PER MP-AdS5 a due spin:
   Omega_H^(1) = a1*Xi1/(r_h^2 + a1^2)   con Xi1 = 1 - a1^2/L^2
   Omega_H^(2) = a2*Xi2/(r_h^2 + a2^2)   con Xi2 = 1 - a2^2/L^2
   
   T_H = r_h^2 * Delta'(r_h) / (4*pi*(r_h^2+a1^2)*(r_h^2+a2^2))
   dove Delta(r) = (r^2+a1^2)(r^2+a2^2)(1+r^2)/r^2 - 2M
   e   Delta'(r) = d/dr [Delta(r)]
   
   La scelta dell'accoppiamento per due spin:
   xi = w - m*(Omega_H^(1) - Omega_H^(2))  [asimmetria tra i due piani]
   oppure
   xi = w - m*Omega_H^(1) - m*Omega_H^(2)  [accoppiamento totale]
   
   Da verificare quale dei due corrisponde al meccanismo fisico.
   ============================================================ *)

(* --- OUTPUT FILE (come A.3) --- *)
outFile = "C:\\Users\\Utente\\Desktop\\des\\files\\asym_MP_AdS5_OUT.txt";
out = OpenWrite[outFile];
say[x__] := (Print[x]; WriteString[out, StringJoin[ToString /@ {x}], "\n"]);

(* --- PARAMETRI --- *)
a1val = 0.222;  (* spin attrattore piano 1 *)
a2val = 0.135;  (* spin attrattore piano 2 *)
Lval  = 1;      (* unita' di L *)

(* --- FORMULE ESATTE MP-AdS5 --- *)
Xi1[a1_] := 1 - a1^2/Lval^2;
Xi2[a2_] := 1 - a2^2/Lval^2;

(* Massa dalla condizione di orizzonte Delta(r_h)=0 *)
Mval[rh_, a1_, a2_] := 
  (1/2)*(rh^2+a1^2)*(rh^2+a2^2)*(1+rh^2/Lval^2)/rh^2;

(* Velocita' angolari dell'orizzonte *)
Omega1[rh_, a1_] := a1*Xi1[a1]/(rh^2 + a1^2);
Omega2[rh_, a2_] := a2*Xi2[a2]/(rh^2 + a2^2);

(* Derivata di (r^2+a1^2)(r^2+a2^2)(1+r^2)/r^2 *)
DeltaFunc[r_, a1_, a2_] := 
  (r^2+a1^2)*(r^2+a2^2)*(1+r^2/Lval^2)/r^2 - 2*Mval[r,a1,a2];

(* T_H dalla formula GLPP (derivata di Delta) *)
TH[rh_, a1_, a2_] := Module[{dDelta},
  dDelta = D[(r^2+a1^2)*(r^2+a2^2)*(1+r^2/Lval^2)/r^2, r] /. r->rh;
  rh^2 * dDelta / (4*Pi*(rh^2+a1^2)*(rh^2+a2^2))
];

(* --- ASIMMETRIA --- *)
(* CASO A: accoppiamento alla differenza (chiralita') *)
asymA[rh_, a1_, a2_, mpart_:1] := Module[{oH, tH, nm, na},
  oH = Omega1[rh,a1] - Omega2[rh,a2];
  tH = TH[rh,a1,a2];
  If[tH <= 0, Return["T_H<=0: buco sotto estremalita'"]];
  nm = 1/(Exp[(1 - mpart*oH)/tH] + 1);
  na = 1/(Exp[(1 + mpart*oH)/tH] + 1);
  (nm - na)/(nm + na)
];

(* CASO B: accoppiamento alla somma (entrambe le rotazioni) *)
asymB[rh_, a1_, a2_, mpart_:1] := Module[{oH1, oH2, tH, nm, na},
  oH1 = Omega1[rh,a1];
  oH2 = Omega2[rh,a2];
  tH = TH[rh,a1,a2];
  If[tH <= 0, Return["T_H<=0: buco sotto estremalita'"]];
  nm = 1/(Exp[(1 - mpart*(oH1+oH2))/tH] + 1);
  na = 1/(Exp[(1 + mpart*(oH1+oH2))/tH] + 1);
  (nm - na)/(nm + na)
];

(* --- TABELLA RISULTATI --- *)
say["=== T_H, Omega1, Omega2, asym(A), asym(B) vs r_h ==="];
say["r_h/L | T_H | Omega1 | Omega2 | asym(A) | asym(B) | note"];
say[StringRepeat["-", 80]];

rhvals = {0.001, 0.01, 0.05, 0.1, 0.135, 0.168, 0.173, 0.222, 0.3, 
          0.5, 0.707, 1.0, 1.44};
notes  = {"", "", "", "", "<-a2", "<-estremo", "<-inv FD", "<-a1", "", 
          "", "<-cerniera", "", "<-oggi"};

Do[
  rh  = rhvals[[i]];
  th  = N[TH[rh, a1val, a2val], 6];
  o1  = N[Omega1[rh, a1val], 6];
  o2  = N[Omega2[rh, a2val], 6];
  aA  = If[th > 0, N[asymA[rh, a1val, a2val], 6], "nan"];
  aB  = If[th > 0, N[asymB[rh, a1val, a2val], 6], "nan"];
  nt  = notes[[i]];
  say[rh, " | ", th, " | ", o1, " | ", o2, " | ", aA, " | ", aB, " | ", nt],
  {i, Length[rhvals]}
];

(* --- VERIFICA contro valore audit: asym=0.178 agli attrattori --- *)
say[""];
say["=== VERIFICA: asym agli attrattori (r_h=1.44) ==="];
say["asym(A) a r_h=1.44: ", N[asymA[1.44, a1val, a2val], 6]];
say["asym(B) a r_h=1.44: ", N[asymB[1.44, a1val, a2val], 6]];
say["Valore audit (Kerr 4D): 0.178"];
say[""];

(* --- CERCA r_estremo dove T_H=0 --- *)
say["=== ESTREMALITA': r_h dove T_H=0 ==="];
rEstr = FindRoot[TH[rh, a1val, a2val] == 0, {rh, 0.168}];
say["r_estremo = ", rh /. rEstr];
say[""];

(* --- VARIAZIONE di asym tra r_estremo e oggi --- *)
say["=== VARIAZIONE asym: r_estremo -> oggi ==="];
rE = rh /. rEstr;
aE_A = N[asymA[rE*1.01, a1val, a2val], 6];  (* appena sopra estremo *)
aOggi_A = N[asymA[1.44, a1val, a2val], 6];
say["asym(A) appena sopra estremo: ", aE_A];
say["asym(A) oggi (r_h=1.44):      ", aOggi_A];
say["Variazione:                    ", aOggi_A - aE_A];
say[""];

(* --- CONFRONTO con A.3 (Kerr 4D, un solo spin) --- *)
say["=== CONFRONTO A.3: Kerr 4D (script originale) ==="];
(* Kerr 4D con a=a1=0.222, M=1 *)
aKerr = a1val;
rHKerr = 1 + Sqrt[1 - aKerr^2];  (* M=1 *)
OmKerr = aKerr/(2*1*rHKerr);
kappaKerr = (rHKerr - (1 - Sqrt[1-aKerr^2]))/(2*(rHKerr^2+aKerr^2));
THKerr = kappaKerr/(2*Pi);
nmKerr = 1/(Exp[(1 - OmKerr)/THKerr]+1);
naKerr = 1/(Exp[(1 + OmKerr)/THKerr]+1);
asymKerr = (nmKerr - naKerr)/(nmKerr + naKerr);
say["asym Kerr 4D (a/M=0.222): ", N[asymKerr, 6]];
say["(audit riporta 0.178 per a1=0.222, a2=0.135 combinati)"];

Close[out];
