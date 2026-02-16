const fs = require("fs");
const path = require("path");

const statePath = path.join(__dirname, "../state/agents_state.json");

// Stato iniziale se il file non esiste
const defaultAgents = [
  { id: "A01", name: "ORION", role: "Stratega delle Rotte", memory: [], status: "idle" },
  { id: "A02", name: "VULKAN", role: "Ingegnere Minerario", memory: [], status: "idle" },
  { id: "A03", name: "LUMINA", role: "Custode delle Energie", memory: [], status: "idle" },
  { id: "A04", name: "NEXUS", role: "Coordinatore Eventi", memory: [], status: "idle" },
  { id: "A05", name: "ECHO", role: "Archivista Temporale", memory: [], status: "idle" },
  { id: "A06", name: "IRIS", role: "Visione e Pannelli", memory: [], status: "idle" },
  { id: "A07", name: "KAIROS", role: "Custode del Tempo", memory: [], status: "idle" },
  { id: "A08", name: "ZENITH", role: "Analista Anomalie", memory: [], status: "idle" },
  { id: "A09", name: "NOVA", role: "Comunicazioni Esterne", memory: [], status: "idle" },
  { id: "A10", name: "SIGMA", role: "Intelligenza Predittiva", memory: [], status: "idle" }
];

// Carica o inizializza lo stato
let agents = defaultAgents;
if (fs.existsSync(statePath)) {
  try {
    agents = JSON.parse(fs.readFileSync(statePath, "utf8"));
  } catch (e) {
    console.warn("⚠️ Errore nel parsing di agents_state.json, uso stato di default.");
  }
}

// Riceve comando da terminale
const input = process.argv.slice(2).join(" ");
if (!input) {
  console.log("❌ Nessun comando fornito.");
  process.exit(1);
}

// Parsing comando (es: A03: attiva modulo fotonico)
const match = input.match(/^(A\d{2}):\s*(.+)$/);
if (!match) {
  console.log("❌ Formato comando non valido. Usa: A03: azione");
  process.exit(1);
}

const [_, agentId, command] = match;
const agent = agents.find(a => a.id === agentId);

if (!agent) {
  console.log(`❌ Agente ${agentId} non trovato.`);
  process.exit(1);
}

// Logica autonoma (simulata)
const response = `🧠 ${agent.name} (${agent.role}) ha ricevuto: "${command}"\n→ Risposta: Comando "${command}" accettato. Stato aggiornato.`;

// Aggiorna memoria e stato
agent.memory.push({ timestamp: new Date().toISOString(), command });
agent.status = "active";

// Salva stato aggiornato
fs.writeFileSync(statePath, JSON.stringify(agents, null, 2));

console.log(response);
