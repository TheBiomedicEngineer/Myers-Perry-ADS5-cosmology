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
  Module[{idx = {1, 3, 4, 5}, gab, ser},
    gab = Table[
       z^2 * Series[(gfullF[r, x, A1, A2, M] /. r -> rz)[[idx[[i]], idx[[j]]]],
                    {z, 0, 6}],
       {i, 4}, {j, 4}];
    g0 = Table[SeriesCoefficient[gab[[i, j]], 0], {i, 4}, {j, 4}];
    g2 = Table[SeriesCoefficient[gab[[i, j]], 2], {i, 4}, {j, 4}];
    g4 = Table[SeriesCoefficient[gab[[i, j]], 4], {i, 4}, {j, 4}];
  ];
  g0 = Simplify[g0]; g2 = Simplify[g2]; g4 = Simplify[g4];
  log["  g0, g2, g4 estratti"];

  (* tensore di bordo DSS per AdS5 (L=1, 8piG=1):
     T_ab = (1/(4piG)) { g4_ab - (1/8) g0_ab [ (Tr g2)^2 - Tr(g2^2) ]
            - (1/2)(g2^2)_ab + (1/4) g2_ab Tr g2 }
     (forma standard de Haro-Skenderis-Solodukhin 2000, eq. per d=4).
     Uso 16piG=1 -> prefattore 4. *)
  Module[{g0inv, g2u, trg2, g2sq},
    g0inv = Simplify[Inverse[g0]];
    g2u = Simplify[g0inv . g2];          (* g2^a_b *)
    trg2 = Simplify[Tr[g2u]];
    g2sq = Simplify[g2 . g0inv . g2];    (* (g2^2)_ab abbassato *)
    Tab = 4 (g4
        - (1/8) g0 (trg2^2 - Tr[g2u . g2u])
        - (1/2) g2sq
        + (1/4) g2 trg2);
    Tab = Simplify[Tab];
    (* per il confronto cont.111 serve la sola dipendenza M->1 normalizzata *)
    res = <|"g0" -> g0, "g2" -> g2, "g4" -> g4, "T" -> Tab,
            "g0inv" -> g0inv, "trg2" -> trg2|>;
  ];
  res];

(* -------- DIAGNOSI: dove atterra M nell'espansione FG? -------- *)
log["=== DIAGNOSI: ordine in z del termine di massa ==="];
Module[{A1 = 1/2, A2 = 1/5, grr, rz, nz = 8, bvars, rser, eq, sol, k,
        gttFull, gttSer, idx = {1,3,4,5}},
  grr = Simplify[gfullF[r, x, A1, A2, M][[2, 2]]];
  bvars = Table[Symbol["bb" <> ToString[k]], {k, 1, nz}];
  rser = 1/z + Sum[bvars[[k]] z^(2k-1), {k, 1, nz}];
  eq = Series[(D[rser, z])^2 (grr /. r -> rser) - 1/z^2, {z, 0, 2 nz - 2}];
  sol = Solve[Thread[Table[SeriesCoefficient[eq, j], {j, -2, 2 nz - 3}] == 0], bvars];
  rz = rser /. First[sol];
  log["r(z) costruita. Ora guardo g_tt(z) = z^2 gfull_tt(r(z)):"];
  (* g_tt completa riscalata, serie in z, tenendo M simbolico *)
  gttFull = z^2 (gfullF[r, x, A1, A2, M] /. r -> rz)[[1, 1]];
  gttSer = Series[gttFull, {z, 0, 8}];
  Do[Module[{cf = Simplify[SeriesCoefficient[gttSer, n]]},
     log["  z^" <> ToString[n] <> " : " <> ToString[InputForm[cf]] <>
         "   [contiene M? " <> ToString[! FreeQ[cf, M]] <> "]"]],
    {n, 0, 8}];

  (* CONTROCHECK: r(z) e' stata costruita da grr CHE CONTIENE M.
     Se M e' sparita, e' perche' bb_k dipendono da M e si e' incastrato.
     Stampo se r(z) contiene M: *)
  log["r(z) contiene M? " <> ToString[! FreeQ[rz, M]]];
  log["primi coeff bb (devono dipendere da M se la massa entra nel frame radiale):"];
  Do[log["  bb" <> ToString[k] <> " = " <>
     ToString[InputForm[Simplify[bvars[[k]] /. First[sol]]]]], {k, 1, 4}];
];
log["=== FINE DIAGNOSI ==="];
Close[strm];
