# Homothetic derivation of δ ≈ const

**Status:** [C] — valid in the self-similar regime; **not claimed exact at late times**.
**Date:** 2026-07-14

---

## 1. What needed fixing

The derivation of the a² flux law (`a2_flux_law.md`, §4b) requires that the
brane keeps a **fixed relative distance** from the horizon while the horizon
grows:

    r_brane = (1+δ) r_h    with    δ ≈ const

Without this, the constant (1+δ)⁻² could not be absorbed into the coefficient k.
Until now δ≈const was an assumption.

---

## 2. What did not work (recorded for completeness)

Fixing δ via **stable circular orbits** of a probe brane in the effective
potential (Alexander, hep-th/9912037) does **not** close the problem: with the
correct DBI potential f = 1 − 2m/(r⁴Λ) there is **no stable orbit without bulk
friction**. Alexander's own stabilisation mechanism requires three ingredients
together — rotation (frame-dragging deflects the brane away from the horizon),
bulk expansion (Hubble damping), and virialisation — and he leaves dynamical
capture as work in progress.

This route is therefore not sufficient. Recorded so it is not re-attempted.

---

## 3. What works: homothetic symmetry [V]

In the **self-similar regime** m(v) = μv — which is the primordial regime, i.e.
exactly where the a² law is used for inflation — the Vaidya geometry admits a
**homothetic Killing vector** (Bengtsson & Senovilla, arXiv:0912.3691):

    η = v ∂_v + r ∂_r

whose flow lines are confined to hypersurfaces of constant x = v/r.

**Verification:**

    η(x) = v ∂_v(v/r) + r ∂_r(v/r) = v·(1/r) + r·(−v/r²) = v/r − v/r = **0**

so x = v/r is preserved along the flow.

**Consequence.** With a self-similar horizon r_h = c·v and a brane sitting at
constant x_brane = v/r_brane:

    δ = r_brane/r_h − 1 = (v/x_brane)/(c·v) − 1 = **1/(c·x_brane) − 1**

which is **independent of v**: δ is constant.

**Interpretation.** Self-similarity *is* the absence of a privileged scale.
There is nothing with respect to which δ could vary. In this regime δ≈const is
not an assumption but a consequence of an exact symmetry of the geometry.

**Rotating case.** Support from the quasi-stationary Kerr-Vaidya horizon
location (arXiv:2101.03948), ingoing (accreting) case — the relevant one here.

---

## 4. Limits and open point

- **Regime.** The argument holds where the geometry is self-similar (m∝v), i.e.
  the primordial/inflationary regime. At late times (r_h ~ L) self-similarity
  breaks and δ≈const reverts to an approximation — but there the (1+2a²/L²)
  correction of `a2_flux_law.md` §3 already accounts for the deviation.
- **Open [?]:** does the brane's own backreaction spoil the homothety? The
  argument above treats the brane as following the geometry; a self-consistent
  treatment including backreaction has not been done.
