#!/bin/bash
echo '[TEMPLATE] Generatore template xZDOS'
TARGET="templates/$1.html"
mkdir -p templates
echo '<!-- Template generato automaticamente -->' > $TARGET
echo '[OK] Template creato: ' $TARGET

