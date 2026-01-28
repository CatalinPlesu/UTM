#!/usr/bin/bash
echo "2) De la tastatură, ca parametri, script-ului se transmit trei numere întregi.
Afișați cel mai mare număr."

echo "Dati 3 numere intregi:"

read a b c

printf "Cel mai mare număr: "
if [ $a -gt $b ] && [ $a -gt $c ]
then 
    echo $a
elif [ $b -gt $a ] && [ $b -gt $c ]
then
    echo $b
else 
    echo $c
fi
