#!/bin/sh
FILE=.communication

modul=adunare
calculat=1


(tail -n 0 -f $FILE) | while true; do 
    read LINE; 
    case $LINE in 
    "+")
        modul=adunare;;
    "'*'")
        modul=inmultire;;
    QUIT) 
        Echo "exit" 
        killall tail 
        exit 
    ;; 
    *) 
        echo "Text introdus'$LINE'"
        if echo $LINE | grep "[0-9]*" -q; then
            if [ $modul = "adunare" ]; then
                calculat=$(echo "${calculat} ${LINE}" | awk '{print $1 + $2}')
            elif [ $modul = "inmultire" ]; then
                calculat=$(echo "${calculat} ${LINE}" | awk '{print $1 * $2}')
            fi
        else
            echo valoare invalida
        fi

    ;; 
    esac 
    echo "modul: ${modul}"
    echo "valoarea curenta: ${calculat}"
    echo "introduceti simbol {+, *} sau un numar intreg"
done 
 
 
