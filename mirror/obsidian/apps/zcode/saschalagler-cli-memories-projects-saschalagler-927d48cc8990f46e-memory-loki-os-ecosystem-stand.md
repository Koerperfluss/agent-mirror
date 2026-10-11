---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-os-ecosystem-stand.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: loki-os-ecosystem-stand
description: Agentic-OS-Gesamtinventar — 20.09. Vollanalyse (10 Harnesses, 1075
  Skills, 21 MCPs) + 05.10. Re-Count (466 Skills/3 Roots, 22 MCPs) + 11.10.
  Anthropic-Plugin-Verdict (0 von 26 nötig) + 11.10. Skill-Audit FINAL (1211
  Dateien/638 Uniques) + VOLLZUG: alle 3 GOs ausgeführt (107 MB Cache
  frei, 5 Skill-Paare synchronisiert, alpha-Leak weg; Backup
  ~/.zcode/backups/skill-aufraeumen-20261011) — offen nur: tote Plugins
  deaktivieren, Kanon-Root-Entscheid, Wartungs-Routine —
  Ladezeit-Behauptung RETRAKTIERT (Harness dedupliziert beim Laden) —
  Workflow-Killer #1 = leerer Start-Plan, subagent_model immer explizit
metadata:
  node_type: memory
  type: project
  originSessionId: sess_64b34125-9344-419d-b538-057e3e03645a
---

Systemanalyse von Saschas Agentic OS (20.09.2026, alle Fakten mit lsof/ps/ls/curl-Beweisen):

**Harnesses (alle 10):** ZCode (aktiv, AGENTS.md 18.09., 0 lokale Sessions!) · Cline (376 Sessions, 95 Skills) · Claude Code (Memory 15.09., hinkt nach) · AutoClaw (104 Skills, 8 Agenten, cron) · Antigravity (49 Extensions, 2 Projekte) · Gemini CLI · Hermes (eigenes Memory) · LM Studio (13 GB: Gemma-4-12B, GLM-4.6V-Flash-MLX) · Codex (nur installiert) · Hammerspoon (Voice-Trigger). **MCP:** 21 Server, 4 disabled/kaputt (github-Auth, gitlab-404, shopify-400, zai-vision).

**Skills gesamt 1.075:** 127 ~/.agents + 104 autoclaw + 95 cline + 749 Vault. Kopplung nur via `skillshare` + `~/.agents/skill-routing.md` (84 Zeilen). Drift: kanonische Doku (SKILL_LANDKARTE 31.08., loki-memory-sync) nennt 113/99/99 — falsch; „Phi"-Harness existiert NICHT (Phantom); `~/.agents/STANDARD-Skills`-Pfad fehlt (Referenz ins Leere); **cognee-Paket nicht installiert** (Skill tot); deja findet ZCode-Verlauf nicht (0 Sessions dort).

**Kritische Baustellen (Re-Scan 20.09. Abend, 3 Explorer des One-Shot-Plannings):** 1) OmniRoute bindet weiter `*:20128` (LAN-offen, Security #1, mehrfach in Saschas Docs CRITICAL) · 2) **Kernel 8010 LÄUFT JETZT DOCH** (Python PID 8933, 8 h, `localhost:8010` — korrigiert früheren Tot-Befund!) ABER: kein Watchdog/LaunchAgent, nur manueller Prozess; Code `LOKI_MASTER.py:894` bindet `0.0.0.0` (künftige Starts wären LAN-offen) · 3) **5× LegalOps-Duplikate** (4× loki_legal_ops_mcp_server.py PIDs + NativeLegalOps.app, trotz disabled-plist) · 4) **VwGH-DB leer** (`~/loki-ki/data/vwgh_erkenntnisse/` = 0 B seit Mai) · 5) tote LaunchAgents: omni-free-sync Exit 1; Chrome CDP 9222 tot. M2–M6-Roadmap (Voice→Kernel) Quelle: `~/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO /Judicario_Sacha_Mac/chipsi-safetalk/SPRACHASSISTENT_ARCHITEKTUR.md:138-143` (M1 lokale Transkription · M2 Second-Brain-Sitzungsdatei · M3 Prüfkopf Judicario · M4 Melde-Report · M5 Frage-mich · M6 Cloud-Fallback).

**Aktive Projekte:** ~/loki-voice (Daemon LIVE) · ~/loki-voice-app (Fork, wartet Deploy, [[loki-voice-agent]]) · ~/loki-verkaufstool (MVP fertig, eBay live) · ~/loki-assistent (assi-CLI, 08:00-Briefing) · FFG 68209806 (Upload fertig, HITL-Felder offen) · Kernel-Code ~/loki-ki/macos-app-v17/LOKI_MASTER.py v15.3.0 existiert.

**Wunsch-Befund (aus seinen Doku):** Saschas eigentlicher Traum = Stimme als Eingang ins Agentic OS: 24/7 mithören, nur antworten bei „Loki" oder belegtem Fehler, Diktat→Tasks (`~/.loki/safebox/tasks.json` + `~/loki-ki/todo.txt`), lokal/DSGVO-first, 0 € Laufkosten (SPRACHASSISTENT_ARCHITEKTUR.md §1–7, ORIGINAL_REQUEST.md R1–R3, DEEP-DIVE „Exekutivprothese").

