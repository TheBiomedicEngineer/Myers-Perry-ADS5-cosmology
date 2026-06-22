(* ============================================================ *)
(* g4 STATICO: coefficienti monopolo/cos2th/cos4th di That_tt   *)
(* Macchina B-K validata cont.110-111. L=1 fisso.               *)
(* CON SCRITTURA SU FILE (Flush) - cambia a1v,a2v e rilancia.   *)
(* ============================================================ *)
Get["xAct`xCoba`"];

outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\RISULTATO_g4scaling.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, s, "\n"]; Flush[strm]; Print[s]);

(* >>>>>>>>>> CAMBIA QUI I DUE SPIN E RILANCIA <<<<<<<<<< *)
a1v = 1/2;
a2v = 1/5;
(* set: {1/2,1/5} D=0.21 VALIDA cos2/mono atteso 0.05377 ; {1/5,1/10} D=0.03 *)
(* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> *)

Lv = 1;
log["=== g4 per a1=" <> ToString[N[a1v]] <> " a2=" <> ToString[N[a2v]] <> " D=" <> ToString[N[a1v^2-a2v^2]] <> " S=" <> ToString[N[a1v^2+a2v^2]] <> " ==="];

ctp = Cos[tht]; stp = Sin[tht];
Xi1 = 1 - a1v^2/Lv^2; Xi2 = 1 - a2v^2/Lv^2;
rho2 = rr^2 + a1v^2 ctp^2 + a2v^2 stp^2;
Dr = (rr^2+a1v^2)(rr^2+a2v^2)(1+rr^2/Lv^2)/rr^2 - 2;
Dth = 1 - (a1v^2/Lv^2)ctp^2 - (a2v^2/Lv^2)stp^2;
w1 = {1,0,0,-a1v stp^2/Xi1,-a2v ctp^2/Xi2};
w2 = {a1v,0,0,-(rr^2+a1v^2)/Xi1,0};
w3 = {a1v a2v,0,0,-a2v(rr^2+a1v^2)stp^2/Xi1,-a1v(rr^2+a2v^2)ctp^2/Xi2};
w4 = {a2v,0,0,0,-(rr^2+a2v^2)/Xi2};
c1=-Dr/rho2; c2=Dth stp^2/rho2; c3=(1+rr^2/Lv^2)/(rr^2 rho2); c4=Dth ctp^2/rho2;
cdr=rho2/Dr; cdth=rho2/Dth;
gmat = c1 Outer[Times,w1,w1] + c2 Outer[Times,w2,w2] + c3 Outer[Times,w3,w3] + c4 Outer[Times,w4,w4];
gmat[[2,2]] += cdr; gmat[[3,3]] += cdth; gmat = Simplify[gmat];

grr = gmat[[2,2]]; nr = 1/Sqrt[grr]; idx = {1,3,4,5}; h = gmat[[idx,idx]];
Kab = Simplify[-(1/2) nr D[h,rr]]; hinv = Simplify[Inverse[h]]; Ktrace = Simplify[Tr[hinv.Kab]];

DefManifold[B4, 4, {a,b,c,d,e,f}];
DefChart[CHb, B4, {0,1,2,3}, {tt[],thh[],phh[],pss[]}];
hxact = h /. tht -> thh[];
DefMetric[{1,3,0}, hmet[-a,-b], CDb, {",","\[Del]"}];
MetricInBasis[hmet, -CHb, hxact];
log["inizio MetricCompute... " <> DateString[]];
MetricCompute[hmet, CHb, All];
log["MetricCompute fatto. " <> DateString[]];
extract[x_] := Module[{v}, v=x; While[Head[v]===Rule, v=Last[v]]; v];
RicciMat = Table[extract[ComponentValue[RicciCDb[{i,-CHb},{j,-CHb}]]],{i,0,3},{j,0,3}];
Rsc = extract[RicciScalarCDb[] // ToValues];
Gab = RicciMat - (1/2) Rsc hxact;

hh = h /. tht -> thh[]; KabX = Kab /. tht -> thh[]; KtraceX = Ktrace /. tht -> thh[];
Tdown = KabX - KtraceX hh - (3/Lv) hh + (Lv/2) Gab;
That = Table[Simplify[Limit[Tdown[[i,j]] rr^2, rr->Infinity]], {i,1,4},{j,1,4}];

Ttt = TrigReduce[That[[1,1]]];
log["That_tt = " <> ToString[InputForm[Ttt]]];

mono = Ttt /. {Cos[2 thh[]]->0, Cos[4 thh[]]->0};
c2coef = Coefficient[Ttt, Cos[2 thh[]]];
c4coef = Coefficient[Ttt, Cos[4 thh[]]];
log["--- COEFFICIENTI ---"];
log["monopolo = " <> ToString[InputForm[mono]] <> " = " <> ToString[N[mono,8]]];
log["cos2th   = " <> ToString[InputForm[c2coef]] <> " = " <> ToString[N[c2coef,8]]];
log["cos4th   = " <> ToString[InputForm[c4coef]] <> " = " <> ToString[N[c4coef,8]]];
log["--- RAPPORTI ---"];
log["cos2th/mono = " <> ToString[N[c2coef/mono, 8]] <> "   <- quadrupolo/monopolo (cont.111 atteso 0.05377)"];
log["cos4th/mono = " <> ToString[N[c4coef/mono, 8]]];
log["D = " <> ToString[N[a1v^2-a2v^2,8]] <> "  S = " <> ToString[N[a1v^2+a2v^2,8]]];
log["(cos2th/mono)/D = " <> ToString[N[(c2coef/mono)/(a1v^2-a2v^2), 8]] <> "  <- atteso -0.259, costante su set diversi"];
log["=== FINE === " <> DateString[]];
Close[strm];
Print["Salvato: " <> outfile];
Quit[];
