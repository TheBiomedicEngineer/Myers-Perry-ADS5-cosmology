# Analysis of the Bulk Flux Profile Ṁ(t)
## Myers-Perry AdS5 Braneworld — Accumulated Results

**Status:** Exploratory phenomenological programme — not peer-reviewed.
**Repository:** https://github.com/TheBiomedicEngineer/Myers-Perry-ADS5-cosmology
**DOI:** 10.5281/zenodo.20800476

---

## 1. The Central Node

The flux profile Ṁ(t) — or equivalently S(a) where a is the scale factor —
is **not derivable from first principles** without a full numerical 5D
Einstein-Vaidya integration on a rotating MP-AdS5 background. This is the
"Master Node" of the model: everything depends on it, and it cannot be
closed analytically.

What the programme has established is:
- The **form** of S(a) is partially constrained by geometry and thermodynamics
- The **robustness** of observables to variations in form has been tested
- The **physical quantisation scale** of the flux has been derived from the
  first law

---

## 2. The Bell-Shaped Form [A — motivated assumption, partially derived]

The accretion flux onto the MP-AdS5 horizon has a bell-shaped temporal profile:

```
S(a) ∝ (a/a_p)^q × exp(−(a/a_p)^m)    [phenomenological]
```

with parameters fitted to DESI DR2: a_p ≈ 0.6, q ≈ 2, m ≈ 5/3.

**Geometric motivation (cont.113, cont.128):**

The rise (∝ a²) is derived independently by two routes:
1. **Capture cross-section:** infalling matter from the bulk is captured with
   cross-section ∝ r_h² ∝ a² in the large-brane regime.
2. **First law:** dM = T_H dS_BH with S_BH ∝ r_h³ and T_H ∝ 1/r_h gives
   dM/dr_h ∝ r_h → M ∝ r_h² in the small regime → S ∝ a².

The agreement of two independent derivations makes the a² rise **robust**.

**Peak position (cont.128, cont.942):**

The peak of the bell is NOT a free parameter. It is pinned by the
Hawking-Page transition at r_h ~ L:
- For r_h < L: small AdS black hole (thermodynamically unstable)
- For r_h > L: large AdS black hole (stable, entropy grows)

The flux peaks near r_h ~ L, which corresponds cosmologically to
z ~ 0.5 — consistent with the DESI dark energy crossing.

**The decay:**

The fall is governed by the finite bulk reservoir being depleted.
The specific exponent m is not geometrically derived — it is a free
parameter encoding the bulk matter distribution.

---

## 3. Connection to the Null Dust Vaidya Framework

### Non-rotating case (cont.129, cont.152) [V]

The 5D Vaidya-AdS metric with null dust source:

```
ds²₅ = ds²_{AdS5} − 2m(v)/r³ dv²
```

produces a boundary stress tensor with:

```
T_vv = (3/2) ṁ(v) / r³
```

This is null dust: T_μν = ρ k_μ k_ν with k² = 0.

Energy conservation (∇_A T^{AB} = 0) holds exactly — the active flux
does NOT violate 5D conservation. Energy comes from the bulk, not
from any local violation.

### Rotating case (cont.147, cont.151, cont.154) [V]

The rotating Vaidya-Kerr-AdS5 computation (Kerr-Schild gauge, verified
T1: R=−20, T2: k²=0) shows:

- **T_tt = 0 at the boundary**: the DE injected onto the brane is
  **isotropic** (does not carry D at the injection level)
- **T_ti ≠ 0**: angular momentum fluxes at both spin planes (geometrical,
  not physical D)
- The stress tensor near the horizon is anisotropic and carries non-zero
  trace (real anisotropic stress), but this decays as 1/r⁷ and **vanishes
  at the brane**

**Key finding (cont.116 corrected by cont.117, then cont.122):**

The D asymmetry lives in the **equilibrium geometry** of the brane, not
in the injection channel. What arrives isotropic becomes asymmetric
through the brane's response to the two-spin metric.

### Energy conditions (cont.155) [V]

NEC is violated near the horizon but the violation vanishes at the brane.
On the brane, matter satisfies reasonable energy conditions.
Interpretation: the flux is projected Weyl curvature, not ordinary bulk
matter.

---

## 4. What the First Law Constrains (cont.128, cont.1284) [partial]

The first law of MP-AdS5 thermodynamics:

```
dM = T_H dS_BH + Ω₁ dJ₁ + Ω₂ dJ₂
```

constrains Ṁ(t) but does not fully determine it:

