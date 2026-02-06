#!/bin/bash
TS=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backup_$TS"
mkdir -p $BACKUP_DIR
cp -r * $BACKUP_DIR/
echo '[BACKUP] Creato backup in:' $BACKUP_DIR

