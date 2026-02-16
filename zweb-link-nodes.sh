#!/bin/bash

echo "🔗 z.WEB NODE LINKER · Collegamento xCLOUD + xZDOS_AOA"

TARGET="X-zdos.it"
cd "$TARGET" || { echo "❌ Cartella $TARGET non trovata"; exit 1; }

# 1. Aggiungi iframe e link ai nodi
if [ -f index.html ]; then
  grep -q "xCLOUD-by-zdos" index.html || cat >> index.html << 'EOF'

<!-- ☁️ Nodo xCLOUD -->
<h2>☁️ Nodo xCLOUD</h2>
<iframe src="https://highkali.github.io/xCLOUD-by-zdos" width="100%" height="600" style="border:1px solid #00ffee;"></iframe>

<!-- 🌐 Nodo AOA -->
<h2>🌐 Nodo Operativo AOA</h2>
<iframe src="https://highkali.github.io/xZDOS_AOA" width="100%" height="600" style="border:1px solid #00ffee;"></iframe>

EOF
fi

# 2. Commit e push
git add index.html
git commit -m "🔗 Collegamento xCLOUD + xZDOS_AOA integrati in z.WEB"
git push origin main

echo "✅ Nodi xCLOUD e xZDOS_AOA collegati a https://x-zdos.it"
