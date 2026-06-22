# Piano operativo Mathematica — derivare il quadrupolo via proiezione (SMS), passo 2

> Scopo: avere su carta ESATTAMENTE le equazioni e l'ordine, così in Mathematica si esegue
> e basta (licenza limitata, non bruciare tempo a capire). Ogni passo ha un RISULTATO ATTESO
> per accorgersi subito se è sbagliato (regola 12: un risultato "bello/atteso" va comunque controllato).
> Etichette: [V]=già verificato in sessioni precedenti (xCoba), [DA FARE]=nuovo.

## Quadro: le equazioni di Shiromizu-Maeda-Sasaki (SMS, gr-qc/9910076)

La cosmologia di brana NON usa direttamente Einstein 5D. Usa l'equazione di Einstein EFFETTIVA
sulla brana 4D, ottenuta proiettando con Gauss-Codazzi + junction di Israel:

  G_μν = −Λ₄ g_μν + κ₄² T_μν + κ₅⁴ π_μν − **E_μν**

dove:
- T_μν = materia sulla brana (per noi: poco/niente, la DE viene dal bulk);
- π_μν = termine quadratico in T_μν (trascurabile a bassa energia, ρ≪λ);
- **E_μν = proiezione del tensore di Weyl del bulk sulla brana** = il pezzo che porta
  l'informazione del bulk (massa + rotazione) sulla brana. È QUI che vive tutto.

E_μν si decompone (Maartens, hep-th/0303095) in:
  E_μν = −(κ₅/κ₄)⁴ [ U (u_μu_ν + ⅓h_μν) + **P_μν** + Q_(μu_ν) ]
- U = densità di energia "dark radiation" scalare → è il **μ/a⁴** di Maartens (isotropo, monopolo);
- **P_μν = stress anisotropo del Weyl proiettato** ← IL TERMINE CHE LA LETTERATURA AZZERA;
- Q_μ = flusso di energia (per ora 0, brana comovente).

**Il punto di tutto il programma:** la letteratura pone P_μν = 0 (astro-ph/0504226: "no evolution
equation, primarily assume zero"). Noi vogliamo CALCOLARLO dal bulk Myers-Perry-AdS5 a due spin e
vedere se ∝ D = a₁²−a₂².

---

## ORDINE DEI PASSI (eseguire in questo ordine)

### PASSO 2a — UN SOLO SPIN, validare l'impalcatura [DA FARE, leggero]
Metrica: Myers-Perry-AdS5 con a₂=0 (un solo spin a₁=a).
1. Caricare la metrica g_AB (5D) in xAct/xCoba (già fatto a 2 spin in cont.98-103; qui basta a₂→0).
2. Calcolare il tensore di Weyl 5D: C_ABCD.
3. Proiettare sulla brana (normale n^A all'orizzonte r_h~L): **E_μν = C_AμBν n^A n^B**.
4. Decomporre E_μν in U (traccia) e P_μν (parte senza traccia, simmetrica, ⊥u).
RISULTATO ATTESO: con UN solo spin, P_μν deve dare un quadrupolo **assisimmetrico** attorno
all'unico asse di rotazione → tipo Poplawski/dipolo-asse (un asse privilegiato). Se U riproduce
μ/a⁴ (Maartens), l'impalcatura è validata. **Se P_μν=0 anche con uno spin → fermarsi, qualcosa non torna.**

### PASSO 2b — DUE SPIN, accendere D [DA FARE, pesante — il cuore]
Metrica: a₁≠a₂ (entrambi).
5. Stessi passi 2-4 con due spin.
6. Estrarre la dipendenza angolare di P_μν. RISULTATO ATTESO (da verificare, NON assumere):
   la combinazione S=a₁²+a₂² nella parte isotropa (U), la combinazione **D=a₁²−a₂² nel quadrupolo
   di P_μν**, struttura cos2θ (+ coda cos4θ). Coerente con la curvatura di bordo già nota
   R=6−3S/L²−5D cos2θ/L² [V cont.100] e con lo scaling quad/mono=−0.259 D/L² [V cont.126].
7. CONTROLLO INCROCIATO: la traccia di E_μν deve riprodurre l'anomalia conforme già calcolata
   −(63/10000)(7−228cos2θ+21cos4θ) [V cont.102]. Se torna, P_μν è sullo stesso oggetto validato.

### PASSO 2c — la proiezione 4→3, il nodo aperto vero [DA FARE, geometrico]
ATTENZIONE (cont. ~1900, già intercettato da Matte): il bulk 5D ha 2 piani di rotazione su 4 assi
spaziali; la brana ne ha 3. La mappa (2 piani)→(3 assi spaziali della brana) NON è mai stata fatta.
8. Derivare come i due spin si proiettano sui 3 assi spaziali → fissa la FORMA del quadrupolo
   (assisimmetrico? tri-assiale? c'è un asse neutro?). Finché non fatto, NON affermare una forma
   specifica (l'assunto diag(a₁²,a₂²,0) è declassato a ipotesi).
RISULTATO ATTESO: nessuno pregiudiziale — è la parte genuinamente da scoprire.

---

## COSA SERVE CARICARE IN MATHEMATICA (lista secca per non perdere tempo)
- xAct + xCoba (già installati e validati, cont.98).
- La metrica MP-AdS5 a 2 spin in Boyer-Lindquist (file già usato cont.103; per 2a porre a₂=0).
- La macchina B-K (Balasubramanian-Kraus) per il tensore di stress di bordo — già validata
  (cont.110, riproduce i due J di Awad con fattore unico −2). Serve per il controllo incrociato 7.

## ORDINE DI PRIORITÀ se la licenza è corta
1. PASSO 2b punto 6 (D nel quadrupolo di P_μν) — è il risultato che conta.
2. Controllo incrociato 7 (traccia = anomalia nota) — conferma che è l'oggetto giusto.
3. PASSO 2a (un solo spin) — solo se serve validare prima; ma 2b+7 con D→0 lo contiene.
4. PASSO 2c (proiezione 4→3) — geometrico, può anche essere fatto a mano dopo.

## RISULTATO CHE CHIUDEREBBE IL PROGRAMMA
Se P_μν ≠ 0 e il suo quadrupolo ∝ D con la struttura attesa, e la traccia torna con l'anomalia,
allora il quadrupolo-DE è **derivato** (non assunto) dal P_μν che la letteratura azzera. Questo è
ciò che trasforma il "contributo candidato" da architettura a risultato. Resta separato il nodo
AMPIEZZA assoluta (richiede g(4) completo / normalizzazione) e la FORMA (passo 2c).
