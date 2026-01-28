<5

@startuml
skinparam linestyle ortho
skinparam responseMessageBelowArrow true

actor ":Autor" as autor
rectangle "<u>page:AuthorView"as two
rectangle "<u>manage_books : \n<u>BookController" as three
rectangle "<u>book_db:Book" as four

autor -right- two: 1: IntroducereCarte() \n2: ModificareCarte()\n3: StergereCarte()\n<&arrow-right>

two -down- three: <&arrow-bottom> 4: Verificare()

three -left- four: 5: Actualizare()\n<&arrow-left>

@enduml
