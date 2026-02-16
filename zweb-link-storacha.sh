#!/bin/bash

echo "📡 z.WEB STORACHA · Collegamento nodo decentralizzato"

TARGET="X-zdos.it"
cd "$TARGET" || { echo "❌ Cartella $TARGET non trovata"; exit 1; }

mkdir -p agents

cat > agents/registry.json << 'EOF'
{
  "agent": "XDSN.MINER",
  "email": "XDSN.MINER@PROTON.ME",
  "did": "did:key:z6Mkj7y6V8uJAgaYxVRNPwiXYnMjFXvR8sXDQ1kW6R9dFjx1",
  "storage": "0B of 5.0GB",
  "egress": "0B of 5.0GB",
  "plan": "Mild",
  "referral": "http://storacha.network/referred?refcode=CWzPFzPgk77rHLMG"
}
EOF

# Integra nella dashboard
DASHBOARD="dashboard/dashboard-biforcata.html"
grep -q "Nodo Storacha" "$DASHBOARD" || cat >> "$DASHBOARD" << 'EOF'

<h2>📡 Nodo Storacha</h2>
<p>Email: XDSN.MINER@PROTON.ME</p>
<p>Piano: Mild · Storage: 0B / 5.0GB · Egress: 0B / 5.0GB</p>
<p>DID: did:key:z6Mkj7y6V8uJAgaYxVRNPwiXYnMjFXvR8sXDQ1kW6R9dFjx1</p>
<p><a href="http://storacha.network/referred?refcode=CWzPFzPgk77rHLMG" target="_blank">🔗 Referral Link</a></p>

EOF

# Commit e push
git add .
git commit -m "📡 Collegamento nodo Storacha con DID decentralizzato"
git push origin main

echo "✅ Nodo Storacha integrato con agente XDSN.MINER"
