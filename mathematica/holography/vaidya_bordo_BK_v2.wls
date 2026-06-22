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

(* ---- CHECK RAPIDO NORMALIZZAZIONE (5 s, prima della parte pesante) ----
   Per AdS: g^rr ~ r^2/L^2, quindi 1/lapse = sqrt(g^rr) ~ r/L.
   Il fattore conforme del bordo BK e' proprio (r/L) (ovvero 1/lapse).
   Verifico l'ordine leading in r di gam_ab/r^2 (deve tendere a finito). *)
lapseInv = Simplify[1/lapse, TimeConstraint -> 60];
log["leading 1/lapse in r (atteso ~ r/L = r): " <>
    ToString[Series[(lapseInv /. {m[t]->0, x->Pi/5}), {r, Infinity, 1}]]];
log["leading gam_xx/r^2 (atteso finito): " <>
    ToString[Limit[gam[[2,2]]/r^2 /. x->Pi/5, r->Infinity]]];


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

(* ====================================================================
   TENSORE DI BORDO BK per AdS5 (d=4) -- FORMULA CORRETTA.
   Brown-York: T^BY_ab = K_ab - K gam_ab  (con 8piG=1).
   Counterterm di Balasubramanian-Kraus per AdS5 (L=1):
     T^ct_ab = -(d-1)/L gam_ab - L/(d-2) ( Ric_ab[gam] - 1/2 R[gam] gam_ab )
             = -3 gam_ab - (1/2)( Ric4_ab - 1/2 R4 gam_ab ).
   Questi coefficienti sono FISSI (non liberi): -3 e -1/2 cancellano le
   divergenze r^2 e log per costruzione. Il mio errore in v1 era lasciarli
   liberi e imporli SBAGLIATO sugli ordini in r del frame NON riscalato.
   Il bordo conforme richiede il riscalamento: gamma_ab cresce ~ r^2,
   quindi T_ab[BK] e' FINITO ma la METRICA di bordo e' g0_ab = lim r^-2 gam_ab.
   Il tensore CFT fisico: T^CFT_ab = lim_{r->inf} r^2 * T^BK_ab (peso conforme). *)

c1fix = -3; c2fix = -1/2;   (* AdS5, L=1: FISSI da BK *)
Tbk[a_, b_] := Kab[[a, b]] - Ktr gam[[a, b]]
   + c1fix gam[[a, b]]
   + c2fix (Ric4[[a, b]] - (1/2) R4 gam[[a, b]]);

log["=== TEST CANCELLAZIONE (ordini divergenti devono sparire) ==="];
tic;
Do[Module[{ser = Series[Tbk[a, b], {r, Infinity, 2}], divs},
   divs = Table[Simplify[SeriesCoefficient[ser, -n], TimeConstraint -> 90],
                {n, -2, 0}];  (* coeff di r^2, r^1, r^0 *)
   log["T_bk[" <> ToString[a] <> "," <> ToString[b] <> "] ordini (r^2,r^1,r^0): "
       <> ToString[InputForm[divs]]];
  ], {a, 1, 2}, {b, a, 2}];
toc["test cancellazione (T_tt, T_tx, T_xx)"];

log["Se sopra i coeff di r^2 e r^1 NON sono 0 -> il frame ha ancora bisogno"];
log["del fattore conforme; procedo comunque all'estrazione del coeff fisico r^-2."];

(* ---- TENSORE CFT: coefficiente conforme (ordine fisico) ----
   Per AdS5 il dato di bordo sta all'ordine r^-2 dopo la sottrazione,
   moltiplicato per il volume conforme. Estraggo direttamente quel coeff. *)
Tcft[a_, b_] := Module[{ser},
   ser = Series[Tbk[a, b], {r, Infinity, 4}];
   Simplify[SeriesCoefficient[ser, 2], TimeConstraint -> 180]]; (* coeff r^-2 *)

(* ---- TARATURA STATICA: m->M0, quad/mono atteso -0.259 D ---- *)
log["=== TARATURA STATICA m->M0 ==="];
tic;
fttST = Simplify[
   Tcft[1, 1] /. {m[t] -> M0, m'[t] -> 0, m''[t] -> 0},
   TimeConstraint -> 240];
fttST = TrigReduce[fttST];
log["T_tt^CFT statico (coeff r^-2): " <> ToString[InputForm[fttST]]];
monoM = Simplify[D[fttST, M0] /. {Cos[2 x] -> 0, Cos[4 x] -> 0}];
quadM = Simplify[Coefficient[D[fttST, M0], Cos[2 x]]];
log["mono(coeff M0): " <> ToString[InputForm[monoM]]];
log["quad(coeff M0): " <> ToString[InputForm[quadM]]];
If[monoM =!= 0,
  log["RAPPORTO quad/mono = " <> ToString[N[quadM/monoM]] <>
      "   atteso -0.259*D = " <> ToString[N[-0.259*DD]]]];
toc["taratura statica"];

(* ---- PARTE DI FLUSSO: coeff di m'[t] per componente ---- *)
log["=== PARTE DI FLUSSO (coeff di m'[t]) ==="];
tic;
Do[Module[{cf = Simplify[D[Tcft[a, b], m'[t]], TimeConstraint -> 180]},
   If[cf =!= 0,
     log["dT[" <> ToString[a] <> "," <> ToString[b] <> "]/dm' = " <>
         ToString[InputForm[TrigReduce[cf]]]]]],
  {a, 1, 4}, {b, a, 4}];
toc["flusso"];

(* ---- TRACCIA parte di flusso (Step B planare: 0) ---- *)
tic;
TrCFT = Simplify[Sum[gamInv[[a, b]] Tcft[a, b], {a, 4}, {b, 4}],
   TimeConstraint -> 240];
log["traccia CFT, coeff di m' (Step B: 0 esatto): " <>
    ToString[InputForm[Simplify[D[TrCFT, m'[t]]]]]];
toc["traccia"];

log["=== FINE " <> DateString[] <> " ==="];
Close[strm];
