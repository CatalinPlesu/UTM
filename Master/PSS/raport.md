
# Introducere

StoryMap este o aplicație destinată utilizării în timpul citirii sau scrierii lucrărilor de ficțiune și nu numai, care permite vizualizarea locurilor unde are loc acțiunea.
De asemenea, această aplicație are ca scop urmărirea unor atribute sau caracteristici ale personajelor, care ar putea fi trecute cu vederea pe parcursul desfășurării evenimentelo.
În viitor, se preconizează adăugarea funcționalității de a încorpora povestea într-o carte digitală, iar cititorul să poată extrage și vizualiza in aplicație.

# Șabloane de proiectare

În ingineria software, un șablon de proiectare este o soluție generală repetabilă la o problemă frecventă în proiectarea software. Un model de design nu este un design finit care poate fi transformat direct în cod. Este o descriere sau un șablon pentru rezolvarea unei probleme care poate fi folosită în multe situații diferite.

În general, utilizarea șabloanelor de proiectare este o practică bună, care ar trebui să facă codul mai sigur și mai ușor de modificat pe viitor. Însă, numărul de șabloane utilizate nu este o metrică bună pentru calitatea codului, iar utilizarea silită a acestora doar de dragul utilizării acestora, fără a rezolva probleme reale, cel mai probabil va duce la anti-șabloane.

Totuși, fiindcă acest proiect a avut ca scop utilizarea șabloanelor de proiectare iar proiectul în sine este irelevant, mai jos sunt enumerate șabloanele de proiectare utilizate și ce reprezintă acestea.

## Șabloane Creationale

