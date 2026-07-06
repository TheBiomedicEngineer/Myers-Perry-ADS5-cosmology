[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20800476.svg)](https://doi.org/10.5281/zenodo.20800476)

A Geometric Exploration of Myers-Perry AdS5 2 SPINs Cosmology
Holographic Brane-World Model: A Toy Theory
> **Status:** Exploratory phenomenological programme — not a peer-reviewed publication.  
> **Author:** Anonymous (biomedical engineer with a personal interest in theoretical physics)  
> **Period:** May–July 2026  
> **Approach:** AI-assisted analytical exploration (Claude, Mathematica/xCoba, Python)
This repository documents an amateur exploratory programme. The goal was understanding, not publication. Mathematical rigour is maintained where possible; every claim is labelled by confidence level. The work is shared openly so that anyone searching this geometric configuration can find a starting point.
---
Overview
A 3-brane lives on the S³ horizon of a two-spin Myers-Perry-AdS5 black hole. Matter, dark energy, chirality, the baryon asymmetry, and the electromagnetic coupling constant emerge from the geometry of two asymmetric spins (a₁ = 0.222 L, a₂ = 0.135 L).
---
The Central Idea: D as the source of Standard Model asymmetries
The most original feature of this work is the role of the anisotropic channel D = a₁² − a₂² as a shared geometric source of multiple apparently unrelated phenomena:
Chirality — the frame-dragging inversion at r_h = √(a₁a₂) produces a Pöschl-Teller potential that traps only left-handed fermions. No scalar field added by hand: it emerges from the pure Myers-Perry metric with a₁ ≠ a₂.
Baryogenesis — D changes sign at the inversion, defining a geometric freeze-out of the baryon asymmetry at asym = 0.178 (r_bario = 0.191 L).
EW gauge structure — D carries the quadrupole and the electroweak sector.
DE dynamics — D contributes to the anisotropic component of the boundary stress tensor, producing w(z) that crosses −1 in the direction observed by DESI.
Electromagnetic coupling — D/S = (Ω₁−Ω₂)/(Ω₁+Ω₂) at r_bario gives α(M_Z) = 1/128.1 (Δ = 0.1%). The low-energy value α = 1/137 emerges from the same geometry at second order: 3D/(R+2S) = 3D/(O(O+4)) = 1/137.5 (Δ = 0.33%), where O = (Ω₁+Ω₂)/2.
In standard cosmology and the Standard Model, these phenomena are explained by five or more separate mechanisms. Here they are projections of the same geometric asymmetry.
The α geometry in detail
The two values of α are the only physically relevant terms of the series:
```
α(n) = (2n−1) · D / (O · (O+4)^(n−1))
```
n=1: D/S = 1/128.1 → α(M_Z) [high energy, single excitation of channel D]
n=2: 3D/(O(O+4)) = 1/137.5 → α(low energy) [pair creation threshold, double excitation]
n≥3: 1/531, 1/2445, ... — outside any physical observable
The coefficient C = 4 in (O+4) is universal — algebraically exact for any spin values in the limit O₁ ≈ O₂, independent of the specific DESI attractors. The factor 3 = (2·2−1) is combinatorial, not dimensional. Both verified analytically.
Physical meaning: The geometry fixes the boundary conditions of the electromagnetic coupling. The running between 1/137 and 1/128 (5 orders of magnitude in Q) is described by QED. Geometry sets the endpoints; QED fills the path.
---
Key numerical results
Result	Value	Observed	Discrepancy
Ω_DM/Ω_b (from asym)	5.62	5.41	3.8%
m_DM (from cost mechanism)	~150 MeV	—	~ Λ_QCD
α(M_Z) from D/S	1/128.1	1/127.9	0.1%
α(low E) from 3D/(O(O+4))	1/137.5	1/137.036	0.33%
w(z) crossing	z ≈ 0.45	DESI	compatible 0.7σ
Today on Area/M curve	93.7% of max	—	DE weakening
Chirality inversion	r_h = 0.173 L	universal	geometric
---
Holographic boundary results (Passo C — verified on real metric)
Computed directly on the GLPP metric with xCoba/Mathematica:
Quantity	Value	Note
R(g₀)	−0.404 − 0.217/sin²θ − 0.231/cos²θ	≠ 3/2; Python artefact confirmed
J_D (Noether charge)	−5.371	Real metric [V]
CT2 (BK counterterms)	−7063	Finite [V]
C = 4 in α series	universal	All spin values tested [V]
(D−2)/2 factor in Vaidya	3/2 in D=5	xAct symbolic [V]
Note: J_D is the differential angular charge (J₁−J₂)/G₅ — a thermodynamic object, not the photon current. α = D/S is the physical result; it does not require G₅.
---
Repository Structure
```
├── README.md
├── docs/
│   ├── COMPLETE_NARRATIVE_model.md    ← Start here: full story in English
│   ├── RACCONTO_COMPLETO_modello.md   ← Italian version
│   ├── risposta_critiche_referee.md   ← Response to structural critiques
│   ├── MODEL_synthesis_EN.md          ← Technical synthesis (EN)
│   ├── MODEL_apparatus_EN.md          ← Technical apparatus (EN)
│   ├── MODELLO_sintesi.md             ← Sintesi tecnica (IT)
│   ├── MODELLO_apparato.md            ← Apparato tecnico (IT)
│   └── REGOLE_metodo.md               ← Methodology rules
├── mathematica/
│   ├── geometry/      ← Metric, horizon, S/D/R structure
│   ├── holography/    ← Boundary stress tensor, Vaidya, BK
│   ├── baryogenesis/  ← Asymmetry, Dirac-Kerr QFT, asym(r_h)
│   ├── dark_matter/   ← KK masses
│   └── cosmology/     ← Friedmann, DESI
├── python/            ← DESI and Pantheon+ data analysis
├── results/           ← Actual output files from Mathematica runs
└── papers/            ← Outreach PDF (Italian)
```
---
Confidence labels used throughout
Label	Meaning
[V]	verified with explicit calculation
[L]	anchored to published literature
[O]	order-of-magnitude estimate
[A]	motivated assumption
[S]	speculation
[?]	open conjecture
---
Known structural limits
Flux profile Ṁ(t): not derivable from first principles — requires numerical 5D Einstein-Vaidya on supercomputers.
SU(3) non-diagonal generators: H₂(S³) = 0 blocks them geometrically. Requires Sasaki-Einstein Y^{p,q} manifolds (string theory).
Full holographic stress tensor: boundary stress tensor partially verified (g₀, g₂ sectors). Full g₄ sector with complete de Haro-Skenderis-Solodukhin counterterms requires Cadabra/xAct.
G₅ in physical units: the absolute scale of L is not derivable from within the model (nodo B.2). Ratios like D/S bypass this; absolute currents like J_D do not.
α running: the geometry fixes the boundary conditions (1/128 and 1/137.5) but not the logarithmic running between them — that is standard QED.
The brane causality critique is resolved: Apostolopoulos-Tetradis 2004/2005 covers the dynamic case exactly. The brane is timelike at r_b > r_h.
---
Key references
Gibbons-Lu-Page-Pope (2004): MP-AdS5 metric [hep-th/0404008]
Apostolopoulos-Tetradis (2004/2005): Mirage brane cosmology
Balasubramanian-Kraus (1999): Holographic stress tensor [hep-th/9902121]
Hawking-Hunter-Taylor (1999): MP-AdS5 thermodynamics [hep-th/9811056]
Rasulian (2024): Brane-horizon cosmology [arXiv:2408.15166]
DESI Collaboration (2024/2025): Dark energy dynamics
Read `docs/COMPLETE_NARRATIVE_model.md` for the full physical story.  
Read `docs/risposta_critiche_referee.md` for the structural critique responses.
