---
app: zcode
quelle: "saschalagler/commands/init.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
description: Vermisst Modell-, Provider-, MCP-, Skill- und Umgebungsstatus + aktiviert Prompt-Guidelines
---

Führe die Umgebungsmessung aus und gib EINEN Report:

1. `cat ~/.zcode/cli/config.json` — aktive Hooks/MCP-Plugins
2. `curl -s localhost:20128/v1/models | head -40` oder `omni-health`-Check — OmniRoute-Gateway + Modelle
3. Skill-Zähler: `find ~/.agents/skills -maxdepth 2 -name SKILL.md | wc -l`
4. Agenten: `ls ~/.zcode/agents/`
5. Ports: `lsof -iTCP -sTCP:LISTEN -P | grep -E '8010|8765|20128|3484'`
6. Lese `~/.agents/STANDARD-SKILLS.md` Abschnitt D (GLM-Pro-Betrieb).

Output (ADHS): Tabelle | Komponente | Status | Wert | — dann aktiviere für diese
Session: karpathy-guidelines (surgical changes, verifizierbare Kriterien),
ponytail (Minimalismus), i-have-adhd (BLUF). Schliesse mit: Quota-Rest
(providers-Screenshot bzw. letzte bekannte Werte) und 1 Empfehlung für
schnellste Ausführung (Flash vs. Pro).
