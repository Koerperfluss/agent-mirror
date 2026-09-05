---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LegalOpsAdvisor_Sacha_Mac/LegalOpsAdvisor_Schellenbacher/Anleitung.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Legal Ops Advisor — Anleitung

KI-Rechtsassistent für das gesamte österreichische, DACH- & EU-Recht (Zivil/Straf/Verwaltung/Sozial/Steuer/Gesellschaft), mit RIS-Judikatur-Grounding (VwGH/OGH/EuGH).

## 1. Web-App (empfohlen zum Testen)
Link in `Web-App.txt`. Öffnet sofort im Browser, nichts zu installieren. Handy: Safari → Teilen → „Zum Home-Bildschirm".
Nutzung: Fall oder Rechtsfrage ins Feld schreiben → Antwort im Kanzlei-Format (Ergebnis/BLUF, Prüfprotokoll, Masterplan, Exekution). Auto-Routing über 6 interne Fach-Agenten.

## 2. Mac-App (lokal)
`Mac-App/Installieren.command` doppelklicken. Voraussetzung: Python 3.11+, ein Google-Gemini-API-Key (wird einmalig abgefragt). Fenster öffnet sich lokal.

## 3. Prompts
Ordner `Prompts/`: die vier Fach-Personas (legal_ops_omni = God-Mode-Master v7, gdb, vwgh, compliance).

## 4. Architektur (kurz)
Frontend (index.html) ↔ Backend (FastAPI, Gemini 2.5 Flash). Web läuft auf Google Cloud (Frankfurt). Lokal optional mit eigenen Modellen (Ollama) statt Cloud.
