Ministerul Educaţiei şi Cercetării al Republicii Moldova   

Universitatea Tehnică a Moldovei   

Facultatea Calculatoare, Informatică şi Microelectronică  



# Termeni de Referință

## Tema: Analiza eficienței layout-urilor de tastatură și algoritmi de optimizare
  
    
### A efectuat: Pleșu Cătălin TI-241M

### A verificat: Chirev Pavel, lector univ. dr.

Chișinău 2025


# Termeni de Referință (ToR)
## Analiza eficienței layout-urilor de tastatură și algoritmi de optimizare

### INFORMAȚII DE FOND

#### 1.1. Domeniul de activitate
Interacțiunea om-calculator, utilizabilitate și ergonomie.

#### 1.2. Autoritatea contractantă
Universitatea Tehnică a Moldovei.

#### 1.3. Contextul domeniului
Tastatura rămâne un dispozitiv periferic fundamental și omniprezent în interacțiunea om-calculator, chiar și în era interfețelor vocale avansate și a ecranelor tactile.
De-a lungul istoriei calculatoarelor, metodele de introducere a datelor au evoluat. Primele computere erau programate prin carduri perforate, un proces complex și  predispus la erori.
O singură eroare în perforarea unui card putea compromite întregul program, necesitând reluarea procesului.
Odată cu evoluția tehnologiei, cardurile perforate au devenit o relicvă istorică, iar tastatura a devenit metoda preferată de a introduce informații în calculator.
Chiar și astăzi, deși tehnologiile de recunoaștere vocală (speech-to-text) au avansat, tastatura își menține relevanța datorită preciziei, controlului și eficienței în diverse sarcini, de la scrierea documentelor complexe și programare, până la interacțiunea în medii zgomotoase sau sarcini ce necesită confidențialitate.
Această persistență subliniază importanța optimizării tastaturii pentru a satisface nevoile diverse ale utilizatorilor actuali.

În prezent, layout-ul QWERTY a devenit un standard global.
Introdus pentru prima dată în 1874 pe mașina de scris "Sholes & Glidden", QWERTY a fost o inovație remarcabilă pentru epoca sa. În contextul mașinilor de scris mecanice, QWERTY a fost proiectat pentru a minimiza blocajele mecanice frecvente ale brațelor de caractere.
Prin separarea tastelor literelor frecvent utilizate, inginerii au redus riscul ca brațele de caractere să se blocheze la tastarea rapidă.
Însă, în era digitală, limitările mecanice nu mai există. Tastaturile electronice nu suferă de blocaje mecanice, deschizând calea către layout-uri mai eficiente, optimizate pentru viteza de tastare, ergonomie și confortul utilizatorului, nu pentru a evita o problemă mecanică depășită.
Astfel, se naște întrebarea: este QWERTY, un layout proiectat pentru o tehnologie arhaică, cu adevărat optim pentru nevoile utilizatorilor moderni? Alternativa Dvorak, inventată în 1930 de August Dvorak, a fost o încercare timpurie de a crea un layout mai ergonomic.
Dvorak plasează tastele cele mai frecvente pe rândul de bază (Home Row), reducând distanța degetelor și efortul de tastare.
Cu toate acestea, Dvorak nu a atins popularitatea QWERTY, rămânând o alternativă nișată, deși studiile ergonomice i-au demonstrat avantajele.
Această situație subliniază inerția standardelor tehnologice și provocarea de a introduce inovații, chiar și atunci când acestea oferă beneficii clare.

#### 1.4. Situația actuală în domeniu
Industria tastaturilor este dominată de QWERTY la nivel global, un standard impus de moștenirea istorică și de compatibilitatea universală. Răspândirea QWERTY de-a lungul a peste un secol și jumătate a creat un ecosistem vast de software, sisteme de operare și platforme digitale construite în jurul acestui layout. Această compatibilitate omniprezentă face din QWERTY alegerea implicită pentru majoritatea producătorilor și utilizatorilor.
Standardele internaționale, precum ISO/IEC 9995, reglementează aspectele layout-urilor, consolidând poziția dominantă a QWERTY și asigurând interoperabilitatea.

