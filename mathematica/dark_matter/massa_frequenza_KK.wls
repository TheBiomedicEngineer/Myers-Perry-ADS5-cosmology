#!/usr/bin/env wolframscript
(* ============================================================
   CONTO (B): massa strappata -> frequenza, con riduzione KK 5D->4D
   ------------------------------------------------------------
   Verifica il processo ipotizzato:
   1. campo massivo nel bulk MP-AdS5, fase eikonale (Hamilton-Jacobi)
   2. caduta verso orizzonte -> frequenza vista dalla brana
   3. LIMITE NULLO: massa->0 nel modulo, la FASE/frequenza sopravvive
   4. RIDUZIONE KK sull'angolo extra: la 5a dim diventa torre di modi
      (= spazio degli stati che si conserva, NON proiezione che butta)

   Tutte le tappe scrivono su file con timestamp (regola export).
   Conto puramente classico/eikonale: nessun pacchetto xAct necessario qui,
   solo algebra. Se serve la geometria completa, agganciare a vaidya_ks_full.
   ============================================================ *)

out = "C:\\Users\\Utente\\Desktop\\des\\files\\massa_frequenza_KK.txt";
str = OpenWrite[out];
log[s_] := (WriteString[str, s <> "\n"]; Flush[str]; Print[s]);
log["=== massa->frequenza + KK 5D->4D === " <> DateString[]];
log[""];

(* ---- 1. METRICA MP-AdS5 (forma diagonale semplificata al bordo) ----
   coordinate: t, r, chi, phi1, phi2
   chi = angolo che distingue i due piani di rotazione (l'asimmetria a1,a2)
   La "quinta dimensione" da ridurre KK: prendiamo phi2 come la direzione
   che NON vive sulla brana 4D (brana = t,r,chi,phi1). [A dichiarata]
   Metrica modello (bordo AdS5, L=1, due spin a1,a2 piccoli): *)
a1 = 1/3; a2 = 1/5;
(* funzione di lapse semplificata vicino al bordo; mu = parametro di massa BH *)
Clear[r, mu, chi];
Delta = r^2 + 1 - mu/r^2;   (* L=1 *)
(* metrica diagonale efficace (i termini di trascinamento li trattiamo a parte) *)
gtt = -(Delta/r^2);
grr = r^2/Delta;
gchichi = r^2;
gphi1 = (r^2 + a1^2) Sin[chi]^2;
gphi2 = (r^2 + a2^2) Cos[chi]^2;
log["1. METRICA MP-AdS5 (bordo, diagonale efficace) impostata."];
log["   g_tt = " <> ToString[gtt, InputForm]];
log["   g_phi2 (quinta dir KK) = " <> ToString[gphi2, InputForm]];
log[""];

(* inverse diagonali *)
guu = {1/gtt, 1/grr, 1/gchichi, 1/gphi1, 1/gphi2};
log["2. CAMPO MASSIVO: Hamilton-Jacobi g^{mn} dS_m dS_n + m^2 = 0"];
(* ansatz separato: S = -omega t + W[r] + L1 phi1 + n phi2 + Theta[chi]
   omega = frequenza (energia), n = numero KK (momento sull'angolo extra) *)
Clear[omega, W, L1, nKK, Theta, m];
dS = {-omega, W'[r], Theta'[chi], L1, nKK};
HJ = Sum[guu[[i]] dS[[i]]^2, {i, 1, 5}] + m^2;
log["   HJ = 0 con S = -omega t + W[r] + Theta[chi] + L1 phi1 + nKK phi2"];
log["   equazione HJ: " <> ToString[Simplify[HJ], InputForm]];
log[""];

(* ---- 3+4. LIMITE NULLO + ruolo del numero KK ----
   Risolvo HJ per W'[r]^2 (parte radiale) e guardo due limiti: *)
Wr2 = Simplify[Solve[HJ == 0, W'[r]^2][[1, 1, 2]]];
log["3. W'[r]^2 risolto da HJ:"];
log["   W'^2 = " <> ToString[Wr2, InputForm]];
log[""];

(* frequenza propria vs frequenza al bordo: norma del vettore d'onda temporale *)
(* il LIMITE NULLO: m -> 0. Guardo cosa resta di omega e del termine KK *)
Wr2null = Simplify[Wr2 /. m -> 0];
log["4. LIMITE NULLO (m->0 nel modulo):"];
log["   W'^2|_{m=0} = " <> ToString[Wr2null, InputForm]];
log["   -> se finito e nonbanale, la fase/frequenza SOPRAVVIVE senza massa. [verifica]"];
log[""];

(* il punto KK: il termine di massa effettiva 4D viene dal momento sulla 5a dim.
   Riducendo KK, il momento nKK sull'angolo phi2 appare nelle 4 dim come una MASSA.
   Estraggo il coefficiente: nel settore 4D (t,r,chi,phi1), il termine con nKK
   gioca il ruolo di m_eff^2. *)
massaEff = Simplify[guu[[5]] nKK^2];  (* g^{phi2 phi2} nKK^2 *)
log["5. RIDUZIONE KK: il momento nKK sulla 5a dim (phi2) appare in 4D come massa eff."];
log["   m_eff^2 (da KK) = g^{phi2phi2} nKK^2 = " <> ToString[massaEff, InputForm]];
log["   valutata al bordo r->inf:"];
massaEffBordo = Limit[massaEff, r -> Infinity];
log["   m_eff^2|_{r->inf} = " <> ToString[massaEffBordo, InputForm]];
log[""];
(* a r grande g^{phi2phi2} ~ 1/(r^2 Cos^2chi) -> 0: la massa eff si DILUISCE al bordo?
   verifica del comportamento *)
log["   andamento m_eff^2 con r (chi=pi/4):"];
Do[
  val = N[massaEff /. {chi -> Pi/4, nKK -> 1, r -> rr, mu -> 1}];
  log["     r=" <> ToString[rr] <> ": m_eff^2 = " <> ToString[val]],
  {rr, {2, 5, 10, 50}}];
log[""];

(* ---- conteggio dimensioni dopo riduzione ---- *)
log["6. CONTEGGIO DIM dopo riduzione KK:"];
log["   bulk: 5 coordinate (t,r,chi,phi1,phi2)."];
log["   KK su phi2: phi2 -> torre di modi nKK (spazio degli stati, NON buttata)."];
log["   restano 4 coordinate dinamiche (t,r,chi,phi1) = brana 4D. [verifica: 4]"];
log["   La 5a dim e' conservata come indice di modo nKK = candidato 'spazio stati'."];
log[""];
log["=== INTERPRETAZIONE DA LEGGERE ==="];
log["- se m_eff^2 (da KK) e' FINITA e nonbanale: la massa 4D PUO' venire dal momento"];
log["  sulla 5a dim (meccanismo KK standard). La 'frequenza' della 5a dim = massa 4D."];
log["- se m_eff^2 si DILUISCE al bordo (->0 per r grande): la massa-da-KK svanisce sulla"];
log["  brana lontana -> il meccanismo NON regge cosi', serve la 5a dim COMPATTA (raggio finito)."];
log["- LIMITE NULLO: controllare che W'^2|_{m=0} resti sensato (fase sopravvive)."];
log[""];
log["=== fine === " <> DateString[]];
Close[str];
Print["Output scritto in: " <> out];
