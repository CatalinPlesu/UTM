#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal!" 
  exit 0
}

trap _term SIGTERM

while true; do 
    echo "1337"
    sleep 1
done 
 
 
