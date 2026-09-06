---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/agenten-selbstueberwachung.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: agenten-selbstueberwachung
description: Sascha verlangt ein Agent-Team, das den Haupt-Agenten ÜBERWACHT —
  Standard = Orchestrator(baut+committet) + unabhängiger Reviewer(misst/nichtet,
  baut NICHT — Gewaltenteilung) + Install-Worker + ZCode als Koordinator
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

**Saschas Forderung (06.09., nach „du hast nichts umgesetzt"-Wut): „WIE ZUR HÖLLE STARTEST DU ENDLICH DAS AGENT TEAM DAS DICH SELBER ÜBERWACHT???"** — er will keine Einzel-Agent-Behauptungen, sondern eine Maschine, die sich selbst kontrolliert und sichtbar liefert.

**Warum:** Selbst-Berichte des Builders sind für ihn wertlos (siehe [[anti-luegen-vertrag]]); eine Zweit-Instanz, die unabhängig misst und verurteilt, ist der einzige akzeptierte Beweis. Parallel dazu will er den Plan als Tabelle im Chat SEHEN ([[sascha-meldung-nur-fertig]] gilt für Zwischenberichte — die Team-/Plan-Sicht ist keine Ausrede für Stillstand).

**How to apply — Team-Standard (Agent-Tool, run_in_background):**
1. **Orchestrator/Builder:** zieht Tickets aus PLAN.md/.wayfinder, baut, committet lokal (4 Stopp-Regeln: kein Deploy/Löschen/Push/>5k Credits), liefert Datei-Artefakte.
2. **Unabhängiger Reviewer (GEWALTENTEILUNG):** misst live (Screenshots, DOM-Counts, Scores 1–10), schreibt REVIEW.md mit priorisierten P1/P2-Tickets — **baut NIEMALS selbst** (wer reviewed, ändert nichts; wer baut, reviewed sich nicht selbst).
3. **Spezial-Worker** für Installationen/Langläufer (brew etc.) im Hintergrund.
4. **ZCode = Koordinator:** startet, sammelt, deployt NUR geprüfte Commits, hält [[zcode-koordinator-live-austausch]] (Sascha nie als Relay).
Bewährte Zusatzregeln: Subagent-Prompts müssen den /bin/bash-c-Workaround enthalten (zsh-ENOENT, [[zcode-offpeak-ticket-ausfall]]); Background-Logs auf Leerheit prüfen (leer = relaunchen); Berichte als Dateien im Projekt + 1-Zeilen-`open`-Befehl für Sascha.

Verwandt: [[sascha-3-saeulen-parallelarbeit]] (3-Säulen-Rahmen), [[autoclaw-team-kopplung]] (AutoClaw als weiterer Builder), [[omniroute-verkabelung]] (2-Parallel-Subagenten-Standard fürs UI-Testen).
