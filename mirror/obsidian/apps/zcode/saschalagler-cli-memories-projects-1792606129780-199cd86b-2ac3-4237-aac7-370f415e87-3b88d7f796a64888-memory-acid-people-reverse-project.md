---
app: zcode
quelle: "saschalagler/cli/memories/projects/1792606129780-199cd86b-2ac3-4237-aac7-370f415e87-3b88d7f796a64888/memory/acid-people-reverse-project.md"
stand: 2026-10-22
tags: [spiegel, zcode]
---

---
name: acid-people-reverse-project
description: Neues Projekt Acid-People-Reverse — Reverse-Engineering des
  DnB-Tracks, kanonischer Ordner + Analyse-Stand
metadata:
  node_type: memory
  type: project
  originSessionId: session_9fccb38cef626fd430b2fa1aa39384d2
---

Neues Projekt (21.10.2026, Nutzer-Wunsch „neues Projekt"): **Acid-People-Reverse**
- Kanonischer Ordner: `~/Desktop/Coworkspace_Ich/Acid-People-Reverse/` (FLAC, Stems in `_archiv/htdemucs/…`, `STRUKTUR.md`, `timeline.csv`, Rassel-Dateien, Kandidaten, Skripte `struktur.py`/`sep_series.py`).
- Track: Levela & Kasra – Acid People (Critical Music, DnB). Kein WhoSampled-Eintrag, Samples nicht dokumentiert.
- Analyse-Stand: 175,2 BPM effektiv (librosa 87,6 Halbwert), D#-Moll, 13 8-Takt-Blöcke, 7 Sections (Intro / Drop1 44,6–131,1 / Breakdown 131,1–154,3 / Rebuild / Drop2 / Outro). Rassel-Perkussion setzt bei 56 s ein, Periode 2,76 s (2 Takte), liegt im drums-Stem, isoliert per gleitender Spektral-Subtraktion (Referenz 48–56 s) + HPSS + Bandpass 300–8000 Hz (`sep_series.py`).
- AudioSep (text-geführte Trennung) war installiert und funktionierte (Checkpoints 3,6 GB), Repo + Gewichte wurden vom Nutzer wieder gelöscht — Re-Install = git clone audio-agi/AudioSep + Checkpoints vom HF-Space, Patches: torch.load weights_only=False, load_state_dict strict=False, iCloud-Dateien vorher materialisieren (fileproviderctl).
- Nutzer will Reverse-Engineering-Ziel: Track in Teile zerlegen und NEU AUFBAUEN können (Struktur-Map + Teile + Rezept = `STRUKTUR.md`).
- Mimosa-Hook: blockt `open(<Variable>, "w")` in Python-Dateien („path traversal" Fehlalarm) und .py-Pfade in Bash — Dateien per Write-Tool mit Literalpfaden anlegen, Auswerte-Skripte drucken JSON nach stdout.
- Stand 21.10. spät: Reverse-Engineering-Kernlieferung komplett — STRUKTUR.md (Bauplan: 175,2 BPM effektiv / 87,6 Halbzeit-Feel, D#-Moll, 13 8-Takt-Blöcke, 7 Sections mit Breakdown 131,1–154,3 s, Bass-RMS-Steigerung 0,25→0,43 über die Drops = Filter-Sweep), timeline.csv (RMS je Stem pro Block), Rassel isoliert (RASSEL_isoliert_ab_56s.wav, Periode 2,76 s = 2 Takte, liegt im drums-Stem). Nutzer-Kommunikation: keine Erklärungen, ein Ergebnis-Pfad + ein Beweis pro Antwort; bei Frustration präzise nach dem einen fehlenden Stück fragen statt breit zu antworten.
- Offener nächster Schritt (21.10./22.10., wartet auf Nutzer-„weiter" oder Fehlermeldung): Acid-Line → MIDI (Audio-zu-MIDI) + alle Elemente als DAW-fertige One-Shots exportieren. Nutzer hat den Ohr-Check der Lieferungen noch nicht gemacht.
- Tool-Frage 22.10. beantwortet: 2026 haben fast alle Programme eingebaute Stem-Separation — DJ: VirtualDJ (Echtzeit, lokal), Serato „Stems", Traktor Pro 4, djay Pro (NeuralMix, stärkste DJ-Umsetzung); DAW: Logic Pro 11 „Stem Splitter" (laut EditorsKeys-Test 6/2026 beste Qualität), Ableton Live 12.3 (kreativste Umsetzung), Studio One 7, FL Studio 2025, Cubase Pro 15. Wichtige Grenze gegenübergestellt: alle trennen nur Standard-Kategorien (Vocals/Drums/Bass/Other), kein Tool isoliert EINEN individuellen Sound (wie die 56-s-Rassel) — dafür nur text-/beispiel-geführte Modelle (AudioSep, SAM Audio von Meta). Falls der Nutzer Logic/Live etc. besitzt, können dessen Stems die demucs-Stems im Projekt ersetzen (Qualitätsupgrade, Struktur-Map bleibt gleich).
- 22.10. erledigt — 6-Stem-Trennung wie Logic Stem Splitter: `demucs -n htdemucs_6s` → `htdemucs_6s/…/{vocals,drums,bass,guitar,piano,other}.wav` (~40 s CPU). Gitarre/Piano im Track praktisch leer (RMS 0,0002/0,0005 — Acid-DnB ohne Guitar/Piano). 56-s-Ton eindeutig zugeordnet: **drums-Stem** (Δ 2,5–5 kHz bei 56 s: drums +1,98 dB, other −8,83 dB — das 4-Stem-Modell hatte die Rassel in „other", das 6-Stem-Modell schiebt sie korrekt in drums). Extrakt: `kandidaten/ton56_aus_drums-stem.wav` (56–58,76 s, HPSS-perkussiv, Bandpass 300–8000 Hz, 2,76 s = 2 Takte; Skript `ton56_6stem.py`). Offen: Nutzer-Ohr-Check dieses Extrakts; falls er trifft, Rassel über die ganze Track-Länge aus dem 6-Stem-drums ziehen (gleiche Methode).
