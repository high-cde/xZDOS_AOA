#!/bin/bash

echo "🧪 z.WEB DIAGNOSTICA GLOBALE · Analisi completa del nodo"

TARGET="X-zdos.it"
cd "$TARGET" || { echo "❌ Cartella $TARGET non trovata"; exit 1; }

echo "📂 Verifica struttura..."
for dir in moltbook dashboard agents scripts; do
  [ -d "$dir" ] && echo "✅ $dir presente" || echo "❌ $dir mancante"
done

echo "📄 Verifica file essenziali..."
for file in moltbook/moltbook.html dashboard/dashboard-biforcata.html moltbook/manifesto.html scripts/utility-toolchai.js agents/verify-agent.js; do
  [ -f "$file" ] && echo "✅ $file OK" || echo "❌ $file mancante"
done

echo "🔗 Verifica link in index.html..."
grep -q "moltbook/moltbook.html" index.html && echo "✅ Link moltbook OK" || echo "❌ Link moltbook mancante"
grep -q "dashboard/dashboard-biforcata.html" index.html && echo "✅ Link dashboard OK" || echo "❌ Link dashboard mancante"
grep -q "manifesto.html" index.html && echo "✅ Link manifesto OK" || echo "❌ Link manifesto mancante"
grep -q "utility-toolchai.js" index.html && echo "✅ Script ToolChai OK" || echo "❌ Script ToolChai mancante"

echo "🧠 Verifica token ZDOS..."
TOKEN="0xfc90516a1f736FaC557e09D8853dB80dA192c296"
curl -s "https://api.etherscan.io/api?module=token&action=tokeninfo&contractaddress=$TOKEN" | grep -E '"name"|"symbol"|"totalSupply"'

echo "📡 Verifica nodi remoti..."
for url in "https://highkali.github.io/xCLOUD-by-zdos" "https://highkali.github.io/xZDOS_AOA"; do
  curl -s --head "$url" | grep "200 OK" > /dev/null && echo "✅ Nodo attivo: $url" || echo "❌ Nodo non raggiungibile: $url"
done

echo "📜 Verifica manifesto..."
grep -q "Manifesto Firmato" moltbook/manifesto.html && echo "✅ Manifesto presente" || echo "❌ Manifesto mancante"

echo "✅ Diagnostica completata. z.WEB operativo se tutti i moduli sono OK."
