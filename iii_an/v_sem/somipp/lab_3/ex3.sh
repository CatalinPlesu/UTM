#!/usr/bin/bash
echo "3) De la  tastatură introduceți caractere până când este introdus caracterul
    'q'. Imprimați șirul introdus pe o singură  linie. "

echo "Introduceți șirul:"

IFS=''

string=""
char="x"
while read -n1 char  && [ $char != "q" ]; do
    string="${string}${char}"
done

printf "\nșirul introdus: $string"
