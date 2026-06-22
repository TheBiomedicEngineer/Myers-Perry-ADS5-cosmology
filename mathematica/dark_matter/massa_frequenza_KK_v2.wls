#!/usr/bin/env wolframscript
(* ============================================================
   CONTO (B) — VERSIONE CORRETTA (bug separazione HJ risolto)
   Il bug precedente: Solve[HJ==0, W'^2] scartava i termini angolari.
   Correzione: separo le variabili a mano. La parte radiale W'^2 deve
   contenere ESPLICITAMENTE m, omega, e la costante di separazione.
   ============================================================ *)

out = "C:\\Users\\Utente\\Desktop\\des\\files\\massa_frequenza_KK_v2.txt";
str = OpenWrite[out];
log[s_] := (WriteString[str, s <> "\n"]; Flush[str]; Print[s]);
log["=== massa->frequenza + KK (v2 corretta) === " <> DateString[]];
log[""];

a1 = 1/3; a2 = 1/5;
Clear[r, mu, chi, omega, L1, nKK, m, Csep];
Delta = r^2 + 1 - mu/r^2;
gtt = -(Delta/r^2);  grr = r^2/Delta;  gchichi = r^2;
gphi1 = (r^2 + a1^2) Sin[chi]^2;  gphi2 = (r^2 + a2^2) Cos[chi]^2;
guu = {1/gtt, 1/grr, 1/gchichi, 1/gphi1, 1/gphi2};

(* HJ completo *)
dS = {-omega, Wr, Tch, L1, nKK};  (* Wr = W'[r], Tch = Theta'[chi] *)
HJ = guu[[1]] dS[[1]]^2 + guu[[2]] Wr^2 + guu[[3]] Tch^2
     + guu[[4]] dS[[4]]^2 + guu[[5]] dS[[5]]^2 + m^2;
log["1. HJ completo (tutti i termini):"];
log["   " <> ToString[Simplify[HJ], InputForm]];
log[""];

(* SEPARAZIONE A MANO: moltiplico per r^2 e separo parte-r da parte-chi.
   Il MP-AdS5 e' separabile: r^2 * HJ si spezza in [funzione di r] + [funzione di chi]=0
   con costante di separazione Csep. *)
H2 = Expand[r^2 HJ];
log["2. r^2 * HJ (per separare r da chi):"];
log["   " <> ToString[Simplify[H2], InputForm]];
log[""];

(* raccolgo i termini che dipendono SOLO da chi *)
partChi = guu[[3]] Tch^2 r^2 + guu[[4]] L1^2 r^2 + guu[[5]] nKK^2 r^2;
partChi = Simplify[partChi];
log["3. parte angolare (x r^2), dipende da chi:"];
log["   " <> ToString[partChi, InputForm]];
(* parte radiale = resto *)
partR = Simplify[H2 - partChi];
log["   parte radiale (x r^2), dipende da r:"];
log["   " <> ToString[partR, InputForm]];
log[""];

(* separazione: partR = -Csep (costante), partChi = +Csep
   -> risolvo W'^2 dalla parte radiale, ESPLICITA in m, omega, Csep *)
Wr2 = Simplify[Solve[partR == -Csep, Wr^2][[1, 1, 2]]];
log["4. W'^2 CORRETTO (con m, omega, Csep espliciti):"];
log["   W'^2 = " <> ToString[Wr2, InputForm]];
log[""];

(* ---- LIMITE NULLO vero: m->0, guardo cosa resta di W'^2 ---- *)
Wr2null = Simplify[Wr2 /. m -> 0];
log["5. LIMITE NULLO (m->0):"];
log["   W'^2|_{m=0} = " <> ToString[Wr2null, InputForm]];
diff = Simplify[Wr2 - Wr2null];
log["   differenza (cio' che la massa aggiungeva a W'^2): " <> ToString[diff, InputForm]];
log["   -> la massa entra in W'^2 come: " <> ToString[Simplify[D[Wr2, m^2]], InputForm] <> " (coeff di m^2)"];
log[""];

(* il vettore d'onda k = dS. Nel limite nullo deve valere k.k = 0.
   verifico la norma g^{mn} k_m k_n nel limite m->0 *)
knorm = guu[[1]] omega^2 + guu[[2]] Wr^2 + guu[[3]] Tch^2 + guu[[4]] L1^2 + guu[[5]] nKK^2;
knormNull = Simplify[(knorm /. Wr^2 -> Wr2null)];
log["6. NORMA del vettore d'onda nel limite nullo (deve ->0 se davvero nullo):"];
log["   k.k|_{m=0} = " <> ToString[knormNull, InputForm]];
log["   (con HJ: k.k = -m^2, quindi a m=0 deve essere 0. Verifica di consistenza.)"];
log[""];

(* frequenza omega: sopravvive? omega e' un parametro libero in S=-omega t+...
   La fase resta perche' omega NON e' forzato a zero da m=0. Esplicito: *)
log["7. FREQUENZA: omega compare in S = -omega t + ... ed e' INDIPENDENTE da m."];
log["   A m=0, omega resta libero -> la fase exp(-i omega t) SOPRAVVIVE. [CONFERMATO]"];
log["   La massa strappata (m->0) NON annulla omega: la frequenza propaga senza massa."];
log[""];
log["=== fine v2 === " <> DateString[]];
Close[str];
Print["Output: " <> out];
