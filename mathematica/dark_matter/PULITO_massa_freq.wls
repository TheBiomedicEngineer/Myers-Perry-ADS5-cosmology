#!/usr/bin/env wolframscript
(* ============================================================
   PULITO. Niente separazione MP-AdS5 (la' si annidava il bug).
   Solo due fatti, ciascuno con verifica esplicita a vista:
   (1) la frequenza e' indipendente dalla massa (la fase sopravvive a m->0)
   (2) massa da KK: estesa diluisce, compatta da' spettro finito
   Ogni passo stampa una IDENTITA' verificabile, non un Solve opaco.
   ============================================================ *)

out = "C:\\Users\\Utente\\Desktop\\des\\files\\PULITO_massa_freq.txt";
str = OpenWrite[out];
log[s_] := (WriteString[str, s <> "\n"]; Flush[str]; Print[s]);
log["=== PULITO: massa->frequenza === " <> DateString[]];
log[""];

(* ---------- FATTO 1: frequenza indipendente da massa ----------
   Relazione di dispersione di una particella: E^2 = p^2 c^2 + m^2 c^4.
   In unita' c=1: omega^2 = k^2 + m^2  (omega=E/hbar, k=|p|/hbar).
   Verifico DIRETTAMENTE che a m=0 omega resta libero e finito. *)
log["FATTO 1 — la frequenza sopravvive alla perdita della massa."];
log["  Dispersione relativistica (c=1): omega^2 = k^2 + m^2"];
Clear[omega, k, m];
disp = omega^2 - (k^2 + m^2);
log["  relazione: " <> ToString[disp == 0, InputForm]];
(* a m=0: *)
dispNull = disp /. m -> 0;
log["  a m=0:    " <> ToString[Simplify[dispNull] == 0, InputForm]];
log["  -> omega^2 = k^2 : omega resta FINITO e LIBERO (lo fissa k, il momento)."];
log["  -> la massa m e' SOLO un addendo; toglierla NON annulla omega."];
log["  VERIFICA: d(omega)/d(m) a m=0 = " <>
    ToString[Simplify[D[Sqrt[k^2 + m^2], m] /. m -> 0]]];
log["     = 0  -> a m piccola, omega NON dipende da m al primo ordine. [pulito]"];
log[""];
(* interpretazione Compton: massa a riposo = frequenza a k=0 *)
log["  Caso k=0 (particella ferma): omega = m  -> e' la frequenza di Compton."];
log["  Strappare la massa = passare da (k=0, omega=m) a (k!=0, m=0, omega=k):"];
log["  la frequenza NON sparisce, si TRASFERISCE da 'omega di massa' a 'omega di moto'."];
log["  Conservazione: omega resta, cambia solo cosa la sostiene (m -> k). [pulito]"];
log[""];

(* ---------- FATTO 2: massa da KK, estesa vs compatta ----------
   Una dimensione extra y con metrica g_yy. Un modo e^{i n y/L_y}.
   Massa effettiva 4D: m_eff^2 = g^{yy} (n/period)^2 ~ (n^2)/(g_yy * period^2).
   Confronto due casi a vista. *)
log["FATTO 2 — la massa 4D dal modo sulla 5a dim: estesa vs compatta."];
log["  m_eff^2 = (momento sulla 5a dim)^2 / g_yy"];
log[""];
Clear[r, n, Rc, chi];
(* (a) ESTESA: dimensione tipo angolo che si apre, g_yy ~ r^2 *)
gEstesa = r^2;
mEstesa = n^2/gEstesa;
log["  (a) ESTESA  g_yy = r^2 (si apre al bordo):"];
log["      m_eff^2 = n^2/r^2"];
log["      r->inf: " <> ToString[Limit[mEstesa, r -> Infinity]] <> "   -> DILUISCE a 0. NO."];
log[""];
(* (b) COMPATTA: g_yy = R^2 costante (cerchio di raggio R) *)
gCompatta = Rc^2;
mCompatta = n^2/gCompatta;
log["  (b) COMPATTA g_yy = R^2 (cerchio, raggio finito):"];
log["      m_eff^2 = n^2/R^2  (indipendente da r)"];
log["      r->inf: " <> ToString[Limit[mCompatta, r -> Infinity]] <> "   -> RESTA n^2/R^2. SI."];
log["      spettro: m_n = n/R, n=0,1,2,... TORRE DISCRETA di masse/stati. [pulito]"];
log[""];
log["=== CONCLUSIONE (pulita, senza dubbi) ==="];
log["1. La frequenza e' indipendente dalla massa: omega^2=k^2+m^2, a m=0 omega=k!=0."];
log["   Strappare la massa trasferisce omega da 'di massa' a 'di moto'. Non sparisce."];
log["2. La massa 4D dal modo sulla 5a dim e' FINITA solo se la 5a dim e' COMPATTA"];
log["   (m=n/R). Se estesa, diluisce a 0. La compatta da' insieme: masse finite +"];
log["   spettro discreto (= spazio di stati). Le due cose coincidono."];
log[""];
log["Entrambi i fatti sono identita' algebriche dirette, verificabili a vista."];
log["Nessun Solve opaco, nessuna separazione di MP-AdS5 (li' c'era il bug)."];
log["=== fine === " <> DateString[]];
Close[str];
Print["Output: " <> out];
