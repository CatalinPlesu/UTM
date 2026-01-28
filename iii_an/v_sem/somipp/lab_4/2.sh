#!/bin/bash

# 2) Calculați numărul total de linii în fișierele directorului /var/log/ cu
# extensia log. Afișați acest număr pe ecran.

wc -l /var/log/*log | tail -n1 | awk '{print "numarul total de linii: "$1}'
