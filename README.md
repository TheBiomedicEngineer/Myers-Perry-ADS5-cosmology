# A Geometric Exploration of Myers-Perry AdS5 Cosmology
### Holographic Brane-World Model: A Toy Theory

**Status:** Exploratory phenomenological programme — not a peer-reviewed publication.  
**Author:** Anonymous (biomedical engineer with a personal interest in theoretical physics)  
**Period:** May–June 2026  
**Approach:** AI-assisted analytical exploration (Claude, Mathematica/xCoba, Python)

> *This repository documents an amateur exploratory programme. The goal was understanding,
> not publication. Mathematical rigour is maintained where possible; every claim is labelled
> by confidence level. The work is shared openly so that anyone searching this geometric
> configuration can find a starting point.*

---

## Overview

A 3-brane lives on the S³ horizon of a two-spin Myers-Perry-AdS5 black hole. Matter, dark
energy, chirality, and the baryon asymmetry emerge from the geometry of two asymmetric
spins (a₁ = 0.222 L, a₂ = 0.135 L).

## The Central Idea: D as the source of Standard Model asymmetries

The most original feature of this work is the role of the **anisotropic channel D = a₁² − a₂²**
as a shared geometric source of multiple apparently unrelated phenomena:

- **Chirality** — the frame-dragging inversion at r_h = √(a₁a₂) produces a Pöschl-Teller
  potential that traps only left-handed fermions. No scalar field added by hand: it emerges
  from the pure Myers-Perry metric with a₁ ≠ a₂.
- **Baryogenesis** — D changes sign at the inversion, defining a geometric freeze-out of
  the baryon asymmetry at asym = 0.178 (r_bario = 0.191 L).
- **EW gauge structure** — D carries the quadrupole and the electroweak sector.
- **DE dynamics** — D contributes to the anisotropic component of the boundary stress tensor,
  producing w(z) that crosses −1 in the direction observed by DESI.

In standard cosmology, these phenomena are explained by four separate mechanisms. Here
they are four projections of the same geometric asymmetry.

## Key numerical results

| Result | Value | Observed | Discrepancy |
|--------|-------|----------|-------------|
| Ω_DM/Ω_b (from asym) | 5.62 | 5.41 | 3.8% |
| m_DM (from cost mechanism) | ~150 MeV | — | ~ Λ_QCD |
| w(z) crossing | z ≈ 0.45 | DESI | compatible 0.7σ |
| Today on Area/M curve | 93.7% of max | — | DE weakening |
| Chirality inversion | r_h = 0.173 L | universal | geometric |

Scripts produce these numbers. The result files in `/results` confirm the model runs
and gives values close to observation.

## Repository Structure

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

## Confidence labels used throughout

- **[V]** verified with explicit calculation
- **[L]** anchored to published literature
- **[O]** order-of-magnitude estimate
- **[A]** motivated assumption
- **[S]** speculation
- **[?]** open conjecture

## Known structural limits

1. **Flux profile Ṁ(t):** not derivable from first principles — requires numerical 5D
   Einstein-Vaidya on supercomputers.
2. **SU(3) non-diagonal generators:** H₂(S³) = 0 blocks them geometrically. Requires
   Sasaki-Einstein Y^{p,q} manifolds (string theory).
3. **Full holographic stress tensor:** requires Cadabra/xAct with complete
   de Haro-Skenderis-Solodukhin counterterms.

The brane causality critique is resolved: Apostolopoulos-Tetradis 2004/2005 covers
the dynamic case exactly. The brane is timelike at r_b > r_h.

## Key references

- Gibbons-Lu-Page-Pope (2004): MP-AdS5 metric [hep-th/0404008]
- Apostolopoulos-Tetradis (2004/2005): Mirage brane cosmology
- Balasubramanian-Kraus (1999): Holographic stress tensor [hep-th/9902121]
- Rasulian (2024): Brane-horizon cosmology [arXiv:2408.15166]
- DESI Collaboration (2024/2025): Dark energy dynamics

---

*Read `docs/COMPLETE_NARRATIVE_model.md` for the full physical story.*  
*Read `docs/risposta_critiche_referee.md` for the structural critique responses.*
