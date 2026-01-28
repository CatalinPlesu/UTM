# 4. IMPLEMENTAREA ȘI REZULTATELE EXPERIMENTALE

Acest capitol detaliază implementarea practică a metodologiei descrise anterior, structura codului sursă, configurațiile experimentale și rezultatele obținute prin rulări multiple ale algoritmului genetic. Implementarea se bazează pe simulare directă a tastării pe seturi de date unificate, evaluând layout-uri generate în raport cu cele existente. Rezultatele evidențiază că layout-urile optimizate depășesc semnificativ QWERTY în termeni de eficiență, oferind îmbunătățiri marginale față de Colemak în scenarii generale de aproximativ 7%, dar beneficii substanțiale în configurații personalizate pentru utilizatori cu mobilitate inegală a mâinilor sau degetelor, ajungând până la 14% față de Colemak. 

Procesul de implementare integrează componentele metodologice într-un sistem modular Python cu modul de calcul accelerat în C#, permițând ajustări rapide și experimentare sistematică. Sistemul suportă procesare distribuită prin RabbitMQ, facilitând scalarea orizontală pe clustere heterogene. Simularea parcurge texte unificate pentru calculul fitness-ului, iar algoritmul genetic evoluează populații pe baza acestuia. Rezultatele din 31 de rulări experimentale arată convergență către soluții cvasi-optime, cu variații dependente de parametrii aleși: dimensiunea populației și numărul de iterații. 

Explorarea sistematică a spațiului de parametri a identificat configurații optime: populație de 300 indivizi cu 50 iterații pentru calitate maximă, sau 110 indivizi cu 200 iterații pentru echilibru cost-beneficiu. Analiza comparativă confirmă beneficiile limitate față de Colemak în configurații standard, dar demonstrează potențialul semnificativ al personalizării prin ajustarea coeficienților de penalizare pentru cazuri specifice de mobilitate redusă. Experimentele cu configurație personalizată pentru mâna stângă au produs îmbunătățiri de 14% față de Colemak, validând valoarea practică a optimizării individualizate.

Capitolul este structurat în șase secțiuni principale: arhitectura sistemului și componentele implementate, explorarea sistematică a spațiului de parametri prin 31 de rulări experimentale, rezultatele detaliate pe Simple English Wikipedia în configurație standard, rezultatele cu configurație personalizată pentru mobilitate asimetrică, implicațiile personalizării și direcții de îmbunătățire, precum și limitările generale și direcțiile de cercetare viitoare. Implementarea asigură reproducibilitate prin descrieri detaliate ale tuturor componentelor, parametrilor și procedurilor experimentale. Codul sursă complet al implementării este disponibil public la adresa https://github.com/CatalinPlesu/ErgoType.2#.

## 4.1 Arhitectura Sistemului și Inițierea Proiectului 

Implementarea sistemului de optimizare s-a realizat în Python, cu integrarea unui modul de calcul fitness în C# pentru accelerarea simulărilor intensive. Codul a fost organizat modular, separând clar funcționalitățile și facilitând extinderea ulterioară. Structura proiectului reflectă principiile de inginerie software pentru sisteme de cercetare reproductibile.

Directorul principal conține:

- cs;
    - Class.cs;
    - KeyboardFitness.csproj;
    - makefile;
- main.py;
- pyproject.toml;
- rabbitmq;
    - docker-compose.yml;
- src;
    - core;
        - ga.py;
        - keyboard.py;
        - layout.py;
        - mapper.py;
        - evaluator.py;
        - job_queue.py;
        - clr_loader_helper.py;
        - map_json_exporter.py;
    - config;
        - config.py;
    - data;
        - layouts;
            - keyboard_genotypes.py;
        - text;
            - raw;
        - keyboards;
    - helpers;
        - keyboards;
            - annotator_gui.py;
        - text;
            - scrapers;
    - ui;
        - menu.py;

Modulul C# cs/ asigură calcul fitness accelerat prin implementarea în Class.cs a structurilor de date fundamentale și algoritmilor de simulare. Fișierul Class.cs definește record-urile Point și KeyPress pentru reprezentare geometrică, struct-ul CharStats pentru statistici caractere, clasa Finger pentru tracking poziție și distanțe cu metoda TapAndGetDistance() inline optimizată pentru performanță, și clasa Fitness cu metoda Compute() pentru calcul rapid returnând tuple total_distance; total_time și metoda ComputeStats() pentru analiză detaliată cu tracking hover și press counts. Configurația proiectului KeyboardFitness.csproj specifică .NET 9.0 cu optimizări Release, iar makefile-ul automatizează build-ul prin comanda dotnet build -c Release.

