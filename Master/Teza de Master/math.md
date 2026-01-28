# Formulare matematică — Funcția de fitness pentru optimizarea tastaturilor (versiune revizuită)

## 1. Notă introductivă

Vom nota cu bold variabilele principale și vom explica pentru fiecare:

- ce reprezintă;
- dacă notația e standard (p. ex. distanță euclidiană, Legea lui Fitts) sau convenție definită în această lucrare (custom);
- modul de calcul.

Vom presupune un text de intrare compus din $N$ caractere/apasări de taste (după mapare), parcurs secvențial de la $k=1$ la $k=N$.

---

## 2. Funcția de fitness — nivel înalt

$$F = w_d \cdot \operatorname{norm}(D_{\text{total}}) + w_t \cdot \operatorname{norm}(T_{\text{total}})$$

- **$F$** — scorul de fitness (scop: **minimizare**).  
  *Notare*: convenție proprie; standard în GA e să minimizăm costuri sau să maximizăm fitness — dacă se dorește maximizare se poate folosi $F' = 1 - F$.
- **$w_d, w_t$** — ponderi pentru termenii de distanță și timp; recomandat:
  $$w_d = w_t = 0.5$$
- **$\operatorname{norm}(\cdot)$** — funcție de normalizare pe intervalul [0,1], cu $X_{\min}=0$ și $X_{\max}$ stabilit empiric sau teoretic.

---

## 3. Modelul de dispozitiv și asignarea degetelor

- Există **10 degete distincte**: le notăm $f \in \mathcal{F} = \{1,\dots,10\}$.
- Fiecare deget operează pe un **subset fix de taste**, dat de modelul ergonomic/layout.
- Funcție de asignare tastă→deget:
  $$\pi: \mathcal{K} \to \mathcal{F}$$
  unde $\mathcal{K}$ este mulțimea tastelor fizice.

---

## 4. Distanța totală ($D_{\text{total}}$) — definiție precisă

$$D_{\text{total}} = \sum_{k=1}^{N} d_k$$

- **$d_k$** — distanța parcursă de degetul $f_k = \pi(k)$ pentru a ajunge la tasta corespunzătoare apasării $k$.

### 4.1 Calcul local (distanță euclidiană)

$$d_k = \sqrt{(x(k) - x^{(f_k)}_{k-1})^2 + (y(k) - y^{(f_k)}_{k-1})^2}$$

- Poziția tastelor în plan Cartesian: $(x(k),y(k))$.
- Poziția curentă a degetului $f$ după pasul $k-1$: $(x^{(f)}_{k-1},y^{(f)}_{k-1})$.

### 4.2 Actualizare poziții (stateful)

După apăsarea $k$:

$$(x^{(f_k)}_k, y^{(f_k)}_k) := (x(k), y(k))$$

Pentru celelalte degete $g \neq f_k$:

$$(x^{(g)}_k, y^{(g)}_k) := (x^{(g)}_{k-1}, y^{(g)}_{k-1})$$

### 4.3 Resetare periodică

La fiecare $M$ taste procesate:

$$(x^{(f)}_k, y^{(f)}_k) \leftarrow (x^{\text{home}}_f, y^{\text{home}}_f), \quad \forall f \in \mathcal{F}$$

---

## 5. Grupuri de apăsări (paralelismul / simultaneitatea)

- Grup $G$ = subsecvență maximală de apasări consecutive în care fiecare deget apare cel mult o singură dată:
  $$f_p \neq f_q, \quad \forall p,q \in [i,j],\ p\neq q$$
- Notare: $G_g$ — grupul g-lea, iar $G = \{G_1,\dots,G_{\max}\}$.

---

## 6. Timpul total ($T_{\text{total}}$) — cu TPS scalar simplificat

$$T_{\text{total}} = \sum_{g=1}^{G_{\max}} T_{\text{group}}^{(g)}$$

$$T_{\text{group}}^{(g)} = \max_{f\in \mathcal{F}_g} TS_f^{(g)} + \sum_{f\in \mathcal{F}_g} TPS_f$$

- $\mathcal{F}_g$ — mulțimea degetelor active în grup $g$.
- TPS simplificat: scalar fix per deget $f$, independent de diferențe de timp între degete.

---

## 7. Setul timpilor simultani — $TS$ (Legea lui Fitts)

$$TS_f^{(g)} = a_f + b_f \cdot \log_2\left(1 + \frac{D_f^{(g)}}{W_f}\right)$$

- $a_f, b_f$ — coeficienți empirici pentru degetul $f$.
- $D_f^{(g)}$ — distanța de la poziția curentă a degetului $f$ la tasta din grupul $g$.
- $W_f$ — width asociat tastei pentru degetul $f$.

---

## 8. Penalizările de sincronizare simplificate — TPS

$$TPS_f = \tau_f \ge 0$$

- Scalar fix pentru fiecare deget.
- Reflectă viteza / puterea fiecărui deget. Degetele mai rapide → valori mai mici, degetele mai lente → valori mai mari.
- Nu mai depinde de grup sau diferențe de timp, simplificând calculul.

---

## 9. Normalizare

$$\operatorname{norm}(X) = \frac{X}{X_{\max}}, \quad X \in \{D_{\text{total}}, T_{\text{total}}\}$$

- Alegere: $X_{\min} = 0$.
- $X_{\max}$ se poate determina teoretic, empiric sau prin percentilă.

---

## 10. Rezumat compact al formulelor cheie

1. **Fitness:**
   $$F = w_d \cdot \operatorname{norm}(D_{\text{total}}) + w_t \cdot \operatorname{norm}(T_{\text{total}})$$

2. **Distanța totală:**
   $$D_{\text{total}} = \sum_{k=1}^{N} \sqrt{(x(k)-x^{(\pi(k))}_{k-1})^2 + (y(k)-y^{(\pi(k))}_{k-1})^2}$$

3. **Timp total:**
   $$T_{\text{total}} = \sum_{g=1}^{G_{\max}} \left(\max_{f \in \mathcal{F}_g} TS_f^{(g)} + \sum_{f \in \mathcal{F}_g} TPS_f \right)$$

4. **Legea lui Fitts:**
   $$TS_f^{(g)} = a_f + b_f \cdot \log_2\left(1 + \frac{D_f^{(g)}}{W_f}\right)$$

5. **TPS simplificat:**
   $$TPS_f = \tau_f$$

6. **Normalizare:**
   $$\operatorname{norm}(X) = \frac{X}{X_{\max}}$$

---

## 11. Parametri ce trebuie raportați în teză

- $w_d, w_t$ — ponderi.
- $M$ — fereastra de reset.
- Coeficienți Fitts: $a_f, b_f$ pentru fiecare deget $f$.
- $W_f$ — width per tastă / per deget.
- $\tau_f$ — scalar per deget (TPS).
- Metoda de alegere a $X_{\max}$ pentru normalizare.
- Descrierea funcției de mapare $\pi$ (care taste sunt atribuite fiecărui deget).
