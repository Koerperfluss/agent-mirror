# Autonomer Entwicklungsagent auf dem DGX Spark

> **Rollenkorrektur (25.10.2026):** Der Spark ist die **Entwicklungsmaschine** für
> den Traktor-Pro-4-Nachbau unter **macOS/CoreAudio/CoreMIDI/Swift**. Qwen läuft dort
> als Modellserver; `scripts/spark_dev_agent.py` gibt ihm einen begrenzten Tool-Loop
> zum Lesen/Schreiben von Dateien und Ausführen von Tests. Linux ist nur die
> Laufzeitumgebung des Sparks, **nicht das Ziel**. Das Modell liegt **nicht** in der
> Echtzeit-Audiokette.

**Wichtige Grenze:** Der Spark kann Swift-/Python-Code schreiben und Python-Tests
ausführen. Er kann aber **kein Xcode/CoreAudio/CoreMIDI auf macOS testen** und keine
Audiohardware ansprechen. Bau, Signierung, CoreAudio-/CoreMIDI-Tests und Gerätetests
laufen auf dem Mac. Der Pi ist für Linux-Hardware-/ALSA-Tests optional.

## 1. Was der Agent kann

| Werkzeug | Wirkung | Grenze |
|---|---|---|
| `list_files` | Dateien im Workspace auflisten | max. 500 Treffer, keine `.git`/Secrets |
| `read_file` | UTF-8-Datei lesen | max. 20.000 Zeichen pro Aufruf |
| `write_file` | vollständige Datei schreiben | max. 100.000 Zeichen, nur Workspace |
| `run_tests` | **fest konfigurierten** Testbefehl ausführen | Timeout, Read-only-Modus möglich |
| `git_read` | `git status` / `git diff` lesen | keine Git-Schreiboperation |
| `finish` | Lauf mit Zusammenfassung beenden | — |

Es gibt **keinen freien Shell-Zugriff**. Der Agent kann keine beliebigen
Systembefehle, `sudo`, Netzwerkbefehle oder Git-Commits ausführen. Der Testbefehl
wird vom Menschen beim Start festgelegt und ist nicht vom Modell änderbar. Der Agent
committet auch nicht selbst; Änderungen werden anschließend geprüft und manuell
committet.

## 2. Voraussetzungen

- DGX Spark mit laufendem llama.cpp-Server (`spark_start.sh`)
- Qwen-Modell mit `--jinja` und Tool- oder JSON-fähigem Chat-Template
- Projektordner auf dem Spark, auf den der Agent begrenzt wird
- Python 3, Git und die Testabhängigkeiten des Projekts

Der Agent läuft **auf dem Spark**, nicht auf dem Mac:

```bash
cd /pfad/zu/agent-mirror
export MODEL_PATH=/pfad/zum/ersten-shard.gguf
./scripts/spark_start.sh
```

## 3. Erster Lauf

```bash
python3 scripts/spark_dev_agent.py \
  --workspace /pfad/zum/zielprojekt \
  --host http://127.0.0.1:8080 \
  --model qwen3.8-flash-next \
  --task-file auftrag.md \
  --test-command "python3 -m unittest discover -s tests -v" \
  --max-steps 10 \
  --json-out agent-run.json
```

`auftrag.md` sollte enthalten:

```text
Ziel: ...
Akzeptanzkriterien: ...
Erlaubte Dateien/Bereiche: ...
Nicht ändern: ...
Testbefehl: ...
Offene Fragen: ...
```

Der Agent liest zuerst, ändert dann, führt Tests aus und beendet mit `finish`.
Das Ergebnis enthält Status, Schritte, Testresultat und die vollständige
Werkzeug-Historie.

## 4. Wichtige Optionen

| Option | Bedeutung |
|---|---|
| `--workspace` | harte Grenze für alle Dateizugriffe |
| `--task` / `--task-file` | Entwicklungsauftrag |
| `--test-command` | einziger ausführbarer Befehl |
| `--protocol auto` | versucht native OpenAI-Tools, fällt bei 400/422 auf JSON zurück |
| `--protocol native` | nur native Toolcalls |
| `--protocol json` | nur ein JSON-Objekt pro Antwort (Fallback) |
| `--read-only` | keine Schreib- oder Testaktionen; gut für Review |
| `--no-final-tests` | keine zusätzliche Testsuite nach `finish` |
| `--max-steps` | harte Obergrenze gegen Endlosschleifen |
| `--json-out` | reproduzierbares Protokoll für Benchmark/Review |

## 5. Empfohlener Arbeitszyklus

1. **Auftrag klein schneiden:** eine Funktion, ein Modul oder ein Bug pro Lauf.
2. **Read-only-Review:** `--read-only` für Analyse und Planung ohne Änderungen.
3. **Umsetzung:** normaler Lauf mit Testbefehl und `--max-steps 8`.
4. **Menschliche Prüfung:** `git diff`, Testausgabe und `agent-run.json` ansehen.
5. **Commit:** erst nach Prüfung manuell ausführen.
6. **Wiederholen:** nächsten kleinen Auftrag formulieren.