Punctul de intrare al aplicației main.py oferă interfață interactivă pentru configurarea și executarea experimentelor de optimizare, orchestrând încărcarea componentelor și lansarea algoritmului genetic. Configurația dependențelor pyproject.toml este gestionată prin uv pentru reproducibilitate exactă a mediului de dezvoltare, specificând versiunile precise ale bibliotecilor pythonnet; pika pentru RabbitMQ și rich pentru interfață utilizator.

Infrastructura de procesare distribuită rabbitmq/ conține fișierul docker-compose.yml care definește container RabbitMQ cu port 5672 pentru AMQP și 15672 pentru management UI, utilizator implicit user și parolă pass, cu volum persistent pentru persistența cozilor de joburi între restart-uri, permițând scalare orizontală prin adăugare worker-i pe mașini diferite.

Implementarea algoritmului genetic ga.py se bazează pe clasa Individual pentru reprezentarea cromozomilor cu atribute fitness; distance; time_taken; parents; generation, și clasa GeneticAlgorithmSimulation care orchestrează procesul evolutiv. Algoritmul implementează selecție prin turneu cu k=3 candidați pentru menținerea diversității, crossover uniform cu bias 0.75 către părintele mai bun pentru exploatare gradientului de fitness, și mutație swap cu rată adaptivă funcție de stagnare pentru echilibru explorare-exploatare. Sistemul de tracking al tuturor indivizilor evaluați prin dicționarul all_individuals permite analiză genealogică completă și recuperare după întreruperi. Suportul pentru faze dinamice de populație population_phases permite strategii de explorare-exploatare variabile, iar funcționalitatea de continuare din rulări anterioare continue_from_run cu re-evaluare optimizată economisește calcule redundante. Worker pool-ul local folosește ProcessPoolExecutor pentru paralelizare intra-nod, competând fair cu worker-i distribuiți pentru joburi prin sistem de pull bazat pe disponibilitate.

Modelul fizic al tastaturii keyboard.py definește clasa Key care encapsulează proprietăți geometrice x; y; width; height în unități KLE și proprietăți de adnotare finger; hand; homing pentru taste de referință F și J. Clasa Keyboard agregă tastele și oferă metode de căutare: get_finger_keys() filtrează taste pe deget, get_homing_key_for_finger_name() returnează tasta de referință cu caching pentru performanță. Clasa Serial implementează deserializarea formatului KLE prin metoda deserialize() care parsează structuri JSON complexe suportând rotații, offset-uri și proprietăți custom.

Manipularea layout-urilor logice layout.py se realizează prin clasa Layout care suportă multiple straturi: BASE_LAYER pentru caractere normale și ALTGR_LAYER pentru diacritice și caractere speciale. Metoda remap() permite modificare generică layout-uri prin mapare caracter-la-caracter, iar qwerty_based_remap() simplifică transformarea din QWERTY în alt layout prin aplicare directă genotip. Metoda find_key_for_char() efectuează căutare inversă returnând key_id; layer_id; key_obj pentru un caracter dat, esențială în simulare tastare. Integrarea cu Mapper gestionează taste speciale Tab; Enter; Space prin KeyType.SPECIAL_CHAR și taste de control Shift; Ctrl; Alt prin KeyType.CONTROL.

Sistemul de mapare taste-caractere mapper.py folosește enum-ul KeyType cu valori CHAR pentru caractere normale, SPECIAL_CHAR pentru taste cu label diferit de output Tab → '\t', CONTROL pentru modificatori Shift; Ctrl; Alt, LAYER pentru switch-uri de strat AltGr. Clasa Mapper implementează indexare duală prin dicționarele by_layer și by_key pentru acces rapid O(1), având metodele filter_data() pentru căutări globale, filter_by_layer() pentru filtrare pe strat specific, filter_by_key() pentru extragere toate straturile unei taste.

Orchestratorul de configurare evaluator.py coordonează încărcarea componentelor prin metoda load_keyboard() care citește fișier JSON tastatură și parsează cu Serial, metoda load_layout() care inițializează mapper-ul cu toate caracterele din tastatură, metoda load_dataset() care încarcă frecvențe din fișiere pickle procesate pentru statistici corpus.

Abstracția cozii de joburi job_queue.py implementează clasa JobQueue cu suport RabbitMQ și fallback automat in-memory dacă conexiunea eșuează, asigurând funcționare seamless. Metodele push_job() și pull_job() gestionează distribuția muncii cu acknowledgment manual pentru requeue automat în caz de eroare worker, metodele push_result() și pull_result() colectează rezultate de la worker-i, metodele push_config() și get_config() sincronizează configurația între master și worker-i la început de batch. Configurarea flexibilă prin dicționarul RABBITMQ_CONFIG host; port; user; pass; virtual_host permite deployment distribuit pe clustere heterogene.

