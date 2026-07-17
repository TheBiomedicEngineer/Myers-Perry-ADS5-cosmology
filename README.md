[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20800476.svg)](https://doi.org/10.5281/zenodo.20800476)

# A Geometric Exploration of Myers-Perry AdS5 2 SPINs Cosmology
### Holographic Brane-World Model: A Toy Theory

**Status:** Exploratory phenomenological programme — not a peer-reviewed publication.  
**Author:** Anonymous (biomedical engineer with a personal interest in theoretical physics)  
**Period:** May–July 2026  
**Approach:** AI-assisted analytical exploration (Claude, Mathematica/xCoba, Python)

> *This repository documents an amateur exploratory programme. The goal was understanding,
> not publication. Mathematical rigour is maintained where possible; every claim is labelled
> by confidence level. The work is shared openly so that anyone searching this geometric
> configuration can find a starting point.*

> **Claim-by-claim status:** [`STATUS.md`](STATUS.md) · **What changed and when:** [`CHANGELOG.md`](CHANGELOG.md)

---

## Overview

A 3-brane lives on the S³ horizon of a two-spin Myers-Perry-AdS5 black hole. Matter, dark
energy, chirality, and the baryon asymmetry emerge from the geometry of two asymmetric
spins (a₁ = 0.222 L, a₂ = 0.135 L). **These two numbers are the only genuine inputs.**

## The Central Idea: D as the source of Standard Model asymmetries

The most original feature of this work is the role of the **anisotropic channel D = a₁² − a₂²** as a shared geometric source of multiple apparently unrelated phenomena:

- **Chirality** — the frame-dragging inversion at r_h = √(a₁a₂) produces a Pöschl-Teller
potential that traps only left-handed fermions. No scalar field added by hand: it emerges
from the pure Myers-Perry metric with a₁ ≠ a₂. *Candidate mechanism: still to be checked
with the full Dirac equation in AdS₅.*
- **Baryogenesis** — D changes sign at the inversion, defining a geometric freeze-out of
the baryon asymmetry at asym = 0.178 (r_bario = 0.191 L). *The **sign** is a verified QFT
result (Dirac-Kerr, CPT check exact); the **value** is model-dependent, and reaching the
observed η~10⁻⁹ still requires greybody factors and dilution.*
- **EW gauge structure** — D carries the quadrupole and the electroweak sector.
- **DE dynamics** — D contributes to the anisotropic component of the boundary stress tensor,
producing w(z) that crosses −1 in the direction observed by DESI.
- **Hubble quadrupole** — D fixes both the amplitude (≈1.6%) and the axis of an anisotropy
in the expansion rate. **This is the programme's one falsifiable prediction** (see below).

In standard cosmology, these phenomena are explained by separate mechanisms. Here
they are projections of the same geometric asymmetry.

---

## NEW (July 2026): the flagship prediction

### A falsifiable Hubble quadrupole ≈ 1.6%

The two-spin geometry predicts an **anisotropic quadrupole in the Hubble expansion**,
amplitude **≈1.6%**, with its **axis fixed by the two rotation planes** — not a free
parameter.

- Below the current ceiling (Cowell et al. 2023, ~3%)
- **Above Gaia sensitivity (~1%)** — predicted proper motions ~0.32 μas/yr
- **Falsification condition:** if Gaia (or future astrometry) excludes a quadrupole at this
  amplitude *and* axis, this version of the model is dead.
- Isotropic dark-energy models (e.g. Dark Dimension) predict **no** quadrupole — so this
  discriminates between them.

Two independent routes give the same number: `shear/ρ = 0.016070` and `D/(Ξ₁+Ξ₂) = 0.016072`.
The holographic stress tensor is validated against Awad-Johnson (J₁/J₂ = 1.698167, exact match).
The conformal boundary is **conformally flat** (g_θθ=1, R=6, Weyl=0, xAct/xCoba) — which
removes the 1/(1−u)⁴ polar divergence that had blocked this calculation for many attempts:
the divergence came from an incorrect angular normalisation (g_θθ=4), not from physics.

→ [`results/hubble_quadrupole.md`](results/hubble_quadrupole.md)

### The a² flux law, derived from the 5D Einstein equations

The source term feeding dark energy, S = k·a²·B, previously had its a² exponent *motivated*
but not *derived* — this was known structural limit #1 (see below). It now follows from the
bulk equations:

    T_vv = 3(dm/dv)/r³        (5D Einstein on Vaidya-AdS₅)
    m = (r_h²/2)(1+r_h²/L²)   (horizon condition)
    ⟹  dm/dτ = H a² (1 + 2a²/L²)

**Pure a² is the small-radius limit** — exact to 1.9% at the horizon-area minimum
(a = 0.0968 L, the inflationary regime), while at a = 1.44 L the correction factor is 5.15.
The **(1+2a²/L²) correction at low redshift is a parameter-free prediction**, testable
against BAO. What is *not* derived: the coefficient k and the reservoir profile B(t).

→ [`docs/derivations/a2_flux_law.md`](docs/derivations/a2_flux_law.md)

### δ ≈ const from homothetic symmetry

The one assumption behind the a² derivation (the brane keeping a fixed relative distance
from the growing horizon) is **not** assumed in the self-similar regime: the Vaidya geometry
admits the homothetic Killing vector η = v∂_v + r∂_r (Bengtsson-Senovilla), which preserves
x = v/r, making δ = r_brane/r_h − 1 independent of v. **Valid in the self-similar
(primordial) regime; not claimed exact at late times.**

→ [`docs/derivations/delta_homothetic.md`](docs/derivations/delta_homothetic.md)

---

## Key numerical results

| Result                      | Value          | Observed  | Discrepancy |
| --------------------------- | -------------- | --------- | --------------- |
| **Hubble quadrupole**       | **1.6%**       | **< 3% (Cowell)** | **Gaia-testable** |
| Ω_DM/Ω_b (from asym)        | 5.62           | 5.41      | 3.8%            |
| m_DM (from cost mechanism)  | ~150 MeV       | —         | ~ Λ_QCD *(prediction, unverified)* |
| w(z) crossing               | z ≈ 0.45       | DESI      | compatible 0.7σ *(see caveat)* |
| Today on Area/M curve       | 93.7% of max   | —         | DE weakening    |
| Chirality inversion         | r_h = 0.173 L  | universal | geometric       |

---

## Repository layout

```
├── README.md
├── STATUS.md                          ← Claim-by-claim status table
├── CHANGELOG.md                       ← What changed, when, why
├── docs/
│   ├── COMPLETE_NARRATIVE_model.md    ← Start here: full story in English
│   ├── RACCONTO_COMPLETO_modello.md   ← Italian version
│   ├── risposta_critiche_referee.md   ← Response to structural critiques
│   ├── MODEL_synthesis_EN.md          ← Technical synthesis (EN)
│   ├── MODEL_apparatus_EN.md          ← Technical apparatus (EN)
│   ├── MODELLO_sintesi.md             ← Sintesi tecnica (IT)
│   ├── MODELLO_apparato.md            ← Apparato tecnico (IT)
│   ├── REGOLE_metodo.md               ← Methodology rules
│   ├── derivations/                   ← a² flux law, homothetic δ
│   └── open_questions/                ← unresolved / possibly numerology
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

## Confidence labels used throughout

- **[V]** verified with explicit calculation
- **[L]** anchored to published literature
- **[O]** order-of-magnitude estimate
- **[A]** motivated assumption
- **[S]** speculation
- **[?]** open conjecture

## Known structural limits

- **Flux profile Ṁ(t):** the **a² exponent is now derived** from the 5D Einstein equations
(July 2026, see above) — this limit is partially lifted. What remains phenomenological: the
coefficient k and the reservoir profile B(t). These still control the number of inflationary
e-folds (N≈60 requires Ṁ≈0.012 in units of L), so the inflation mechanism is physically
motivated but **not yet quantitatively predictive**.
- **SU(3) non-diagonal generators:** H₂(S³) = 0 blocks them geometrically. Requires
Sasaki-Einstein Y^{p,q} manifolds (string theory).
- **Full holographic stress tensor:** boundary stress tensor partially verified (g₀, g₂ sectors). Full g₄ sector with complete de Haro-Skenderis-Solodukhin counterterms requires Cadabra/xAct with complete de Haro-Skenderis-Solodukhin counterterms. *(For the two-spin conformal boundary the
conformal flatness makes g₍₄₎ analytically accessible — see the quadrupole result.)*
- **S₈ ≈ 0.83** vs 0.766 observed: tension reduced to ~2.8σ, ~8% unexplained.
- **Higgs / electroweak VEV:** an input, not derivable (eight attempts failed; recorded as a negative result).

The brane causality critique is resolved: Apostolopoulos-Tetradis 2004/2005 covers
the dynamic case exactly. The brane is timelike at r_b > r_h.

---

## Key references

- Gibbons-Lu-Page-Pope (2004): MP-AdS5 metric [hep-th/0404008]
- Apostolopoulos-Tetradis (2004/2005): Mirage brane cosmology
- Balasubramanian-Kraus (1999): Holographic stress tensor [hep-th/9902121]
- Awad-Johnson (1999): Holographic stress tensor for rotating AdS [hep-th/9910040]
- Hawking-Hunter-Taylor (1998): Rotating AdS5 black holes
- Bengtsson-Senovilla (2010): Trapped surfaces, homothetic Vaidya [arXiv:0912.3691]
- Cowell et al. (2023) / Pantheon+ anisotropy [arXiv:2411.10838]
- Rasulian (2024): Brane-horizon cosmology [arXiv:2408.15166]
- DESI Collaboration (2024/2025): Dark energy dynamics

---

*Read `docs/COMPLETE_NARRATIVE_model.md` for the full physical story.*
*Read `docs/risposta_critiche_referee.md` for the structural critique responses.*

**Criticism is the point.** If something here is wrong, numerology, or already known,
please open an issue.
