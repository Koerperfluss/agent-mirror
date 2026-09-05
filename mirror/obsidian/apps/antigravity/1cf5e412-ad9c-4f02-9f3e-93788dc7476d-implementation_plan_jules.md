---
app: antigravity
quelle: "1cf5e412-ad9c-4f02-9f3e-93788dc7476d/implementation_plan_jules.md"
stand: 2026-09-05
tags: [spiegel, antigravity]
---

# Masterplan: Die Finale Automation (Jules Meta-Agent)

> **Zweck:** Aufbau des zentralen KI-Chefentwicklers (Jules), der deine Kommandos ("Füge Feature X zu Y hinzu") entgegennimmt und den Code autonom in den 6 Projekten schreibt.

## 1. System-Architektur (Wie alles zusammenhängt)

| Komponente | Rolle in der Automation | Genutzte Technologie |
|---|---|---|
| **Du (Sascha)** | Gibt den Befehl in natürlicher Sprache | Antigravity IDE (Chat) |
| **Jules Meta-Agent** | Versteht den Befehl, plant die Code-Änderung | Google Premium Modelle (Gemini Pro) |
| **Routing-Engine** | Leitet den Befehl an das richtige Projekt (Cali, LOKI) | Genkit & Antigravity SDK |
| **Lokale Agenten** | Führen die Code-Änderung in ihrem Ordner aus | Plain Python Tool Functions |

## 2. User Review Required

> [!IMPORTANT]
> **API-Kosten & Premium Tools:** Jules wird intensiv auf die Google API zugreifen, um Code zu analysieren und zu schreiben. Da dein Billing aktiv ist, werden hierbei Token verbraucht. Bist du mit der Nutzung der Premium-Modelle für diese autonome Code-Erstellung einverstanden?

## 3. Proposed Changes (Umsetzungsschritte)

### Schritt 1: Jules Python-Environment fixen
- `pytest` und fehlende Dependencies installieren.
- Sicherstellen, dass Jules lokal auf deinem M4 fehlerfrei läuft.

### Schritt 2: SDK & Genkit Integration
- **[MODIFY]** `jules_agent/src/jules/agent.py`
  - Integration von `google.antigravity` und Genkit für strukturiertes Tool-Calling.
  - Hinzufügen der Fähigkeiten, die 6 lokalen `antigravity_agent.py` Dateien der anderen Projekte aufzurufen.

### Schritt 3: Der erste Live-Test
- Wir geben Jules einen echten Test-Befehl (z.B. "Füge eine neue Route im Cali Coach Atlas hinzu").
- Jules muss den Code ohne mein oder dein Zutun schreiben.

## 4. Verification Plan

### Automated Tests
- `python3 -m pytest tests/` im Jules-Ordner muss grün sein.

### Manual Verification
- Ein Live-Kommando von dir in der IDE, das erfolgreich in einem der 6 Projekte Code verändert.
