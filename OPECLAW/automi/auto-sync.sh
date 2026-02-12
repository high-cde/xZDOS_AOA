#!/usr/bin/env bash
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
echo "$(date) · auto-sync eseguito" >> "$LOG_DIR/flow.log"
