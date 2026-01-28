1
@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe dep Amplasarea serviciului

node "Server Web" as Web {
component "Windows Serevr OS" as win
component "Microsoft IIS" as iis
component "Serviciul BookMall" as bm
bm ..> iis
iis ..> win
}

node "Serverul Bazei de date" as Db {
component BookMallDB <<bazadedate>>
component "Ms Sql Server" as sql
BookMallDB ..> sql
} 

node "Dispozitiv Utilizator" <<device>> as User {

component "Web Browser" as browser
component "Web Browser" as browser
component "Pagina web" as page
browser <.. page

}

Web -l- "*" User: <<TCP/IP>>
Web -r- Db: <<TCP/IP>>
Web -[hidden]- User

@enduml
