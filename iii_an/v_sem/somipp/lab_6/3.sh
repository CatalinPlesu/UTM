#!/bin/bash
# 3) Modificați script-ul din 1) ca să ruleze la fiecare 5 minute din oră, în
# zilele pare ale săptămânii.
echo "*/5 * 2-30/2 * * ${PWD}/1.sh" | crontab
