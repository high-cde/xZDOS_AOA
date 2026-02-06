#!/bin/bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"
LOG_DIR="$ROOT_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/sentinel_watchdog.log"

log() {
    echo "[$(date +%Y%m%d_%H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

INTERVAL=60

log "[WATCHDOG] Avvio watchdog SENTINEL (intervallo: ${INTERVAL}s)"

while true; do
    log "[WATCHDOG] Avvio ciclo SENTINEL"
    bash "$SCRIPTS_DIR/xzdos_sentinel.sh"
    log "[WATCHDOG] Ciclo completato, sleep ${INTERVAL}s"
    sleep "$INTERVAL"
done
