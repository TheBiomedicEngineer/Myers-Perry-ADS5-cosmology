#!/usr/bin/env python3
"""
ANISOTROPIA / SHEAR DA MOMENTO DEL FLUSSO
==========================================
Conto INDIPENDENTE dal bulk, fatto all'indietro: dal limite osservativo
di isotropia ricaviamo quanto momento netto e' permesso nel flusso, e su
quale scala puo' nascondersi.

Inquadramento (correzione di Matte): l'asimmetria NON e' la rotazione del
bulk impressa direttamente; e' il momento angolare del flusso in caduta che
produce dilatazione asimmetrica. La conservazione del momento OBBLIGA
un'anisotropia residua.

Punto chiave: lo shear cosmico obbedisce a
    sigma_dot + 3 H sigma = S_momento(a)
cioe' la STESSA struttura dell'equazione della dark energy del modello.
=> vale lo stesso criterio della coda attiva (vedi calc_coda_attiva.py).

Limiti osservativi (verificati su letteratura):
  Saadeh et al. 2016 (Planck), arXiv:1605.07178 : (sigma_V/H)_0 < 4.7e-11  [vettoriale]
  Planck (rotazione globale)                      : (omega/H)_0  < 7.6e-10
  Scholarpedia (stima ruvida da CMB)              : (sigma/H)_0  < ~1e-9
  Pontzen-Challinor, MNRAS 462,1802               : (sigma_T/H)_0 < 2.4e-7  [tensoriale "regolare"]
"""
import numpy as np

# Limiti osservativi
LIM = {
    "vettoriale (vorticita')":      4.7e-11,
    "rotazione globale":            7.6e-10,
    "stima CMB ruvida":             1.0e-9,
    "tensoriale 'regolare' (grande scala)": 2.4e-7,
}

def evoluzione_shear():
    print("="*64)
    print("EVOLUZIONE DELLO SHEAR")
    print("="*64)
    print("""
sigma_dot + 3 H sigma = S_momento(a)   [stessa forma della DE]

Senza sorgente:  sigma ~ a^-3  (qualunque anisotropia iniziale si diluisce
                                 come 1/volume: viene STIRATA VIA).
Con sorgente (momento che arriva col flusso): sigma sostenuto, e vale lo
stesso CRITERIO DELLA CODA ATTIVA. Se il momento ha coda lenta, resta un
residuo di anisotropia OGGI; quel residuo cresce con quanto e' attivo il
flusso ora.
""")

def conto_allindietro():
    print("="*64)
    print("CONTO ALL'INDIETRO: quanto momento netto e' permesso?")
    print("="*64)
    print("""
sigma/H oggi ~ grado di sbilanciamento del momento netto tra i due assi
             = (momento non cancellato) / (flusso totale).

Con due assi (Myers-Perry, ortogonali a 90 gradi) i momenti si cancellano
PARZIALMENTE; il residuo netto e' cio' che si vede. Il limite osservativo
dice quanto piccolo deve essere il residuo:
""")
    for nome, val in LIM.items():
        print(f"  sigma/H < {val:.1e}   ({nome})")
    print("""
=> il momento NETTO deve stare tra ~1e-11 (se si scarica sui modi locali)
   e ~1e-7 (se si scarica sul modo di grande scala) del flusso totale.
""")

def due_letture():
    print("="*64)
    print("DUE LETTURE  (e dove sta la via d'uscita)")
    print("="*64)
    loc = LIM["vettoriale (vorticita')"]
    big = LIM["tensoriale 'regolare' (grande scala)"]
    print(f"""
LETTURA A - modo LOCALE (vettore/scalare): limite durissimo ({loc:.0e}).
  Se i due assi non si cancellassero quasi perfettamente, il modello
  sarebbe gia' escluso => richiederebbe fine-tuning. BRUTTO.

LETTURA B - modo di GRANDE SCALA (tensoriale): limite {big:.0e},
  ~{big/loc:.0e}x piu' largo. La letteratura (Pontzen-Challinor, Saadeh+2016)
  dice che questo modo PUO' CRESCERE da un universo quasi isotropo e vive
  sulle grandi scale. E' la via "su scala piu' grande" intuita da Matte,
  e ha aggancio reale.

margine tra i due limiti: fattore {big/loc:.1e}
""")

