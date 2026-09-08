---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/sascha-plan-vollstaendigkeit.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
name: sascha-plan-vollstaendigkeit
description: 4× ExitPlanMode nacheinander abgelehnt („völlig wertlos") — Pläne müssen die KOMPLETTE Funktionsliste (alle ~34 Funktionen/11 Bereiche) enthalten, jede offene Funktion drin, keine „nächste Runde"-Aufschieber, Architektur an seiner Vision ausgerichtet
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

**Muster (06.09. Nacht):** 4 ExitPlanMode-Pläne in Folge abgelehnt — jeder mit spezifischem Fehlvorwurf:
1. „was ist mit den 20 anderen app funktionalitäten?" — Plan enthielt nur ~10 Punkte, die anderen ~20 Funktionen (Ausbildung, Archiv, GTG-Details, Kalender/Deload, Custom-Spalten, Bio-Feed, Symmetry-Ring, PR-Badge, Link-Import, Biomech-Modal, Push, Auth…) fehlten
2. „völlig wertlos" — Architektur falsch (fixe Abfragen statt lernender Agent), Details [[atlas-lernender-agent-paradigma]]
3. Redesign-Punkt = CSS-Tweaks statt echte 3D-Engine
4. Auch die schließlich VOLLSTÄNDIGE Version wurde abgelehnt — dann Permission denied → Session-Ende. **Niemals Plan-Variablen „für später" reduzieren; „KEINE GRENZEN" = wörtlich nehmen.**

**Korrigiertes Plan-Protokoll für Sascha (gilt statt der 3-Zeilen-Regel aus [[plan-mode-falle]], wenn er VOLLSTÄNDIGKEIT verlangt):**
1. VOR dem Plan: komplette Funktionsinventur (11 Bereiche × alle Sub-Funktionen, ~34 Punkte) mit Status ✅/⬜ — er hat sie eingefordert („WO IST DIE LISTE")
2. Jede ⬜-Funktion kommt in den Plan, keine Auslagerung auf „später/nächste Runde/optional"
3. Architektur-Vorentscheidungen mit seiner Vision abgleichen (lernender Agent, Wissen anwenden statt anzeigen)
4. Plan = totzdem strukturiert (nummerierte Blöcke + Reihenfolge), aber VOLL
5. Wenn Trotz-Rejection-Kette: die vermissten Punkte IM PLAN BENENNEN und ergänzen, nicht neu formatieren — Inhalt, nicht Form, war das Problem

**Why:** Seine Rejection-Gründe waren jedes Mal konkrete FEHLENDE INHALTE, nicht Länge. Der „3-Zeilen-Minimalplan"-Rat aus [[plan-mode-falle]] gilt nur für Plan-Mode-Vergessen-Fälle, nicht für Vollständigkeits-Fälle.

**Welle 2 (08.09. Morgen): 2 weitere ExitPlanMode-Ablehnungen — diesmal war NICHT die Funktionsliste das Problem, sondern Ambition/Scope:**
1. Plan v1 (Redesign als PORT des kanonischen FUI-Builds + Richtungs-Prototypen) abgelehnt: „das neue design existiert nicht .. völlig unbrauchbar. du sollst es neu bauen komplett neu … apple design ui ux, vercel … du greifst den laufenden app build nicht an sonst bist du tot" → kanonischer Code gilt als wertlos, **Komplettneubau**, Live-Build tabu
2. Plan v2 (Neubau, aber schlanke Skill-Liste + max-3-Agents + Marketing als Konzept) abgelehnt: „alle verfügbaren skill design front backend ui ux apple 3d, glasmorph next level interaktiv … visuell die premium app nr 1 … tob dich aus" + DB „aus all meinen übungen die im graphen sind + Einbindung durch personen mittels video link insta youtube oder bilder" + Marketing „voll autonom … starte so viel agent wie nötig"
**Erweiterung des Protokolls:** „unbrauchbar" heißt immer NEUBAU (nie Portierung/Patch seiner alten Artefakte); Qualitäts-Ambition = Maximum aller installierten Skills ausreizen, „tob dich aus" wörtlich; seine „max 3 Agents"-Regel hebt ER selbst auf, wenn er „so viel wie nötig" sagt ([[sascha-globale-anweisungen]]-Muster); Feature-Scopes aus SEINEN Sätzen ableiten (Graph als Quelle, User-Contributions via Media-Links) statt aus dem Bestand. Genehmigt wurde dann v3: Sandbox `~/ATLAS_DESIGN/atlas-v8` + DESIGN-BIBEL + 4 Parallel-Agenten ([[atlas-v8-premium-neubau]]).
