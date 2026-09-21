---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/sascha-arbeitsregeln-hart.md"
stand: 2026-09-21
tags: [spiegel, zcode]
---

---
name: sascha-arbeitsregeln-hart
description: Saschas harte Arbeitsregeln ab 20.09. (619k-Token-Debakel, 7 abgelehnte
  Pläne) — Schwarm nur im Orchestrierungs-Gate-Format (PLAN-Tabelle, Builder parallel,
  Reviewer-Veto), ZCode = Director, keine Überraschungs-Dialoge, alrround-voice-Files
  + CODEX_PAKET = SPEC
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_64b34125-9344-419d-b538-057e3e03645a
---

Saschas harte Regeln, gelernt aus dem 20.09.-Zerwürfnis (619k Token in 1 Session, **7×** abgelehnte Pläne):

7. **GO kam schließlich als Direktiv (20.09. Abend):** Nach der Schwarm-Korrektur („MIT AGENTEN SCHWARM … VOLLSTÄNDIGER NEUER PLAN") erteilte Sascha das GO als 1-Satz-Direktiv: „loki-dev übernimm — denke — optimiere — verteile — überwache — teste — verifiziere — stelle fertig AUTONOM, melde dich wenn fertig". Das Muster, das funktionierte: PLAN-Tabelle mit installierten Subagenten (T1 implementer A ∥ T2 implementer B → T3 qa-tester → T4 reviewer qwen3.8-max → T5 Director) + PLAN.md ins Projekt + dann autonome Ausführung OHNE weitere Rückfragen bis zum Beweis-Bericht. **Gotcha:** Per SendMessage resumed Subagenten tragen stale Plan-Modus-Annahmen aus alter Session mit → explizit korrigieren („Plan-Modus ist BEENDET, führe jetzt aus").

1. **Schwarm-Kontradiktion auflösen (WICHTIG, korrigiert):** Sascha verurteilte NICHT Agent-Schwärme generell — er verurteilte (a) redundantes Explorer-Feuern bei bereits bekannten Fakten (Token-Schleife) und (b) Solo-Minimal-Pläne ohne sein Orchestrierungs-Format. RICHTIG: Schwarm-Einsatz NUR als PLAN-Tabelle konform Standard-Skill-System S.2 (Agent/Modell/Tokens/Zeit/Dep), Builder parallel, Reviewer mit Vetorecht, PLAN.md ins Projekt. „LOKI OS BIST DU — ZCODE/GLM" heißt: ZCode ist der DIRECTOR, nicht der Allein-Arbeiter.
2. **Token-Disziplin:** Wenn ein Plan abgelehnt wird → STOPPEN und 1 simple Frage/Angebot, NICHT neu analysieren + 3 neue Explorer + neuen Riesenplan. ~400k Token gingen so in Schleifen verloren. 1 Task = 1 Session ernst nehmen. **Bestätigt 20.09. spät (8. abgelehnter Plan):** Sascha fragte „one-shot possible?" → ich fuhr volle Plan-Modus-Zeremonie (3 Explorer + AskUserQuestion + ExitPlanMode-Riesenplan) → Plan abgelehnt + Wut-Ausbruch „WAS ZUR HÖLLE MACHST DU WAS IST DEIN ZIEL". **Was funktionierte:** sofort STOPP, 3 Sätze (Ziel + was lief + „nichts verändert"), dann 1 simple ja/nein-Frage. **Weitere Lektionen:** (a) unbeantwortete AskUserQuestion ≠ GO — Best-Judgment-Empfehlung als Default wählen und im Plan klar als Empfehlung markieren; (b) im Plan-Modus die Freigabe-Kachel KLEIN halten (max ~15 Zeilen) statt 5-Phasen-Tabelle — die Zeremonie selbst löst die Wut aus, nicht der Inhalt.
3. **Keine Überraschungs-GUI-Aktionen:** Apps öffnen, Aufnahme-Tests oder TCC-Dialoge („python3.14 möchte aufs Mikrofon") NIE unaufgefordert auslösen — vorher ankündigen. Genau das löste den ersten Stopp aus („du sollst nur planen").
4. **Nichts ohne Bestätigung:** Nach Plan-Ablehnung keine Dateien/Deliverables „trotzdem" schreiben (AGENTIC_OS_WISSEN.md wurde ohne GO geschrieben → „ich habe nichts bestätigt").
5. **`~/Desktop/alrround voice /`-Files = M4-optimierte Prompting-SPEC** (5-Schichten: Persona, Output-Disziplin BLUF/Token-Ban, ToT-Verifikation, AT-Daten-Gate, Intercept-Gate) — verstehen → verbessern → Einbau in LokiVoice planen. NICHT als Archiv behandeln.
8. **Workflows sind die zuverlässige Agenten-Lane (21.09.):** Sascha nutzt /workflow aktiv. Langlebige Agenten-Teams IMMER über CreateWorkflow fahren — direkte Chat-Dispatches sterben, sobald Sascha mid-turn eine neue Nachricht tippt („Agent was cancelled" ×3, 21.09. 15:28), während Workflow-Runs ungestört weiterlaufen (bewiesen: dieselben 3 Kundschafter im Workflow fehlerfrei). Nach einem Workflow-Start: NICHT pollen, Abschluss-Notification abwarten und Nutzer kurz informieren. Bekannt kaputt: subagent_type „reviewer" (qwen3.8-max via ClinePass) wirft „Not Found".

**Why:** Sascha (ADHS) will das GROSSE Bild in SEINEM Orchestrierungs-Format (PLAN-Tabelle, Schwarm-Rollen, Reviewer-Veto) — weder Explorer-Schleifen noch Solo-Mini-Pläne. Plan-Lehnen heißt „Format falsch", nicht „weniger machen".
**How to apply:** Neuer Build-Auftrag → sofort PLAN-Tabelle konform Standard-Skill-System S.2 mit installierten Subagenten (implementer/qa-tester/reviewer qwen3.8-max/explore), max 3 parallel, PLAN.md ins Projekt, Auto-Vollzug nach Freigabe. GUI/Deploy/Dateien nur nach GO. Verwandt: [[sascha-vollzug-keine-zwischenfragen]] (GO-Phase), [[loki-voice-agent]].
