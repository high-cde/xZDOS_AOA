#!/bin/bash

echo "🧰 z.WEB TOOLCHAI · Installazione nativa del tool"

TARGET="X-zdos.it"
cd "$TARGET" || { echo "❌ Cartella $TARGET non trovata"; exit 1; }

mkdir -p scripts

# 1. Crea utility-toolchai.js
cat > scripts/utility-toolchai.js << 'EOF'
export const TOKEN_ADDRESS = "0xfc90516a1f736FaC557e09D8853dB80dA192c296";
export const ETHERSCAN_API = "https://api.etherscan.io/api";

export async function getTokenStatus() {
  const res = await fetch(`${ETHERSCAN_API}?module=token&action=tokeninfo&contractaddress=${TOKEN_ADDRESS}`);
  const data = await res.json();
  return {
    name: data.result.name,
    symbol: data.result.symbol,
    supply: data.result.totalSupply,
    holders: data.result.holdersCount
  };
}

export function connectNodes() {
  const urls = [
    "https://highkali.github.io/xCLOUD-by-zdos",
    "https://highkali.github.io/xZDOS_AOA"
  ];
  urls.forEach(url => {
    const iframe = document.createElement("iframe");
    iframe.src = url;
    iframe.width = "100%";
    iframe.height = "400";
    iframe.style.border = "1px solid #00ffee";
    document.body.appendChild(iframe);
  });
}

export function mintUtility(agent, amount) {
  console.log(`🔁 Minting ${amount} ZDOS for agent ${agent}`);
  return `✅ ${amount} ZDOS assegnati a ${agent}`;
}

export function tokenPay(from, to, amount) {
  console.log(`💸 ${from} → ${to}: ${amount} ZDOS`);
  return `✅ Pagamento simulato: ${amount} ZDOS da ${from} a ${to}`;
}

export function verifySignature(message, signature, expectedAddress) {
  return ethers.verifyMessage(message, signature).toLowerCase() === expectedAddress.toLowerCase();
}

export function syncToMoltbook(entry) {
  console.log(`📡 Syncing to moltbook: ${entry}`);
  return true;
}
EOF

# 2. Integra nel file index.html
if [ -f index.html ]; then
  grep -q "utility-toolchai.js" index.html || sed -i '/<\/head>/i <script type="module" src="scripts/utility-toolchai.js"></script>' index.html

  grep -q "Utility ToolChai" index.html || cat >> index.html << 'EOF'

<h2>🧰 Utility ToolChai</h2>
<button onclick="connectNodes()">🔗 Collega Nodi</button>
<button onclick="getTokenStatus().then(console.log)">📊 Stato Token</button>
<button onclick="mintUtility('NeuroGhost', 100)">💰 Usa Token</button>
<button onclick="tokenPay('Sentinel-9', 'OpenClaw', 50)">💸 Paga con ZDOS</button>

EOF
fi

# 3. Commit e push
git add .
git commit -m "🧰 ToolChai: utility token tool nativo per z.WEB"
git push origin main

echo "✅ ToolChai installato e attivo su https://x-zdos.it"
