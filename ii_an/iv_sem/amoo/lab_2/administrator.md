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
