#!/bin/bash

rm -rf .~lock*
rm -rf raport.md
touch raport.md

cat rezumat.md >> raport.md
printf "\n\n\n" >> raport.md

cat abstract.md >> raport.md
printf "\n\n\n" >> raport.md

cat introduction.md >> raport.md
printf "\n\n\n" >> raport.md

cat chapter1.claude.md >> raport.md
printf "\n\n\n" >> raport.md

cat chapter2.claude.md >> raport.md
printf "\n\n\n" >> raport.md

cat chapter3.md >> raport.md
printf "\n\n\n" >> raport.md

cat chapter4.md >> raport.md
printf "\n\n\n" >> raport.md

cat conclusion.md >> raport.md
printf "\n\n\n" >> raport.md

pandoc raport.md -o raport.odt --variable lang=ro --wrap=none

# Așteaptă ca pandoc să termine
wait

libreoffice raport.odt
