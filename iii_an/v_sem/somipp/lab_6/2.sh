#!/bin/bash
# 2) Modificați script-ul din 1) pentru încă o singură executare peste 2 minute.
# Controlați conținutul fișierului ~/raport și afișați liniile noi apărute ( se
# recomanda – at, tail).

rm ~/test ~/raport -rf
./1.sh 2> /dev/null

tail -f ~/raport&

# sleep 2m
sleep 2
./1.sh 2> /dev/null

rm ~/test ~/raport -rf
