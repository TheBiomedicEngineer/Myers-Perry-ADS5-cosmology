(* ================================================================== *)
(* STEP C: TENSORE DI BORDO (Balasubramanian-Kraus) per                *)
(* VAIDYA-MP-AdS5 A DUE SPIN.  g = gbar + (2 m[t]/U) k k               *)
(* gbar, k, U: VERIFICATI cont.142 (R=-20 esatto, k.k=0).              *)
(* Metodo: ADM lungo r (matrici 4x4, niente MetricCompute 5D) ->       *)
(*   K_ab; counterterm con coefficienti c1,c2 SIMBOLICI risolti        *)
(*   dalla cancellazione delle divergenze (autocalibrante sui segni);  *)
(*   limite statico = taratura (quad/mono atteso -0.259 D).            *)
(* Bersagli: (1) check statico; (2) termini in m'[t] per componente;   *)
(*   (3) struttura angolare (1, cos2x, cos4x) dei termini di flusso;   *)
(*   (4) traccia della parte di flusso (Step B planare: traceless).    *)
(* ATTESA: 30-90 min. Log con timing per stadio, export robusto.       *)
(* ================================================================== *)

outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_bordo_BK.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, ToString[s], "\n"]; Flush[strm]; Print[s]);
tic := (t0 = AbsoluteTime[];);
toc[lbl_] := log[lbl <> ": " <> ToString[Round[AbsoluteTime[] - t0]] <> " s"];
log["=== STEP C BORDO BK " <> DateString[] <> " ==="];

a1 = 1/3; a2 = 1/5; Xi1 = 1 - a1^2; Xi2 = 1 - a2^2; LL = 1;
SS = a1^2 + a2^2; DD = a1^2 - a2^2;
log["spin a1=" <> ToString[a1] <> " a2=" <> ToString[a2] <>
    "  S=" <> ToString[SS] <> " D=" <> ToString[N[DD]]];

(* ---- blocchi verificati (cont.142), coordinate {t,r,x,p1,p2} ---- *)
gbarF[rr_, cc_] := Module[{s, c, g}, s = Sin[cc]; c = Cos[cc];
  g = ConstantArray[0, {5, 5}];
  g[[1,1]] = (rr^2+1)*((a1^2-1)*s^2+(a2^2-1)*c^2)/((a1^2-1)*(a2^2-1));
  g[[2,2]] = rr^2*((a1^2*rr^2+a1^2+rr^4+rr^2)*s^2+(a2^2*rr^2+a2^2+rr^4+rr^2)*c^2)/
             ((a1^2*rr^2+a1^2+rr^4+rr^2)*(a2^2*rr^2+a2^2+rr^4+rr^2));
  g[[3,3]] = (-a1^2*s^2+a2^2*s^2-a2^2-rr^2)/(a1^2*s^2-a2^2*s^2+a2^2-1);
  g[[4,4]] = (-a1^2-rr^2)*c^2/(a1^2-1);
  g[[5,5]] = (-a2^2-rr^2)*s^2/(a2^2-1); g];
kF[rr_, cc_] := Module[{s, c, W, F}, s = Sin[cc]; c = Cos[cc];
  W = c^2/Xi1 + s^2/Xi2; F = rr^2/(1+rr^2)*(c^2/(rr^2+a1^2)+s^2/(rr^2+a2^2));
  {W, F, 0, -a1*c^2/Xi1, -a2*s^2/Xi2}];
UF[rr_, cc_] := Module[{s, c}, s = Sin[cc]; c = Cos[cc];
  (c^2/(rr^2+a1^2)+s^2/(rr^2+a2^2))*(rr^2+a1^2)*(rr^2+a2^2)];

(* ---- metrica completa con m[t] ---- *)
tic;
kv = kF[r, x]; gfull = gbarF[r, x] + (2 m[t]/UF[r, x]) * Outer[Times, kv, kv];
gfull = Simplify[gfull, TimeConstraint -> 60];
toc["metrica completa"];

