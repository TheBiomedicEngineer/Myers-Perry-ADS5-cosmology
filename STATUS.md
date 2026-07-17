# STATUS — claim-by-claim

**Last audit:** 2026-07-14

Status legend (the repository's existing scheme):
- **[V]** verified with explicit calculation
- **[L]** anchored to published literature
- **[O]** order-of-magnitude / solid but not blinded
- **[A]** motivated assumption
- **[S]** speculation
- **[?]** open conjecture

Where a claim holds *only under stated assumptions*, the assumption is named in
the "Depends on" column.

---

| Claim | Status | Depends on | Missing verification |
|---|---|---|---|
| **Hubble quadrupole ≈1.6%** (amplitude) | [O] | correct conformal boundary; shear as the observable | Gaia measurement; independent check of the shear→observable projection |
| Quadrupole **structure ∝ D** | [V] | two-spin geometry | — |
| Conformal boundary: **Weyl=0, R=6** | [V] | xAct/xCoba computation | — |
| Holographic stress tensor **J₁/J₂=1.698167** | [V] | validated vs Awad-Johnson | — |
| **a² flux law**: dm/dτ = H a²(1+2a²/L²) | [O] | brane=horizon; δ≈const; def. of H | independent check; late-time regime |
| — its small-radius limit S/H = a²B | [O] | a≪L (exact to 1.9% at a=0.0968L) | — |
| — predicted low-z correction (1+2a²/L²) | [O] | same as above | test against BAO; degeneracy check |
| **δ≈const** (self-similar regime) | [O] | homothetic Killing vector η=v∂_v+r∂_r; m∝v | brane backreaction on the homothety |
| **Flux coefficient k** | [P] | fit | derivation from bulk dynamics |
| **Reservoir profile B(t)** | [P] | fit | derivation from bulk dynamics |
| **Baryon asymmetry: sign** | [V] | Dirac-Kerr QFT; CPT check exact | — |
| Baryon asymmetry: **value asym=0.178** | [O] | relative angular velocity at AdS boundary | greybody factors, dilution → η~10⁻⁹ |
| **Ω_dm/Ω_b = 5.618** (obs. 5.41, Δ3.8%) | [O] | asym | — |
| **DM gauge-neutral (C₂=0)** | [V] | S-pure singlet | — |
| **DM ≈ CDM-like** (free-streaming ~2pc) | [O] | m_DM | — |
| **m_DM ≈ 151 MeV** | [O] | QCD scale as input | experimental detection |
| **Chirality** (left-handed trapping) | [O] | Pöschl-Teller reduction | full Dirac equation in AdS₅ |
| **α = D_Ω/S_Ω = 1/128.1** (M_Z) | [?] | Ω₁,Ω₂ (functions of a₁,a₂) | parametrisation independence — see open_questions |
| α low-energy (1/137.5 **or** 1/136.4) | [?] | choice of f | two non-coinciding forms; unresolved |
| **w(z) crosses −1** | [O] | source equation ρ'+3Hρ=S | — |
| Transient vs ΛCDM on **raw DESI BAO** | [?] | — | **indistinguishable** (χ²=2.91 vs 5.97, 3-4 params vs 1 on 5 points) |
| **Inflation N≈60** | [?] | Ṁ≈0.012 (in units of L) | derivation of Ṁ(t) — mechanism motivated, not predictive |
| **H₀≈67, r_d≈147** | [O] | N_eff=3.044, no EDE | — |
| **L↔r_d bridge**, L≈85 μm (±4%) | [O] | ρ_DE | — |
| **S₈ ≈ 0.83** (obs. 0.766) | [?] | — | ~8% gap; tension 2.8σ |
| **Higgs / VEV** | [?] | — | input, not derived (8 attempts failed) |
| **cos4θ** term in the quadrupole | [?] | — | extra signature or missing piece? |

---

## Dependency chain of the flagship results

```
two spins (a₁, a₂)          ← only genuine inputs
   ├── D_spin = a₁²−a₂² ──── quadrupole ≈1.6% [O] ── Gaia test
   ├── asym = 0.178 [O] ──── Ω_dm/Ω_b = 5.618 [O]
   └── horizon r_h ────────── a² flux law [O]
                                └── needs δ≈const [C, homothetic]
                                └── k, B(t) still [P]
                                     └── inflation N≈60 [?]
```

## Parameter count

- **Genuine inputs: two** (a₁=0.222L, a₂=0.135L).
- **Parameter-free consequences:** Ω_dm/Ω_b, asym, quadrupole (∝D_spin).
- **Near-tautological:** α (Ω are functions of a₁,a₂) — see open_questions.
- **Still phenomenological:** k, B(t).
- On raw DESI BAO the model is *compatible*, not *preferred*.
