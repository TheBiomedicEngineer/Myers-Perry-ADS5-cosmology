(* ============================================================
   calcolo_Pmunu.wl
   PASSO 2 — Derivare il quadrupolo via P_munu (proiezione SMS)
   dal bulk Myers-Perry-AdS5 a due spin.

   Stampa a schermo E salva un report su file.
   Richiede: xAct + xCoba installati.

   >>> CAMBIA SOLO QUESTA RIGA col percorso giusto sul TUO computer <<<
   ============================================================ *)

outDir = "/mnt/user-data/outputs/";   (* <-- metti qui il TUO percorso *)
outFile = FileNameJoin[{outDir, "RISULTATO_Pmunu.txt"}];

(* apertura log: scrive sia a schermo sia su file *)
log[args__] := Module[{s},
  s = StringJoin[ToString /@ {args}];
  Print[s];
  WriteString[outFile, s <> "\n"];
];
If[FileExistsQ[outFile], DeleteFile[outFile]];
WriteString[outFile, "=== RISULTATO P_munu da MP-AdS5 due spin ===\n"];
log["Avvio: ", DateString[]];

(* ------------------------------------------------------------
   1. METRICA Myers-Perry-AdS5, coordinate Boyer-Lindquist
      due spin a1,a2 ; raggio AdS L ; massa-parametro mm.
      Coord: t, r, theta, phi, psi   (phi,psi = due angoli azimutali)
   ------------------------------------------------------------ *)
log["\n[1] Costruzione metrica MP-AdS5 (BL, due spin)"];

(* Per il calcolo simbolico pesante useremo xCoba. Qui imposto i blocchi.
   Funzioni note (Chen-Lu-Pope / Awad):  *)
Clear[L, mm, a1, a2, r, th];
DeltaTheta = 1 - (a1^2/L^2) Cos[th]^2 - (a2^2/L^2) Sin[th]^2;
rho2 = r^2 + a1^2 Cos[th]^2 + a2^2 Sin[th]^2;
DeltaR = (1/r^2) (r^2 + a1^2)(r^2 + a2^2)(1 + r^2/L^2) - 2 mm;
Xi1 = 1 - a1^2/L^2;
Xi2 = 1 - a2^2/L^2;

(* NOTA OPERATIVA: la metrica completa g_AB in BL e' nota (cont.103 la usava).
   Caricare QUI il file metrica gia' validato se disponibile, es:
     << g5MPAdS_2spin.wl
   altrimenti ricostruirla dalle componenti Chen-Lu-Pope.
   Lasciato esplicito per non assumere una forma sbagliata (regola 4). *)

log["  DeltaTheta, rho2, DeltaR, Xi1, Xi2 definiti."];
log["  >>> caricare qui g5 (metrica 5D validata cont.103) prima di proseguire."];

(* ------------------------------------------------------------
   2. WEYL 5D del bulk:  C_ABCD
      In xCoba: DefManifold, DefMetric, poi RiemannCD, RicciCD, e Weyl.
   ------------------------------------------------------------ *)
log["\n[2] Tensore di Weyl 5D (xCoba: WeylCD[-A,-B,-C,-D])"];
log["  comando tipico: cw = WeylCD[-A,-B,-C,-D] // ToValues // ComponentArray // Simplify;"];

(* ------------------------------------------------------------
   3. PROIEZIONE sulla brana: E_munu = C_{A mu B nu} n^A n^B
      n^A = normale unitaria all'orizzonte/brana (direzione r).
      h_munu = g_munu - epsilon n_mu n_nu  (metrica indotta)
   ------------------------------------------------------------ *)
log["\n[3] Proiezione E_munu = C_{A mu B nu} n^A n^B sulla brana r=r_h~L"];
log["  n^A normale radiale unitaria; valutare a r->r_h (orizzonte grande, r_h~L)."];
log["  E_munu = proiezione 4D del Weyl. Poi al bordo r->infty per la lettura olografica."];

