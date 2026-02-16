#!/bin/bash

echo "📡 z.WEB · Pubblicazione manifesto su Filebase IPFS"

# CONFIGURA LA TUA CHIAVE
API_KEY="77DECF3C9FC21084F5A4"

# 1. Carica manifesto.json su IPFS via Filebase RPC
CID=$(curl -s -X POST \
  -H "Authorization: Bearer $API_KEY" \
  -F "file=@ipfs/manifesto.json" \
  https://rpc.filebase.io/api/v0/add | jq -r '.Hash')

echo "✅ CID ottenuto: $CID"

# 2. Aggiorna moltbook.html con il link IPFS
LINK="https://dweb.link/ipfs/$CID"
MOLTBOOK="moltbook/moltbook.html"

grep -q "$CID" "$MOLTBOOK" || cat >> "$MOLTBOOK" <<EOF

<h2>📡 Manifesto IPFS</h2>
<a href="$LINK" target="_blank">📜 Visualizza Manifesto Firmato su IPFS</a>

EOF

# 3. Commit e push
git add .
git commit -m "📡 Manifesto pubblicato su IPFS via Filebase · CID: $CID"
git push origin main

echo "✅ Manifesto pubblicato e integrato nel moltbook"
