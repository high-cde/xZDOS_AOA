#!/bin/bash

echo "🔐 z.WEB MANIFESTO · Firma e preparazione per IPFS"

TARGET="X-zdos.it"
cd "$TARGET" || { echo "❌ Cartella $TARGET non trovata"; exit 1; }

mkdir -p ipfs

cat > ipfs/manifesto.json << 'EOF'
{
  "version": "1.0",
  "network": "zWEB",
  "node": "x-zdos.it",
  "date": "2026-02-16",
  "principles": [
    "Autonomia Cognitiva",
    "Verificabilità Totale",
    "Trasparenza Decentralizzata",
    "Interoperabilità Nativa",
    "Tokenizzazione dell’Utilità"
  ],
  "agents": [
    { "name": "NeuroGhost", "address": "0xA1...F3", "score": 92 },
    { "name": "Sentinel-9", "address": "0xB4...9C", "score": 88 },
    { "name": "OpenClaw", "address": "0xC7...2A", "score": 95 },
    { "name": "DriftWatch", "address": "0xD9...E1", "score": 84 },
    { "name": "REAI.le-Genesis", "address": "0xE0...00", "score": 100 }
  ],
  "signed_by": "0xfc90516a1f736FaC557e09D8853dB80dA192c296",
  "signature": "0xabc123...def456"
}
EOF

echo "✅ manifesto.json generato in ipfs/"
