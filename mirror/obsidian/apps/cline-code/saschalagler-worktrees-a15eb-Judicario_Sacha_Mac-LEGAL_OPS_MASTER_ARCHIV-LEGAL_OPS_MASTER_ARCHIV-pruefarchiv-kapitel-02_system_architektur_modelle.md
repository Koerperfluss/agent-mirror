---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/pruefarchiv/kapitel/02_system_architektur_modelle.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# KAPITEL 02 — System-Architektur & Modelle (Code-Audit: Legal Ops Advisor)

**Prüfer:** CODE-AUDITOR · **Datum:** 28.07.2026 · **Methode:** Vollständiges Code-Audit auf echtem lokalen Code (keine Cloud, keine Behauptungen ohne Beleg)
**Bewertungsskala:** ✅ verifiziert (Code-Zeile belegt) · ⚠️ teilweise · ❌ widerlegt · 🔶 behauptet (unbelegt)

**Pfad-Konvention:** `APP` = `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/` · `JUD` = `/Users/saschalagler/Downloads/Judicario_Sacha_Mac/judicario/`

---

## 2.1 Prüfgegenstand & Methodik

Geprüft wurde die Behauptung aus dem Team-Briefing: „FastAPI:7070 + PyWebView, SQLite FTS5 RAG (indexer.py), Ollama lokal, BACKEND_MODE auto/local/cloud, Gemini-Fallback, RAM-Check, DDGS-Websuche" — Zeile für Zeile gegen den realen Code. Zusätzlich wurde die vom Lead geforderte **Modell-Diskrepanz** (app.py vs. PROJECT.md) untersucht und der **Ist-Zustand** der lokalen Inferenz auf der Prüfmaschine empirisch verifiziert.

## 2.2 Gesamtarchitektur: Zwei-Betriebsarten-Design ✅

Die App ist eine **standalone macOS-Desktop-App**: PyWebView-Fenster vor FastAPI-Backend, alternativ Cloud-Deployment (Docker/Cloud Run + Firebase).

