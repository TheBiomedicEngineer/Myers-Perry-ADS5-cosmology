(* ================================================================ *)
(* VAIDYA-KERR-AdS5 DUE SPIN, m=m(v). Sorgente del flusso.          *)
(* CORREZIONE: parto dalla metrica a DUE spin (forma doc 2008.13478 *)
(* gia' validata nelle sessioni precedenti, R=-20/L^2) e rendo      *)
(* m->m(v). Per single-spin: porre a2=0 (limite, non riscrittura).  *)
(* La trasformazione EF (GLPP eq.7) elimina i cross-term dr.        *)
(* DOPPIO CONTROLLO:                                                *)
(*   TEST 1: R = -20/L^2                                            *)
(*   TEST 2: a1=a2=0 (Schwarzschild-AdS5) -> T_vv=(3/2)m'/r^3       *)
(* ================================================================ *)
Needs["xAct`xTensor`"];
Needs["xAct`xCoba`"];
Print["=== VAIDYA-KERR-AdS5 due spin: sorgente flusso ==="];

Lv = 1;
a1v = 1/3;    (* spin 1: cambia per test. a1=a2=0 -> Schwarzschild test 2 *)
a2v = 1/5;    (* spin 2 *)

ct = Cos[thh]; st = Sin[thh];
Xi1 = 1 - a1v^2/Lv^2;  Xi2 = 1 - a2v^2/Lv^2;
rho2 = rr^2 + a1v^2 ct^2 + a2v^2 st^2;
mf = mm[v];
(* Delta_r a DUE spin (5D): (r^2+a1^2)(r^2+a2^2)(1+r^2/L^2)/r^2 - 2 m *)
Dr = (rr^2+a1v^2)(rr^2+a2v^2)(1+rr^2/Lv^2)/rr^2 - 2 mf;
Dth = 1 - (a1v^2/Lv^2) ct^2 - (a2v^2/Lv^2) st^2;

(* Metrica BL a due spin (forma standard, doc 2008.13478 eq.):       *)
(* ds^2 = -Dr/rho2 (dt - a1 st^2/Xi1 dphi - a2 ct^2/Xi2 dpsi)^2       *)
(*        + rho2/Dr dr^2 + rho2/Dth dth^2                             *)
(*        + Dth st^2/rho2 (a1 dt - (r^2+a1^2)/Xi1 dphi)^2             *)
(*        + Dth ct^2/rho2 (a2 dt - (r^2+a2^2)/Xi2 dpsi)^2             *)
(*        + (1+r^2/L^2)/(r^2 rho2) (a1 a2 dt - a2(r^2+a1^2)st^2/Xi1 dphi - a1(r^2+a2^2)ct^2/Xi2 dpsi)^2 *)
(* coords: 0=t,1=r,2=th,3=phi,4=psi *)
s1 = {1,0,0,-a1v st^2/Xi1,-a2v ct^2/Xi2};
s2 = {a1v,0,0,-(rr^2+a1v^2)/Xi1,0};
s3 = {a2v,0,0,0,-(rr^2+a2v^2)/Xi2};
s4 = {a1v a2v,0,0,-a2v(rr^2+a1v^2)st^2/Xi1,-a1v(rr^2+a2v^2)ct^2/Xi2};
er = {0,1,0,0,0}; eth = {0,0,1,0,0};
gBL = -Dr/rho2 Outer[Times,s1,s1] + rho2/Dr Outer[Times,er,er]
      + rho2/Dth Outer[Times,eth,eth]
      + Dth st^2/rho2 Outer[Times,s2,s2]
      + Dth ct^2/rho2 Outer[Times,s3,s3]
      + (1+rr^2/Lv^2)/(rr^2 rho2) Outer[Times,s4,s4];
gBL = Simplify[gBL];
Print["det gBL (deve essere != 0): controllo rank..."];
Print["  det = ", Simplify[Det[gBL]] // Short];

(* trasformazione EF: dt = dv - (r^2+a1^2)(r^2+a2^2)/(r^2 Dr) dr ;  *)
(*   dphi = dphi' - a1/Dr dr ; dpsi = dpsi' - a2/Dr dr              *)
(* (GLPP eq.7 adattata a 5D due spin)                               *)
fr = (rr^2+a1v^2)(rr^2+a2v^2)/(rr^2 Dr);
Jac = {
  {1, -fr, 0, 0, 0},
  {0, 1, 0, 0, 0},
  {0, 0, 1, 0, 0},
  {0, -a1v/Dr, 0, 1, 0},
  {0, -a2v/Dr, 0, 0, 1}
};
gEF = Simplify[Transpose[Jac].gBL.Jac];
Print["det gEF (deve essere != 0): ", Simplify[Det[gEF]] // Short];

DefManifold[M5, 5, {a,b,c,d,e,f,g,h,p,q}];
DefChart[CH, M5, {0,1,2,3,4}, {v[],r[],th[],ph[],ps[]}, ChartColor->Blue];
gEFx = gEF /. {rr->r[], thh->th[]};
DefMetric[{1,4,0}, met[-a,-b], CD, {",","\[Del]"}];
MetricInBasis[met, -CH, gEFx];
MetricCompute[met, CH, All];
extract[x_] := Module[{u}, u=x; While[Head[u]===Rule, u=Last[u]]; u];

Rsc = extract[RicciScalarCD[] // ToValues];
Print["--- TEST 1: R scalare (deve essere -20) ---"];
Print["  R = ", Simplify[Rsc]];

RicM = Table[extract[ComponentValue[RicciCD[{i,-CH},{j,-CH}]]],{i,0,4},{j,0,4}];
Gmix = RicM - (1/2) Rsc gEFx;
Tsrc = Simplify[Gmix + (-6/Lv^2) gEFx];
Print["--- SORGENTE T_munu (non nulle) ---"];
Do[If[Simplify[Tsrc[[i,j]]] =!= 0,
    Print["  T[",i-1,",",j-1,"] = ", Simplify[Tsrc[[i,j]]]]], {i,1,5},{j,i,5}];
Print["--- T_vv struttura angolare ---"];
Print["  T_vv = ", TrigReduce[Simplify[Tsrc[[1,1]]]]];
