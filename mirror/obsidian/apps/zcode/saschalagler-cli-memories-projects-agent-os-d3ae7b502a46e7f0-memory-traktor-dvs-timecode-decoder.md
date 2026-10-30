---
app: zcode
quelle: "saschalagler/cli/memories/projects/agent-os-d3ae7b502a46e7f0/memory/traktor-dvs-timecode-decoder.md"
stand: 2026-10-30
tags: [spiegel, zcode]
---

---
name: traktor-dvs-timecode-decoder
description: DVS + NI-TSI-Reader im TraktorClone (Slices 12+13) — Hardware-Setup
  (BD-1380-USB=Line, Scratch-Vinyl vorhanden), Decoder-Gotchas, TSI-Format-Befund,
  Beweisgrenze synthetisch
metadata:
  node_type: memory
  type: project
  originSessionId: session_58f3f4bfcb9a88671e0595593de28702
---

DVS + NI-TSI-Import im TraktorClone (30.10., Commits `7264e782b` Slice 12 + `bb7cc7e6d` Slice 13, 114/114 Tests).

## Saschas echtes Setup (wichtig für alle Audio-Fragen)

- **Mac = das Audio-Interface** („wir brauchen gar nichts"); Mixer egal (Xone:32 oder DJM-750 per Line-In vom Mac-Out)
- **BD-1380-USB hat Phono-Preamp + USB-Line-Out eingebaut** → Turntable direkt per USB an den Mac, KEIN extra Interface (frühere Annahme „Traktor Audio/UFO202 nötig" ist falsch). DVS-Default daher `lineLevel = true`, Phono-Toggle im Treiber-Panel
- **Traktor-Scratch-Vinyl ist vorhanden** — Live-Kalibrierung jederzeit möglich
- „ALSA-Standardtreiber" = Linux-Konzept; macOS-Pendant CoreAudio ist eingebaut (`AudioDevices.swift` listet/sets Output+Input)

## TimecodeDecoder (`TimecodeVinyl.swift`)

Traktor Scratch A/B (23 Bit, seed 0x134503/0x32066c, taps 0x041040, 2 kHz) + Serato 2A (20 Bit, seed 0x59017, taps 0x361e4). Gotchas: **LUT-lookup braucht Bounds-Check** (Code 0xDEADBEE → Index-out-of-range-Crash); **Tonearm-Tiefpass bei 2×Carrier ist Pflicht** für Rauschrobustheit (5%-Rauschen-Test schlug ohne fehl); Richtungswechsel → validCounter reset. Kopplung: EngineHost-Timer 10 Hz, Absolute-Mode (Lead-in 1000 Codes), `applyPlatterSpeed` (Pitch = Plattengeschwindigkeit, ±0.05 = Pause, Stems ausgenommen).

## NI-TSI-Format (Slice 13, reverse-engineered)

.tsi = NIXML, Mappings in Base64-Blob von Entry `DeviceIO.Config.Controller`. **S4/S2-User-Mappings enthalten die Action-Registry (UTF-16LE-Namen wie "Left.Cue") OHNE MIDI-Nummern** — S4/S2 sind HID-Geräte. Deshalb: Action-Katalog-Bericht statt Fake-Import; echte Bindings per MIDI-Learn (2 s/Knopf). Scanner-Lektion: Header-Schema scheiterte an **Endian-Falle im payloadLen-Feld** (LE vs BE je Version) → robuster `[u16 nlen][UTF16LE-ASCII]`-String-Scan über den ganzen Blob, Punkt-Notation als Filter, Set-Dedup. Integrationstest gegen echte S4-Datei grün.

## Lizenz-Route

Eigene Implementierung des öffentlich dokumentierten Signalformats (§ 40e UrhG / Art. 6 RL 2009/24/EG). xwax + Mixxx sind GPL → deren Code NIE kopieren, nur Format-Konstanten als Interop-Spec.

## Beweisgrenze

Decoder nur synthetisch bewiesen (Position @1.0×/1.5×-Speed, 5 % Rauschen, LFSR fwd/rev invers). **Live-Kalibrierung ausstehend**: Vinyl auflegen → Treiber-Panel → DVS „▶︎ Vinyl" → Eingang „USB Audio CODEC" (BD-1380) → Mic-Dialog erlauben. Siehe [[qwen-flash-spark-project]], [[research-before-declining-blocked]].
