---
app: zcode
quelle: "saschalagler/cli/artifacts/sess_5b46926c-ea38-4d93-833c-ef981b842fd5/dwfrun-5c7d545e-7421-4fd7-9174-084461b62f6a_artifact_1_1-tool-result-8ce9b403-6f9e-464e-93ec-e556becf674a.md"
stand: 2026-09-22
tags: [spiegel, zcode]
---

# Mini-Chipsi — deine lokale Rechtsrecherche (läuft)

**Adresse: http://127.0.0.1:8085** — im Browser öffnen, Frage eintippen, Suchen klicken.

- Bau: Mini-Chipsi läuft dauerhaft im Hintergrund auf http://127.0.0.1:8085 (PID 16377 in mini-chipsi/server.pid, Binding per lsof ausschließlich 127.0.0.1). Verifiziert: /api/health → {"ok":true}, Testabfrage 'Kündigungsfrist Mietvertrag Österreich' → 15 Quellen (10 Judikatur/OGH-Rechtssätze + 5 Normen, Felder typ/gericht/datum/titel/kernaussage/gz). Ollama läuft lokal, glm-5.3-flash:cloud scheiterte am Credit-Limit, daher Synthese über das lokal installierte qwen2.5-coder:7b (live getestet, Fundstellen im Prompt vorgegeben). Der Judicario-Key steht nur serverseitig in server.mjs — im ausgelieferten HTML ist weder Key noch Gateway-URL enthalten (grep-Prüfung: 0 Treffer).
- Synthese-Modus: **ollama:qwen2.5-coder:7b**
- Live-Test: ✅ echte Judicario-Quellen gekommen (15 Quellen im Test)
- Sicherheits-Review: ✅ bestanden

## Warum das heute die Lösung ist
- Chipsis Synthese-Backend bei openlaw ist ausgefallen (3 Live-Fehlversuche 14:24–14:27 bewiesen) — die RECHERCHE über denselben Gateway läuft einwandfrei, genau die nutzt Mini-Chipsi direkt.
- Sobald openlaw Chipsi repariert hat, läuft Chipsi wieder — Mini-Chipsi bleibt als lokale, mandantengetrennte Ergänzung.

## Server verwalten
- Stoppen: `kill $(cat mini-chipsi/server.pid)`
- Log: `mini-chipsi/server.log`