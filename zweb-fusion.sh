#!/bin/bash

echo "🧬 z.WEB FUSION · One Shot One Kill"

declare -a projects=("Z-GENESIS-OS" "Cloudx-site-by-zdos" "xZDOS_AOA/social")

for proj in "${projects[@]}"; do
  echo "🔧 Entrando in $proj"
  cd "$proj" || exit

  mkdir -p moltbook style scripts canvas agents relay wasm dashboard

  cp ../X-zdos.it/moltbook/moltbook.html moltbook/
  cp ../X-zdos.it/style/zdos-node.css style/
  cp ../X-zdos.it/scripts/token-monitor.js scripts/
  cp ../X-zdos.it/canvas/zdos-pulse.js canvas/
  cp ../X-zdos.it/agents/agent-core.js agents/
  cp ../X-zdos.it/agents/verify-agent.js agents/
  cp ../X-zdos.it/relay/ipfs-publisher.js relay/
  cp ../X-zdos.it/wasm/zdos-node.js wasm/
  cp ../X-zdos.it/dashboard/dashboard-biforcata.html dashboard/

  if grep -q "Live Chat (Simulata)" index.html; then
    sed -i 's/Live Chat (Simulata)/REAI.le Agents · Live Feed/g' index.html
  fi

  if ! grep -q "moltbook" index.html; then
    echo '<a href="https://x-zdos.it/moltbook/moltbook.html">🧠 Moltbook</a>' >> index.html
  fi

  if ! grep -q "dashboard" index.html; then
    echo '<a href="dashboard/dashboard-biforcata.html">🌐 Dashboard Biforcata</a>' >> index.html
  fi

  git add .
  git commit -m "🔗 z.WEB FUSION: moltbook, agenti REAI.le, terminale, canvas, IPFS, dashboard"
  git push origin main

  cd ..
done

echo "✅ z.WEB FUSION completata. Tutti i nodi sincronizzati."
