#!/bin/bash

# 3) Creați fișierul full.log, în care veți plasa liniile dinfișierul
# /var/log/Xorg.0.log, care conținavertizări și mesaje informaționale, înlocuind
# marcheriiavertizărilor (WW) și mesajelor informaționale (II) cucuvintele
# Warning: și Information:, astfel încât înfișierul rezultat mai întâi să apară
# toate mesajeleinformaționale, iar apoi toate avertizările. Afișațiconținutul
# fișierului full.log pe ecran.

FILE_NAME=full.log
rm $FILE_NAME
touch $FILE_NAME
grep -E '(WW)|(II)' /var/log/Xorg.0.log > $FILE_NAME
sed -i 's/(WW)/Warning/g' $FILE_NAME
sed -i 's/(II)/Information/g' $FILE_NAME
sed -i '1,2d' $FILE_NAME
sort -k3 $FILE_NAME -o $FILE_NAME
bat $FILE_NAME
