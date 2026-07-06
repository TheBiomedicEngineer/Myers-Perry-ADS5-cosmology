(* ============================================================ *)
(* PASSO C FINALE — istruzioni complete per Mathematica         *)
(* Tutto in un unico script, calcolo simbolico + numerico       *)
(* ============================================================ *)

outputFile = "C:\\Users\\Utente\\Desktop\\des\\files\\passo_C_g5_risultati.txt";
If[FileExistsQ[outputFile], DeleteFile[outputFile]];
W[s_] := (Print[s]; PutAppend[OutputForm[s <> "\n"], outputFile]);
W["=== PASSO C FINALE === " <> DateString[]]; W[""];

a1 = 0.222; a2 = 0.135; rh = 0.191;
Xi1 = 1 - a1^2; Xi2 = 1 - a2^2;

(* --- 1. METRICA g(0) --- *)
g22[theta_] := Sin[theta]^2/Xi1;
g33[theta_] := Cos[theta]^2/Xi2;
sqrtg[theta_] := 2*Sin[theta]*Cos[theta]/Sqrt[Xi1*Xi2];

(* --- 2. CURVATURA SCALARE (da v3, verificata) --- *)
Rscalar[theta_] := -0.404113 - 0.216704/Sin[theta]^2 - 0.231488/Cos[theta]^2;

(* --- 3. R_22 ANALITICA (derivata nel v3, verificata per R_22) --- *)
(* Gamma^theta_phi1phi1 = -Sin[2theta]/(8*Xi1) *)
(* Gamma^phi1_theta_phi1 = Cot[theta] *)
(* R_22 = d_theta(Gamma^t_22) + Gamma^phi1_t_phi1 * Gamma^t_22 *)
R22[theta_] := -Cos[2*theta]/(4*Xi1) - Cos[theta]*Sin[2*theta]/(8*Xi1*Sin[theta]);

(* --- 4. R_33 SIMBOLICA (DA CALCOLARE ESATTAMENTE) --- *)
(* Gamma^theta_phi2phi2 = +Sin[2theta]/(8*Xi2) *)
(* Gamma^phi2_theta_phi2 = -Tan[theta] *)
(* R_33 = d_theta(Gamma^t_33) + Gamma^phi2_t_phi2 * Gamma^t_33 *)
R33[theta_] := Cos[2*theta]/(4*Xi2) + Sin[theta]*Sin[2*theta]/(8*Xi2*Cos[theta]);

(* --- 5. VERIFICA PUNTUALE vs Mathematica v3 --- *)
W["=== VERIFICA R_22, R_33 vs Mathematica v3 ==="];
W["R_22(Pi/4) = " <> ToString[N[R22[Pi/4]]] <> " (atteso: -0.13148)"];
W["R_33(Pi/4) = " <> ToString[N[R33[Pi/4]]] <> " (atteso: -0.12732)"];
W["R_22(Pi/6) = " <> ToString[N[R22[Pi/6]]] <> " (atteso: -0.3287)"];
W["R_33(Pi/6) = " <> ToString[N[R33[Pi/6]]] <> " (atteso: +0.0637)"];
W[""];

(* --- 6. g(2) DA FORMULA FG (de Haro-Skenderis-Taylor) --- *)
(* g(2)_munu = -1/2*(R_munu - R*g_munu/6) *)
g2_22[theta_] := -0.5*(R22[theta] - Rscalar[theta]*g22[theta]/6);
g2_33[theta_] := -0.5*(R33[theta] - Rscalar[theta]*g33[theta]/6);

W["=== g(2) COEFFICIENTI FG ==="];
W["g(2)_22(Pi/4) = " <> ToString[N[g2_22[Pi/4]]]];
W["g(2)_33(Pi/4) = " <> ToString[N[g2_33[Pi/4]]]];
W["delta_c2(Pi/4) = g(2)_22 - g(2)_33 = " <> ToString[N[g2_22[Pi/4] - g2_33[Pi/4]]]];
W[""];

(* --- 7. INTEGRALE delta_c2 su S3 --- *)
delta_c2_integrand[theta_] := (g2_22[theta] - g2_33[theta]) * sqrtg[theta];
W["delta_c2 integrand(Pi/4) = " <> ToString[N[delta_c2_integrand[Pi/4]]]];
W["delta_c2 integrand(Pi/6) = " <> ToString[N[delta_c2_integrand[Pi/6]]]];
W[""];

delta_c2_psi = NIntegrate[delta_c2_integrand[theta], {theta, 0.001, Pi/2-0.001},
  Method -> "GaussKronrodRule", PrecisionGoal -> 8, AccuracyGoal -> 8];
delta_c2_total = delta_c2_psi * 4.0 * (3.14159265)^2;

W["Int delta_c2 * sqrt(g) = " <> ToString[N[delta_c2_psi]]];
W["delta_c2_total (x 4pi^2) = " <> ToString[N[delta_c2_total]]];
W[""];

(* --- 8. RAPPORTO delta_c2 / J_D = stima G5/L^3 --- *)
JD = -5.37066;
Dv = 0.0381363;

ratio = N[delta_c2_total] / JD;
W["=== RAPPORTO delta_c2 / J_D ==="];
W["delta_c2_total / J_D = " <> ToString[N[ratio]]];
W["Interpretazione: ~ G5/L^3"];
W[""];

(* --- 9. alpha rinormalizzata --- *)
(* J_D^ren = J_D * (L^3/G5) *)
(* alpha = Dv / |J_D^ren| = Dv * G5/L^3 / |J_D| = Dv / |J_D| * ratio *)
(* Se ratio = G5/L^3, allora: *)
alpha_ren = Dv * Abs[ratio] / Abs[JD];
W["=== alpha RINORMALIZZATA ==="];
W["alpha = Dv * |ratio| / |J_D| = " <> ToString[N[alpha_ren]]];
W["1/alpha = " <> ToString[N[1/alpha_ren]]];
W["alpha(MZ) = 1/127.9 = " <> ToString[N[1/127.9]]];
W["Delta = " <> ToString[N[Abs[alpha_ren - 1/127.9]/(1/127.9)*100]] <> "%"];
W[""];

(* --- 10. N^2 implicato --- *)
G5_over_L3 = Abs[ratio];
N2 = Pi/(2*G5_over_L3);
W["=== N^2 IMPLICATO ==="];
W["G5/L^3 = " <> ToString[N[G5_over_L3]]];
W["N^2 = pi/(2*G5/L^3) = " <> ToString[N[N2]]];
W["N = " <> ToString[N[Sqrt[N2]]]];
W["(per confronto: N=4 SYM ha N=numero di colori, tipico N>>1)"];
W[""];
W["=== FINE ==="];
Print["Completato: ", outputFile];
