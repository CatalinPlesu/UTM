# 2. ALGORITMI GENETICI

Algoritmii genetici constituie o clasă de metode metaeuristice inspirate din mecanismele evoluției naturale, utilizate pentru rezolvarea problemelor complexe de optimizare și căutare. Introducerea lor formală în domeniul științific a fost realizată de John Holland în lucrarea "Adaptation in Natural and Artificial Systems" publicată în 1975, stabilind fundamentele teoretice și demonstrând aplicabilitatea acestor tehnici pentru explorarea eficientă a spațiilor de căutare vaste.

Principiul fundamental constă în evoluția unei populații de soluții candidate prin aplicarea repetată a operatorilor de selecție, încrucișare genetică și mutație aleatorie. Procesul emulează selecția naturală, conferind indivizilor cu performanță superioară șanse mai mari de reproducere și transmitere a caracteristicilor benefice către generațiile ulterioare. Această abordare permite explorarea sistematică a spațiului soluțiilor fără a necesita cunoaștere explicită despre structura problemei sau gradient al funcției obiectiv, fiind aplicabilă pentru probleme continue, discrete sau combinatorii.

Domeniile de aplicare acoperă optimizarea funcțiilor matematice multimodale, probleme combinatorii NP-dificile precum Problema Comis-Voiajorului și Problema Rucsacului, proiectarea și antrenarea rețelelor neuronale, optimizarea structurilor inginerești și circuitelor electronice, analiza datelor genomice și bioinformatică, planificarea producției și gestionarea lanțului de aprovizionare. Versatilitatea metodei derivă din capacitatea de adaptare la specificul problemei prin configurarea reprezentării cromozomiale, operatorilor genetici și funcției de evaluare.

Capitolul prezintă terminologia fundamentală, mecanismele de funcționare, tipurile de reprezentare cromozomială, operatorii genetici, strategiile de gestionare a populației, criteriile de terminare și considerațiile teoretice care fundamentează comportamentul algoritmilor. Structura urmează progresiv conceptele necesare pentru înțelegerea completă a metodei și aplicarea sa în contexte practice de optimizare.

## 2.1 Terminologie și Concepte Fundamentale

Vocabularul algoritmilor genetici împrumută termeni din biologia evolutivă, adaptați pentru contextul computațional. Cromozomul reprezintă codificarea unei soluții candidate sub formă de structură de date manipulabilă. Gena este unitatea elementară de informație din cromozom, corespunzând unei variabile de decizie sau componentă a soluției. Alela denotă valoarea specifică pe care o poate lua o genă, reprezentând o alegere particulară din domeniul de valori admisibile. Genotipul este reprezentarea internă completă a soluției, manipulată de operatorii genetici. Fenotipul constituie manifestarea externă, reprezentând soluția decodificată în contextul problemei reale. Locus-ul identifică poziția fizică a unei gene în cadrul cromozomului.

Populația este mulțimea de cromozomi evaluați simultan la un moment dat, reprezentând diversitatea soluțiilor exploratate. Individul sau parentul desemnează un cromozom specific din populație. Descendentul este cromozomul nou generat prin aplicarea operatorilor genetici asupra părinților selectați. Generația constituie iterația curentă a ciclului evolutiv, marcând trecerea de la o populație la următoarea prin procese de selecție și reproducere. Fitness-ul cuantifică calitatea relativă a unui cromozom, reprezentând măsura de performanță utilizată pentru ghidarea selecției.

Selecția este procesul prin care indivizii sunt aleși pentru reproducere pe baza fitness-ului, conferind șanse superioare celor cu performanță ridicată. Încrucișarea genetică sau crossover-ul combină materialul genetic de la doi sau mai mulți părinți pentru generarea descendenților, facilitând explorarea rapidă prin recombinarea caracteristicilor prometțătoare. Mutația introduce modificări aleatorii în cromozomi, menținând diversitatea genetică și prevenind convergența prematură către optima locale. Elitismul asigură transferul nemodificat al celor mai buni indivizi către generația următoare, protejând soluțiile de calitate superioară împotriva pierderii accidentale.