- **[Singleton](https://refactoring.guru/design-patterns/singleton)**: Este utilizat pentru a ne asigura că o clasă are o singură instanță. Există două variații: *eager* cu instanțiere imediată și *lazy* cu instanțiere în funcție de necesitate.
- **[Builder](https://refactoring.guru/design-patterns/builder)**: Permite construirea obiectelor complexe pas cu pas pentru a evita un constructor cu mulți parametri.
- **[Prototype](https://refactoring.guru/design-patterns/prototype)**: Facilitează copierea obiectelor existente fără a face codul să depindă de clasele lor. O variație a acestui șablon include un registru unde sunt stocate obiecte pre-construite pentru a fi copiate.

## Șabloane Structurale

- **[Decorator](https://refactoring.guru/design-patterns/decorator)**: Permite să atașați noi comportamente la obiecte prin plasarea acestor obiecte în interiorul obiectelor speciale care conțin comportamentele.
- **[Facade](https://refactoring.guru/design-patterns/facade)**: Oferă o interfață simplificată la o bibliotecă, un cadru sau orice alt set complex de clase.
- **[Proxy](https://refactoring.guru/design-patterns/proxy)**: Permite substituirea unui substituent pentru alt obiect. Un proxy controlează accesul la obiectul original, permițându-vă să efectuați ceva înainte sau după ce solicitarea ajunge la obiectul original.

## Șabloane Comportamentale

- **[Observer](https://refactoring.guru/design-patterns/observer)**: Permite definirea unui mecanism de abonare pentru a notifica mai multe obiecte despre orice evenimente care au loc în obiectul pe care îl observă.
- **[State](https://refactoring.guru/design-patterns/state)**: Permite unui obiect să-și modifice comportamentul atunci când starea sa internă se schimbă. Obiectul își poate schimba starea internă în mod independent.
- **[Strategy](https://refactoring.guru/design-patterns/strategy)**: Permite definirea unei familii de algoritmi, prin punerea fiecărui algoritm într-o clasă separată, clasele date fiind interschimbabile.

# Implementarea

Proiectul este realizat cu în .NET Core. Proiectul a fost împărțit in 4 subproiecte, pentru a urma stilul arhitectural pe straturi:

- Domain
- Services
- Presentation
- Tests

Presentation este un proiect MVC însă după ce am înțeles cât de complicat este de implementat interfața grafică am adăugat la acesta și librăria [Mithril.js](https://mithril.js.org/) care simplifică crearea aplicației. Totodată din cauza complexității s-a renunțat la implementarea backend-ului pentru moment și efortul a fost utilizat doar pentru a avea o aplicație funcțională.

Există controlere doar pentru Home și Story, pe pagina de home este posibil de vizualizat și creat povești noi, iar pe pagina de Story este posibil de vizualizat sau editat aceste povești.

Fiind că timpul a fost limitat și am dorit ca aplicația să fie funcționlă toate șabloanele de proiectare care au fost implementate sunt pe partea de frontend.

[AppManager](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/AppManager/AppManager.js) este o clasă centrală în funcționarea aplicației, aceasta a fost implementată utilizând mai multe șabloane de proiectare. Acestea șabloane sunt:

- Singleton: pentru a avea doar o singură instanță a acestei clase.
- Facade: această clasă oferă o interfață simplificată și unificată pentru utilizarea restului claselor.

[StoryDataBuilder](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/Models/StoryData.js) este clasa de builder care permite crearea unui obiect StoryData utilizat în stocarea datelor.

[Character](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/Models/Character.js) este un model pentru personaj care are aplicat asupra lui șablonul prototype. Acesta a fost prevazut pentru utilizarea în două scenarii:

1. Copierea unui caracter de bază care este aplicată în cadrul tuturor creărilor de caracter.
2. Copierea unui caracter deja existent în aplicație.

Mentionez că copierea obiectelor nu este copletă, fiind că un caracter poate avea mai multe stări în evoluția acestuia, însă pentru copiere este selectată o singură stare de a fi copiată.

Șablonul decorator a fost utilizat pentru modificarea clasei AppManager, există două decoruri ale acestei clase:

- [HomePage](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/AppManager/Decorator/AppMagerHomePageDecorator.js) - în acest caz funcția **init()** va încărca poveștile din memorie.
- [StoryPage](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/AppManager/Decorator/AppManagerStoryPageDecorator.js) - în acest caz funcția **init()** va detecta dacă pagina este in mod de creare sau nu. Dacă este în mod de creare atunci ID-ul poveștii va fi curățat și vor fi utilizate atribute pentru caracterul de bază, în caz contrar va fi încărcată povestea din memorie conform ID-ului poveștii.

[StorageProxy](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/AppManager/StorageProxy/StorageProxy.js) este un proxy utilizat pentru selectarea strategiei de stocare a datelor, această clasă reprezintă o substituire pentru clasa [StrategyContext](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/AppManager/Strategy/StorageContext.js) care are următoarele metode:

- setStrategy()
- save()
- load()
- loadStories()

Fiind că backendul încă nu a fost finizat a fost implementată doar strategia de [IndexDbStrategy](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/AppManager/Strategy/IndexDbStrategy.js) care permite stocarea și citirea datelor prin baza API-ului oferit de browser IndexDB.

Fiind că în pringipiu pagina de /Story indiferent că este Home/Create/Edit afișează aceiași pagina cshtml, a fost utilizat șablonul State pentru a identifica ăn ce mod este aplicația în mai multe cazuri. Clasa de bază este [StoryModeContext](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/AppManager/State/StoryModeContext.js) care setează starea odată cu crearea clasei și oferă următoarele metode:

- get stateName()
- isCreateMode()
- isEditMode()
- isViewMode()

În ultimul rând a fost utilizat șablonul Observer. Componenta [Canvas](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/components/Canvas.js) este observerul care observă [StoryState](https://github.com/CatalinPlesu/StoryMap/blob/master/StoryMap.Presentation/wwwroot/js/AppManager/StoryState.js). Acest patern lucreză în paralel cu librăria Mithril așa cum aceasta tot notifică toate obiectele în caz de actualizări, însă problema este că dacă Canvas s-ar actualiza la fiecare schimbare vizual ar părea că elementele de pe canvas sunt șterse și create din nou fiind că actualizările sunt foarte frecvente, de aceia Canvas este notificat de schimbări și că ar trebui să actualizeze imaginile.

# Documentație

## Obținerea Software-ului

1. Descărcați ultima versiune de pe pagina de release pe [GitHub](https://github.com/CatalinPlesu/StoryMap/releases).
2. Lansați `StoryMap.Presentation.exe` (pe Linux, fără `.exe`).
3. Accesați aplicația la `http://localhost:5044/`.
4. Alternativ, clonați proiectul și rulați `dotnet run`.

## Utilizare


# Concluzii

