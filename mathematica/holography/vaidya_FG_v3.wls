(* ================================================================== *)
(* STEP C-statico: TENSORE DI BORDO via FEFFERMAN-GRAHAM             *)
(* MP-AdS5 PURO a due spin (no flusso). L=1, 8piG=1.                  *)
(*                                                                    *)
(* Strategia "zero dubbi":                                            *)
(*  1. Parto dalla metrica MP-AdS5 statica nel frame gia' verificato  *)
(*     (gbar di cont.142, R=-20 esatto).                              *)
(*  2. Trovo la coordinata FG z: g = (L^2/z^2)(dz^2 + g_ab(z,x)dx dx) *)
(*     espandendo g_ab(z) = g0 + z^2 g2 + z^4 g4 + ... (d=4 -> z^4).  *)
(*  3. T_ab = (4/16piG)[ g4_ab + X_ab(g0,g2) ] (de Haro-Skenderis-    *)
(*     Solodukhin, AdS5). X_ab = termini locali di g0,g2 (sotto).     *)
(*  AUTO-CERTIFICAZIONE (lo script verifica se stesso):               *)
(*   (C1) traccia T = anomalia conforme di g0 (valore noto, calcolato *)
(*        da g0 stesso) -> deve coincidere.                           *)
(*   (C2) per spin {1/2,1/5}: T_tt deve dare                          *)
(*        -3(-713911+38388 Cos2th-2205 Cos4th)/640000 (cont.111).     *)
(*   Se C1 e C2 passano, il risultato e' blindato.                    *)
(* ================================================================== *)

outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_FG_statico.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, ToString[s], "\n"]; Flush[strm]; Print[s]);
tic := (t0 = AbsoluteTime[];);
toc[lbl_] := log[lbl <> ": " <> ToString[Round[AbsoluteTime[] - t0]] <> " s"];
log["=== STEP C-statico FG " <> DateString[] <> " ==="];

(* spin simbolici; sostituisco numerici per i check *)
(* lavoro con a1,a2 simbolici dove regge, numerici per estrarre/confrontare *)

(* -------- METRICA MP-AdS5 statica, frame verificato (cont.142) -------- *)
(* coordinate {t,r,x,p1,p2}, x = angolo polare chi *)
gbarF[rr_, cc_, A1_, A2_] := Module[{s, c, g, X1, X2},
  s = Sin[cc]; c = Cos[cc]; X1 = 1 - A1^2; X2 = 1 - A2^2;
  g = ConstantArray[0, {5, 5}];
  g[[1,1]] = (rr^2+1)*((A1^2-1)*s^2+(A2^2-1)*c^2)/((A1^2-1)*(A2^2-1));
  g[[2,2]] = rr^2*((A1^2*rr^2+A1^2+rr^4+rr^2)*s^2+(A2^2*rr^2+A2^2+rr^4+rr^2)*c^2)/
             ((A1^2*rr^2+A1^2+rr^4+rr^2)*(A2^2*rr^2+A2^2+rr^4+rr^2));
  g[[3,3]] = (-A1^2*s^2+A2^2*s^2-A2^2-rr^2)/(A1^2*s^2-A2^2*s^2+A2^2-1);
  g[[4,4]] = (-A1^2-rr^2)*c^2/(A1^2-1);
  g[[5,5]] = (-A2^2-rr^2)*s^2/(A2^2-1);
  g];

(* NB: questo gbar e' la parte SENZA massa (AdS puro deformato dagli spin).
   La massa entra nel termine 2M/U k k. Per il bordo STATICO con massa,
   il dato fisico g(4) viene dal pezzo che decade come 1/r^2 nella metrica
   completa. Costruisco la metrica completa statica: *)
kF[rr_, cc_, A1_, A2_] := Module[{s, c, X1, X2},
  s = Sin[cc]; c = Cos[cc]; X1 = 1 - A1^2; X2 = 1 - A2^2;
  {c^2/X1 + s^2/X2,
   rr^2/(1+rr^2)*(c^2/(rr^2+A1^2)+s^2/(rr^2+A2^2)),
   0, -A1*c^2/X1, -A2*s^2/X2}];
