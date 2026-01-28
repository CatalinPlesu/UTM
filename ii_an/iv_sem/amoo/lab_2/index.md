<div align="center">

@startuml
top to bottom direction
actor Administrator
Administrator -l- (Autentificare)
Administrator -u- (Gestionare abonamente)
Administrator -r- (Sterge utilizatroi)
Administrator -u- (Gestionare carti)
Administrator -- (Cauta carte)
Administrator -- (Descarca carte)
@enduml

@startuml
top to bottom direction
actor Autor
Autor -l- (Autentificare)
Autor -- (Gestionare carti)
Autor -- (Cauta carte)
Autor -- (Descarca carte)
@enduml

@startuml
top to bottom direction
actor Utilizator
Utilizator -l- (Autentificare)
Utilizator -- (Cauta carte)
Utilizator -- (Descarca carte)
@enduml

@startuml
top to bottom direction
(Modificare carte) .u.> (Gestionare carti) : <<extend>>
(Incarcare carte) .u.> (Gestionare carti) : <<extend>>
(Sterge carte) .u.> (Gestionare carti) : <<extend>>

(Verifica permisiuni) <.u. (Sterge carte) : <<include>>
(Verifica permisiuni) <.u. (Modificare carte) : <<include>>
(Verifica permisiuni) <.u. (Incarcare carte) : <<include>>
@enduml

@startuml
top to bottom direction
(Regeistrare) .u.> (Autentificare) : <<extend>>
(Logare) .u.> (Autentificare) : <<extend>>
(Reseteaza parola) .u.> (Autentificare) : <<extend>>
@enduml

@startuml
top to bottom direction
(Autentificare) <.u. (Descarca carte) : <<include>>
(Verifica permisiuni) <.u. (Descarca carte) : <<include>>
(Cumpara carte) .r.> (Descarca carte) : <<extend>>
@enduml
</div>
