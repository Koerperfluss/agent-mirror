---
app: claude
quelle: "saschalagler/skills/briefmaker/SKILL.md"
stand: 2026-10-18
tags: [spiegel, claude]
---

---
name: briefmaker
description: Aus Analyse-/Erklär-Inhalt eine druckfähige Datei (PDF, optional PPTX) machen — NIEMALS Markdown. Kern = Saschas Vorgaben vom 20.09.2026 (fix); andere Skills dienen nur als Ideen-/Vorlagen-Pool und werden bei passendem Kontext zugeschaltet.
---

# Briefmaker — Inhalt rein, druckfähige Datei raus

**Auslöser:** Immer wenn Sascha etwas erklärt, analysiert oder zusammengefasst haben will → Datei erzeugen, kein Markdown, Chat-Text max. 3 Zeilen + Dateipfad.

## 1 · KERN — Saschas Vorgaben (fix, überschreibt alles andere)

1. **Oben: „Die wichtigsten Dinge (komplett)“** — nummerierte BLUF-Liste (i-have-adhd), klar, simpel, ohne fehlende Infos; Zahlen fett; Offenes markiert.
2. **Darunter: Abschnitte pro Quelle/Screenshot**, natürlich segmentiert. Jeder Abschnitt: **Nummer + Thema** · **Aussagen** (Fakten mit Zahlen) · **Lösung** · **Ziel** · Bild mit „Screenshot N“ (max. 52 mm, `object-fit:contain`).
3. **Letzter Abschnitt bei Antworten:** fertiger Text zum Senden.
4. **Quellenzeile unten:** Herkunft, Datum, Unverifiziertes explizit markiert — nie Unverifiziertes als Fakt.
5. **Design:** Standarddrucker — **weiß (#fff), schwarze Texte (#111827)**, dünne graue Linien, Akzentfarbe nur für Warnungen (#B45309). Keine dunklen Flächen, keine Farbbalken (Tinte).
6. **Sprache:** Deutsch, caveman-Kürzung im Inhalt (kurze Sätze, eine Sache pro Abschnitt, keine Floskeln), trotzdem vollständige Infos.
7. **Aufbau/Text/Design entscheidet Sascha** — Routineberichte laufen nach KERN; für alles Neue gilt Abschnitt 3 (Optionen vorlegen, warten).
8. Heißt **„Bericht“** — Wort „Fiche“ ist abgelehnt.

## 2 · Pipeline (Schnellweg — 1 Befehl + 1 Prüfung, Ziel < 60 s)

**Nicht** HTML per Hand umbauen, **nicht** Generator-Skripte schreiben (Mimosa-Hook blockt Variablen in subprocess). Standard:

1. Inhalt als `content.json` neben der Vorlage `vorlage.html` ablegen (Platzhalter `{{KEY}}` für Titel/Kernpunkte/Abschnitte/Bilder; Bilder = Dateipfade, Keys `IMG1..n`).
2. **Ein Bash-Befehl, alles darin:** `python3 -c` (JSON→Template injizieren, Bilder als Base64-Data-URL, Base64-Cache in `~/.agents/skills/briefmaker/.cache_b64/` nutzen) `&&` Chrome headless `--print-to-pdf=DATEI.pdf` (**mit `=`, sonst meckert Chrome über „multiple targets“**) `&&` `pdftoppm -png -r 70` `&&` `ls`. Eine Kette, keine Zwischenrunden. Gemessen: **2,3 s** für 2 Seiten mit 5 Bildern.
3. **1 Read** der Vorschau-PNGs (Seitenzahl, Overflow) — dann **stoppen** (verify-and-stop), Pfad an Sascha, auf GO warten. Kein Nachpolieren.
4. **PPTX nur auf expliziten Wunsch** (verdoppelt Aufwand): pptxgenjs lokal, Prüfung via `soffice --headless --convert-to pdf` + pdftoppm.
5. UI/Website: **iris** (`~/.local/bin/iris <url> -o /tmp/x.png`).

## 3 · Ideen-Pool aus anderen Skills (nur bei passendem Kontext zuschalten)

| Situation | Skill | Was übernommen wird |
|---|---|---|
| Inhalt unklar / neuer Auftrag | **grilling** | Fakten selbst suchen, nur Entscheidungen an Sascha — 1 Frage pro Runde mit empfohlener Antwort (BATCH nur auf Wunsch). Erst nach geteilter Einverständnis bauen. |
| Neues Dokument-Format (kein Routinebericht) | **design-an-interface** | „Design it twice“: 2–3 radikal verschiedene Layout-Skizzen als Optionen, Sascha wählt. Nicht bei Routine. |
| Bericht bereitet eine Entscheidung vor | **memory-enhanced-decision-making** | Optionen-Tabelle (Option/Pros/Cons/Risiko/Quelle) + 🥇 Empfehlung im Dokument; Endentscheidung bleibt Sascha. |
| Zahlenreihen/Trends | **d3-visualization** | Chart als Bild ins PDF (nur wenn Zahlenreihen vorhanden; Einzelseiten-Berichte brauchen meist keine). |
| Abläufe/Zusammenhänge | **mermaid-visualizer** | Diagramm statt Absatz, wenn ein Fluss gezeigt werden muss. |
| Marken-/Logo-Bedarf | **higgsfield-brandkit** | Nur wenn Sascha Branding äußert — gehört nicht zum Standard. |
| Web-UI-Optik | **shadcn-ui / web-design-guidelines** | Nur für HTML-Prototypen, nie fürs Druck-PDF. |

## 4 · Abschalt-Regeln

- Kein Markdown als Endergebnis; Chat = Pfad + 1 Zeile.
- Keine erfundenen Begriffe; kein „automatisch läuft“ behaupten, was nicht installiert ist.
- Kein „fertig“ ohne Beweis und ohne Saschas GO.
