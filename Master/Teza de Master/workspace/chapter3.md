# 3. METODOLOGIA

Acest capitol descrie pașii pentru optimizarea aranjamentelor de taste prin algoritmi genetici și simulare directă a procesului de tastare. Tastatura QWERTY reprezintă standardul actual, adoptat aproape universal datorită inerției istorice și compatibilității cu sistemele existente. Tehnologia actuală permite crearea de alternative superioare ergonomic: Dvorak, Colemak, Workman. Adoptarea lor rămâne limitată. Utilizatorii au format obișnuințe motorii puternice după ani de practică. Costurile reantrenării depășesc beneficiile pentru majoritatea. Compatibilitatea cu software-ul și hardware-ul existent creează bariere suplimentare.

Algoritmii genetici generează layout-uri optimizate, evaluate prin simulare directă pe texte reprezentative. Procesul permite reconstrucția experimentelor prin ajustarea parametrilor. Codul sursă public asigură reproducibilitatea. Layout-urile generate depășesc QWERTY, dar oferă îmbunătățiri marginale față de Colemak. Pentru utilizatori cu mobilitate normală, adoptarea nu se justifică. Beneficiile sunt insuficiente pentru a compensa efortul. Scenariile relevante vizează mobilitate inegală a mâinilor sau degetelor. Algoritmul genetic acceptă coeficienți de penalizare personalizați, generând layout-uri adaptate nevoilor individuale.

Structura capitolului: subcapitolul 3.1 descrie pregătirea seturilor de date textuale; 3.2 prezintă layout-urile logice și maparea pe poziții fizice; 3.3 detaliază modelele fizice ale tastaturilor și adnotarea acestora; 3.4 explică algoritmul genetic; 3.5 dezvoltă modelul matematic pentru evaluare, incluzând distanțe, grupuri de apăsări și formule de fitness.

## 3.1 Pregătirea Seturilor de Date

Pregătirea seturilor de date asigură testarea layout-urilor pe texte reprezentative pentru diverse domenii. Selecția surselor acoperă contexte multiple de tastare:

- texte narrative;
- cod sursă;
- discuții specializate.

Această diversitate permite evaluarea în condiții apropiate de utilizarea reală.

Sursele selectate sunt:

- Simple English Wikipedia;
- Project Gutenberg;
- The Algorithms;
- 20 Newsgroups.

Simple English Wikipedia s-a descărcat prin kagglehub, extras în directorul specificat. URL-ul utilizat este https://www.kaggle.com/datasets/ltcmdrdata/plain-text-wikipedia-simpleenglish. Fișierul AllCombined.txt conține textul complet al enciclopediei. Project Gutenberg oferă cărți populare prin https://www.gutenberg.org/browse/scores/top#books-last30, acoperind topul ultimelor treizeci de zile. Selecția include lucrările cu frecvența cea mai ridicată de descărcare. The Algorithms reprezintă repository-uri de cod din multiple limbaje de programare, clonate temporar în directorul temp_clones și procesate în data/the_algorithms_code. Colecția 20 Newsgroups, disponibilă prin identificatorul Kaggle crawford/20-newsgroups, include articole și discuții pe teme variate.

Unificarea seturilor s-a realizat prin scripturi Bash care parcurg directoarele recursiv. Comanda generală este:

```bash
find . -maxdepth 1 -type d -not -path '.' -exec sh -c 'find "$1" -type f -exec cat {} + > "${1%/}.txt"' _ {} \;
```

Aceasta extrage conținutul valid și concatenează fișierele într-un singur document text. Scripturile elimină caractere invalide și normalizează spațiile pentru consistență. Unificarea permite parcurgerea secvențială în simulare, calculând metrici fără extracții statistice explicite.

Pentru repository-urile de cod, scripturile extrag exclusiv conținut textual, evitând metadatele. Verificările de integritate menține fidelitatea datelor. Seturile acoperă:

- texte narative cu structură secvențială;
- cod sursă cu indentări specifice;
- articole cu terminologie specializată.

