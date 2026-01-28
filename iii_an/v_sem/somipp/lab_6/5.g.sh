#!/bin/sh
# 5) Procesul "Generator" transmite informații procesului "Handler" utilizând un
# fișier ascuns. Procesul "Handler" trebuie să efectueze următoarele
# procesări asupra liniilor noi în acest fișier: dacă linia conține un singur
# caracter "+", procesul "Handler" comută modul în adunare și așteaptă
# introducerea datelor numerice. Dacă Lucrări de laborator SOMIPP șirul
# conține un singur caracter "*", atunci procesul "Handler" comută modul în
# înmulțire și așteaptă introducerea datelor numerice. În cazul când linia
# conține un întreg, atunci procesul "Handler" execută operația curentă
# activă (modul activ curent) asupra valorii variabilei calculate (curente)
# și valoarea recent introdusă (de exemplu, adună sau înmulțește rezultatul
# calculat anterior cu numărul recent introdus). Când lansați script-ul,
# modul se va seta în adunare, iar variabila calculată – în 1. Dacă este
# primit QUIT, script-ul afișează un mesaj despre finalizare și finalizează
# activitatea. Dacă sunt primite alte valori, scriptul finalizează
# activitatea cu un mesaj de eroare - date de intrare eronate. 

FILE=.communication
> $FILE 

while true; do 
    read LINE 
    if echo $LINE | grep '1.sh' -q; then
        LINE="'*'"
    fi
    echo $LINE >> $FILE
    [ "$LINE" = "QUIT" ] && exit 0
done 
