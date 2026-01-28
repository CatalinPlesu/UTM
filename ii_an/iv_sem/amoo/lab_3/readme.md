2-3-5 diagrame de secventa

<div align="center">

Diagrama 1; 

@startuml
mainframe Stergere utilizator
skinparam sequenceMessageAlign center
hide footbox

actor Administrator as admin
participant "Pagina Web" as p1
participant Server as p2

activate admin
admin -> p1: Aceseaza lista utilizatori()
activate p1
p1 -> p2: Get(utilizatori)
activate p2
p2 -> p2: Verifica permisiuni(Admin)
p2 -->> p1: Returneaza raspuns()
deactivate p2
p1 -->> admin: Afiseaza raspuns()
deactivate p1

admin ->> p1: Selecteaza utilizator()
activate p1
deactivate p1
admin -> p1: Apasa stergere(utilizatorID)
activate p1
p1 -> p2: Delete(utilizatorID)
activate p2
p2 -> p2: Verifica permisiuni(Admin)
p2 -> p2: Delete(utilizatorID)
activate p2
deactivate p2
p2 -->> p1: Returneaza raspuns()
deactivate p2
p1 --> admin: Afiseaza raspuns()
@enduml

---

Diagrama 2; 

@startuml
mainframe Gestionare carti
skinparam sequenceMessageAlign center
hide footbox

actor Autor as autor
participant "Pagina Web" as p1
participant Server as p2
activate autor

autor ->> p1: Introduce carte()
activate p1
deactivate p1
autor ->> p1: Introduce informatii carte()
activate p1
deactivate p1
autor -> p1: Incarca carte()
activate p1
p1 -> p2: Post(carte)
activate p2
p2 -> p2: Verifica permisiuni(autor||administrator)
p2 -->> p1: Returneaza raspuns()
deactivate p2
p1 -->> autor: Afiseaza raspuns()
deactivate p1

autor ->> p1: Selecteaza carte()
activate p1
deactivate p1

autor -> p1: Apasa stergere(carteID)
activate p1
p1 -> p2: Delete(carteID)
activate p2
p2 -> p2: Verifica permisiuni(autorID||administrator)
p2 -> p2: Delete(carteID)
activate p2
deactivate p2
p2 -->> p1: Returneaza raspuns()
deactivate p2
p1 -->> autor: Afiseaza raspuns()
deactivate p1



autor ->> p1: Apasa editare(carteID)
activate p1
deactivate p1

autor ->> p1: Modifica date(carteID)
activate p1
deactivate p1

autor -> p1: Apasa 'salveaza modificari'(carteID)
activate p1
p1 -> p2: Update(carteID)
activate p2
p2 -> p2: Verifica permisiuni(autorID||administrator)
p2 -> p2: Update(carteID)
activate p2
deactivate p2
p2 -->> p1: Returneaza raspuns()
deactivate p2
p1 -->> autor: Afiseaza raspuns()
@enduml

---

Diagrama 3; 

@startuml
mainframe Descarcare carte
skinparam sequenceMessageAlign center
hide footbox

actor Utilizator as user
participant "Pagina Web" as p1
participant Server as p2
activate user

user ->> p1: Introduce titlu carte()
activate p1
deactivate p1

user -> p1: Cauta carte()
activate p1
p1 -> p2: Get(titlu)
activate p2
p2 -> p2: stringMatching(titlu)
p2 -->> p1: Returneaza raspuns()
deactivate p2
p1 -->> user: Afiseaza carti()
deactivate p1

user -> p1: Acceseaza carte(carteID)
activate p1
p1 -> p2: Get(carteID)
activate p2
p2 -> p2: returnCarte(carteID)
activate p2
deactivate p2
p2 -->> p1: Returneaza raspuns()
deactivate p2
p1 -->> user: Afiseaza raspuns()
user -> p1: Cumpara carte()
p1 -> p2: Post(carteID, userID)
activate p2
p2 -> p2: addToCart(carteID, userID)
activate p2
deactivate p2
p2 -->> p1: Cere informatie credit()
deactivate p2
p1 -->> user: Afiseaza pagina de procurare()
user -> p1: Introduce date card()
p1 -> p2: Post(cardSecrete)
activate p2
p2 -> p2: Extrage suma(cardSecrete, carteiD[pret])
activate p2
deactivate p2
p2 -->> p1: Returneaza raspuns()
deactivate p2
p1 -->> user: Afiseaza raspuns()
user -> p1: Descarca carte()
p1 -> p2: Get(carteID)
activate p2
p2 -> p2: VerificaPermisiune(userID, carteID)
p2 -->> p1: Returneaza raspuns()
deactivate p2
p1 -->> user: Afiseaza raspuns()
deactivate p1
deactivate user
@enduml
</div>

%% admin -> p1: Acceseaza pagina web()
%% activate p1
%% p1 -> p2: Get(index)
%% activate p2
%% p2 -->> p1: Returneaza pagina web()
%% deactivate p2
%% p1 -->> admin: Afiseaza pagina web()
%% deactivate p1

%% admin ->> p1: Introduce date autentificare()
%% activate p1
%% deactivate p1
%% admin -> p1: Apasa logare()
%% activate p1
%% p1 -> p2:  ValideazaUser(username, password)
%% activate p2
%% p2 -> p2: VerificaUtilizator()
%% p2 -->> p1: Returneaza raspuns()
%% deactivate p2
%% p1 -->> admin: Afiseaza raspuns()
%% deactivate p1



%% autor -> p1: Afiseaza carti detinute()
%% activate p1
%% p1 -> p2: Get(carti, autorID)
%% activate p2
%% p2 -> p2: Verifica permisiuni(autor||administrator)
%% p2 -> p2: Cauta carti(autorID||administrator)
%% activate p2
%% deactivate p2
%% p2 -->> p1: Returneaza raspuns()
%% deactivate p2
%% p1 -->> autor: Afiseaza raspuns()
%% deactivate p1

