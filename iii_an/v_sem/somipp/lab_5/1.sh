#!/bin/bash

# 1) Aflaţi numărul de procese inițiaţializate de utilizatorul user și
# introduceți într-un fișier perechea „PID: comanda” a proceselor inițializate.
# Afișați conținutul acestui fișier şi numărul de procese. 

FILE=1tmpfile
# -l - long format
# -U - selecteaza procesele dupa numele real al utilizatorului
ps -lU catalin | awk '{print $4 ": " $14}' | sed '1d' > $FILE
cat $FILE
echo "Nr de procese: " $(wc -l $FILE | awk '{print $1}')
