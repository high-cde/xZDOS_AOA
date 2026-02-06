#!/bin/bash
echo '[REBUILD] Ricostruzione ecosistema xZDOS_AOA'
bash scripts/xzdos_aoa_install.sh
bash scripts/xzdos_aoa_sync.sh
echo '[OK] Rebuild completato'

