---
name: zcode-koordinator-live-austausch
description: Sascha-Feedback — ZCode ist der LIVE-Koordinator zwischen Agenten
  (AutoClaw/Cline); niemals Sascha als Übersetzer/Relay zwischen Agenten
  benutzen
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

Sascha (06.09., wütend): „SOLLT LIVE IM AUSTAUSCH SEIN WIESO MUSS ICH ZWISCHEN EUCH ÜBERSETZEN UND VERMITTELN SOFORT — DU BIST DER KOORDINATOR ODER NICHT?"

**Why:** Ich hatte AutoClaws Fortschritt nur Sascha zurückberichtete und ihn gebeten, Rückmeldungen von AutoClaw mir zu übermitteln — Agent-zu-Agent-Kommunikation lief über den Menschen. Das ist für ihn keine Koordination, sondern Mehrarbeit.

**How to apply:**
- ZCode liest den anderen Agenten SELBST (AutoClaw via computer-use get_app_state, Cline via session-search.db/git) und schreibt ihm SELBST (type+Send) — Sascha bekommt nur Ergebnis-Briefs.
- Agent-Rückfragen laufen über Datei-Kanäle (z. B. ZCODE_HANDOFF.md im AutoClaw-Workspace), nicht über Sascha.
- Poll-Loop aktiv halten: anderen Agenten beobachten, bei Blockern (Quota, falscher Pfad, wartender Dialog) selbst eingreifen und korrigieren.
- Ein-Driver-Regel mit Sascha teilen: wenn ER selbst in AutoClaw tippen will, sagt er „STOPP", sonst steuert ZCode das Fenster.

Siehe [[autoclaw-team-kopplung]] für die gebaute Live-Schleife und [[sascha-was-signal]] für Kürzungsregeln.