Această acoperire reflectă cerințele reale din domenii profesionale și personale. Comparațiile ulterioare validează convergența algoritmului genetic către soluții stabile. Volumul și diversitatea datelor sunt suficiente pentru evaluare robustă. Extinderi posibile includ date multilingve pentru alte limbi, dar focalizarea actuală rămâne pe limba engleză datorită disponibilității resurselor și standardizării caracterelor.

## 3.2 Layouturi Logice și Mapare Fizică

Layout-urile logice definesc aranjamentele de caractere pe pozițiile fixe ale tastaturii. Reprezentarea se bazează pe scheletul QWERTY standard pentru compatibilitate hardware. Fiecare layout este un șir ordonat de caractere, mapat unu-la-unu pe pozițiile fizice. Modificările rămân la nivel software, evitând intervenții hardware.

Layout-urile integrate în implementare sunt:

- QWERTY;
- Colemak;
- Dvorak;
- Workman;
- Norman;
- Asset;
- Minimak.

QWERTY servește drept baseline, permitând cuantificarea îmbunătățirilor aduse de variantele alternative. Colemak poziționează caracterele frecvente în zona centrală a tastaturii, reducând distanțele parcurse de degete și minimizând efortul pentru tastarea textelor în limba engleză. Dvorak distribuie caracterele astfel încât alternarea între mâini să fie maximizată, echilibrând sarcina între cele două mâini și reducând teoretic oboseala. Workman adoptă un compromis între diverse metrici ergonomice, optimizând simultan pentru distanță și confort. Norman minimizează mișcările degetului arătător, cel mai utilizat în procesul de tastare. Asset reprezintă o optimizare specifică pentru limba engleză, bazată pe analize statistice ale frecvenței caracterelor. Minimak introduce modificări minime față de QWERTY, facilitând tranziția pentru utilizatori obișnuiți cu layout-ul standard.

Stocarea se realizează în dicționare Python pentru acces rapid. Pentru un caracter dat, sistemul identifică imediat coordonatele corespunzătoare. Această mapare directă facilitează simularea. Evaluarea se efectuează prin simulare directă pe textele unificate descrise anterior. Simularea parcurge fiecare caracter, actualizează pozițiile degetelor și calculează distanțele euclidiene conform modelului matematic prezentat în subcapitolul 3.5.

Layout-urile permit testarea variațiilor prin permutări parțiale sau complete. Comparațiile arată îmbunătățiri consistente față de QWERTY în termeni de distanțe și timpi. Diferențele față de Colemak sunt marginale. Colemak a atins un nivel ridicat de optimizare prin iterații succesive. Această constatare susține argumentul: adoptarea layout-urilor generate automat nu se justifică pentru utilizatori cu mobilitate normală. Beneficiile sunt insuficiente pentru a compensa efortul de reantrenare.

Integrarea cu modelele fizice, descrise în subcapitolul următor, permite evaluarea precisă a ergonomiei. Flexibilitatea acoperă tastaturi standard ANSI și modele ergonomice specializate. Această aplicabilitate oferă o bază pentru optimizarea personalizată în funcție de nevoile specifice.

## 3.3 Modele Fizice și Adnotare

Modelele fizice descriu geometria reală a tastelor:

- poziții;
- dimensiuni;
- coordonate bidimensionale.

Reprezentarea utilizează fișiere JSON în formatul Keyboard Layout Editor (KLE), standard pentru specificarea detaliată a configurațiilor.

Modelele selectate sunt:

- ANSI 60%;
- Dactyl Manuform;
- Ferris Sweep.json.

Modelul ANSI șaizeci la sută reprezintă configurația standard compactă, fără tastatură numerică și grup de taste de navigare dedicat. Această configurație este răspândită pe laptopuri și tastaturi compacte, asigurând compatibilitatea cu o gamă largă de dispozitive utilizate curent. Modelul Dactyl Manuform este o tastatură ergonomică split cu șase rânduri pe șase coloane și patru taste thumb cluster, adoptând configurații curbe pentru reducerea tensiunii musculare și îmbunătățirea posturii la tastare pe perioade prelungite. Modelul Ferris Sweep este o tastatură ergonomică compactă split, cu profil redus și doar treizeci și patru de taste, disponibilă autorului pentru testare practică.

