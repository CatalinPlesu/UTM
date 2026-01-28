#!/bin/bash

# 5) Pentru toate procesele înregistrate, la moment, în sistem, introduceți
# într-un fişier linii de tip ProcessID=PID:Parent_ProcessID=PPID:
# Average_Time=avg_atom Preluați valorile PPID și PID din fișierele status,
# valoarea avg_atom (avg_atom=se.sum_exec_runtime/nr_switches) Lucrări de
# laborator SOMIPP 71 din fișierele sched care se află în subdirectoarele, cu
# nume ce corespund PID proceselor în directorul /proc. Sortați aceste linii
# conform identificatorilor proceselor părinte. Rezultatul sortării
# introduceți într-un fișier și afișați-l.

FILE=5tmpfile

> $FILE
# echo "ProcessID=PID:Parent_ProcessID=PPID:Average_Time=avg_atom" >> $FILE

for process  in $(\ls /proc | grep "[0-9]*" -w); do
    if ! sudo cp /proc/$process/status localstatus ; then
        >&2 echo "process terminated befor reading files"
        continue
    fi
    if ! sudo cp /proc/$process/sched localsched ; then
        >&2 echo "process terminated befor reading files"
        continue
    fi

    pid=$(grep ^Pid: localstatus | cut -f 2)
    ppid=$(grep ^PPid: localstatus| cut -f 2)
    sum=$(grep se.sum_exec_runtime localsched | sed 's/ //g' | cut -d ':' -f 2)
    switch=$(grep nr_switches localsched | sed 's/ //g' | cut -d ':' -f 2)
    avg_atom=$(echo "print $sum/$switch" | perl)
    echo "ProcessID=${pid}:Parent_ProcessID= ${ppid} :Average_Time=${avg_atom}" >> $FILE
done
\rm localstatus localsched -f

sort -k2n $FILE -o $FILE
echo "ProcessID=PID:Parent_ProcessID=PPID:Average_Time=avg_atom"
cat $FILE
