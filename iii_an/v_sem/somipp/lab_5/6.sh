#!/bin/bash

# 6) În fișierul obținut în 5, după fiecare grup de înregistrări cu același
# identificator al procesului părinte, introduceți o linie de tip
# Sum_switches_of_ParentID=N is M, unde N=PPID, iar M este suma calculată
# voluntary_ctxt_switches+ nonvoluntary_ctxt_switches din status pentru acest
# proces. Afișați conținutul acestui fișier.

FILE=6tmpfile
\cp 5tmpfile $FILE

cut -d ' ' -f 2 5tmpfile | uniq -c | sed 's/  / /g' > index_file

print_index=1

while read line; do
    repeats=$(echo $line | cut -d ' ' -f 1)
    ppid=$(echo $line | cut -d ' ' -f 2)
    print_index=$(($print_index+$repeats))

    voluntary_ctxt_switches=$(grep ^voluntary_ctxt_switches /proc/$ppid/status | awk '{print $2}')
    nonvoluntary_ctxt_switches=$(grep ^nonvoluntary_ctxt_switches /proc/$ppid/status | awk '{print $2}')
    if [ -z $voluntary_ctxt_switches ] || [ -z $nonvoluntary_ctxt_switches ]; then
        sum="can't be calculated"
    else
        sum=$((${voluntary_ctxt_switches} + ${nonvoluntary_ctxt_switches}))
    fi
    insert_line="Sum_switches_of_ParentID=${ppid} is ${sum}"
    if [ $print_index -lt $(wc -l $FILE | cut -d ' ' -f 1) ]; then
        awk -v n=$print_index -v s="$insert_line" 'NR == n {print s} {print}' $FILE > ${FILE}.tmp
        mv ${FILE}.tmp $FILE 
    else
        echo $insert_line >> $FILE
    fi
    print_index=$(($print_index+1))
done < index_file

cat $FILE