def conclusione():
    print("="*64)
    print("CONCLUSIONE")
    print("="*64)
    print("""
1. Il momento del flusso PRODUCE shear, governato dalla stessa equazione
   della dark energy. Conservazione del momento => anisotropia obbligata,
   non si diluisce via se il flusso la alimenta.

2. Il modello NON e' escluso, MA a condizione: il momento netto deve
   scaricarsi quasi tutto sul MODO DI GRANDE SCALA (tensoriale, <1e-7),
   non sui modi locali (<1e-11). Condizione fisicamente sensata: il flusso
   agisce sull'intero orizzonte, non localmente.

3. Se cosi', e' compatibile coi limiti E affiorerebbe come anomalia di
   grande scala - dove le anomalie del CMB effettivamente si vedono.
   La quantita' e' legata allo sbilanciamento dei due spin (~4.5).

COERENZA: e' la 2a grandezza (dopo la DE) governata da [X]_dot+3H[X]=S.
DE (densita') e anisotropia (momento) = due facce dello stesso flusso.

CAVEAT: il conto dice DOVE l'anisotropia puo' stare e dove NO, non QUANTA
ce n'e' (dipende dal momento del flusso = bulk non derivato). E' un VINCOLO
sul modello, non una predizione di numero. Anomalie = "non escluse",
condizione naturalmente possibile, NON predette. Sono anche osservativamente
contestate, quindi non un pilastro.

PROSSIMO CONTO POSSIBILE: lo shear di grande scala con coda lenta cresce
o decresce oggi? Se decresce -> coerente con DE calante (stesso "dopo il
picco" del flusso).
""")



# ============================================================
# AGGIUNTA: legge di scala della VORTICITA' (vortici dal momento del flusso)
# Regola standard del tubo di vortice (Helmholtz-Kelvin), dai testi.
# ============================================================
def vorticita_scaling():
    import numpy as np
    print("="*64)
    print("VORTICITA': come scala un vortice stirato dall'espansione")
    print("="*64)
    print("""
Regola del tubo di vortice (fluido ideale, dai testi): omega * A = cost,
con A = sezione del tubo. In espansione isotropa ogni lunghezza ~ a:
  - lunghezza del vortice  L ~ a   (piu' grande, come intuiva Matte)
  - sezione A ~ a^2  =>  vorticita'  omega ~ 1/A ~ a^-2  (piu' debole)

Importanza relativa osservabile omega/H:
  - regime MATERIA   (H~a^-3/2):  omega/H ~ a^-1/2   (decade DOLCE)
  - regime RADIAZIONE(H~a^-2):    omega/H ~ a^0 = COSTANTE (non si diluisce)
  - regime DE        (H~cost):    omega/H ~ a^-2     (decade in fretta nel futuro)
""")
    a_rec = 1/1100
    print(f"Da ricombinazione a oggi (materia): omega/H calato di "
          f"(1100)^-1/2 ~ {1/np.sqrt(1100):.3f} (fattore ~{np.sqrt(1100):.0f}).")
    print("""
LETTURA: i vortici primordiali oggi sono GRANDI in scala ma DEBOLI in
intensita' relativa (decadimento DOLCE a^-1/2, non a^-3 come lo shear).
Nel primordiale (radiazione) NON si diluiscono affatto. Quindi sopravvivono
a lungo; basta un rialimento modesto dal flusso (criterio coda attiva) per
tenerli osservabili oggi su GRANDE SCALA, deboli.

CORREZIONE registrata: la previsione 'i vortici restano dominanti crescendo'
era SBAGLIATA; il conto (verificato sui testi) da' 'grandi ma sbiaditi'.

CAVEAT: fluido ideale, espansione isotropa. GR piena (formalismo di Ellis)
puo' correggere l'esponente; il VERSO (decadimento lento, omega~a^-2) e'
robusto e coerente coi testi (regola del tubo di vortice).

PREDIZIONE BLINDATA: la conservazione del momento del flusso VIETA
l'isotropia perfetta. Deve esistere anisotropia residua non nulla, grande
scala, debole, intensita' dal bulk (non derivata). Falsificazione vera =
isotropia esatta. NON si appoggia all'asse del male (contestato).
""")

if __name__ == "__main__":
    evoluzione_shear()
    conto_allindietro()
    due_letture()
    conclusione()
    vorticita_scaling()
