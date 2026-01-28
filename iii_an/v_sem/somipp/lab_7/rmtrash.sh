#!/bin/sh
# 1) Script-ul rmtrash. 
# ▪ Script-ului i se transmite un parametru - numele fișierului ce va fi creat
# în directorul curent (lab7).
# ▪ Script-ul verifică dacă a fost creat un director ascuns trash în directorul
# home/user ($HOME) al utilizatorului. Dacă nu este creat, îl creează.
# ▪ Apoi, în directorul curent, script-ul creează un fişier cu numele
# parametrului. Creează şi un hard link către fișierul creat şi directorul
# ascuns trash, cu un nume unic ce constă din cifre (utilizaţi (date +%s)) și
# șterge fișierul din directorul curent.
# ▪ Apoi, în fișierul ascuns trash.log din directorul home/user al
# utilizatorului este plasată o linie care conține calea completă a fișierului
# șters și numele link-ului hard creat.

#1 crearea fisierului
if [ ! -z "$1" ]; then
    echo "file: '${1}' was created"
    touch $1
fi

#2 verificarea si crearea directoriului trash
if [ ! -d ~/.trash ]; then
    echo "trash didn't existed"
    mkdir ~/.trash
fi

#3 crearea hardlinkului
if [ ! -z "$1" ]; then
    link_name=$(date +%s)
    ln "$1" ~/.trash/$link_name
    echo "hard link was created"
    rm -f $1
fi

#4 log
if [ ! -z "$1" ]; then
    message="$(date +%T_%D)#$(pwd)/${1}#${link_name}" 
    if [ ! -f ~/.trash.log ]; then
        echo $message > ~/.trash.log
    else
        echo $message >> ~/.trash.log
    fi
fi
