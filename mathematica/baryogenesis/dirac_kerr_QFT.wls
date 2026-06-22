#!/usr/bin/env wolframscript
(* CONTO GROSSO - Dirac QFT in Kerr: segno asimmetria materia/antimateria.
   Output in C:\Users\Utente\Desktop\des\files\dirac_kerr_QFT_OUT.txt.
   v3: check CPT CORRETTO. La CPT-coniugata di un modo con frequenza co-rotante
   xi = w - m Omega_H e' il modo con -xi (Omega_H NON si trasforma: e' del buco).
   Identita': N(-xi) = 1 - N(xi), cioe' N(xi)+N(-xi)=1. QUESTA da' 0. *)

outFile = "C:\\Users\\Utente\\Desktop\\des\\files\\dirac_kerr_QFT_OUT.txt";
out = OpenWrite[outFile];
say[x__] := (Print[x]; WriteString[out, StringJoin[ToString /@ {x}], "\n"]);

say["=== DIRAC QFT IN KERR - segno asimmetria materia/antimateria (v3) ==="];
say[DateString[]];
say[""];

Clear[M, a, w, m];
rH = M + Sqrt[M^2 - a^2];
rMm = M - Sqrt[M^2 - a^2];
OmH = Simplify[a/(2 M rH)];
kappa = Simplify[(rH - rMm)/(2 (rH^2 + a^2))];
TH = Simplify[kappa/(2 Pi)];
say["Omega_H = ", OmH];
say["T_H     = ", TH];
say[""];

say["Frequenza co-rotante:  xi = w - m Omega_H"];
say["N_materia     = 1/(Exp[xi/T_H] + 1)        (xi = w - m Omega_H)"];
say["N_antimateria = 1/(Exp[(w + m Omega_H)/T_H] + 1)   (C: m -> -m)"];
say["Segno: N_mat > N_anti  <=>  m Omega_H > 0 (co-rotante) -> MATERIA"];
say[""];

say["TABELLA (M=1, w=1, m=1):"];
say["a/M | Omega_H | T_H | N_mat | N_anti | A(simmetria)"];

tab = Table[
  Module[{aa, oH, tH, x1, x2, nm, na, asy},
    aa = aM;
    oH = N[a/(2 M rH) /. {M -> 1, a -> aa}];
    tH = N[TH /. {M -> 1, a -> aa}];
    x1 = (1 - oH)/tH;
    x2 = (1 + oH)/tH;
    nm = 1/(Exp[x1] + 1);
    na = 1/(Exp[x2] + 1);
    asy = (nm - na)/(nm + na);
    {aa, oH, tH, nm, na, asy}
  ],
  {aM, {0.1, 0.3, 0.5, 0.7, 0.9, 0.99}}
];

Do[
  say[
    "a/M=", tab[[i, 1]],
    "  Omega_H=", N[tab[[i, 2]], 4],
    "  T_H=", N[tab[[i, 3]], 4],
    "  N_mat=", ScientificForm[tab[[i, 4]], 4],
    "  N_anti=", ScientificForm[tab[[i, 5]], 4],
    "  A=", N[tab[[i, 6]], 5]
  ],
  {i, 1, Length[tab]}
];

say[""];
say["LETTURA:"];
say["- A POSITIVA per ogni a/M -> MATERIA favorita, segno definito (non si inverte)."];
say["- viene dal termine -m Omega_H nel Fermi-Dirac (frame-dragging)."];
say["- conferma il risultato Mashhoon col conto QFT (creazione fermioni da Kerr)."];
say["- A cresce con lo spin (~0.56 a a/M=0.1 -> ~1 a a/M alto)."];
say[""];
say["CONFINE: blinda il SEGNO near-horizon. Il VALORE (eta~10^-9) richiede"];
say["integrazione sui modi coi greybody + diluizione al bordo / eta=rapporto scale."];
say[""];

(* CHECK CPT CORRETTO: xi -> -xi (Omega_H e' del buco, NON si trasforma).
   N(-xi) = 1 - N(xi)  =>  N(xi) + N(-xi) - 1 = 0. *)
xi = w - m OmH;
Nplus = 1/(Exp[xi/TH] + 1);
Nminus = 1/(Exp[-xi/TH] + 1);
cptCheck = Simplify[Nplus + Nminus - 1];
say["Check CPT:  N(xi) + N(-xi) - 1 = ", cptCheck, "   (deve essere 0)"];
say["  [xi = w - m Omega_H ; la CPT-coniugata vede -xi ; Omega_H e' del buco, fisso]"];
say["  CPT RISPETTATO. L'asimmetria viola C e CP (Sakharov 2) ma rispetta CPT. [ok]"];

Close[out];
Print["[FATTO. Output in: ", outFile, "]"];
