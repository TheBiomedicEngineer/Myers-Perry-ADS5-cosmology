# α: numerical correspondence — audit and open questions

**Status:** [?] — open. **Not claimed as a physical derivation.**
**Date of downgrade:** 2026-07-14

This file collects, in full, what the programme found about the fine-structure
constant and why it is **no longer presented as a result**. It is kept because
the correspondence is numerically striking and someone may see what is missing —
or may show it is a coincidence.

---

## 1. The correspondence

Horizon angular velocities, evaluated at the baryogenesis freeze-out
r_bario = 0.191 L, with a₁=0.222 L, a₂=0.135 L:

    Ω₁ = a₁(1−a₁²)/(r_bario²+a₁²) = 2.460898
    Ω₂ = a₂(1−a₂²)/(r_bario²+a₂²) = 2.422762

    S_Ω = Ω₁+Ω₂ = 4.883661
    D_Ω = Ω₁−Ω₂ = 0.038136
    R_Ω = Ω₁·Ω₂ = 5.962171

**At the Z scale:**

    α = D_Ω/S_Ω = 0.038136/4.883661 = 0.007809 = **1/128.1**    (obs. 1/127.9, Δ=0.1%)

**At low energy — two non-coinciding forms:**

| form | expression | value | Δ vs 1/137.036 |
|---|---|---|---|
| simplified | 3·D_Ω/(R_Ω+2S_Ω) | 1/137.5 | 0.33% |
| physical | D_Ω/(R_Ω·f + S_Ω(1−f)), f=0.2951 | 1/136.4 | 0.5% |

The transition function f(E) is obtained from the roots of the geometry's
quadratic equation (not assumed): f(E) = 1 − (u₂−u₁). Its limits are
f→1 (α = D_Ω/R_Ω = 1/156, pure frame-dragging) and f→0 (α = D_Ω/S_Ω = 1/128).
The value f=0.2951 corresponds to the **photon pair-creation threshold**
(E = 2·HD_min), the geometric analogue of 2mₑ in QED.

---

## 2. Why this is NOT claimed as a derivation

**2.1 Not parametrisation-independent.** Ω₁ and Ω₂ are themselves functions of
a₁ and a₂. The internal audit's own verdict on the relation was: *"algebra of
definitions, near-tautological — not a discovery."* Building a ratio out of two
quantities that are both defined from the same two inputs does not, by itself,
constitute a prediction.

**2.2 The two low-energy forms do not agree.** 1/137.5 and 1/136.4 come from two
different choices:
- the simplified form corresponds to **f = 1/3 exactly** (since
  R·⅓ + S·⅔ = (R+2S)/3) — a round number, not the physical value;
- the physical form uses f = 0.2951, derived at the pair-creation threshold.

They differ. There is no principled reason so far to prefer one. A relation
whose value depends on which of two "natural" simplifications one picks is not
a prediction.

**2.3 The exact value needs a shifted energy.** α = 1/137.036 exactly would
require E = 1.883·HD_min, not 2·HD_min. The "2×" threshold is an approximation.

---

## 3. Notation error (corrected 2026-07-14)

Earlier versions of the README wrote this as **"α = D/S"**. This is ambiguous
and, read literally with the spin-based D and S used elsewhere in the model,
**wrong**:

    D_a/S_a = (a₁²−a₂²)/(a₁²+a₂²) = 0.031059/0.067509 = **0.46**   ≠ 1/128

The relation uses the **angular velocities** (D_Ω, S_Ω), not the spins. Any
reader doing the arithmetic with the published notation would have found 0.46.
Two distinct quantities were being called "D":

    D_spin = a₁²−a₂² = 0.031059    → used in the quadrupole
    D_Ω    = Ω₁−Ω₂   = 0.038136    → used here

---

## 4. Open questions

1. Is there a reason, from the geometry, to prefer f=1/3 or f=0.2951 — or is
   the ambiguity itself the signal that the relation is not meaningful?
2. Can any version of this be made parametrisation-independent, i.e. can α be
   obtained without building a ratio of two functions of the same two inputs?
3. Should the correspondence simply be dropped as numerology?

Contributions or refutations welcome.
