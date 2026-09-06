---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/legal-ops-native-status.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: legal-ops-native-status
description: Legal-Ops+Native-Diagnose 06.09. ABGESCHLOSSEN — Verschmelzung
  FUNKTIONIERT (App+Backend live verifiziert); Root Cause „kaputt" =
  4-App-Varianten-Wirrwarr; Architektur-Fakten (Port 7070, venv,
  Ollama-Personas)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc
---

**P0-Diagnose 06.09. 17:15 („alles und abfahrt"-Session): Legal Ops Native Verschmelzung FUNKTIONIERT** — live verifiziert: App gestartet → Fenster „Legal Ops Advisor v7.0 // M4 Native" voll geladen (Fristen- & Schulden-Cockpit, € 4.814,68 offen, 12 Fallkarten), kein Spinner/Fehler. Details: `~/LegalOpsAdvisor_Sacha_Mac/STATE.md`.

**Root Cause des „App funktioniert nicht"-Eindrucks = 4-App-Varianten-Wirrwarr** (nicht Code!):

| Variante | Pfad | Stand |
|---|---|---|
| **Native Legal Ops.app** | `~/Desktop/` | Sep 4 — ✅ DIE funktionierende |
| NativeLegalOps.app | `~/Applications/` | Aug 26, alt |
| Legal Ops Advisor.app | `~/Applications/` | Jul 28, andere Bundle-ID `com.saschalagler.legalopsadvisor` |
| com.saschalagler.NativeLegalOps | `~/.Trash/` | WebKit-Cache-Leiche |

Fix = alte Varianten aus `~/Applications/` entfernen (Lösch-Stopp-Regel → GO) + gute App nach /Applications + Dock.

**Architektur-Fakten:** SwiftUI macOS 14+ (SPM, min 1100×720, Dark) · Backend FastAPI `legal-ops-advisor/app.py` auf **127.0.0.1:7070**, Ollama `qwen2.5-coder:1.5b`, 5 Personas (legal, legal_ops_omni, gdb, vwgh, compliance) · App startet Backend selbst: ProcessManager → `.venv/bin/python -m uvicorn app:app` (venv 3.14 vorhanden, HOME-absolut) · Health-Poll 0,3 s · bekannte kosmetische Race: AppDelegate greift `windows.first` vor WindowGroup-Anlage. Endpunkte inkl. `/launch_lokivoice`, `/lokivoice_status` (Thomas/LokiVoice-Verzahnung — [[loki-project-map]]).

**Offene Tickets:** (1) [GO] App-Varianten aufräumen, (2) `NativeLegalOps/run_e2e_tests.sh` durchlaufen, (3) LokiVoice-Endpunkte live testen (ein Thomas-System mit LOKI Voice).

**How to apply:** Bei „Legal-Ops-App kaputt": zuerst prüfen WELCHE der 4 Varianten gestartet wurde, nicht Code debuggen; Backend-Verifikation = `curl 127.0.0.1:7070/health` + `lsof -iTCP:7070`. Verwandt: [[loki-project-map]] [[autoclaw-full-stack-builder]]
