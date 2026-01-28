#!/bin/bash

# 2) Afișați PID-ul procesului, ultimul lansat (cu timpul de lansare).  

FILE=2tmpfile

ps -eo pid,lstart,comm > $FILE
lastButOne=$(wc -l $FILE | awk '{print $1}')
lastButOne=$(($lastButOne))
awk 'NR==1{print $0}' $FILE
awk -v line=$lastButOne 'NR==line{print $0}' $FILE
