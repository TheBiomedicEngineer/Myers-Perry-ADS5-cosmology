# APPARATUS — calculations and literature anchors
## Supporting MODEL_synthesis_EN.md

Each entry [n] is either a CALCULATION (verifiable, with formula/result) or a LITERATURE ANCHOR
(with reference). Type indicated at the head of each.

---

**[1] — LITERATURE.** Two-spin Myers–Perry–AdS solution in 5D: Gibbons–Lü–Page–Pope (GLPP), "The
general Kerr–de Sitter metrics in all dimensions", hep-th/0404008. Two-rotation-parameter metric
form (a1, a2) used as bulk.

**[2] — CALCULATION.** Ricci scalar of the GLPP metric computed in xCoba/xAct (Mathematica):
R = −20/L² exact, consistent with AdS5 (R = −d(d−1)/L² for d=5 → −20/L²). Verification of the vacuum
solution with cosmological constant.

**[3] — CALCULATION.** Decomposition ρ²=r²+(S/2)+(D/2)cos2θ with S=a1²+a2², D=a1²−a2². Algebraic
identity directly from the form of ρ² in the two-spin metric; S and D are the two invariants
(symmetric and antisymmetric) buildable from the squared moduli of the two spins.

**[4] — CALCULATION + DOWNGRADE.** DM = pure-S sector with C2=0. The step "trace/traceless
orthogonality ⇒ C2=0 exact" was recognised (review #2) as a categorial slip (the decomposition of
T_μν is not the gauge charge). Downgraded to [S]. Remains: mass from S directly, null gauge as a
hypothesis requiring a symmetry reason, not a geometric one.

**[5] — CALCULATION.** Ω_dm/Ω_b = 1/asym, asym = tanh(Ω_H/2T_H) evaluated at the attractor spins
(a1=0.222, a2=0.135) → asym≈0.178 → ratio 5.62; observed 5.41 (3.8% discrepancy). Mass-free
(independent of the DM mass). Anti-circular provenance (asym had been fixed for something else, not
to obtain this ratio).

**[6] — CALCULATION (double method).** (a) Holographic stress tensor via Balasubramanian–Kraus on the
boundary: density = monopole S + quadrupole D·cos2χ, pure (no cos4χ), zero trace (Ward identity).
(b) Israel tensor on the brane side (script israel_due_spin.wls): same result. proper ε=−Sᵗₜ. The
convergence of the two methods is a strong consistency check; NOT an independent verification because
both start from the same MP-AdS5 geometry. It is the only unsought result that held against the
guardian.

**[7] — CALCULATION + REFUTATION.** Test of the coincidence D/S = m_h/VEV at the attractor spins:
~9% discrepancy, out of tolerance. Discarded as numerical coincidence, not structure.

**[8] — REASONING + LITERATURE.** The additive conserved quantities of a hole (mass, angular
momentum) survive as sums; the internal structure (correlations) is of a different nature. Anchor:
holographic conservation of information (see [18]).

**[9] — CALCULATION.** dim SU(3)=8; dim SO(4)=6 (isometry of S³). 8>6 ⇒ SU(3) is not a subgroup of the
isometries. Verified also including the four coordinates (no combination closes onto su(3)). Confirmed
by the KK l=2 degeneracy on S³ (=9=8+1) incompatible for integer isospin vs the half-integer required
by the adjoint.

