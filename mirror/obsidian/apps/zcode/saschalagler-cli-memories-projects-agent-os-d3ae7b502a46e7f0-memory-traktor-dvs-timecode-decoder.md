---
app: zcode
quelle: "saschalagler/cli/memories/projects/agent-os-d3ae7b502a46e7f0/memory/traktor-dvs-timecode-decoder.md"
stand: 2026-10-30
tags: [spiegel, zcode]
---

---
name: traktor-dvs-timecode-decoder
description: DVS im TraktorClone — Traktor-Scratch-Timecode-Konstanten,
  Decoder-Architektur, Beweisgrenze (Live-Kalibrierung braucht Phono-Interface)
metadata:
  node_type: memory
  type: project
  originSessionId: session_58f3f4bfcb9a88671e0595593de28702
---

DVS (Slice 12, 30.10.2026, Commit 7264e782b) im TraktorClone implementiert: `TimecodeVinyl.swift` dekodiert Traktor Scratch (23 Bit, seed 0x134503/0x32066c, taps 0x041040, 2 kHz) und Serato 2A (20 Bit, seed 0x59017, taps 0x361e4, 1 kHz) — LFSR fwd/rev invers, Position-LUT (1<<bits Int32, bounds-check!), Zero-Crossing-Bitstream, Tonearm-Tiefpass bei 2×Carrier (nötig gegen 5 % Rauschen), Speed-EMA.

**Wichtig:** Nutzer-Korrektur — DVS geht auch mit Riemenantrieb (BD-1380); „blocked"-Aussage war falsch. Lizenz-Route: eigene Implementierung des öffentlich dokumentierten Formats (§40e UrhG), xwax/Mixxx sind GPL → deren Code NICHT kopieren, nur Format-Konstanten als Interop-Spec nutzen.

**Beweisgrenze:** Decoder synthetisch bewiesen (Position/1.5×-Speed/Rauschen, 6 Tests); Live-Kalibrierung am echten Vinyl ausstehend — braucht Phono-Interface (Traktor Audio oder Behringer UFO202) + Mikrofon-Freigabe. Absolute-Mode: Lead-in 1000 Codes, Seek-Toleranz 0.08 s bei 10 Hz Kopplungstimer.

Verwandt: [[qwen-flash-spark-project]]
