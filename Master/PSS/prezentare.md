---
marp: true
theme: default
paginate: true
size: 16:9
---

# Raport: Proiectul StoryMap
Universitatea Tehnică a Moldovei  
Facultatea Calculatoare, Informatică şi Microelectronică  

A efectuat: Pleșu Cătalin TI-241M  
A verificat: lect. univ. Andrei Poștaru  
A verificat: aist. univ. Valentina Astafi  

**Chișinău 2025**

---

# Introducere

StoryMap este o aplicație destinată utilizării în timpul citirii sau scrierii lucrărilor de ficțiune și nu numai, care permite vizualizarea locurilor unde are loc acțiunea. 

De asemenea, această aplicație urmărește atributele sau caracteristicile personajelor, care ar putea fi trecute cu vederea pe parcursul desfășurării evenimentelor. 

În viitor, se preconizează adăugarea funcționalității de a încorpora povestea într-o carte digitală, iar cititorul să poată extrage și vizualiza informațiile în aplicație.

---

# Șabloane Creationale

- **Singleton**: Asigură că o clasă are o singură instanță.
- **Builder**: Permite construirea obiectelor complexe pas cu pas.
- **Prototype**: Permite copierea obiectelor existente fără a depinde de clasele lor.

---

# Șabloane Structurale

- **Decorator**: Permite atașarea de noi comportamente la obiecte.
- **Facade**: Oferă o interfață simplificată pentru biblioteci sau cadre complexe.
- **Proxy**: Permite substituirea unui obiect pentru altul și controlează accesul la obiectul original.

---

# Șabloane Comportamentale

- **Observer**: Permite notificarea obiectelor despre evenimentele ce au loc într-un alt obiect.
- **State**: Permite unui obiect să își schimbe comportamentul în funcție de starea sa internă.
- **Strategy**: Permite definirea unei familii de algoritmi interschimbabili.

---

# Implementarea

Proiectul este realizat în .NET Core și împărțit în 4 subproiecte:

- Domain
- Services
- Presentation
- Tests

Interfața a fost realizată folosind Mithril.js și este gestionată de un controler principal.

---

# Exemple de Implementare

- **AppManager**: Clasă centrală, implementată cu șabloane Singleton și Facade.
- **StoryDataBuilder**: Builder pentru crearea unui obiect `StoryData`.
- **Character**: Model pentru personaj, cu șablonul Prototype.
- **StorageProxy**: Proxy pentru alegerea strategiei de stocare a datelor.

---

# Documentație - Instalare

Obținerea Software-ului:

1. Descărcați ultima versiune de pe GitHub.
2. Lansați `StoryMap.Presentation.exe` (pe Linux fără `.exe`).
3. Accesați aplicația la `http://localhost:5044/`.
4. Alternativ, clonați proiectul și rulați `dotnet run`.

---

# Documentație - Utilizare

- Aplicația este găzduită la `http://localhost:5044/`
- Pagina principală permite crearea de povești noi
- Caracteristici principale:
  - Adăugarea de hărți
  - Încărcarea de imagini
  - Crearea de caractere
  - Modificarea caracterelor în funcție de timeframe-uri

---

# Concluzii

- Proiectul a atins obiectivele stabilite
- Utilizarea șabloanelor de proiectare a fost demonstrată
- Aplicația este funcțională și poate fi inclusă în CV
- Observație: utilizarea excesivă a șabloanelor nu este întotdeauna necesară (KISS)