Convergența descrie starea în care populația devine omogenă, majoritatea indivizilor având fitness similar și caracteristici genetice apropiate. Diversitatea genetică măsoară gradul de variabilitate din populație, fiind esențială pentru capacitatea de explorare continuă. Explorarea desemnează investigarea regiunilor noi și neexplorate din spațiul de căutare. Exploatarea intensifică căutarea în regiunile cunoscute ca fiind promițătoare, rafinând soluțiile existente. Echilibrul dintre explorare și exploatare determină eficiența algoritmului, explorarea excesivă prelungind inutil procesul, iar exploatarea prematură ducând la convergență înainte de identificarea optimului global.

## 2.2 Structura și Funcționarea Algoritmului

Ciclul evolutiv urmează o schemă iterativă standardizată, descrisă sintetic prin pașii principali prezentați în figura 2.1.

**Figura 2.1 – Structura generică a unui algoritm genetic**

Inițializarea generează populația inițială, de obicei aleatoriu, asigurând acoperirea diversă a spațiului de căutare. Evaluarea calculează fitness-ul fiecărui individ prin aplicarea funcției obiectiv. Verificarea condiției de terminare determină dacă algoritmul a atins criteriile de oprire stabilite. Selecția alege indivizii pentru reproducere pe baza fitness-ului. Încrucișarea combină materialul genetic al părinților selectați. Mutația introduce variații aleatorii în descendenți. Formarea noii populații înlocuiește total sau parțial populația curentă cu descendenții generați. Ciclul se repetă de la evaluare până la îndeplinirea criteriului de terminare.

Mecanismul de funcționare emulează selecția naturală prin conferirea de șanse superioare de reproducere indivizilor cu fitness ridicat, reflectând principiul supraviețuirii celui mai adaptat. Crossover-ul permite combinarea caracteristicilor prometțătoare de la doi părinți, facilitând explorarea rapidă a spațiului de căutare prin generarea de noi configurații ce moștenesc trăsături benefice. Mutația introduce variații aleatorii în materialul genetic, menținând diversitatea populației și prevenind convergența prematură către optima locale. Acest echilibru dintre exploatarea soluțiilor promițătoare și explorarea regiunilor noi constituie fundamentul eficienței algoritmilor genetici.

Funcția de fitness mapează fiecare cromozom la o valoare numerică reprezentând calitatea soluției corespunzătoare. În esență, funcția de fitness primește ca intrare un genotip (reprezentarea internă a soluției) și returnează un număr real care indică cât de bună este acea soluție. Calculul fitness-ului reprezintă operația cea mai frecvent executată și intensivă computațional din algoritm, influențând direct viteza de execuție. Caracteristicile unei funcții de fitness eficiente includ:

- viteza de calcul ridicată;
- măsură cantitativă obiectivă;
- sensibilitate la diferențele de calitate;
- continuitate sau regularitate.

În majoritatea cazurilor, funcția de fitness este identică cu funcția obiectiv a problemei de optimizare. Cu toate acestea, pot fi necesare ajustări pentru încorporarea constrângerilor sau pentru îmbunătățirea comportamentului algoritmului. Penalizările se aplică soluțiilor nefezabile sau celor ce violează constrângeri, reducând artificial fitness-ul acestora pentru descurajarea propagării lor în generațiile ulterioare. Transformările pot fi aplicate pentru modificarea peisajului fitness-ului prin scalare sau normalizare, ajustând presiunea de selecție. În cazurile unde evaluarea exactă este prohibitiv costisitoare, se poate recurge la aproximarea fitness-ului prin modele surrogate, construite pe baza unui subset de evaluări complete.

Reprezentarea cromozomială determină modul în care soluțiile sunt codificate și manipulate de operatorii genetici. Alegerea reprezentării influențează semnificativ eficiența algoritmului, fiind necesară adaptarea la natura problemei și asigurarea că operatorii genetici generează soluții valide. Tipurile principale de reprezentare sunt prezentate în tabelul 2.1.

