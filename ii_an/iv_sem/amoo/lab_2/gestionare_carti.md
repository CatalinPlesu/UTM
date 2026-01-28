@startuml
top to bottom direction
(Modificare carte) .u.> (Gestionare carti) : <<extend>>
(Incarcare carte) .u.> (Gestionare carti) : <<extend>>
(Sterge carte) .u.> (Gestionare carti) : <<extend>>

(Verifica permisiuni) <.u. (Sterge carte) : <<include>>
(Verifica permisiuni) <.u. (Modificare carte) : <<include>>
(Verifica permisiuni) <.u. (Incarcare carte) : <<include>>
@enduml
