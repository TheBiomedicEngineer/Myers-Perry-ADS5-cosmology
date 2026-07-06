outputFile = "C:\\Users\\Utente\\Desktop\\des\\files\\passo_C_vaidya_v4.txt";
If[FileExistsQ[outputFile], DeleteFile[outputFile]];
W[s_] := (Print[s]; PutAppend[OutputForm[s <> "\n"], outputFile]);
W["=== VAIDYA v4 === " <> DateString[]]; W[""];

(* Tutto numerico, nessuna variabile intermedia *)
(* Costanti *)
(* xi1=0.950716, xi2=0.981775, Dn2=0.015530, Ah=0.085766, Bh=0.054706 *)
(* sqXi=sqrt(xi1*xi2), factor=3/2 *)
(* Au = factor*xi1/(sqXi*Ah) *)
(* Cu = -factor*xi2/(sqXi*Bh) *)
(* pole_B = Ah/(2*Dn2) *)
(* Bu = factor*(xi1/pole_B - xi2/(1-pole_B))/(sqXi*(-2*Dn2)) *)
(* Int_H = Bu*Log[Bh/Ah] *)
(* dtot = Int_H * 4*Pi^2 *)

Au   = N[1.5 * 0.950716 / (Sqrt[0.950716*0.981775] * 0.085766)];
Cu   = N[-1.5 * 0.981775 / (Sqrt[0.950716*0.981775] * 0.054706)];
pB   = N[0.085766 / (2 * 0.015530)];
Bu   = N[1.5 * (0.950716/pB - 0.981775/(1-pB)) / (Sqrt[0.950716*0.981775]*(-2*0.015530))];
IntH = N[Bu * Log[0.054706/0.085766]];
dtot = N[IntH * 4 * Pi^2];
rel  = N[dtot / (-5.37066)];
Mn   = N[(-128.0*0.0381363 - (-5.37066)) / dtot];
rat  = N[Mn / 0.448786];

W["A = " <> ToString[Au]];
W["C = " <> ToString[Cu]];
W["B = " <> ToString[Bu]];
W["pole_B = " <> ToString[pB]];
W[""];
W["Int_Hadamard = B*Log[Bh/Ah] = " <> ToString[IntH]];
W["delta_J_D (x4pi^2) = " <> ToString[dtot]];
W["delta_J_D / J_D_static = " <> ToString[rel]];
W[""];
W["Mdot necessario = " <> ToString[Mn]];
W["M_buco*G5 = 0.448786"];
W["Mdot/M_buco = " <> ToString[rat]];
W[""];
If[Abs[rat] < 0.001, W["=> TRASCURABILE"],
  If[Abs[rat] < 0.5,  W["=> RILEVANTE: chiude il gap"],
                      W["=> NON SUFFICIENTE"]]];
W[""];
W["=== FINE ==="];
Print["Completato: ", outputFile];
