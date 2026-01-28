#!/bin/bash
# 4) Script-ul upback. Scriptul trebuie să copieze în directorul
# /home/user/restore/ toate fișierele din directorul de backup (care are
# cea mai recentă dată în nume), cu excepția fișierelor cu versiunile
# anterioare.


HOME='.'
BACKUP_NAME=`\ls --sort=time -r | grep Backup | head -n1`

test -d source || mkdir source
echo "'$BACKUP_NAME'"
\ls $HOME/$BACKUP_NAME/ | grep -v -E '\.[0-9]{2}:[0-9]{2}:[0-9]{2}_.'| while read LINE; do
echo $LINE
    cp $HOME/$BACKUP_NAME/$LINE  $HOME/source/$LINE 
    echo "'$HOME/$BACKUP_NAME/$LINE' restored to '$HOME/source/$LINE'"
done
