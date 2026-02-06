#!/bin/bash
echo '[PANEL] Generatore pannelli xZDOS'
TARGET="panels/$1/index.html"
mkdir -p "panels/$1"
echo '<!-- Pannello generato automaticamente -->' > $TARGET
echo '[OK] Pannello creato: ' $TARGET

