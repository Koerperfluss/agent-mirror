---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/claude-app-zai-setup.md"
stand: 2026-10-29
tags: [spiegel, zcode]
---

---
name: claude-app-zai-setup
description: FERTIG 30.10. — Claude Code läuft auf ZCode/GLM-Abo, OFFIZIELL von
  z.ai-Doku bestätigt; Modell-Mapping nach offizieller Empfehlung
  (Opus/Sonnet=glm-5.3[1m], Haiku=flash[1m]); z.ai-MCP-Server eingerichtet+geprüft
  (zai-mcp-server/zai-vision ✔, Remote-HTTP-Endpoint = Protokoll-Falle);
  2× e2e bewiesen; Chat bleibt Login-only; Lorenz-Handoff auf Desktop fertig
  (~/Desktop/LORENZ_HANDOFF_5_BEGRIFFE.md)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_3710694b-d1b2-4d51-bafa-02d30fb8bda5
---

Sascha will „Claude mit dem ZCode-Abo betreiben" (11.10.2026) — **ABGESCHLOSSEN 30.10.2026 (Plan approved, ausgeführt):**

**Endstand (bewiesen):**
- Endpoint-Test: `curl https://api.z.ai/api/anthropic/v1/messages` mit Key → HTTP 200, `model: glm-5.3-flash`.
- Fix ausgeführt: `ANTHROPIC_MODEL` + `ANTHROPIC_DEFAULT_FABLE_MODEL` von `glm-first` → **`glm-5.3-flash`** in `~/.claude/settings.json`. Backup: `~/.claude/settings.json.bak-20261011`.
- Claude.app neu gestartet (6 Prozesse); CLI `claude --version` → 2.1.251.
- **End-to-End-Beweis:** `claude -p "PINGPONG-Test" --model glm-5.3-flash` → antwortete „PINGPONG", Exit 0. Warnung `[claude-code:unrecognized_model]` ist harmlos (CLI prüft gegen Anthropic-Modellliste, Aufruf läuft trotzdem über z.ai).
- Claude-Desktop-**Chat** bleibt Anthropic-Login-only (technisch nicht umbiegbar) — nur Claude **Code** (CLI + Code-Bereich der App) läuft aufs GLM-Abo.
- **OFFIZIELLE Bestätigung (30.10., docs.z.ai/devpack/tool/claude):** Z.AI unterstützt Claude Code offiziell — exakt `ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic` + `ANTHROPIC_AUTH_TOKEN=<zai-key>`. Empfohlenes Mapping: `OPUS_MODEL`/`SONNET_MODEL` = `glm-5.3[1m]` (Flagship für schwere Slots), `HAIKU_MODEL` = `glm-5.3-flash[1m]` — so gesetzt (vorher stand überall flash). Zweiter e2e-Beweis nach Mapping-Fix: `claude -p` → „JA", Exit 0. **Dritter e2e-Test (30.10., von Sascha verlangt):** Begriffserklärungs-Frage (Skills/MCP/Plugin/Sub-Agent/Extension) per `claude -p` → fachlich korrekte 5-Zeilen-Antwort über das Abo, Exit 0, 5/5 deckungsgleich mit meiner Erklärung — bewährterQuick-Test: `claude -p "<Frage>"` als Abo-Live-Check.

