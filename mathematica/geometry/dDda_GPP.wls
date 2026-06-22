(* ================================================================ *)
(* dD/da CON RELAZIONI ESATTE Myers-Perry-AdS5 (Gibbons-Perry-Pope)  *)
(* Obiettivo: verificare se D = a1^2-a2^2 resta piccolo sotto il     *)
(* vincolo osservativo (~0.077) quando il flusso lo allarga, col     *)
(* freno del tetto di estremalita'. Il conto Python (cont.170) dava  *)
(* D~0.03 con struttura ESSENZIALE; qui le formule COMPLETE GPP.     *)
(* Niente normalizzazioni a mano se non l'ampiezza del flusso kJ.    *)
(* Export robusto: stream aperto una volta, Flush dopo ogni riga.    *)
(* ================================================================ *)

outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_dDda.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, s, "\n"]; Flush[strm]; Print[s]);
log["=== dD/da GPP esatto " <> DateString[] <> " ==="];

(* ---------------------------------------------------------------- *)
(* RELAZIONI ESATTE Gibbons-Perry-Pope per Myers-Perry-AdS5 (L=1).   *)
(* Rif: Gibbons, Perry, Pope, "The First Law of Thermodynamics for   *)
(* Kerr-Anti-de Sitter Black Holes" (hep-th/0408217), d=5.           *)
(* Xi_i = 1 - a_i^2 (L=1). Parametri: m (massa), a1, a2.             *)
(* Massa ed momenti angolari fisici:                                 *)
(*   M = (pi m / 4) * (1/Xi1 + 1/Xi2 + ... ) -> uso la forma d=5:    *)
(*   M = (pi m (2 Xi1 + 2 Xi2 - Xi1 Xi2)) / (4 Xi1^2 Xi2^2)          *)
(*   J_i = (pi m a_i) / (2 Xi_i^2 Xi_j)   (j != i)                   *)
(* (forma standard d=5 GPP; il punto chiave e' la struttura in Xi)   *)
(* ---------------------------------------------------------------- *)
Xi[a_] := 1 - a^2;
Mass[m_, a1_, a2_] := (Pi m (2 Xi[a1] + 2 Xi[a2] - Xi[a1] Xi[a2])) / (4 Xi[a1]^2 Xi[a2]^2);
J1[m_, a1_, a2_] := (Pi m a1) / (2 Xi[a1]^2 Xi[a2]);
J2[m_, a1_, a2_] := (Pi m a2) / (2 Xi[a2]^2 Xi[a1]);

log["Relazioni GPP definite. Test a a1=a2=0: M, J -> "];
log["  M(m=1,0,0) = " <> ToString[N[Mass[1, 0, 0]]] <> " (atteso pi/2=1.571)"];
log["  J1(m=1,0.3,0.2) = " <> ToString[N[J1[1, 3/10, 2/10]]]];

(* ---------------------------------------------------------------- *)
(* EVOLUZIONE. Il flusso aggiunge massa e momento seguendo la campana *)
(* sul fattore di scala cosmico a_cos. Picco a z=1.5 -> a_pk=0.4.    *)
(* dm/dlna, dJ_i/dlna seguono la campana; rapporto flussi momento    *)
(* 1.8:1 (derivato, cont.165). Invertiamo le relazioni GPP per       *)
(* trovare da_i/dlna dato dJ_i e dm.                                 *)
(* ---------------------------------------------------------------- *)
apk = 1/(1 + 3/2);   (* a al picco, z=1.5 *)
bell[ac_] := With[{x = ac/apk}, x^2/(1 + x^(2 + 5/3))];

(* Sistema: incognite m[t], a1[t], a2[t] con t = log(a_cos).         *)
(* dJ1 = 1.8 kJ bell, dJ2 = 1.0 kJ bell, dm = kM bell.               *)
(* Ma J_i = J_i(m,a1,a2): differenziamo e invertiamo per da_i.       *)
(* dJ_i = dJ_i/dm dm + dJ_i/da1 da1 + dJ_i/da2 da2.                  *)
(* Risolvo il sistema lineare 2x2 per {da1, da2} dato {dJ1,dJ2,dm}.  *)

kJ = 15/100;   (* ampiezza momento - UNICO parametro a mano *)
kM = 1;        (* ampiezza massa *)

evolve[a1i_, a2i_, m0_] := Module[{sol, sys, da1, da2, dm, eqs, t, m, x1, x2, ac},
  sol = NDSolve[{
     m'[t]  == kM bell[Exp[t]],
     (* derivate totali dei J rispetto a t, uguagliate ai flussi *)
     D[J1[m[t], x1[t], x2[t]], t] == (18/10) kJ bell[Exp[t]],
     D[J2[m[t], x1[t], x2[t]], t] == (10/10) kJ bell[Exp[t]],
     m[Log[2/100]] == m0, x1[Log[2/100]] == a1i, x2[Log[2/100]] == a2i
     },
    {m, x1, x2}, {t, Log[2/100], 0},
    MaxSteps -> 200000, Method -> "StiffnessSwitching"];
  {x1[0], x2[0]} /. sol[[1]]
];

log[""];
log["--- EVOLUZIONE (GPP esatto), vari spin iniziali ---"];
log[StringPadLeft["a1_i", 8] <> StringPadLeft["a2_i", 8] <> StringPadLeft["a1_oggi", 11] <> StringPadLeft["a2_oggi", 11] <> StringPadLeft["D_oggi", 11]];
Do[
  Module[{res, a1f, a2f, Df},
    res = Quiet[Check[evolve[ai[[1]], ai[[2]], 1/5], {-1, -1}]];
    a1f = res[[1]]; a2f = res[[2]]; Df = a1f^2 - a2f^2;
    log[StringPadLeft[ToString[N[ai[[1]]]], 8] <> StringPadLeft[ToString[N[ai[[2]]]], 8] <>
        StringPadLeft[ToString[N[a1f, 5]], 11] <> StringPadLeft[ToString[N[a2f, 5]], 11] <>
        StringPadLeft[ToString[N[Df, 5]], 11]];
  ],
  {ai, {{3/10, 2/10}, {15/100, 10/100}, {8/100, 5/100}, {4/100, 2/100}, {1/100, 1/1000}}}
];

log[""];
log["--- TEST CRUCIALE: D iniziale = 0 esatto (spin uguali). Il flusso genera D? ---"];
Do[
  Module[{res, Df},
    res = Quiet[Check[evolve[a0, a0, 1/5], {-1, -1}]];
    Df = res[[1]]^2 - res[[2]]^2;
    log["  a1=a2=" <> ToString[N[a0]] <> " -> D oggi = " <> ToString[N[Df, 6]]];
  ],
  {a0, {2/10, 1/10, 5/100}}
];

log[""];
log["VINCOLO osservativo: D < 0.077 (cont.159). Confronto col D oggi sopra."];
log["Se D_oggi < 0.077 per spin iniziali ragionevoli -> COMPATIBILE (conferma Python cont.170)."];
log["Se D_oggi > 0.077 -> i coefficienti GPP esatti RIBALTANO la stima -> problema anisotropia."];
log["=== FINE " <> DateString[] <> " ==="];
Close[strm];