| Befund | Status | Beleg |
|---|---|---|
| FastAPI-App instanziiert („Legal Ops Advisor", v1.0.0) | ✅ | `APP/app.py:77` — `app = FastAPI(title="Legal Ops Advisor", version="1.0.0")` |
| Desktop-Modus: Uvicorn auf **127.0.0.1:7070** | ✅ | `APP/desktop_app.py:44-45` — `uvicorn.run(app, host="127.0.0.1", port=7070, log_level="error")` |
| Natives macOS-Fenster via PyWebView (1200×800) | ✅ | `APP/desktop_app.py:60-66` — `webview.create_window('Legal Ops Advisor v6.0 M4-Native :: Polymath-Core', 'http://127.0.0.1:7070', ...)` |
| Backend-Thread als Daemon vor Fensterstart | ✅ | `APP/desktop_app.py:52-57` |
| Cloud-Modus: `__main__` bindet auf 0.0.0.0, Port via ENV (Default 8080) | ✅ | `APP/app.py:599-601` — `uvicorn.run("app:app", host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))` |
| Docker- + Firebase-Deployment-Artefakte vorhanden | ✅ | `APP/Dockerfile`, `APP/firebase.json` (Dateien existieren im Projektroot) |
| Zwei Betriebsarten dokumentiert (ONLINE=Cloud Run Frankfurt/Firebase, OFFLINE=Mac/Ollama) | ✅ | `APP/CLAUDE.md:6-8` |

**Festgestellte Auffälligkeit (positiv):** Der Desktop-Modus bindet ausschließlich auf `127.0.0.1` (`desktop_app.py:45`) — das Backend ist im Offline-Betrieb nicht aus dem LAN erreichbar. Architektonisch sauber für den Datenschutz. Der `__main__`-Pfad (0.0.0.0) ist der Cloud-Deployment-Pfad, kein Desktop-Risiko (vgl. § 2.10).

## 2.3 LLM-Backend-Orchestrierung: BACKEND_MODE + Fallback-Kette ✅

| Befund | Status | Beleg |
|---|---|---|
| `BACKEND_MODE` mit drei Modi **auto / local / cloud**, Default „auto" | ✅ | `APP/app.py:34-35` — Kommentar: `# BACKEND_MODE: "auto" (lokal-first, Fallback Gemini) \| "local" (nur lokal) \| "cloud" (nur Gemini)`; `BACKEND_MODE = os.environ.get("BACKEND_MODE", "auto").lower()` |
| Desktop-App setzt Default „auto" (lokal-first) | ✅ | `APP/desktop_app.py:2` — `os.environ.setdefault('BACKEND_MODE','auto')   # lokal-first (Ollama), Gemini-Fallback bei Bedarf` |
| Ollama-Endpoint konfigurierbar, Default nativer `/api/chat` auf :11434 | ✅ | `APP/app.py:36` — `LOCAL_LLM_URL = os.environ.get("LOCAL_LLM_URL", "http://localhost:11434/api/chat")` |
| Lokaler Modell-Default `gemma4:12b-it-qat` | ✅ | `APP/app.py:37` — `LOCAL_LLM_MODEL = os.environ.get("LOCAL_LLM_MODEL", "gemma4:12b-it-qat")` |
| Lokaler Timeout 180s (konfigurierbar) | ✅ | `APP/app.py:38` |
| Einheitlicher Einstieg `call_llm()`: auto→lokal zuerst, bei Fehler Gemini; local→nie Cloud; cloud→nur Gemini | ✅ | `APP/app.py:252-265` — inkl. ehrlichem Fehler-Return `{"response": f"Lokales Modell nicht erreichbar: {e}", "backend": "none", "status": "error"}` (Z. 264) |
| Ollama-Call mit `think: False` (Reasoning-Modelle würden sonst Token-Budget ins „Denken" schütten) | ✅ | `APP/app.py:229-249`, insb. Z. 240 — `\"think\": False` mit erklärendem Docstring Z. 230-232 |
| Gemini-Fallback mit 4er-Kandidatenliste (2.5-flash → 2.5-pro → 1.5-flash → 1.5-pro) | ✅ | `APP/app.py:205` — `candidate_models = [...]`; Retry-Loop `APP/app.py:214-225` |
| Primäres Cloud-Modell `gemini-2.5-flash` | ✅ | `APP/app.py:31` — `GEMINI_MODEL = "gemini-2.5-flash"` |
| Modellauswahl durch Benchmark begründet (2026-07-22: Gemini 2.5 Flash einziges korrektes Rechtsmodell; gemma4:12b-it-qat bestes lokales, QAT ~2× schneller; qwen2.5-coder:14b/phi3:mini „halluzinieren Gesetze") | ✅ (Doku) | `APP/CLAUDE.md:14-16` — ⚠️ Benchmark-Rohdaten selbst liegen nicht im Repo vor (Behauptung in Doku, plausibel) |
| Health-Endpoint exponiert aktiven Backend-Modus transparent | ✅ | `APP/app.py:300-308` — liefert `backend`, `backend_mode`, `model`, `personas` |
| Veralteter Modul-Docstring („gemini-1.5-pro") im Dateikopf | ⚠️ | `APP/app.py:4` — Docstring nennt noch „FastAPI → Google GenAI SDK (gemini-1.5-pro)", Code nutzt längst 2.5-flash (Z. 31). Kosmetik, kein Funktionsfehler. |
| Deaktivierter alternativer Inferenzpfad (LiteRT-LM auf Port 9379) | ⚠️ | `APP/desktop_app.py:16-41` (Funktion `start_litert`), deaktiviert in `desktop_app.py:48-49` — `# Starte LiteRT-LM deaktiviert (Ollama/phi3:mini & Gemini Cloud API werden verwendet)`. Toter, aber harmloser Code; Kommentar nennt zudem phi3:mini, nicht den aktuellen Default. |


## 2.4 ⚠️ ZENTRALBEFUND: Modell-Diskrepanz — Doku vs. Code vs. Ist-Zustand

Das Briefing hat die Diskrepanz korrekt antizipiert; das Audit bestätigt und verschärft sie auf drei Ebenen:

**Ebene 1 — Code vs. PROJECT.md (Dokumentations-Drift):** ❌ PROJECT.md ist veraltet.

| Quelle | Aussage | Beleg |
|---|---|---|
| `APP/PROJECT.md:11` | „LLM Server (Ollama): executing **`qwen2.5-coder:14b`** (primary) and **`deepseek-coder`** (fallback) on port 11434" | widerspricht Code |
| `APP/PROJECT.md:35-38` | Interface-Contract: `POST .../v1/chat/completions` (OpenAI-kompatibel), Payload `"model": "qwen2.5-coder:14b"` | widerspricht Code |
| `APP/app.py:36-37` | Tatsächlich: nativer Ollama-Endpoint `/api/chat`, Modell `gemma4:12b-it-qat` | Code-Stand |

PROJECT.md beschreibt einen **älteren Architekturstand** (OpenAI-kompatibler Endpoint, qwen-Modell, deepseek-Fallback). Der Code nutzt den **nativen** Ollama-`/api/chat`-Endpoint (`app.py:36, 244`) mit `think:false`-Fix (`app.py:240`) und gemma4 als Default. Erklärbar durch Chronologie: `CLAUDE.md:14-16` datiert die Modell-Neuwahl auf den Benchmark vom 22.07.2026; PROJECT.md wurde nicht nachgezogen. **⚠️ Architektur korrekt implementiert, Projektdoku driftet** — prüfrelevant, weil ungeprüfte Doku-Zitate falsche Modelle behaupten würden.

**Ebene 2 — Code vs. Ist-Zustand der Prüfmaschine (empirisch, 28.07.2026):** ⚠️ Referenzmodell nicht geladen.

```
$ which ollama → /opt/homebrew/bin/ollama
$ ollama list  → phi3:mini  4f2222927938  2.2 GB   (einziges Modell)
$ curl http://localhost:11434/api/tags → ['phi3:mini']
```

Ollama **läuft** (API antwortet), aber nur **`phi3:mini` ist installiert — nicht das im Code referenzierte `gemma4:12b-it-qat`**. Konsequenzen, ehrlich benannt:

1. Im Default-Modus `auto` (`desktop_app.py:2`) schlägt der lokale Call fehl; `call_llm()` fällt **bei jeder Anfrage auf Gemini zurück** (`app.py:258-265`). Die App ist im Ist-Zustand **faktisch cloud-betrieben**, obwohl die Architektur lokal-first ist.
2. `phi3:mini` ist laut eigener Doku für Recht **ungeeignet** („halluzinieren Gesetze", `CLAUDE.md:16`). Manuelles `LOCAL_LLM_MODEL=phi3:mini` wäre fachlich riskant.
3. Der Fallback funktioniert **genau wie designed** — kontrollierte Degradation statt Crash (`app.py:261-262`). Das ist Architekturqualität; der Ist-Zustand ist Betriebs-Schwäche.

**Ebene 3 — Behauptungsebene (Briefing „gemma4:12b-it-qat lokal"):** ⚠️ Lokaler Inferenzpfad **architektonisch vollständig verifiziert** (Code ✅), **betrieblich aktuell nicht lauffähig** (Modell fehlt). Die anwaltliche Leitthese („lokale Inferenz existiert strukturell") bleibt auf Code-Ebene wahr; „lokale Inferenz läuft" wäre im Ist-Zustand falsch.

## 2.5 RAM-Schutz (Resource Guard) ✅

| Befund | Status | Beleg |
|---|---|---|
| Konfigurierbares RAM-Minimum, Default 128 MB | ✅ | `APP/app.py:45` |
| Plattformübergreifende Messung: Linux `/proc/meminfo`, macOS `vm_stat` (free+inactive × page size); Fallback 8192 MB | ✅ | `APP/app.py:47-72` |
| **Harte Durchsetzung** vor jeder Inferenz: HTTP 503 „RAM-Schutz aktiv" | ✅ | `APP/app.py:454-460` — `if free_ram < RAM_MINIMUM_MB: raise HTTPException(status_code=503, ...)` |
| Check-Logging | ✅ | `APP/app.py:455` |

**Einordnung:** Technisch durchgesetzt (kein Prompt-Wunsch), schützt die Maschine vor OOM beim lokalen Modell. Anmerkung: Default 128 MB prüft nur ein Mindestmaß, nicht den tatsächlichen Bedarf eines 12B-Modells (~7-8 GB) — der Guard verhindert Kollisionen, garantiert aber keine erfolgreiche lokale Inferenz. ✅ mit Kalibrierungs-Anmerkung.