**Tabelul 2.1 – Tipuri de reprezentare cromozomială**

| Tip Reprezentare | Domeniu de Aplicare | Avantaje Principale | Dezavantaje |
|------------------|---------------------|---------------------|-------------|
| Binară | Probleme cu variabile booleene | Simplitate, operatori generici | Redundanță, probleme Hamming cliff |
| Valori reale | Optimizare continuă | Precizie ridicată, fără codificare | Necesită operatori adaptați |
| Numere întregi | Selecție din seturi discrete | Natural pentru probleme combinatorii | Limitată la domenii finite |
| Permutare | Probleme de secvențiere | Validitate inerentă, compact | Operatori specializați obligatorii |

Reprezentarea binară constă într-un șir de biți și este adecvată pentru variabilele de decizie booleene sau pentru codificarea discretizată a variabilelor continue. Avantajul constă în simplitatea operatorilor genetici, crossover-ul realizându-se prin simpla împărțire și combinare a șirurilor de biți, iar mutația prin inversarea biților selectați aleatoriu. Dezavantajul major este fenomenul cunoscut ca Hamming cliff, unde valori numerice apropiate pot avea reprezentări binare foarte diferite, provocând discontinuități în spațiul genotipic. Codificarea Gray atenuează această problemă prin asigurarea că numere consecutive diferă printr-un singur bit, îmbunătățind continuitatea explorării. 

Pentru probleme cu variabile continue definite pe intervalul `[a, b]`, intervalul este împărțit în subdiviziuni. Precizia reprezentării depinde de numărul `n` de biți utilizați: cu cât `n` este mai mare, cu atât subdiviziunile `2^n` sunt mai mici și cu atât mai precisă este reprezentarea. De exemplu, pentru a reprezenta valori între zero și zece folosind `n=8` biți, vom avea `2^8 = 256` subdiviziuni posibile, deci precizia va fi `(b-a) / 2^n = 10 / 256 ≈ 0.039`.

Reprezentarea cu valori reale stochează direct valorile numerice ale variabilelor continue și este utilizată frecvent în optimizarea inginerească și științifică. Avantajul principal constă în precizia ridicată și eliminarea erorilor de codificare-decodificare. Operatorii genetici trebuie adaptați pentru manipularea vectorilor numerici, crossover-ul putând fi aritmetic unde descendenții sunt combinații liniare ale părinților sau cu punct de tăiere adaptat, iar mutația adaugă perturbații aleatorii cu distribuție controlată, de exemplu gaussiană cu deviație standard descrescătoare pentru rafinare progresivă. Această reprezentare este preferată pentru probleme de optimizare continuă unde precizia numerică este crucială.

Reprezentarea cu numere întregi este ideală pentru variabilele discrete din intervale finite, precum codificarea deciziilor dintr-un set ordonat de opțiuni. Este frecvent utilizată în probleme de alocare a resurselor, programare sau configurare de sisteme cu parametri discreti. Operatorii sunt similari celor pentru reprezentarea binară, cu adaptări pentru menținerea valorilor în intervalele permise. Mutația poate incrementa sau decrementa aleatoriu valoarea cu respectarea limitelor, iar crossover-ul combină segmente de șiruri de întregi.

Reprezentarea prin permutare codifică soluțiile ca ordonări ale unui set fix de elemente, fiind ideală pentru probleme de secvențiere, rutare și aranjamente unde fiecare element trebuie să apară exact o dată. Problema Comis-Voiajorului, programarea task-urilor și optimizarea layout-urilor de tastatură utilizează această reprezentare. Validitatea este asigurată inerent, orice permutare fiind o soluție fezabilă din perspectiva constrângerilor de unicitate. Operatorii genetici trebuie proiectați specific pentru a păstra proprietatea de permutare, evitând generarea de duplicate sau omisiuni.

