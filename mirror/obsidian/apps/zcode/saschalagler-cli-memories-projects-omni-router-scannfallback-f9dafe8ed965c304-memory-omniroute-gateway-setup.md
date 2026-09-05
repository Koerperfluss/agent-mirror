---
app: zcode
quelle: "saschalagler/cli/memories/projects/omni-router-scannfallback-f9dafe8ed965c304/memory/omniroute-gateway-setup.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: omniroute-gateway-setup
description: OmniRoute v3.8.49 läuft auf localhost:20128 als
  Zero-Key-Free-Routing-Gateway; omni-check-Checker repariert und täglich 09:00
  via launchd
metadata:
  node_type: memory
  type: project
  originSessionId: sess_fea88d05-e278-4c57-90bf-e7e85a6eb5e2
---

OmniRoute (npm-Paket `omniroute`, v3.8.49) wurde am 2026-08-20 global installiert und als Gateway auf `http://localhost:20128/v1` betrieben (Start: `omniroute`). Modell `auto` liefert keyless Gratis-Inferenz über Free-Provider (verifiziert). Der Ordner `~/Desktop/OMNI-Router:ScannFallback` enthält den Werkzeugkasten: `omni_model_checker.py` (Alias `omni-check`, repariert — fehlende Funktion `lese_cline_provider` nachgerüstet, Gratis-Filter-Bug auf falscher JSON-Ebene gefixt, hardcoded Z.AI-Key entfernt), täglich 09:00 via LaunchAgent `com.sascha.omni-check.daily`.

**Why:** Sascha will täglich ohne manuelle Prüfung wissen, welche Gratis-Modelle leben und wo noch Kontingent frei ist; OmniRoute übernimmt das Fallback-Routing automatisch.

**How to apply:** Für Status-Fragen: `omni-check` laufen lassen bzw. `OMNI_STATUS_BERICHT.md` lesen. Z.AI-Coding-Plan-Nutzung ist NICHT per API abfragbar (nur Web: z.ai/manage-apikey/coding-plan/personal/usage) — keine Endpunkt-Versuche wiederholen. Cline-Pass-Account-Endpoint antwortet 404, Fallback ist Log-Analyse. OmniRoute ist nicht als Autostart eingerichtet — muss per `omniroute` gestartet werden.

Update 2026-08-20 (GLM-First): Z.AI-Key als Provider `zai` registriert; Priority-Combo **`glm-universum`** erstellt (zai/glm-5.2 → openrouter/z-ai/glm-5.2:free → auto); Cline steht auf `glm-universum` (vorher `auto`). Verifiziert via `X-OmniRoute-Decision: strategy=priority; provider=zai`. 36 GLM-Modelle im Pool. Früher am selben Tag: OpenRouter-Provider `openrouter-cline` (Pool 1.099 Modelle), API-Key `lokal-setup` (chat+manage) in `/tmp/omni_api_key.txt`, MCP aktiviert (mcpTransport=streamable-http) + in Claude Code registriert (109 Tools), Cline-Base-URL ohne `/v1`, Dashboard-Passwort noch `CHANGEME`.

Entscheidung 2026-08-20: Sascha hat das optionale Custom System Prompt (Dashboard → Endpoints) mit „nein" abgelehnt — KEIN globaler System-Prompt in OmniRoute setzen und nicht erneut anbieten.

Update 2026-08-22 (Repair-Session): Ordner umgezogen nach `~/Desktop/Coworkspace_Ich/OmniRoute/OMNI-Router:ScannFallback` (alte Desktop-Pfade tot — Plist + zshrc-Alias repariert). Gateway läuft jetzt PERMANENT via LaunchAgent `com.sascha.omniroute` (RunAtLoad+KeepAlive, Logs `~/.omniroute/logs/launchd*.log`) — kein manueller Start mehr nötig. Dashboard-Passwort geändert (kein CHANGEME mehr). Verkabelungs-Stand: Claude Code global (env ANTHROPIC_BASE_URL + MCP omniroute global in ~/.claude.json), Cline = openai-compatible/glm-universum (Backups `*.backup_20260822_*`), Codex config.toml auf 20128 verkabelt (CLI aktuell NICHT installiert — greift bei Re-Install), Gemini CLI: omniroute als MCP-Server in ~/.gemini/settings.json (Modell-Ebene nicht umbiegbar, Google-API-Key-Auth), Antigravity + LM Studio nicht verkabelbar (serverseitig gesperrt bzw. Provider keine Consumer). ZCode bleibt bewusst DIREKT auf Z.AI-GLM (OmniRoute nur Fallback-Ebene, Sascha-Entscheidung 22.08.). Env `OMNIROUTE_API_KEY` in ~/.zshrc exportiert.