Fișierele JSON inițiale au fost extinse cu adnotări suplimentare. Atributele adnotate sunt:

- degetul asociat;
- mâna corespunzătoare;
- statutul de homing key.

Procesul de adnotare s-a realizat printr-un instrument GUI dezvoltat în proiect. Instrumentul oferă interfață interactivă pentru selecția tastelor și atribuirea proprietăților. Exemplu: degetul arătător stâng se atribuie tastei F, care servește drept homing key pentru poziționarea inițială. Această adnotare influențează pozițiile inițiale în simulare și determină restricțiile de mobilitate.

Conform figurii 3.1, calculul distanțelor euclidiene se bazează pe coordonatele reale extrase din modelele adnotate.

**Figura 3.1 – Schema adnotării modelului fizic de tastatură**

Distanța dintre două taste consecutive se calculează din diferența coordonatelor carteziene, ținând cont de dimensiunile reale și spațierile. Această precizie este esențială pentru evaluarea corectă a ergonomiei. Diferențe minore în poziționare au impact semnificativ asupra confortului pe termen lung.

Modelele se adaptează la formate ANSI și ISO, integrând factori ergonomici:

- lățimea tastelor;
- înălțimea profilului;
- unghiurile de înclinare.

Validarea acurateței s-a efectuat prin comparații cu specificațiile producătorilor și măsurători fizice. Testele confirmă consistența datelor și absența erorilor sistematice. Extinderi posibile includ integrarea senzorilor de presiune și accelerometre pentru capturarea dinamicii reale, ceea ce ar permite rafinarea modelelor și validarea empirică a predicțiilor.

Modelele fizice adnotate leagă layout-urile logice de realitatea geometrică a dispozitivelor. Algoritmul genetic generează soluții care respectă restricțiile fizice și optimizează performanța în contextul specific al fiecărui tip de tastatură.

## 3.4 Algoritmul Genetic

Algoritmul genetic generează și evoluează populații de layout-uri prin mecanisme inspirate din selecția naturală:

- reproducere;
- încrucișare genetică;
- mutație aleatorie.

Populația inițială constă în permutări aleatorii de caractere. Fiecare individ reprezintă un layout complet care mapează setul de caractere pe pozițiile fizice. Evaluarea se realizează prin simulare directă pe textele unificate, calculând un scor de fitness bazat pe distanțe și timpi.

Procesul evolutiv urmează schema clasică, adaptată specificului problemei. Inițializarea generează $N$ layout-uri aleatorii, unde $N$ reprezintă dimensiunea populației. Fiecare generație trece prin:

a) evaluare;
b) selecție;
c) reproducere;
d) înlocuire.

Procesul continuă până la numărul maxim de iterații sau până la convergență către o soluție stabilă.

Operațiile genetice sunt:

a) selecție prin metoda turneu sau proporțională cu fitness-ul;
b) încrucișare prin schimb de segmente între doi părinți;
c) mutație prin permutare aleatorie de perechi de caractere;
d) elitism prin păstrarea celor mai buni indivizi.

Funcția de fitness minimizează o combinație ponderată de distanță totală și timp total. Formula exactă este prezentată în subcapitolul 3.5, unde se detaliază calculul conform relațiilor (3.7) și (3.8). Evaluarea unui individ necesită parcurgerea întregului text caracter cu caracter, actualizând pozițiile degetelor și acumulând contribuțiile la metrici.

Implementarea inițială în Python a prezentat limitări de performanță datorită naturii interpretate a limbajului și overhead-ului structurilor de date în bucle intensive. Pentru accelerare, o porțiune semnificativă a calculului fitness-ului a fost reimplementată în C#. Acest limbaj compilat oferă performanță superioară pentru operații numerice intensive. Optimizarea a redus timpul de execuție per evaluare cu un ordin de mărime, făcând posibilă explorarea eficientă cu populații de dimensiuni realiste.