Gestiunea populației constituie un aspect critic al algoritmului, performanța finală fiind puternic influențată de mărimea, diversitatea și metodele de înlocuire ale populației. Dimensiunea populației trebuie stabilită printr-un compromis: o populație prea mare încetinește algoritmul proporțional cu costul evaluării fitness-ului, în timp ce o populație prea mică nu asigură un bazin genetic suficient diversificat pentru explorarea eficientă a spațiului de căutare. Studiile empirice sugerează că dimensiuni între cincizeci și două sute de indivizi sunt adecvate pentru majoritatea problemelor, cu ajustări în funcție de complexitatea spațiului.

## 2.3 Operatori Genetici

Operatorii genetici reprezintă mecanismele prin care se generează noi soluții candidate, constituind motorul evolutiv al algoritmilor genetici. Cei doi operatori fundamentali sunt crossover-ul, care combină materialul genetic de la doi sau mai mulți părinți, și mutația, care introduce variații aleatorii în cromozomi individuali. Selecția precede aplicarea acestor operatori, determinând care indivizi participă la reproducere.

Selecția implementează presiunea evolutivă prin favorizarea indivizilor cu fitness ridicat, conferindu-le șanse superioare de a transmite materialul genetic către generațiile ulterioare. Metodele principale de selecție includ:

- selecția prin ruletă;
- selecția prin turnir;
- selecția prin rang;
- selecția uniformă.

Selecția prin ruletă atribuie fiecărui individ o probabilitate de selecție proporțională cu fitness-ul său relativ față de suma fitness-urilor întregii populații. Metoda emulează o roată a norocului unde fiecare individ ocupă un sector proporțional cu fitness-ul său, selecția realizându-se prin rotiri aleatorii. Mai exact, dacă un individ `i` are fitness `f_i` și suma tuturor fitness-urilor din populație este `F = sum(f_j)` pentru toți indivizii `j`, atunci probabilitatea de selecție a individului `i` este `p_i = f_i / F`. Avantajul constă în simplitatea conceptuală și implementării. Dezavantajele includ posibilitatea ca indivizi cu fitness excepțional de ridicat să domine rapid selecția, provocând convergență prematură, și dificultatea de aplicare pentru fitness-uri negative, care necesită transformări prealabile.

Selecția prin turnir alege aleatoriu un subset de indivizi și selectează cel mai bun dintre aceștia. Dimensiunea turnirului controlează presiunea de selecție: turniruri mari favorizează puternic indivizii cu fitness ridicat, în timp ce turniruri mici oferă șanse mai echilibrate. Metoda este simplă, eficientă computațional și aplicabilă direct pentru fitness-uri negative sau neordonate strict. Presiunea de selecție se ajustează ușor prin modificarea dimensiunii turnirului, oferind control fin asupra echilibrului explorare-exploatare.

Selecția prin rang ordonează indivizii după fitness și atribuie probabilități bazate pe poziția în clasament, nu pe valoarea absolută a fitness-ului. Această abordare elimină problemele legate de dominația indivizilor cu fitness extrem de ridicat și funcționează uniform indiferent de scala fitness-ului. Dezavantajul constă în costul computațional al sortării, dar pentru populații moderate, impactul este neglijabil.

Selecția uniformă sau aleatorie alege indivizi fără a considera fitness-ul, fiind utilizată rar ca metodă principală, dar poate fi combinată cu alte strategii pentru menținerea diversității sau explorarea aleatorie periodică.

Crossover-ul combină materialul genetic de la doi sau mai mulți părinți pentru generarea descendenților, facilitând explorarea rapidă prin recombinarea caracteristicilor prometțătoare. Tipurile principale depind de reprezentarea utilizată.

Pentru reprezentarea binară, crossover-ul cu un punct de tăiere selectează aleatoriu o poziție în cromozom și împarte ambii părinți la acea poziție, combinând segmentele pentru a forma doi descendenți. Să presupunem că avem doi părinți reprezentați ca șiruri de biți:

