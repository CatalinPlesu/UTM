# Termeni de Referință (ToR)
## Analiza eficienței layout-urilor de tastatură și algoritmi de optimizare

### INFORMAȚII DE FOND

#### 1.1. Domeniul de activitate
Interacțiunea om-calculator, utilizabilitate și ergonomie.

#### 1.2. Autoritatea contractantă
Universitatea Tehnică a Moldovei.

#### 1.3. Contextul domeniului
Tastatura reprezintă un dispozitiv periferic pentru interacțiunea dintre utilizator și calculator.
O mare parte a primelor calculatoare erau programabile prin intermediul cardurilor perforate, procesul creării lor era unul predispus erorilor și destul de anevoios. Însă, cu timpul, cardurile perforate au rămas în istorie, iar tastatura a devenit metoda preferată de a introduce informații în calculator. Chiar și în ziua de azi, când avem mecanisme care permit transformarea vorbirii în text, tastatura este încă utilizată pe larg.

În prezent, layout-ul QWERTY a devenit standard. Acesta a fost introdus pentru prima dată în anul 1874, în mașina de scris "Sholes & Glidden". În acele vremuri, acest layout a fost inovativ, permițând utilizatorilor să scrie mai rapid prin reducerea riscului de blocare a mașinii de scris. Însă, în ziua de astăzi, când tastaturile nu sunt limitate de construcția lor, pot fi create layouturi mai optime pentru scris. O alternativă destul de veche la QWERTY este Dvorak, care a fost inventată în 1930, însă nu se bucură de o popularitate similară. Avantajul Dvorak este că tastele cele mai utilizate sunt amplasate pe rândul de bază ("Home Row").

#### 1.4. Situația actuală în domeniu
Industria tastaturilor este dominată de standardul QWERTY, utilizat la nivel global datorită răspândirii sale istorice și a compatibilității universale cu software-ul și sistemele de operare. Politicile și standardele internaționale, precum ISO/IEC 9995, reglementează aspectele legate de layouturi și funcționalitățile tastaturilor.

În ultimii ani, au apărut inițiative pentru optimizarea eficienței tastării, bazate pe studii ergonomice care sugerează că anumite layouturi alternative (ex. Dvorak, Colemak, ASET) pot îmbunătăți viteza de tastare și reduce riscul de leziuni prin încordare repetitivă (RSI). Totuși, adoptarea acestora este limitată de compatibilitatea software-ului, costurile ridicate ale producției de tastaturi personalizate și rezistența utilizatorilor la schimbare.

În ceea ce privește piața, majoritatea producătorilor de tastaturi (ex. Logitech, Razer, Keychron) mențin o abordare conservatoare, oferind tastaturi QWERTY ca standard, iar alternativele personalizabile sunt disponibile doar la un cost mai ridicat. Sectorul gaming și entuziaștii tastaturilor mecanice sunt principalele segmente care experimentează cu layouturi alternative, dar piața generală rămâne reticentă la schimbare.

Pe plan tehnologic, tendințele recente includ integrarea switch-urilor optice și a tehnologiilor wireless avansate, dar acestea nu influențează în mod direct structura layouturilor de tastatură. În sectorul educațional și instituțional, nu există politici oficiale care să încurajeze utilizarea unui layout optimizat, ceea ce menține dependența de standardul QWERTY.

Capacitatea de producție este concentrată în Asia, cu China și Taiwan fiind principalele hub-uri de manufacturare. Principalele constrângeri ale industriei includ costurile ridicate ale personalizării și lipsa unui consens global privind avantajele ergonomice ale layouturilor alternative.

### 2. OBIECTIVE ȘI REZULTATE AȘTEPTATE

#### 2.1. Obiectiv general
Îmbunătățirea eficienței tastării, a acurateței scrierii și a confortului utilizatorilor, reducând în același timp riscul de leziuni prin încordare repetitivă (RSI). Pe termen lung, această acțiune va contribui la optimizarea interacțiunii om-mașină și la adoptarea unor soluții ergonomice mai eficiente.

#### 2.2. Obiective specifice

1. Analiza eficienței layout-urilor existente - QWERTY, Dvorak, Colemak, Workman, ASSET.
2. Crearea unui set de layout-uri optimizate pentru limba engleză, limba română și programare.

#### 2.3. Rezultatele preconizate

**Funcționalitatea 1: Evaluarea eficienței layout-urilor**

- Rezultat 1: Măsurarea distanței totale parcurse de degete pentru fiecare layout.
- Rezultat 2: Prezentarea grafică a eficienței layout-urilor prin diagrame comparative.
- Livrabil: Set de diagrame comparative privind eficiența layout-urilor.

**Funcționalitatea 2: Crearea și optimizarea noilor layout-uri**

- Rezultat 1: Layout optimizat pentru tastarea în limba engleză.
- Rezultat 2: Layout optimizat pentru tastarea în limba română.
- Rezultat 3: Layout optimizat pentru programare.
- Rezultat 4: Compararea layouturilor create cu cele existente.
- Livrabil: Set de layout-uri eficiente.

