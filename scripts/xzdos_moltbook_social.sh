#!/bin/bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOCIAL_SRC="$ROOT_DIR/moltbook/social"
SOCIAL_DOCS="$ROOT_DIR/docs/social"
LOG_DIR="$ROOT_DIR/logs"
EVENT_BUS="$ROOT_DIR/scripts/xzdos_sentinel_event_bus.sh"

mkdir -p "$SOCIAL_DOCS" "$LOG_DIR"
LOG_FILE="$LOG_DIR/moltbook_social.log"

log() {
    echo "[$(date +%H:%M:%S)] [MOLTBOOK_SOCIAL] $1" | tee -a "$LOG_FILE"
}

emit() {
    bash "$EVENT_BUS" emit "$1"
}

log "Avvio agente MOLTBOOK Social"

if [ ! -d "$SOCIAL_SRC" ]; then
    log "Directory MOLTBOOK Social mancante"
    emit "MOLTBOOK_SOCIAL_MISSING"
    exit 1
fi

if ! diff -qr "$SOCIAL_SRC" "$SOCIAL_DOCS" >/dev/null 2>&1; then
    log "DRIFT rilevato tra sorgente e docs/"
    emit "MOLTBOOK_SOCIAL_DRIFT"
else
    log "Nessun drift rilevato"
fi

log "Sincronizzazione contenuti MOLTBOOK Social → docs/social/"
rsync -a --delete "$SOCIAL_SRC/" "$SOCIAL_DOCS/" >> "$LOG_FILE" 2>&1

log "Sincronizzazione completata"
emit "MOLTBOOK_SOCIAL_SYNC_OK"

if [ ! -f "$SOCIAL_DOCS/index.html" ]; then
    log "Validazione fallita: index.html mancante"
    emit "MOLTBOOK_SOCIAL_VALIDATION_FAIL"
    exit 1
fi

log "Validazione OK"
emit "MOLTBOOK_SOCIAL_OK"
exit 0
