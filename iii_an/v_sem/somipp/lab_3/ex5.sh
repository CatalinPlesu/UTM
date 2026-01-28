#!/usr/bin/bash
echo "5) Creați un meniu textual din patru elemente. La introducerea numărului
    elementului din meniu, va fi lansat editorul nano, editorul xed, browser-ul
    Firefox, sau ieșirea din meniu. "

echo "1 - nano
2 - xed
4 - firefox
8 - exit"

read option
case $option in 
    1)
        nano;;
    2)  
        xed;;
    4) 
        chromium;;
    8) 
        exit;;
    *)
        exit;;
esac