- Părinte 1: [1, 0, 1, 1, 0, 1, 0, 0]
- Părinte 2: [0, 1, 0, 0, 1, 1, 1, 1]

Dacă punctul de tăiere este ales după a patrea poziție, atunci:

- Descendent 1 preia primele patru gene de la Părinte 1 și ultimele patru de la Părinte 2: [1, 0, 1, 1, 1, 1, 1, 1]
- Descendent 2 preia primele patru gene de la Părinte 2 și ultimele patru de la Părinte 1: [0, 1, 0, 0, 0, 1, 0, 0]

Crossover-ul cu două puncte selectează două poziții aleatorii și schimbă segmentul intermediar între părinți. Crossover-ul uniform decide independent pentru fiecare poziție de la care părinte se copiază gena, oferind explorare mai intensă dar riscând distrugerea blocurilor de construcție benefice.

Pentru reprezentarea cu valori reale, crossover-ul aritmetic generează descendenți prin combinații liniare ale părinților. De exemplu, dacă avem doi părinți P1 și P2, și un parametru de amestecare `α` (să zicem 0.3), atunci:

- Descendent 1 = `α` × P1 + (1 - `α`) × P2
- Descendent 2 = (1 - `α`) × P1 + `α` × P2

Această metodă garantează că descendenții sunt în interiorul convexului definit de părinți, asigurând explorarea regiunii intermediare. Variante mai sofisticate permit extrapolarea în afara convexului pentru explorare extinsă.

Pentru reprezentarea prin permutare, crossover-ul standard generează duplicate și omisiuni, fiind necesari operatori specializați ce preservă proprietatea de permutare. Operatorii principali includ:

a) crossover ordonat:
   1) selectează un segment aleatoriu de la un părinte;
   2) copiază segmentul în aceeași poziție la descendent;
   3) completează restul cu elemente din celălalt părinte în ordinea apariției;
b) crossover parțial mapat:
   1) stabilește corespondențe între elemente în segmentul selectat;
   2) utilizează aceste mapări pentru completarea restului;
c) crossover ciclic:
   1) identifică cicluri de poziții legate prin elemente comune;
   2) schimbă ciclurile între părinți;
d) crossover bazat pe margini:
   1) construiește o structură de adiacență din ambii părinți;
   2) generează descendentul respectând adiacențele.

Crossover-ul ordonat poate fi ilustrat astfel: să presupunem că avem doi părinți care reprezintă rute:

- Părinte 1: [A, B, C, D, E, F, G, H, I]
- Părinte 2: [D, F, A, H, C, I, B, E, G]

Selectăm un segment aleatoriu din Părinte 1, de exemplu poziții 4-6 care conțin [D, E, F]. Acest segment este copiat direct în Descendent 1 în aceleași poziții. Apoi, completăm celelalte poziții cu elemente din Părinte 2 în ordinea în care apar, omițând elementele deja prezente (D, E, F). Rezultatul ar fi ceva de genul: [A, H, C, D, E, F, I, B, G].

Mutația introduce variații aleatorii în cromozomi individuali, menținând diversitatea genetică și permițând explorarea de noi regiuni ale spațiului de căutare. Pentru reprezentarea binară, mutația inversează biți selectați aleatoriu cu o rată de mutație `p_m`, de obicei între 0.01 și 0.05. Pentru reprezentarea cu valori reale, mutația adaugă perturbații aleatorii din distribuții precum uniforma sau gaussiana. Pentru reprezentarea prin permutare, mutația swap schimbă poziția a două elemente alese aleatoriu, mutația insert elimină un element și îl inserează într-o nouă poziție, iar mutația invert inversează ordinea unui subsegment aleatoriu.

Rata de mutație controlează intensitatea explorării. Rate prea mici reduc capacitatea de evadare din optima locale, în timp ce rate prea mari transformă căutarea în una aproape aleatorie, distrugând informația acumulată. Valori tipice se situează între 0.01 și 0.05 per genă, ajustate în funcție de dimensiunea cromozomului și convergența observată.

