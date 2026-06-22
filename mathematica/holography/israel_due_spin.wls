(* ================================================================== *)
(* JUNCTION DI ISRAEL — brana a r=cost in MP-AdS5 a DUE SPIN.         *)
(* Z2-simmetrico: K_ab - K h_ab = -4 pi G5 S_ab  (8piG5=1 -> -1/2).   *)
(* Obiettivo: S_ab della brana, sua S_tt (= sigma + rho), e la sua    *)
(*   decomposizione angolare (monopolo sigma + quadrupolo prop D?).   *)
(* Risponde a: QUALE contrazione e' rho (fissata da Israel, non a mano)*)
(* Frame: gbar verificato cont.142 (R=-20). Brana timelike a r=R0,    *)
(*   normale radiale; leggo a R0 grande e nel limite R0->r_h.         *)
(* AUTO-CHECK: a1=a2=0 (Schwarzschild-AdS) deve dare il caso          *)
(*   non-rotante gia' verificato (sigma isotropa, no quadrupolo).     *)
(* Veloce (no MetricCompute 5D): estrinseca via normale + derivate.   *)
(* ================================================================== *)

outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_israel.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, ToString[s], "\n"]; Flush[strm]; Print[s]);
tic := (t0 = AbsoluteTime[];);
toc[l_] := log[l <> ": " <> ToString[Round[AbsoluteTime[] - t0]] <> " s"];
log["=== ISRAEL DUE SPIN " <> DateString[] <> " ==="];

(* coordinate {t,r,x,p1,p2}; metrica statica MP-AdS5, frame cont.142 *)
gbarF[rr_, cc_, A1_, A2_, MM_] := Module[{s, c, g, X1, X2, kv, U},
  s = Sin[cc]; c = Cos[cc]; X1 = 1 - A1^2; X2 = 1 - A2^2;
  g = ConstantArray[0, {5, 5}];
  g[[1,1]] = (rr^2+1)*((A1^2-1)*s^2+(A2^2-1)*c^2)/((A1^2-1)*(A2^2-1));
  g[[2,2]] = rr^2*((A1^2*rr^2+A1^2+rr^4+rr^2)*s^2+(A2^2*rr^2+A2^2+rr^4+rr^2)*c^2)/
             ((A1^2*rr^2+A1^2+rr^4+rr^2)*(A2^2*rr^2+A2^2+rr^4+rr^2));
  g[[3,3]] = (-A1^2*s^2+A2^2*s^2-A2^2-rr^2)/(A1^2*s^2-A2^2*s^2+A2^2-1);
  g[[4,4]] = (-A1^2-rr^2)*c^2/(A1^2-1);
  g[[5,5]] = (-A2^2-rr^2)*s^2/(A2^2-1);
  kv = {c^2/X1 + s^2/X2,
        rr^2/(1+rr^2)*(c^2/(rr^2+A1^2)+s^2/(rr^2+A2^2)),
        0, -A1*c^2/X1, -A2*s^2/X2};
  U = (c^2/(rr^2+A1^2)+s^2/(rr^2+A2^2))*(rr^2+A1^2)*(rr^2+A2^2);
  g + (2 MM/U) Outer[Times, kv, kv]];

(* superficie Sigma: r = R0 (cost). Normale n_mu = (0, n_r, 0,0,0),
   n_mu propto d_mu(r - R0) = delta^r_mu, normalizzata: n.n=+1 (timelike brana,
   normale spacelike). n_r = 1/Sqrt[g^rr] = Sqrt[g_rr] (metrica con g^rr).
   Estrinseca: K_ab = (1/2) n^r d_r h_ab, con h_ab metrica indotta (a,b != r),
   formula per superficie di coordinata costante con metrica diagonale-in-r. *)

