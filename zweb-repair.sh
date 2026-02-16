#!/bin/bash

echo "🛠 z.WEB REPAIR & DEPLOY · Analisi + Fix + Deploy"

TARGET="X-zdos.it"
cd "$TARGET" || { echo "❌ Cartella $TARGET non trovata"; exit 1; }

mkdir -p moltbook agents dashboard

# 1. Ricrea moltbook.html se mancante
if [ ! -f moltbook/moltbook.html ]; then
  echo "⚠️  moltbook.html mancante. Ricreazione..."
  cat > moltbook/moltbook.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Moltbook</title></head>
<body>
  <h1>🧠 Registro Biforcato</h1>
  <p>Benvenuto nel moltbook decentralizzato. Ogni voce è firmata e pubblicata su IPFS.</p>
</body>
</html>
EOF
fi

# 2. Ricrea dashboard se mancante
if [ ! -f dashboard/dashboard-biforcata.html ]; then
  echo "⚠️  Dashboard mancante. Ricreazione..."
  cat > dashboard/dashboard-biforcata.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Dashboard Biforcata</title></head>
<body style="background:#0a0a0f;color:#00ffee;font-family:monospace;padding:2rem;">
  <h1>🌐 Rete Agenti REAI.le</h1>
  <div>🧠 NeuroGhost – Attivo</div>
  <div>🛡️ Sentinel-9 – Monitoraggio</div>
  <div>🧬 OpenClaw – Supply Sync</div>
  <div>📡 DriftWatch – Deriva 0.002%</div>
</body>
</html>
EOF
fi

# 3. Ricrea verify-test.html
cat > agents/verify-test.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Verifica Firma</title></head>
<body>
  <script type="module">
    import { verifyAgentMessage } from './verify-agent.js';
    const msg = "Biforcazione attiva";
    const sig = "0x..."; // Inserisci firma reale
    const pubkey = "0x..."; // Inserisci indirizzo agente
    const valid = verifyAgentMessage(msg, sig, pubkey);
    console.log(valid ? "✅ Firma valida" : "❌ Firma non valida");
  </script>
</body>
</html>
EOF

# 4. Integra link in index.html
if [ -f index.html ]; then
  grep -q "moltbook" index.html || echo '<a href="https://x-zdos.it/moltbook/moltbook.html">🧠 Moltbook</a>' >> index.html
  grep -q "dashboard" index.html || echo '<a href="https://x-zdos.it/dashboard/dashboard-biforcata.html">🌐 Dashboard Biforcata</a>' >> index.html
fi

# 5. Commit e push
git add .
git commit -m "🛠 z.WEB REPAIR: moltbook, dashboard, verifica agenti, link, deploy"
git push origin main

echo "✅ Nodo z.WEB ristabilito e pubblicato su https://x-zdos.it"
