---
name: loki-os-ecosystem-stand
description: Agentic-OS-Gesamtinventur (20.09.2026, 3 Explorer verifiziert) — 10
  Harnesses, 1075 Skills, 21 MCPs; kritische Baustellen Kernel 8010 tot, VwGH-DB
  leer, Phantome (Phi, STANDARD-Skills, cognee)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_64b34125-9344-419d-b538-057e3e03645a
---

Systemanalyse von Saschas Agentic OS (20.09.2026, alle Fakten mit lsof/ps/ls/curl-Beweisen):

**Harnesses (alle 10):** ZCode (aktiv, AGENTS.md 18.09., 0 lokale Sessions!) · Cline (376 Sessions, 95 Skills) · Claude Code (Memory 15.09., hinkt nach) · AutoClaw (104 Skills, 8 Agenten, cron) · Antigravity (49 Extensions, 2 Projekte) · Gemini CLI · Hermes (eigenes Memory) · LM Studio (13 GB: Gemma-4-12B, GLM-4.6V-Flash-MLX) · Codex (nur installiert) · Hammerspoon (Voice-Trigger). **MCP:** 21 Server, 4 disabled/kaputt (github-Auth, gitlab-404, shopify-400, zai-vision).

**Skills gesamt 1.075:** 127 ~/.agents + 104 autoclaw + 95 cline + 749 Vault. Kopplung nur via `skillshare` + `~/.agents/skill-routing.md` (84 Zeilen). Drift: kanonische Doku (SKILL_LANDKARTE 31.08., loki-memory-sync) nennt 113/99/99 — falsch; „Phi"-Harness existiert NICHT (Phantom); `~/.agents/STANDARD-Skills`-Pfad fehlt (Referenz ins Leere); **cognee-Paket nicht installiert** (Skill tot); deja findet ZCode-Verlauf nicht (0 Sessions dort).

**Kritische Baustellen (Reihenfolge nach Risiko):** 1) OmniRoute + Kernel-Bind auf `0.0.0.0` ([[sascha-local-infra-ports]]) · 2) LOKI-Kernel 8010 läuft nicht, Watchdog fehlt → ganzes LOKI.OS nur Doku, Voice→Kernel-Kopplung (M2–M6: Second-Brain-Sitzungsdatei, voice-triage-Webhook, Prüfkopf) hat kein Ziel · 3) 4 LegalOps-Duplikate · 4) **VwGH-DB leer** (Legal-Use-Case Peter/Thomas inhaltlich tot) · 5) 3 tote LaunchAgents.

**Aktive Projekte:** ~/loki-voice (Daemon LIVE) · ~/loki-voice-app (Fork, wartet Deploy, [[loki-voice-agent]]) · ~/loki-verkaufstool (MVP fertig, eBay live) · ~/loki-assistent (assi-CLI, 08:00-Briefing) · FFG 68209806 (Upload fertig, HITL-Felder offen) · Kernel-Code ~/loki-ki/macos-app-v17/LOKI_MASTER.py v15.3.0 existiert.

**Wunsch-Befund (aus seinen Doku):** Saschas eigentlicher Traum = Stimme als Eingang ins Agentic OS: 24/7 mithören, nur antworten bei „Loki" oder belegtem Fehler, Diktat→Tasks (`~/.loki/safebox/tasks.json` + `~/loki-ki/todo.txt`), lokal/DSGVO-first, 0 € Laufkosten (SPRACHASSISTENT_ARCHITEKTUR.md §1–7, ORIGINAL_REQUEST.md R1–R3, DEEP-DIVE „Exekutivprothese").

**Kanonische Architektur-Quelle (20.09. entdeckt):** `~/Desktop/Coworkspace_Ich/LOKI_OS_CODEX_PAKET/` — CODEX_AGENT_OS_HANDOUT.md (Gesamt-Architektur: Kernel :8010 mit 25 Endpunkten, 6 Domänen-Personas P-01…W-03, 8 Domain-Tools, Inferenz-Regel „Sensibles NUR lokal", 9 Arbeitsregeln inkl. „keine parallelen Agent-Sessions auf denselben Ordnern") · LOKI_MASTER_STATUS.md (16 Projekte-Portfolio) · WAYFINDER_MAP.md (v16-Destination: bootbarer Kernel + OmniRoute + MCP-Bridge) · AUDIT/STRIX/SYSTEM_HANDBUCH. Bei LOKI.OS-Architekturfragen ZUERST dieses Paket lesen. Hinweis: Kernel-Stand dort 01.–07.09. (lief damals); heute ist 8010 tot.

Verwandt: [[loki-voice-agent]], [[sascha-local-infra-ports]], [[sascha-arbeitsregeln-hart]]
