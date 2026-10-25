# Ziel und Hardware-Setup (korrigiert, 26.10.2026)

> Diese Datei ersetzt die früheren Linux/ALSA-Annahmen. Das RE-Ziel ist die **Software
> Traktor Pro 4** (Version 4.5.0, auf deinem Mac installiert), nicht NI-Controller-Hardware.
> Der Nachbau erfolgt unter **macOS** (CoreAudio / CoreMIDI / Swift).

## 1. RE-Ziel: Traktor Pro 4 → eigener macOS-DJ-Client

| Fakt | Bedeutung |
|---|---|
| Traktor Pro 4.5.0 auf deinem Mac installiert | Du hast echte .tsi- und .nml-Dateien als Analyse-Material |
| Kein Linux, kein ALSA | Nachbau nutzt **CoreAudio**, **CoreMIDI**, **Swift/Xcode** |
| DGX Spark mit Qwen3.8-Flash-Next | Analyse-Backend über OpenAI-kompatible API (Port 8080) |
| Pi/Mac als Client | Liefert Rohdaten (.tsi, nml, Messwerte) an den Spark |

## 2. Deine Hardware (verifiziert)

| Gerät | Typ | Relevanz |
|---|---|---|
| **Allen & Heath Xone:32** | Analoger 3-Kanal-Mixer, kein USB/MIDI | Treiberlos, RE-irrelevant |
| **Omnitronic BD-1380 USB** | Plattenspieler mit USB-Audio-Interface, 44,1/48 kHz 16-bit, class-compliant | Läuft unter macOS/CoreAudio ohne Treiber |

**Wichtig:** Aktuell kein MIDI-Controller vorhanden. MIDI-Mapping ist daher erst ein
**Software-Ziel** (.tsi-Schema verstehen), später testbar sobald ein MIDI-Controller
dazukommt.

## 3. Signalweg heute vs. Ziel

```
Heute (analog): Plattenspieler -> Xone:32 -> PA;  BD-1380 -> USB -> Mac (nur Aufnahme)

Ziel (macOS):   BD-1380 -> CoreAudio -> eigene DJ-App -> CoreAudio-Ausgabe
                MIDI-Controller (später) -> CoreMIDI -> Mapping-Engine (.tsi-kompatibel)
```

## 4. Rechtlicher Rahmen

Reverse Engineering zur Interoperabilität ist erlaubt (§ 40e UrhG AT / Art. 6 RL 2009/24/EG).
Erlaubt: Dateiformate lesen, Verhalten beobachten, eigene kompatible Software schreiben.
Nicht erlaubt: NI-Code kopieren, geschützte DSP/Samples extrahieren, Lizenz/Kopierschutz umgehen.
