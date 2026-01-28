#!/bin/bash
initial=1
update=true

_usr1() {
    initial=$(($initial+2))
    echo "numarul curent este: '${initial}'"
}

_usr2() {
    initial=$(($initial*2))
    echo "numarul curent este: '${initial}'"
}

_sigterm() { 
  echo "Caught SIGTERM signal!" 
  exit 0
}
trap _sigterm SIGTERM
trap _usr1 USR1
trap _usr2 USR2

while true; do 
    sleep 1
done 
 
 
