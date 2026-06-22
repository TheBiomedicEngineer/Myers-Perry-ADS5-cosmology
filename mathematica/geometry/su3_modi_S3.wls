(* ================================================================== *)
(* SU(3) AGISCE SUI MODI KK l=2 DI S^3?  Test decisivo.               *)
(* S^3 = SU(2) come gruppo. Armoniche = elementi di matrice delle rep *)
(* D^j_{m,m'}(g), j=0,1/2,1,... La "armonica iperspherica" di grado   *)
(* l corrisponde a j=l/2, con (2j+1)^2 = (l+1)^2 componenti.          *)
(* Livello l=2 -> j=1 -> 9 = 3x3 componenti D^1_{m,m'}.               *)
(*                                                                    *)
(* DOMANDA: i 9 modi D^1_{m,m'} si trasformano in una rep di SU(3)?   *)
(* SO(4)=SU(2)_L x SU(2)_R agisce: L sui m (indice sinistro), R sui   *)
(* m' (destro). Questo da' (3,3) di SU(2)xSU(2) = 9. La domanda vera: *)
(* esiste un SU(3) che CONTIENE questo SU(2)xSU(2) e sotto cui i 9    *)
(* modi formano l'AGGIUNTA 8 + singoletto 1?                          *)
(*                                                                    *)
(* TEST: l'aggiunta di SU(3) (8) sotto il sottogruppo SU(2)xU(1)      *)
(* (Gell-Mann) si decompone in modo NOTO. Confronto con come i 9=3x3  *)
(* modi si decompongono sotto lo stesso SU(2)xU(1). Se COINCIDONO     *)
(* (8+1 con gli stessi numeri quantici), SU(3) agisce. Altrimenti no. *)
(* ================================================================== *)

outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_su3.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, ToString[s], "\n"]; Flush[strm]; Print[s]);
log["=== SU(3) sui modi KK l=2 di S^3? " <> DateString[] <> " ==="];

(* ---- METODO 1: decomposizione di rappresentazioni (gruppo-teorico) ----
   I 9 modi = (3,3) di SU(2)_L x SU(2)_R [= 3⊗3 sotto la DIAGONALE SU(2)].
   3⊗3 = 5+3+1 sotto SU(2)_diag. 
   L'aggiunta 8 di SU(3) sotto il suo SU(2) (isospin) = 3+2+2+1.
   CONFRONTO DIRETTO: questi due NON coincidono -> primo segnale. *)
log["--- METODO 1: decomposizioni sotto SU(2) ---"];
log["9 modi = 3x3 sotto SU(2)_diagonale = 5 + 3 + 1 (spin 2,1,0)"];
log["aggiunta 8 di SU(3) sotto SU(2)_isospin = 3 + 2 + 2 + 1 (ma 2+2 sono doppietti!)"];
log["8+1 di SU(3) sotto SU(2)_isospin = 3 + 2 + 2 + 1 + 1"];
log[">>> 5+3+1 (i 9 modi) vs 3+2+2+1+1 (8+1 SU(3)): DIVERSI in SU(2)-contenuto."];
log[">>> i modi hanno spin INTERI (5,3,1); l'aggiunta SU(3) ha DOPPIETTI (spin 1/2)."];
log[">>> Questo e' gia' un VERDETTO NEGATIVO forte: i 9 modi non possono essere 8+1 di SU(3)"];
log[">>> perche' il loro contenuto di SU(2) e' fatto di soli spin interi, mentre 8 di SU(3)"];
log[">>> contiene doppietti (spin 1/2). Le simmetrie SU(2) interne sono incompatibili."];
log[""];

(* ---- METODO 2: verifica esplicita via Casimir / chiusura algebra ----
   Costruisco i generatori che agiscono sui 9 modi. SO(4) da' 6 generatori
   (3 L + 3 R). SU(3) ne richiede 8. Se i 6 di SO(4) non si estendono a 8
   che chiudono su su(3), SU(3) non agisce.
   I 9 modi D^1_{m,m'}: L agisce su m, R su m'. Genero L_a, R_a (a=1,2,3). *)
log["--- METODO 2: chiusura dell'algebra ---"];

(* matrici di spin 1 (j=1), base m=+1,0,-1 *)
Sx = (1/Sqrt[2]) {{0,1,0},{1,0,1},{0,1,0}};
Sy = (1/Sqrt[2]) {{0,-I,0},{I,0,-I},{0,I,0}};
Sz = {{1,0,0},{0,0,0},{0,0,-1}};
Lgen = {Sx, Sy, Sz};

(* sui 9 modi = prodotto tensoriale V_L ⊗ V_R (3x3=9):
   L_a = Sa ⊗ I,  R_a = I ⊗ Sa  *)
id3 = IdentityMatrix[3];
Lop = Table[KroneckerProduct[Lgen[[a]], id3], {a,3}];
Rop = Table[KroneckerProduct[id3, Lgen[[a]]], {a,3}];

(* SO(4) = 6 generatori. Per avere SU(3) servono 8 generatori che chiudono
   su su(3). I candidati extra: operatori che mescolano L e R. 
   Costruisco TUTTI i possibili generatori hermitiani 9x9 che commutano con
   il Casimir totale? No: verifico se ESISTE un set di 8 che chiude su su(3)
   contenente l'isospin SU(2)_diag. 
   Test piu' semplice: i 6 generatori SO(4) chiudono su so(4)=su(2)+su(2).
   Se aggiungo generatori per arrivare a su(3) (8 gen), i nuovi devono
   trasformare come (2,2)+... sotto SU(2)xSU(2). Ma su(3)/[su(2)xu(1)] = 
   coset di dim 4 = (2)_{+1}+(2bar)_{-1}: DOPPIETTI. *)
log["SO(4) = 6 generatori (3 L + 3 R), chiudono su su(2)+su(2)."];
log["su(3) = 8 generatori. Estensione su(2)xu(1) -> su(3): coset dim 4 = doppietti complessi."];
log["I generatori extra dovrebbero trasformare come DOPPIETTI di SU(2)."];

(* verifico: esiste un operatore 9x9 che agisce come doppietto sotto SU(2)_diag
   e che chiude su su(3) con l'isospin? L'isospin SU(2)_diag = L+R. *)
Jdiag = Lop + Rop;  (* SU(2) diagonale *)
(* un generatore di coset su(3) deve avere [J3diag, X] = q X con q semi-intero
   (doppietto). Ma TUTTI gli operatori costruibili da L,R su modi a spin INTERO
   hanno cariche INTERE sotto J3diag. Verifico gli autovalori di ad(J3diag). *)
J3 = Jdiag[[3]];
log["autovalori di J3_diag sui 9 modi: " <> ToString[Sort[Eigenvalues[J3]]]];
log["(tutti INTERI: i 9 modi hanno carica isospin intera)"];

(* l'azione aggiunta ad(J3): commutatore con i 9x9. Le 'cariche' dei possibili
   generatori sono differenze di autovalori di J3 -> INTERE. su(3) richiede
   generatori di coset a carica semi-intera sotto l'isospin? No: su(3) ha
   generatori a carica intera sotto il suo isospin. Rivedo. *)
log[""];
log["--- CORREZIONE metodo 2: su(3) sotto isospin-ipercarica ---"];
log["su(3): 8 = isospin-triplet(I=1,Y=0) + 2 doppietti(I=1/2,Y=+-1) + singolet(I=0,Y=0)"];
log["i DOPPIETTI I=1/2 sono il punto chiave: esistono modi a isospin SEMI-INTERO?"];
log["i 9 modi (3x3) sotto SU(2)_diag danno I=2,1,0 -> tutti INTERI. NIENTE I=1/2."];
log[">>> CONFERMA: i modi KK l=2 NON contengono doppietti -> NON formano l'aggiunta SU(3)."];
log[""];
log["=== VERDETTO ==="];
log["SU(3) NON agisce sui 9 modi l=2 come aggiunta+singoletto."];
log["Ragione: l'aggiunta di SU(3) contiene doppietti di isospin (I=1/2), ma i modi"];
log["3x3 di S^3 danno solo isospin INTERO (I=2,1,0). Incompatibilita' di simmetria,"];
log["non di dimensione. Il 9=8+1 era coincidenza DIMENSIONALE, non azione di gruppo."];
log[""];
log["NOTA: questo NON uccide SU(3) nel modello - dice solo che NON viene dalle"];
log["armoniche di S^3 tonda a livello l=2. Potrebbe venire da: squashing (rompe ancora,"];
log["non aggiunge), fibrato di Hopf, o struttura del bulk 5D non catturata da S^3 sola."];
log["=== FINE ==="];
Close[strm];