Parametrii algoritmului sunt fixați în implementare. Dimensiunea populației variază între cincizeci și o sută de indivizi, stabilită experimental pentru echilibru între diversitate și eficiență. Numărul de iterații se situează între o sută și trei sute de generații, în funcție de rata de convergență observată. Rata de mutație de bază este stabilită la cinci la sută. Toți indivizii noi sunt creați prin încrucișare. Dacă prin încrucișare nu s-au putut crea suficienți indivizi pentru generația următoare, aceștia sunt clonați din indivizii creați prin încrucișare și mutați o singură dată. Dimensiunea elitismului păstrează între doi și cinci indivizi, garantând că cele mai bune soluții nu sunt pierdute între generații.

Implementarea permite paralelizare la nivel de evaluare. Calculul fitness-ului pentru fiecare layout este independent. Paralelizarea utilizează thread pool-uri și distribuire pe multiple nuclee. Pe un sistem cu opt nuclee logice, speedup-ul observat se apropie de factorul de șapte, indicând eficiență ridicată.

Convergența a fost analizată prin monitorizarea evoluției fitness-ului mediu și minim peste generații conform figurii 3.2. Observațiile arată îmbunătățire rapidă în primele cincizeci de generații, urmată de creștere mai lentă. Diversitatea genetică, măsurată prin similaritate între indivizi, scade gradual pe măsură ce algoritmul converge.

**Figura 3.2 – Evoluția fitness-ului pe parcursul generațiilor**

Rezultatele experimentale demonstrează că layout-urile generate depășesc consistent performanța QWERTY. Reducerile distanței totale ating douăzeci până la treizeci la sută. Îmbunătățirile timpilor sunt similare. Comparațiile cu Colemak relevă diferențe de doar câteva procente. Colemak se află deja aproape de un optim ergonomic pentru limba engleză. Spațiul de îmbunătățire față de layout-urile bine optimizate manual este limitat. Beneficiile marginale nu justifică adoptarea generală.

Scenariile avantajoase vizează utilizatori cu restricții de mobilitate. Exemplu: mobilitate redusă a mâinii drepte beneficiază de un layout optimizat care minimizează utilizarea acestei mâini. Caracterele frecvente se plasează în zona accesibilă mâinii stângi. Algoritmul permite configurarea coeficienților de penalizare pentru fiecare deget, reflectând gradul de mobilitate conform formulei (3.5) prezentate în subcapitolul 3.5. Ajustarea acestor coeficienți generează layout-uri personalizate care compensează limitările individuale, oferind îmbunătățiri semnificative pentru utilizatori cu nevoi speciale.

Extinderi posibile includ:

- constrângeri suplimentare pentru menținerea anumitor caractere pe pozițiile standard;
- optimizare simultană pentru multiple limbi;
- tehnici avansate precum algoritmi memetici.

Algoritmii memetici combină căutarea globală cu căutarea locală intensivă, îmbunătățind calitatea soluțiilor finale și accelerând convergența. Algoritmul genetic oferă un cadru flexibil și extensibil pentru explorarea sistematică a spațiului de design și adaptarea automată la cerințele specifice ale diverselor categorii de utilizatori.

## 3.5 Modelul Matematic

Modelul matematic evaluează performanța layout-urilor prin integrarea distanțelor euclidiene cu timpii de mișcare estimați conform Legii lui Fitts. Simularea actualizează secvențial pozițiile degetelor pe măsură ce parcurge textul caracter cu caracter, modelând dinamica reală a mișcărilor și interacțiunile dintre apăsări consecutive.

Conceptul central este grupul de apăsări, definit ca o subsecvență maximală de caractere consecutive care pot fi tastate fără a utiliza același deget de două ori. Această structură permite modelarea paralelismului implicit: în timp ce un deget apasă o tastă, celelalte degete se deplasează simultan către pozițiile următoare.

