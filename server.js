const express = require("express");
const bodyParser = require("body-parser");
const { exec } = require("child_process");
const app = express();
const PORT = 8081;

app.use(bodyParser.json());
app.use(express.static("."));

app.post("/run-agent-command", (req, res) => {
  const cmd = req.body.command;
  if (!cmd || !/^A\d{2}:\s*/.test(cmd)) {
    return res.status(400).send("❌ Comando non valido.");
  }

  const safeCmd = `node scripts/xzdos_agent_core.js "${cmd.replace(/"/g, '\\"')}"`;
  exec(safeCmd, (err, stdout, stderr) => {
    if (err) {
      return res.status(500).send("❌ Errore esecuzione comando.");
    }
    res.send(stdout || stderr);
  });
});

app.listen(PORT, () => {
  console.log(`🚀 xZDOS Agent Server attivo su http://localhost:${PORT}`);
});
