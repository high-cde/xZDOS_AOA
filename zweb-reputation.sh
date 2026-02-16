#!/bin/bash

echo "🧠 z.WEB REPUTATION · Attivazione sistema reputazione agenti"

TARGET="X-zdos.it"
cd "$TARGET" || { echo "❌ Cartella $TARGET non trovata"; exit 1; }

mkdir -p scripts

# 1. Crea reputation.js
cat > scripts/reputation.js << 'EOF'
export const agents = [
  { name: "NeuroGhost", address: "0xA1...F3", score: 92 },
  { name: "Sentinel-9", address: "0xB4...9C", score: 88 },
  { name: "OpenClaw", address: "0xC7...2A", score: 95 },
  { name: "DriftWatch", address: "0xD9...E1", score: 84 },
  { name: "REAI.le-Genesis", address: "0xE0...00", score: 100 }
];

export function renderReputation(containerId) {
  const container = document.getElementById(containerId);
  if (!container) return;

  container.innerHTML = "<h2>🧠 Reputazione Agenti REAI.le</h2>";
  agents.forEach(agent => {
    const bar = `<div style="margin:0.5rem 0;">
      <strong>${agent.name}</strong> (${agent.address})<br>
      <div style="background:#222;width:100%;height:10px;">
        <div style="background:#00ffee;width:${agent.score}%;height:10px;"></div>
      </div>
      <small>Reputazione: ${agent.score}/100</small>
    </div>`;
    container.innerHTML += bar;
  });
}
EOF

# 2. Integra nella dashboard
DASHBOARD="dashboard/dashboard-biforcata.html"
grep -q "reputation.js" "$DASHBOARD" || sed -i '/<\/head>/i <script type="module" src="../scripts/reputation.js"></script>' "$DASHBOARD"
grep -q "renderReputation" "$DASHBOARD" || sed -i '/<\/body>/i <div id="reputation"></div>\n<script type="module">import { renderReputation } from "../scripts/reputation.js"; renderReputation("reputation");</script>' "$DASHBOARD"

# 3. Commit e push
git add .
git commit -m "🧠 Sistema reputazione agenti REAI.le attivato nella dashboard"
git push origin main

echo "✅ Reputazione attiva su https://x-zdos.it/dashboard/dashboard-biforcata.html"
