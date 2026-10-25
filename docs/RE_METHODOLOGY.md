# RE-Methodik: Funktionsgleicher Nachbau — auf Traktor Pro gemappt

> **Quellen:** „Systematische Anleitung für Reverse Engineering.pdf" (12-Schritte) + „reverse engineering .pdf" (/app-rebuild-Workflow) + „Magicline AI Agent Strategy.pdf" (Phasen-Vorlage) — alle im Ordner `Desktop/Reverse Engeniering /`, Stand 2026-10-26. Methodik hier zusammengefasst und auf unser Ziel (**Traktor-Pro-4-Clone unter macOS**, Swift/CoreAudio/CoreMIDI) gemappt.

## 0. Vier Gleichheits-Ziele (vorab festlegen, was „fertig" heißt)

| Ziel | Bedeutung | Nachweis |
| :--- | :--- | :--- |
| **Funktionsgleichheit** | Gleiche Eingaben → gleichwertige Ergebnisse | Vergleichstests ← **unser Hauptmaßstab** |
| Interaktionsgleichheit | Navigation/Zustandswechsel gleich | Ablauf- + UI-Tests |
| Darstellungsgleichheit | Layout/Animationen gleich | Visueller Vergleich |
| Implementierungsgleichheit | Gleicher interner Code | **Von außen nicht nachweisbar** — nie versprechen |

**Arbeitsdefinition „vollständig":** alle identifizierten Funktionen einer festgelegten Version (Traktor Pro 4.5.0) und Plattform. Nicht beobachtete Funktionen gelten NICHT stillschweigend als nachgebaut.

## 1. Die 12 Schritte (aus PDF 1) — Traktor-Ausprägung

| # | Schritt | Traktor-Konkretisierung |
| :--- | :--- | :--- |
| 1 | Ziel exakt definieren | Funktionsgleichheit, Referenz = Traktor Pro **4.5.0** macOS |
| 2 | Rechtliche Grundlage | Art. 5(3)/6 RL 2009/24/EG (=§ 40e UrhG AT): Beobachten/Dekompilieren zur **Interoperabilität** ok; fremden Code/Assets übernehmen NICHT. Eigene Swift-Implementierung = funktionsgleiche Neuentwicklung. |
| 3 | Referenz einfrieren | Protokoll: Version 4.5.0, macOS-Version, Audio-Interface (Xone:32 analog + BD-1380 USB), MIDI-Controller, Kontotyp/Lizenz. → `rebuild/STATE.md` |
| 4 | Vollständiges Funktionsinventar | Prüfblatt pro Funktion (F-001…): Deck-Playback, Pitch/Bend, Cue/Hotcue, Loop, Effekte, Mixer-Kanal, Browser, Recording, Stem-Playback… → `rebuild/FEATURES.json` |
| 5 | Blackbox-Verhalten | Kontrollierte Experimente: Aktion ausführen → beobachten (auch .tsi/collection.nml-Änderungen!) → Grenzfälle (leerer Track, 0 BPM, Extrem-Pitch), Störungen (Interface abziehen, MIDI-Disconnect) |
| 6 | Technische Analyse | **.tsi/.nml sind XML** (verifiziert) = Datenmodell gratis; HID/MIDI-Captures (usbmon am Pi) = Controller-Verhalten; Traktor-Binary selbst NICHT dekompilieren (rechtlich unsauberer Graubereich, unnötig) |
| 7 | Spezifikation rekonstruieren | 5 Dokumente: Funktionskatalog, Zustandsmodell (Deck: Load→Play→Cue→Loop…), Datenmodell (aus .nml!), Schnittstellenvertrag (CoreAudio-Streams, CoreMIDI-Messages), Abnahmekatalog |
| 8 | Backend ersetzen | Bei uns: **Audio-Engine selbst bauen** (CoreAudio/AudioUnits) — kein Original-Backend-Dependency. BD-1380-Digitizing via Standard-Treiber |
| 9 | iOS/macOS-Bedingungen | Hintergrund-Audio, Samplerate-Switch, Device- Hotplug, Latenz unter Last prüfen |
| 10 | KI-Funktionen separat | Traktor-Pad-/Stem-Erkennung: messbare Verhaltensgleichheit definieren, nicht „identische Ergebnisse" |
| 11 | Vergleichstests automatisieren | Dieselben Testfälle gegen Original (Traktor) und Clone; Status: Bestanden/Abweichung/Blockiert/Unbekannt/Fehlt |
| 12 | Agenten-Auftrag | → siehe `AGENTS.md` im Repo-Root (unser Arbeitsvertrag) |

