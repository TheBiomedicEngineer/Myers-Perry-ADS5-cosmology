#!/usr/bin/env wolframscript
(* ============================================================================
   BARIOGENESI ROTAZIONALE - blindatura del SEGNO dell'asimmetria  (v2, fix stampa)
   ----------------------------------------------------------------------------
   FIX rispetto a v1: l'ordine N[expr /. regole] applicava N PRIMA della
   sostituzione -> N su espressione simbolica -> NumberForm non stampava.
   Qui le sostituzioni sono SEMPRE racchiuse in parentesi: N[(expr /. regole)].
   Il blocco tabella usa ToString[NumberForm[...]], piu' robusto dentro Do.
   ============================================================================ *)

Print["=================================================================="];
Print["DIRAC IN KERR - segno dell'asimmetria materia/antimateria (v2)"];
Print["=================================================================="];

(* ---- Passo 1: Kerr equatoriale, frame-dragging, T_Hawking ---- *)
Clear[M, a, r];
gtph[r_]  := -2 M a/r;
gphph[r_] := r^2 + a^2 + 2 M a^2/r;
OmegaDrag[r_] := Simplify[-gtph[r]/gphph[r]];
Print["Frame-dragging  Omega_drag(r) = ", OmegaDrag[r]];

rH = M + Sqrt[M^2 - a^2];
OmegaH = Simplify[OmegaDrag[rH]];
TH = Simplify[ Sqrt[M^2 - a^2] / (4 Pi M (M + Sqrt[M^2 - a^2])) ];
Print["Orizzonte r_H              = ", rH];
Print["Omega_H (all'orizzonte)    = ", OmegaH];
Print["Temperatura di Hawking T_H = ", TH];

(* ---- Passo 2: accoppiamento spin-rotazione (Mashhoon) ---- *)
Print["--------------------------------------------------------------"];
Print["Accoppiamento spin-rotazione (Mashhoon): E_sr = -Omega_H * s,  s=+/-1/2"];

(* ---- Passo 3: materia vs antimateria sotto C ---- *)
Clear[mass];
Emat  = mass - OmegaH/2;
Eanti = mass + OmegaH/2;
Print["E_materia     = ", Simplify[Emat]];
Print["E_antimateria = ", Simplify[Eanti]];
Print["Delta = E_anti - E_mat = ", Simplify[Eanti - Emat], "  (>0 => materia favorita)"];

(* ---- Passo 4: esponente di Boltzmann ---- *)
esponenteSimbolico = Simplify[(Eanti - Emat)/TH];
Print["--------------------------------------------------------------"];
Print["Esponente (E_anti - E_mat)/T_H = ", esponenteSimbolico];
Print["  (= Omega_H/T_H ; la massa si CANCELLA nella differenza)"];

(* ---- Passo 5: tabella numerica (FIX: parentesi prima di N[]) ---- *)
Print["=================================================================="];
Print["TABELLA NUMERICA (M=1)"];
Print["a/M    Omega_H      T_H        esponente    n_mat/n_anti"];
Do[
  Module[{oH, tH, esp, rt},
    oH  = N[(OmegaH /. {M -> 1, a -> aM})];
    tH  = N[(TH     /. {M -> 1, a -> aM})];
    esp = N[(esponenteSimbolico /. {M -> 1, a -> aM})];
    rt  = N[Exp[esp]];
    Print[
      ToString[NumberForm[aM,  {3,2}]], "   ",
      ToString[NumberForm[oH,  {6,4}]], "   ",
      ToString[NumberForm[tH,  {6,4}]], "   ",
      ToString[NumberForm[esp, {6,3}]], "   ",
      ToString[ScientificForm[rt, 4]]
    ];
  ],
  {aM, {0.1, 0.3, 0.5, 0.7, 0.9, 0.99}}
];

Print["=================================================================="];
Print["LETTURA"];
Print["=================================================================="];
Print["- esponente = Omega_H/T_H = 2 Pi a / Sqrt[M^2-a^2] : POSITIVO per ogni a in (0,M)."];
Print["- => MATERIA favorita in modo DEFINITO e SISTEMATICO (n_mat/n_anti>1 sempre)."];
Print["- cresce con lo spin (diverge a->M). Asimmetria O(1) all'orizzonte."];
Print["  Da diluire al bordo ~(r_h/r_brana)^7, oppure eta=rapporto di scale."];
Print[""];
Print["GUARDIANO (il segno NON e' una convenzione girata a mano):"];
Print["- allineamento spin//Omega: FORZATO dal frame-dragging (non scelto);"];
Print["- segno -Omega.S: Mashhoon standard; inversione antimateria: C (standard)."];
Print["'materia' = freq. positiva rispetto alla freccia di caduta: materia ed eccesso"];
Print["hanno la STESSA origine (la caduta). Relativo, non arbitrario."];
Print[""];
Print["CONFINE: Mashhoon + Boltzmann -> SEGNO (definito) e ORDINE (O(1))."];
Print["Il QFT completo in Kerr (Bogoliubov, C/P/T) blinderebbe. Passo successivo."];

(* ---- Check analitico ---- *)
Print["--------------------------------------------------------------"];
Print["Check: esponente - 2 Pi a/Sqrt[M^2-a^2] = ",
      Simplify[esponenteSimbolico - 2 Pi a/Sqrt[M^2 - a^2]], "  (deve essere 0)"];
