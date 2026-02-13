#!/bin/bash
# xZDOS_AOA — Dev Sync Tool
# Sincronizza il fork locale con il repository upstream ufficiale

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[SYNC] Sincronizzazione con upstream high-cde/xZDOS_AOA"

# Aggiungi upstream se non esiste
if ! git remote | grep -q upstream; then
    git remote add upstream https://github.com/high-cde/xZDOS_AOA.git
    echo "[SYNC] Remote 'upstream' aggiunto"
fi

# Recupera aggiornamenti da upstream
git fetch upstream

# Merge con main locale
git merge upstream/main

# Push sul tuo fork (opzionale)
echo ""
read -p "Vuoi pushare anche sul tuo fork remoto? [y/N] " PUSH
if [[ "$PUSH" =~ ^[Yy]$ ]]; then
    git push origin main
    echo "[SYNC] Push completato su origin/main"
else
    echo "[SYNC] Push locale completato — nessun push remoto eseguito"
fi