Elitismul asigură că cei mai buni indivizi din generația curentă sunt transferați nemodificați în următoarea, protejând soluțiile de calitate superioară împotriva pierderii accidentale prin operatorii stochastici. Numărul de indivizi elitari este de obicei mic, între unu și cinci, suficient pentru păstrarea progresului fără a încetini diversificarea populației.

Aglomerarea este fenomenul prin care indivizi similari cu fitness ridicat proliferează rapid, eliminând diversitatea. Pentru contracararea acestuia, se utilizează tehnici de menținere a diversității.

Partajarea fitness-ului penalizează indivizii care se află în proximitatea altor indivizi similari, reducând fitness-ul efectiv al acestora. Principiul este simplu: dacă un individ `i` are mulți vecini similari cu el în spațiul soluțiilor, fitness-ul său `f_i` este împărțit la un factor de partajare `sh(i)`, calculat ca `sh(i) = sum(s(d_{ij}))` pentru toți indivizii `j` din populație, unde `d_{ij}` este distanța dintre indivizii `i` și `j`, iar `s(d)` este o funcție de partajare (de exemplu, `s(d) = 1 - d/σ_share` dacă `d < σ_share`, altfel `s(d) = 0`). Fitness-ul partajat devine `f'_i = f_i / sh(i)`. Astfel, indivizii unici sau din regiuni mai puțin populate primesc un fitness efectiv mai mare. Această tehnică promovează menținerea de subpopulații în regiuni diferite ale spațiului, favorizând descoperirea multiplelor optima.

Mutația adaptivă ajustează dinamic rata de mutație în funcție de starea populației. Când diversitatea scade sub un prag, rata de mutație crește pentru introducerea de variabilitate suplimentară. Practic, algoritmul monitorizează cât de diferiti sunt indivizii din populație și, dacă observă că devin prea asemănători (semn al convergenței premature), crește rata de mutație pentru a reintroduce variabilitate.

Restart-uri multiple reinițializează parțial sau complet populația când convergența devine evidentă, păstrând doar cei mai buni indivizi și generând aleatoriu restul. Această strategie permite explorarea de noi regiuni după epuizarea potențialului regiunii curente.

Modelele avansate de gestionare a populației extind strategiile de bază pentru îmbunătățirea performanței. Modelele insulare împart populația în subpopulații izolate care evoluează independent, cu migrație periodică de indivizi între insule. Această abordare exploatează paralelismul natural și reduce riscul de convergență prematură globală, întrucât fiecare insulă explorează independent, iar migrația permite schimbul de material genetic benefic. Parametrii cheie includ:

- numărul de insule;
- frecvența migrației;
- numărul de migranți;
- topologia de conectare.

Pentru probleme complexe cu resurse computaționale distribuite, modelele insulare oferă scalabilitate excelentă și robustețe sporită.

Hibridizarea cu căutare locală transformă algoritmii genetici în Algoritmi Memetici, combinând explorarea globală a algoritmilor genetici cu intensificarea locală. După aplicarea operatorilor genetici, descendenții sunt rafinați prin metode de căutare locală înainte de evaluare. Această abordare accelerează semnificativ convergența și îmbunătățește calitatea soluțiilor finale, fiind deosebit de eficientă pentru probleme unde peisajul fitness-ului prezintă văi netede în jurul optimelor. Costul computațional suplimentar al căutării locale este compensat de reducerea numărului de generații necesare.

## 2.4 Criterii de Terminare

Criteriile de terminare determină când algoritmul genetic încetează execuția, fiind esențiale pentru eficiența computațională și calitatea soluției finale. Alegerea criteriului adecvat depinde de natura problemei, resursele disponibile și obiectivele aplicației. Criteriile principale includ:

- număr fix de generații;
- atingerea unui nivel de fitness țintă;
- diversitate sub pragul minim;
- saturația îmbunătățirii;
- limite de timp sau resurse computaționale.

