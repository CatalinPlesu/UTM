#!/bin/bash
# 7) Procesul "Generator" citește linii de la consolă în buclă infinită. Dacă
# linia citită conține un singur caracter "+", procesul "Generator" trimite
# procesului "Handler" un semnal USR1. Dacă linia conține un singur
# caracter "*", "Generator" trimite procesului "Handler" semnalul USR2.
# Dacă șirul conține cuvântul TERM, "Generator" trimite un semnal SIGTERM
# procesului "Handler". Alte valori ale liniilor sunt ignorate. Procesul
# "Handler" adună 2 sau multiplică cu 2 valoarea curentă a numărului
# procesat (valoarea inițială este 1) în funcție de semnalul primit de la
# utilizator și afișează rezultatul pe ecran. Calcularea și afișirea sunt
# efectuate o dată pe secundă. Primind semnalul SIGTERM, "Handler" își
# finalizează Lucrări de laborator SOMIPP activitatea și afișează mesajul
# despre finalizarea activității cu primirea semnalului de la alt proces.

h_pid=$(ps -A | grep "7.h.sh" | awk '{print $1}')
while true; do 
    read LINE 
    if echo $LINE | grep '1.sh' -q; then
        LINE="'*'"
        kill -USR2 $h_pid
    fi
    case $LINE in
        '+') kill -USR1 $h_pid;;
        'QUIT') exit 0;;
        'TERM')  kill -SIGTERM $h_pid;;
    esac
done 

