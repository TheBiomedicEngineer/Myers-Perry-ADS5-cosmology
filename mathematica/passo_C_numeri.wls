(* Script minimale — solo numeri, niente funzioni *)
outputFile = "C:\\Users\\Utente\\Desktop\\des\\files\\passo_C_numeri.txt";
If[FileExistsQ[outputFile], DeleteFile[outputFile]];
W[s_] := (Print[s]; PutAppend[OutputForm[s <> "\n"], outputFile]);
W["=== PASSO C — NUMERI FINALI === " <> DateString[]]; W[""];

(* Tutti i valori numerici espliciti *)
a1 = 0.222; a2 = 0.135; rh = 0.191;
A = rh^2 + a1^2;    (* = 0.085765 *)
B = rh^2 + a2^2;    (* = 0.054706 *)
Dspin = a1^2 - a2^2; (* = 0.031059 *)
O1 = a1*(1-a1^2)/(rh^2+a1^2);  (* = 2.46090 *)
O2 = a2*(1-a2^2)/(rh^2+a2^2);  (* = 2.42276 *)
Dv = O1 - O2;  (* = 0.03814, NOTA: non usare D che e' riservato *)
Sv = O1 + O2;  (* = 4.88366 *)

(* J_D formula analitica VERIFICATA (audit Python, cont.262) *)
(* J_D = -2 * Pi^3 * rh * Dspin / Sqrt[A*B] *)
JD = -2.0 * (3.14159265358979)^3 * rh * Dspin / Sqrt[A*B];

(* CT2 dalla curvatura REALE (Mathematica v3, verificato) *)
(* Int R*sqrt(g) dtheta = -357.817 (da v5) *)
(* CT2 = (L/2) * (-357.817) * 4*Pi^2, L=1 *)
CT2 = 0.5 * (-357.817) * 4.0 * (3.14159265358979)^2;

(* J_D rinormalizzata (approssimazione: delta_CT2 dal contributo differenziale) *)
(* Dal v3: R_22/g22 ~ R_33/g33 (verificare dal tensore di Ricci) *)
(* Per ora usiamo solo J_D grezzo *)
JDren = JD;  (* da aggiornare quando si hanno R_22, R_33 *)

W["A = rh^2+a1^2 = " <> ToString[N[A]]];
W["B = rh^2+a2^2 = " <> ToString[N[B]]];
W["sqrt(A*B) = " <> ToString[N[Sqrt[A*B]]]];
W["Dspin = a1^2-a2^2 = " <> ToString[N[Dspin]]];
W[""];
W["J_D = -2*Pi^3*rh*Dspin/sqrt(AB) = " <> ToString[N[JD]]];
W[""];
W["O1 = " <> ToString[N[O1]] <> "  O2 = " <> ToString[N[O2]]];
W["Dv = O1-O2 = " <> ToString[N[Dv]]];
W["Sv = O1+O2 = " <> ToString[N[Sv]]];
W["D/S = " <> ToString[N[Dv/Sv]] <> " = 1/" <> ToString[N[1/(Dv/Sv)]]];
W[""];
W["=== RAPPORTI ==="];
W["J_D / Dspin = " <> ToString[N[JD/Dspin]]];
W["J_D / Dv    = " <> ToString[N[JD/Dv]]];
W["J_D / Sv    = " <> ToString[N[JD/Sv]]];
W["|J_D| / Dspin = " <> ToString[N[Abs[JD]/Dspin]]];
W["|J_D| / Dv    = " <> ToString[N[Abs[JD]/Dv]]];
W[""];
W["1/alpha(MZ)    = 127.9"];
W["1/alpha(low E) = 137.036"];
W[""];
W["Se |J_D|/Dv ~ 128: alpha = Dv/|J_D| VERIFICATO sulla metrica reale"];
W["Se |J_D|/Dspin ~ 128: alpha = Dspin/|J_D| verificato"];
W[""];
W["CT2 = L/2 * Int[R*sqrt(g)] * 4*Pi^2 = " <> ToString[N[CT2]]];
W["J_D^ren ~ J_D + delta_CT2 (delta_CT2 da R_22,R_33 -- da calcolare)"];
W[""];
W["=== FINE ==="];
Print["Completato: ", outputFile];
