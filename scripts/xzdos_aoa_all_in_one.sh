#!/bin/bash
echo '[ALL-IN-ONE] Installazione completa xZDOS_AOA'
bash scripts/xzdos_aoa_install.sh
bash scripts/xzdos_aoa_sync.sh
bash scripts/xzdos_aoa_update.sh
bash scripts/xzdos_doctor.sh
echo '[OK] Sistema completamente installato'

