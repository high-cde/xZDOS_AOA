#!/bin/bash

echo "🔐 z.WEB AGENT REPAIR · Ricostruzione modulo verify-agent.js"

TARGET="X-zdos.it"
cd "$TARGET/agents" || { echo "❌ Cartella agents non trovata"; exit 1; }

cat > verify-agent.js << 'EOF'
import { ethers } from "https://cdn.jsdelivr.net/npm/ethers@6.7.0/+esm";

export function verifyAgentMessage(message, signature, expectedAddress) {
  try {
    const signer = ethers.verifyMessage(message, signature);
    return signer.toLowerCase() === expectedAddress.toLowerCase();
  } catch (e) {
    console.error("Errore verifica firma:", e);
    return false;
  }
}
EOF

echo "✅ verify-agent.js ricreato"

cd ..
git add agents/verify-agent.js
git commit -m "🔐 Ripristino modulo verify-agent.js per verifica firme"
git push origin main

echo "✅ Modulo agenti ripristinato. Verifica firme ora attiva."
