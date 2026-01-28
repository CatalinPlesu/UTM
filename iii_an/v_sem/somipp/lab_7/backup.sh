#!/bin/bash
# 3) Script-ul backup.
# ▪ Script-ul va crea în /home/user/ directorul cu numele Backup-YYYYMM-DD,
# unde YYYY-MM-DD – data la care a fost rulat script-ul, dacă nu există
# nici un director în /home/user/ cu un nume care să corespundă unei date
# mai mici de 7 zile față de cea curentă. Dacă în /home/user/ este deja un
# director activ de backup (creat nu mai devreme de 7 zile de la data
# lansării script-ului), atunci nu se creează un nou director. Puteți
# utiliza comanda date pentru a determina data curentă.
VALID_DIR=''
WASNT_CREATED=true

day=$(date +%d)
month=$(date +%m)
year=$(date +%Y)
check_date() {
    difference=$(bc <<< "($year-$3)*365 + ($month-$2)*31 + ($day-$1)")
    if [ "$difference" -le "7" ]; then
        VALID_DIR=$4
        echo "VALID_DIR=$VALID_DIR" > save
    fi
}

HOME='.'
# .1 crearea directoriului
 today=$(date +%Y-%m-%d)
 \ls $HOME | grep "Backup-" | while read LINE; do
     wday=$(echo $LINE | cut -d '-' -f 4)
     wmonth=$(echo $LINE | cut -d '-' -f 3)
     wyear=$(echo $LINE | cut -d '-' -f 2)
     check_date $wday $wmonth $wyear $LINE
     if [ ! -z $VALID_DIR ]; then
         echo "Found valid dir '${VALID_DIR}'"
         break
     fi
 done

source save
 if [ -z $VALID_DIR ]; then
     echo "New backup directory created: 'Backup-${today}'"
     echo "'$HOME/Backup-${today}' created on $(date +%T-%D)" >> $HOME/backup-report
     mkdir "${HOME}/Backup-${today}"
     WASNT_CREATED=false
     echo "VALID_DIR=Backup-${today}" > save
 fi

# ▪ Dacă a fost creat un nou director, script-ul va copia în acest director
# toate fișierele din directorul /home/user/source/ (pentru testarea
# script-ului creați un director și un set de fișiere în el). După aceasta,
# script-ul va scrie următoarele informații în fișierul
# /home/user/backup-report: o linie cu informații despre crearea noului
# director cu copiile de rezervă cu indicarea numelui și datei creării
# acestuia; lista fișierelor din /home/user/source/ care au fost copiate în
# acest director.

#.2 copierea si raport
source save
if ! $WASNT_CREATED; then
    \ls $HOME/source | while read LINE; do
        cp $HOME/source/$LINE $HOME/$VALID_DIR/$LINE
        echo "'$HOME/source/$LINE' copyed to '$HOME/$VALID_DIR/$LINE' at $(date +%T)" >> $HOME/backup-report
    done
fi

# ▪ Dacă directorul nu a fost creat (există un director activ de backup),
# scriptul trebuie să copieze toate fișierele din /home/user/source/ în acest
# director folosind următoarele reguli: dacă nu există nici un fișier cu acest
# nume în directorul de backup, el este copiat din /home/user/source. Dacă
# există un fișier cu acest nume, dimensiunea acestuia este comparată cu
# dimensiunea fișierului cu același nume din directorul de backup curent. Dacă
# dimensiunile sunt egale, fișierul nu este copiat. Dacă dimensiunile sunt
# diferite, atunci fișierul este copiat cu crearea automată a copiei versiunii,
# astfel încât ambele versiuni ale fișierului să Lucrări de laborator SOMIPP
# apară în directorul curent de backup (fișierul existent este redenumit,
# adăugându-i-se o extensie suplimentară ".YYYY-MM-DD" (data la care scriptul a
# fost pornit), iar cel copiat își păstrează numele). După copiere, se scrie o
# linie în fișierul /home/user/backup-report despre efectuarea modificărilor în
# directorul curent de backup, cu indicarea numelui său și data efectuării
# modificărilor.
#.3
if $WASNT_CREATED; then
    echo "Active directory used: 'Backup-${today}'" >> $HOME/backup-report
    \ls $HOME/source | while read LINE; do
        if [ -f $HOME/$VALID_DIR/$LINE ]; then
            source_size=$(wc -c $HOME/source/$LINE | cut -d ' ' -f 1)
            backup_size=$(wc -c $HOME/$VALID_DIR/$LINE | cut -d ' ' -f 1)
            if [ $source_size -gt $backup_size ]; then
                cp $HOME/$VALID_DIR/$LINE $HOME/$VALID_DIR/${LINE}.$(date +%T_%d)
                cp $HOME/source/$LINE $HOME/$VALID_DIR/$LINE
                echo "'$HOME/$VALID_DIR/$LINE' renamed to '$HOME/$VALID_DIR/${LINE}.$(date +%T_d)' at $(date +%T)" >> $HOME/backup-report
                echo "$HOME/source/$LINE' copyed to '$HOME/$VALID_DIR/$LINE' at $(date +%T)" >> $HOME/backup-report
            fi
        else
            cp $HOME/source/$LINE $HOME/$VALID_DIR/$LINE
            echo "'$HOME/source/$LINE' copyed to '$HOME/$VALID_DIR/$LINE' at $(date +%T)" >> $HOME/backup-report
        fi
    done
fi


rm save
