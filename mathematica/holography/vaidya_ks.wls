(* ================================================================ *)
(* VAIDYA-KERR-AdS5 Kerr-Schild. gbar DEFINITA DIRETTAMENTE         *)
(* (componenti verificate in sympy: R=-20, k.k=0). NIENTE estrazione*)
(* Coefficient (era il bug della v precedente: righe angolari nulle).*)
(* coords: 1=t,2=r,3=chi,4=phi1,5=phi2.  mu1=Cos[chi],mu2=Sin[chi]. *)
(* TEST T1: R(gbar)=-20 ; T2: k.k=0. Poi sorgente con m[t].         *)
(* ================================================================ *)
Needs["xAct`xTensor`"]; Needs["xAct`xCoba`"];
outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_vaidya_ks.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, s, "\n"]; Flush[strm]; Print[s]);
log["=== VAIDYA-KS v2 (gbar diretta) " <> DateString[] <> " ==="];

a1 = 1/3; a2 = 1/5;   (* spin. a2=0 single; a1=a2=0 Schwarzschild *)
log["spin a1=" <> ToString[a1] <> " a2=" <> ToString[a2]];

(* gbar DIRETTA - componenti diagonali verificate in sympy (R=-20). rr=r[], cc=chi[]. *)
gbarF[rr_,cc_] := Module[{s,c,g},
  s=Sin[cc]; c=Cos[cc]; g=ConstantArray[0,{5,5}];
  g[[1,1]]=(rr^2+1)*((a1^2-1)*s^2+(a2^2-1)*c^2)/((a1^2-1)*(a2^2-1));
  g[[2,2]]=rr^2*((a1^2*rr^2+a1^2+rr^4+rr^2)*s^2+(a2^2*rr^2+a2^2+rr^4+rr^2)*c^2)/((a1^2*rr^2+a1^2+rr^4+rr^2)*(a2^2*rr^2+a2^2+rr^4+rr^2));
  g[[3,3]]=(-a1^2*s^2+a2^2*s^2-a2^2-rr^2)/(a1^2*s^2-a2^2*s^2+a2^2-1);
  g[[4,4]]=(-a1^2-rr^2)*c^2/(a1^2-1);
  g[[5,5]]=(-a2^2-rr^2)*s^2/(a2^2-1);
  g];

(* vettore nullo k (eq.9.20): k = W dt + F dr - a1 mu1^2/Xi1 dphi1 - a2 mu2^2/Xi2 dphi2 *)
(* mu1=Cos[chi], mu2=Sin[chi] -> ATTENZIONE convenzione: in sympy mu1=cos abbina a1. *)
Xi1=1-a1^2; Xi2=1-a2^2;
kF[rr_,cc_] := Module[{s,c,W,F},
  s=Sin[cc]; c=Cos[cc];
  W=c^2/Xi1+s^2/Xi2;
  F=rr^2/(1+rr^2)*(c^2/(rr^2+a1^2)+s^2/(rr^2+a2^2));
  {W, F, 0, -a1*c^2/Xi1, -a2*s^2/Xi2}];
UF[rr_,cc_] := Module[{s,c},s=Sin[cc];c=Cos[cc];
  (c^2/(rr^2+a1^2)+s^2/(rr^2+a2^2))*(rr^2+a1^2)*(rr^2+a2^2)];

(* --- TEST su gbar (m=0) PRIMA di tutto --- *)
DefManifold[M5,5,{aa,bb,cc2,dd,ee,ff,gg,hh,pp,qq}];
DefChart[CH,M5,{0,1,2,3,4},{tt[],r[],ch[],p1[],p2[]},ChartColor->Blue];
gbarX = gbarF[r[],ch[]];
log["det gbar = " <> ToString[InputForm[Simplify[Det[gbarX]]]]];
kX = kF[r[],ch[]];
gbinv = Simplify[Inverse[gbarX]];
knorm = Simplify[kX.gbinv.kX];
log["T2: k.k = " <> ToString[InputForm[knorm]] <> " (deve essere 0)"];

DefMetric[{1,4,0}, gb[-aa,-bb], CDb, {",","\[Del]"}];
MetricInBasis[gb, -CH, gbarX];
log["MetricCompute gbar... " <> DateString[]];
MetricCompute[gb, CH, All];
extract[x_]:=Module[{u},u=x;While[Head[u]===Rule,u=Last[u]];u];
Rbar=extract[RicciScalarCDb[]//ToValues];
log["T1: R(gbar) = " <> ToString[InputForm[Simplify[Rbar]]] <> " (deve essere -20)"];
log["=== test fatti " <> DateString[] <> " ==="];
log["se T1=-20 e T2=0 -> fondazione OK, prossimo step: sorgente con m[t]"];
Close[strm];
