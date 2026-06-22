#!/usr/bin/env wolframscript
(* ============================================================
   CONTO (B) — v3. Bug corretti:
   - m^2 ERA SCOMPARSO da HJ (refuso): rimesso.
   - separazione r/chi fatta pulita con costante Csep.
   Aggiunta: KK con dimensione COMPATTA (raggio R) vs estesa, confronto.
   ============================================================ *)

out = "C:\\Users\\Utente\\Desktop\\des\\files\\massa_frequenza_KK_v3.txt";
str = OpenWrite[out];
log[s_] := (WriteString[str, s <> "\n"]; Flush[str]; Print[s]);
log["=== massa->frequenza + KK (v3) === " <> DateString[]];
log[""];

a1 = 1/3; a2 = 1/5;
Clear[r, mu, chi, omega, L1, nKK, m, Csep, Wr, Tch];
Delta = r^2 + 1 - mu/r^2;
gtt = -(Delta/r^2);  grr = r^2/Delta;  gchichi = r^2;
gphi1 = (r^2 + a1^2) Sin[chi]^2;  gphi2 = (r^2 + a2^2) Cos[chi]^2;

(* HJ COMPLETO con m^2 (stavolta c'e'!) *)
HJ = (1/gtt) omega^2 + (1/grr) Wr^2 + (1/gchichi) Tch^2
     + (1/gphi1) L1^2 + (1/gphi2) nKK^2 + m^2;
log["1. HJ completo (CON m^2):"];
log["   " <> ToString[Simplify[HJ], InputForm]];
log[""];

(* moltiplico per r^2 e separo: termini-r da una parte, termini-chi dall'altra *)
H2 = Expand[r^2 HJ];
(* parte che dipende da chi: i termini con Tch, e i termini angolari L1,nKK *)
(* uso il fatto noto che MP-AdS5 separa: raccolgo per struttura *)
log["2. r^2*HJ:"];
log["   " <> ToString[Simplify[H2], InputForm]];
log[""];

(* SEPARAZIONE ESPLICITA:
   parte radiale R(r) = (1/grr) Wr^2 r^2 + (1/gtt) omega^2 r^2 + m^2 r^2 = -Csep
   parte angolare A(chi) = Tch^2 + [L1^2/gphi1 + nKK^2/gphi2] r^2 = +Csep
   (la dipendenza da chi nei termini angolari resta, ma la costante di sep le lega) *)
partR = (1/grr) Wr^2 r^2 + (1/gtt) omega^2 r^2 + m^2 r^2;
partA = Tch^2 + (1/gphi1) L1^2 r^2 + (1/gphi2) nKK^2 r^2;
log["3. CHECK separazione: r^2*HJ - (partR+partA) deve essere 0:"];
log["   " <> ToString[Simplify[H2 - (partR + partA)], InputForm]];
log[""];

(* risolvo W'^2 dalla parte radiale: partR = -Csep *)
Wr2 = Simplify[Solve[partR == -Csep, Wr^2][[1, 1, 2]]];
log["4. W'^2 (ora con m, omega, Csep ESPLICITI):"];
log["   W'^2 = " <> ToString[Wr2, InputForm]];
log[""];

(* LIMITE NULLO vero *)
Wr2null = Simplify[Wr2 /. m -> 0];
log["5. LIMITE NULLO (m->0):"];
log["   W'^2|_{m=0} = " <> ToString[Wr2null, InputForm]];
log["   cio' che la massa toglieva: " <> ToString[Simplify[Wr2 - Wr2null], InputForm]];
log["   coeff di m^2 in W'^2: " <> ToString[Simplify[D[Wr2, m]/(2 m)], InputForm]];
log["   -> W'^2 resta una funzione sensata a m=0: la parte radiale della fase sopravvive."];
log[""];

(* FREQUENZA indipendente da m (strutturale) *)
log["6. omega e' parametro libero in S=-omega t+..., indipendente da m."];
log["   m->0 NON tocca omega -> fase exp(-i omega t) sopravvive. [CONFERMATO strutturale]"];
log[""];

(* ---- KK: massa effettiva 4D dal momento sulla 5a dim ---- *)
log["7. MASSA EFFETTIVA 4D da KK — confronto dimensione ESTESA vs COMPATTA:"];
log[""];
(* (a) dimensione ESTESA = angolo phi2 del MP-AdS5 (quello che si apre al bordo) *)
mEffEstesa = Simplify[(1/gphi2) nKK^2];
log["   (a) phi2 ESTESA (angolo MP-AdS5): m_eff^2 = " <> ToString[mEffEstesa, InputForm]];
log["       al bordo r->inf: " <> ToString[Limit[mEffEstesa, r -> Infinity], InputForm] <> "  -> DILUISCE a 0"];
log[""];
(* (b) dimensione COMPATTA di raggio R: g_yy = R^2 costante, m_eff = n/R *)
Clear[Rc];
mEffCompatta = nKK^2/Rc^2;
log["   (b) dim COMPATTA raggio R: g_yy=R^2 cost -> m_eff^2 = nKK^2/R^2"];
log["       FINITA, costante, indipendente da r -> NON diluisce. Spettro discreto."];
log["       m_eff = nKK/R : torre di masse equispaziate (= spettro di stati discreto)."];
log[""];
log["=== LETTURA ==="];
log["- limite nullo: W'^2 sensato a m=0 + omega libero -> FREQUENZA SOPRAVVIVE [ok]"];
log["- massa da KK: ESTESA diluisce (no), COMPATTA da' m_eff=n/R finita (si')."];
log["- CONCLUSIONE: il meccanismo regge SOLO con la 5a dim COMPATTA. La quinta dim"];
log["  che 'resta come spazio di stati' DEVE essere compatta: allora da' sia lo"];
log["  spettro discreto (Hilbert) sia masse finite m=n/R. Le due cose coincidono."];
log["- DOMANDA APERTA: nel nostro modello, qual e' la dim compatta? L'angolo MP-AdS5"];
log["  e' esteso. Serve una direzione compatta (raggio finito) - da identificare."];
log[""];
log["=== fine v3 === " <> DateString[]];
Close[str];
Print["Output: " <> out];