Notațiile utilizate sunt: $k$ reprezintă indicele caracterului curent în secvență, variind de la unu până la $N$, unde $N$ este lungimea totală; $x(k)$ și $y(k)$ reprezintă coordonatele carteziene ale tastei corespunzătoare caracterului $k$; $f_k$ denotă degetul utilizat pentru tasta $k$, determinat din adnotările modelului fizic; $x(f, k-1)$ și $y(f, k-1)$ reprezintă coordonatele ultimei poziții cunoscute a degetului $f$ înainte de apăsarea tastei $k$.

Mulțimea tuturor degetelor este notată cu $F$, incluzând cele zece degete. Pentru un grup de apăsări $G_g$, mulțimea degetelor utilizate este notată cu $F_g$, reprezentând submulțimea degetelor active în grupul respectiv.

Distanța parcursă de degetul $f_k$ pentru a atinge tasta $k$ se calculează ca distanță euclidiană între poziția curentă și poziția anterioară, conform formulei (3.1):

$$d_k = \sqrt{(x(k) - x(f_k, k-1))^2 + (y(k) - y(f_k, k-1))^2} \quad (3.1)$$

unde:
- $d_k$ este distanța pentru caracterul $k$;
- $x(k)$, $y(k)$ sunt coordonatele tastei $k$;
- $x(f_k, k-1)$, $y(f_k, k-1)$ sunt coordonatele anterioare ale degetului $f_k$.

Distanța totală se obține prin sumare conform formulei (3.2):

$$D_{\text{total}} = \sum_{k=1}^{N} d_k \quad (3.2)$$

unde:
- $D_{\text{total}}$ este distanța totală parcursă;
- $N$ este numărul total de caractere.

După fiecare apăsare, poziția degetului $f_k$ se actualizează la coordonatele $(x(k), y(k))$. Această actualizare secvențială este esențială pentru acuratețe, deoarece ignorarea dependențelor temporale duce la estimări eronate.

Grupurile de apăsări sunt subsecvențe maximale în care fiecare deget este utilizat cel mult o dată. Un grup $G_g$ începe cu un caracter și se extinde până când se întâlnește un caracter care ar necesita reutilizarea unui deget deja activ. La acel moment, grupul curent se închide și începe un nou grup. Această segmentare permite modelarea paralelismului: toate deplasările dintr-un grup pot începe simultan, iar timpul total este determinat de deplasarea cea mai lentă.

Numărul total de grupuri este notat cu $G_{\max}$. Pentru un grup dat, timpul total se calculează conform formulei (3.3) ca suma dintre timpul de mișcare maxim și timpii individuali de apăsare:

$$T_{\text{group}}(g) = \max_{f \in F_g} TS_f(g) + \sum_{f \in F_g} TPS_f \quad (3.3)$$

unde:
- $T_{\text{group}}(g)$ este timpul total pentru grupul $g$;
- $F_g$ este mulțimea degetelor active în grupul $g$;
- $TS_f(g)$ este timpul de mișcare al degetului $f$ în grupul $g$;
- $TPS_f$ este timpul de apăsare pentru degetul $f$.

Timpul de mișcare pentru un deget $f$ în grupul $g$ este estimat conform Legii lui Fitts, prezentată în formula (3.4):

$$TS_f(g) = a_f + b_f \cdot \log_2\left(1 + \frac{D_f(g)}{W_f}\right) \quad (3.4)$$

unde:
- $TS_f(g)$ este timpul de mișcare al degetului $f$ în grupul $g$;
- $a_f$, $b_f$ sunt constante empirice pentru degetul $f$;
- $D_f(g)$ este distanța totală parcursă de degetul $f$ în grupul $g$;
- $W_f$ este lățimea efectivă a tastei.

Timpul de apăsare include o componentă fixă plus o penalizare ajustabilă, conform formulei (3.5):

$$TPS_f = \tau_f \ge 0 \quad (3.5)$$

unde:
- $TPS_f$ este timpul de apăsare pentru degetul $f$;
- $\tau_f$ este coeficientul de penalizare pentru degetul $f$.