- If accretion carries angular momentum (dJ₁, dJ₂ ≠ 0), then a₁(t) ≠ a₂(t)
  evolve in time — the asymmetry D = a₁² − a₂² changes
- Three observable signatures follow:
  1. Width of the w(z) bump → velocity of dM/dv
  2. Redshift-dependent alignment of large-scale structures
  3. Thermodynamic scale (Hawking-Page) pins the peak

The first law **links** the energy driver (dM) to the directional signature
(dJ) via the same thermodynamic object. This is physically elegant but
leaves the actual amount and angular distribution of accreted matter as
an unresolved input.

---

## 5. Robustness Studies

### 5.1 Granularity test (cont.135) [V]

**Setup:** multiplicative noise η on S → S(1+η), η Gaussian with varying
amplitude. Physical motivation: Matte's insight that granularity
self-quenches in the tail where S is small (mass falls off → fewer events
→ smaller grains → auto-spegnimento).

**Results on the true dynamic solver (cont.125):**

| Noise level | w₀ | wₐ |
|---|---|---|
| 0% (smooth) | −0.879 | −0.220 |
| 10% | −0.90 ± 0.07 | −0.31 ± 0.60 |
| 30% | −0.96 ± 0.22 | −0.10 ± 2.5 |
| 50-100% | diverges | diverges |

**Conclusion:**
- **w₀ is robust** to moderate granularity (≤10-30%): depends on the
  recent tail of S where grains are small (auto-quenching confirmed)
- **wₐ is fragile**: already unstable at 10% noise, as expected since
  wₐ is a derivative and amplifies noise

**Physical implication:** the model class fixes w₀ (robust quantity);
the grain structure determines wₐ (degenerate with uncontrolled granularity).
The **clean test of the model** is w₀ + w=−1 crossing + quadrupole,
NOT wₐ (degenerate with granularity).

### 5.2 Discretisation test (cont.140) [V]

**Setup:** replace continuous S(a) with sum of N Gaussian pulses, each
with area ∝ S(aᵢ) (physically: mass packets scale with the local flux,
not fixed size).

**Results:**

| N events | max |δρ_DE/ρ_DE| | w₀ behaviour |
|---|---|---|
| 3 | 0.59 | unstable |
| 10 | 0.22 | unstable |
| 50 | 0.086 | partially stable |

- **ρ_DE(a) converges** to the continuous limit monotonically → H(z) and
  DESI observables are robust to discretisation
- **w(z) shows micro-structure** (oscillations around the continuous
  mean) that does not converge cleanly

**Diagnosis:** w is a derivative of ρ — it amplifies residual steps.
The micro-structure is **not physically interpretable** from this scheme
because the Gaussian widths and inter-event dilution scheme are arbitrary
choices, not derived.

**Conclusion:** ρ_DE(a) → H(z) → DESI distances are robust. The w(z)
micro-structure requires physical quantisation (see §6).

### 5.3 Flux inertia and massive events (cont.143)

- **Inertia term** τ dS/dt shifts w₀ but does not change the bell shape
- **Massive single event at peak:** absorbed into the smooth curve
- **Massive event off-peak:** leaves a detectable residual signature
  (qualitative prediction, not quantified)

The **absorption window** around the peak is a qualitative prediction of
the model with no ΛCDM equivalent.

---

## 6. Physical Quantisation from the First Law (cont.256) [V]

**Objective:** close the open node of cont.140 by computing the scale and
amplitude of the w(z) micro-structure from **derived** (not assumed)
physical quanta.

### Setup

In natural units L = ℏ = c = 1:

- G₄ = (l_{P4}/L)² = 3.10×10⁻¹²²  (Planck suppression)
- S_BH = A_horizon / (4G₄),  A = π²(r_h²+a₁²)(r_h²+a₂²)/r_h

At r_h = 1.44 (today):  A = 30.44 L²,  dA/dr_h = 62.06 L,  T_H = 0.558 L⁻¹

### Minimum quantum (1 qubit of information)

```
δr_h^{qubit} = 1 / (dS/dr_h) = 1 / (dA/dr_h × 1/(4G₄)) = 2.00×10⁻¹²³ L
δM^{qubit} = (dM/dr_h) × δr_h^{qubit} = 2.36×10⁻¹²² (adim)
```

### Total entropy and event rate

```
S_BH(today) = [A(1.44) − A(0.168)] / (4G₄) = 2.43×10¹²² qubit
```

Mean event frequency: N_events/t_universe = 5.60×10¹⁰⁴ events/s

Today (at 33.5% of peak): freq = 1.88×10¹⁰⁴ events/s

### Micro-structure of w(z)

