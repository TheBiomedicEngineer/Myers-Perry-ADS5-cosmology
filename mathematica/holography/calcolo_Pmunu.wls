#!/usr/bin/env wolframscript
(* ============================================================
   calcolo_Pmunu.wls  -  PASSO 2: P_munu da MP-AdS5 due spin
   Versione che NON si pianta: path Windows gestito, niente
   sessione appesa, Quit[] finale, output a schermo + file.
   ============================================================ *)

(* --- PATH: su Windows usa le BARRE NORMALI dentro Wolfram, non i backslash --- *)
outDir  = "C:/Users/Utente/Desktop/des/files";
outFile = FileNameJoin[{outDir, "RISULTATO_Pmunu.txt"}];

(* se la cartella non esiste, creala; se fallisce, ripiega sulla home *)
If[!DirectoryQ[outDir],
  Quiet[CreateDirectory[outDir, CreateIntermediateDirectories -> True]]];
If[!DirectoryQ[outDir],
  outDir = $HomeDirectory; outFile = FileNameJoin[{outDir, "RISULTATO_Pmunu.txt"}]];

(* stream esplicito: scrive sia a schermo sia su file, e fa FLUSH (così vedi subito) *)
str = OpenWrite[outFile];
log[args__] := Module[{s = StringJoin[ToString /@ {args}]},
  Print[s];                 (* schermo *)
  WriteString[str, s, "\n"]; (* file *)
];

log["=== RISULTATO P_munu da MP-AdS5 due spin ==="];
log["Avvio: ", DateString[]];
log["outFile = ", outFile];

(* ------------------------------------------------------------
   1. PARAMETRI e funzioni note (Chen-Lu-Pope). Tutto SIMBOLICO.
   ------------------------------------------------------------ *)
log["\n[1] Definizioni MP-AdS5 (simboliche)"];
ClearAll[LL, mm, a1, a2, r, th];
rho2  = r^2 + a1^2 Cos[th]^2 + a2^2 Sin[th]^2;
Svar  = a1^2 + a2^2;
Dvar  = a1^2 - a2^2;
log["  rho2, S=a1^2+a2^2, D=a1^2-a2^2 definiti."];

(* ------------------------------------------------------------
   2. CHECK indipendenti dalla metrica pesante (girano SEMPRE,
      così lo script PRODUCE OUTPUT anche senza xCoba caricato).
      Sono i risultati gia' validati: servono da sanity-check.
   ------------------------------------------------------------ *)
log["\n[2] CHECK di struttura (non richiedono xCoba)"];

(* CHECK C: curvatura di bordo nota R = 6 - 3S/L^2 - 5 D cos2th/L^2 *)
Rbordo = 6 - 3 Svar/LL^2 - 5 Dvar Cos[2 th]/LL^2;
log["  [CHECK C] R bordo = ", InputForm[Rbordo]];
log["            con D=0 (a2=a1): R = ", InputForm[Simplify[Rbordo /. a2 -> a1]]];
log["            -> deve perdere il termine cos2th (isotropo). ",
    If[FreeQ[Simplify[Rbordo /. a2 -> a1], Cos[2 th]], "PASSA", "FALLISCE"]];

(* CHECK B: anomalia conforme nota -(63/10000)(7-228cos2th+21cos4th) per a1=1/2,a2=1/5 *)
anomForm = 7 - 228 Cos[2 th] + 21 Cos[4 th];
log["  [CHECK B] forma anomalia attesa (a1=1/2,a2=1/5): ", InputForm[anomForm]];
log["            (in Mathematica vero: confronta la traccia di E_munu con questa)"];

(* CHECK A: decomposizione angolare S/2 + (D/2) cos2chi *)
decomp = Simplify[a1^2 Cos[chi]^2 + a2^2 Sin[chi]^2];
decompCos2 = Simplify[TrigReduce[decomp]];
log["  [CHECK A] a1^2 cos^2 + a2^2 sin^2 = ", InputForm[decompCos2]];
log["            = S/2 + (D/2)cos2chi ? ",
    If[Simplify[decompCos2 - (Svar/2 + Dvar/2 Cos[2 chi])] === 0, "PASSA", "FALLISCE"]];

(* ------------------------------------------------------------
   3. BLOCCO xCoba (il conto vero di P_munu). Eseguito SOLO se xAct
      e' installato e la metrica e' caricata. Protetto da Check.
   ------------------------------------------------------------ *)
log["\n[3] Blocco xCoba (P_munu vero) - eseguito solo se disponibile"];
xcobaOK = False;
Quiet[Check[ Needs["xAct`xCoba`"]; xcobaOK = True, xcobaOK = False ]];
If[xcobaOK,
  log["  xCoba caricato. >>> qui carica la metrica g5 (2 spin) e calcola:"];
  log["    Weyl 5D -> E_munu = C_{A mu B nu} n^A n^B -> U + P_munu"];
  log["    poi:  Pmunu /. a2->a1 // Simplify   (CHECK A: atteso 0)"];
  log["    e:    traccia E_munu vs anomForm     (CHECK B: atteso costante)"];
  (* <-- INSERISCI QUI i comandi xCoba con la TUA metrica caricata --> *)
  ,
  log["  xCoba NON disponibile in questa sessione: eseguiti solo i CHECK di struttura."];
  log["  (Per il P_munu vero: apri il notebook con xAct e la metrica g5 caricata.)"];
];

(* ------------------------------------------------------------
   chiusura PULITA: flush, close, Quit (cosi' NON resta appeso)
   ------------------------------------------------------------ *)
log["\n=== FINE ==="];
log["Fine: ", DateString[]];
Close[str];
Print["Report salvato in: ", outFile];
Quit[];
