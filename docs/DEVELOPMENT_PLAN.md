# Entwicklungsplan: Traktor-Clone für macOS

> Ziel: Eigene DJ-App unter macOS (Swift, CoreAudio, CoreMIDI), die die Kern-Features von Traktor Pro 4.5.0 nachbaut. Qwen3.8-Flash-Next auf dem DGX Spark ist der Entwicklungspartner (Code-Generierung, Architektur, RE).

## Phase 1 — Reverse Engineering & Spezifikation (jetzt)

| Aufgabe | Input | Output | Werkzeug |
|---------|-------|--------|----------|
| `.tsi`-Schema analysieren | 9 `.tsi`-Dateien in `~/Documents/Native Instruments/Traktor 4.5.0/.../Layout/` | JSON-Schema als offenes Mapping-Format | `pi_dev_client.py --task mapping` |
| `collection.nml` parsen | `collection.nml` | JSON-Export von Tracks, Cues, Beatgrids | `pi_dev_client.py --task format` |
| Audio-Device prüfen | BD-1380 am Mac | `Audio MIDI Setup` zeigt class-compliant Input | System-Prüfung |
| Blackbox-Messungen | Traktor Pro 4 auf Mac | Latenz, Keylock, Sync-Werte als Text | Mess-Setup + `pi_dev_client.py --task generic` |

**Definition of Done Phase 1:** Offenes JSON-Mapping-Schema existiert, `collection.nml` lässt sich vollständig in JSON überführen, Audio-Input läuft am Mac.

## Phase 2 — Minimal-Deck (MVP)

| Aufgabe | Output | Werkzeug |
|---------|--------|----------|
| CoreAudio-Capture (2× USB-Input) | Swift-Code, lauffähig in Xcode | `pi_dev_client.py --task codegen` |
| CoreAudio-Playback (beliebiges Output-Device) | Swift-Code | `pi_dev_client.py --task codegen` |
| Fester Buffer, Xrun-Logging | Swift-Code | `pi_dev_client.py --task codegen` |
| CoreMIDI-Eingang (Note/CC) | Swift-Code | `pi_dev_client.py --task codegen` |
| JSON-Mapping laden (Controller → Lautstärke/Crossfader) | Swift-Code + JSON | `pi_dev_client.py --task codegen` |

**Definition of Done Phase 2:** Minimal-Deck startet, empfängt Audio von den Plattenspielern und MIDI vom Controller, spielt aus.

## Phase 3 — DJ-Features (iterativ)

| Feature | Priorität |
|---------|-----------|
| Jog-Wheel / Pitch-Bend | Hoch |
| Cue-Punkte & Hotcues | Hoch |
| Beat-Sync zwischen Decks | Mittel |
| Effekte (Filter, EQ) | Mittel |
| Library-Ansicht (aus nml-Export) | Mittel |
| Stems-Unterstützung (.stem.mp4) | Niedrig |

Jedes Feature: Qwen auf dem Spark generiert den Swift-Code, du implementierst in Xcode, testest am echten Gerät.

## Phase 4 — Vergleichstest (Funktionsgleichheit)

Original Traktor Pro 4 vs. eigener Clone:
- Gleiche Eingabe (MIDI-Sequence, Audio-File) → gleiches Ergebnis?
- Latenz im gleichen Bereich?
- Beatgrid-Deckung stimmt?

---

## Rollen & Tools

| Rolle | Aufgabe | Tool |
|-------|---------|------|
| DGX Spark | Qwen-Dev-Backend, Code-Generierung, Architektur-Beratung | `llama-server`, Port 8080 |
| Mac / Pi | Client, Dateien schicken, Code zurückholen, in Xcode bauen | `pi_dev_client.py`, Xcode |
| GitHub | Wissensbasis, alle Prompts, Antworten, Code-Skelette | `Koerperfluss/agent-mirror`, Branch `cline/s4sx83cs` |

---

## Rechtlicher Rahmen

Reverse Engineering zur Interoperabilität ist erlaubt (§ 40e UrhG AT / Art. 6 RL 2009/24/EG). Ein eigener, unabhängiger Nachbau ist zulässig. Nicht erlaubt: NI-Quellcode kopieren, geschützte DSP-Algorithmen/Samples extrahieren, Kopierschutz oder Lizenzsysteme umgehen.
