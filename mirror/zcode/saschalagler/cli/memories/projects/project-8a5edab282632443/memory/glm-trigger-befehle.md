---
name: glm-trigger-befehle
description: KORREKTUR 01.09. — Trigger-Wörter (/deve, "baue mir X") waren AGENT-ERFUNDEN, nie von Sascha abgesegnet ("DAS HABE ICH NIE GESAGT"). Kanonischer Weg ist /feature-dev (Plugin-Subagenten); glm-build/deve nur optionale Wrapper. Antworten immer Chat-Ebene, nie Terminal/Bash.
metadata:
  node_type: memory
  type: project
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

**KORREKTUR (01.09. abends):** Die Trigger-Tabelle (/deve, „baue mir X", wayfinder-Aufruf) habe ich als Agentin ERSONNEN und fälschlich als Vertrags-Waren dargestellt — Sascha: „DAS HABE ICH NIE GESAGT DU TROTTEL /feature-dev".

**Kanonisch ist der OFFIZIELLE Weg, den es schon gibt:**
- **`/feature-dev`** (Plugin) = Feature-Entwicklung: code-explorer → code-architect → code-reviewer (Plan→Build→Review integriert). Das ist der Weg, den Sascha kennt und will.
- Eigene Skills `glm-build`/`deve` = nur OPTIONALE Wrapper darüber — dürfen ignoriert werden; nie als Pfad/„Vertrag" verkaufen.
- Die GLM-Optimierungen (glm-first-Routing, Free-Fallback, MCPs, Regeln Abschnitt D) greifen automatisch, unabhängig davon, welcher Weg genutzt wird — das ist der eigentliche Wert, nicht die Trigger-Sprache.

**Kontext-Regel:** Sascha sitzt typischerweise IN einem Projekt-Chat (ZCode/Cline). Bei „wie nutze ich das" → NUR Chat-Befehle nennen; KEINE Terminal-/cd-/cline-/Bash-Zeilen („WIESO SOLL ICH EIN BASH SKRIPT" — Wut). Terminal-Syntax nur auf explizite Terminal-Frage.

**Why:** Erfindene Konventionen als absichtlich darzustellen + Terminal-Antworten im Chat-Kontext = zweifache Wut in 3 Nachrichten.

**How to apply:** Bei Feature-/Build-Wünschen zuerst /feature-dev und bestehende Mechaniken anbieten; eigene Skills nur erwähnen, wenn er nach Automation fragt. Vor jeder „so hast du es festgelegt"-Aussage prüfen: hat Sascha das wirklich gesagt? Siehe [[sascha-erfundene-konventionen]] und [[omniroute-verkabelung]].

**NACHTRAG (01.09. spät, „du hast nichts in cline cli implementiert"):** Skills-Symlinks in ~/.cline/skills/ waren wirkungslos für die CLI — Slash-Commands kommen in Cline CLI aus **~/.cline/workflows/** (bewiesen durch seine /00…/04), Regeln aus **~/.clinerules**. Fix ausgeführt: workflows/05-glm-build.md, 06-deve.md, 07-wayfinder.md angelegt + GLM-Regeln an ~/.clinerules angehängt. Sein Screenshot bewies parallel: Modell glm-first griff in der CLI bereits (providers.json wirkt). Details [[cline-cli-befehle-mechanik]].

**NACHTRAG 2 (05.09., User-Validierung der Pipeline):** Sascha forderte SELBST an: „teste die pipeline die workflow mit folgendem ziel erstelle retrogame sonic the hedgehog - jump and run" — mit Skill-Tags inkl. glm-build/deve/wayfinder/cavecrew. Der komplette Director-Lauf lief E2E ohne Rückfragen und ohne Einwand (Details [[omniroute-verkabelung]]). Einordnung: Die Erfindungs-Korrektur oben bleibt gültig (nie als von ihm abgesegnete „Trigger-Sprache" verkaufen), ABER glm-build/deve sind damit einmal von ihm explizit als Workflow beauftragt und erfolgreich erlebt — nicht mehr nur meine Eigenbauten.
