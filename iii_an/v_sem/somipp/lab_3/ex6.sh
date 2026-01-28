#!/usr/bin/bash
echo "6) Dacă scriptul este lansat din directorul Home, afișați calea spre
directorul Home și ieșiți cu codul 0. În caz contrar, ieșiți cu codul 1 și
afișați un mesaj de eroare."

# echo $PWD
# echo $HOME

if [ $PWD = $HOME ]; then
    # echo $HOME
    exit 0
else
    echo "trebuie executat din home directory"
    exit 1
fi