Cu toate acestea, în ultimii ani, se manifestă un interes crescut pentru optimizarea ergonomiei și eficienței tastării.
Studiile ergonomice sugerează că layout-uri alternative precum Dvorak, Colemak, Workman, ASSET și altele pot îmbunătăți viteza de tastare și pot reduce riscul de RSI (Leziuni prin Încordare Repetitivă).
RSI, o problemă de sănătate ocupațională majoră în era digitală, este cauzată de mișcări repetitive și posturi incorecte la tastare.
Deși aceste alternative oferă beneficii ergonomice potențiale, adoptarea lor este limitată de mai mulți factori.
Compatibilitatea software nu este întotdeauna perfectă, iar inerția utilizatorilor și rezistența la schimbare rămân obstacole majore.
Reînvățarea tastării pe un nou layout necesită timp și efort, ceea ce descurajează mulți utilizatori, chiar dacă beneficiile pe termen lung ar fi semnificative.

Pe piața tastaturilor, majoritatea producătorilor adoptă o abordare conservatoare, oferind QWERTY ca standard implicit.
Alternativele ergonomice sau personalizate, cu layout-uri non-QWERTY, sunt disponibile, dar adesea la costuri mai ridicate și pentru segmente de nișă.
Sectorul jocurilor video (gaming) și entuziaștii tastaturilor mecanice sunt mai deschiși la experimentarea cu layout-uri alternative, în căutarea performanței sau a unei experiențe de tastare personalizate.
Cu toate acestea, piața generală rămâne reticentă la schimbare, preferând familiaritatea și compatibilitatea oferite de QWERTY.

Producția de tastaturi este concentrată în Asia, China și Taiwan fiind centrele majore de manufacturare.

### 2. OBIECTIVE ȘI REZULTATE AȘTEPTATE

#### 2.1. Obiectiv general
Obiectivul principal este îmbunătățirea semnificativă a eficienței tastării.
Aceasta include creșterea vitezei de tastare, sporirea acurateței scrierii (reducerea erorilor) și maximizarea confortului utilizatorilor, în special în sesiunile lungi de tastare.
Un obiectiv esențial este reducerea riscului de leziuni prin încordare repetitivă (RSI), o problemă de sănătate ocupațională din ce în ce mai relevantă în contextul muncii moderne.
Pe termen lung, proiectul urmărește să contribuie la optimizarea interacțiunii om-mașină și la promovarea adoptării unor soluții ergonomice mai eficiente în designul interfețelor de input.

#### 2.2. Obiective specifice

1. **Analiza comparativă a eficienței layout-urilor existente**: Evaluarea riguroasă a layout-urilor QWERTY, Dvorak, Colemak, Workman și ASSET, folosind metrici obiective și metode de analiză cantitativă.
Această analiză va oferi o bază factuală pentru a înțelege punctele forte și slabe ale fiecărui layout și pentru a identifica direcții de optimizare.
2. **Crearea de layout-uri optimizate**: Proiectarea și dezvoltarea unui set de layout-uri specializate și optimizate algoritmic pentru limba engleză, limba română și programare.

#### 2.3. Rezultatele preconizate

**Funcționalitatea 1: Evaluarea eficienței layout-urilor**

-  **Rezultat 1: Măsurarea distanței parcurse de degete**: Calcularea precisă a distanței totale pe care degetele o parcurg în timpul tastării pentru fiecare layout analizat.
Această metrică, distanța degetelor, este un indicator cheie al efortului fizic și al eficienței.
-  **Rezultat 2: Prezentarea grafică a eficienței**: Crearea de diagrame comparative care vizualizează eficiența relativă a layout-urilor. Aceste diagrame vor include grafice comparative care ilustrează clar diferențele de eficiență între layout-uri, facilitând înțelegerea și interpretarea rezultatelor.
-  **Livrabil**: Analiza clară a layout-urilor cercetate.

**Funcționalitatea 2: Crearea și optimizarea noilor layout-uri**

