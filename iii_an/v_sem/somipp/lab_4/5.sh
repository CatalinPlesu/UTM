#!/bin/bash

# 5) Găsiți în directorul /bin toate fișierele, ce reprezintă script-uri și
# afișați pe ecran numele interpretoarelor cu numărul ce indică frecvența lor
# de utilizare (în scripturi). Script-urile pot începe cu una din următoarele
# linii:

scripts="#!/bin/sh #!/bin/bash #!/usr/bin/perl #!/usr/bin/tcl"

for script in $scripts; do
    grep -rsa "^$script" /bin | wc -l | awk '{print "nr de scripturi de tipul XxX: "$1}' | sed -e "s|XxX|$script|"
done