### 3. IPOTEZE ȘI RISCURI

#### 3.1. Ipotezele proiectului
- **Disponibilitatea datelor**: Se presupune că există suficiente date publice privind frecvența literelor și combinațiilor acestora în limba engleză, limba română și în codul sursă.
- **Capacitatea de optimizare**: Se așteaptă ca algoritmii genetici să genereze layout-uri ce reduc considerabil distanța parcursă de degete, comparativ cu configurațiile existente.
- **Relevanța metricilor**: Se consideră că distanța parcursă de degete este un indicator esențial al eficienței layout-urilor, iar reducerea acesteia va conduce la o experiență de tastare mai confortabilă.
- **Generalizarea layout-urilor**: Se presupune că layout-urile optimizate pentru programare vor fi eficiente, indiferent de limbajul utilizat.
- **Ușurința de a învăța**: În jur de 20% dintre utilizatorii de calculatoare pot tasta proficient fără a se uita la tastatură. Se presupune că ceilalți 80% nu vor avea inconveniențe în schimbarea layoutului, dacă oricum nu sunt familiarizați cu QWERTY.
- **Interesul pentru adoptare**: Se anticipează că utilizatorii preocupați de ergonomie și prevenirea RSI vor fi deschiși adoptării noilor layout-uri optimizate.

#### 3.2. Riscuri
- **Calitatea și diversitatea datelor**: Există riscul ca datele colectate să nu fie suficient de reprezentative, afectând astfel acuratețea analizei și a procesului de optimizare.
- **Complexitatea algoritmilor genetici**: Acești algoritmi pot necesita resurse computaționale semnificative, prelungind astfel procesul de optimizare.
- **Reticența la adoptarea noilor layout-uri**: Chiar și în cazul în care noile layout-uri sunt mai eficiente, utilizatorii pot fi reticenți din cauza necesității reînvățării și a inerției tehnologice.
- **Factorii ergonomici necuantificabili**: Distanța parcursă de degete reprezintă doar un aspect al ergonomiei; factori precum unghiul încheieturii sau forța de apăsare a tastelor pot influența confortul de utilizare.
- **Variabilitatea stilurilor de tastare**: Diferențele individuale în stilul de tastare pot reduce aplicabilitatea layout-urilor optimizate pentru unii utilizatori.
- **Evoluția tehnologică**: Apariția unor noi metode de input ar putea reduce relevanța tastaturilor clasice în viitor.

### 4. SCOPUL LUCRĂRII

#### 4.1. General
##### 4.1.1. Descrierea proiectului
Proiectul își propune să analizeze eficiența layout-urilor existente, urmând generarea și testarea unor noi configurații optimizate. Pentru aceasta, se va dezvolta și utiliza un software dedicat analizei și configurării layout-urilor, iar datele colectate din surse online vor fi folosite pentru testare și comparare. Rezultatele obținute vor fi sintetizate într-un raport final, care va fi prezentat Comisiei pentru Examenul de Master, contribuind astfel la o mai bună înțelegere a impactului layout-urilor asupra performanței de tastare.

##### 4.1.2. Zona geografică de acoperire
Proiectul are o dimensiune globală, deoarece datele vor fi extrase din surse online accesibile de oriunde. De asemenea calculatoarele și tastaturile se foloses global astefel oricine ar beneficia de un layout mai eficient.

##### 4.1.3. Grupuri țintă
Grupul țintă include profesioniști din domeniul tehnologiei informației, cercetători în designul layout-urilor și utilizatori interesați de îmbunătățirea eficienței de tastare. Oricine utilizeaza un calculator regular ar putea beneficia prin schimbarea layoutului.

#### 4.2. Lucrări specifice
- Colectarea aranjamentuoui layouturilor de tastaturi: QWERTY, Dvorak, Colemak, Workman, ASSET.
- Colectarea unui set de texte din domeniul public care ar permite analiza eficientei layouturilor in urmatoarele cazuri: engleza, romana și programare.
- Scrierea unui program care poate determina eficiența fiecărui layout.
- Analiza eficienței layout-urilor existente.
- Scrierea unui program care poate genera layouturi noi.
- Generarea și evaluarea noilor layout-uri.
- Redactarea raportului final ce va cuprinde analiza detaliată a layout-urilor existente, configurările layout-urilor noi și evaluarea performanțelor acestora.

#### 4.3. Managementul proiectului

##### 4.3.1. Organismul responsabil
Coordonatorul tezei de master va avea responsabilitatea de a gestiona întregul proiect. Acesta va fi identificat din cadrul profesorilor de la universitate care au titlul de doctor.

##### 4.3.2. Structura managementului
Coordonatorul tezei de master are rolul de supervizor principal. Aprobarea temei de tezei este făcută de către decanul facultații.

##### 4.3.3. Facilități puse la dispoziție
Nu se anticipează necesitatea unor facilități suplimentare din partea autorității contractante.