-  **Rezultat 1: Layout optimizat pentru engleză**: Dezvoltarea și testarea unui layout de tastatură complet optimizat pentru limba engleză, având ca scop maximizarea vitezei, acurateței și confortului la tastare în limba engleză.
-  **Rezultat 2: Layout optimizat pentru română**: Crearea unui layout dedicat și optimizat pentru limba română, care să ia în considerare frecvența specifică a literelor și particularitățile limbii române, pentru a oferi o experiență de tastare naturală și eficientă în limba română.
-  **Rezultat 3: Layout optimizat pentru programare**: Proiectarea unui layout specializat pentru programare, care să optimizeze accesul la simbolurile, caracterele speciale și combinațiile de taste frecvent utilizate în codul sursă, facilitând o programare mai rapidă și mai eficientă.
-  **Rezultat 4: Compararea layouturilor create**: Realizarea unei comparații riguroase între layout-urile nou create și layout-urile existente (QWERTY, Dvorak, etc.), utilizând aceleași metrici de eficiență, pentru a demonstra avantajele noilor layout-uri și a valida procesul de optimizare.
-  **Livrabil**: Set de layout-uri create optimizate pentu scenarii individuale.

### 3. IPOTEZE ȘI RISCURI

#### 3.1. Ipotezele proiectului
-  **Disponibilitatea datelor lingvistice**: Se presupune existența unor corpusuri lingvistice ample și accesibile public, care să furnizeze date fiabile despre frecvența literelor și a combinațiilor de litere în limba engleză, română și în codul sursă.
Aceste date sunt fundamentale pentru analiza și optimizarea layout-urilor.
-  **Eficacitatea algoritmilor**: Se ipotezează că algoritmii utilizati vor fi capabili să genereze layout-uri care reduc semnificativ distanța degetelor, depășind performanța layout-urilor existente.
Succesul proiectului depinde de capacitatea algoritmilor de a găsi soluții inovatoare și eficiente.
-  **Relevanța distanței degetelor ca metrică**: Distanța parcursă de degete este considerată un indicator esențial al eficienței ergonomice. Reducerea acestei distanțe ar trebui să conducă la o tastare mai confortabilă și mai puțin obositoare, deși se recunoaște că și alți factori ergonomici pot influența experiența utilizatorului.
-  **Generalizarea layout-urilor de programare**: Se presupune că layout-urile optimizate pentru programare vor fi eficiente indiferent de limbajul de programare.
Deși diferitele limbaje pot avea particularități, se așteaptă ca un layout general optimizat pentru programare să ofere beneficii larg aplicabile.
-  **Potențialul de învățare al noilor layout-uri**: Se bazează pe premisa că majoritatea utilizatorilor nu sunt tastatori orbi și, prin urmare, vor fi mai deschiși la schimbarea layout-ului, neavând o dependență puternică de QWERTY.
-  **Interesul pentru ergonomie și prevenirea RSI**: Se anticipează un interes crescut din partea utilizatorilor preocupați de ergonomie și sănătate, care vor fi motivați să adopte layout-uri optimizate pentru a reduce riscul de RSI și a îmbunătăți confortul la tastare.

#### 3.2. Riscuri
-  **Calitatea și reprezentativitatea datelor**: Există riscul ca datele lingvistice colectate să nu fie suficient de diverse sau reprezentative, afectând acuratețea optimizării.
Datele incomplete sau distorsionate ar putea conduce la layout-uri suboptimal.
-  **Complexitatea algoritmilor**: Algoritmii selectați pot fi complecși și să necesite resurse computaționale semnificative și timp de procesare.
Optimizarea layout-urilor ar putea fi mai complexă și mai lentă decât se anticipează, necesitând ajustări ale planului proiectului.
-  **Reticența la adoptarea noilor layout-uri**: Chiar dacă layout-urile optimizate sunt superioare, utilizatorii ar putea fi reticenți la schimbare din cauza inerției, familiarității cu QWERTY sau dificultății percepute a reînvățării.
-  **Factorii ergonomici necuantificabili**: Optimizarea bazată exclusiv pe distanța degetelor poate neglija alți factori ergonomici importanți.
-  **Variabilitatea stilurilor de tastare**: Stilurile de tastare individuale variază semnificativ.
Layout-urile optimizate pe baza datelor statistice medii s-ar putea să nu fie optime pentru toți utilizatorii, deoarece stilurile de tastare diverse pot influența eficiența diferitelor layout-uri.
-  **Evoluția tehnologică**: Apariția unor noi metode de input, cum ar fi interfețele creier-computer sau realitatea virtuală, ar putea reduce relevanța tastaturilor clasice în viitorul îndepărtat.

