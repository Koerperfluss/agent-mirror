---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-gui-not-cli.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: feedback-gui-not-cli
description: Sascha will grafische Oberflächen, keine Terminal-Befehle — bei Tool-Bau
  immer Web-UI bauen
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_ec864b92-2403-44f6-8057-fd71047cea94
---

Sascha hat am 30.08.2026 klar gestellt (Zitat: „und was sol ich mit so einem befehl ich wil eine grafische oberfläche du trotel"): Er will **grafische Oberflächen**, keine CLI-Tools. Wenn ein Tool/Assistent gebaut wird, IMMER eine Web-UI oder native GUI bauen, nicht nur einen Terminal-Befehl.

**Why:** CLI wurde abgelehnt obwohl es funktionierte. Sascha hat ADHS — eine Chat-Oberfläche im Browser ist für ihn sofort nutzbar, ein `foerderops "Frage"`-Befehl nicht. Er braucht visuelle Schnell-Buttons und ein Eingabefeld, keine Kommandozeile.

**How to apply:** Bei Tool-Bau: Python `http.server` + HTML-Chat-UI auf localhost (wie foerderops_web.py auf Port 8765). Browser per `subprocess.Popen(["open", url])` automatisch öffnen. Dark/Gold-Design im Körperfluss-Look. Schnell-Buttons für häufige Fragen. Niemals nur CLI anbieten — mindestens Web-UI dazu liefern. Siehe [[foerderops-assistent]].
