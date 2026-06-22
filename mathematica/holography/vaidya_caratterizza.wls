(* ================================================================ *)
(* CARATTERIZZA la struttura del flusso rotante (coeff di m'[t]).   *)
(* Domanda: e' null dust puro (T=Phi k k), null dust + stress       *)
(* anisotropo, o artefatto? Separo PULITO statico/flusso.          *)
(* Calcolo: tensore flusso T^flux, sua TRACCIA, e test decomposiz.  *)
(* Export robusto.                                                  *)
(* ================================================================ *)
Needs["xAct`xTensor`"]; Needs["xAct`xCoba`"];
outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_caratterizza.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, s, "\n"]; Flush[strm]; Print[s]);
log["=== CARATTERIZZA FLUSSO " <> DateString[] <> " ==="];

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
(* tensore di Einstein + Lambda: la SORGENTE totale *)
Tsrc=Simplify[RicM-(1/2)Rsc gfullX+(-6)gfullX];
mp=Derivative[1][mm][tt[]];
mpp=Derivative[2][mm][tt[]];

(* FLUSSO PULITO = coeff di m'[t], azzerando m'' e ponendo mm->0 nel resto *)
(* (cosi' isolo SOLO il termine lineare in m', senza residui statici) *)
Tflux=Table[
   Coefficient[Tsrc[[i,j]],mp]/.{mm[tt[]]->0,mpp->0},
   {i,5},{j,5}];
Tflux=Simplify[Tflux];
log["--- componenti FLUSSO PULITO (coeff m', mm->0) ---"];
nm={"t","r","ch","p1","p2"};
Do[If[Simplify[Tflux[[i,j]]]=!=0,
  log["  T["<>nm[[i]]<>","<>nm[[j]]<>"] = "<>ToString[InputForm[Simplify[Tflux[[i,j]]]]]]],
  {i,5},{j,i,5}];

(* TRACCIA del flusso: g^munu T_munu. Null dust ha traccia 0. *)
ginv=Simplify[Inverse[gfullX]/.{mm[tt[]]->0}];
trace=Simplify[Sum[ginv[[i,j]]Tflux[[i,j]],{i,5},{j,5}]];
log["--- TRACCIA flusso (null dust -> 0) ---"];
log["  tr = "<>ToString[InputForm[Simplify[trace]]]];

(* TEST null dust pulito ora: T_tt T_p1p1-(T_tp1)^2 sul flusso pulito *)
ndtest=Simplify[Tflux[[1,1]]Tflux[[4,4]]-Tflux[[1,4]]^2];
log["--- test null dust su flusso pulito: T_tt T_p1p1-(T_tp1)^2 ---"];
log["  = "<>ToString[InputForm[ndtest]]];
log["  (=0 -> null dust puro; !=0 -> ha stress)"];
log["=== FINE "<>DateString[]<>" ==="];
Close[strm];