### 4. SCOPUL LUCRĂRII

#### 4.1. General
##### 4.1.1. Descrierea proiectului
Proiectul de față își propune o investigație riguroasă asupra eficienței layout-urilor de tastatură, comparând layout-uri existente și creând layout-uri noi, optimizate.
Se va dezvolta un software dedicat pentru analiză și configurare, folosind date colectate din surse online pentru testare și validare.
Rezultatele vor fi sintetizate într-un raport final detaliat, prezentat Comisiei de Master, contribuind la o mai bună înțelegere a impactului layout-urilor asupra performanței la tastare și deschizând calea pentru inovații viitoare.

##### 4.1.2. Zona geografică de acoperire
Proiectul are o dimensiune globală, datele fiind extrase din surse online accesibile universal.
Tastaturile sunt utilizate global, astfel beneficiile unui layout mai eficient sunt universale, depășind granițele geografice.
Layout-urile optimizate ar putea fi adoptate de utilizatori din întreaga lume.

##### 4.1.3. Grupuri țintă
Grupul țintă principal include profesioniști care utilizează tastatura zilnic pentu a interactiona cu calculatorul.
Beneficiarii secundari includ orice utilizator de calculator, care ar putea beneficia de un layout mai ergonomic și eficient.
Proiectul vizează un impact larg asupra comunității utilizatorilor de tehnologie.

#### 4.2. Lucrări specifice
-  **Colectarea layout-urilor**: Documentarea și colectarea aranjamentelor de taste pentru QWERTY, Dvorak, Colemak, Workman, ASSET și alte layout-uri relevante.
-  **Colectarea textelor**: Crearea unui set de texte reprezentative din diverse domenii (engleză, română, programare) pentru analiza eficienței layout-urilor.
-  **Program pentru eficiență**: Dezvoltarea unui program software pentru a calcula și evalua eficiența fiecărui layout analizat, pe baza distanței degetelor și a altor metrici relevante.
-  **Analiza layout-urilor existente**: Utilizarea programului software pentru a realiza o analiză comparativă aprofundată a eficienței layout-urilor existente, identificând punctele forte și slabe ale fiecăruia.
-  **Program pentru generare layout-uri**: Crearea unui program software avansat, bazat pe algoritmi, pentru generarea automată de layout-uri noi și optimizate, configurabile pentru diferite limbi și contexte de utilizare.
-  **Generarea și evaluarea noilor layout-uri**: Utilizarea programului de generare pentru a crea iterativ layout-uri noi, urmând un proces de optimizare algoritmică și euristică, și evaluarea riguroasă a performanțelor acestora folosind programul de analiză a eficienței.
-  **Redactarea raportului final**: Compilarea unui raport detaliat care prezintă metodologia proiectului, analiza layout-urilor existente, descrierea noilor layout-uri create, evaluarea comparativă a performanțelor și concluziile principale ale lucrării.

#### 4.3. Managementul proiectului

##### 4.3.1. Organismul responsabil
Coordonatorul tezei de master, un cadru didactic universitar cu titlul de doctor și expertiză relevantă, va fi responsabil de gestionarea, supervizarea și coordonarea întregului proiect, asigurând direcția științifică și respectarea standardelor academice.

##### 4.3.2. Structura managementului
Coordonatorul tezei de master va acționa ca supervizor principal și mentor academic.
Decanatul facultății va aproba tema tezei și va valida progresul proiectului, conform procedurilor universitare interne.

##### 4.3.3. Facilități puse la dispoziție
Nu se anticipează necesitatea unor facilități suplimentare din partea universității.