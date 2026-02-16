#!/bin/bash

echo "🧬 z.WEB UNIFIED FINALIZER"

TARGET="X-zdos.it"
cd "$TARGET" || { echo "❌ Cartella $TARGET non trovata"; exit 1; }

mkdir -p moltbook agents dashboard

# Sposta file se esistono
[ -f ../moltbook/moltbook.html ] && mv ../moltbook/moltbook.html moltbook/
[ -f ../dashboard-biforcata.html ] && mv ../dashboard-biforcata.html dashboard/dashboard-biforcata.html
[ -f ../dashboard-biforcata.html. ] && mv ../dashboard-biforcata.html. dashboard/dashboard-biforcata.html
[ -f ../agents/verify-agent.js ] && mv ../agents/verify-agent.js agents/

# Crea verify-test.html
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

# Integra link in index.html
if [ -f index.html ]; then
  grep -q "moltbook" index.html || echo '<a href="https://x-zdos.it/moltbook/moltbook.html">🧠 Moltbook</a>' >> index.html
  grep -q "dashboard" index.html || echo '<a href="https://x-zdos.it/dashboard/dashboard-biforcata.html">🌐 Dashboard Biforcata</a>' >> index.html
fi

# Commit e push
git add .
git commit -m "🧠 z.WEB UNIFICATO: moltbook, dashboard, verifica firme agenti"
git push origin main

echo "✅ z.WEB UNIFICATO attivo su https://x-zdos.it"
