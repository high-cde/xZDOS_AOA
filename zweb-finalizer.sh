#!/bin/bash

echo "🧬 z.WEB FINALIZER · One Shot One Kill"

# 1. Crea struttura corretta
mkdir -p X-zdos.it/{moltbook,agents,dashboard}

# 2. Sposta i file se esistono
[ -f moltbook/moltbook.html ] && mv moltbook/moltbook.html X-zdos.it/moltbook/
[ -f dashboard-biforcata.html ] && mv dashboard-biforcata.html X-zdos.it/dashboard/dashboard-biforcata.html
[ -f dashboard-biforcata.html. ] && mv dashboard-biforcata.html. X-zdos.it/dashboard/dashboard-biforcata.html
[ -f agents/verify-agent.js ] && mv agents/verify-agent.js X-zdos.it/agents/

# 3. Crea verify-test.html
cat > X-zdos.it/agents/verify-test.html << 'EOF'
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

# 4. Cerca progetti e aggiorna index.html
for proj in *; do
  if [ -d "$proj" ] && [ -f "$proj/index.html" ]; then
    echo "🔗 Collegando $proj"
    cd "$proj"
    grep -q "moltbook" index.html || echo '<a href="https://x-zdos.it/moltbook/moltbook.html">🧠 Moltbook</a>' >> index.html
    grep -q "dashboard" index.html || echo '<a href="https://x-zdos.it/dashboard/dashboard-biforcata.html">🌐 Dashboard Biforcata</a>' >> index.html
    git add .
    git commit -m "🔗 z.WEB: integrazione moltbook, dashboard, agenti REAI.le"
    git push origin main
    cd ..
  fi
done

echo "✅ z.WEB completamente sincronizzato. Ogni nodo è vivo, ogni firma è verificabile."