So bleibt „autonom“ kontrolliert: Der Agent darf im Workspace arbeiten, aber nicht
unkontrolliert am System oder an Git vorbei.

## 6. Modell- und Protokollwahl

Der Server wird mit `--jinja` gestartet. Der Agent sendet offizielle Qwen-Sampling-
Parameter (`thinking`: temperature 1.0, top_p 0.95, top_k 20, min_p 0.0).
Für Werkzeugaufrufe ist ein eher deterministischer Lauf oft besser; teste bei
Bedarf `--mode instruct`. `auto` ist der sichere Default:

- **native:** Server akzeptiert `tools` im OpenAI-Format.
- **json:** Modell antwortet mit genau einem JSON-Objekt; funktioniert auch, wenn
  der Server Toolcalls nicht vollständig unterstützt.
- **auto:** versucht native und fällt bei HTTP 400/422 auf JSON zurück.

Wenn das Modell im JSON-Modus Text statt JSON liefert, wird der Lauf nach
`--max-steps` beendet. Dann `--protocol json` erzwingen und den System-Prompt/
das Chat-Template prüfen. Der Agent erfindet keine ausgeführten Tests: Jedes
`run_tests`-Ergebnis stammt aus dem konfigurierten Befehl.

## 7. Sicherheit und Grenzen

- **Workspace-Sandbox:** Pfade mit `..`, absolute Pfade, `.git`, `.ssh`, `.env`,
  Schlüsseldateien und Symlink-Ausbrüche werden abgewiesen.
- **Keine freie Shell:** Nur die sechs Werkzeuge sind erreichbar; der Testbefehl
  ist fest vorgegeben.
- **Codeausführung:** Tests können beliebigen Projektcode ausführen. Deshalb den
  Agenten in einem **disposable Container oder eigenen Benutzer** ohne Secrets und
  ohne Produktionszugriff laufen lassen.
- **Netzwerk:** Der Agent selbst braucht nur den llama-Server. Testcode kann
  Netzwerkzugriff haben; bei Bedarf im Container blockieren.
- **Keine Autonomie über Git/System:** Kein Commit, Push, `sudo` oder Paketinstallation.
- **Modellfehler:** Halluzinierte APIs/Dateien sind möglich; Tests und Review bleiben
  Pflicht. Das Modell ist kein Ersatz für einen Menschen.

## 8. Mac, Pi und Echtzeit-Audio

Der Agent entwickelt auf dem Spark; er hat **keinen Zugriff** auf CoreAudio,
CoreMIDI, Xcode oder Audiohardware. Reale Builds und Gerätetests laufen auf dem Mac:

```
Spark: Qwen + DevAgent -> Dateien/Tests -> Git-Branch
Mac:   Xcode-Build -> CoreAudio/CoreMIDI -> Testergebnisse/Logs zurück
Pi:    optional ALSA-/MIDI-Hardwaretests unter Linux
```

Der Client (`scripts/pi_re_client.py`) kann `.tsi`, `.nml`, Logs und Fragen an Qwen
schicken. Das LLM bleibt außerhalb der Audiokette; Echtzeit-Messungen werden lokal
ausgeführt und nur als Ergebnisse analysiert.

## 9. Benchmark und Abnahme

Der Agent schreibt mit `--json-out` ein reproduzierbares Protokoll. Für einen
Entwicklungsbenchmark vergleicht man:

- Status (`done`, `tests_failed`, `max_steps`, `error`)
- Anzahl Modell-/Werkzeugschritte bis zum Abschluss
- ob die finale Testsuite bestanden wurde
- ob die erwarteten Dateien/Änderungen entstanden sind
- Laufzeit und Modell (bei gleichem Auftrag)

Die reine Token-Geschwindigkeit sagt nichts über Entwicklungsqualität. Für
aussagekräftige Werte mehrere identische, kleine Aufgaben mit versteckten Tests
verwenden und die Protokolle vergleichen.

## 10. Troubleshooting

| Problem | Prüfung |
|---|---|
| `API HTTP 400/422` | `--protocol json`, llama.cpp/`--jinja` prüfen |
| Modell ruft kein Werkzeug auf | System-Prompt/Template, `--protocol json` |
| Lauf endet mit `max_steps` | Auftrag kleiner schneiden, `--max-steps` erhöhen |
| `tests_failed` | Testausgabe im Protokoll lesen; Code nicht ungeprüft übernehmen |
| Schreiben verweigert | Pfad außerhalb Workspace, `.git`/Secret oder `--read-only` |
| `Testbefehl nicht gefunden` | `--test-command` auf dem Spark prüfen |
| Timeout | `--timeout`/`--test-timeout` anpassen, langsame Tests auslagern |
