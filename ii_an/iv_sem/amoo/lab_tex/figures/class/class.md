<5

@startuml
skin rose
skinparam shadowing false
skinparam classAttributeIconSize 0
hide circle
skinparam linetype polyline
'left to right direction
mainframe class Utilizator si carte

class Utilizator {
 + Id  : int 
 + numeUtilizator  : string 
 + parola  : string 
 + Email  : string 
 + primaLogare  : DateTime 
 + ultimaLogare  : DateTime 
 + ultimulIp  : string 
 + NivelAcces  : int 
 + librariePersonala : LibrariePersonala
 + cosProduse : CosProduse
}

class Recenzie {
 + idCarte : int
 + nota : int
 + comentariu : string
}


Utilizator *-u- "*" Recenzie


class Carte {
 + Id : int
 + titlu : string
 + autor : string
 + categorie : string
 + descriere : string
 + coperta : string
 + fisier : string
 + pret : float
 + nr_pagini : int
 + ISBN : string
 
}

class ContainerCarti {
 + nr_carti : int
 + valoare_totala : float
 + carti : Carte[]
}

class LibrariePersonala {
 + descarcaCarte() : Raspuns
}

class CosProduse {
- transferaCarti() : Raspuns
+ adaugaProdus() : Raspuns
+ eliminaProdus() : Raspuns
+ achitaProduse() : Raspuns
}

ContainerCarti o-l- "*" Carte 

LibrariePersonala -u-|> ContainerCarti
CosProduse -u-|> ContainerCarti


Utilizator  *-u-  CosProduse 
Utilizator  *-u-  LibrariePersonala

@enduml

@startuml
skin rose
skinparam shadowing false
skinparam classAttributeIconSize 0
hide circle
skinparam linetype polyline
mainframe class Modele aditionale


interface ISesiune <<interfata>>
interface ICarte <<interfata>>
ISesiune ..> DateLogare
ISesiune .l.> DateRegistrare
ISesiune ..> DateSetari
ISesiune .u.> Sesiune
ISesiune .r.> Raspuns
ICarte ..> DateCarte
ICarte .l.> Raspuns

class Sesiune {
 + Id  : int 
 + credential  : string 
 + cookie: string 
 + timpExpirare   : DateTime 
}

class DateLogare
    {
        + credential  : string 
        + parola  : string 
        + ultimulIp  : string 
        + timpDeLogare  : DateTime 
    }
    
class DateRegistrare
    {
        + email  : string 
        + numeUtilizator  : string 
        + parola1  : string 
        + parola2  : string 
        + ultimulIp  : string 
        + timpDeLogare  : DateTime 
    }
    
class DateSetari
    {
        + Id  : int 
        + email  : string 
        + numeUtilizator  : string 
        + parolaCurenta  : string 
        + parola1  : string 
        + parola2  : string 
    }
    
     class Raspuns
    {
        + status  : bool 
        + mesaj  : string 
    }
    
    class DateCarte
    {
        + Id  : int 
        + URL_Imagine  : string 
        + Titlu  : string 
        + Autor  : string 
        + Pret  : decimal 
    }

@enduml

@startuml
skin rose
skinparam shadowing false
skinparam classAttributeIconSize 0
hide circle
skinparam linetype polyline
'left to right direction
mainframe class Business Logic

class LogicaDeAfacere {

+ ObtineSesiuneLA(): ISesiune 
+ ObtineCarteLA(): ICarte 

}
LogicaDeAfacere ..> ISesiune
LogicaDeAfacere ..> ICarte

class SesiuneLA
SesiuneLA ..|> ISesiune
interface ISesiune <<interfata>> {
+ LogareUtilizator(DateLogare date): Raspuns 
+ RegistrareUtilizator(DateRegistrare date): Raspuns 
+ SchimbaDateUtilizator(DateSetari date): Raspuns 
+ CreazaCookie(DateLogare date): string 
+ ObtineUtilizatorDinCookie(string biscuit): UProfileData 
}

class CarteLA
CarteLA ..|> ICarte
interface ICarte <<interfata>> {

+ CreazaCarte(Carte carte): Raspuns 
+ EditeazaCarte(Carte carte): Raspuns 
+ ObtineListaCarti(): List<DateCarte>
+ ObtineCarte(int id): Carte 
+ StergeCarte(int id): Raspuns 
+ CautaCarte(string titlu): Carte 

}

@enduml

