(* ============================================================ *)
(* PASSO C v3 — MATHEMATICA PURO (senza xAct)                   *)
(* Christoffel, Riemann, Ricci calcolati direttamente           *)
(* Output su file Desktop                                        *)
(* ============================================================ *)

outputFile = "C:\\Users\\Utente\\Desktop\\des\\files\\passo_C_v3_risultati.txt";
If[FileExistsQ[outputFile], DeleteFile[outputFile]];

log[s_] := (Print[s]; PutAppend[OutputForm[s], outputFile]);

log["=== PASSO C v3 — MP-AdS5 MATHEMATICA PURO ==="];
log["Data: " <> DateString[]];
log[""];

(* ============================================================ *)
(* 1. PARAMETRI NUMERICI                                         *)
(* ============================================================ *)
a1v = 0.222; a2v = 0.135; Lv = 1.0;
Xi1v = 1 - a1v^2/Lv^2;
Xi2v = 1 - a2v^2/Lv^2;

log["=== 1. PARAMETRI ==="];
log["a1=" <> ToString[a1v] <> ", a2=" <> ToString[a2v]];
log["Xi1=" <> ToString[N[Xi1v]] <> ", Xi2=" <> ToString[N[Xi2v]]];
log[""];

(* ============================================================ *)
(* 2. METRICA DI BORDO g(0) — 3x3 in coordinate (th, phi1, phi2) *)
(* g_00=4, g_11=sin^2(th)/Xi1, g_22=cos^2(th)/Xi2               *)
(* ============================================================ *)
th = Symbol["th"];  (* coordinata angolare *)

gij[i_,j_] := Which[
  i==1&&j==1, 4,
  i==2&&j==2, Sin[th]^2/Xi1v,
  i==3&&j==3, Cos[th]^2/Xi2v,
  True, 0
];

(* Matrice e inversa *)
gMat = Table[gij[i,j], {i,1,3}, {j,1,3}];
gInv = Inverse[gMat] // Simplify;
detg = Det[gMat] // Simplify;
sqrtg = Sqrt[detg] // Simplify;