Wrapper-ul pythonnet clr_loader_helper.py asigură inițializare sigură runtime CLR prin funcția initialize_clr_runtime() care poate fi apelată repetat fără erori, folosind flag global _runtime_initialized pentru tracking stare. Funcția load_csharp_fitness_library() automatizează încărcarea DLL din cs/bin/Release/net9.0/ și returnează clasa Fitness importată, cu gestionare excepții pentru cazuri când runtime-ul este deja inițializat de alt mecanism.

Interfața Python-C# map_json_exporter.py generează configurații JSON compatibile prin clasa CSharpFitnessConfig. Metoda _get_char_key_sequence() mapează caractere pe secvențe de keypresses, incluzând automat Shift pentru majuscule și AltGr pentru strat 1, respectând regula opposite-hand pentru taste modificatoare. Metoda generate_json_string() produce JSON cu structură validată: text_file_path cale absolută corpus, fitts_law coeficienți a; b, finger_coefficients listă 10 coeficienți pentru timp presare/sincronizare, homing_positions array 10 poziții Point cu finger și key_id, char_mappings dicționar caracter → array KeyPress. Generatorul asigură toate cele 10 poziții homing sunt completate, folosind fallback la centru tastatură x=6.5; y=2.5 pentru degete fără homing key explicit.

Fișierul config.py definește clase cu câmpuri statice pentru acces uniform la configurații. Clasa DatasetConfig specifică constante pentru câmpuri JSON: field_word_frequencies pentru lista cuvinte, field_character_frequencies pentru dicționar caractere, field_category_frequencies_relative pentru frecvențe normalizate. Clasa FitnessConfig conține parametri calcul: n_gram_multiplier pentru penalizare n-grame în simulări cu valoare tipică 8.0. Configurația globală este accesibilă în întreg proiectul prin import direct from src.config.config import Config.

Genotipurile predefinite keyboard_genotypes.py sunt stocate în dicționarul LAYOUT_DATA cu șapte layout-uri: qwerty referință tradițională, dvorak din 1936 cu alternare mâini, colemak din 2006 cu modificări minime, workman din 2010 cu poziții centrale, minimak pentru tranziție incrementală, norman pentru optimizare ergonomică, asset balansat frecvență-alternare. Fiecare layout este listă de 46 caractere în ordine fizică: rând 1 backtick-equals cu 13 taste, rând 2 q-backslash cu 13 taste, rând 3 a-apostrophe cu 11 taste, rând 4 z-slash cu 9 taste, permițând aplicare rapidă prin layout.remap(LAYOUT_DATA["qwerty"]; new_chromosome).

Corpus-urile text text/raw/ conțin fișiere neprocesate colectate de scraper-e, excluse din Git datorită dimensiunii de ordinul GB. Modelele tastaturi keyboards/ sunt fișiere JSON format KLE: ansi_60_percent.json pentru 60% ANSI cu 61 taste ca baseline comparație, dactyl_manuform_6x6_4.json pentru split ergonomic 6×6+4 thumb cu geometrie 2D, ferris_sweep.json pentru ultra-compact split cu 34 taste pentru portabilitate maximă.

Instrumentul de adnotare annotator_gui.py implementează GUI cu DearPyGui pentru adnotare interactivă taste, oferind interfață vizuală pentru selectare taste și atribuire finger; hand; homing, salvare automată modificări în fișier JSON cu validare format KLE, preview live al adnotărilor cu culori distinctive per deget pentru verificare rapidă.

Sistemul de colectare date text/scrapers/ conține cinci scraper-e specializate orchestrate de main.sh: get_100_cartigratis.py pentru cărți românești de pe CartiGratis.ro cu conversie PDF→TXT folosind pdfplumber și salvare în src/data/text/raw/cartigratis/, get_top_100_gutenberg_books.py pentru top 100 de la Project Gutenberg în format text plain salvat în src/data/text/raw/gutenberg/, newsgroup_20.py pentru 20 Newsgroups dataset de pe Kaggle cu aproximativ 20.000 mesaje în 20 categorii salvate în src/data/text/raw/newsgroups/, the_algorithms.py pentru clone GitHub The Algorithms/Python cu extragere fișiere .py salvate în src/data/text/raw/algorithms/, wikipedia_simple_english.py pentru articole Simple English Wikipedia prin API MediaWiki salvate în src/data/text/raw/wikipedia_simple/.

Clasa Menu din menu.py implementează interfață terminal cu navigare săgeți și enter pentru selecție, suport meniuri ierarhice cu submeniuri, handling semnale Ctrl+C pentru exit graceful.

