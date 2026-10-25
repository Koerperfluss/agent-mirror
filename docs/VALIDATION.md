# Validation Log: Qwen-Flash-Spark

Dieses Dokument belegt die funktionale Verifikation des Deliverable-Sets. 
**Hinweis:** Es wurden Funktionstests und Syntax-Prüfungen durchgeführt. Hardware-Benchmarks wurden gemockt.

## 1. Syntax-Check (Bash & Python)

### spark_start.sh (Bash)
Befehl: `bash -n scripts/spark_start.sh`
Ergebnis: Exit Code 0 (Keine Syntaxfehler)

### Python Scripts (pi_benchmark.py, pi_re_client.py)
Befehl: `python3 -m py_compile scripts/*.py`
Ergebnis: Exit Code 0 (Erfolgreich kompiliert)

## 2. Unit-Tests (Funktionsnachweis)

Befehl: `python3 -m unittest discover -s tests -p 'test_*.py'`

```text
.....
----------------------------------------------------------------------
Ran 5 tests in 0.001s

OK
```

### Getestete Komponenten:
- **SSE-Parsing:** Korrektes Auslesen von TTFT und Usage-Daten aus dem OpenAI-Stream.
- **Tokenrate:** Verifikation der mathematischen Formeln für TPS (Tokens per Second) und PP (Prompt Processing).
- **Robuustheit:** Fehlerfreies Handling bei fehlenden `usage`-Feldern im API-Response.
- **Prompt-Logik:** Validierung der RE-Task-Profile und System-Prompts.
- **CLI-Interface:** Test der Argument-Parser für Pi-Tools.

## 3. Datei-Integrität

Alle geforderten Dateien wurden vollständig ohne Platzhalter erstellt:
- [x] `scripts/spark_start.sh`
- [x] `scripts/pi_benchmark.py`
- [x] `scripts/pi_re_client.py`
- [x] `docs/SETUP_GUIDE.md`
- [x] `docs/PROMPT_GUIDELINES.md`
- [x] `docs/VALIDATION.md`
- [x] `tests/test_pi_tools.py`

---

## Update 2026-10-26 (Session "weiter" — Voll-Bündel)

### Unit-Tests: 12 (zuvor 5), alle OK
Befehl: `python3 -m unittest discover -s tests -p 'test_*.py'`
```
Ran 12 tests in 0.007s — OK
```
Neu getestet: SSRF-Guard (Schema/Private-IP/Normalisierung), Stream-Robustheit (leere choices, data:-Präfix ohne Leerzeichen, Reasoning-Capture), Task-Profile vollständig (inkl. codegen).

### Syntax
- `python3 -m py_compile scripts/pi_benchmark.py scripts/pi_re_client.py` → Exit 0
- `bash -n scripts/spark_start.sh scripts/run_bench_suite.sh` → Exit 0
- `run_bench_suite.sh --dry-run` → Exit 0, keine Netzwerk-Calls

### Code-Review-Fixes (7 Findings, alle behoben)
1. Stream-Crash bei leerer choices-Liste → parse_re_stream() robust
2+3. Fehlende HTTP-Timeouts → 600 s / 1800 s
4. SSE-Präfix "data:" ohne Leerzeichen → wird geparst
5. usage_missing-Kennzeichnung statt stiller 0-Werte
6. FLASH_ATTN-Toggle (env FLASH_ATTN=0) für DeltaNet-Fälle
7. /proc/meminfo-Guard (macOS-Testläufe)

### Sicherheits-Review (Mimosa, unabhängig)
- SSRF-Guard eingebaut: nur http/https, private/Loopback-IPs default blockiert, Freigabe via --allow-lan / QFS_ALLOW_LAN=1 (LAN-Betrieb ist der Anwendungsfall, Runbook dokumentiert die Freigabe). Redirects blockiert (NoRedirectHandler).

### Echte Daten verifiziert
- Traktor Settings.tsi (4.3.0 + 4.5.0): Plain-XML `<NIXML>` (Hexdump belegt)
- Default-Layout-.tsi: 0-Byte-Platzhalter
- Offen (nur auf echter Hardware): llama.cpp-Build auf Spark, UD-Q4_K_XL-Download (111 GB), echte tok/s
