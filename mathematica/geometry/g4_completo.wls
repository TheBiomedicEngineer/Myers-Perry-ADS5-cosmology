#!/usr/bin/env wolframscript
(* ============================================================
   g4_completo.wls v2 - g(4) FG, MP-AdS5 due spin.
   FIX: usa extract[] (While Head===Rule) per estrarre i VALORI,
   non ToValues nudo (che resta una regola, bug della v1).
   Sintassi collaudata 5-6 giugno. Output file + schermo, Quit finale.
   ============================================================ *)
Needs["xAct`xTensor`"]; Needs["xAct`xCoba`"];

outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\RISULTATO_g4.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, s, "\n"]; Flush[strm]; Print[s]);
extract[x_]:=Module[{u},u=x;While[Head[u]===Rule,u=Last[u]];u];

log["=== g(4) di bordo, MP-AdS5 due spin === " <> DateString[]];

(* 3-metrica di BORDO (theta, phi1, phi2) - quella validata cont.98 *)
Lv=1;
DefManifold[Bordo, 3, {a,b,c,d,e,f}];
DefConstantSymbol[a1]; DefConstantSymbol[a2];
DefChart[CH, Bordo, {1,2,3}, {th[],ph1[],ph2[]}, ChartColor->Blue];
ct=Cos[th[]]; st=Sin[th[]];
Xi1=1-a1^2; Xi2=1-a2^2;                 (* L=1 *)
DeltaTh=1-a1^2 ct^2-a2^2 st^2;
gmat=DiagonalMatrix[{1/DeltaTh, ct^2/Xi1, st^2/Xi2}];
DefMetric[1, met[-a,-b], CD, {",","\[Del]"}];
MetricInBasis[met, -CH, gmat];
log["inizio MetricCompute... " <> DateString[]];
MetricCompute[met, CH, All, CVSimplify->Simplify];
log["MetricCompute fatto. " <> DateString[]];

(* [A] VERIFICA: R di bordo (atteso 6 - 3S - 5D cos2th, con L=1) *)
Rsc = Simplify[extract[RicciScalarCD[] // ToValues]];
log[""]; log["[A] R bordo = " <> ToString[InputForm[Rsc]]];
log["    atteso: 6 - 3(a1^2+a2^2) - 5(a1^2-a2^2)Cos[2th]"];
log["    dR/dth con a2->a1 (D=0): " <> ToString[InputForm[Simplify[D[Rsc,th[]]/.a2->a1]]] <> "  (atteso 0)"];

(* [B] g(2) = -(1/(d-2))(R_ij - R/(2(d-1)) g_ij), d=4 *)
Rij = Table[Simplify[extract[ComponentValue[RicciCD[{i,-CH},{j,-CH}]]]], {i,3},{j,3}];
dB=4;
g2 = Table[Simplify[-(1/(dB-2))(Rij[[i,j]] - Rsc/(2(dB-1)) gmat[[i,j]])], {i,3},{j,3}];
log[""]; log["[B] g(2) diagonale:"];
log["    g2_thth   = " <> ToString[InputForm[g2[[1,1]]]]];
log["    g2_ph1ph1 = " <> ToString[InputForm[g2[[2,2]]]]];
log["    g2_ph2ph2 = " <> ToString[InputForm[g2[[3,3]]]]];

(* [C] struttura g(4): tr(g2), g2.g2 - portano S e D? sparisce a D=0? *)
ginv = Inverse[gmat];
trg2 = Simplify[Sum[ginv[[i,j]] g2[[i,j]], {i,3},{j,3}]];
g2sq = Simplify[Table[Sum[g2[[i,k]] ginv[[k,l]] g2[[l,j]], {k,3},{l,3}], {i,3},{j,3}]];
log[""]; log["[C] struttura g(4):"];
log["    tr g2 = " <> ToString[InputForm[TrigReduce[trg2]]]];
log["    tr g2 con a2->a1 (D=0): " <> ToString[InputForm[Simplify[trg2/.a2->a1]]]];
log["    tr g2 ha Cos[2th]? " <> If[!FreeQ[TrigReduce[trg2],Cos[2 th[]]],"SI -> porta D","NO"]];
log["    (g2.g2)_thth = " <> ToString[InputForm[TrigReduce[g2sq[[1,1]]]]]];

(* g(4) tracefree-part conforme: il quadrupolo OSSERVABILE *)
(* formula DSS (d=4): g4 ha parte ~ (1/8)[ (tr g2)^2 - tr(g2^2) ] g0 + ... ; 
   qui leggo la STRUTTURA angolare, non il coeff normalizzato assoluto *)
quad = Simplify[trg2^2 - Sum[g2sq[[i,i]] ginv[[i,i]]^0, {i,3}]];  (* indicatore struttura *)
log[""]; log["[C2] indicatore (tr g2)^2 - tr(g2.g2):"];
log["     = " <> ToString[InputForm[TrigReduce[quad]]]];
log["     con a2->a1 (D=0): " <> ToString[InputForm[Simplify[quad/.a2->a1]]]];

log[""]; log["=== FINE === " <> DateString[]];
Close[strm];
Print["Salvato: " <> outfile];
Quit[];
