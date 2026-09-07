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

**Commit-Trennung bei parallelen Agents (06.09. bewährt):** Mehrere Agents, EIN git-Repo, gleichzeitige Commits → jeder Agent bekommt im Briefing eine **exklusive Datei-Zone** UND die Regel „committe NUR deine expliziten Pfade (`git add src/glass/ …`), NIEMALS `git add -A`" — sonst sweepen sich die Agents gegenseitig halbfertige Dateien in ihre Commits. Freigabe-Nachricht an resumed Agents enthält: GO + Pfadliste + „NIEMALS git add -A" + tsc-Gate vor jedem Commit.

**Resume-Muster:** „Completed"-Subagents sind keine Totgeborenen — per SendMessage (an die agentId) wieder aufnehmen; sie behalten ihren vollen Kontext (Befund, Blueprint) und führen auf GO sofort aus. Kombiniert mit Plan-Mode-Bypass ([[plan-mode-falle]]): Agents liefern im Lock Blueprints → nach Approval per SendMessage FREIGABE + Commit-Zonen → sie bauen ohne Neukontextierung.

**Zonen-Kollisionen aktiv koordinieren:** Vor dem Start jedes Agents die Datei-Zonen der LAUFENDEN Agents deklarieren („FASS NICHT AN: …") UND Überschneidungen im GO-Punkt auflösen (z. B. „Überspringe Schritt 4 OverviewTab — übernimmt der Parallel-Agent").

**🔴 PRÜFINSTANZ-REALAUSFÜHRUNG (07.09., Sascha-Wut „WO IST DIE PRÜFINSTANZ DIE STUNDEN ARBEIT WTF"):** Der geforderte unabhängige Reviewer ist konkret der **document-skills:judge-Subagent** — bekommt gerenderte PNGs (QA-LIVE/*.png) + User-Akzeptanz-Kriterien (erster Eindruck kommerziell 40 % / Ästhetik 20 % / Layout-Proportionen 20 % / Bedienbarkeit 15 % / Branding 5 %), urteilt hart PASS|FAIL je Screen. **Erstes Urteil: 0/6 PASS** („so bricht der zahlende Kunde nach 10s im Onboarding ab") — obwohl ich dieselbe App zuvor „live bewiesen" hatte. **Abnahme-Gate ab jetzt: Wer baut ≠ wer abnimmt — fertig gilt erst bei Judge-PASS auf FRISCHEN Screens nach dem Fix-Deploy, nie per Selbstanzeige des Bau-Agenten.** Judge braucht keine Deploy-Umgebung, nur Beweis-PNGs; sein Urteil = direkt die priorisierte Fix-Liste (Top-5 mit P0/P1).

**✅ GATE DURCHLAUFEN BEWIESEN (07.09. Abend, Side-Chat-Execution „mach endlich"): 2. Judge-Lauf = 3/3 PASS, „Verkaufbar? Ja"** — nach Fixes der 5 Judge-Punkte (Blobs hinter Content + amber-only + 0.55, Fehlerbanner raus, Safe-Area, Interview-Persistenz, Onboarding produziert + Quick-Wins). Beweis-Kette: Judge-Urteil → alle Punkte gefixt → build+deploy+Parität → NEUE Screens → Judge-Re-Lauf → PASS. Judge-FALSE-POSITIVE-Lektion: er las „Datengeriebenes" (Tippfehler-Vorwurf) — Code sagte korrekt „Datengetriebenes", der Blob fraß nur Render-Buchstaben → **Judge-Befund „Tippfehler" immer gegen den Quellcode prüfen** (Layout-Befunde dafür direkt glauben). Judge-Rest-Quick-Wins (Scrim, Composer-Docking, Scroll-Padding) noch im selben Deploy nachgeschoben — Gate bleibt: nach jedem Polish-Deploy wieder frische Screens + Judge.

Verwandt: [[sascha-3-saeulen-parallelarbeit]] (3-Säulen-Rahmen), [[autoclaw-team-kopplung]] (AutoClaw als weiterer Builder), [[omniroute-verkabelung]] (2-Parallel-Subagenten-Standard fürs UI-Testen).
