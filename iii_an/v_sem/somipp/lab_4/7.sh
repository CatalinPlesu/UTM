#!/bin/bash

# 7) Afișați 5 cel mai frecvent întâlnite cuvinte din man bash cu lungimea de
# cel puțin 3 caractere.

man bash > bash_man
sed -e 's/\s/\n/g' bash_man | grep '[[:alnum:]]\{3,\}' | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr | head -3
rm bash_man