**Kanonische Architektur-Quelle (20.09. entdeckt):** `~/Desktop/Coworkspace_Ich/LOKI_OS_CODEX_PAKET/` — CODEX_AGENT_OS_HANDOUT.md (Gesamt-Architektur: Kernel :8010 mit 25 Endpunkten, 6 Domänen-Personas P-01…W-03, 8 Domain-Tools, Inferenz-Regel „Sensibles NUR lokal", 9 Arbeitsregeln inkl. „keine parallelen Agent-Sessions auf denselben Ordnern") · LOKI_MASTER_STATUS.md (16 Projekte-Portfolio) · WAYFINDER_MAP.md (v16-Destination: bootbarer Kernel + OmniRoute + MCP-Bridge) · AUDIT/STRIX/SYSTEM_HANDBUCH. Bei LOKI.OS-Architekturfragen ZUERST dieses Paket lesen. Hinweis: Kernel-Stand dort 01.–07.09. (lief damals); heute ist 8010 tot.

**Re-Count 05.10.2026 (Bash-verifiziert, nach Workload-Woche):** 466 Skills in 3 Roots (zcode 201 / agents 144 / autoclaw 121) · **134 Duplikate** zwischen zcode- und agents-Root · 22 MCP-Server in ~/.mcp.json (MCP_DOCKER, chrome-devtools, claude-mem, context7, deja, desktop-commander, filesystem, firebase, firestore, github, gitlab, google-cloud-storage …) · 15 Hook-Regeln (~/.claude/settings.json). **Modell-Lage (Workflow-killer #1):** Session-Modell = zai-start-plan GLM-5.3-Flash mit LEERER Quota (code 1005, network_error) — Start-Plan-gebundene Workflows sterben; **`zai-api/GLM-5.3-Flash` = funktionsfähiger Fallback** (bewiesen in 2 großen Workflows); Individual-Plan-Modell tauchte zwischenzeitlich aus der Modell-Liste ab. **Fix-Muster:** bei jedem CreateWorkflow `subagent_model` EXPLIZIT setzen + Zeitbudget-Hinweis in jeden Agent-Ask (verhindert Web-Recherche-Hänger 20–90 min).

**Anthropic-Plugin-Analyse 11.10.2026 (Claude-Anpassungen-Seite vs. LOKI-Skills):** Claude-Verzeichnis = 276 Skills (3 Sascha-eigene: sascha-precision-mode, tool-monetarisierung, technischer-erklarer-style [deaktiviert] + 273 von Anthropic/Partnern) · 32 Konnektoren (25 verbunden, judicario + MCP_DOCKER + memory = Kerne) · 26 Plugins. **Verdict: 0 von 26 Plugins nötig** — Legal (US-Recht) verliert gegen judicario/loki-legal-ops (AT/DE/CH), Engineering/Productivity/Search verliert gegen coderabbit/deja/loki-brain; einziger Testkandidat = Data-Plugin (nur Skills, kein MCP); Empfehlung: nur Supabase-Konnektor verbinden (falls Körperfluss/ATLAS Supabase nutzen — ungeklärt). Vergleichs-Dashboard: **~/Desktop/ANTHROPIC_VS_LOKI_SKILLS_2026-10-11.html**; Quell-Paste: ~/.zcode/tmp/paste-attachments/2026-10-11/pasted-text-20261011-121026-cb42efe4.txt (1631 Zeilen).

**Skill-Audit-Workflow 11.10. (ABGESCHLOSSEN + nachkorrigiert):** Nach Sascha-Vorwurf „kein Plan, kein investigativ Team" → Workflow dwfrun-58c1fba0 (Fehler: Subagenten-Name „Ermittler·skills" doppelt — computed names nötig in fan-out!) → amend → dwfrun-d33b58c0 → Sascha-Settings-Änderung im GUI (Flash$low, max 3 parallel) → superseded → **dwfrun-fb29e93d FERTIG** (kurzer Quota-Stopp code 1308 „5h limit, Reset 23:25" lief von selbst durch). Deliverable: **~/Desktop/LOKI_SKILL_AUDIT_2026-10-11.md** (gegengelesen + 2. Nachmess-Welle). **Ergebnisse:** 1211 SKILL.md gescannt (zcode 690 / agents 142 / cache 379), eff. ~638 Uniques · **Plugin-Cache-Altversionen ≈670 Dateien / ≈111 MB** (GO 1, reiner Cache, ~0 Risiko) · **135 Namenspaare zcode×agents: 130 byte-identisch, 5 ABWEICHEND** (qa, projects, lisa-therapeut, obsidian-second-brain, ios-swift-development — GO 2, Kanon-Root je Skill klären; `qa` weicht auch gstack vs .agents, md5 d36b8c… ≠ 9c2626…, Sascha muss sagen welche Version gilt) · **gstack: 547 SKILL.md = Symlink-Farm-Artefakt** (Hidden-Roots .agents/.cursor/.opencode… sind Symlinks, nur 1 reale Kopie je Skill — „54×9-Kopien" war falsch; NICHT konsolidieren, das ist gstacks eigener Tool-Interop) · test/fixtures-Leak nur 2 Dateien (GO 3, aus Skill-Scan ausschließen). Korrekturen Sascha: run-fpa/write-research liegen unter **zcode-plugins-official** (nicht claude-), write-research = 17 Skills, docx/pdf/pptx/xlsx je 2 Versionen. Workflow-Lektionen: Subagenten-Namen im fan-out IMMER mit Index uniqueness-sicher bauen; GUI-Settings-Änderung am laufenden Run = supersede mit Cache-Import. **RETRAKTION 11.10. (Sascha-Sritte berechtigt):** die Behauptung „1211 Skills werden pro Session geladen → Ladezeit-/Context-Kosten" war NICHT gemessen und zurückgezogen — der Harness dedupliziert Dubletten beim Laden (Session-Liste zeigt je Skill 1 Eintrag); der einzige belegte funktionale Risk-Punkt = die 5 inhaltlich abweichenden Paare (inkl. `qa`). 1211/638 = nur Festplatten-/Aufräum-Fakten, keine Performance-Behauptung mehr.

