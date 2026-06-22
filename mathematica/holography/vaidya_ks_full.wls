(* ================================================================ *)
(* VAIDYA-KERR-AdS5 COMPLETO: sorgente del flusso.                  *)
(* gbar+k VERIFICATI (cont.142: R=-20, k.k=0). Aggiungo (2m[t]/U)k k.*)
(* Isolo coeff di m'[t] in OGNI componente, struttura angolare bordo.*)
(* Export robusto. ATTESA ~50 min (MetricCompute con m[t]).         *)
(* ================================================================ *)
Needs["xAct`xTensor`"]; Needs["xAct`xCoba`"];
outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_vaidya_full.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, s, "\n"]; Flush[strm]; Print[s]);
log["=== VAIDYA-KS COMPLETO " <> DateString[] <> " ==="];

a1 = 1/3; a2 = 1/5;
log["spin a1=" <> ToString[a1] <> " a2=" <> ToString[a2]];
Xi1=1-a1^2; Xi2=1-a2^2;

(* gbar diretta (verificata cont.142) *)
gbarF[rr_,cc_] := Module[{s,c,g},
  s=Sin[cc]; c=Cos[cc]; g=ConstantArray[0,{5,5}];
  g[[1,1]]=(rr^2+1)*((a1^2-1)*s^2+(a2^2-1)*c^2)/((a1^2-1)*(a2^2-1));
  g[[2,2]]=rr^2*((a1^2*rr^2+a1^2+rr^4+rr^2)*s^2+(a2^2*rr^2+a2^2+rr^4+rr^2)*c^2)/((a1^2*rr^2+a1^2+rr^4+rr^2)*(a2^2*rr^2+a2^2+rr^4+rr^2));
  g[[3,3]]=(-a1^2*s^2+a2^2*s^2-a2^2-rr^2)/(a1^2*s^2-a2^2*s^2+a2^2-1);
  g[[4,4]]=(-a1^2-rr^2)*c^2/(a1^2-1);
  g[[5,5]]=(-a2^2-rr^2)*s^2/(a2^2-1);
  g];
kF[rr_,cc_] := Module[{s,c,W,F},
  s=Sin[cc]; c=Cos[cc];
  W=c^2/Xi1+s^2/Xi2;
  F=rr^2/(1+rr^2)*(c^2/(rr^2+a1^2)+s^2/(rr^2+a2^2));
  {W, F, 0, -a1*c^2/Xi1, -a2*s^2/Xi2}];
UF[rr_,cc_] := Module[{s,c},s=Sin[cc];c=Cos[cc];
  (c^2/(rr^2+a1^2)+s^2/(rr^2+a2^2))*(rr^2+a1^2)*(rr^2+a2^2)];

DefManifold[M5,5,{aa,bb,cc2,dd,ee,ff,gg,hh,pp,qq}];
DefChart[CH,M5,{0,1,2,3,4},{tt[],r[],ch[],p1[],p2[]},ChartColor->Blue];

(* metrica COMPLETA: gbar + (2 m[t]/U) k k . m dipende dal tempo (coord 0 = tt). *)
gbarX = gbarF[r[],ch[]];
kX = kF[r[],ch[]];
UX = UF[r[],ch[]];
ksterm = 2 mm[tt[]]/UX;
gfullX = Simplify[ gbarX + ksterm Outer[Times,kX,kX] ];
log["det gfull (m=0 -> det gbar): " <> ToString[InputForm[Simplify[Det[gfullX]/.mm->Function[{x},0]]]]];

DefMetric[{1,4,0}, met[-aa,-bb], CD, {",","\[Del]"}];
MetricInBasis[met, -CH, gfullX];
log["MetricCompute COMPLETO (m[t])... ATTESA ~50min " <> DateString[]];
MetricCompute[met, CH, All];
log["MetricCompute fatto " <> DateString[]];
extract[x_]:=Module[{u},u=x;While[Head[u]===Rule,u=Last[u]];u];

Rsc=extract[RicciScalarCD[]//ToValues];
log["R (mm cost -> -20): " <> ToString[InputForm[Simplify[Rsc/.{mm->Function[{x},mc]}]]]];
RicM=Table[extract[ComponentValue[RicciCD[{i,-CH},{j,-CH}]]],{i,0,4},{j,0,4}];
log["Ricci fatto " <> DateString[]];
Tsrc=Simplify[RicM-(1/2)Rsc gfullX+(-6)gfullX];   (* Lambda5=-6 (L=1) *)
log["Sorgente calcolata " <> DateString[]];

mp=Derivative[1][mm][tt[]];
nm={"t","r","ch","p1","p2"};
log["--- COEFF di m'[t] in OGNI componente, struttura al bordo ---"];
Do[
  cf=Coefficient[Tsrc[[i,j]],mp];
  If[Simplify[cf]=!=0,
    b2=Simplify[Limit[(cf/.r[]->rr) rr^2, rr->Infinity]];
    b3=Simplify[Limit[(cf/.r[]->rr) rr^3, rr->Infinity]];
    log["T["<>nm[[i]]<>","<>nm[[j]]<>"]: r^2-> "<>ToString[InputForm[TrigReduce[b2]]]<>" ; r^3-> "<>ToString[InputForm[TrigReduce[b3]]]]
  ],
  {i,1,5},{j,i,5}];
log["--- cos2ch o cos2chi = porta D ; costante/no angolo = isotropo ---"];
log["=== FINE " <> DateString[] <> " ==="];
Close[strm];
