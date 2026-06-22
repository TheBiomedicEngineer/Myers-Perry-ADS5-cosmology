(* ================================================================ *)
(* VERIFICA CAVEAT cont.147: T_tt del flusso e' davvero 0?          *)
(* Controlla T_tt a TUTTI gli ordini r (r^1,r^2,r^3,r^4) e testa    *)
(* la struttura null dust: T_munu = Phi k_mu k_nu ?                 *)
(* (se null dust: T_tt/T_tp1 = k_t/k_p1, rapporto esatto)           *)
(* Stessa metrica verificata. Export robusto.                      *)
(* ================================================================ *)
Needs["xAct`xTensor`"]; Needs["xAct`xCoba`"];
outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_check_Ttt.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, s, "\n"]; Flush[strm]; Print[s]);
log["=== CHECK T_tt " <> DateString[] <> " ==="];

a1 = 1/3; a2 = 1/5; Xi1=1-a1^2; Xi2=1-a2^2;
gbarF[rr_,cc_] := Module[{s,c,g},s=Sin[cc];c=Cos[cc];g=ConstantArray[0,{5,5}];
  g[[1,1]]=(rr^2+1)*((a1^2-1)*s^2+(a2^2-1)*c^2)/((a1^2-1)*(a2^2-1));
  g[[2,2]]=rr^2*((a1^2*rr^2+a1^2+rr^4+rr^2)*s^2+(a2^2*rr^2+a2^2+rr^4+rr^2)*c^2)/((a1^2*rr^2+a1^2+rr^4+rr^2)*(a2^2*rr^2+a2^2+rr^4+rr^2));
  g[[3,3]]=(-a1^2*s^2+a2^2*s^2-a2^2-rr^2)/(a1^2*s^2-a2^2*s^2+a2^2-1);
  g[[4,4]]=(-a1^2-rr^2)*c^2/(a1^2-1); g[[5,5]]=(-a2^2-rr^2)*s^2/(a2^2-1); g];
kF[rr_,cc_] := Module[{s,c,W,F},s=Sin[cc];c=Cos[cc];
  W=c^2/Xi1+s^2/Xi2; F=rr^2/(1+rr^2)*(c^2/(rr^2+a1^2)+s^2/(rr^2+a2^2));
  {W,F,0,-a1*c^2/Xi1,-a2*s^2/Xi2}];
UF[rr_,cc_] := Module[{s,c},s=Sin[cc];c=Cos[cc];(c^2/(rr^2+a1^2)+s^2/(rr^2+a2^2))*(rr^2+a1^2)*(rr^2+a2^2)];

DefManifold[M5,5,{aa,bb,cc2,dd,ee,ff,gg,hh,pp,qq}];
DefChart[CH,M5,{0,1,2,3,4},{tt[],r[],ch[],p1[],p2[]},ChartColor->Blue];
gbarX=gbarF[r[],ch[]]; kX=kF[r[],ch[]]; UX=UF[r[],ch[]];
gfullX=Simplify[gbarX + (2 mm[tt[]]/UX) Outer[Times,kX,kX]];
DefMetric[{1,4,0},met[-aa,-bb],CD,{",","\[Del]"}];
MetricInBasis[met,-CH,gfullX];
log["MetricCompute... "<>DateString[]];
MetricCompute[met,CH,All];
log["fatto "<>DateString[]];
extract[x_]:=Module[{u},u=x;While[Head[u]===Rule,u=Last[u]];u];
Rsc=extract[RicciScalarCD[]//ToValues];
RicM=Table[extract[ComponentValue[RicciCD[{i,-CH},{j,-CH}]]],{i,0,4},{j,0,4}];
Tsrc=Simplify[RicM-(1/2)Rsc gfullX+(-6)gfullX];
mp=Derivative[1][mm][tt[]];

(* T_tt del flusso a TUTTI gli ordini *)
Ttt=Coefficient[Tsrc[[1,1]],mp];
log["--- T_tt (coeff m') a ordini r^n ---"];
Do[
  ord=Simplify[Limit[(Ttt/.r[]->rr) rr^n, rr->Infinity]];
  log["  r^"<>ToString[n]<>" -> "<>ToString[InputForm[TrigReduce[ord]]]],
  {n,{1,2,3,4,5}}];

(* TEST null dust: T_munu = Phi k_mu k_nu ? Allora T_tt T_p1p1 = (T_tp1)^2 *)
Ttp1=Coefficient[Tsrc[[1,4]],mp];
Tp1p1=Coefficient[Tsrc[[4,4]],mp];
log["--- TEST null dust: T_tt*T_p1p1 - (T_tp1)^2 = 0 ? (a ogni r) ---"];
nulltest=Simplify[Ttt Tp1p1 - Ttp1^2];
log["  T_tt T_p1p1 - (T_tp1)^2 = "<>ToString[InputForm[Simplify[nulltest]]]];
log["  (se =0 ovunque: e' null dust puro T=Phi k k, struttura confermata)"];
log["=== FINE "<>DateString[]<>" ==="];
Close[strm];
