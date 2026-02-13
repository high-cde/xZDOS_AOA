#!/bin/bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"
EVENT_BUS_DIR="$ROOT_DIR/event_bus"
MINIERA_DIR="$ROOT_DIR/giga-xzdos"
OPECLAW_DIR="$ROOT_DIR/OPECLAW"

echo "[FUSION] Avvio fusione quantistica dei 4 moduli…"

# 1. Collegamento Portale
PORTAL_FILE="$ROOT_DIR/web/portal/index.html"
if [ -f "$PORTAL_FILE" ]; then
    sed -i 's|//EVENT_BUS_DISABLED|window.xzdosEventBusEnabled=true;|g' "$PORTAL_FILE"
    echo "[OK] Portale collegato all’Event Bus"
else
    echo "[WARN] Portale non trovato"
fi

# 2. Mappa dinamica
MAP_SCRIPT="$MINIERA_DIR/update-map.js"
cat > "$MAP_SCRIPT" << 'EOF'
const fs = require("fs");
const state = JSON.parse(fs.readFileSync("./giga-xzdos/miners-state.json","utf8"));
const html = `<html><body style="background:#000;color:#0f0;font-family:monospace">
<h2>GIGA-XZDOS — Mappa Dinamica</h2><pre>${JSON.stringify(state,null,2)}</pre></body></html>`;
fs.writeFileSync("./panels/miniera_map.html", html);
EOF
echo "[OK] Mappa dinamica generata"

# 3. Runner principale
RUNNER="$SCRIPTS_DIR/xzdos_aoa_runner.sh"
cat > "$RUNNER" << 'EOF'
#!/bin/bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$ROOT_DIR/scripts/xzdos_sentinel.sh"
EOF
chmod +x "$RUNNER"
echo "[OK] Runner principale attivo"

# 4. Automi OPECLAW nel ciclo Sentinel
SENTINEL="$SCRIPTS_DIR/xzdos_sentinel.sh"
if ! grep -q "OPECLAW" "$SENTINEL"; then
    sed -i '/run_miniera_cycle/a \
echo "[OPECLAW] Avvio automi"; \
for auto in $(ls OPECLAW/*.sh 2>/dev/null); do \
    bash "$auto"; \
done' "$SENTINEL"
    echo "[OK] Automi OPECLAW integrati nel ciclo Sentinel"
else
    echo "[OK] Automi già integrati"
fi

echo ""
echo "🔥 FUSIONE COMPLETATA — xZDOS_AOA ora opera come un ecosistema unico."
echo "Puoi avviare tutto con: bash scripts/xzdos_aoa_runner.sh"
