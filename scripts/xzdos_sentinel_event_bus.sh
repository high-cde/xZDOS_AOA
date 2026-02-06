#!/bin/bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUS_DIR="$ROOT_DIR/event_bus"
LOG_DIR="$ROOT_DIR/logs"
mkdir -p "$BUS_DIR" "$LOG_DIR"
LOG_FILE="$LOG_DIR/sentinel_event_bus.log"

log() {
    echo "[$(date +%H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

EVENT_FILE="$BUS_DIR/events_$(date +%Y%m%d).log"

case "$1" in
    emit)
        shift
        MSG="$*"
        echo "[$(date +%Y%m%d_%H%M%S)] $MSG" >> "$EVENT_FILE"
        log "[EMIT] $MSG"
        ;;
    tail)
        log "[TAIL] Event stream"
        tail -f "$EVENT_FILE"
        ;;
    *)
        echo "Usage: $0 {emit <msg> | tail}"
        ;;
esac
