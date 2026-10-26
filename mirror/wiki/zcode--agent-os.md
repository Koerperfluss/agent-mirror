# agent-os (zcode)

Zuletzt gespiegelt: 2026-10-26 01:00 UTC

## plan-session_58f3f4bfcb9a88671e0595593de28702

# Plan: PDF-Methodik ins qwen-flash-spark-Repo einarbeiten (Traktor-Clone)

**Was die PDFs liefern (verifiziert, alle 3 gelesen):**
1. **Systematische Anleitung (7 S.)**: 12-Schritte-Methodik für funktionsgleichen Nachbau — Referenz einfrieren, vollständiges Funktionsinventar mit Prüfblättern, Blackbox-Experimente, 5 verbindliche Dokumente (Funktionskatalog/Zustandsmodell/Datenmodell/Schnittstellenvertrag/Abnahmekatalog), Vergleichstest-Status (Bestanden/Abweichung/Blockiert/Unbekannt/Fehlt), Ehrlichkeitsregel „kein 100%-Nachbau bei unbekannten Funktionen".
2. **reverse engineering .pdf (7 S.)**: Der fertige `/app-rebuild`-Agenten-Workflow — AGENTS.md-Arbeitsvertrag + `.agents/workflows/app-rebuild.md` mit FEATURES.json-Schema, STATE.md-Checkpoints, Anti-Mock-Regeln, 9 Phasen + Abschlussgate.
3. **Magicline Strategy (8 S.)**: Praxisbeispiel (Enterprise-Replikation in 5 Phasen: HAR→OpenAPI, Zustandsmaschinen, Edge-Gateway, Vision-UI, Compliance) — als Vorlage für große Rebuilds.

## Umsetzung (auf ~/qwen-flash-spark, alles lokale Commits)

| # | Datei | Inhalt |
|---|---|---|
| 1 | `docs/RE_METHODOLOGY.md` (neu) | Die 12-Schritte + app-rebuild-Regeln, **konkret auf Traktor Pro 4.5 gemappt**: Referenz = deine installierte Version + `Traktor Settings.tsi`/`collection.nml` (XML, verifiziert) = Datenmodell-Quelle; HID/MIDI-Captures = Interaktionsanalyse; macOS-Clone = Swift/CoreAudio/CoreMIDI. Magicline-PDF als Muster für Phasenplanung referenziert. |
| 2 | `AGENTS.md` (neu, Root) | Der Arbeitsvertrag aus PDF 2, angepasst: Referenz-App = Traktor Pro 4, Plattform = macOS, rebuild/-Artefakte (STATE.md, FEATURES.json, BLOCKERS.md) definiert — das ist der „genaue Anweisungs-Rahmen für Lorenz via Claude". |
| 3 | `scripts/pi_re_client.py` | Task-Profil `rebuild` ergänzen (Prüfblatt-/FEATURES.json-Analyse + Generierung). |
| 4 | `tests/` | Tests fürs neue Profil (wieder >12 grün). |
| 5 | `docs/LORENZ_GUIDE.md` | Verweis auf AGENTS.md + `/app-rebuild`-Nutzung ergänzen. |
| 6 | Commit | „RE_METHODOLOGY aus Nutzer-PDFs: 12-Schritte + app-rebuild-Workflow auf Traktor-Clone gemappt". Push-Befehl erneut an dich übergeben (Hook blockiert wegen agent-os-Fundstellen). |

**Aufwand:** ~15–20 Min, glm-first, minimales Credit-Risiko.
**Nicht tun:** Keine PDFs ins Repo kopieren (Urheberrecht) — nur Methodik-Zitate mit Quellenangabe „Desktop/Reverse Engeniering/*.pdf, Stand 2026-10".
**Offen bleibt:** echter Hardware-Benchmark; `MAGICLINE_GEORGE_ALLES_IN_EINEM_2026-10-19.pdf` (4. Datei im Ordner) nicht angefordert — unangetastet.