## 2. Prüfblatt-Template (pro Funktion, aus PDF 1)

```
ID: F-0xx
Name: z.B. "Hotcue setzen/wiedergeben Deck A"
Vorbedingungen: Track geladen, Deck spielt
Ausgangsdaten: Beatgrid vorhanden
Benutzeraktion: Pad 1 drücken (MIDI Note 0x36, Kanal 1)
Sichtbares Ergebnis: Marker im Waveform, Wiedergabe springt
Tatsächliche Datenänderung: collection.nml? Session-State?
Nebenwirkungen: Quantize greift?
Fehler-/Grenzfälle: kein Track, Paused, Grid fehlt
Nachweis: Capture + Screenshot + .nml-Diff
Offene Fragen: [UNSICHER] …
```

**Regel:** Vermutungen immer separat markieren — eine beobachtete Ausgabe belegt nicht den internen Ablauf.

## 3. Der /app-rebuild-Agentenvertrag (aus PDF 2, Kurzfassung)

Vollversion: `AGENTS.md` im Repo-Root. Kernregeln für den Agenten (Claude/Qwen):

- **Keine eigenmächtige Reduktion** auf MVP — Vollständigkeit gilt für den erfassten Funktionsumfang.
- **Keine Mocks als fertig zählen**, keine nicht ausgeführten Tests als bestanden melden.
- Fortschritt in `rebuild/STATE.md` sichern; bei Fortsetzung zuerst Zustand + FEATURES.json lesen.
- Unbekanntes nie durch erfundene Referenzfunktionen ersetzen.
- STATUS je Funktion: `not_started/in_progress/implemented/blocked` + `not_tested/passed/failed/blocked`.
- **Abschlussgate:** „funktionsgleich im geprüften Umfang" nur wenn alle erfassten Funktionen implementiert + Abnahmekriterien bestanden + reproduzierbarer Build + keine offenen Blockaden.

## 4. Phasenplan (Vorlage: Magicline-PDF, 5 Phasen → Traktor)

| Phase | Magicline-Vorlage | Traktor-Umsetzung |
| :--- | :--- | :--- |
| 1 | Domain-Analyse, HAR→OpenAPI | Funktionsinventar aus UI + .tsi/.nml-Datenmodell (XML ist unsere „API-Spezifikation") |
| 2 | Core-Backend + Zustandsmaschinen | Swift-Engine: Deck-Zustandsmaschine (Load/Play/Cue/Loop), Audio-Graph (CoreAudio) |
| 3 | Edge-Gateway/Hardware | CoreMIDI-Layer + HID-Handling; BD-1380/Xone:32-Anbindung (analog = Pegel, USB = class-compliant) |
| 4 | UI/UX-Synthese | SwiftUI-Deck/Waveform/Mixer (Vision-Agenten können Traktor-Screenshots → SwiftUI konvertieren) |
| 5 | Compliance-Audit | Lizenz-Check (keine NI-Assets), Vergleichstest-Report, Gleichwertigkeitsbericht mit Restlücken |

## 5. Ehrlichkeits-Bilanz (aus PDF 1, wörtlich übernommen)

> „Kein ‚100 % nachgebaut', solange unbekannte oder blockierte Funktionen im definierten Umfang verbleiben. Auch vollständig bestandene Tests belegen Gleichwertigkeit innerhalb des geprüften Umfangs, nicht aller denkbaren Eingaben."

Unser Realitätscheck zu Traktor Pro 4.5: Waveform-Rendering, Timecode-Vinyl (Scratch mit BD-1380 = RIEMENANTRIEB → kein echter DVS-Turntable!), Stem-Separation und Sync-Engine sind die Schwergewichte — alles machbar, aber nicht in einer Session. Deshalb: FEATURES.json zuerst, dann Phase für Phase.
