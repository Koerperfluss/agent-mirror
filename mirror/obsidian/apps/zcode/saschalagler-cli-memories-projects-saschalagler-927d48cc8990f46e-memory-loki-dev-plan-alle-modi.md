---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-dev-plan-alle-modi.md"
stand: 2026-09-20
tags: [spiegel, zcode]
---

---
name: loki-dev-plan-alle-modi
description: PLAN „alle 5 loki-dev-Modi" (20.09.2026) steht als Datei
  ~/LOKI_DEV_PLAN_ALLE_MODI.md — wartet auf Saschas GO +
  LokiVoice-Ausbaustufen-Wahl
metadata:
  node_type: memory
  type: project
  originSessionId: sess_2879174a-220a-46e8-be58-79d65929bc01
---

Meta-Plan (20.09.2026, Schnitt-0 komplett: Sequential 3 Schritte + TodoWrite + PLAN-Tabelle + Datei): Sascha bat „plane loki-dev alle 5 Modi aktiv". Deutung: Ökosystem-weit → Kernmodus **MAP**, INIT/TAKEOVER/FINISH/BUILD laufen als Stufen.

**Datei:** `~/LOKI_DEV_PLAN_ALLE_MODI.md` (lebend, Fortschritts-Spalte).

**6 Stufen:** 1 TAKEOVER Ist-vs-Soll (10 Agenten, 17 MCPs, Skills, Explore×2) · 2 INIT deja-history+cline-session-history+investigate-first ins Skill-Routing+STANDARD-SKILLS · 3 BUILD cavecrew×3 Frontmatter `model:` (Flash) + gate-enforcer-test auf Flash (siehe [[loki-os-harness-sollstand]]) · 4 BUILD LokiVoice-Ausbaustufe · 5 FINISH Beweis-Pass (qa+reviewer) · 6 MAP beide Wayfinder-Maps syncen. Aufwand ~90–120 Min, ~0 extra Credits.

**Offene Sascha-Entscheidungen (Produkt-Hoheit, Blocker für Start):** (1) GO für den Plan · (2) LokiVoice-Ausbaustufe(n): ① Stille-Erkennung ② CDP-Browser-Fernsteuerung ③ Morgenbrief (loki-assistent) ④ iPhone-Shortcut→/ask.

**Update 20.09. Abend (Stufe 4 läuft):** LokiVoice-Prompting-Ausbau wird NICHT über diesen Meta-Plan gefahren, sondern über den autonomen Schwarm mit lebendem PLAN: **`~/loki-voice-app/PLAN.md`** (T1 Prompt-Files+PromptLoader ∥ T2 Daemon-Prompt-Quelle ✅ → T3 QA/Deploy → T4 Review → T5 Abschluss). Nutzungs-Szenarien aus dem Kanban-HTML fließen über die Whisper-Vokabular-Datei (`~/.loki/prompt/whisper-vocab.txt`) ein.

**Update 20.09. (Visualisierung + Nutzungs-Fix):** Sascha verstand nicht, was passiert → **visuelles HTML-Kanban gebaut + geöffnet: `~/LOKI_PLAN_KANBAN.html`** (4 Spalten Todo/In-Arbeit/Blockiert/Fertig, wird nach jeder Stufe aktualisiert). WICHTIG: `/kanban`-Command (Port 3484) NICHT für Plan-Sichtbarkeit nutzen — `kanban task create` startet echte Cline-Agenten mit Git-Worktrees (zu schwer); HTML-Board ist der Weg. Stufe 4 erweitert: **Nutzungs-Szenarien zuerst definieren** (am Schreibtisch Doppel-Ctrl · curl-Fallback ohne Mikro · Morgenbrief-Fluss · Whisper-Vokabular VwGH/FFG/Judicario) und **ui-ux-tester als Abnahme-Gate** einbauen — Antwort auf Saschas Frage „hast du bedacht, wie ich den Assistenten nutzen werde?"

**Update 20.09. spät — ONE-SHOT-FULL-OS-PLAN vorgelegt + ABGELEHNT:** Sascha: „spawn whole zcode sub agent team - plan everything from 0 - one shot. possible?" → 3 Explorer lieferten Fakten (Kernel 8010 läuft doch, App deployt, aber OmniRoute *:20128, 5 LegalOps-Dupes, VwGH-DB leer, kein git im Fork). Plan: P0 Sicherung (git init beide Voice-Repos, .env) · P1 Security (OmniRoute 127.0.0.1, LegalOps-Singleton, Kernel-Bind-Fix+Watchdog, omni-free-sync) · P2 Voice-Abschluss (T4/T5, Ausbaustufe ② CDP-Browser + ③ Morgenbrief) · P3 Maps/Ticket 10 Option A · P4 QA+Reviewer-Veto. AskUserQuestion (Umfang+Ausbaustufen) blieb unbeantwortet → Empfehlung Full-OS+②③ gewählt. **ExitPlanMode abgelehnt** (Sascha verstand das Ziel nicht → Wut; siehe [[sascha-arbeitsregeln-hart]]). Status: nichts ausgeführt, Plan wartet auf einfaches ja/nein.

**Why:** Endet die Session vor GO, muss der nächste Lauf NICHT neu planen — Datei + Kanban-HTML + diese Notiz sind die Basis.
**How to apply:** Bei „GO" (ggf. mit Stufen-Nr.) Datei lesen und ab Stufe 1+2 parallel fahren; Stopp-Regeln (Deploy/Löschen/push) bleiben GO-pflichtig. Verwandt: [[loki-voice-agent]], [[wayfinder-skill-konsolidierung]], [[sascha-vollzug-keine-zwischenfragen]]
**How to apply:** Bei „GO" (ggf. mit Stufen-Nr.) Datei lesen und ab Stufe 1+2 parallel fahren; Stopp-Regeln (Deploy/Löschen/push) bleiben GO-pflichtig. Verwandt: [[loki-voice-agent]], [[wayfinder-skill-konsolidierung]], [[sascha-vollzug-keine-zwischenfragen]]
