#!/bin/bash

# 1) Creați fișierul errors.log, în care veți plasa toate liniile din toate
# fișierele directorului /var/log/ accesibile pentru citire, care conțin
# secvența de caractere ACPI. Afișați pe ecran liniile din errors.log, care
# conțin numele fișierelor, excluzând calea acestor fișiere.

FILE=errors.log

grep -rsI ACPI /var/log > $FILE
sed 's/\/var\/log\///g' $FILE 
