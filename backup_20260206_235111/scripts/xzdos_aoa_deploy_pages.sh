#!/bin/bash
echo '[DEPLOY] Pubblicazione GitHub Pages'
git add .
git commit -m 'Deploy GitHub Pages'
git push
echo '[OK] Deploy completato'

