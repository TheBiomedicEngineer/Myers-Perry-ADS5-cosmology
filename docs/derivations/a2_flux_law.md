# Derivation of the a² flux law from the 5D Einstein equations

**Status:** [C] — conditional on the assumptions listed in §4.
**Date:** 2026-07-14

---

## 1. What was open

The source term feeding dark energy on the brane has always been written

    S = k · a² · B

(a = scale factor, B = bulk reservoir, k = coefficient). The **a² exponent** was
*motivated* — the capture cross-section of the horizon scales with its area —
but never *derived* from the bulk equations. This was the programme's central
open node.

---

## 2. Derivation

### 2.1 Flux term from 5D Einstein [V, symbolic]

Ingoing Vaidya-AdS₅:

    ds² = −f(v,r) dv² + 2 dv dr + r² dΩ₃²
    f    = 1 − 2m(v)/r² + r²/L²

Computing G_vv symbolically on the **full 5D metric** (the S³ angular part
included):

    G_vv = 3(dm/dv)/r³  −  [ 6/L² − 12m/(L²r²) + 6r²/L⁴ ]
           └── flux ──┘     └──── AdS background ────┘

so the flux term is

> **T_vv = 3 (dm/dv) / r��**

**Consistency check (passed).** Integrating over the S³ area (2π²r³):

    dM/dv = [3(dm/dv)/r³] · [2π²r³] = 6π² (dm/dv)

The r-dependence cancels — confirming that m is the mass.

> **Pitfall:** truncating the metric to the (v,r) block gives G_vv = 0. The flux
> source lives in the **angular** curvature; it disappears if the S³ part is
> dropped.

### 2.2 Horizon condition

The apparent horizon satisfies f(v,r_h) = 0:

    1 − 2m/r_h² + r_h²/L² = 0    ⟹    m = (r_h²/2)(1 + r_h²/L²)

### 2.3 Brane = horizon, and the definition of H

With the brane identified with the horizon, a = r_h (up to the constant factor
of §4b), and by definition H ≡ (dr_h/dτ)/r_h, i.e. dr_h/dτ = H·r_h.

Differentiating m(r_h) along the flow:

    dm/dτ = (dm/dr_h)(dr_h/dτ) = [ r_h(1 + 2r_h²/L²) ] · (H r_h)

> **dm/dτ = H · a² · (1 + 2a²/L²)**

---

## 3. Result and regime

The **full law** is dm/dτ = H a²(1+2a²/L²). Pure a² is its **small-radius
limit**:

| regime | a | correction factor (1+2a²/L²) | comment |
|---|---|---|---|
| Inflation (horizon-area minimum) | 0.0968 L | **1.019** | a² exact to 1.9% |
| Late time / dark energy | 1.44 L | **5.15** | pure a² **not** valid |

So, for a ≪ L:

    S/H = a²      and with a finite reservoir      **S/H = a² B**

which is exactly the phenomenological form previously fitted to raw DESI BAO
data — now with its exponent derived rather than assumed.

**Prediction.** The (1+2a²/L²) factor is a parameter-free geometric correction
to the flux law at low redshift. It is testable against BAO data (subject to a
degeneracy check against other parameters).

---

## 4. Assumptions — each checked

**(a) Independence from the time coordinate.** ✔
dm/dτ = r_h(dr_h/dτ) holds in *any* time coordinate: the chain rule absorbs
dv/dτ, since dm/dτ = (dm/dv)(dv/dτ) = r_h(dr_h/dv)(dv/dτ) = r_h(dr_h/dτ). And
H ≡ (dr_h/dτ)/r_h is the definition in that same coordinate. The exponent does
not depend on the v↔τ mapping.

*(Noted while checking: a brane exactly on the apparent horizon would be null —
at f=0 one gets dτ² = −2(dr_h/dv)dv². The physical brane therefore sits just
outside, r_brane = r_h(1+δ). This motivates (b).)*

**(b) Is a = r_h exact?** ✔ (exponent unaffected)
No: a = r_brane = (1+δ)r_h. But m is a function of r_h, so dm/dτ = r_h(dr_h/dτ)
exactly; substituting r_h = a/(1+δ):

    dm/dτ = H a² / (1+δ)²

The **exponent stays 2**; the constant (1+δ)⁻² is absorbed into k.
This requires **δ ≈ const** → derived in `delta_homothetic.md` for the
self-similar regime.

**(c) Regime.** ✔ (quantified in §3)
a² is exact for a≪L; at late times the (1+2a²/L²) correction applies and is
predicted, not fitted.

---

## 5. What this does NOT establish

- The **coefficient k** and the **reservoir profile B(t)** remain
  phenomenological. They control the number of inflationary e-folds
  (N≈60 requires Ṁ≈0.012 in units of L) — the inflation mechanism is
  physically motivated but **not yet quantitatively predictive**.
- On **raw** DESI BAO data the transient model and ΛCDM are
  **indistinguishable** (χ²=2.91 vs 5.97, but 3-4 parameters vs 1 on 5 points —
  not significant). This derivation improves the model's internal consistency;
  it does not by itself constitute observational evidence.

---

## 6. Reproduce

The Einstein tensor computation is a short symbolic calculation (SymPy):
build the 5×5 metric for ds² = −f dv² + 2dvdr + r²dΩ₃² with
dΩ₃² = dθ² + sin²θ dφ₁² + cos²θ dφ₂², compute Christoffels → Ricci → G_vv,
and read off the coefficient of dm/dv.
