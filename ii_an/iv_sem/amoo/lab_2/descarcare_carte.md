@startuml
top to bottom direction
(Autentificare) <.u. (Descarca carte) : <<include>>
(Verifica permisiuni) <.u. (Descarca carte) : <<include>>
(Cumpara carte) .r.> (Descarca carte) : <<extend>>
(Abonare) .l.> (Descarca carte) : <<extend>>
@enduml
