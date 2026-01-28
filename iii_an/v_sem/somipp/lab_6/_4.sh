#!/bin/bash
# 4) Creați două procese de fundal care efectuează același ciclu infinit de
# calcul (de exemplu, înmulțirea a două numere). După lansarea proceselor,

#fibonacci
first=0
second=1
while true; do
    third=$(($first+$second))
    first=$second
    second=$third
done