israel[A1_, A2_, label_] := Module[
  {g, ginv, nr, nup, idx = {1,3,4,5}, h, dh, Kab, Ktr, hinv, Sab, res},
  g = gbarF[rr, x, A1, A2, MM];
  ginv = Inverse[g];
  (* normale unitaria spacelike: n_mu = delta^r / Sqrt[g^rr], n^mu = g^rr n_r * e_r *)
  nr = 1/Sqrt[ginv[[2,2]]];          (* n_r *)
  nup = ginv[[2,2]] nr;               (* n^r = g^rr n_r = Sqrt[g^rr] *)
  (* metrica indotta = g sui blocchi non-r (la brana eredita) *)
  h = g[[idx, idx]];
  hinv = Inverse[h];
  (* K_ab = (1/2) n^r d_r h_ab  (superficie r=cost, metrica senza shift in r per i blocchi) *)
  dh = D[h, rr];
  Kab = (1/2) nup dh;
  Ktr = Sum[hinv[[a,b]] Kab[[a,b]], {a,4}, {b,4}];
  (* Israel Z2, 8piG5=1: K_ab - K h_ab = -(1/2) S_ab -> S_ab = -2(K_ab - K h_ab) *)
  Sab = -2 (Kab - Ktr h);
  (* valuto sull'orizzonte: r_h = piu' grande radice di U-relazione; uso r_h tale che
     g^rr=0. Per MP-AdS, g_rr ha polo dove Delta=0. Prendo il limite simbolico a r->Infinity
     (brana asintotica) E la struttura a R0 generico. *)
  res = <|"Sab" -> Sab, "h" -> h, "hinv" -> hinv, "Kab" -> Kab, "Ktr" -> Ktr|>;
  res];

(* ---- AUTO-CHECK: Schwarzschild-AdS (a1=a2=0) ---- *)
tic;
log["--- CHECK Schwarzschild-AdS (a1=a2=0): atteso S_tt isotropo, no cos2x ---"];
r0 = israel[0, 0, "Schw"];
Stt0 = Simplify[r0["Sab"][[1,1]]];
log["S_tt (Schw, simbolico in rr,MM): " <> ToString[InputForm[Stt0]]];
log["  dipende da x? (deve NO): " <> ToString[! FreeQ[Stt0, x]]];
toc["check Schw"];

(* ---- DUE SPIN: estraggo S_tt e la decomposizione angolare ---- *)
doSpin[A1_, A2_, lab_] := Module[{r1, Stt, asy, mono, quad, quad4},
  tic;
  r1 = israel[A1, A2, lab];
  Stt = Simplify[r1["Sab"][[1,1]]];
  log["--- " <> lab <> " (a1=" <> ToString[A1] <> ",a2=" <> ToString[A2] <> ") ---"];
  log["S_tt(rr,MM) = " <> ToString[InputForm[Stt]]];
  (* struttura angolare a rr grande (brana asintotica) e a MM->0 (tensione pura) e in MM (materia) *)
  log["  S_tt|_{MM->0} (tensione, dovrebbe dare sigma): "];
  sigmaPart = Simplify[Stt /. MM -> 0];
  log["    " <> ToString[InputForm[TrigReduce[sigmaPart]]]];
  log["  d S_tt/d MM (parte materia/energia): "];
  rhoPart = Simplify[D[Stt, MM]];
  log["    " <> ToString[InputForm[TrigReduce[rhoPart]]]];
  (* decomposizione angolare della parte materia, a rr grande *)
  rhoAsym = Simplify[Series[rhoPart, {rr, Infinity, 0}] // Normal];
  log["  parte materia a rr->inf: " <> ToString[InputForm[TrigReduce[rhoAsym]]]];
  toc[lab];
  <|"Stt" -> Stt, "sigma" -> sigmaPart, "rho" -> rhoPart|>];

sA = doSpin[1/2, 1/5, "TEST {1/2,1/5}"];
sB = doSpin[1/3, 1/5, "TEST {1/3,1/5}"];

(* ---- la domanda chiave: quale contrazione e' rho? ----
   S_tt e' la componente covariante. La densita' fisica sulla brana e'
   rho = -S^t_t = -h^{tt} S_tt (un indice alzato con la metrica di brana).
   Calcolo S^t_t e la confronto con le tre densita' di cont.214. *)
log["=== rho = -S^t_t (un indice alzato con h di brana) ==="];
Do[Module[{r1 = israel[sp[[1]], sp[[2]], sp[[3]]], Smix, rho, mono, quad},
   Smix = Simplify[(r1["hinv"] . r1["Sab"])[[1,1]]];
   rho = Simplify[D[Smix, MM]];   (* parte in materia *)
   rho = Simplify[Series[rho, {rr, Infinity, 0}] // Normal];
   mono = Simplify[rho /. {Cos[2 x] -> 0, Cos[4 x] -> 0}];
   quad = Simplify[Coefficient[TrigReduce[rho], Cos[2 x]]];
   log[sp[[3]] <> ": rho=-S^t_t (rr->inf, parte MM) = " <> ToString[InputForm[TrigReduce[rho]]]];
   If[mono =!= 0,
      log["  quad/mono = " <> ToString[N[quad/mono]]]];
  ], {sp, {{1/2, 1/5, "{1/2,1/5}"}, {1/3, 1/5, "{1/3,1/5}"}}}];

log["=== FINE " <> DateString[] <> " ==="];
Close[strm];
