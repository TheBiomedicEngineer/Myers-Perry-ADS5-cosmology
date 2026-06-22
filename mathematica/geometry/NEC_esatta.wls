(* ================================================================ *)
(* NEC ESATTA lungo il raggio in Vaidya-Myers-Perry-AdS5 (2 spin).  *)
(* Scopo: sostituire il fit a 2 punti (cont.155) con la funzione    *)
(* vera NEC(r). Serve a verificare se la violazione (vicino al buco) *)
(* svanisce davvero al bordo dove sta la brana -> HRT applicabile.   *)
(* Riusa metrica VERIFICATA (cont.142/154). Export robusto.         *)
(* NB: MetricCompute con m[t] ~ 30-50 min.                          *)
(* ================================================================ *)
Needs["xAct`xTensor`"]; Needs["xAct`xCoba`"];
outfile = "C:\\Users\\Utente\\Desktop\\des\\files\\risultati_NEC.txt";
strm = OpenWrite[outfile];
log[s_] := (WriteString[strm, s, "\n"]; Flush[strm]; Print[s]);
log["=== NEC ESATTA " <> DateString[] <> " ==="];

a1 = 1/3; a2 = 1/5; Xi1=1-a1^2; Xi2=1-a2^2;
log["spin a1=" <> ToString[a1] <> " a2=" <> ToString[a2]];

(* metrica verificata (cont.142/154) *)
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
log["MetricCompute... " <> DateString[]];
MetricCompute[met,CH,All];
log["fatto " <> DateString[]];
extract[x_]:=Module[{u},u=x;While[Head[u]===Rule,u=Last[u]];u];
Rsc=extract[RicciScalarCD[]//ToValues];
RicM=Table[extract[ComponentValue[RicciCD[{i,-CH},{j,-CH}]]],{i,0,4},{j,0,4}];
Tsrc=Simplify[RicM-(1/2)Rsc gfullX+(-6)gfullX];
log["Sorgente calcolata " <> DateString[]];

(* ---- VETTORE NULLO GENERICO per la NEC ---- *)
(* Costruisco un vettore nullo n^mu generico (non il k Kerr-Schild, che dava 0 = artefatto, *)
(* cont.155). Parametrizzo: n = e_t + alpha e_r + beta e_ch + ... e impongo n.n=0.        *)
(* Uso una famiglia a 1 parametro: direzione radiale-temporale + componente angolare.     *)
(* ginv per alzare/contrarre. Valuto a m[t]->mu (flusso attivo) e poi numericamente.       *)
ginvX=Simplify[Inverse[gfullX]];
mp=Derivative[1][mm][tt[]];

(* La NEC fisica: T_munu n^mu n^nu >= 0 per ogni n nullo. *)
(* Prendo n^mu nullo generico: componenti {nt,nr,nch,np1,np2} con vincolo g_munu n n =0. *)
(* Per esplorare la NEC, scelgo una base di vettori nulli e valuto il MINIMO della       *)
(* contrazione su quella base (la violazione peggiore).                                  *)
(* Vettore nullo radiale-temporale (semplice, cattura la violazione vista in cont.155):  *)
(* n = (nt, nr, 0,0,0) con g_tt nt^2 + 2 g_tr nt nr + g_rr nr^2 = 0.                      *)

(* lavoro a chi = pi/4 (generico, non sui poli) e flusso attivo mm[tt[]]->mu, mp-> flusso *)
chval = Pi/4;
sub0 = {ch[]->chval};

(* coefficiente di m' nella sorgente (il flusso) - la NEC del flusso *)
TfluxM=Table[Coefficient[Tsrc[[i,j]],mp]/.{mm[tt[]]->0},{i,5},{j,5}];
TfluxM=Simplify[TfluxM];

(* metrica covariante a mm->0 (la parte rilevante per il vincolo nullo del flusso entrante) *)
gX0=Simplify[gfullX/.{mm[tt[]]->0}];

(* vettore nullo radiale entrante a chi fisso: risolvo g_tt nt^2 + g_rr nr^2=0 (g_tr=0 qui) *)
(* g_tt = gX0[[1,1]], g_rr = gX0[[2,2]] *)
log["--- NEC del flusso lungo r (vettore nullo radiale-temporale, chi=Pi/4) ---"];
log["r    g_tt      g_rr      NEC=T_ab n^a n^b   stato"];
Do[
  Module[{gtt,grr,nt,nr,nvec,nec},
   gtt=gX0[[1,1]]/.{r[]->rr,ch[]->chval};
   grr=gX0[[2,2]]/.{r[]->rr,ch[]->chval};
   (* nullo: gtt nt^2+grr nr^2=0 -> nr=nt Sqrt[-gtt/grr]; normalizzo nt=1 *)
   nt=1; nr=Sqrt[-gtt/grr];
   nvec={nt,nr,0,0,0};
   (* NEC = T_ab n^a n^b con T del flusso (coeff m', che e' >0 per flusso entrante) *)
   nec=Sum[(TfluxM[[i,j]]/.{r[]->rr,ch[]->chval}) nvec[[i]] nvec[[j]],{i,5},{j,5}];
   nec=Simplify[nec];
   log[ToString[N[rr]]<>"  "<>ToString[N[gtt,4]]<>"  "<>ToString[N[grr,4]]<>"  "<>ToString[N[nec,5]]<>"  "<>If[N[nec]<-(10^-6),"VIOLATA",If[Abs[N[nec]]<10^-6,"~zero","ok"]]]
  ],
  {rr,{0.5,1.0,2.0,3.0,5.0,10.0,20.0,50.0,100.0}}];
log[""];
log["Se NEC -> 0 (o >=0) al crescere di r: violazione confinata al buco, brana SANA -> HRT ok."];
log["Confronto col fit cont.155 (1/r^2.7): vediamo se l'andamento vero coincide o no."];
log["=== FINE " <> DateString[] <> " ==="];
Close[strm];
