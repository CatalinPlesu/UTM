3
@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe cmp Structura sistemului Book Mall


component EntityFramework  {
}
EntityFramework -- IEntityFramework
BookMall.LogicaDeAfacere -u-( IEntityFramework
component BookMallDB <<bazadedate>>
interface " " as x
EntityFramework -r-( x
x -- BookMallDB  

component BookMall.Web {
}

component BookMall.Modele {
}
component BookMall.Ajutor {
}

component BookMall.LogicaDeAfacere {
}

BookMall.LogicaDeAfacere .u.> BookMall.Modele
BookMall.LogicaDeAfacere ..> BookMall.Ajutor


BookMall.LogicaDeAfacere -l- ICarte 
BookMall.LogicaDeAfacere -d- ISesiune  
BookMall.Web -r-( ICarte  
BookMall.Web -r-( ISesiune  

BookMall.Web ..> BookMall.Ajutor

@enduml



@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe cmp Accesarea paginilor de catre utilizator
skinparam classAttributeIconSize 0
hide circle
skinparam linetype polyline
hide empty members

interface "Pagina Logare" <<interfata>> as login
interface "Pagina Registrare" <<interfata>> as register
interface "Pagina Principala" <<interfata>> as home
interface "Pagina Cos" <<interfata>> as cart

component "Site Web" as web
web ..|> login
web ..|> register
web ..|> home
web ..|> cart

component Utilizator
login <.. Utilizator
register <.. Utilizator
home <.. Utilizator
cart    <.. Utilizator

component Server

web .u.> Server

@enduml


@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe cmp Accesarea paginilor de catre administrator
skinparam classAttributeIconSize 0
hide circle
skinparam linetype polyline
hide empty members

interface "Pagina Logare"  <<interfata>> as login
interface "Pagina Principala"  <<interfata>> as home
interface "Pagina Creare Carte"  <<interfata>> as create
interface "Pagina Editare Carte"  <<interfata>> as edit

component "Site Web" as web
web ..|> login
web ..|> home
web ..|> create
web ..|> edit

component Administrator
login <.. Administrator
home <.. Administrator
create <.. Administrator
edit <.. Administrator

component Server

web .u.> Server

@enduml
