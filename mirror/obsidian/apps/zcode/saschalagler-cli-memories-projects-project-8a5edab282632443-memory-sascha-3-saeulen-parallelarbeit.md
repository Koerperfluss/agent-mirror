---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/sascha-3-saeulen-parallelarbeit.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: sascha-3-saeulen-parallelarbeit
description: Saschas ATLAS-Arbeitsrahmen = 3 Säulen (1 Planung/Userflow, 2 App-Dev
  iOS/Android/Web, 3 Research/Wissensanalyse) — Wut-Trigger: geplante Sachen nicht
  ausgeführt, Doppelarbeit; Rezept: ausführen ODER sofort fähige Subagents (Agent-Tool,
  background) parallel draufsetzen; SSD-Konsolidierungs-GO 06.09. erteilt
metadata:
  type: feedback
---

Sascha formulierte es selbst (06.09., wütend): „1) planung kompletter app, funktion userflow … 2) app dev entwicklung ios android web 3) research wissenanalyse sammlung planung". Das ist sein permanenter Rahmen für ATLAS — jede Arbeit einer dieser 3 Säulen zuordnen.

**Warum:** Sein Wut-Ausbruch galt NICHT fehlendem Plan, sondern **nicht ausgeführten Plänen**: „DU HAST ALLES GEPLANT ODER NICHT ?? WENN NICHT SETZT SOFORT FÄHIGE AGENTS DARAUF AN" + „ARBEITEST DOPPELT DREIFACH" + „DEINE AUFGABE WAR ES ALLE FILES AUF MEINER SSD ZU VERSCHIEBEN DU HAST NICHTS DAVON GETAN". Doppelarbeit und alte Versprechen (SSD-Konsolidierung, Wayfinder-Aufnahme), die monatelang auf dem Papier blieben, sind seine größten Vertrauensbrecher.

**How to apply:**
1. Bereits geplante/versprochene Missionen VOR neuen Ideen abarbeiten — Wayfinder `.wayfinder/`-Tickets sind die Wahrheitsquelle ([[atlas-master-app-verhaeltnis]]).
2. Wenn eigene Kapazität fehlt: **sofort Subagents via Agent-Tool starten (run_in_background), parallel mehrere Säulen bedienen** — das akzeptiert er ausdrücklich („SETZT SOFORT FÄHIGE AGENTS DARAUF AN"). Bewährt 06.09.: SSD-Konsolidierer + Flowchart-Gap-Analyst parallel, während AutoClaw T-A2 baute und ZCode selbst T-A10 deployte.
3. Subagent-Prompts SELBST-ENTHALTEND schreiben: Ziel + Regeln + DONE-WHEN + Shell-Hinweis `/bin/bash -c '…'` (zsh-ENOENT betrifft auch Subagents, [[zcode-offpeak-ticket-ausfall]]) + Anti-Lügen-Log-Pflicht ([[anti-luegen-vertrag]]).
4. **SSD-Konsolidierungs-GO (06.09. explizit):** alle verstreuten Atlas-Wissens-Dateien in `~/Desktop/Coworkspace_Ich/atlas + pliability /SSD-KONSOLIDIERUNG/` VERSCHIEBEN (mv, nie rm; Duplikate nach `_DUPLIKATE/`); verboten: ~/ATLAS_MASTER (live), cali-coach-atlas-final (git-Projekt), ~/Library, .git, node_modules. Verwandt: [[atlas-wissens-graph]] (4228-Dateien-Inventar als Basis), [[omniroute-verkabelung]] (Team-Regeln).
5. **„WO IST DAS TO-DO?" → PLAN.md zeigen, nicht neu erklären (06.09. Abend):** Sascha verlangt EINE sichtbare Liste für alles. Antwort-Artefakt: **`~/ATLAS_MASTER/app/PLAN.md`** (committed) = DIE lebende Liste — 3 Säulen als Tabellen, je Zeile: Stufe | Agent | Status (⬜🔧✅🔴) | Beweis + „Roter Faden bis verkauft" + seine nur-2-User-Punkte. Bei jeder „wo ist die Liste"-Wut: PLAN.md aktualisieren (echte Zahlen der Agent-Logs eintragen) + committen, statt eine neue Übersicht zu bauen. Vierte Bewährung des Parallel-Musters: **4 Ströme gleichzeitig** (Agent-SSD-Konsolidierer + Agent-Flowchart-Gap + AutoClaw T-A2 + ZCode T-A10 deploy). Konsolidierer-Zielstruktur live bewiesen: `SSD-KONSOLIDIERUNG/{01_Alt-Projekte,02_Atlas-Cali-Plan,03_Downloads,04_Einzeldateien,_DUPLIKATE}/` stand nach Minuten.
6. **Abschluss-Beleg des Musters (06.09. Nacht — alle 3 Säulen lieferten am selben Abend):** Gap-Agent 7✅/6🟡+Tickets 14/15 · SSD-Agent **fertig: 83 verschoben/94 Dup/16 übersprungen/0 Fehler, Log 237 Zeilen** (Saschas Stichproben-Klausel erfüllbar) · AutoClaw T-A2 komplett + Team-Merge live (1/20-Zähler) · ZCode selbst: T-A8 CoT-Wiring + T-A10 Branding + P4.5 Auto-Push, alles deployed mit Asset-Parität. Sein `/goal „führe zu ende"` + „mitte" = Plan autonom bis zum Ende durchziehen; Berichte nur mit Bundle-/Live-Beweisen.
7. **„FERTIG EIGENSTÄNDIG WAR DER PLAN ODER" (06.09. späte Nacht) = autonom-weitermachen-Befehl:** Keine neue Planung, keine Bestätigung — die nächste PLAN.md-Stufe (C2 Proxy) wurde sofort eigenständig gebaut+deployed+per curl HTTP 200 bewiesen. Muster: bei diesem Signal Plan-Reihenfolge stur abarbeiten (C4 Tiers → native Builds → GTM), jede Stufe mit Live-Beweis + commit; PLAN.md-Stand danach **20 ✅ / 24**.