**[10] — REASONING.** The reference frame that survives the collapse is the attractor (the centre),
because the pieces mix and lose mutual identity while the attractor does not collapse. The position
relative to the attractor = position on the holographic horizon. (Review #3: "known privileged
reference", not "unique" — sufficiency, not proven necessity.)

**[11] — CALCULATION.** a_writing ~ 26/m from T_mat~1/a and m/T~26 (typical freeze-out x_f).
Independent of the form of a(t). The horizon grows monotonically r_h(t), so r is in monotone
correspondence with time (map, not ontological identity — review #3).

**[12] — LITERATURE.** Flux tubes as colour-hair mechanism: Coleman–Preskill–Wilczek, hep-th/9201059.
Segment shape between charges, finite width, Fermat–Steiner junctions for more than two charges.
Weakened non-abelian no-hair: Ashtekar et al., gr-qc/0011081. Flux direction = Cartan element
diag(−1,−1,2).

**[13] — CALCULATION.** Quadratic brane regime H²∝ρ² with radiation ρ∝a⁻⁴ → H²∝a⁻⁸ → a∝t^(1/4).
Corrects the earlier a∝√t (valid only in the standard Friedmann regime, not in the primordial brane
one).

**[14] — REASONING (corrected en route).** The 4D space (a,χ,φ₁,φ₂) with independently active
coordinates replaces the earlier rigid hierarchy S⊂D⊂R (artefact). Which coordinate each channel uses
follows from which are already committed: S→a, D→χ, R→phases.

**[15] — CALCULATION.** a1−a2 is recoverable from S,D: from a1²+a2² and a1²−a2² one gets a1,a2, hence
a1−a2. So a1−a2 is redundant (error corrected). The relative phase φ₁−φ₂ (difference of angular
positions) is NOT recoverable from S,D (which are functions of the amplitudes): it is independent.

**[16] — CALCULATION + LITERATURE.** φ₁,φ₂ = two U(1) = torus U(1)×U(1), rank 2. The maximal torus of
SU(3) is U(1)×U(1) (rank 2). Consistency with the flux tube diag(−1,−1,2): Cartan element, zero trace
(= confinement/singlet). Literature on the Cartan via torus: toric AdS/CFT, see [23].

**[17] — SYNTHESIS.** Outcome of the four nodes of reviews #4–#5, detailed in [18]–[21].

**[18] — LITERATURE.** Holographic scrambling: the information of infalling matter is conserved but
delocalised (from local to correlational) after the scrambling time, intact before with unitary
fidelity. Hayden–Preskill, arXiv:0907.1190; decoherence-after-scrambling model, arXiv:1605.02061;
scrambling time from horizon-fluid, arXiv:2211.07946. CAVEAT (review #5): scrambling makes
R=correlations a NATURAL interpretation, not the CONFIRMATION (it holds for all information, it does
not select R).

**[19] — CALCULATION.** Horizon capacity: dS_BH = dM/T_H bits added per piece. For m≫T_H, dS≫1 ≫ bits
needed to register the piece. Plus the second law dS_BH≥0: capacity grows with each piece and does not
saturate.

**[20] — CALCULATION.** (Dynamics) d(φ₁−φ₂)/dt = Ω₁−Ω₂ = a1/(r_h²+a1²) − a2/(r_h²+a2²): the evolution
is fixed by the spins, but the initial phase is free (dof of R). (Operator) Q_i=−i∂/∂φ_i, conjugate
momentum, gives two commuting diagonal charges = Cartan. Limit: integer eigenvalues, not the specific
values of the colour charges (review #5: "compatible, not identified").

**[21] — CALCULATION.** Homology of S³: H₀=Z, H₁=0, H₂=0, H₃=Z. H₂=0 ⇒ no 2-cycle. In toric models the
off-diagonal generators live on 2-cycles of Sasaki–Einstein manifolds with H₂≠0. The 8>6 barrier thus
has a topological name: H₂(S³)=0.

**[22] — FORMULATION (review #5).** Official state adopted after five reviews: rank-2 structure
compatible with the Cartan of colour; full SU(3) and charge values = input.

**[23] — LITERATURE.** Toric AdS/CFT: the U(1)ⁿ isometries of the Sasaki–Einstein horizon give the
flavour/gauge charges; precisely a U(1)² satisfies the Killing-spinor condition (Franco–Hanany–
Martelli, hep-th/0505211). The non-abelian group emerges from branes wrapped on cycles (example:
SU(ℓ) from M2-branes on resolution cycles, arXiv:2105.11567). Difference from the present model: there
the internal geometry is designed (chosen Calabi–Yau + branes), here it is received from an Einstein
solution; consequently there one obtains the full group, here one stops at the Cartan (consistent with
[21]).

**[24] — CALCULATION.** Ω₁−Ω₂ = (1+r_h²)[a1(a2²+r_h²)−a2(a1²+r_h²)] / [(a1²+r_h²)(a2²+r_h²)]. Numerator
factorises into (a1−a2)(r_h²−a1·a2): sign change at r_h=√(a1·a2) (geometric mean of the spins).
(Ω₁−Ω₂)² has there the global minimum (=0) with dE/dr_h=0 and d²E/dr_h²≈132>0 (real well). Limits:
r_h→0 gives ~(a2−a1)/(a1a2) (strong), r_h→∞ gives a1−a2 (saturates). Invariant T_inv/T_S =
√(a1/a2+a2/a1) = 1.501 (depends only on the spin ratio; √2 for equal spins).

**[25] — CALCULATION.** Rotational energy of the hole contained in S and D (the two spins squared).
The relative phase: velocity d(φ₁−φ₂)/dt driven by the spins (energy already in S,D); the initial
condition costs zero (position, not momentum). So R integrates information, not energy. Confinement:
flux-tube tension = energy in the field (input), not in the hole.

**[26] — CALCULATION.** Measure on the phase torus invariant under U(1)×U(1) = flat (dφ₁dφ₂/(2π)²) →
equiprobability. Attempt of "channel-weight" via continuous volume DISCARDED: for continuous
coordinates, "inactive channel" = fixed phase = zero measure ⇒ singlet never formed (absurd). With
discrete charges (integer eigenvalues, [20]) the count is well defined = dimension of the
representation.

**[27] — CALCULATION.** With discrete equiprobability, the types weigh as dim of the representations
(1:2:3 for singlet:doublet:triplet) = standard count g\*. Shear correction: exp(−(Ω₁−Ω₂)²/T)
[assumption on the form], between ~0.78 (extreme epoch) and 1.00 (at the minimum), hence a few-%
modulation. Privileged formation mass m\*~1/√(a1·a2) (geometric units). NOT computable in absolute
terms without geometric-units↔GeV anchoring.

**[28] — CALCULATION + DISCARDS.** asym inversion at √(a1·a2): three anchors tested and discarded.
(Higgs) the profile (Ω₁−Ω₂)² has a minimum at the centre, the Higgs potential has a maximum: opposite
topology. (Matter/antimatter) requires breaking with a permanent choice; here there is transit (r_h
grows, crosses). (SM chirality) weak chirality is universal, the sense here is epoch-dependent and
inverts at the threshold, giving net chirality ~0; moreover the effect is ~10⁻¹⁰, below threshold.

**[29] — LITERATURE.** Microstate→radiation map: universal open problem (firewall, islands, Page
curve). Not specific to the model.

**[30] — CALCULATION (conditional theorem).** If the Cartan is realised by the phases φ₁,φ₂ (one
generator per phase), the number of diagonal generators = number of independent phases = number of
spins of the hole. For two spins: rank 2. Distinct from circularity (one does not assume rank 2 to
prove it; one assumes Cartan=phases). Tension: SM rank=4≠2.

**[31] — CALCULATION (exclusion, Option A).** Cartan requirements: abelian algebra, rank 2, quantized
generators, holographic survival. Coordinate-by-coordinate test: a1,a2 are parameters (not operators,
they fail algebra and quantization); r is not periodic (continuous spectrum); χ has rank 1 and
boundaries (χ=0,π/2 are poles, not a U(1) phase) and is already committed to D. Only φ₁,φ₂ pass all
requirements. They are the only two independent periodic coordinates of the horizon. Residue: the list
of coordinates must be complete — closed by [32].

**[32] — LITERATURE.** A squashed S³ breaks the SO(2r) isometry of S^(2r−1) to its Cartan U(1)^r; for
S³ (r=2) the isometry is exactly U(1)×U(1) = Cartan of SO(4) (Hama–Hosomichi–Lee and follow-up; SYM
on squashed spheres arXiv:2110.13065; localization on Hopf surfaces arXiv:1805.11076; Berger sphere).
The Hopf phases φ₁,φ₂ are the two generators; χ is the base coordinate with boundaries (the conditions
f(0)=ℓ₂, f(π/2)=ℓ₁ avoid conical singularities on the phase circles), not a periodic phase. Confirms
that there is no third independent periodic coordinate: the residue of [31] is closed by construction
of the squashed geometry. Makes the rank theorem unconditional.

**[33] — CALCULATION.** Q_i=−i∂/∂φ_i on a periodic phase φ_i∼φ_i+2π has integer spectrum (standard).
The periodicity of the phases forces the quantization of the Cartan charges. Interpretive limit: it
gives "integers", not "these integers" — the weight lattice (which colour charges) remains input, like
the six off-diagonal generators (geometrically excluded by H₂(S³)=0, entry [21]).

**[34] — LITERATURE (Witten no-go).** Pure Kaluza–Klein on a smooth compact manifold does not give
chiral fermions: the internal angular momentum manifests in 4D as a charge of both handednesses, which
double in second quantization (Witten 1981; reviews hep-ph/0111334, hep-ph/0412208, arXiv:0710.1956;
Physics of Extra Dimensions literature). It is the defect that marginalised KK. The geometric "sense"
of our model (J_i linear in a_i, audit cont.16) is precisely the quantity that does not suffice.

**[35] — LITERATURE (chirality in AdS+brane).** In the AdS5+brane class chirality is a standard
mechanism: Randall–Sundrum, domain-wall fermions, warped fermions (hep-lat/0503011 Warped Domain Wall
Fermions; arXiv:1505.01061; arXiv:1908.00915; review hep-ph/0111334 §3.5.2). The Witten no-go does not
apply because localization occurs in the radial direction of the bulk, not by index on a compact
manifold.

**[36] — LITERATURE (flux route, closed for us).** Randjbar-Daemi–Shaposhnikov, "Fermion zero-modes on
brane-worlds" (hep-th/0008079): chiral fermions from a gauge flux / monopole / instanton on the
internal manifold K, with the number of families tied to the charge and topology of K (e.g. K=S² with
U(1) monopole of charge n → n families). Requires H₂(K)≠0 (a 2-cycle). Our horizon S³ has H₂=0: the
first Chern number is not defined, the mechanism does not start. Same topological wall as the
off-diagonal generators ([21]). We are neither a rewrite of [36] nor do we inherit its result.

**[37] — CALCULATION (chirality via domain-wall, works).** Dirac equation on the brane with Yukawa
coupling η·Ψ̄·F(φ)·Ψ, kink F = flux that changes sign at √(a1a2) (frame-dragging inversion, audit
cont.243). With physical kink F=v·tanh(kz) the Schrödinger potential is exactly Pöschl–Teller:
V_L = (ηv)² − [(ηv)²+ηvk]·sech²(kz). Left-handed zero-mode |ψ_L0|²=cosh(kz)^(−2ηv/k)~exp(−2ηv|z|)
normalizable/localised; right-handed divergent/non-normalizable → only one handedness = chirality.
Spectrum E_n=A²−(A−nk)², A=ηv: n=0 is the massless chiral zero-mode, n≥1 massive modes (KK tower) that
do not affect the zero-mode. Dependence: slope ∝2√(a1a2), amplitude ∝|D|=|a1²−a2²|; a1=a2 → null kink
→ chirality lost. Requires a1≠a2, the same condition as quadrupole and colour (a single origin, three
sectors). The kink is output of the rotating geometry, not input as in the other models. Limits:
Yukawa assumed not derived; zero-mode profile, not full Dirac index (number/handedness of families
open, blocked by H₂(S³)=0).

**[38] — CALCULATION.** T_mat ~ 1/a ~ 1/r_h (plasma). r_h grows always → T_mat falls always,
monotone. Consistent with observation (CMB cools). CORRECTED ERROR: the rise of T_geom (horizon)
was confused with the temperature of matter — they are the two different ends of the Tolman gradient.

**[39] — CALCULATION + LITERATURE.** T_geom = (1+2r_h²)/(4πr_h) (Schwarzschild-AdS5). Minimum
at hinge r_h = L/√2 (Hawking-Page transition). Rise for r_h > L/√2: AdS curvature compresses large
hole instead of letting it expand freely → heating. Hawking-Page [L]: large AdS black holes are hot,
small are cold — standard structure (Hawking-Page 1983).

**[40] — CALCULATION.** Re-encounter T_geom = T_mat: r_h = √((4π−1)/2) = 2.405L. Beyond: T_geom >
T_mat, Tolman gradient inverted, horizon can re-radiate toward brane. Thresholds: inversion 0.173L,
hinge 0.707L, re-encounter 2.405L.

**[41] — CALCULATION (parametrised destiny).** Flux tail Ṁ ~ t^(−p). Total mass M_tot determines
asymptotic r_h via M = r_h²(1+r_h²). Thresholds: M(hinge) = 0.75, M(re-encounter) = 39.2 (two
orders of magnitude, because M ~ r_h⁴ at large r_h). Generic scenario (p>1, declining flux): r_h
stops at 0.7–1.2L, Big Freeze. Re-fusion requires p≤1 or multi-episode accumulation. AdS black hole
stable (does not radiate below Hawking-Page) = permanent accumulator: open destiny if bulk pours
again (Matte). All conditioned on Ṁ not derived (master node).

**[42] — CALCULATION (asym_MP_AdS5_due_spin.wls, 14/06).** Exact GLPP formulas for T_H and
Omega_i in MP-AdS5 two spins. r_extreme=0.168L (T_H=0), r_inv=0.173L (asym sign change),
r_bario=0.191L (asym=0.178, baryogenesis freeze-out, eta freezes). asym today=0.055 (exact
MP-AdS5). Discrepancy with A.3 (Kerr 4D): Kerr with a/M=0.222 gives 0.892, not 0.178.
The 0.178 coincides with asym_MP-AdS5(r_bario=0.191L) — not an audit error.

**[43] — CALCULATION.** m_DM from formation cost. n_DM/n_bar = costo_bar/costo_DM/asym =
6/1/0.178 = 33.7. Omega_DM/Omega_bar = (m_DM/m_bar)*33.7 = 5.41 → m_DM = 150.5 MeV.
m_DM ~ Λ_QCD without having put it in. 34 DM per baryon. Compatible BBN/CMB/structure/DD [V].

**[44] — LITERATURE (14/06).** Braneworld dark energy in light of DESI DR2 (2025, JCAP):
braneworld models compatible with decaying DE and w=−1 crossing. BellDE Hussain 2505.09913:
bell-shaped DE on DESI. Grey Galaxies 2412.06904: two distinct spins, boundary tensor = sum
of two pieces. Our specific assembly (D as shared source of baryogenesis+quadrupole-DE,
dipole forbidden by parity) not in literature. [L]