Pregătirea seturilor de date este automatizată prin scraper-e Python orchestrate de main.sh, asigurând colectare rapidă, uniformă și reproductibilă. Scraper-ul get_100_cartigratis.py extrage cărți românești din PDF folosind pdfplumber pentru extragere text din pagini, aplică curățare pentru eliminare headere/footere repetitive, salvează fiecare carte individual cu numele sanitizat. Scraper-ul get_top_100_gutenberg_books.py accesează API Project Gutenberg pentru identificare cărți populare, descarcă versiuni text plain format .txt, salvează cu metadate autor/titlu în numele fișierului. Scraper-ul newsgroup_20.py descarcă dataset Kaggle folosind kaggle API cu autentificare kaggle.json, dezarhivează fișiere, organizează mesaje pe categorii. Scraper-ul the_algorithms.py clonează repository GitHub cu git, parcurge recursiv directoare pentru identificare fișiere .py, extrage cod sursă eliminând comentarii header, salvează consolidat. Scraper-ul wikipedia_simple_english.py accesează API MediaWiki pentru Simple English Wikipedia, extrage articole în format text prin parsare HTML, elimină markup wiki, salvează articole individual.

După achiziție, fiecare set de date este consolidat într-un singur fișier prin scripturi de compilare care concatenează toate fișierele dintr-un director, adăugând separatori între documente pentru menținere context. Procesul include curățare automată eliminând caractere imposibil de tastat, adică control characters ASCII sub 32 exceptând newline; tab; space și caractere Unicode exotice, precum și simboluri invalide prin filtrare, asigurând validitatea pentru simulare. Rezultatul sunt fișiere .txt mari de sute MB în directorul raw/, procesate direct de biblioteca C# în evaluare fitness fără intermediari.

Modelele fizice folosesc format JSON conform Keyboard Layout Editor cu extensii ergonomice. Configurația ansi_60_percent.json reprezintă tastatură compactă 60% în format ANSI cu 61 taste aranjate în layout tradițional QWERTY, constituind baseline pentru comparație cu layout-uri ergonomice, tastele fiind aranjate în 4 rânduri cu offset standard 0.0; 0.25; 0.5; 0.0, fără proprietăți 3D. Configurația dactyl_manuform_6x6_4.json descrie tastatură ergonomică split cu 6×6 taste per mână pentru degete și 4 taste pentru degetele mari, având geometrie plană 2D cu proprietăți x și y pentru poziționare taste în spațiu, fără coordonate z sau rotații complexe. Configurația ferris_sweep.json specifică tastatură ultra-compactă split cu 34 taste reprezentând 17 per mână aranjate în 3 rânduri plus 2 taste thumb per mână, optimizată pentru portabilitate maximă și minimizare mișcări degete.

Fiecare tastă necesită adnotare manuală: proprietatea finger cu valori PINKY; RING; MIDDLE; INDEX; THUMB, proprietatea hand cu valori LEFT; RIGHT; BOTH pentru taste partajate precum Space, proprietatea homing setată true pentru taste referință F și J pe ANSI sau echivalente pe tastaturi ergonomice. Adnotarea se realizează prin annotator_gui.py care oferă afișare vizuală taste cu poziții geometrice, selecție taste prin click și atribuire proprietăți prin dropdown-uri, preview live cu culori distinctive per deget, salvare automată cu validare format KLE.

Adnotările permit calcul precis distanțe prin metoda get_key_center_position() returnând punctul geometric central x + width/2; y + height/2, fiind esențiale pentru implementare legea Fitts MT = a + b × log₂(D/W + 1) unde D este distanța și W lățimea tastei țintă și tracking stateful poziții degete în clasa Finger din Class.cs.

Genotipurile predefinite servesc ca punct plecare pentru algoritm și benchmark-uri pentru comparație. Fiecare layout este listă ordonată de 46 caractere mapabilă direct pe orice aranjament fizic prin operație remap. Ordinea caracterelor corespunde poziției fizice conform convenție KLE: rândul 1 de la backtick la equals cu 13 taste, rândul 2 de la q la backslash cu 13 taste, rândul 3 de la a la apostrophe cu 11 taste, rândul 4 de la z la slash cu 9 taste. Reprezentarea permite aplicare rapidă prin layout.remap(LAYOUT_DATA["qwerty"]; new_chromosome) care mapează caractere din poziție QWERTY în poziție nouă specificată de cromozom.

## 4.2 Explorarea Sistematică a Spațiului de Parametri

Această secțiune descrie experimentele pentru identificarea configurației optime a algoritmului genetic. Au fost efectuate 31 de rulări distincte, variind două dimensiuni principale: dimensiunea populației de la 5 la 500 indivizi și numărul maxim de iterații de la 5 la 300 generații. Scopul a fost evaluarea impactului parametrilor asupra calității soluțiilor finale și eficienței computaționale.

