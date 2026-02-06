#!/bin/bash

echo "[SENTINEL] xZDOS_AOA_SENTINEL — Supervisore Avanzato"

ROOT_DIR="$(dirname "$(pwd)")"
SCRIPTS_DIR="$(pwd)"
LOG_DIR="$ROOT_DIR/logs"
STATE_DIR="$ROOT_DIR/state"
LOG_FILE="$LOG_DIR/sentinel_$(date +%Y%m%d_%H%M%S).log"
STATE_FILE="$STATE_DIR/sentinel_state.json"

mkdir -p "$LOG_DIR"
mkdir -p "$STATE_DIR"

log() {
    echo "[$(date +%H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

# Stato persistente
if [ ! -f "$STATE_FILE" ]; then
    echo '{"cycles":0,"last_status":"INIT"}' > "$STATE_FILE"
fi

# Carica stato
CYCLES=$(jq '.cycles' "$STATE_FILE")
LAST_STATUS=$(jq -r '.last_status' "$STATE_FILE")

log "[INFO] Ciclo precedente: $CYCLES"
log "[INFO] Stato precedente: $LAST_STATUS"

# Lista agenti
AGENTS=(
    "xzdos_aoa_install.sh"
    "xzdos_aoa_update.sh"
    "xzdos_aoa_sync.sh"
    "xzdos_aoa_pages_sync.sh"
    "xzdos_aoa_deploy_pages.sh"
    "xzdos_template_gen.sh"
    "xzdos_panel_gen.sh"
    "xzdos_rebuild.sh"
    "xzdos_backup.sh"
    "xzdos_doctor.sh"
    "xzdos_validator.sh"
    "xzdos_aoa_all_in_one.sh"
)

STATUS="OK"

log "[STEP] Verifica integrità agenti"

for agent in "${AGENTS[@]}"; do
    FILE="$SCRIPTS_DIR/$agent"
    if [ ! -f "$FILE" ]; then
        log "[FAIL] $agent mancante — rigenerazione necessaria"
        STATUS="REPAIR"
    elif [ ! -x "$FILE" ]; then
        log "[FIX] $agent non eseguibile — applico chmod +x"
        chmod +x "$FILE"
    else
        log "[OK] $agent integro"
    fi
done

# Diagnostica
log "[STEP] Diagnostica avanzata"

if bash "$SCRIPTS_DIR/xzdos_doctor.sh" | tee -a "$LOG_FILE"; then
    log "[OK] Diagnostica completata"
else
    log "[WARN] Diagnostica ha rilevato problemi"
    STATUS="WARN"
fi

# Validazione
log "[STEP] Validazione integrità"

if bash "$SCRIPTS_DIR/xzdos_validator.sh" | tee -a "$LOG_FILE"; then
    log "[OK] Validazione completata"
else
    log "[FAIL] Validazione fallita"
    STATUS="FAIL"
fi

# Auto-riparazione
if [ "$STATUS" = "FAIL" ]; then
    log "[REPAIR] Avvio ricostruzione ecosistema"
    bash "$SCRIPTS_DIR/xzdos_rebuild.sh"
    STATUS="REBUILD"
fi

# Aggiorna stato
NEW_CYCLES=$((CYCLES + 1))

jq -n \
    --arg status "$STATUS" \
    --argjson cycles "$NEW_CYCLES" \
    '{cycles:$cycles, last_status:$status}' \
    > "$STATE_FILE"

log "[DONE] Ciclo SENTINEL completato — Stato: $STATUS"