Numărul fix de generații oprește execuția după un număr predeterminat de iterații, oferind predictibilitate și control asupra duratei. Acest criteriu este simplu de implementat și garantează terminarea în timp finit. Dezavantajul constă în posibila oprire prematură dacă numărul este prea mic sau continuarea inutilă dacă este prea mare.

Atingerea unui nivel de fitness țintă oprește când cel puțin un individ atinge sau depășește o valoare specificată. Acest criteriu este util când optimul sau o aproximare acceptabilă sunt cunoscute. Problema constă în necesitatea cunoașterii prealabile a valorii țintă, care adesea nu este disponibilă.

Diversitatea sub pragul minim monitorizează variabilitatea populației și oprește când aceasta scade sub o limită stabilită. Algoritmul măsoară cât de diferiți sunt indivizii din populație (prin calcularea varianței genelor, distanțelor între indivizi, sau alte metrici de diversitate) și se oprește când această măsură devine foarte mică, indicând că populația a devenit omogenă. Acest criteriu previne execuția inutilă după convergență, dar poate opri prematur dacă pragul este prea ridicat.

Saturația îmbunătățirii monitorizează progresul fitness-ului și oprește când nu se observă îmbunătățiri semnificative într-un număr `k` de generații consecutive. De exemplu, dacă diferența absolută dintre cel mai bun fitness de acum și cel mai bun fitness de acum `k` generații (`|best_now - best_k_generations_ago|`) este mai mică decât un prag `ε` (să zicem 0.001), atunci algoritmul se oprește. Acest criteriu este robust și frecvent utilizat, identificând saturația efectivă fără a depinde de cunoștințe prealabile despre optimum.

Limite de timp sau resurse computaționale opresc execuția după o durată prestabilită sau după consumarea unui buget de evaluări de fitness, fiind esențiale pentru aplicații cu constrângeri de timp real sau în contexte comparative unde bugetul computațional trebuie să fie egal.

## 2.5 Considerații Teoretice și Gestionarea Constrângerilor

Considerațiile teoretice oferă fundamentare matematică pentru înțelegerea comportamentului algoritmilor genetici. Teorema Schema, formulată de Holland, demonstrează că schemele scurte, de ordin scăzut și cu fitness ridicat primesc un număr exponențial crescător de încercări în generațiile succesive. O schemă reprezintă un șablon de poziții fixe în cromozom, de exemplu [1,*,*,0,*] unde * reprezintă poziții arbitrare. Ordinul schemei este numărul de poziții fixe, iar lungimea de definire este distanța între prima și ultima poziție fixă. Teorema sugerează că algoritmii genetici exploatează implicit paralelismul, evaluând și procesând un număr mare de scheme simultan prin evaluarea cromozomilor individuali.

Ipoteza Blocurilor de Construcție postulează că algoritmii genetici obțin performanță superioară prin combinarea de scheme scurte și foarte apte pentru a forma soluții complexe de calitate înaltă. Această ipoteză justifică utilizarea crossover-ului, care combină blocuri de la părinți diferiți. Cu toate acestea, crossover-ul poate distruge blocuri benefice dacă acestea sunt întrerupte de punctele de tăiere, motiv pentru care operatorii precum crossover-ul uniform sau cu multiple puncte prezintă compromisuri între explorare și menținerea blocurilor.

Teorema Fără Prânz Gratuit afirmă că, mediat peste toate problemele de optimizare posibile, performanța oricărui algoritm de căutare este identică. Această teoremă implică că nu există un algoritm universal optim, superioritatea unui algoritm depinzând de structura specifică a problemei abordate. Pentru algoritmii genetici, performanța depinde de existența regularităților în peisajul fitness-ului care să permită exploatarea de către operatorii evolutivi. Probleme complet aleatorii nu beneficiază de algoritmi genetici față de căutarea aleatorie, dar probleme reale prezintă adesea structuri exploatabile. Teorema subliniază importanța adaptării algoritmului la problema specifică prin alegerea reprezentării, operatorilor și parametrilor adecvați.

