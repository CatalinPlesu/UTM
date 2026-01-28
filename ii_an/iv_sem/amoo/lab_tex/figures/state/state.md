@startuml
skin rose
skinparam shadowing false
'left to right direction
hide empty description
mainframe stm Logarea in sistem

state "Afisarea paginii\nde logare" as wait
state "Date introduse" as login
state "Validarea\ndatelor" as validate
state "Crearea cookie-lor" as cookie
state "Redare pagină\nprincipală" as home
state "Date invalide" as error
error: entry/ afisează mesaj eroare
error: exit/ redirectioneaza 

[*] --> wait
wait -r-> login : introducere\ndate autentificare
login --> validate : apăsare buton\nde autentificare
validate --> cookie : validează date\n[valid]
cookie --> home : genereaza cookie
validate --> error : validează date\n[invalid]
error --> wait : redirecționare\npagină logare
home --> [*] : redirectionare\npagina principala
wait --> home : apasa buton\npagina principala

@enduml

@startuml
skin rose
skinparam shadowing false
hide empty description
mainframe stm Creare carte

state "Afisarea paginii\nde creare carte" as create
state "Carte introdusă" as upload
state "Validarea\ndatelor" as validate
state "Accesarea \nBazei de date" as database
state "Redare pagină\nprincipală" as home
state "Date invalide" as error
error: entry/ afisează mesaj eroare
error: exit/ redirectioneaza 

[*] --> create
create -r-> upload : introducere\ndate carte
upload --> validate : apăsare buton\nde creare
validate --> database : validează date\n[valid]
database --> home : inserare in \nbaza de date
validate --> error : validează date\n[invalid]
error --> create : redirecționare\npagină creare
home --> [*] : redirecționare\npagină principală
create --> home : apasa buton\npagina principala

@enduml
