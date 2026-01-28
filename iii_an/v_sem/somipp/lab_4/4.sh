#!/bin/bash

# 4) Creați fișierul emails.lst, în care veți plasa toate adresele de poștă
# electronică, depistate în fișierele directorului /etc. Adresele vor urma
# consecutiv, separate prin virgulă. Afișați conținutul fișierului emails.lst
# pe ecran.

FILE=emails.lst
grep -IEiorhs '([[:alnum:]_.-]+@[[:alnum:]_.-]+?\.[[:alpha:].]{2,6})' /etc > $FILE
sed -i 's/$/,/' $FILE 
sed -i '$s/,$//' $FILE 
bat $FILE
