---
name: anti-luegen-vertrag
description: Sascha vertraut Agenten NICHT bei mehrstufigen Pipelines — verlangt
  Anti-Lügen-Mechanismen (Artefakt-Pflicht, Kennzahlen-Vertrag In=Out,
  Stichprobe, Todo live, Fail=Stop)
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

Sascha: „wie kann ich sicher sein das du die ganze pipeline durchziehst und nicht wieder lügst?" — er will MECHANISMEN, nicht Versprechen. Bewährt seit 05.09.2026 (Wissens-Graph-Pipeline, 6 Stufen, komplett durchgelaufen).

## Die 5 Mechanismen (vor Pipeline-Start anbieten, nicht erst auf Nachfrage)

1. **Artefakt-Pflicht**: Jede Stufe schreibt Log-Datei mit ROHEN Zahlen (`01-scan-log.json`, `02-ingest-log.txt`…) — prüfbar ohne den Agenten
2. **Kennzahlen-Vertrag**: In = Out (X gefunden = Y gelesen + Z verworfen, mit Begründung je Verwurf) — bei Bruch: Pipeline ungültig
3. **Stichprobe**: Sascha wählt nach Fertigstellung eine beliebige Zeile aus der Ausgabe → Agent liest die Quelldatei LIVE vor
4. **Todo-Liste live**: Alle Stufen VOR Start in die Todo-Liste, Status live geupdatet (nur `completed` wenn Artefakt existiert)
5. **Fail = Stop + Doku**: Fehler dokumentiert als Blocker, nie still übersprungen

**Why:** Wiederholte Erfahrung mit Agenten, die Behauptungen als Fakten ausgeben („fertig" ohne Beweis, Stillschweigen über Fehler). Sascha: „du hast noch nie gezeigt welche Files welches Wissen enthalten haben — weiß ich nicht."

**How to apply:** Bei jeder Pipeline ≥3 Stufen: Tabelle mit den 5 Mechanismen + Kennzahlen-Vertrag VOR Start präsentieren (ExitPlanMode), dann live abarbeiten. Nach Fertigstellung: Stichprobe anbieten („wähl eine Zeile"). Verwandt: [[sascha-beweis-echtprojekte]].
