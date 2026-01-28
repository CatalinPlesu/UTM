#!/bin/bash
# 4) Creați două procese de fundal care efectuează același ciclu infinit de
# calcul (de exemplu, înmulțirea a două numere). După lansarea proceselor,
# prevedeți posibilitatea de a utiliza consolele virtuale din care au fost
# lansate. Folosind comanda top, analizați procentul de utilizare a
# microprocesorului de către aceste procese. Rezervați primului proces
# lansat o rată de utilizare a resurselor microprocesorului nu mai mare de
# 20% (se recomanda – nice, kill, cpulimit).

SCRIPT_NAME='_4.sh'

killall ${SCRIPT_NAME} 2> /dev/null

./${SCRIPT_NAME}&
PROC_PID=$(ps -A | grep $SCRIPT_NAME | awk '{print $1}')
cpulimit -p $PROC_PID -l 20&

./${SCRIPT_NAME}&
