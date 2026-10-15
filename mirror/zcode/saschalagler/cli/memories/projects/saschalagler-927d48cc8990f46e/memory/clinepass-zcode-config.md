---
name: clinepass-zcode-config
description: ClinePass-Flatrate in ZCode+Cline (15.10.2026) — 12-Modelle-Config,
  Roh-ID-Falle, Quota-Architektur, 9-App-Sync-Verdict, offene Punkte +
  Fertigmach-Workflow dwfrun-af3116d0
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ec044ff8-4d82-412d-b9db-4db95e4da190
---

**ClinePass in ZCode/Cline — Stand 15.10.2026 (Sascha: „mach alles fertig bis morgen, full gas")**

**Config (bewiesen):** `~/.zcode/v2/provider_config.json` = die LIVE-Datei (UI-Edits schreiben nur sie, nicht die alte v2/config.json): Provider „ClinePass", Base `https://api.cline.bot/api/v1`, Format openai-chat-completions, **12 cline-pass/-Modelle** (kimi-k3, qwen3.8-max, glm-5.3, glm-5.3-flash, deepseek-v4-pro, deepseek-v4.1-flash, qwen3.7-max 262k, qwen3.7-plus, mimo-v2.5, mimo-v2.5-pro, minimax-m3, muse-spark-1.3-contributor), 12 Model-Regeln (Context 1M/262144, Max-Output 32000, Input-Types pro Handbuch, Structured output + Mid-conversation; Muse nur Structured). Saschas Key `sk_e399e2086e…` (curl → 429 = Auth gültig). Backup `AGENTS.md.bak-clinepass-20261015…`.

**Roh-ID-Falle (wichtigster Befund):** Gateway-Katalog listet 463 Modelle — nur IDs MIT Präfix `cline-pass/` buchen die Flatrate; Roh-IDs (`z-ai/glm-5.3`, `moonshotai/…`, 417 in der alten v2/config.json) = Pay-as-you-go → „Insufficient balance −0,09 $". Legacy-Eintrag in alter v2/config.json ist inaktiv (ZCode 3.15 liest sie nicht), bewusst nicht angefasst.

**Quota-Architektur:** 3 Schranken (5h-Rolling-Fenster, Woche, Monat), Hard-Cutoff ClinePassLimitError, KEIN Upgrade/Tier/Token-Add-on; Yearly 79,92 $ = nur −33 % Preis, KEINE mehr Tokens. Flash-Modelle (GLM-5.3-Flash, DeepSeek V4.1 Flash) brennen Quota am langsamsten.

**9-App-Sync-Verdict:** ClinePass gehört NUR in ZCode + Cline; Claude.app braucht Anthropic-Endpoint (z.ai api/anthropic), Antigravity/AutoClaw = z.ai, Eigent = nur Browser-Backend, Docker = MCP-Gateway, LM Studio/Ollama getrennt halten. Cline-Desktop: cline-pass-Provider + lastUsed cline-pass, Default cline-free/mimo-v2.6-flash (spart Pass-Quota).

**Offen (per Konversationstabelle 15.10.):** ClinePass echter Chat-Test (Limit-Reset ~00:10 nach 429) · LOKI-Kernel :8010 down · LegalOps-MCP :7070 4× dupliziert · Sigma :10345 down · AutoClaw-CLI fehlt im PATH · Atomic-Hermes-Entfernung wartet auf GO · AutoClaw-Cron Night-Shift + Hermes Learning-Loop „geplant" · Dauermutten: GO-Wecker, Deutsch-Patch, „GO doku-fix" (assi-README).

**Fertigmach-Workflow:** dwfrun-af3116d0 „ClinePass + System fertig machen" (15.10. ~23:30 gestartet, Script `.zcode/workflow-drafts/ClinePass--System-fertig-machen.dwf.ts`): Unterhaltungs-Extrakt (Paste-File 2291 Zeilen) → 3 Prüfer (clinepass/infra/skills, nur-lesend) → Fixer mit tar-Backup nach `~/.zcode/backups/cleanup-20261016/` (nie löschen/deployen; Skill-Konsolidierung „managing-skills einpflegen" war 6× an Hub-1006 gescheitert, nie gelaufen) → Fertigmeldung `~/Desktop/FERTIGMELDUNG_2026-10-16.md` mit frischer Beweis-Gegenprüfung. GO-Liste/Blockiert nur gelistet, nie ausgeführt. **Workflow-Fakten:** läuft mit Default **8 parallel** — Saschas „keine 3-Sperre, du Trottel" war gegen das nie aktive max_concurrency=3 im Create-Call gerichtet; AmendWorkflow-Retune meldete „already runs at default (8)". Compile-Falle: typografische öffnende Anführungszeichen `„` + ASCII-`"` als Schluss reißen TS-Strings.

Link: [[sascha-local-infra-ports]] · [[cline-code-app-hub-1006-diagnosis]] · [[autoclaw-sprache-translocation-fix]] · [[loki-konsolidierung-merge-matrix]]
