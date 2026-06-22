(* ================================================================ *)
(* SORGENTE DEL FLUSSO - versione 2: guarda TUTTE le componenti.    *)
(* Il flusso radiale in BL vive in T_tr (mista), non T_tt.          *)
(* Estrae coeff di mm'[v] da OGNI componente, mostra le non-nulle.  *)
(* Export robusto (Flush). R=-20 gia' verificato nel run precedente.*)
(* ================================================================ *)
Needs["xAct`xTensor`"]; Needs["xAct`xCoba`"];
outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_flusso2.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, s, "\n"]; Flush[strm]; Print[s]);
log["=== FLUSSO v2 (tutte le componenti) " <> DateString[] <> " ==="];

Lv=1; a1v=1/2; a2v=1/5;
log["spin a1=" <> ToString[a1v] <> " a2=" <> ToString[a2v]];
ct=Cos[thh]; st=Sin[thh];
Xi1=1-a1v^2/Lv^2; Xi2=1-a2v^2/Lv^2;
rho2=rr^2+a1v^2 ct^2+a2v^2 st^2;
Dr=(rr^2+a1v^2)(rr^2+a2v^2)(1+rr^2/Lv^2)/rr^2-2 mm[v[]];
Dth=1-(a1v^2/Lv^2)ct^2-(a2v^2/Lv^2)st^2;
w1={1,0,0,-a1v st^2/Xi1,-a2v ct^2/Xi2};
w2={a1v,0,0,-(rr^2+a1v^2)/Xi1,0};
w3={a1v a2v,0,0,-a2v(rr^2+a1v^2)st^2/Xi1,-a1v(rr^2+a2v^2)ct^2/Xi2};
w4={a2v,0,0,0,-(rr^2+a2v^2)/Xi2};
c1=-Dr/rho2;c2=Dth st^2/rho2;c3=(1+rr^2/Lv^2)/(rr^2 rho2);c4=Dth ct^2/rho2;
cdr=rho2/Dr;cdth=rho2/Dth;
gmat=c1 Outer[Times,w1,w1]+c2 Outer[Times,w2,w2]+c3 Outer[Times,w3,w3]+c4 Outer[Times,w4,w4];
gmat[[2,2]]+=cdr; gmat[[3,3]]+=cdth; gmat=Simplify[gmat];

DefManifold[M5,5,{a,b,c,d,e,f,g,h,p,q}];
DefChart[CH,M5,{0,1,2,3,4},{v[],r[],th[],ph[],ps[]},ChartColor->Blue];
gx=gmat/.{rr->r[],thh->th[]};
DefMetric[{1,4,0},met[-a,-b],CD,{",","\[Del]"}];
MetricInBasis[met,-CH,gx];
log["MetricCompute... " <> DateString[]];
MetricCompute[met,CH,All];
log["MetricCompute fatto " <> DateString[]];
extract[x_]:=Module[{u},u=x;While[Head[u]===Rule,u=Last[u]];u];
Rsc=extract[RicciScalarCD[]//ToValues];
log["R = " <> ToString[InputForm[Simplify[Rsc/.{mm->Function[{x},mc]}]]] <> " (deve essere -20)"];
RicM=Table[extract[ComponentValue[RicciCD[{i,-CH},{j,-CH}]]],{i,0,4},{j,0,4}];
log["Ricci fatto " <> DateString[]];
Tsrc=Simplify[RicM-(1/2)Rsc gx+(-6/Lv^2)gx];
log["Sorgente calcolata " <> DateString[]];

mp=Derivative[1][mm][v[]];
nm={"v","r","th","ph","ps"};
log["--- COEFF di mm'[v] in OGNI componente, al bordo (r^2 * coeff, r->inf) ---"];
Do[
  cf=Coefficient[Tsrc[[i,j]],mp];
  If[Simplify[cf]=!=0,
    bordo=Simplify[Limit[(cf/.r[]->rr) rr^2, rr->Infinity]];
    bordo2=Simplify[Limit[(cf/.r[]->rr) rr^3, rr->Infinity]];
    log["T["<>nm[[i]]<>","<>nm[[j]]<>"]: r^2-> "<>ToString[InputForm[TrigReduce[bordo]]]<>" ; r^3-> "<>ToString[InputForm[TrigReduce[bordo2]]]]
  ],
  {i,1,5},{j,i,5}];
log["--- (cerca cos2th = porta D ; costante/no theta = isotropo) ---"];
log["=== FINE " <> DateString[] <> " ==="];
Close[strm];