**VOLLZUG 11.10. spät (Sascha: „ja bitte mach fertig" = GO für alle 3,Backup-first ausgeführt):** GO 1 Plugin-Cache **276 MB → 169 MB (107 MB frei**, 27 Altversions-Ordner) · GO 2 die 5 abweichenden Paare per mtime auf NEUERE Version synchronisiert (qa/lisa-therapeut/ios-swift-development = .zcode-Seite neu, projects/obsidian-second-brain = .agents-Seite neu) → `diff -rq` danach **0 Abweichungen** · GO 3 Phantom-Symlink `.zcode/skills/alpha -> gstack/test/fixtures/...` entfernt (gstack/tests unberührt, .zcode/skills = 203 Einträge). **Backup: ~/.zcode/backups/skill-aufraeumen-20261011/** (5 Original-Paare). Vollzug als Abschnitt 6 im Audit-Bericht dokumentiert. Weiter offen (Sascha-Entscheid): gitlab/example-plugin in Plugin-Config deaktivieren · langfristig EIN Kanon-Root (.zcode vs .agents) statt Spiegel · Wartungs-Routine aus managing-skills+writing-great-skills.

Verwandt: [[loki-voice-agent]], [[sascha-local-infra-ports]], [[sascha-arbeitsregeln-hart]], [[pflicht-ablauf-plan-sichtbar]]