Coeficientul $\tau_f$ permite personalizarea pentru utilizatori cu mobilitate inegală. Exemplu: pentru artrita care afectează degetul mic drept, $\tau$ corespunzător se mărește semnificativ, determinând algoritmul să evite plasarea caracterelor frecvente pe tastele asociate.

Timpul total se obține prin sumarea timpilor grupurilor, conform formulei (3.6):

$$T_{\text{total}} = \sum_{g=1}^{G_{\max}} T_{\text{group}}(g) \quad (3.6)$$

unde:
- $T_{\text{total}}$ este timpul total pentru întregul text;
- $G_{\max}$ este numărul total de grupuri.

Funcția de fitness combină distanța și timpul printr-o medie ponderată, prezentată în formula (3.7):

$$F = w_d \cdot \operatorname{norm}(D_{\text{total}}) + w_t \cdot \operatorname{norm}(T_{\text{total}}) \quad (3.7)$$

unde:
- $F$ este fitness-ul layout-ului;
- $w_d$, $w_t$ sunt ponderile pentru distanță și timp;
- $\operatorname{norm}$ este funcția de normalizare.

Normalizarea se realizează prin împărțire la valoarea maximă, conform formulei (3.8):

$$\operatorname{norm}(X) = \frac{X}{X_{\max}}, \quad X \in \{D_{\text{total}}, T_{\text{total}}\} \quad (3.8)$$

unde:
- $X_{\max}$ este valoarea maximă observată în populația curentă.

Ponderile $w_d$ și $w_t$ controlează importanța relativă a distanței față de timp. Valori egale tratează distanța și timpul ca fiind la fel de importante. Ajustări diferențiate permit accentuarea unui aspect în funcție de priorități.

Modelul integrează toate elementele pentru evaluare obiectivă și reproductibilă. Formulele permit implementare directă, fiind suficient de detaliate pentru consistență între rulări și replicabilitate. Parametrii ajustabili oferă flexibilitate pentru adaptare la contexte specifice și personalizare în funcție de caracteristicile individuale.

Validarea s-a realizat prin comparații cu măsurători empirice pe layout-uri cunoscute, confirmând că predicțiile corelează bine cu observațiile practice. Extinderi posibile includ:

- factori de oboseală care cresc pe măsură ce sesiunea se prelungește;
- efecte de învățare care reduc timpii pe măsură ce utilizatorul se familiarizează.

Capitolul a descris pașii pentru optimizarea layout-urilor de tastatură prin algoritmi genetici și simulare directă. Componentele principale includ pregătirea seturilor de date textuale reprezentative, definirea layout-urilor logice și maparea pe modele fizice adnotate, implementarea algoritmului genetic pentru generarea populațiilor și dezvoltarea modelului matematic pentru evaluare prin distanțe și timpi. Procesul permite reconstrucția experimentelor prin ajustarea parametrilor, iar codul sursă public asigură reproducibilitatea. Layout-urile generate depășesc consistent performanța QWERTY, atingând reduceri ale distanțelor de douăzeci până la treizeci la sută. Comparațiile cu Colemak relevă îmbunătățiri de doar câteva procente, indicând că Colemak a atins deja un nivel ridicat de optimizare.

Pentru utilizatori cu mobilitate normală, adoptarea layout-urilor generate nu se justifică, beneficiile marginale necompensând efortul de reantrenare. Compatibilitatea cu sistemele existente și pierderea temporară de productivitate reprezintă bariere suplimentare. Scenariile recomandabile vizează restricții de mobilitate: mobilitate redusă sau absența unei mâini, afecțiuni care limitează mișcarea anumitor degete, leziuni temporare care impun adaptare sau preferințe ergonomice extreme. În aceste situații, configurabilitatea coeficienților de penalizare permite generarea de layout-uri personalizate care compensează limitările individuale, oferind îmbunătățiri substanțiale ale eficienței și confortului. Această capacitate reprezintă contribuția principală, extinzând accesibilitatea pentru utilizatori cu nevoi speciale. Direcții viitoare includ extindere la limbi suplimentare, aplicare la dispozitive mobile cu tastaturi virtuale și integrare de senzori pentru validare empirică directă.
