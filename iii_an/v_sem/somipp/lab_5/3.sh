#!/bin/bash

# 3) Introduceți într-un fișier o listă cu PID-urile proceselor,  pornite cu
# comenzile localizate în /sbin/. Afișați conținutul acest fișier. 

FILE=3tmpfile

# -A - select all processes
# -F - Extra full format
ps -A -F | grep -v 'grep ' | grep 'sbin/' | awk '{print $2}' > $FILE
cat $FILE
