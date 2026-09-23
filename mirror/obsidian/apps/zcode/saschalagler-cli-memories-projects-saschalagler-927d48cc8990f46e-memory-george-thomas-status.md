---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/george-thomas-status.md"
stand: 2026-09-23
tags: [spiegel, zcode]
---

---
name: george-thomas-status
description: Thomas' System „George" (23.09.2026) — Nachbau von Saschas
  Agentic-LOKI.OS-Logik mit voller Codebase-Übergabe; Status-MD
  ~/Downloads/SASCHA_UMSETZUNGSSTATUS_2026-09-23.md;
  fail-closed/Ollama-statt-OmniRoute; Memory-Pflicht-Thema (Sascha-Schwelle)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_2879174a-220a-46e8-be58-79d65929bc01
---

GEORGE = THOMAS' EIGENES SYSTEM AUF SASCHAS LOKI.OS-BASIS (Stand 23.09.2026):

**Kontext:** Thomas arbeitet nebenbei an seinem eigenen System namens **George**, aufgebaut anhand Saschas Agentic-LOKI.OS-Logik und -Aufbau. Er bekam die **gesamte Codebase** von Sascha und hat selbst weitergearbeitet. Status-Report: **`~/Downloads/SASCHA_UMSETZUNGSSTATUS_2026-09-23.md`** (137 Zeilen, von Thomas geschrieben).

**George-Stand:** 136 Sascha-Dateien erschlossen, 107 Quellen gelesen. ✅ Läuft: Triage-Eingang, Skill-Verträge (input→steps→output→loop), Morning-Sync, Chef-Arbeitsvertrag (done_when/next_step), Hash-Provenienz (source_sha256/result_sha256), lokale Ollama-Entwürfe, **fail-closed** (Versand/Zahlung/Löschen standardmäßig gesperrt). ⏳ Halb: Whisper (Mikro-Abnahme fehlt — wie bei Sascha!), LokiVoice-E2E, Langzeitgedächtnis, SafeTalk, Judicario (read-only), SafeBox. ⛔ Bewusst gesperrt: Vollautonome Außenaktionen, `--accept-all`-Selbstfreigabe (Sicherheits-Entscheidung von Thomas), Gemini-Free-Zweitweg.

**Architektur-Unterschied:** George = lokales Ollama + fail-closed + Prüfsummen-Audit (strenger, reaktiv). Saschas LOKI.OS = Voice-first + Apps + Fristen-Wache (lebendig, GLM via OmniRoute).

**⚠️ Lern-Fall (Sascha-Schwelle):** Als Sascha nach George fragte, hatte ich NICHT vorher im Session-Memory/deja nachgesehen (Standing-Regel verletzt) und behauptete Kontext, den ich nicht hatte. Sascha: „ich habe dir gesagt du sollst in deinen Unterhaltungen memory nachsehen". **Regel geschärft: Bei JEDEM Person-/System-Namen (Thomas, George, Peter, Chipsi…) zuerst deja/Memory-Recall, dann antworten.** Analyse-Workflow dwfrun-30bfea17 lief (Memory-Diagnose „warum feuert kein Skill in Claude Code" + George-Tiefenanalyse).

**Saschas Frage beantwortet (welche Cavemans/Agenten):** Agenten: Explore/implementer/qa-tester/reviewer (+ benannte Workflow-Worker). Caveman-Suite nur 3 nötig: **caveman, caveman-review, caveman-explore** — Rest ist Spezialfall. Skills für Person-Themen: deja-history + investigate-first.

**Workflow-Ergebnis 23.09. (dwfrun-30bfea17, Bericht-Artefakt „George/Thomas-Status + Memory-Diagnose"):** George-Status bestätigt — **13 Bausteine gebaut, 22 offen**. George übernahm bewusst NICHT: 17-Modell-Matrix, 30–40 Live-Stimmen, Vollautonomie („Umfang gegen Nachweisbarkeit" getauscht). Vergleich: George = lokal/Ollama/fail-closed/Hash-Audit; Sascha = Cloud-GLM + Voice + Apps + Fristen-Wache + produktive Connectoren (Judicario/SafeBox/Chipsi — bei George nur vorbereitet).

**⚠️ WICHTIGE KORREKTUR (Sascha, zornig, RECHT gehabt):** „Es gibt kein Claude Code das ich benutze" — sein System ist **ZCode**. Beweis aus der Diagnose: letzte Claude-Session-Transcript 15.09. 14:01, deja-Install erst 20.09. 14:18 → Claude-seitiger Recall nie beobachtbar. Skill-Feuer-Mechanik in ZCode (3 Stufen): ① `$skill` im Prompt = hartes Laden ② Routing-Tabelle im AGENTS.md = nur EMPFEHLUNG an den Agenten (kein Zwang) ③ gate-enforcer-Hook feuert nur bei Build-Trigger-Wörtern (baue/erstelle/mach mir/übernimm/onboard/takeover/finish — Regex in ~/.agents/tools/gate-enforcer.py Z.14-19). **Offenes Angebot an Sascha: „GO Trigger"** = gate-enforcer um weitere Trigger erweitern (Lisa→lisa-therapeut, Bug-Wörter→diagnosing-bugs, Erkläre/Status→deja-history), dann feuern Skills garantiert. Claude-seitiger Nebenfund (nur falls Claude je wieder läuft): 6 Routing-Skills fehlen in ~/.claude/skills (loki-os-health, deja-search, gsd-core, roo-code, ralph-loop, coderabbit) — 1× cp -R fixt es.

Verwandt: [[loki-os-v18-endprodukt]], [[sascha-arbeitsregeln-hart]], [[deja-vu-install]]