Experimentele au fost executate pe setul de date Simple English Wikipedia, cu înregistrare automată a metricilor: fitness-ul celui mai bun individ, fitness-ul mediu al populației, numărul total de indivizi evaluați, numărul de generații efectiv parcurse. 

Tabelul 4.1 prezintă un subset reprezentativ al celor 31 de rulări:

**Tabelul 4.1 – Rezultate selectate din explorarea parametrilor**

| Run | Pop Size | Max Iter | Gens | Total Inds | Best Fitness |
|-----|----------|----------|------|------------|--------------|
| ga_run_2025-12-13--15-46-21 | 300 | 50 | 51 | 11062 | 0.420397 |
| ga_run_2025-12-14--09-25-24 | 110 | 200 | 141 | 5737 | 0.434057 |
| ga_run_2025-12-13--18-04-05 | 70 | 100 | 101 | 3160 | 0.436152 |
| ga_run_2025-12-14--11-12-21 | 70 | 300 | 170 | 4250 | 0.453160 |
| ga_run_2025-12-13--14-44-17 | 5 | 50 | 5 | 22 | 0.743611 |

Vizualizarea corelației tridimensionale Figura 4.1 ilustrează relația între dimensiunea populației, numărul de generații efectiv parcurse și fitness-ul obținut. Axa X reprezintă dimensiunea populației, axa Y numărul de generații executate, iar axa Z valorile fitness-ului unde valori mai mici indică performanță superioară.

**Figura 4.1 – Corelație 3D între populație, iterații și fitness**

Prima tendință identificată: populațiile mari correlează puternic cu atingerea numărului maxim de iterații configurat. Configurațiile cu 200-500 indivizi completează practic întotdeauna cele 50-100 de generații planificate, indicând că diversitatea genetică susține explorarea continuă fără stagnare prematură. În contrast, populațiile sub 50 de indivizi converg frecvent după 20-40% din iterațiile disponibile.

A doua tendință confirmă ipoteza centrală: fitness-ul îmbunătățit rezultă din combinația populații mari și iterații substanțiale. Zona optimă se situează în regiunea 150-300 indivizi × 40-100 generații, unde clustering-ul soluțiilor de calitate superioară este vizibil. Punctele izolate cu fitness peste 0.70 corespund configurațiilor cu populație minimă de 5 indivizi, demonstrând vizual limitările diversității reduse.

Figura 4.2 prezintă relația directă între dimensiunea populației și iterațiile efectiv parcurse, cu culori reprezentând numărul maxim de iterații configurat:

**Figura 4.2 – Populație versus iterații efectiv parcurse**

Analiza datelor identifică trei configurații recomandate pentru scenarii distincte. Configurația de calitate maximă utilizează populație de 300 indivizi și 50 iterații, producând best fitness absolut de 0.420397 după evaluarea a 11.062 indivizi în 5.124 secunde, oferind raport cost-beneficiu excelent. Configurația echilibrată cu populație de 110 indivizi și 200 iterații atinge fitness de 0.434057 cu 5.737 evaluări, fiind potrivită pentru experimente iterative rapide. Configurația rapidă folosește populație de 70 indivizi și 100 iterații, obținând fitness de 0.436152 cu 3.160 evaluări, utilă pentru validare conceptuală.

Acoperirea spațiului de căutare Figura 4.3 arată că, după evaluarea a aproximativ 5.000-7.000 de indivizi, îmbunătățirile devin marginale. Acest rezultat sugerează că explorarea extensivă cu zeci de mii de evaluări nu justifică costul computațional adițional.

**Figura 4.3 – Acoperirea spațiului de căutare versus calitate**

Heatmap-ul fitness-ului Figura 4.4 vizualizează concentrarea soluțiilor optime în zona 150-300 indivizi × 40-100 iterații, cu tranziție graduală către performanțe slabe când parametrii scad sub praguri critice.

**Figura 4.4 – Heatmap al fitness-ului pe spațiul parametrilor**

## 4.3 Rezultate pe Simple English Wikipedia – Configurație Standard

Evaluarea detaliată folosește configurația optimă identificată anterior. Experimentul a utilizat tastatura compactă 60% cu 61 taste definită în ansi_60_percent.json și corpusul Simple English Wikipedia pentru simularea tastării. Parametrii legii Fitts au fost configurați cu valorile A=0.50 și B=0.30, iar coeficienții de penalizare pentru degete au fost setați uniform la valorile [0.07, 0.06, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.06, 0.07], reflectând forța relativă similară a degetelor ambelor mâini. Algoritmul a evaluat un total de 11.062 indivizi în timpul de execuție de 5.123 secunde, rezultând o medie de 0.463 secunde per individ. Best fitness obținut a fost 0.420397, corespunzând layoutului identificat ca gen_50-10944.

