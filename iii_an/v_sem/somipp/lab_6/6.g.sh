#!/bin/bash
# 6) Procesul "Generator" citește liniile de la consolă până când va fi introdus
# TERM. În acest caz, acesta trimite un semnal de sistem SIGTERM procesului
# "Handler". Procesul "Handler" (ca în exemplul, ce afișează, în buclă
# infinită, un număr natural în fiecare secundă) trebuie să intercepteze
# semnalul de sistem SIGTERM și să finalizeze activitatea, afișând mesajul
# despre finalizarea activității cu primirea semnalului de la alt proces. 



while true; do 
    read LINE 
    if [ "$LINE" = "TERM" ]; then
        kill -SIGTERM $(ps -A | grep "6.h.sh" | awk '{print $1}')
        echo "killing the process"
    fi
    [ "$LINE" = "QUIT" ] && exit 0
done 
