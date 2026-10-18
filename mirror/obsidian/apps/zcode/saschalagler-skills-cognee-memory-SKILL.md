---
app: zcode
quelle: "saschalagler/skills/cognee-memory/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: cognee-memory
description: Persistent graph and vector memory for AI agents that survives past the end of the chat session. Langzeitgedächtnis via cognee (Python) - Entity & Decision Extraction, Graph-Beziehungen, Kontext über Sessions hinweg.
---

# Cognee Memory

Verankert permanentes Langzeitgedächtnis, Graph-Beziehungen und Kontext über Sitzungen hinweg.
Basiert auf der Python-Library [cognee](https://github.com/topoteretes/cognee) (`pip install cognee`).
Kernfunktionen: Entity & Decision Extraction, Context Restoration, Graph Traversal.

## 1. Wann der Skill nutzen

Nutze den Skill, wenn:

- **Kontext über Sessions:** Der User startet eine neue Session/einen neuen Task und erwartet
  Wissen aus früheren Sitzungen (Projektstand, Entscheidungen, Präferenzen, Terminologie).
- **Entscheidungen persistieren:** Architektur-Entscheidungen, User-Präferenzen, Kundenakten,
  Gesetzesreferenzen/Paragraphen, Aktenzeichen dauerhaft speichern.
- **Graph-Beziehungen:** Verknüpfungen zwischen Entities (Projekte, Personen, Dokumente,
  Rechtsquellen) speichern und später traversieren.

Nicht nutzen für: flüchtigen Session-Kontext, Rohdaten (dafür Dateisystem/Git) und niemals für
Secrets/Passwörter/Tokens (diese gehören NIEMALS in den Memory-Index).

## 2. Setup-Check (vor der ersten Nutzung)

1. Python prüfen: `python3 --version` (>= 3.10 empfohlen).
2. cognee prüfen: `uv pip show cognee 2>/dev/null || python3 -m pip show cognee`.
3. Falls fehlend, bevorzugt mit `uv` installieren:
   ```bash
   uv venv ~/.agents/skills/cognee-memory/.venv
   uv pip install --python ~/.agents/skills/cognee-memory/.venv cognee
   # Fallback ohne uv:
   python3 -m venv ~/.agents/skills/cognee-memory/.venv
   ~/.agents/skills/cognee-memory/.venv/bin/pip install cognee
   ```
4. LLM-API-Key setzen (cognee braucht einen LLM-Provider für Extraction/Cognify):
   `export LLM_API_KEY=...` (oder je Provider `OPENAI_API_KEY` / `GEMINI_API_KEY`).
5. Smoke-Test aus einem stabilen Arbeitsverzeichnis heraus (cognee legt dort das Data-Dir
   `.cognee/` an — dort persistiert der Graph):
   ```bash
   cd ~ && ~/.agents/skills/cognee-memory/.venv/bin/python - <<'EOF'
   import asyncio, cognee
   async def main():
       await cognee.add("Smoke Test: cognee ist funktionsfaehig.")
       await cognee.cognify()
       print(await cognee.search("Smoke Test"))
   asyncio.run(main())
   EOF
   ```

## 3. Memory schreiben (add + cognify)

cognee ist async — Snippets immer via `asyncio.run(...)` in einem Python-Skript ausführen:

```python
import asyncio
import cognee

MEMORY_TEXT = """
Projekt: Analyse-Memorybase Tool (2026-08-23).
Entscheidung: Memory-Layer wird mit cognee umgesetzt, nicht mit flachen JSONL-Dateien.
Begruendung: Es werden Graph-Beziehungen und Vektorsuche benoetigt.
Entities: Owner Sascha; Library cognee (github.com/topoteretes/cognee).
Naechster Schritt: Fallback-Strategie fuer Umgebungen ohne cognee dokumentieren.
"""

async def main():
    await cognee.add(MEMORY_TEXT)   # akzeptiert Text, Liste von Texten oder Dateipfade
    await cognee.cognify()          # baut Graph + Embeddings (Entity/Decision Extraction)

asyncio.run(main())
```

Regeln:
- Memory-Text explizit strukturieren (Projekt, Entscheidung, Entities, Datum) statt
  ganzen Chat-Mitschnitt kippen — die Extraction wird deutlich präziser.
- Nach mehreren `add`-Aufrufen genügt einmal `cognify()` — Aufrufe sammeln und batchen.

## 4. Memory abfragen (search)

```python
import asyncio
import cognee

async def main():
    results = await cognee.search(
        "Welche Entscheidung wurde fuer den Memory-Layer des Projekts getroffen?"
    )
    for r in results:
        print(r)

asyncio.run(main())
```

Query-Varianten (optional via `query_type` aus `cognee.api.v1.search import SearchType`):
- `GRAPH_COMPLETION` (Default): LLM-Antwort angereichert mit Graph-Kontext.
- `INSIGHTS`: Roh-Treffer aus Graph + Vektorindex (für Weiterverarbeitung im Agent).
- `CHUNKS`: passende Original-Textabschnitte (wörtliche Belege).

## 5. Typische Patterns

### 5.1 Session-Ende: Entscheidungen & Entities verankern
1. Aus der Session die tragenden Punkte extrahieren: gefällte Entscheidungen (+Begründung),
   neu aufgetauchte Entities (Personen, Projekte, Tools, Paragraphen/Aktenzeichen), offene Tasks.
2. Als strukturierten Text formatieren (siehe Snippet in Abschnitt 3), Datum + Projekt voranstellen.
3. `cognee.add(...)` + `cognee.cognify()` ausführen und Erfolg kurz bestätigen.

### 5.2 Session-Start / neuer Task: alten Kontext laden
1. 2–4 gezielte Suchfragen pro relevantem Thema an `cognee.search(...)` stellen
   (Projektstand, frühere Entscheidungen, beteiligte Entities).
2. Treffer kompakt zusammenfassen und als "Geladener Langzeit-Kontext" an den Anfang des
   eigenen Arbeitskontexts stellen — vor der eigentlichen Task-Bearbeitung.
3. Bei Widersprüchen: neuere Treffer (Datum im Text) gewinnen; im Zweifel beim User nachfragen.

## 6. Fallback: cognee nicht installierbar

Wenn Installation/Import fehlschlagen (Netzwerk, Python-Version, Abhängigkeitskonflikte):
NICHT blockieren, sondern JSONL-Simple-Fallback nutzen — Datei `~/.agents/memory/cognee-fallback.jsonl`:

```bash
mkdir -p ~/.agents/memory && cat >> ~/.agents/memory/cognee-fallback.jsonl <<'EOF'
{"ts": "2026-08-23", "project": "Analyse-Memorybase Tool", "type": "decision",
 "content": "Memory-Layer mit cognee statt JSONL.", "entities": ["Sascha", "cognee"]}
EOF
# Abfragen (grobes Retrieval):
grep -i "cognee" ~/.agents/memory/cognee-fallback.jsonl | tail -5
```

Verhalten im Fallback: pro Event eine JSON-Zeile (Felder `ts`, `project`, `type`
[decision|entity|context|task], `content`, `entities`). Retrieval via `grep`/`jq` oder kleinem
Python-Skript. Den User einmalig darüber informieren, dass nur der Simple-Fallback aktiv ist.

## 7. Betriebshinweise

- Persistenz lebt im `.cognee/`-Datenverzeichnis (Graph-DB + Vektorstore) — deshalb Skripte
  immer aus demselben stabilen Verzeichnis starten (z. B. `~`).
- `cognify()` kostet LLM-Calls: batchen, nicht nach jedem Mini-Statement einzeln aufrufen.
- Duplikate vermeiden: vor dem Speichern kurz `search()` nach dem Thema fragen und ggf. anreichern
  statt doppelt anlegen.
- Fehlerbild `LLM_API_KEY not set` → Abschnitt 2 Schritt 4 prüfen; Import-Fehler → Fallback Abschnitt 6.
