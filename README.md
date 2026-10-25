# qwen-flash-spark — Traktor-Clone Entwicklung (Lorenz, Mac → Spark → Qwen)

**Ziel:** Eigene DJ-App für macOS, die Traktor Pro 4 nachbaut (CoreAudio, CoreMIDI, Swift).
Das Qwen3.8-Flash-Next-Modell läuft bereits auf deinem DGX Spark (Port 8080, OpenAI-kompatibel) und ist dein Entwicklungspartner. Der Mac / Pi ist der Client, der Dateien schickt und Code zurückbekommt.

Alles hier ist für **dich** zum direkten Kopieren und Ausführen.

---

## Architektur (3 Rollen)

```
┌─────────────┐      HTTP :8080       ┌─────────────────────────┐
│  Dein Mac   │ ─────────────────────►│   DGX Spark (GB10)      │
│  (Client)   │   pi_dev_client.py    │  llama-server           │
│             │  .tsi / nml / Fragen  │  Qwen3.8-Flash-Next     │
│  Xcode      │◄──────────────────────│  Code + Architektur     │
│  Swift      │      Swift-Code       │  (Reasoning, Dev-Helfer)│
└─────────────┘                       └─────────────────────────┘
         ▲
         │ scp / Netzwerk
         ▼
~/Documents/Native Instruments/Traktor 4.5.0/
├── Settings/Default Settings/Layout/Traktor Pro 4/*.tsi
├── Settings/Default Settings/Controller
├── Settings/Default Settings/Audio
├── collection.nml
└── Traktor Settings.tsi
```

---

## 1. Spark prüfen (ein Befehl)

```bash
curl http://<spark-ip>:8080/v1/models
```

Muss dein Qwen-Modell zurückgeben. Nicht da? Spark-Server starten:

```bash
export MODEL_PATH=/pfad/zu/deinem/qwen-flash-next-q4_k_m.gguf
export CTX=32768
export PORT=8080
export LLAMA_SERVER_BIN=~/llama.cpp/build/bin/llama-server
./scripts/spark_start.sh
```

---

## 2. Entwicklungsschritte (in dieser Reihenfolge)

### Schritt A — .tsi-Mappings analysieren (Schema herausfinden)

Deine 9 `.tsi`-Layouts liegen hier:

```
/Users/saschalagler/Documents/Native Instruments/Traktor 4.5.0/Settings/Default Settings/Layout/Traktor Pro 4/
```

```bash
python3 scripts/pi_dev_client.py \
  --host http://<spark-ip>:8080 \
  --task mapping \
  --input "/Users/saschalagler/Documents/Native Instruments/Traktor 4.5.0/Settings/Default Settings/Layout/Traktor Pro 4/01 - Layout - Traktor Pro 4 - 2 Track Decks.tsi" \
  --question "Extrahiere das vollständige Mapping-Schema: Welche MIDI-CC/Notes steuern welche Deck-Funktion (Play, Cue, Jog, Pitch, FX)? Erstelle ein offenes JSON-Schema als Gegenstück zum .tsi-Format." \
  --output tsi-mapping-schema.json
```

### Schritt B — collection.nml parsen (Library, Cues, Beatgrids)

```bash
python3 scripts/pi_dev_client.py \
  --host http://<spark-ip>:8080 \
  --task format \
  --input "/Users/saschalagler/Documents/Native Instruments/Traktor 4.5.0/collection.nml" \
  --question "Analysiere das .nml-XML-Schema: Welche Elemente speichern Titel, Pfade, BPM, Key, Cue-Punkte, Beatgrid? Schreibe einen Python-Parser, der alles in JSON exportiert." \
  --output nml-parser-plan.md
```

### Schritt C — Swift-Code für den Clone generieren (CoreAudio / CoreMIDI)

```bash
python3 scripts/pi_dev_client.py \
  --host http://<spark-ip>:8080 \
  --task codegen \
  --question "Ich baue einen Traktor-Clone für macOS in Swift (Xcode). CoreAudio für 2 USB-Audio-Eingänge (Omnitronic BD-1380, class-compliant, 44.1kHz/16-bit), CoreMIDI für Controller-Input. Schreibe ein minimales, lauffähiges DJ-Deck: Audio-Capture, playback, Xrun-Logging, MIDI-CC → Lautstärke/Crossfader via JSON-Mapping. Erkläre jede API-Entscheidung." \
  --output swift-deck-skeleton.swift
```

### Schritt D — Benchmark (wie schnell antwortet der Spark?)

```bash
python3 scripts/pi_benchmark.py \
  --host http://<spark-ip>:8080 \
  --suite traktor \
  --runs 3 \
  --json-out bench.json
```

---

## 3. Dateien in diesem Repo

| Pfad | Zweck |
|------|-------|
| `scripts/pi_dev_client.py` | Client: schickt `.tsi`, `nml`, Fragen an den Spark, erhält Code + Antwort |
| `scripts/pi_benchmark.py` | Benchmark: TTFT, tok/s gegen den Spark |
| `scripts/spark_start.sh` | Spark-Server starten (nur falls nötig) |
| `scripts/run_dev_suite.sh` | Kombinierter Lauf: Health → Benchmark → Dev-Smoke |
| `docs/PROMPT_GUIDELINES.md` | Prompt-Baukasten für die Entwicklung (tsi, nml, CoreAudio, Swift) |
| `docs/DEVELOPMENT_PLAN.md` | Phasenplan: RE → Spezifikation → Implementierung → Test |
| `docs/ZIEL_UND_HARDWARE.md` | Ziel: Traktor-Clone macOS, CoreAudio/CoreMIDI, Hardware |
| `docs/ARCHITECTURE.md` | Mermaid-Diagramme: Deployment, Dev-Flow |
| `tests/test_pi_tools.py` | Unit-Tests (ohne Spark, nur Stdlib) |

---

## 4. Nächste Schritte für dich

```bash
# 1. Repo holen
git clone https://github.com/Koerperfluss/agent-mirror.git
cd agent-mirror && git checkout cline/s4sx83cs
cd qwen-flash-spark

# 2. Health-Check
curl http://<spark-ip>:8080/v1/models

# 3. Erstes .tsi analysieren (Pfad stimmt mit deinem Mac)
python3 scripts/pi_dev_client.py \
  --host http://<spark-ip>:8080 \
  --task mapping \
  --input "/Users/saschalagler/Documents/Native Instruments/Traktor 4.5.0/Settings/Default Settings/Layout/Traktor Pro 4/01 - Layout - Traktor Pro 4 - 2 Track Decks.tsi" \
  --question "Schema extrahieren, offenes JSON-Gegenstück entwerfen." \
  --output tsi-analyse.json

# 4. Swift-Skelett generieren
python3 scripts/pi_dev_client.py \
  --host http://<spark-ip>:8080 \
  --task codegen \
  --question "Minimales DJ-Deck in Swift mit CoreAudio + CoreMIDI." \
  --output swift-deck.swift
```

Dann in Xcode öffnen, compilieren, testen.

**Rechtlicher Rahmen:** Reverse Engineering zur Interoperabilität ist erlaubt (§ 40e UrhG AT / Art. 6 EU Software-Richtlinie). NI-Code kopieren oder Kopierschutz umgehen ist nicht erlaubt.
