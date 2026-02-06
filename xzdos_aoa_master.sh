#!/bin/bash

# ============================================================
# xZDOS_AOA MASTER SCRIPT (ENTERPRISE EDITION)
# Genera l'intero ecosistema di script xZDOS_AOA
# Bash + Python Bridge
# ============================================================

ROOT_DIR="$(pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

echo "[xZDOS_AOA] MASTER SCRIPT — ENTERPRISE EDITION"
echo "[INFO] Root directory: $ROOT_DIR"
echo "[INFO] Scripts directory: $SCRIPTS_DIR"

mkdir -p "$SCRIPTS_DIR"

# ------------------------------------------------------------
# Funzione helper per creare file
# ------------------------------------------------------------
create_script() {
    local filename="$1"
    local content="$2"

    echo "[CREATE] $filename"
    echo "$content" > "$SCRIPTS_DIR/$filename"
    chmod +x "$SCRIPTS_DIR/$filename"
}

# ------------------------------------------------------------
# 1. xzdos_aoa_install.sh
# ------------------------------------------------------------
create_script "xzdos_aoa_install.sh" "#!/bin/bash
echo '[INSTALL] xZDOS_AOA — Setup iniziale'
mkdir -p panels
mkdir -p config
mkdir -p src
mkdir -p logs
echo '[OK] Struttura base creata'
"

# ------------------------------------------------------------
# 2. xzdos_aoa_update.sh
# ------------------------------------------------------------
create_script "xzdos_aoa_update.sh" "#!/bin/bash
echo '[UPDATE] Aggiornamento struttura xZDOS_AOA'
git pull
echo '[OK] Repository aggiornato'
"

# ------------------------------------------------------------
# 3. xzdos_aoa_sync.sh
# ------------------------------------------------------------
create_script "xzdos_aoa_sync.sh" "#!/bin/bash
echo '[SYNC] Sincronizzazione file e pannelli'
rsync -av panels/ docs/ --exclude '*.tmp'
echo '[OK] Sincronizzazione completata'
"

# ------------------------------------------------------------
# 4. xzdos_aoa_pages_sync.sh
# ------------------------------------------------------------
create_script "xzdos_aoa_pages_sync.sh" "#!/bin/bash
echo '[PAGES] Sincronizzazione GitHub Pages'
mkdir -p docs
cp -r panels/social_control docs/
echo '[OK] Pannello Social Control sincronizzato in docs/'
"

# ------------------------------------------------------------
# 5. xzdos_aoa_deploy_pages.sh
# ------------------------------------------------------------
create_script "xzdos_aoa_deploy_pages.sh" "#!/bin/bash
echo '[DEPLOY] Pubblicazione GitHub Pages'
git add .
git commit -m 'Deploy GitHub Pages'
git push
echo '[OK] Deploy completato'
"

# ------------------------------------------------------------
# 6. xzdos_template_gen.sh
# ------------------------------------------------------------
create_script "xzdos_template_gen.sh" "#!/bin/bash
echo '[TEMPLATE] Generatore template xZDOS'
TARGET=\"templates/\$1.html\"
mkdir -p templates
echo '<!-- Template generato automaticamente -->' > \$TARGET
echo '[OK] Template creato: ' \$TARGET
"

# ------------------------------------------------------------
# 7. xzdos_panel_gen.sh
# ------------------------------------------------------------
create_script "xzdos_panel_gen.sh" "#!/bin/bash
echo '[PANEL] Generatore pannelli xZDOS'
TARGET=\"panels/\$1/index.html\"
mkdir -p \"panels/\$1\"
echo '<!-- Pannello generato automaticamente -->' > \$TARGET
echo '[OK] Pannello creato: ' \$TARGET
"

# ------------------------------------------------------------
# 8. xzdos_rebuild.sh
# ------------------------------------------------------------
create_script "xzdos_rebuild.sh" "#!/bin/bash
echo '[REBUILD] Ricostruzione ecosistema xZDOS_AOA'
bash scripts/xzdos_aoa_install.sh
bash scripts/xzdos_aoa_sync.sh
echo '[OK] Rebuild completato'
"

# ------------------------------------------------------------
# 9. xzdos_backup.sh
# ------------------------------------------------------------
create_script "xzdos_backup.sh" "#!/bin/bash
TS=\$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=\"backup_\$TS\"
mkdir -p \$BACKUP_DIR
cp -r * \$BACKUP_DIR/
echo '[BACKUP] Creato backup in:' \$BACKUP_DIR
"

# ------------------------------------------------------------
# 10. xzdos_doctor.sh
# ------------------------------------------------------------
create_script "xzdos_doctor.sh" "#!/bin/bash
echo '[DOCTOR] Diagnostica xZDOS_AOA'
echo '[CHECK] Verifica directory...'
for d in panels config src scripts; do
    if [ -d \"\$d\" ]; then
        echo '[OK]' \$d
    else
        echo '[WARN]' \$d 'mancante'
    fi
done
echo '[DONE] Diagnostica completata'
"

# ------------------------------------------------------------
# 11. xzdos_validator.sh
# ------------------------------------------------------------
create_script "xzdos_validator.sh" "#!/bin/bash
echo '[VALIDATOR] Validazione struttura xZDOS_AOA'
if [ -f scripts/xzdos_aoa_master.sh ]; then
    echo '[OK] Master script presente'
else
    echo '[ERROR] Master script mancante'
fi
echo '[DONE] Validazione completata'
"

# ------------------------------------------------------------
# 12. xzdos_aoa_all_in_one.sh
# ------------------------------------------------------------
create_script "xzdos_aoa_all_in_one.sh" "#!/bin/bash
echo '[ALL-IN-ONE] Installazione completa xZDOS_AOA'
bash scripts/xzdos_aoa_install.sh
bash scripts/xzdos_aoa_sync.sh
bash scripts/xzdos_aoa_update.sh
bash scripts/xzdos_doctor.sh
echo '[OK] Sistema completamente installato'
"

echo "[DONE] Tutti gli script del MEGA PACK sono stati generati."
echo "[NEXT] Esegui:  bash scripts/xzdos_aoa_all_in_one.sh"
