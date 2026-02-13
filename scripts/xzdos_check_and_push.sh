#!/bin/bash
# xZDOS_AOA — Verifica e Push Intelligente

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "🔍 Verifica integrità ecosistema xZDOS_AOA…"

# 1. Controllo file essenziali
REQUIRED=(
  "scripts/xzdos_fusion_all.sh"
  "scripts/xzdos_aoa_runner.sh"
  "scripts/xzdos_dev_sync.sh"
  "panels/sentinel_dashboard/index.html"
  "event_bus/events.log"
  "state/sentinel_state.json"
  "panels/miniera_map.html"
)

MISSING=0
for file in "${REQUIRED[@]}"; do
  if [ ! -f "$file" ]; then
    echo "❌ Manca: $file"
    MISSING=1
  else
    echo "✅ Presente: $file"
  fi
done

if [ "$MISSING" -eq 1 ]; then
  echo "🚫 Alcuni file sono mancanti. Correggi prima di procedere."
  exit 1
fi

# 2. Pull da upstream
echo "🔄 Sincronizzazione con upstream…"
git fetch upstream
git merge upstream/main

# 3. Commit locale
echo "📦 Commit locale delle modifiche…"
git add .
git commit -m "🔧 Aggiornamento completo: dashboard, agenti, eventi, mappa" || echo "ℹ️ Nessuna modifica da committare."

# 4. Push su GitHub
echo "🚀 Push su origin/main…"
git push origin main

echo "✅ Tutto aggiornato e sincronizzato con GitHub!"
