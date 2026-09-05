# Masterplan: LOKI als globales Plugin (@loki) & Full Audit

> **Zweck:** Genau wie Jules machen wir LOKI zu einem globalen Plugin, damit du ihn in *jedem* Projekt via `@loki` rufen kannst. Gleichzeitig repariere ich den kaputten Boot-Prozess (fehlende Python-Module) im LOKI-Verzeichnis, damit das Backend überhaupt läuft.

## 1. System-Architektur

| Komponente | Aufgabe | Status |
|---|---|---|
| **LOKI Kernel** | Läuft im Hintergrund auf Port 8010 (`/Users/saschalagler/loki-ki`) | ❌ Boot fehlerhaft (Module fehlen) |
| **@loki Plugin** | Das neue, systemweite IDE-Interface für den LOKI Kernel | ❌ Noch nicht erstellt |

## 2. Proposed Changes

### 1. Full Audit & Repair (LOKI Backend)
- Ich installiere die fehlenden Module (`bs4`, `psutil`, etc.) im Environment `/Users/saschalagler/loki-ki/.venv_new`.
- Ich verifiziere, dass `LOKI_MASTER.py` erfolgreich auf Port 8010 bootet.

### 2. Globales Plugin erstellen
- **[NEW]** `~/.gemini/config/plugins/loki-os/plugin.json`
- **[NEW]** `~/.gemini/config/plugins/loki-os/agents/loki/AGENT.md` (System-Prompt, der `@loki` beibringt, dass er mit dem lokalen Kernel auf `localhost:8010` kommunizieren soll).

## 3. User Review Required

> [!IMPORTANT]
> Soll ich diesen kombinierten Plan (Reparatur des Backends + Erstellung des globalen Plugins) jetzt direkt ausführen?
