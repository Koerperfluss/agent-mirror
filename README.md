# qwen-flash-spark — Client-Anleitung für Lorenz (Mac / Pi → Spark)

**Zustand:** Qwen3.8-Flash-Next läuft bereits auf deinem DGX Spark als `llama-server` (Port 8080, OpenAI-kompatibel).  
Dieses Repo enthält nur die **Client-Seite** für deinen Mac / Pi. Alles, was du brauchst, steht hier.

---

## Architektur (kurz)

```
Dein Mac / Pi (Client)  --HTTP-->  DGX Spark (llama-server, Port 8080)  -->  Qwen3.8-Flash-Next (bereits installiert)
         pi_re_client.py / pi_benchmark.py                      SSE-Streaming
```

Wofür: Analyse deiner vorhandenen Traktor Pro 4.5.0-Dateien (`.tsi`-Mappings, `collection.nml`) und Nachbau der App unter macOS (CoreAudio / CoreMIDI / Swift).

---

## 1. Spark erreichbar machen

Auf dem Spark ist `llama-server` bereits laufend (oder wird mit `spark_start.sh` gestartet).  
Du brauchst nur die **LAN-IP des Spark** (z. B. `192.168.1.50`).

Schnelltest vom Mac / Pi:

```bash
curl http://<spark-ip>:8080/v1/models
```

Muss eine JSON-Liste zurückgeben (enthält dein Qwen-Modell). Wenn nein: Spark nicht erreichbar oder Server nicht gestartet.

---

## 2. Benchmark fahren (nur um zu wissen, wie schnell der Spark antwortet)

```bash
python3 scripts/pi_benchmark.py \
  --host http://<spark-ip>:8080 \
  --suite traktor \
  --runs 3 \
  --json-out bench_traktor.json
```

Was gemessen wird: TTFT (Time to first token), Dekodier-Geschwindigkeit (tok/s), Prompt-Verarbeitungsrate.

---

## 3. Traktor-RE-Analyse starten (das ist der Hauptzweck)

Deine Traktor-Dateien liegen hier:

```
/Users/saschalagler/Documents/Native Instruments/Traktor 4.5.0/
├── Settings/Default Settings/Layout/Traktor Pro 4/*.tsi   ← MIDI/Controller-Mappings
├── Settings/Default Settings/Controller                   ← Controller-Definitionen
├── Settings/Default Settings/Audio                        ← Audio-Device-Konfig
├── collection.nml                                         ← Library, Cues, Beatgrids
└── Traktor Settings.tsi                                   ← Globale Einstellungen
```

### Beispiel 1: `.tsi`-Mapping analysieren (Schema herausfinden)

```bash
python3 scripts/pi_re_client.py \
  --host http://<spark-ip>:8080 \
  --task mapping \
  --input "/Users/saschalagler/Documents/Native Instruments/Traktor 4.5.0/Settings/Default Settings/Layout/Traktor Pro 4/01 - Layout - Traktor Pro 4 - 2 Track Decks.tsi" \
  --question "Extrahiere das Mapping-Schema: Welche MIDI-CC/Notes steuern welche Deck-Funktion? Erstelle ein offenes JSON-Gegenstück." \
  --output tsi-analyse.json
```

### Beispiel 2: `collection.nml` analysieren (Library-Format)

```bash
python3 scripts/pi_re_client.py \
  --host http://<spark-ip>:8080 \
  --task format \
  --input "/Users/saschalagler/Documents/Native Instruments/Traktor 4.5.0/collection.nml" \
  --question "Welche XML-Elemente speichern Titel, Pfade, BPM, Key, Cue-Punkte und Beatgrid? Schreibe einen Python-Parser, der alles in JSON exportiert." \
  --output nml-analyse.json
```

### Beispiel 3: Eigene Textfrage / Hypothese

```bash
python3 scripts/pi_re_client.py \
  --host http://<spark-ip>:8080 \
  --task generic \
  --question "Ich will Traktor Pro 4 unter macOS nachbauen (CoreAudio, CoreMIDI, Swift). Welche Kern-Features muss ich als erstes reimplementieren, und in welcher Reihenfolge?" \
  --output architektur.json
```

Die Antwort kommt als Stream auf stdout und optional als JSON in `--output` (inkl. Reasoning-Falls vom Modell geliefert).

---

## 4. Dateien in diesem Repo

| Pfad | Zweck |
|------|-------|
| `scripts/pi_re_client.py` | Client: schickt `.tsi`, `nml`, Hexdumps oder Fragen an den Spark |
| `scripts/pi_benchmark.py` | Benchmark: TTFT, tok/s, Prompt-Rate gegen den Spark |
| `scripts/spark_start.sh` | Falls du den Spark-Server neu starten musst (Modellpfad anpassen!) |
| `scripts/run_bench_suite.sh` | Kombinierter Lauf: Health → Benchmark → RE-Smoke |
| `tests/test_pi_tools.py` | Unit-Tests (läuft ohne Spark, nur Stdlib) |
| `docs/PROMPT_GUIDELINES.md` | Prompt-Baukasten für die RE-Tasks (tsi, nml, CoreAudio-Code) |
| `docs/ZIEL_UND_HARDWARE.md` | Korrigiertes Ziel: macOS-Nachbau, vorhandene Traktor-Dateien |
| `docs/RESEARCH.md` | Modell- & Hardware-Fakten |
| `docs/TRAKTOR_RE_RESEARCH.md` | Traktor-Ökosystem, .tsi/.nml, rechtlicher Rahmen (§ 40e UrhG) |

---

## 5. Wichtige Hinweise

- **Modell ist bereits installiert** auf dem Spark — nichts herunterladen, kein `llama.cpp`-Bauen nötig.
- Ersetze `<spark-ip>` durch die tatsächliche IP deines Spark im LAN.
- Der Client nutzt nur Python 3-Stdlib (kein `pip`, kein `venv`).
- Antworten können lange dauern (Reasoning). Timeout im Client ist bereits hoch (1800 s).
- Rechtlicher Rahmen: Reverse Engineering zur Interoperabilität ist erlaubt (§ 40e UrhG AT / Art. 6 EU Software-Richtlinie). NI-Code kopieren oder Kopierschutz umgehen ist nicht erlaubt.

---

## 6. Nächste Schritte für dich

1. `git clone https://github.com/Koerperfluss/agent-mirror.git && cd agent-mirror && git checkout cline/s4sx83cs`
2. `cd qwen-flash-spark`
3. `curl http://<spark-ip>:8080/v1/models` (Health-Check)
4. Erstes `.tsi` mit `pi_re_client.py` analysieren (siehe Beispiel 1)
5. Basierend auf der Analyse den macOS-Nachbau (Swift/CoreAudio) planen