**z.ai MCP-Server (30.10., „richte alles ein" — FERTIG):**
- **Schon installiert und VERBUNDEN** (nichts neu nötig): `zai-mcp-server` (lokal `/opt/homebrew/lib/node_modules/@z_ai/mcp-server/build/index.js`) + `zai-vision` (`npx -y @z_ai/mcp-server`) — beide `✔ Connected` in `claude mcp list`.
- **Remote-HTTP-Endpoint-Falle:** `https://api.z.ai/api/mcp/mcp_server/mcp` antwortet auf GET mit HTTP 200, aber der MCP-Handshake aus Claude Code scheitert mit JSON-RPC-Validierungsfehler („Invalid input: expected jsonrpc 2.0"). Eintrag `zai` per `claude mcp add --transport http` war tot → **wieder entfernt**. Nicht nochmal versuchen — die lokalen @z_ai/mcp-server-Instanzen sind der richtige Weg.
- **Endbeweis:** `claude -p` listete live `mcp__web-search-prime__web_search_prime` + 3× `mcp__zread__*` — Claude Code sieht und nutzt die z.ai-MCP-Tools über sein Abo, Exit 0.
- Scope-Doppel-Eintrag existiert (user: npx, project: lokaler Node-Pfad) — beide verbinden, harmlos; Warnung von `claude mcp list` ignorierbar.

**Terminal-Nutzung bestätigt (30.10., letzte Runde):** Sascha fragte „claude nutzbar im Terminal?" → JA, mit Bedienungs-Tabelle geliefert: `claude` (interaktiv), `claude -p "Frage"` (Einmal-Frage), `cd Projekt && claude` (im Projekt). Gilt automatisch nach Terminal-Neustart, nichts weiter zu tun.

**LIVE-START bewiesen (30.10., finale Runde):** Terminal mit `osascript -e 'tell application "Terminal" to do script "claude"'` geöffnet → Screenshot-Beweis: Claude Code v2.1.251, Header-Zeile **`glm-5.3-flash · /Users/saschalagler`** = läuft live auf dem z.ai-Abo. Wichtig: Die Queue-Ansicht („13 awaiting input") zeigt viele alte 429-/Fehler-Zeilen (19d/60d/83d alt) — das sind **veraltete background-agent-Reste, KEINE neuen Fehler**; nicht davon verwirren lassen. Sascha soll nur ins Fenster klicken, tippen, Enter.

**Fakten:**
- `/Applications/Claude.app` = **Claude Desktop** (`com.anthropic.claudefordesktop`, v3.6556.2, Electron).
- `ANTHROPIC_AUTH_TOKEN=cb194f3f…UIwwAP` = **identisch mit dem cline-pass-Key** in `~/.cline/data/settings/providers.json` (z.ai Coding Plan).
- Plan-Modus-Falle: 1. ExitPlanMode wurde abgelehnt → Bash komplett geblockt (auch read-only curl); 2. Einreichung mit einfachem, kurzem Plan wurde approved — Sascha versteht lange technische Pläne nicht, MENSCHI-Sprache im Plan.

**Lorenz-Handoff (29.10./30.10., FERTIG):** Sascha baut ein Handoff-Dokument für **Lorenz** (eigener Claude-Nutzer, will die 5 Begriffe Skill/MCP-Server/Plugin/Sub-Agent/Extension verstehen) — Datei liegt: `~/Desktop/LORENZ_HANDOFF_5_BEGRIFFE.md` (95 Zeilen, 4.948 Bytes, Beweis via ls/wc). Inhalt: 5 Bausteine mit Alltags-Metaphern (Rezept/Steckdose/IKEA-Paket/Praktikant/Aufsatz), „WO läuft was"-Tabelle (Skills/MCP/Sub-Agents nur im Claude-Code-Terminal, Desktop-Chat = nur Plauderfenster), Mermaid-Grafik, 5 Selbst-Check-Befehle (`claude --version`, `claude mcp list`, `ls ~/.claude/skills`, `claude -p PINGPONG`, `cat settings.json`) mit erwarteter Ausgabe, Diagnose-Tabelle, Glossar. Visual: `~/.zcode/v2/visualizations/091101e0…/lorenz-5-begriffe.html` (::visualize eingebaut). Nutzung durch Lorenz: Datei als Text in die Claude Desktop App einfügen = Erklärung; seine Checks muss er im eigenen Claude-Code-Terminal laufen lassen (dort gibt es Skills/Stecker, im Chat nicht). Auslöser: Saschas Claude-Code-Terminal-Session („claude agents"-Ansicht) hatte bereits selbst einen Lorenz-Handoff-Entwurf produziert (Write dort geblockt) — die Desktop-App-Frage („in der claude desktop app") wurde dort mit der Code-vs-Chat-Tabelle beantwortet; mein Handoff konsolidiert beides.

**web-research-team-Skill:** `/jules-meta-agent` → Command-Quelle liest `/Users/saschalagler/.claude/skills/web-research-team/SKILL.md` (Multi-Agent-Recherche-Protokoll v1.1, Iron Law „kein Fakt ohne Quelle", Modi quick/standard/deep, DIV-DEEP-Subagents max 3 parallel). Bei Aufgaben OHNE Recherche-Bedarf (z.B. Handoff-Bau) reicht Modus-Gate-Ankündigung „kein Web-Recherche-Lauf nötig — Fakten bereits belegt" + Quellen aus der Session, kein Subagent-Fan-out.

**Why:** Er fragte dreimal differently formuliert nach derselben Sache (AutoClaw, Cline, jetzt Claude) — immer dasselbe Muster: App soll sein GLM-Coding-Plan-Abo nutzen statt separatem Provider-Login.

**How to apply:** Bei „Claude geht nicht / 0 Credits" erst diese Datei lesen — Setup ist FERTIG, Rest nur bei Fehlern. Siehe [[cline-code-app-hub-1006-diagnosis]] + [[sascha-vollzug-keine-zwischenfragen]].
