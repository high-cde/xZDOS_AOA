#!/bin/bash
echo '[VALIDATOR] Validazione struttura xZDOS_AOA'
if [ -f scripts/xzdos_aoa_master.sh ]; then
    echo '[OK] Master script presente'
else
    echo '[ERROR] Master script mancante'
fi
echo '[DONE] Validazione completata'

