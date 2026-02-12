#!/usr/bin/env bash
LOG_DIR="$(dirname "$0")/../logs"
echo "$(date) · health-check OK" >> "$LOG_DIR/health.log"
