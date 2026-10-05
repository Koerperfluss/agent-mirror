---
app: zcode
quelle: "saschalagler/workspace/default/.zcode/plans/plan-sess_c289f4fc-daa2-4f04-9693-646e08160f63.md"
stand: 2026-10-05
tags: [spiegel, zcode]
---

# CHIPSI LIVE-AUDIT (chipsi.openlaw.cc) + deine 5 Anliegen — Ausführungsplan

**Ziel:** Die echte App chipsi.openlaw.cc komplett prüfen gegen Marinus' JUD-Liste (Judicario.docx) + deine 28 markierten Screenshots (deine Fehler/Meinung). Ergebnis: **AUDIT 3 im Stil der Cline-Audits 1+2** (`#ID | Soll | Ist live | Warum/Root-Cause | Schwere | Beweis`) als MD+PDF im Projektordner.

## Deine 5 Zusatz-Anliegen (eingebaut)
1. **Auto-Memory** (Gedächtnis): geprüft — macht es Antworten dumm? Wo ist der Schalter, was geht aus.
2. **Onboarding-Flow**: kompletter Durchgang getestet (Pläne → Ansprache → Einstieg → Einverständnis → Passwort) gegen JUD-1..5.
3. **Team-Stand unbekannt** → Audit dokumentiert NUR den Live-Befund von chipsi.openlaw.cc (was aktuell wirklich da ist), plus Dedupe-Tabelle: was laut Marinus „schon in Bearbeitung" ist.
4. **Support ja/nein**: klare Empfehlung im Audit (braucht die App einen Support-Weg, wenn etwas nicht klappt — ja/nein + warum + wo).
5. **Konnektoren + E-Mail-Login**: geprüft, was im Backend/Hintergrund fertig sein muss, damit sie beim User einfach funktionieren; deine E-Mail-Anbindung-Ausarbeitung (E-Mail schreiben/E-Mail-Versand) wird eingebaut.

## Reihenfolge
1. **Infra-Fix** (1 Min): Overrides auf toten OmniRoute in `~/.zcode/v2/agents-state.json` leeren (Backup nach ~/sicherungen/) → Team-Dispatch läuft wieder; 1 Test-Agent als Beweis.
2. **Cline live bedient**: echter `cline`-CLI-Lauf — Task: Audits 1+2 + Prüfkopf aus `~/.cline/data/sessions/` archäologieren (Beweis: Session-ID + Log).
3. **Live-Testung chipsi.openlaw.cc** im Browser: alle JUD-Punkte 0–14 + Auto-Memory + Onboarding + Support + Konnektoren/E-Mail + funktionaler Test Recherche→Synthese (Netzwerkproblem-Bug noch da?) — je Punkt Screenshot-Beweis.
4. **AUDIT 3 schreiben** (`03_AUDIT3_CHIPSI_LIVE_2026-10-05.md` + PDF): Was soll weg / Was bleibt / Was geht nicht + warum / Team-Dedupe / Onboarding / Auto-Memory / Support-Empfehlung / Konnektoren+E-Mail-Backend-Voraussetzungen.
5. **Chronik-Korrektur**: Voll-Sweep über ALLE Sessions (ZCode-DB + Cline komplett + deja) — „weitaus mehr als 4" → komplette Tabelle; Fundinventar verschachtelter Ordner mit Move-Protokoll (nichts löschen).

Kein Löschen, kein Deploy, nur Tests + Dokumente + Config-Fix mit Backup.