(* ------------------------------------------------------------
   4. DECOMPOSIZIONE  E_munu = -(k5/k4)^4 [ U(u u + 1/3 h) + P_munu ]
      U = -(1/3) E^mu_mu proiettata su u   (traccia -> monopolo)
      P_munu = parte simmetrica senza traccia ortogonale a u  (quadrupolo)
      u^mu = quadrivelocita' comovente (direzione t normalizzata)
   ------------------------------------------------------------ *)
log["\n[4] Decomposizione in U (monopolo) e P_munu (quadrupolo)"];
log["  U      = -(k^4) * (E proiettata su u u) "];
log["  P_munu = E_munu - U-part - traccia-part   (TT rispetto a u, ortog. a u)"];

(* ------------------------------------------------------------
   5. LETTURA ANGOLARE: estrarre la dipendenza in theta di U e P.
      ATTESO (NON assumere, verificare):
        U      ~ funzione di S=a1^2+a2^2  (isotropo nel limite, monopolo)
        P_munu ~ contiene D=a1^2-a2^2 , struttura cos2theta (+ coda cos4theta)
   ------------------------------------------------------------ *)
log["\n[5] Lettura angolare di U e P_munu"];

(* sostituzioni di controllo *)
Svar = a1^2 + a2^2;
Dvar = a1^2 - a2^2;

(* === CHECK AUTOMATICI (regola 12: stampano PASSA/FALLISCE) === *)
log["\n=== CHECK ==="];

(* CHECK A: con a1=a2 (D=0) il quadrupolo P_munu deve ANNULLARSI *)
log["[CHECK A] a1=a2 (D=0): P_munu deve -> 0 (quadrupolo sparisce)."];
log["  eseguire:  Pmunu /. {a2->a1} // Simplify   ==> atteso 0"];

(* CHECK B: la traccia di E_munu deve riprodurre l'anomalia conforme nota *)
log["[CHECK B] traccia E_munu (al bordo) vs anomalia conforme nota:"];
log["  atteso (a1=1/2,a2=1/5):  proporzionale a (7 - 228 Cos[2th] + 21 Cos[4th])"];
log["  confronto: Simplify[ traccia / (7 - 228 Cos[2th] + 21 Cos[4th]) ]  ==> costante se torna"];

(* CHECK C: la curvatura di bordo deve dare R = 6 - 3S/L^2 - 5 D Cos[2th]/L^2 *)
log["[CHECK C] curvatura di bordo R (gia' validata cont.100):"];
log["  atteso: R == 6 - 3*Svar/L^2 - 5*Dvar*Cos[2th]/L^2   (con Svar,Dvar sopra)"];
log["  eseguire: Simplify[ Rbordo - (6 - 3*Svar/L^2 - 5*Dvar*Cos[2th]/L^2) ] ==> 0"];

(* CHECK D: scaling quadrupolo/monopolo *)
log["[CHECK D] rapporto quad/mono atteso ~ -0.259 D/L^2 (lineare in D, cont.126)"];
log["  eseguire: coeff(cos2th in P)/U  a spin piccoli  ==> ~ -0.259 D/L^2"];

(* ------------------------------------------------------------
   RIEPILOGO finale a schermo + file
   ------------------------------------------------------------ *)
log["\n=== RIEPILOGO ==="];
log["Se CHECK A=0, B=cost, C=0, D~-0.259 D/L^2: P_munu DERIVATO, quadrupolo ∝ D confermato."];
log["Se CHECK A!=0 con D=0: errore nella proiezione, FERMARSI e ricontrollare n^A e h_munu."];
log["AMPIEZZA assoluta resta separata (g4 completo). FORMA: vedi passo 2c (proiezione 4->3)."];
log["\nFine: ", DateString[]];
log["Report salvato in: ", outFile];

(* ============================================================
   NOTA: questo file imposta la STRUTTURA e i CHECK. I blocchi xCoba
   pesanti (Weyl, proiezione) vanno eseguiti con la metrica g5 validata
   caricata al punto [1]. Eseguire i CHECK uno per uno; fermarsi al primo
   che fallisce (regola 12). Non forzare un risultato atteso.
   ============================================================ *)
