#!/bin/bash
echo '[DOCTOR] Diagnostica xZDOS_AOA'
echo '[CHECK] Verifica directory...'
for d in panels config src scripts; do
    if [ -d "$d" ]; then
        echo '[OK]' $d
    else
        echo '[WARN]' $d 'mancante'
    fi
done
echo '[DONE] Diagnostica completata'

