<5

@startuml
skin rose
skinparam shadowing false
skinparam linestyle ortho
skinparam responseMessageBelowArrow true
mainframe sd Introducere carte

actor "<u>:Autor" as autor
rectangle "<u>:Pagina"as two
rectangle "<u>:ControlorCarte" as three
rectangle "<u>_carte:CarteLA" as four

autor -- two: 1: IntroducereCarte()\n<&arrow-bottom>
two -right- three: <&arrow-right> 2: POST(carte)
three -up- four: 3: CreazaCarte(carte)\n<&arrow-top>
four -- four: 4: Verifica(carte)\n<&arrow-top>

@enduml

@startuml
skin rose
skinparam shadowing false
skinparam linestyle ortho
skinparam responseMessageBelowArrow true
mainframe sd Modificare carte

actor "<u>:Autor" as autor
rectangle "<u>:Pagina"as two
rectangle "<u>:ControlorCarte" as three
rectangle "<u>_carte:CarteLA" as four

autor -- two: 1: ModificareCarte(id)\n<&arrow-bottom>
two -right- three: <&arrow-right> 2: PUT(carte)
three -up- four: 3: EditeazaCarte(carte)\n<&arrow-top>
four -- four: 4: Verifica(carte)\n<&arrow-top>

@enduml

@startuml
skin rose
skinparam shadowing false
skinparam linestyle ortho
skinparam responseMessageBelowArrow true
mainframe sd Stergere carte

actor "<u>:Autor" as autor
rectangle "<u>:Pagina"as two
rectangle "<u>:ControlorCarte" as three
rectangle "<u>_carte:CarteLA" as four

autor -- two: 1: StergeCarte(id)\n<&arrow-bottom>
two -right- three: <&arrow-right> 2: DELETE(id)
three -up- four: 3: StergeCarte(id)\n<&arrow-top>
four -- four: 4: Verifica(id)\n<&arrow-top>

@enduml

@startuml
skin rose
skinparam shadowing false
skinparam linestyle ortho
skinparam responseMessageBelowArrow true
mainframe sd Descarca carte

actor "<u>:Utilizator" as autor
rectangle "<u>:Pagina"as two
rectangle "<u>:ControlorCarte" as three
rectangle "<u>_carte:CarteLA" as four

autor -- two: 1: DescarcaCarte(id)\n<&arrow-bottom>
two -right- three: <&arrow-right> 2: GET(id)
three -up- four: 3: ObtineCarte(id)\n<&arrow-top>
four -- four: 4: Verifica(id)\n<&arrow-top>

@enduml

