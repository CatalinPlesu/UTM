#!/bin/bash

# 4) Pentru fiecare proces, calculați diferența dintre memoria totală (statm:
# size) şi rezidentă (statm: resident)  ale memoriei de proces (în pagini).
# Introduceți într-un fișier linii de tip „PID:diferența”, sortate în ordinea
# descrescătoare a acestor diferențe. Afișați conținutul acestui fișier. 

FILE=4tmpfile
echo "PID:diferența">$FILE
ps -eo pid,vsz,rss | sed '1d' | awk '{print  $1 ":" $2 - $3}' >> $FILE
cat $FILE