Figura 4.5 ilustrează dinamica întregii populații pe parcursul celor 51 de generații, incluzând valori minime, maxime, medii și percentilele 25%, 50%, 75%.

**Figura 4.5 – Evoluția fitness-ului pe parcursul generațiilor**

Convergența graduală este vizibilă: scădere pronunțată în primele 10-15 generații reprezentând explorare intensivă, urmată de îmbunătățiri incrementale reprezentând exploatare gradientului. Dispersia populației se reduce progresiv, indicând convergența către o regiune optimă. Valorile medii și mediane apropiindu-se de minimum în ultimele generații confirmă că majoritatea populației atinge performanțe apropiate de optimul găsit.

Heatmap-urile frecvenței de utilizare evidențiază diferențele între layouturi. Figura 4.6 prezintă QWERTY, figura 4.7 Colemak, figura 4.8 layoutul generat algoritmic.

**Figura 4.6 – Heatmap QWERTY pe Simple English Wikipedia**

QWERTY prezintă distribuție ineficientă cu caractere frecvente dispersate, concentrare ridicată pe rândul superior, utilizare intensă a degetului mic pentru litera p, vocale împrăștiate crescând distanțele.

**Figura 4.7 – Heatmap Colemak pe Simple English Wikipedia**

Colemak demonstrează îmbunătățire substanțială cu concentrare pe home row, distribuție echilibrată între mâini, vocale centralizate reducând distanțele pentru combinații frecvente vocal-consonantă.

**Figura 4.8 – Heatmap layout optim pe Simple English Wikipedia**

Layout-ul generat prezintă distribuție aproape identică cu Colemak, cu ajustări minore pentru caractere specifice. Similaritatea explică diferența marginală de performanță de aproximativ 7.3%.

Figura 4.9 compară toate layouturile standard cu layoutul generat algoritmic.

**Figura 4.9 – Compararea performanței layouturilor pe Wikipedia**

Rezultatele confirmă ierarhia așteptată. Layoutul generat obține fitness de 0.420397, constituind referința pentru comparații. Colemak înregistrează fitness de 0.453560, reprezentând o creștere de 7.3% față de layoutul generat și o îmbunătățire de 9.7% față de QWERTY. QWERTY obține fitness de 0.502485, cu 16.3% mai mare decât layoutul generat. Diferența absolută de 16.3% între layoutul generat și QWERTY reprezintă o îmbunătățire substanțială în distanța totală parcursă. Diferența de doar 7.3% față de Colemak este marginală, sugerând că adoptarea layoutului generat nu se justifică pentru utilizatori familiarizați cu Colemak, beneficiile necompensând efortul de reantrenare.

## 4.4 Rezultate cu Configurație Personalizată – Optimizare pentru Mâna Stângă

Experimentul demonstrează capacitatea algoritmului de a genera layouturi specializate pentru restricții individuale. Scenariul simulat: mobilitate redusă a mâinii drepte, necesitând concentrarea tastării pe mâna stângă.

Tabelul 4.2 compară parametrii experimentului personalizat cu configurația standard:

**Tabelul 4.2 – Comparația parametrilor standard versus personalizat**

| Parametru | Configurație Standard | Configurație Personalizată |
|-----------|----------------------|---------------------------|
| Keyboard File | ansi_60_percent.json | ansi_60_percent.json |
| Text File | simple_wikipedia_dataset.txt | simple_wikipedia_dataset.txt |
| Fitts A | 0.50 | 0.50 |
| Fitts B | 0.30 | 0.30 |
| Finger Coefficients L→R | [0.07, 0.06, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.06, 0.07] | [0.07, 0.06, 0.05, 0.05, 0.05, 0.9, 0.9, 1.0, 1.0, 1.0] |
| Population Size | 300 | 50 |
| Max Iterations | 50 | 50 |
| Total Evaluated | 11.062 | 2.550 |
| Best Fitness | 0.420397 | 0.430820 |
| Run Time seconds | 5.123 | 1.306 |

Coeficienții crescuți pentru mâna dreaptă între 0.9 și 1.0 versus 0.05-0.07 pentru mâna stângă forțează algoritmul să minimizeze utilizarea degetelor cu mobilitate redusă. Populația redusă la 50 indivizi a permis explorare rapidă, fiind suficientă datorită constrângerilor puternice impuse de coeficienți.

Layoutul personalizat produce îmbunătățiri semnificative față de toate layouturile standard evaluate cu aceeași funcție de penalizare asimetrică. Comparativ cu Colemak care obține fitness de 0.501095, layoutul generat cu valoare de 0.430820 reprezintă o îmbunătățire de 14.0%. Față de Asset care înregistrează 0.492747, îmbunătățirea este de 12.6%. QWERTY obține fitness de 0.511387, rezultând o diferență de 15.8% în favoarea layoutului personalizat.

