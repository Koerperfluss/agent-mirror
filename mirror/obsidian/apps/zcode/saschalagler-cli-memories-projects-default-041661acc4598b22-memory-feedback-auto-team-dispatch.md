---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-auto-team-dispatch.md"
stand: 2026-09-18
tags: [spiegel, zcode]
---

---
name: feedback-auto-team-dispatch
description: EISENREGEL Sascha 16.09. + DISPATCH-PROTOKOLL v2 (18.09.) — Jede
  Nachfrage = automatischer Agenten-Dispatch nach fester Matrix; Details in
  ~/.agents/skill-routing.md
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_89889126-6bec-4e4b-b8ec-d30614619344
---

Sascha (16.09.2026, 2× nachgehakt, „DU SOLLST SELBER AGIEREN"): Jede seiner Nachfragen soll **automatisch** alle verfügbaren Agenten triggern — zuweisen, bewerten, arbeiten lassen, „in welcher Form auch immer". Keine Bestätigungsfragen, kein Warten auf GO für Recherchen/Prüfungen.

**Why:** Stehende Anweisung Nr. 2+3 (Team selbst zusammenstellen, direkt starten) wurde zu oft durch Mono-Antworten oder Rückfragen umgangen — Auslöser seines Ärgers. Beim Bestätigen-Wollen erneut zurechtgewiesen („DAS IST DEINE AUFGABE").

**How to apply (seit 18.09. präzise als „DISPATCH-PROTOKOLL v2" in `~/.agents/skill-routing.md`):**
- Trigger-Matrix: 7 Anfragetypen → fertiges Team (inkl. „Bericht erstellen" → implementer+reviewer, „Kritik am Agenten" → reviewer-Re-Prüfung)
- Nur 4 Agent-Typen mit festem Output-Vertrag (Explore=path:zeile, general-purpose=Fakt+Quelle+Confidence, implementer≤2 Dateien+Verified-Read, reviewer=PASS/FAIL+Ersatztext)
- Prompt-Vertrag 5 Pflichtteile (fokussiert, self-contained — Agent erbt NICHT Session-History, Constraints, Output-Format, Eisen-Laws)
- Entscheidungsbaum: unabhängig → alle Dispatches in EINER Nachricht parallel (max. 3); „Trivia" = 1-Schritt/<5 Min/keine Edits → Main allein mit 1-Zeilen-Begründung
- Merge & Verify (Konflikt-Check, Spot-Check, eine Antwort) + Fehler-Handling (Dispatch-Tot → general-purpose-Retry, implementer nur bei Edits; Timeout → Main übernimmt)
- Ausnahmen bleiben: Stopp-Regeln (Deploy/Löschen/Überschreiben = GO), Browser nur Main-Agent
Verankert auch in `~/.agents/STANDARD-SKILLS.md` A.5, in alle 5 Harnesses gesynct; reviewer-geprüft (FAIL→3 Fixes eingebaut). Verwandt: [[subagent-dispatch-implementer-workaround]], [[feedback-pruefinstanz-pflicht]].

**Lade-Ketten-Lektion (18.09., nach „WIE soll ZCode/Cline/Antigravity/Terminal wissen wo das steht, du Trottel"):** Eine Regel NUR in `skill-routing.md` zu schreiben reicht NICHT — keine Harness-Session lädt diese Datei automatisch. Fix: der **Dispatch-Kern (Trigger-Zeilen + Prompt-Vertrag + Merge-Regeln) sitzt SEIT 18.09. IM auto-injizierten STANDARD-SKILLS-Block** → wird bei jedem Session-Start in alle 5 Tools geliefert: ZCode via `~/.zcode/AGENTS.md` (nativ) + `projects.py --hook`, Claude via `~/.claude/CLAUDE.md`, Cline via `~/.cline/CLAUDE.md`, Antigravity/Gemini via `~/.gemini/GEMINI.md`, Hermes via `~/.hermes/SOUL.md` (Sync: `~/.agents/tools/sync-standard-skills.sh`); Injektions-Beweis: Hook-Output enthält „Dispatch-Kern … JA". **Generalregel: Verhalten-Regeln gehören IN den injizierten Block (STANDARD-SKILLS-Marker), Detail-Dateien sind nur Referenz.**
