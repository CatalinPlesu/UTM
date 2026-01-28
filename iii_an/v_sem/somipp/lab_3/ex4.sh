#!/usr/bin/bash
echo "4) Introduceți numere întregi de la tastatură, ultimul caracter introdus
- un număr par. Afișați numărul de cifre introduse. "



echo "introduceti numere întregi: "

numbers=""
char="x"
IFS=''
while true; do
    read -n1 char 
    if (echo ' 0123456789' | grep -q $char); then
        if (echo '02468' | grep -q $char); then
            numbers="${numbers}${char}"
            printf "\n$numbers"
            break
        fi
        numbers="${numbers}${char}"
    fi
done

count=0
for number in $numbers
do
    for (( digit=0; digit<${#number}; digit++ )); do
        if (echo '0123456789' | grep -q ${number:$digit:1}); then
          count=$((count+1))
        fi
    done
done
printf "\nNumarul de cifre $count"