Figura 4.10 prezintă heatmap-ul layoutului personalizat:

**Figura 4.10 – Heatmap layout personalizat cu concentrare pe mâna stângă**

Heatmap-ul evidențiază densitate mult mai mare de apăsări pe partea stângă, cu majoritatea caracterelor frecvente relocate pe tastele accesibile mâinii stângi. Caracterele rare și simbolurile speciale au fost plasate pe partea dreaptă, minimizând utilizarea mâinii cu mobilitate redusă.

## 4.5 Implicații ale Personalizării și Direcții de Îmbunătățire

Îmbunătățirea de 14% față de Colemak în scenariul cu mobilitate asimetrică demonstrează că personalizarea prin coeficienți ajustați produce beneficii substanțiale care justifică adoptarea unui layout specializat. Această abordare deschide posibilități pentru optimizări bazate pe limitări fizice precum leziuni, condiții medicale sau amputații parțiale, preferințe ergonomice pentru reducerea oboselii anumitor degete, adaptare profesională prin optimizare pentru programare sau scriere tehnică, și ajustare la distribuția caracterelor din limbi specifice.

Implementarea actuală prezintă trei limitări principale. Prima limitare este absența suportului pentru straturi multiple. Tratarea tuturor caracterelor pe un singur strat înseamnă că tastele mâinii drepte nu pot fi complet eliminate. Cu suport pentru straturi, caracterele rare ar putea fi mapate pe un strat secundar accesibil printr-o tastă modificatoare acționată de mâna stângă, eliminând practic necesitatea utilizării mâinii drepte pentru caractere alfabetice standard.

A doua limitare constă în dependența de setul de date utilizat. Layout-urile sunt optimizate pentru distribuția caracterelor din corpusul de antrenament, ceea ce înseamnă că un layout optim pentru Simple English Wikipedia ar putea să nu fie ideal pentru un programator care scrie predominant cod Python sau pentru un autor de conținut tehnic cu terminologie specifică.

A treia limitare se referă la modelarea simplificată a factorilor ergonomici. Coeficienții de penalizare captează doar forța relativă a degetelor, dar nu modelează aspecte complexe precum oboseala acumulată, poziția naturală a mâinilor sau impactul mișcărilor repetitive asupra dezvoltării leziunilor pe termen lung.

Direcțiile de îmbunătățire identificate includ integrarea suportului pentru straturi multiple, ceea ce ar permite eliminarea completă a caracterelor alfabetice de pe mâna cu mobilitate redusă, organizarea simbolurilor speciale pe straturi dedicate și optimizare separată pentru diferite contexte precum scriere text, programare sau comenzi sistem. Dezvoltarea unui sistem de profil utilizator ar putea colecta date de tastare reale pentru calibrare, ajusta automat coeficienții de penalizare bazat pe performanță observată, propune modificări incrementale ale layoutului pentru tranziție graduală și monitoriza metrici de confort pe termen lung. Extinderea modelului biomecanic ar include simularea oboselii cumulative pe parcursul sesiunilor lungi, integrarea datelor despre unghiurile naturale ale degetelor și încheieturilor, evaluarea riscului de leziuni repetitive bazat pe pattern-uri de mișcare și considerarea diferențelor anatomice individuale.

## 4.6 Limitări Generale și Direcții de Cercetare Viitoare

Analiza rezultatelor experimentale evidențiază mai multe limitări ale abordării curente și identifică direcții concrete pentru îmbunătățirea metodologiei în cercetări viitoare.

**Limitarea fundamentală a algoritmului: absența suportului pentru straturi multiple.** Implementarea actuală operează exclusiv pe un singur strat de caractere, ceea ce impune o constrângere severă asupra spațiului de soluții posibile. Această limitare are consecințe practice semnificative în scenarii cu restricții de mobilitate, deoarece caracterele rare și simbolurile speciale trebuie plasate pe taste fizice accesibile, chiar dacă acestea ar putea fi relocate pe straturi secundare accesibile prin taste modificatoare. În cazul configurat pentru mobilitate redusă a mâinii drepte, caracterele rare rămân pe tastele fizice ale mâinii cu mobilitate limitată, crescând distanța totală parcursă și timpul de tastare. Cu suport pentru straturi multiple, caracterele alfabetice standard ar putea fi concentrate complet pe mâna funcțională, iar caracterele rare și simbolurile speciale ar fi accesibile printr-o tastă modificatoare acționată de aceeași mână. Acest lucru ar permite eliminarea practic completă a utilizării mâinii cu mobilitate redusă pentru text alfabetic standard, producând îmbunătățiri substanțiale dincolo de cele 14% deja obținute. Straturile multiple ar permite, de asemenea, optimizări specializate pentru contexte diferite: un strat pentru scriere text, un strat pentru programare cu simboluri specifice {}[]<> în poziții ergonomice, și un strat pentru comenzi sistem.