log["=== 2. METRICA DI BORDO g(0) ==="];
log["g_mat = " <> ToString[gMat // MatrixForm]];
log["det(g) = " <> ToString[detg // Simplify]];
log["sqrt(g) = " <> ToString[sqrtg // Simplify]];
log[""];

(* ============================================================ *)
(* 3. SIMBOLI DI CHRISTOFFEL                                     *)
(* Gamma^k_ij = 1/2 g^kl (dj g_li + di g_lj - dl g_ij)          *)
(* ============================================================ *)
coords = {th, Symbol["phi1"], Symbol["phi2"]};

(* Derivate della metrica *)
dg[i_,j_,k_] := D[gMat[[i,j]], coords[[k]]];

(* Christoffel *)
Gamma[k_,i_,j_] := Sum[
  gInv[[k,l]] * (dg[l,j,i] + dg[l,i,j] - dg[i,j,l]),
  {l,1,3}] / 2 // Simplify;

log["=== 3. SIMBOLI DI CHRISTOFFEL (non-zero) ==="];
Do[
  Do[
    Do[
      val = Gamma[k,i,j];
      If[val =!= 0 && val =!= 0.,
        log["Gamma^" <> ToString[k] <> "_" <> ToString[i] <>
            ToString[j] <> " = " <> ToString[val // Simplify]]
      ],
      {j,i,3}  (* simmetria in i,j *)
    ],
    {i,1,3}
  ],
  {k,1,3}
];
log[""];

(* ============================================================ *)
(* 4. TENSORE DI RIEMANN                                         *)
(* R^l_ijk = dj Gamma^l_ik - dk Gamma^l_ij                      *)
(*          + Sum_m (Gamma^l_jm Gamma^m_ik - Gamma^l_km Gamma^m_ij) *)
(* ============================================================ *)
Riem[l_,i_,j_,k_] := (
  D[Gamma[l,i,k], coords[[j]]] - D[Gamma[l,i,j], coords[[k]]] +
  Sum[Gamma[l,j,m]*Gamma[m,i,k] - Gamma[l,k,m]*Gamma[m,i,j], {m,1,3}]
) // Simplify;

(* ============================================================ *)
(* 5. TENSORE DI RICCI                                           *)
(* R_ij = R^k_ikj                                                *)
(* ============================================================ *)
Ricci[i_,j_] := Sum[Riem[k,i,k,j], {k,1,3}] // Simplify;

log["=== 4+5. TENSORE DI RICCI R_ij (componenti non-zero) ==="];
RicciMat = Table[Ricci[i,j], {i,1,3}, {j,1,3}];
Do[
  Do[
    val = RicciMat[[i,j]];
    If[val =!= 0 && Simplify[val] =!= 0,
      log["R_" <> ToString[i] <> ToString[j] <> " = " <>
          ToString[val // Simplify]]
    ],
    {j,1,3}
  ],
  {i,1,3}
];
log[""];

(* ============================================================ *)
(* 6. CURVATURA SCALARE — IL TEST DECISIVO                       *)
(* R = g^ij R_ij                                                  *)
(* ============================================================ *)
Rscalar = Sum[gInv[[i,j]] * RicciMat[[i,j]], {i,1,3}, {j,1,3}] // Simplify;

log["=== 6. CURVATURA SCALARE — TEST DECISIVO ==="];
log["R = " <> ToString[Rscalar]];
log["R numerico = " <> ToString[N[Rscalar]]];
log["R da Python (metrica SBAGLIATA): 3/2 = 1.5"];
log[""];
If[Simplify[Rscalar - 3/2] === 0,
  log["RISULTATO: R = 3/2 anche sulla metrica REALE"],
  log["RISULTATO: R != 3/2 — Python era artefatto (CONFERMATO)"]
];
log[""];

(* ============================================================ *)
(* 7. CONTROTERMINI BK                                           *)
(* ============================================================ *)
RicciSq = Sum[gInv[[i,k]]*gInv[[j,l]]*RicciMat[[i,j]]*RicciMat[[k,l]],
  {i,1,3},{j,1,3},{k,1,3},{l,1,3}] // Simplify;
CT3integrand = Simplify[RicciSq - Rscalar^2/4];

log["=== 7. CONTROTERMINI BK ==="];
log["R_mn R^mn = " <> ToString[RicciSq]];
log["R_mn R^mn numerico = " <> ToString[N[RicciSq]]];
log["CT3 integrand = R_mn R^mn - R^2/4 = " <> ToString[CT3integrand]];
log["CT3 integrand numerico = " <> ToString[N[CT3integrand]]];
log[""];

(* ============================================================ *)
(* 8. CORRENTE DI NOETHER J_D                                    *)
(* J_D = sqrt(g) * (g^{phi1 phi1} - g^{phi2 phi2})               *)
(* Integrata su theta in [0, pi/2], poi x (2pi)^2 per phi1,phi2  *)
(* ============================================================ *)
JD_integrand = sqrtg * (gInv[[2,2]] - gInv[[3,3]]) // Simplify;
JD_psi = Integrate[JD_integrand, {th, 0, Pi/2}];
JD_total = JD_psi * (2*Pi)^2 // Simplify;

log["=== 8. CORRENTE DI NOETHER J_D ==="];
log["J_D integrand(th) = " <> ToString[JD_integrand // Simplify]];
log["J_D integrata (x 4pi^2) = " <> ToString[JD_total // Simplify]];
log["J_D numerico = " <> ToString[N[JD_total]]];
log[""];

(* ============================================================ *)
(* 9. CONFRONTO CON D/S E COLLEGAMENTO ALPHA                     *)
(* ============================================================ *)
rhval = 0.191;
O1n = a1v*(1-a1v^2)/(rhval^2+a1v^2);
O2n = a2v*(1-a2v^2)/(rhval^2+a2v^2);
Dn = O1n - O2n;
Sn = O1n + O2n;
DS = Dn/Sn;
Dspin = a1v^2 - a2v^2;

log["=== 9. CONFRONTO CON D/S (cont.257) ==="];
log["O1=" <> ToString[N[O1n]] <> ", O2=" <> ToString[N[O2n]]];
log["D=" <> ToString[N[Dn]] <> ", S=" <> ToString[N[Sn]]];
log["D/S = " <> ToString[N[DS]] <> " = 1/" <> ToString[N[1/DS]]];
log["alpha(MZ) obs = 1/127.9"];
log["Delta = " <> ToString[N[Abs[DS-1/127.9]/(1/127.9)*100]] <> "%"];
log[""];
log["D_spin = a1^2-a2^2 = " <> ToString[N[Dspin]]];
log["J_D / D_spin = " <> ToString[N[JD_total/Dspin]]];
log["Se ~-128: collegamento alpha=J_D/norm VERIFICATO su metrica reale"];
log[""];

log["=== FINE PASSO C v3 ==="];
Print["*** COMPLETATO. File: ", outputFile, " ***"];