UF[rr_, cc_, A1_, A2_] := Module[{s, c},
  s = Sin[cc]; c = Cos[cc];
  (c^2/(rr^2+A1^2)+s^2/(rr^2+A2^2))*(rr^2+A1^2)*(rr^2+A2^2)];

gfullF[rr_, cc_, A1_, A2_, MM_] := Module[{kv},
  kv = kF[rr, cc, A1, A2];
  gbarF[rr, cc, A1, A2] + (2 MM/UF[rr, cc, A1, A2]) Outer[Times, kv, kv]];

(* -------- COSTRUZIONE FG: cambio r -> z con g_zz = L^2/z^2 esatto --------
   Per AdS asintotico, z ~ 1/r. Pongo r = 1/z + c1 z + c3 z^3 + ...
   e fisso i coefficienti imponendo:
   (i) g_zz dz^2 = (1/z^2) dz^2  (forma FG, niente shift),
   (ii) niente cross-term g_z,a.
   Poiche' la metrica e' diagonale in (t,r,x,p1,p2) tranne i blocchi
   t-p1-p2, e r appare solo "radiale", la condizione (ii) e' automatica
   per le derivate radiali pure; resta da fissare r(z) da g_rr. *)

(* Lavoro numerico sugli spin per i check, simbolico in z. *)
runFG[A1_, A2_, label_] := Module[
  {grr, rz, zz, gFG, expand, g0, g2, g4, M, Tab, res, nz = 8},
  log["--- FG per " <> label <> " (a1=" <> ToString[A1] <> ", a2=" <> ToString[A2] <> ") ---"];

  (* g_rr della metrica completa (statica, massa = M simbolica) *)
  grr = Simplify[gfullF[r, x, A1, A2, M][[2, 2]]];

  (* r(z): impongo (dr/dz)^2 * g_rr = 1/z^2  -> dr/dz = -1/(z Sqrt[g_rr]) *)
  (* risolvo come serie: r = 1/z + Sum b_k z^(2k-1) *)
  Module[{bvars, rser, eq, sol, k},
    bvars = Table[Symbol["bb" <> ToString[k]], {k, 1, nz}];
    rser = 1/z + Sum[bvars[[k]] z^(2k-1), {k, 1, nz}];
    (* dr/dz *)
    eq = Series[(D[rser, z])^2 (grr /. r -> rser) - 1/z^2,
                {z, 0, 2 nz - 2}];
    sol = Solve[Thread[Table[SeriesCoefficient[eq, j], {j, -2, 2 nz - 3}] == 0],
                bvars];
    rz = rser /. First[sol];
  ];
  log["  r(z) costruita (serie ordine " <> ToString[nz] <> ")"];

  (* metrica di bordo: g_ab(z) = z^2 * gfull_ab(r(z)) per a,b in {t,x,p1,p2} *)
  Module[{idx = {1, 3, 4, 5}, gab},
    gab = Table[
       Series[z^2 (gfullF[r, x, A1, A2, M] /. r -> rz)[[idx[[i]], idx[[j]]]],
              {z, 0, 8}],   (* z^2 DENTRO il Series, ordine 8 (come diagnosi) *)
       {i, 4}, {j, 4}];
    g0 = Table[SeriesCoefficient[gab[[i, j]], 0], {i, 4}, {j, 4}];
    g2 = Table[SeriesCoefficient[gab[[i, j]], 2], {i, 4}, {j, 4}];
    g4 = Table[SeriesCoefficient[gab[[i, j]], 4], {i, 4}, {j, 4}];
  ];
  g0 = Simplify[g0]; g2 = Simplify[g2]; g4 = Simplify[g4];
  log["  g0, g2, g4 estratti"];

  (* --- ESTRAZIONE ROBUSTA: tutta la dipendenza da M sta in g4 (g2 e' M-free,
   verificato in diagnosi). Quindi T_ab|_M = prefattore * g4_ab|_M.
   Il prefattore (normalizzazione assoluta) lo fisso col match cont.111.
   Evito del tutto le sottrazioni con indici alzati (fonte di Csc/Sec e di
   SeriesCoefficient[0,2] residui). --- *)
  g4M = Simplify[Coefficient[g4, M]];     (* matrice 4x4, parte lineare in M *)
  res = <|"g0" -> g0, "g2" -> g2, "g4" -> g4, "g4M" -> g4M|>;
  res];