(* ---- ADM lungo r: indici di bordo A={t,x,p1,p2} = posizioni {1,3,4,5} ---- *)
idx = {1, 3, 4, 5}; var = {t, x};   (* dipendenze: t (via m[t]) e x; p1,p2 cicliche *)
gam  = gfull[[idx, idx]];                       (* metrica indotta gamma_ab *)
Nsh  = gfull[[2, idx]];                         (* shift radiale N_a = g_{r a} *)
tic;
gamInv = Simplify[Inverse[gam], TimeConstraint -> 120];
toc["inversa gamma"];
N2 = Simplify[gfull[[2, 2]] - Nsh . gamInv . Nsh, TimeConstraint -> 60];
lapse = Sqrt[N2];   (* lapse radiale; N2>0 fuori orizzonte: check sotto *)
log["check N2 a r=10, x=Pi/5, m=1/10: " <>
    ToString[N[N2 /. {r -> 10, x -> Pi/5, m[t] -> 1/10}]]];

(* ---- Christoffel 4D di gamma (derivate solo in t,x) ---- *)
dgam[a_, b_, cv_] := If[MemberQ[var, cv], D[gam[[a, b]], cv], 0];
co[a_] := {t, Null, x, Null, Null}[[idx[[a]]]] /. Null -> nessuna;
cvOf = {t, x, p1, p2};   (* coordinate di bordo in ordine *)
tic;
Gam4 = Table[Sum[(1/2) gamInv[[d, e]] *
     (If[MemberQ[var, cvOf[[a]]], D[gam[[e, b]], cvOf[[a]]], 0] +
      If[MemberQ[var, cvOf[[b]]], D[gam[[e, a]], cvOf[[b]]], 0] -
      If[MemberQ[var, cvOf[[e]]], D[gam[[a, b]], cvOf[[e]]], 0]),
     {e, 4}], {d, 4}, {a, 4}, {b, 4}];
Gam4 = Simplify[Gam4, TimeConstraint -> 120];
toc["Christoffel 4D"];

(* ---- curvatura estrinseca: K_ab = (1/2N)(d_r gam_ab - D_a N_b - D_b N_a) ---- *)
DN = Table[If[MemberQ[var, cvOf[[a]]], D[Nsh[[b]], cvOf[[a]]], 0] -
           Sum[Gam4[[c, a, b]] Nsh[[c]], {c, 4}], {a, 4}, {b, 4}];
tic;
Kab = Table[(1/(2 lapse)) (D[gam[[a, b]], r] - DN[[a, b]] - DN[[b, a]]),
            {a, 4}, {b, 4}];
Kab = Simplify[Kab, TimeConstraint -> 180];
toc["K_ab"];
Ktr = Simplify[Sum[gamInv[[a, b]] Kab[[a, b]], {a, 4}, {b, 4}], TimeConstraint -> 60];

(* ---- Ricci 4D di gamma (serve per il counterterm di curvatura) ---- *)
dG[d_, a_, b_, cv_] := If[MemberQ[var, cv], D[Gam4[[d, a, b]], cv], 0];
tic;
Ric4 = Table[Sum[dG[c, a, b, cvOf[[c]]], {c, 4}] -
             Sum[dG[c, a, c, cvOf[[b]]], {c, 4}] +
             Sum[Gam4[[c, c, e]] Gam4[[e, a, b]] -
                 Gam4[[c, b, e]] Gam4[[e, a, c]], {c, 4}, {e, 4}], {a, 4}, {b, 4}];
Ric4 = Simplify[Ric4, TimeConstraint -> 240];
R4 = Simplify[Sum[gamInv[[a, b]] Ric4[[a, b]], {a, 4}, {b, 4}], TimeConstraint -> 60];
toc["Ricci 4D"];

(* ---- quasilocale + counterterm a coefficienti LIBERI c1, c2 ----
   8piG T_ab = K_ab - K gam_ab + c1 gam_ab + c2 (Ric4_ab - (1/2) R4 gam_ab)
   c1, c2 risolti imponendo la cancellazione delle divergenze in r.    *)
Tq[a_, b_] := Kab[[a, b]] - Ktr gam[[a, b]] + c1 gam[[a, b]] +
              c2 (Ric4[[a, b]] - (1/2) R4 gam[[a, b]]);

