#!/bin/bash
# 2) Script-ul untrash.
# ▪ Script-ului i se transmite un parametru - numele fișierului care
# urmează să fie restabilit (fără calea completă - numai numele).
# ▪ Script-ul în fișierul trash.log găsește toate înregistrările ce conțin nume
# de fișiere ce vor fi ca parametri pentru script și va afișa aceste nume de
# fișiere câte unul, cu o cerere de confirmare.
# ▪ Dacă utilizatorul acceptă cererea, se execută o încercare de a restabili
# fișierul cu calea completă specificată anterior (creați un link hard în
# directorul corespunzător către fișierul din trash și ștergeți fișierul
# corespunzător din trash). Dacă directorul specificat în calea completă către
# fișier nu mai există, fișierul este restabilit în directorul home/user al
# utilizatorului cu afișarea mesajului corespunzător.

counter=0

cp ~/.trash.log ~/.trash.log.tmp

#1 daca i se transmite un parametru
if [ ! -z "$1" ]; then
     # Internal Field Separator
    while IFS= read -r LINE <&3; do

        echo $LINE
        echo "Doriti sa restabiliti fisierul dat (d/N)" 
        # this reads from fd 0 (stdin)
        read danu

        if [ $danu = 'd' ] || [ $danu = 'D' ]; then
            #3 restabilim
            origin=$(echo $LINE | cut -d '#' -f 3)
            destination_file=$(echo $LINE | cut -d '#' -f 2)
            destination_dir=$(echo $destination_file | cut -d '#' -f 2 | awk 'BEGIN{FS=OFS="/"}NF--')
            if [ -d $destination_dir ]; then
                ln ~/.trash/$origin $destination_file$counter
                rm ~/.trash/$origin
                echo "fisier restabilit cu succes"
            else
                ln ~/.trash/$origin $HOME/$1$counter
                rm ~/.trash/$origin
                echo "fisierul a putut fi restabilit in $HOME"
            fi
            counter=$(($counter+1))
            grep -v "$origin" ~/.trash.log.tmp > tmpfile
            mv tmpfile ~/.trash.log.tmp 
        fi

    #2 gasim toate inregistrarile
    done 3< <( grep "/${1}#" ~/.trash.log )
fi

mv ~/.trash.log.tmp ~/.trash.log