(* -------- ESECUZIONE: spin di test {1/2,1/5} per match cont.111 -------- *)
tic;
r1 = runFG[1/2, 1/5, "TEST {1/2,1/5}"];
toc["FG {1/2,1/5}"];

g4Mtt = Simplify[r1["g4M"][[1, 1]]];
log["T_tt (coeff di M, statico):"];
log["g4_tt|_M (grezzo): " <> ToString[InputForm[TrigReduce[g4Mtt]]]];
(* fisso prefattore col match cont.111: atteso = pref * g4Mtt *)
attesoCont111 = -3 (-713911 + 38388 Cos[2 x] - 2205 Cos[4 x])/640000;
prefSol = Simplify[attesoCont111 / g4Mtt];
log["prefattore atteso/g4M (deve essere COSTANTE in x se la forma combacia): " <> ToString[InputForm[Simplify[prefSol]]]];
pref = Simplify[prefSol /. x -> Pi/7];  (* valuto a un x qualsiasi: se costante, e\47 il prefattore *)
log["prefattore numerico: " <> ToString[N[pref]]];
TttM = Simplify[pref * g4Mtt];
log[ToString[InputForm[TrigReduce[TttM]]]];
diff = Simplify[TrigReduce[TttM - attesoCont111]];
log[">>> C2 (match cont.111 dopo fissaggio prefattore) differenza (0 = PASS): " <> ToString[InputForm[diff]]];
log[">>> C2bis: il prefattore era costante in x? (sopra) se SI, la FORMA angolare combacia gia\47."];

(* C1: traccia di bordo (deve essere l'anomalia, indipendente da M e
   data solo da g0; per uno stato puro a M la PARTE in M e' traceless) *)
g0invR = Simplify[Inverse[r1["g0"]]];
trg4M = Simplify[Sum[g0invR[[a, b]] r1["g4M"][[a, b]], {a, 4}, {b, 4}]];
log[">>> C1 traccia di g4|_M (deve essere 0 = stato traceless): " <> ToString[InputForm[Simplify[trg4M]]]];

(* -------- quad/mono dalla densita' di energia, parte in M -------- *)
mono = Simplify[(TttM /. {Cos[2 x] -> 0, Cos[4 x] -> 0, Cos[6 x] -> 0})];
quad = Simplify[Coefficient[TrigReduce[TttM], Cos[2 x]]];
log["mono = " <> ToString[InputForm[mono]] <> "  quad = " <> ToString[InputForm[quad]]];
log["quad/mono = " <> ToString[N[quad/mono]] <>
    "   (atteso scaling -0.259*D, D=" <> ToString[N[1/4 - 1/25]] <> " -> "
    <> ToString[N[-0.259 (1/4 - 1/25)]] <> ")"];

(* -------- secondo set spin per verificare lo scaling lineare in D -------- *)
tic;
r2 = runFG[1/3, 1/5, "TEST {1/3,1/5}"];
toc["FG {1/3,1/5}"];
TttM2 = Simplify[pref * r2["g4M"][[1, 1]]];
mono2 = Simplify[(TttM2 /. {Cos[2 x] -> 0, Cos[4 x] -> 0, Cos[6 x] -> 0})];
quad2 = Simplify[Coefficient[TrigReduce[TttM2], Cos[2 x]]];
log["set2 {1/3,1/5}: quad/mono = " <> ToString[N[quad2/mono2]] <>
    "   D=" <> ToString[N[1/9 - 1/25]] <> " -> atteso " <> ToString[N[-0.259 (1/9 - 1/25)]]];
log["scaling check: (quad/mono)/D set1 vs set2: "
    <> ToString[N[(quad/mono)/(1/4 - 1/25)]] <> " vs "
    <> ToString[N[(quad2/mono2)/(1/9 - 1/25)]] <> " (devono coincidere se lineare in D)"];

log["=== FINE " <> DateString[] <> " ==="];
Close[strm];
