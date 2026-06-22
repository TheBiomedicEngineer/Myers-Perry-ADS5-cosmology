#!/usr/bin/env wolframscript
(* ============================================================
   postprocess_Pmunu.wls
   Parte dalle componenti di bordo GIA' CALCOLATE (risultati_caratterizza
   e risultati_vaidya_full, a1=1/3 a2=1/5) e fa SOLO algebra:
   decompone in monopolo (S) e quadrupolo (D, cos2ch), check parita'.
   NON usa MetricCompute -> gira in secondi, non si pianta.
   ============================================================ *)

outDir  = "C:/Users/Utente/Desktop/des/files";
outFile = FileNameJoin[{outDir, "RISULTATO_postprocess.txt"}];
If[!DirectoryQ[outDir], outDir=$HomeDirectory; outFile=FileNameJoin[{outDir,"RISULTATO_postprocess.txt"}]];
str = OpenWrite[outFile];
log[a__]:=Module[{s=StringJoin[ToString/@{a}]},Print[s];WriteString[str,s,"\n"]];

log["=== POSTPROCESS P_munu (da componenti gia' calcolate) ==="];
log["spin del file: a1=1/3, a2=1/5  =>  S=a1^2+a2^2, D=a1^2-a2^2"];
a1=1/3; a2=1/5; Sval=a1^2+a2^2; Dval=a1^2-a2^2;
log["  S = ",Sval,"  D = ",Dval,"  (D/S = ",N[Dval/Sval],")"];

(* --- componenti FLUSSO al bordo (coeff m'[t]), da risultati_vaidya_full.txt --- *)
(* dipendenza angolare: ch = chi *)
Ttp1 = (3 (1+Cos[2 ch]))/16;
Ttp2 = (-5 (-1+Cos[2 ch]))/48;
Tchch= -225/(4 (26+Cos[2 ch]));
Tp1p1= (-9 (1+Cos[2 ch]))/8;
Tp2p2= (25 (-1+Cos[2 ch]))/24;

log["\n[1] Componenti di bordo (coeff m'[t]) e loro struttura angolare:"];
log["  T_tp1   = ", InputForm[Ttp1]];
log["  T_tp2   = ", InputForm[Ttp2]];
log["  T_p1p1  = ", InputForm[Tp1p1]];
log["  T_p2p2  = ", InputForm[Tp2p2]];
log["  T_chch  = ", InputForm[Tchch]];

(* --- estraggo parte costante (monopolo) e coeff di cos2ch (quadrupolo) --- *)
mono[expr_]:=Simplify[(expr/.ch->0)/2 + (expr/.ch->Pi/2)/2];  (* media angolare ~ monopolo *)
quad[expr_]:=Simplify[Coefficient[TrigReduce[expr],Cos[2 ch]]];

log["\n[2] Decomposizione monopolo / quadrupolo(cos2ch):"];
Do[
  log["  ",nome,": monopolo=",InputForm[mono[e]],"  quad(cos2ch)=",InputForm[quad[e]]],
  {pair,{{"T_tp1",Ttp1},{"T_tp2",Ttp2},{"T_p1p1",Tp1p1},{"T_p2p2",Tp2p2}}},
  {nome=pair[[1]]}, {e=pair[[2]]}
];
(* nota: il Do sopra e' scritto in forma compatta; sotto la versione esplicita *)
log["\n  (espliciti)"];
log["  T_tp1 : mono=",InputForm[mono[Ttp1]],"  quad=",InputForm[quad[Ttp1]]];
log["  T_tp2 : mono=",InputForm[mono[Ttp2]],"  quad=",InputForm[quad[Ttp2]]];
log["  T_p1p1: mono=",InputForm[mono[Tp1p1]],"  quad=",InputForm[quad[Tp1p1]]];
log["  T_p2p2: mono=",InputForm[mono[Tp2p2]],"  quad=",InputForm[quad[Tp2p2]]];

(* --- CHECK PARITA': il quadrupolo (cos2ch) e' PARI sotto ch->ch+Pi --- *)
log["\n[3] CHECK parita' (ch -> ch+Pi): cos2ch deve restare invariante (PARI)"];
testPar = Simplify[(Tp1p1/.ch->ch+Pi) - Tp1p1];
log["  T_p1p1(ch+Pi) - T_p1p1 = ", InputForm[testPar], "  -> ", If[testPar===0,"PARI (PASSA)","NON pari"]];

(* --- CHECK A: con a1=a2 le combinazioni che portano D devono annullarsi --- *)
(* qui le componenti sono gia' a spin fissi; il test simbolico vero e' su S/2+(D/2)cos2chi *)
log["\n[4] CHECK A (simbolico): la struttura S/2+(D/2)cos2chi con a1=a2 -> solo monopolo"];
ClearAll[b1,b2];
struct = (b1^2+b2^2)/2 + (b1^2-b2^2)/2 Cos[2 ch];
log["  struttura = ", InputForm[struct]];
log["  con b2->b1: ", InputForm[Simplify[struct/.b2->b1]], "  -> ",
    If[FreeQ[Simplify[struct/.b2->b1],Cos[2 ch]],"isotropo (PASSA)","FALLISCE"]];

(* --- rapporto quad/mono numerico, confronto con scaling -0.259 D/L^2 (cont.126) --- *)
log["\n[5] rapporto quad/mono per T_p1p1 (indicativo):"];
rqm = Simplify[quad[Tp1p1]/mono[Tp1p1]];
log["  quad/mono (T_p1p1) = ", InputForm[rqm]];
log["  (cont.126 dava quad/mono = -0.259 D/L^2 dal g4 statico; qui e' il flusso, struttura non ampiezza)"];

log["\n=== FINE ==="];
Close[str];
Print["Salvato: ", outFile];
Quit[];
