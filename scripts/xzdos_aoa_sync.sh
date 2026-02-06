#!/bin/bash
echo '[SYNC] Sincronizzazione file e pannelli'
rsync -av panels/ docs/ --exclude '*.tmp'
echo '[OK] Sincronizzazione completata'

