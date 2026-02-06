#!/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"
LOG_DIR="$ROOT_DIR/logs"
STATE_DIR="$ROOT_DIR/state"
PANEL_DIR="$ROOT_DIR/panels/sentinel_dashboard"
DOCS_DIR="$ROOT_DIR/docs"

mkdir -p "$LOG_DIR" "$STATE_DIR" "$PANEL_DIR" "$DOCS_DIR"

TS=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR/sentinel_$TS.log"
STATE_FILE="$STATE_DIR/sentinel_state.json"

log() {
    echo "[$(date +%H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

init_state() {
    if [ ! -f "$STATE_FILE" ]; then
        echo '{"cycles":0,"last_status":"INIT"}' > "$STATE_FILE"
    fi
}

update_state() {
    local status="$1"
    local cycles
    cycles=$(jq '.cycles' "$STATE_FILE")
    local new_cycles=$((cycles + 1))
    jq -n \
        --arg status "$status" \
        --argjson cycles "$new_cycles" \
        '{cycles:$cycles, last_status:$status}' \
        > "$STATE_FILE"
}

run_core_cycle() {
    log "[SENTINEL] xZDOS_AOA_SENTINEL v3 — Meta-agente"

    init_state
    local cycles last_status
    cycles=$(jq '.cycles' "$STATE_FILE")
    last_status=$(jq -r '.last_status' "$STATE_FILE")

    log "[INFO] Root: $ROOT_DIR"
    log "[INFO] Scripts: $SCRIPTS_DIR"
    log "[INFO] Log file: $LOG_FILE"
    log "[INFO] Stato precedente: $last_status (cicli: $cycles)"

    local AGENTS=(
        "xzdos_aoa_install.sh"
        "xzdos_aoa_update.sh"
        "xzdos_aoa_sync.sh"
        "xzdos_aoa_pages_sync.sh"
        "xzdos_aoa_deploy_pages.sh"
        "xzdos_template_gen.sh"
        "xzdos_panel_gen.sh"
        "xzdos_rebuild.sh"
        "xzdos_backup.sh"
        "xzdos_doctor.sh"
        "xzdos_validator.sh"
        "xzdos_aoa_all_in_one.sh"
    )

    local STATUS="OK"

    log "[STEP] Verifica integrità agenti"
    for agent in "${AGENTS[@]}"; do
        local file="$SCRIPTS_DIR/$agent"
        if [ ! -f "$file" ]; then
            log "[FAIL] $agent mancante"
            STATUS="REPAIR"
        elif [ ! -x "$file" ]; then
            log "[FIX] $agent non eseguibile — chmod +x"
            chmod +x "$file"
        else
            log "[OK] $agent integro"
        fi
    done

    log "[STEP] Diagnostica"
    if bash "$SCRIPTS_DIR/xzdos_doctor.sh" | tee -a "$LOG_FILE"; then
        log "[OK] Diagnostica completata"
    else
        log "[WARN] Diagnostica ha rilevato problemi"
        [ "$STATUS" = "OK" ] && STATUS="WARN"
    fi

    log "[STEP] Validazione"
    if bash "$SCRIPTS_DIR/xzdos_validator.sh" | tee -a "$LOG_FILE"; then
        log "[OK] Validazione completata"
    else
        log "[FAIL] Validazione fallita"
        STATUS="FAIL"
    fi

    if [ "$STATUS" = "FAIL" ] || [ "$STATUS" = "REPAIR" ]; then
        log "[REPAIR] Avvio ricostruzione ecosistema"
        bash "$SCRIPTS_DIR/xzdos_rebuild.sh" | tee -a "$LOG_FILE"
        STATUS="REBUILD"
    fi

    update_state "$STATUS"
    log "[DONE] Ciclo SENTINEL completato — Stato: $STATUS"
}

bootstrap_modules() {
    log "[BOOTSTRAP] Installazione moduli SENTINEL v3"

    # Watchdog
    cat > "$SCRIPTS_DIR/xzdos_sentinel_watchdog.sh" << 'EOF'
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
EOF
    chmod +x "$SCRIPTS_DIR/xzdos_sentinel_watchdog.sh"

    # Event bus
    cat > "$SCRIPTS_DIR/xzdos_sentinel_event_bus.sh" << 'EOF'
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
EOF
    chmod +x "$SCRIPTS_DIR/xzdos_sentinel_event_bus.sh"

    # Analyzer Python
    cat > "$SCRIPTS_DIR/xzdos_sentinel_analyzer.py" << 'EOF'
import os
import glob
import re
from datetime import datetime

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
LOG_DIR = os.path.join(ROOT_DIR, "logs")

def parse_logs():
    pattern = os.path.join(LOG_DIR, "sentinel_*.log")
    files = sorted(glob.glob(pattern))
    summary = {
        "total_cycles": 0,
        "status_counts": {},
        "last_cycle": None,
    }

    status_re = re.compile(r"Ciclo SENTINEL completato — Stato: (\w+)")
    time_re = re.compile(r"^\[(\d{2}:\d{2}:\d{2})\]")

    for f in files:
        with open(f, "r", encoding="utf-8", errors="ignore") as fh:
            last_status = None
            last_time = None
            for line in fh:
                m_s = status_re.search(line)
                if m_s:
                    last_status = m_s.group(1)
                m_t = time_re.match(line)
                if m_t:
                    last_time = m_t.group(1)
            if last_status:
                summary["total_cycles"] += 1
                summary["status_counts"][last_status] = summary["status_counts"].get(last_status, 0) + 1
                summary["last_cycle"] = {
                    "file": os.path.basename(f),
                    "status": last_status,
                    "time": last_time,
                }

    return summary

if __name__ == "__main__":
    s = parse_logs()
    print("=== SENTINEL ANALYZER ===")
    print(f"Total cycles: {s['total_cycles']}")
    print("Status counts:")
    for k, v in s["status_counts"].items():
        print(f"  {k}: {v}")
    if s["last_cycle"]:
        print("Last cycle:")
        print(f"  File: {s['last_cycle']['file']}")
        print(f"  Status: {s['last_cycle']['status']}")
        print(f"  Time: {s['last_cycle']['time']}")
EOF

    # Dashboard HTML
    mkdir -p "$PANEL_DIR"
    cat > "$PANEL_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>SENTINEL Dashboard</title>
  <style>
    body { font-family: system-ui, sans-serif; background:#050711; color:#f5f5f5; margin:0; padding:20px; }
    .card { background:#0b0f1f; border-radius:10px; padding:20px; margin-bottom:20px; box-shadow:0 0 20px rgba(0,0,0,0.4); }
    h1 { margin-top:0; }
    .status-ok { color:#4caf50; }
    .status-warn { color:#ffc107; }
    .status-fail { color:#f44336; }
    .grid { display:grid; grid-template-columns: repeat(auto-fit,minmax(250px,1fr)); gap:20px; }
    pre { background:#050711; padding:10px; border-radius:6px; overflow:auto; max-height:300px; }
  </style>
</head>
<body>
  <h1>SENTINEL Dashboard</h1>
  <div class="grid">
    <div class="card">
      <h2>Stato Sistema</h2>
      <p>Questa dashboard mostra lo stato logico di SENTINEL e dei suoi cicli.</p>
      <p><strong>Nota:</strong> versione statica, alimentata dai log generati nel repo.</p>
    </div>
    <div class="card">
      <h2>Log SENTINEL</h2>
      <p>Apri i file in <code>logs/</code> per vedere i dettagli dei cicli.</p>
      <pre>git clone &amp;&amp; tail -f logs/sentinel_*.log</pre>
    </div>
    <div class="card">
      <h2>Analyzer</h2>
      <p>Esegui l'analizzatore Python in locale:</p>
      <pre>python scripts/xzdos_sentinel_analyzer.py</pre>
    </div>
  </div>
</body>
</html>
EOF

    log "[BOOTSTRAP] Moduli SENTINEL v3 creati"
}

deploy_dashboard() {
    log "[DEPLOY] Sync dashboard in docs/ per GitHub Pages"
    mkdir -p "$DOCS_DIR/sentinel"
    rsync -av "$PANEL_DIR/" "$DOCS_DIR/sentinel/"
    log "[DEPLOY] Pronto per git add/commit/push"
}

# --- ENTRYPOINT ---

if [[ "$*" == *"--bootstrap"* ]]; then
    bootstrap_modules
fi

run_core_cycle

if [[ "$*" == *"--deploy"* ]]; then
    deploy_dashboard
fi