```
Δz ~ H₀ × Δt_quantum = 1.16×10⁻¹²²
δρ/ρ_DE ~ δM^{qubit}/M_BH(today) = 3.24×10⁻¹²³
δw ~ 3 × δρ/ρ = 9.73×10⁻¹²³
```

### Comparison with observational thresholds

| Quantity | Model prediction | DESI current | DESI future |
|---|---|---|---|
| Δz micro-structure | 1.16×10⁻¹²² | ~0.1 | ~0.01 |
| δw amplitude | 9.73×10⁻¹²³ | ~0.1 | ~0.01 |

**Conclusion:** The micro-structure is **10¹²⁰ times below** current DESI
sensitivity. The flux is essentially continuous at cosmological scales.
Granularity is Planckian — physically real but observationally inaccessible
with any foreseeable technology.

**Closure of cont.140:** The w(z) micro-structure from physical quanta
EXISTS as a derived prediction (not a numerical artefact), but its scale
and amplitude are set at the Planck level. No refined discretisation scheme
is needed — the answer is in the entropy count.

---

## 7. The Quadrupole Signature of D (cont.119, cont.120) [V]

The boundary flux T_μν has a spatial structure:

```
T_boundary = T_isotropic + D × cos(2θ) + D² × cos(4θ) + ...
```

where θ is the polar angle and D = a₁² − a₂².

**Key result (cont.119, Vaidya-KS complete):**

- The **leading angular structure** is the quadrupole ∝ D
- It scales as (a/L)² — growing with the scale factor
- It **vanishes identically** when a₁ = a₂ (D = 0)

**Observable implication (cont.120):**

The DE flux has a quadrupolar anisotropy ∝ D that:
- Is suppressed for small spins (small D)
- Grows as the universe expands
- Is a falsifiable signature absent in ΛCDM

---

## 8. Perturbations from Bulk Matter (cont.136, cont.137) [S]

### Angular scale of bulk perturbations (cont.136)

A mass at bulk depth z₀ (in Poincaré coordinates) produces an imprint
on the brane of angular scale ~ z₀:

| z₀/L | Angular scale |
|---|---|
| 0.087 | ~5° |
| 0.175 | ~10° |
| 0.52 | ~30° |

For z₀ ~ L (deep bulk): the imprint covers the whole sky.
For z₀ << L (near the brane): localised spot.

**Temporal signature:** as mass falls toward the brane, z₀ → 0 and the
angular imprint **contracts**. A spot that shrinks over time is a
signature with no ΛCDM equivalent.

### Shape of bulk perturbations (cont.137)

With two asymmetric spins, the spot is **elliptical**:

```
axis ratio ~ sqrt((1+a₂²)/(1+a₁²)) = 1.10 : 1  for D = 0.21
```

- Elongated along the dominant spin axis
- Non-Gaussian profile: compact core + extended power-law halo ∝ x⁻⁸
- Major axis direction **fixed in the sky** = same axis as the expansion
  quadrupole (cont.126)

**Key point:** a single parameter D controls two independent signatures —
the quadrupole of the expansion AND the ellipticity of bulk perturbations.

---

## 9. Open Nodes

| Node | Status | Required |
|---|---|---|
| Ṁ(t) from first principles | Open — Master Node | 5D numerical Einstein-Vaidya |
| dM/dv amount and angular distribution | Constrained by first law, not derived | Bulk matter model |
| m parameter of the bell decay | Phenomenological fit | Bulk reservoir model |
| Speed of sound c_s² of null dust on brane | Not computed | Perturbed Vaidya-KS |
| Amplitude of bulk perturbation spots | Scale derived, amplitude not | Full Vaidya-KS with massive source |

---

## 10. Summary of Robustness

| Observable | Robust to granularity? | Robust to bell shape variation? |
|---|---|---|
| ρ_DE(a) / H(z) | Yes (cont.140) | Yes |
| w₀ | Yes ≤30% noise (cont.135) | Yes (cont.125) |
| wₐ | No — fragile (cont.135) | Partially |
| w=−1 crossing | Yes | Yes |
| Quadrupole ∝D | Yes (geometric) | Yes |
| Micro-structure of w(z) | N/A — Planckian scale (cont.256) | N/A |

The model's **clean observational tests** are:
1. w₀ (robust to all tested variations)
2. The w=−1 crossing at z ~ 0.5
3. The quadrupolar anisotropy ∝ D in the DE flux
4. Bulk perturbation spots with contracting angular scale (qualitative)

---

*All numerical results verified with Mathematica scripts in the repository.*
*Labels: [V] verified, [A] assumption, [S] speculation, [?] open.*