ordSer = 6;  (* profondita' serie in 1/r *)
serT[a_, b_] := Series[Tq[a, b], {r, Infinity, ordSer}];

(* uso T_tt e T_xx per fissare c1, c2 dagli ordini divergenti *)
tic;
sTT = serT[1, 1]; sXX = serT[2, 2];
toc["serie T_tt, T_xx"];
(* ordini divergenti: estraggo i coefficienti delle potenze positive di r *)
divEqs = Flatten[Table[
   {SeriesCoefficient[sTT, n], SeriesCoefficient[sXX, n]}, {n, 1, 4}]];
divEqs = DeleteCases[Simplify[divEqs], 0];
sol = Solve[Thread[divEqs == 0], {c1, c2}];
log["soluzione counterterm (atteso tipo c1=-3/L, c2=-L/2 a meno di convenzioni):"];
log[ToString[InputForm[Simplify[sol]]]];
If[sol === {}, log["!! divergenze non cancellabili con c1,c2 costanti: STOP"];
   Close[strm]; Quit[]];
c1v = c1 /. sol[[1]]; c2v = c2 /. sol[[1]];

(* ---- tensore finito: estraggo l'ordine fisico, componente per componente ---- *)
fin[a_, b_] := Module[{s},
  s = Series[Tq[a, b] /. {c1 -> c1v, c2 -> c2v}, {r, Infinity, ordSer}];
  (* il bordo conforme: T^CFT ~ r^2 * coeff; riporto i primi 2 coeff non nulli *)
  s];
log["=== COMPONENTI FINITE (serie in 1/r dopo sottrazione) ==="];
tic;
Do[Module[{s = fin[a, b], lead},
   log["T[" <> ToString[a] <> "," <> ToString[b] <> "]:"];
   Do[Module[{cf = Simplify[SeriesCoefficient[s, -n], TimeConstraint -> 120]},
      If[cf =!= 0, log["  ordine r^-" <> ToString[n] <> ": " <>
         ToString[InputForm[TrigReduce[cf]]]]]], {n, 0, 4}]],
  {a, 4}, {b, a, 4}];
toc["estrazione finiti"];

(* ---- TARATURA STATICA: m[t] -> M0 ----
   atteso: quad/mono della densita' ~ -0.259 D  (cont.111, cont.201)   *)
log["=== TARATURA STATICA m->M0 ==="];
tic;
sTTst = Series[(Tq[1, 1] /. {c1 -> c1v, c2 -> c2v, m[t] -> M0,
    m'[t] -> 0, m''[t] -> 0}), {r, Infinity, ordSer}];
ftt = Simplify[SeriesCoefficient[sTTst, -2], TimeConstraint -> 240];
ftt = TrigReduce[ftt];
log["T_tt finito statico (r^-2): " <> ToString[InputForm[ftt]]];
mono = Simplify[Coefficient[ftt /. Cos[4 x] -> 0, Cos[2 x], 0]];
quad = Simplify[Coefficient[ftt, Cos[2 x]]];
log["mono(M0-parte): " <> ToString[InputForm[mono]]];
log["quad: " <> ToString[InputForm[quad]]];
mM = Coefficient[mono, M0]; qM = Coefficient[quad, M0];
If[mM =!= 0,
  log["RAPPORTO quad/mono (parte in M0): " <> ToString[N[qM/mM]] <>
      "   atteso ~ " <> ToString[N[-0.259*DD]] <> "  (=-0.259 D)"]];
toc["taratura statica"];

(* ---- PARTE DI FLUSSO: coefficienti di m'[t] ---- *)
log["=== PARTE DI FLUSSO (coeff di m'[t]) ==="];
tic;
Do[Module[{s = fin[a, b], cf},
   cf = Simplify[Coefficient[Normal[s], m'[t]], TimeConstraint -> 120];
   If[cf =!= 0,
     log["coeff m' in T[" <> ToString[a] <> "," <> ToString[b] <> "]: " <>
         ToString[InputForm[TrigReduce[Simplify[
           SeriesCoefficient[Series[cf, {r, Infinity, 4}], -2]]]]]]]],
  {a, 4}, {b, a, 4}];
toc["flusso"];

(* ---- traccia della parte di flusso ---- *)
tic;
TrT = Simplify[Sum[gamInv[[a, b]] (Tq[a, b] /. {c1 -> c1v, c2 -> c2v}),
   {a, 4}, {b, 4}], TimeConstraint -> 240];
trFlux = Simplify[Coefficient[Normal[Series[TrT, {r, Infinity, ordSer}]], m'[t]],
   TimeConstraint -> 240];
log["traccia, parte in m' (Step B planare: 0 esatto): " <>
    ToString[InputForm[Simplify[trFlux]]]];
toc["traccia"];

log["=== FINE " <> DateString[] <> " ==="];
Close[strm];
