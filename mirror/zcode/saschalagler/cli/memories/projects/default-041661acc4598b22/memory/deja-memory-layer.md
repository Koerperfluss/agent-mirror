---
name: deja-memory-layer
description: deja CLI = Saschas bestehendes komprimiertes Memory-Layer (2.415
  Sessions → 196 MB Suchindex); bei Memory-Komprimierungs-Wünschen deja nutzen,
  kein cognee/graphify-Neubau
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_66536c69-6d4a-4f36-a9c7-b1c72c2a20b1
---

**deja = das vorhandene komprimierte Memory-Layer auf Saschas Mac (verifiziert 30.10.2026):**

- CLI: `/opt/homebrew/bin/deja`, **v0.23.2** (nur `deja search <query>` + `deja index` + `deja restore`; **kein `deja list`-Kommando**)
- Index-Stand 30.10.: **2.415 Sessions, 118.882 Nachrichten**, Range 01.03.–30.10.2026, aus allen Harnesses (Antigravity 494 Sessions, ZCode, Cline, Claude, Gemini…)
- **Store: `~/.cache/deja` = 196 MB** (25 GB Roh-Rollouts → Faktor ~100:1); `~/.config/deja` 16K, `~/.local/share/deja` 12K
- Behält Zusammenfassungen/Stichworte + wiederherstellbare Text-Spans (`deja restore <file>` — 5.723 gesicherte Spans über 1.099 Dateien); Warnung bei anstehender 30-Tage-Bereinigung des Quell-Tools („deja keeps them searchable")
- Im Chat greift **deja-recall automatisch** (SessionStart-Block mit „✓ recalled from zcode session") — bei Treffer Antwort mit `déjà vu: <was>` + `deja:<session id>` eröffnen

**Verknüpfte Skills in `~/.agents/skills/` (alle vorhanden):** deja-search, deja-history, cognee-memory, graphify, caveman-compress, caveman-learn, memory-enhanced-decision-making, loki-memory-sync.

**Regel:** Wenn Sascha „komprimiere alte Verläufe/Doku in ein Memory-Layer" verlangt (30.10., „mir egal" welches Tool) → deja ist die Antwort, NICHT cognee/graphify/Obsidian neu aufbauen (Duplikat). Volltext-Löschung der Rollouts ([[ssd-cache-automation]], 25 GB) ist nach deja-Indexierung verlustarm — wartet auf sein „ja rollout".
