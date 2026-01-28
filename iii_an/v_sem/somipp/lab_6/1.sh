#!/bin/bash
# 1) Creați și executați o singură dată script-ul (în acest script, nu puteți
# utiliza operatorul de condiție și operatorii de control a proprietăților și
# valorilor), care va încerca să creeze directorul test în directorul home.
# În cazul în care directorul va fi creat, script-ul va scrie în fișierul
# ~/raport un mesaj "catalog test was created successfully" şi va crea în
# directorul test un fișier numit Data_Ora_Lansarii_Scriptului. Apoi,
# indiferent de rezultatele etapei anterioare, script-ul trebuie să
# interogheze, folosind comanda ping, adresa www.traiasca_moldova.md și în
# cazul în care host-ul nu este disponibil, adăugați un mesaj de eroare în
# fișierul ~/raport (se recomanda - >,>>, ~, date, ||, &&).

FILE=$(date +"%d_%H")
mkdir ~/test 2> /dev/null && touch ~/test/"${FILE}" && echo "catalog test was created successfully" > ~/raport || echo "directoria 'test' exista"
ping www.traiasca_moldova.md || echo "host-ul nu este disponibil" >> ~/raport
# cat ~/raport

# rm ~/test ~/raport -rf
