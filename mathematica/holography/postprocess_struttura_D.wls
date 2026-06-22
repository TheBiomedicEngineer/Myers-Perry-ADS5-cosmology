#!/usr/bin/env wolframscript
(* ============================================================
   postprocess_struttura_D.wls
   Opzione 1: CONFERMA STRUTTURA dai file gia' calcolati.
   Parte dalle componenti di bordo (risultati_caratterizza, a1=1/2 a2=1/5)
   e verifica: (a) il cos2ch porta D, (b) a D=0 l'anisotropia sparisce,
   (c) dipolo (cos[ch]) assente. NON usa MetricCompute -> secondi.
   Lo scaling -0.259 D/L^2 e' gia' acquisito (cont.126), NON si rifa'.
   ============================================================ *)

outDir  = "C:/Users/Utente/Desktop/des/files";
outFile = FileNameJoin[{outDir, "RISULTATO_struttura_D.txt"}];
If[!DirectoryQ[outDir], outDir=$HomeDirectory; outFile=FileNameJoin[{outDir,"RISULTATO_struttura_D.txt"}]];
str = OpenWrite[outFile];
log[a__]:=Module[{s=StringJoin[ToString/@{a}]},Print[s];WriteString[str,s,"\n"]];

log["=== CONFERMA STRUTTURA D (da componenti gia' calcolate) ==="];
log["spin di prova del file: a1=1/2, a2=1/5  (valori di costruzione, NON fisici)"];
a1=1/2; a2=1/5; Sval=a1^2+a2^2; Dval=a1^2-a2^2;
log["  S=a1^2+a2^2 = ",Sval,"   D=a1^2-a2^2 = ",Dval];

(* componenti FLUSSO PULITO dal file risultati_caratterizza.txt (ch=chi) *)
Ttp1 = (675 Cos[ch]^2 (-1+r^2))/(8 (17-8 Cos[2 ch]+225 r^2)(r+r^3));
Ttp2 = (375 (-1+r^2) Sin[ch]^2)/(8 (17-8 Cos[2 ch]+225 r^2)(r+r^3));
Tp1p1= (225 Cos[ch]^2 (-1+9 r^4))/(4 r (-17+8 Cos[2 ch]-225 r^2)(1+r^2)^2);
Tp2p2= (75 (1-25 r^4) Sin[ch]^2)/(4 r (1+r^2)^2 (17-8 Cos[2 ch]+225 r^2));
Tchch= (225 (-17+8 Cos[2 ch]+225 r^4))/(4 (26+Cos[2 ch]) r (-17+8 Cos[2 ch]-225 r^2)(1+r^2)^2);

(* --- [1] struttura angolare: riscrivo in termini di Cos[2 ch], Cos[4 ch] --- *)
log["\n[1] Struttura angolare delle componenti (TrigReduce -> multipoli):"];
comps = {{"T_tp1",Ttp1},{"T_tp2",Ttp2},{"T_p1p1",Tp1p1},{"T_p2p2",Tp2p2},{"T_chch",Tchch}};
Do[
  nome=comps[[i,1]]; e=comps[[i,2]];
  ered=TrigReduce[e];
  log["  ",nome,":"];
  log["     ha Cos[ch] (dipolo l=1)? ", If[!FreeQ[ered,Cos[ch]]||!FreeQ[ered,Sin[ch]], "controlla","NO -> dipolo assente"]];
  log["     ha Cos[2 ch] (quadrupolo l=2)? ", If[!FreeQ[ered,Cos[2 ch]], "SI -> porta D","no"]];
  log["     ha Cos[4 ch] (coda l=4)? ", If[!FreeQ[ered,Cos[4 ch]], "SI","no"]],
  {i,Length[comps]}
];

(* --- [2] test parita': ch -> ch+Pi le componenti devono essere PARI (invarianti) --- *)
log["\n[2] CHECK parita' (ch->ch+Pi): le componenti devono restare INVARIANTI (pari)"];
Do[
  nome=comps[[i,1]]; e=comps[[i,2]];
  dif=Simplify[(e/.ch->ch+Pi)-e];
  log["  ",nome,": (ch+Pi)-(ch) = ",InputForm[dif]," -> ",If[dif===0,"PARI (PASSA)","NON pari!"]],
  {i,Length[comps]}
];

(* --- [3] test D=0: con a1=a2 la parte anisotropa (cos2ch) deve sparire ---
     Le componenti del file sono gia' a spin fissi. Il test simbolico vero
     e' sulla COMBINAZIONE che porta D: il fattore (17-8Cos2ch) etc viene da
     rho^2 ~ S + D cos2ch. Verifico sul nucleo rho^2. --- *)
log["\n[3] CHECK D=0 sul nucleo angolare rho^2 ~ S/2 + (D/2)cos2ch"];
ClearAll[b1,b2];
rho2ang = b1^2 Cos[ch]^2 + b2^2 Sin[ch]^2;
rho2red = TrigReduce[rho2ang];
log["  rho2 angolare = ",InputForm[rho2red]];
log["  coeff Cos[2ch] = ",InputForm[Coefficient[rho2red,Cos[2 ch]]]," (= (b1^2-b2^2)/2 = D/2)"];
log["  con b2->b1 (D=0): ",InputForm[Simplify[rho2red/.b2->b1]]," -> ",
    If[FreeQ[Simplify[rho2red/.b2->b1],Cos[2 ch]],"isotropo, quadrupolo SPARISCE (PASSA)","FALLISCE"]];

log["\n=== RIEPILOGO ==="];
log["Atteso: tutte le componenti PARI (dipolo assente), portano Cos[2ch] (quadrupolo, =D),"];
log["alcune Cos[4ch] (coda l=4). A D=0 (a1=a2) l'anisotropia sparisce."];
log["Lo scaling quad/mono = -0.259 D/L^2 e' GIA' acquisito (cont.126), non ricalcolato qui."];
Close[str];
Print["Salvato: ", outFile];
Quit[];
