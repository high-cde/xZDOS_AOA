#!/bin/bash

TS=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backup_$TS"

echo "[BACKUP] Creazione backup in: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

echo "[BACKUP] Copia dei file..."

# Copia tutto tranne:
# - la cartella di backup stessa
# - .git
# - scripts (opzionale)
# - eventuali vecchi backup
rsync -av \
    --exclude "$BACKUP_DIR" \
    --exclude "backup_*" \
    --exclude ".git" \
    --exclude "scripts" \
    ./ "$BACKUP_DIR/"

echo "[OK] Backup completato correttamente."
