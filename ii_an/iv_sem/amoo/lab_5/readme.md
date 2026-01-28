<5

@startuml
skinparam classAttributeIconSize 0
hide circle
skinparam linetype polyline
'left to right direction

class Utilizator {
 - email : string
 - nume : string
 - prenume : string
 - parola : string
 - librariePersonala : LibrariePersonala
 - cosProduse : CosProduse

 + registrare() : bool
 + autentificare() : bool
 + resetareParola() : bool
 + cautaCarte() : Carte[]
}

class Client {
- recenzii : Recenzie[]
}

class Autor {
 + incarcaCarte() : bool
 + modificaCarte() : bool
 + stergeCarte() : bool
}

class Administrator {
 + stergeUtilizator() : bool
}

class Recenzie {
 - ISBN_carte : string
 - nota : int
 - comentariu : string
 + afiseaza() : string
}

Client --|> Utilizator
Autor --|> Utilizator
Administrator --|> Utilizator
Administrator -l-|> Autor

Client "1" *-u- "0..*" Recenzie

@enduml

@startuml
skinparam classAttributeIconSize 0
hide circle
skinparam linetype polyline

class Carte {
 - ISBN : string
 - autor : string
 - titlu : string
 - categorie : string
 - coperta : string
 - pret : float
 - nr_pagini : int
 
 + creaza() : bool
 + actualizeaza() : bool
 + sterge() : bool
 + vizualizeazaInformatii() : void
}

class ContainerCarti {
 - nr_carti : int
 - valoare_totala : float
 - carti : Carte[]
}

class LibrariePersonala {
 + descarcaCarte() : bool
}

class CosProduse {
- transferaCarti() : bool
+ adaugaProdus() : bool
+ eliminaProdus() : bool
+ achitaProduse() : bool
}

ContainerCarti "1" o-l- "0..*" Carte 

LibrariePersonala -u-|> ContainerCarti
CosProduse -u-|> ContainerCarti


Utilizator "1" *-u- "1" CosProduse 
Utilizator "1" *-u- "1" LibrariePersonala

@enduml
