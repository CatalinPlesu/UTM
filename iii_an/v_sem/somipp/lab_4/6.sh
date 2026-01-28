#!/bin/bash

# 6) Afișați lista utilizatorilor sistemului cu indicarea UID alfiecăruia, cu
# sortarea după UID. Informațiile despreutilizatori sunt păstrate în fișierul
# /etc/passwd. Înfiecare linie a acestui fișier primul câmp conține
# numeleutilizatorului, iar câmpul al treilea - UID, separatorul –două puncte
# (:). 

cut -d ':' -f1,3 /etc/passwd | sort -t ':' -k2n 
