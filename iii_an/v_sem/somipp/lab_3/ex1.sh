#!/usr/bin/bash
echo "1) De la tastatură, ca parametri, script-ului se transmit două șiruri de
caractere. Afișați un mesaj despre egalitatea sau inegalitatea șirurilor
introduse."

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Introduceți șirul 1"
read str1 
echo "Introduceți șirul 2"
read str2 

echo $str1 
echo $str2

if [ "$str1" = "$str2" ]
then
    printf "${GREEN}Aceleași șiruri"
else
    printf "${RED}Șirurile sunt diferite"
fi
printf "$NC"