Focalizarea exclusivă pe limba engleză reprezintă o restricție semnificativă. Layout-urile au fost optimizate pentru corpusuri în limba engleză, iar extinderea la alte limbi necesită colectarea de corpusuri reprezentative și adaptarea funcției de fitness pentru caractere diacritice și specificul ortografic. Pentru limba română, de exemplu, ar fi esențială integrarea suportului nativ pentru diacritice ă, â, î, ș, ț pe stratul principal, nu pe strat accesibil prin AltGr, reducând astfel apăsări multiple și îmbunătățind fluența tastării.

Validarea exclusiv prin simulare constituie o limitare majoră. Deși funcția de fitness combină distanța totală normalizată și timpul total normalizat cu formula 0.5 × distanță + 0.5 × timp, permitând extinderea cu parametri suplimentari menținând același obiectiv de minimizare, diferențele dintre predicțiile teoretice și performanța practică pot fi semnificative datorită factorilor psihologici și obișnuințelor motorii formate. Validarea empirică cu utilizatori reali ar necesita studii longitudinale pentru compararea predicțiilor cu performanța reală.

Dependența de corpus influențează puternic rezultatele. Un layout optim pentru Simple English Wikipedia poate să nu fie ideal pentru alte tipuri de text sau domenii de aplicare, subliniind importanța selectării unui corpus reprezentativ pentru cazul de utilizare țintă. Un programator care scrie predominant cod Python va beneficia de un layout optimizat pe corpus de cod sursă, care plasează simbolurile ()[]{}:= în poziții ergonomice, diferit de un layout optimizat pentru proză literară.

Modelarea simplificată a factorilor ergonomici constituie o altă limitare. Coeficienții de penalizare captează doar forța relativă a degetelor, dar nu modelează aspecte complexe precum oboseala acumulată pe parcursul sesiunilor lungi de tastare, poziția naturală a mâinilor și impactul devierilor de la poziția neutră, sau riscul de leziuni repetitive asociat cu mișcări specifice precum extensie excesivă, ulnar deviation, sau apăsări repetate cu același deget.

Direcții concrete de cercetare includ:

**Implementarea suportului pentru straturi multiple** prin extinderea reprezentării genotipului pentru a specifica nu doar caracterul pe o tastă, ci și stratul corespunzător, modificarea funcției de fitness pentru a penaliza schimbările de strat bazat pe frecvența tranziției între caractere, și optimizarea simultană a distribuției caracterelor pe straturi și a plasării tastelor de schimbare strat pentru minimizarea overhead-ului.

**Extinderea modelului biomecanic prin integrare de senzori** prin utilizarea senzorilor EMG electromyography pe degete, mâini și antebrațe pentru cuantificarea efortului real asociat cu apăsarea fiecărei taste, simularea oboselii cumulative folosind modele de depleție a resurselor musculare bazate pe măsurători directe, integrarea datelor despre unghiurile naturale ale degetelor și încheieturilor pentru penalizarea mișcărilor care necesită extensie sau deviere excesivă, evaluarea riscului de leziuni repetitive bazat pe pattern-uri de mișcare măsurate, și calibrarea coeficienților de penalizare pe baza diferențelor anatomice individuale precum lungime degete, flexibilitate, și forță musculară.

**Dezvoltarea de layout-uri adaptive** prin sisteme care învață din datele de tastare ale utilizatorului și propun modificări incrementale ale layoutului, ajustare automată a coeficienților de penalizare bazată pe performanță observată, și tranziție graduală prin layouturi intermediare pentru reducerea costului cognitiv al reantrenării.

Capitolul a prezentat implementarea practică a metodologiei, explorarea sistematică a spațiului de parametri prin 31 de rulări experimentale, și rezultatele pe setul de date Simple English Wikipedia. Analiza a identificat configurațiile optime ale algoritmului genetic reprezentând 300 indivizi × 50 iterații pentru calitate maximă și a confirmat că layout-urile generate oferă alternative superioare QWERTY cu îmbunătățire de 16%, cu îmbunătățiri marginale față de Colemak în configurația standard de 7%, dar cu beneficii semnificative în configurații personalizate de 14% față de Colemak pentru mobilitate asimetrică. Limitarea fundamentală reprezentată de absența suportului pentru straturi multiple restricționează sever spațiul de soluții și reprezintă direcția prioritară pentru cercetări viitoare. Adoptarea layout-urilor generate se justifică în scenarii cu restricții specifice de mobilitate unde personalizarea produce beneficii substanțiale; pentru utilizatori generali, Colemak rămâne o alegere solidă.
