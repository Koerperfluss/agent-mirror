# agent-os (zcode)

Zuletzt gespiegelt: 2026-10-25 23:15 UTC

## plan-session_58f3f4bfcb9a88671e0595593de28702

# Fortsetzungsplan: qwen-flash-spark „weiter" (Voll-Bündel)

**Ziel:** `~/qwen-flash-spark` zu einem abgeschlossenen, commit-ten Deliverable ausbauen: Root-Doku, verifizierte Modell-Fakten, Mermaid-Architektur, Spark-Automatik, Code-Review + Tests bis grün.
**Aufwand:** ~30–45 Min · GLM-Flash (glm-first) · moderates Credit-Risiko. Echte Hardware-Benchmarks bleiben offen (nur auf deiner Spark möglich).

## Phase 0 — Git-Basis (Beweis: git log)
1. `git -C ~/qwen-flash-spark status` prüfen (read-only).
2. Falls kein Repo: `git init` + initialer Commit des Ist-Stands (nur `add`, nichts löschen/überschreiben).

## Phase 1 — README + Quickstart (Root)
- `README.md`: Projektüberblick, 3 Kopier-Blöcke (Spark-Server starten → Benchmark → RE-Client), Dateilandkarte-Tabelle, Verweise auf docs/.

## Phase 2 — Doku-Vertiefung (RESEARCH.md)
- Live-Recherche (WebSearch/WebFetch): aktuelle llama.cpp-Flags für Qwen3-Next-Hybrid (Gated DeltaNet), MTP-Support-Stand in llama.cpp, Unsloth-GGUF-Repo + DGX-Spark-CUDA-aarch64-Build verifizieren.
- RESEARCH.md ergänzen: verifizierte Flags/Links mit Prüf-Datum; Schätzung vs. Fakt klar getrennt (Ehrlichkeits-Regel). Fehlende Belege = „DATENLAGE UNKLAR" markieren.

## Phase 3 — Mermaid-Architektur (docs/ARCHITECTURE.md)
3 Diagramme: (1) Deployment Pi ↔ SSH-Tunnel ↔ llama-server (SSE), (2) Benchmark-Flow (Suites → SSE-Metriken → JSON), (3) RE-Differential-Workflow (Baseline→Trigger→Delta→Scale→Logic → Mapping-Tabelle).

## Phase 4 — Spark-Runbook-Automatik
- `scripts/run_bench_suite.sh`: Health-Check (`/health`) → Benchmark-Suiten → RE-Smoke (hid + format) → Markdown-Report nach `out/`. Mit `--dry-run`.
- `docs/SPARK_RUNBOOK.md`: Hardware-Checkliste (GGUF-Download via huggingface-cli, llama.cpp-CUDA-Build aarch64, SSH-Tunnel/Firewall, optional systemd).
- Neue Tests inkl. Trockenlauf-Modus.

## Phase 5 — Code-Review + Testausbau (Ralph-Loop bis grün)
- Review der 3 Skripte + Runbook (Security: keine Secrets; Logic: Edge-Cases; Robustheit).
- Gefundene Bugs: TDD — erst Test, dann Fix.
- Tests von 5 auf ~10–12 ausbauen; `python3 -m unittest discover` bis OK (Circuit-Breaker: max. 5 Iterationen).

## Phase 6 — Beweis + Abschluss
- Jeder Punkt mit Befehl + Exit-Code + Dateipfad belegt; VALIDATION.md aktualisieren; Commit „WEITER: README+Architecture+Runbook+Review+Tests".
- Offen bleibt: reale Spark-Benchmarks + RE-Qualität auf Hardware (dein Teil, Runbook führt dich).

**Regeln:** Max 3 Subagenten parallel · 2 GO-Gates (Plan-GO = diese Freigabe; Git-Push nur auf separaten Wunsch) · nichts wird gelöscht oder überschrieben ohne Backup.
