const fs = require("fs");
const path = require("path");

const statePath = path.join(__dirname, "miners-state.json");
const outputPath = path.join(__dirname, "../panels/miniera_map.html");

if (!fs.existsSync(statePath)) {
  console.error("❌ File miners-state.json non trovato.");
  process.exit(1);
}

const state = JSON.parse(fs.readFileSync(statePath, "utf8"));

const html = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Mappa Civiltà Biforcuta</title>
  <style>
    body { background: #000; color: #0f0; font-family: monospace; padding: 20px; }
    h2 { color: #00ffff; }
    pre { background: #111; padding: 10px; border: 1px solid #333; }
  </style>
</head>
<body>
  <h2>🗺️ GIGA-XZDOS — Mappa Dinamica</h2>
  <pre>${JSON.stringify(state, null, 2)}</pre>
</body>
</html>
`;

fs.writeFileSync(outputPath, html);
console.log("✅ Mappa generata in panels/miniera_map.html");
