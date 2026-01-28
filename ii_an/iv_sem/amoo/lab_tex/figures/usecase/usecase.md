<div align="center">

@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe uc Cazuri de utilizare Administrator 

actor Administrator
Administrator -l- (Efectueaza autentificare)
Administrator -u- (Gestionare abonamente)
Administrator -r- (Sterge utilizatr)
Administrator -u- (Gestionare carti)
Administrator -- (Cauta carte)
Administrator -- (Descarca carte)
@enduml

@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe uc Cazuri de utilizare Autor

actor Autor
Autor -l- (Efectueaza autentificare)
Autor -- (Gestionare carti)
Autor -- (Cauta carte)
Autor -- (Descarca carte)
@enduml

@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe uc Cazuri de utilizare Utilizator

actor Utilizator
Utilizator -l- (Efectueaza autentificare)
Utilizator -- (Cauta carte)
Utilizator -- (Descarca carte)
@enduml

@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe uc Cazuri de utilizare Gestionare carti

(Modificare carte) .u.> (Gestionare carti) : <<extend>>
(Incarcare carte) .u.> (Gestionare carti) : <<extend>>
(Sterge carte) .u.> (Gestionare carti) : <<extend>>

(Verifica permisiuni) <.u. (Sterge carte) : <<include>>
(Verifica permisiuni) <.u. (Modificare carte) : <<include>>
(Verifica permisiuni) <.u. (Incarcare carte) : <<include>>
@enduml

@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe uc Cazuri de utilizare Efectueaza autentificare

(Efectueaza înregistrare) .u.> (Efectueaza autentificare) : <<extend>>
(Efectueaza logare) .u.> (Efectueaza autentificare) : <<extend>>
(Reseteaza parola) .u.> (Efectueaza autentificare) : <<extend>>
(Efectueaza delogarea) .d.> (Efectueaza autentificare) : <<extend>>
@enduml

@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe uc Cazuri de utilizare Descarca carte

(Efectueaza autentificare) <.u. (Descarca carte) : <<include>>
(Verifica permisiuni) <.u. (Descarca carte) : <<include>>
(Cumpara carte) .r.> (Descarca carte) : <<extend>>
@enduml
</div>


@startuml
skin rose
skinparam shadowing false
top to bottom direction
mainframe uc Actori

actor Administrator
Administrator --|> UtilizatorDeBaza
Autor --|> UtilizatorDeBaza
Utilizator --|> Utilizator
@enduml
