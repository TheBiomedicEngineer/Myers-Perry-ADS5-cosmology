# Results: Dark-Energy Quadrupole → Hubble Anisotropy (July 2026)

## Summary

The two-spin geometry predicts an **anisotropic quadrupole in the Hubble
expansion of amplitude ≈ 1.6%**, oriented along the axis set by the two
distinct rotation planes. This is below the current observational ceiling
(Cowell et al. 2023, ~3%) but **above the Gaia sensitivity threshold (~1%)**,
making it a near-term falsifiable prediction.

> **Status:** [C] amplitude — conditional on the corrected conformal boundary
> and on shear being the right observable; **[V]** structure ∝ D; boundary
> stress tensor validated against literature. Final verdict awaits Gaia.
> See `STATUS.md` for the label scheme.

---

## The obstruction that was removed

For many attempts the boundary stress-tensor integral diverged at the poles
of the squashed S³ as 1/(1−u)⁴. This was traced to an **incorrect boundary
metric** (g_θθ = 4), which gives a Ricci scalar that diverges at the axis —
violating regularity.

The correct boundary metric of the two-spin Myers-Perry-AdS₅ conformal
boundary (a rotating Einstein universe, Hawking-Hunter-Taylor 1998;
Awad-Johnson hep-th/9910040) has:

```
ds²(∂) = −dt² + dθ² + (sin²θ/Ξ₁) dφ₁² + (cos²θ/Ξ₂) dφ₂²
```

with **g_θθ = 1**, squashing only in the angular directions. For this metric:

- **R(g₀) = 6**, finite and smooth everywhere, poles included [V]
- **Weyl tensor = 0 → conformally flat** [V]

The conformal flatness is decisive: for a CFT on a conformally flat 4D
background the boundary stress tensor has **no free dynamical part** — it is
fixed by geometry plus the conformal anomaly. Unlike the generic case
(Figueras-Tunyasuvunakool 2013, which requires 128-bit numerical bulk
integration), here g₍₄₎ is analytically accessible.

---

## Validation against Awad-Johnson

The holographic stress tensor built on the full boundary metric (with the
frame-dragging cross terms g_{tφᵢ}) reproduces the known angular momenta:

```
J₁/J₂ = (a₁/a₂)(Ξ₂/Ξ₁) = 1.698167     (machine-precision match) [V]
```

This confirms the tensor structure is correct before reading any new quantity.

---

## The correct observable: shear, not energy density

Cowell et al. (2023) and the Pantheon+ anisotropy analysis (arXiv:2411.10838)
show the Hubble quadrupole is sourced by the **shear** σ_μν of the expansion:

```
H(e) = (1/3)θ − eᵘaᵤ + eᵘeᵛσᵤᵥ
```

Peculiar velocity contributes only a dipole; the anisotropic shear
contributes the quadrupole (Darling 2014). The relevant quantity is therefore
the traceless spatial shear — the **difference of the angular pressures**
between the two rotation planes — normalised to the expansion (energy density,
via Friedmann):

```
sigma  = (p_φ₁ − p_φ₂)/2 = 0.003751
rho  = |T⁰₀|           = 0.233419
quadrupole = sigma/rho     = 1.607%
```

Stable (mean = RMS, no cancellation). Cross-checked: this coincides with the
closed form **D/(Ξ₁+Ξ₂) = 1.607%**, giving two independent derivations of the
same number.

---

## Observational verdict

| Quantity | Value |
|---|---|
| Hubble quadrupole | **≈ 1.6%** |
| Cowell 2023 ceiling | ~3% (λ ~ 0.02–0.03) — **model passes** |
| Gaia sensitivity | ~1% — **model visible** |
| Predicted proper motions | ~0.32 μas/yr (calib. arXiv:1512.08917) |

The model is **not excluded today** but makes a sharp, falsifiable prediction
that Gaia DR4/DR5 will confirm or rule out.

### Discriminant vs. the Dark Dimension

The Dark Dimension programme (Lüst-Montero-Vafa) predicts an **isotropic**
dark-energy sector — no quadrupole. The two-spin model predicts a **1.6%
quadrupole with a definite axis**, the signature of the two distinct spins.
Gaia can distinguish the two scenarios.