Gestionarea constrângerilor este esențială pentru aplicarea algoritmilor genetici la probleme reale, care impun adesea restricții asupra soluțiilor admisibile. Constrângerile pot fi clasificate în trei categorii principale:

a) constrângeri de egalitate:
   1) de forma `h(x) = 0`;
   2) exemple: ecuații de echilibru, conservare;
b) constrângeri de inegalitate:
   1) de forma `g(x) ≤ 0`;
   2) exemple: limite de capacitate, resurse;
c) constrângeri de domeniu:
   1) variabila `x` trebuie să aparțină unei mulțimi specifice `D`;
   2) exemple: intervale admisibile, mulțimi discrete.

Strategiile de gestionare includ funcții de penalizare care reduc fitness-ul soluțiilor nefezabile proporțional cu gradul de violare. Practic, fitness-ul unei soluții nefezabile este diminuat în funcție de cât de mult încalcă ea constrângerile. De exemplu, dacă o soluție `x` depășește o limită de capacitate, fitness-ul ei `f(x)` poate fi penalizat pentru fiecare violare `v_i` conform relației `f'(x) = f(x) - sum(α_i * v_i)`, unde `α_i` este coeficientul de penalizare. Coeficienții de penalizare controlează severitatea reducerii fitness-ului. Valori prea mici permit persistența soluțiilor nefezabile, în timp ce valori prea mari pot face peisajul fitness-ului abrupt și dificil de explorat. Penalizările adaptive ajustează coeficienții pe parcursul execuției în funcție de proporția soluțiilor nefezabile din populație.

Operatori de reparație transformă soluțiile nefezabile în soluții fezabile apropiate prin aplicarea de euristici sau proceduri de proiecție. Această abordare este mai eficientă decât penalizarea când există metode rapide de corectare. Reparația după generare aplică operatorii genetici fără restricții și corectează ulterior descendenții. Reparația integrată modifică operatorii pentru a genera direct soluții fezabile.

Pentru constrângeri complexe, se pot utiliza euristici specifice domeniului pentru corectarea violărilor. Această abordare este eficientă dar necesită cunoștințe despre structura constrângerilor și poate introduce bias.

Operatorii specializați și codificări ce respectă constrângerile evită complet generarea de soluții nefezabile. Reprezentarea prin permutare pentru probleme de secvențiere este un exemplu: orice permutare este validă, eliminând necesitatea gestionării constrângerilor de unicitate. Pentru alte probleme, operatorii pot fi proiectați să mențină fezabilitatea. Această abordare este preferabilă când este posibilă, reducând complexitatea și îmbunătățind eficiența.

Separarea obiectivelor și constrângerilor tratează constrângerile ca obiective secundare într-un cadru multi-obiectiv, utilizând tehnici precum dominația bazată pe constrângeri. Regulile de dominație sunt:

a) între soluții fezabile:
   1) dominația se bazează pe fitness-ul obiectivului;
b) între soluții nefezabile:
   1) dominația se bazează pe gradul de violare;
c) între soluții fezabile și nefezabile:
   1) soluțiile fezabile domină întotdeauna.

Această abordare permite explorarea graniței dintre regiunea fezabilă și cea nefezabilă, facilitând descoperirea soluțiilor optime pe frontiera constrângerilor.

Capitolul a prezentat algoritmii genetici ca metode evolutive versatile pentru optimizare complexă, detaliind terminologia, reprezentările, operatorii, gestiunea populației și criteriile de terminare. Versatilitatea algoritmilor genetici, combinată cu capacitatea de adaptare la probleme specifice prin configurarea reprezentării și operatorilor, îi face instrumente puternice pentru probleme complexe unde metodele clasice sunt inadecvate. Succesul depinde de înțelegerea profundă a problemei și calibrarea adecvată a parametrilor.
