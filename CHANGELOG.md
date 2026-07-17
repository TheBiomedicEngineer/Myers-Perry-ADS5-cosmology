# CHANGELOG

All notable changes to this programme are recorded here.
Status labels follow `STATUS.md`.

---

## 2026-07-14 — Major audit

### Added
- **Hubble quadrupole** (`results/hubble_quadrupole.md`): amplitude ≈1.6%,
  axis set by the two-spin geometry, falsifiable with Gaia (~1% sensitivity;
  predicted proper motions ~0.32 μas/yr). Two independent routes agree:
  shear/ρ = 0.016070 and D_spin/(Ξ₁+Ξ₂) = 0.016072.
  Includes the corrected conformal boundary (g_θθ=1, R=6, Weyl=0, verified with
  xAct/xCoba) which removes the 1/(1−u)⁴ polar divergence that had blocked this
  calculation for many attempts — the divergence came from an incorrect angular
  normalisation (g_θθ=4), not from physics.
  Holographic stress tensor validated against Awad-Johnson (J₁/J₂=1.698167).
- **a² flux law derivation** (`docs/derivations/a2_flux_law.md`): from the 5D
  Einstein equations on Vaidya-AdS₅, T_vv = 3(dm/dv)/r³; with the horizon
  condition and brane=horizon this gives the full law
  **dm/dτ = H a² (1 + 2a²/L²)**. Pure a² is the **small-radius limit**
  (exact to 1.9% at the horizon-area minimum a=0.0968L); at a=1.44L the
  correction factor is 5.15. The low-z correction (1+2a²/L²) is a
  parameter-free prediction, testable against BAO.
- **Homothetic derivation of δ≈const** (`docs/derivations/delta_homothetic.md`):
  in the self-similar regime (m∝v) the Vaidya geometry admits the homothetic
  Killing vector η = v∂_v + r∂_r (Bengtsson-Senovilla, arXiv:0912.3691), whose
  flow preserves x=v/r; hence δ = r_brane/r_h − 1 is v-independent. Valid in the
  self-similar regime; **not claimed exact at late times**.
- `STATUS.md` — claim-by-claim table with dependencies and missing checks.
- `CHANGELOG.md` — this file.

### Corrected
- **D/S notation** (internal working notes). α = 1/128.1 uses the **angular
  velocities** (D_Ω=Ω₁−Ω₂=0.038136, S_Ω=Ω₁+Ω₂=4.883661 → D_Ω/S_Ω=0.007809),
  **not** the spins: D_a/S_a = (a₁²−a₂²)/(a₁²+a₂²) = **0.46**, a different
  quantity. Two distinct objects were being called "D". Documented so the
  distinction is explicit in anything published.
- **DESI comparison.** Made explicit that against **raw** BAO data the transient
  model and ΛCDM are **indistinguishable** (χ²=2.91 vs 5.97, but 3-4 parameters
  vs 1 on 5 points — not statistically significant). The model's w(z) is not
  CPL, so w₀/wₐ comparisons are not meaningful. Compatibility, not evidence.

### Downgraded
- **α** → published for the first time, and **as an open question, not a result**.
  (It was never in the public README; the internal audit had it as a central
  claim.) The relation is not parametrisation-independent (Ω₁,Ω₂ are themselves
  functions of a₁,a₂ — "algebra of definitions"), and the low-energy value has
  **two non-coinciding forms**: simplified 3D_Ω/(R_Ω+2S_Ω)=1/137.5 (f=1/3
  exactly) vs physical D_Ω/(R_Ω f + S_Ω(1−f))=1/136.4 with f=0.2951 at the
  pair-creation threshold. See `docs/open_questions/`.
- **m_DM ≈ 151 MeV** → conditional/model-dependent prediction (not
  experimentally verified).
- **Chirality** (Pöschl-Teller trapping) → candidate mechanism; requires the
  full Dirac equation in AdS₅.
- **Baryogenesis**: the **sign** of the asymmetry remains a verified QFT result
  (Dirac-Kerr, CPT check exact); the **value** (asym=0.178) is conditional and
  the observed η~10⁻⁹ still requires greybody factors and dilution.

### Note on labels
The repository's existing scheme is kept: [V] verified, [L] literature-anchored,
[O] order-of-magnitude, [A] assumption, [S] speculation, [?] open. `STATUS.md`
adds, per claim, what it depends on and what verification is missing.
