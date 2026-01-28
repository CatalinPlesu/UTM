@startuml
skin rose
skinparam shadowing false
hide empty description
mainframe act Cautare carte si descarcare

start
:Căutarea cărții dorite;
if () then ([exista])
:Afișează rezultate asemanatoare;
:Selecteaza cartea dorita;
:Verifică daca cartea ii apartine;
  if () then ([true])
      :Descarcă cartea;
  else ([false])
  :Propune procurarea cartii;
      if () then ([true])
        :Cumpără cartea;
        else ([false])
    endif
  endif
else ([nuexista])
  :Afiseaza paina\nprincipala;
endif

stop
@enduml

@startuml
skin rose
skinparam shadowing false
hide empty description
mainframe act Verifica autorizatia

start
:Verifica cookies;
if () then ([exista])

    :Verifica utilizator;
    if () then ([autorizat])
      :Permite accesul;
    else ([neautorizat])
        :Redirectioneaza Eror404;
    endif

else ([nuexista])
:Redirectioneaza  Eror404;
endif

stop

@enduml
