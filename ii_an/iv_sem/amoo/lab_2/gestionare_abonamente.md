@startuml
top to bottom direction
(Modificare abonament) .u.> (Gestionare abonamente) : <<extend>>
(Creaza abonament) ..> (Gestionare abonamente) : <<extend>>
(Sterge abonament) ..> (Gestionare abonamente) : <<extend>>
(Exporta abonamente) .u.> (Gestionare abonamente) : <<extend>>
(Incarca abonamente) .u.> (Gestionare abonamente) : <<extend>>
@enduml
