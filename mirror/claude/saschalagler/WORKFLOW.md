# Unified Dev Intelligence Stack (UDIS) Workflow Documentation

## 🎯 Ziel
Dieses Dokument beschreibt den idealen, orchestrierten Workflow zur Entwicklung und Verifikation der "Cali Atlas Coaching App". Das Ziel ist die nahtlose Nutzung von spezialisierten AI-Agenten (Hermes, Claude Code, PI) unter einem zentralen Kontrollpunkt.

## 🛠️ Kritische Komponenten
1. **Logbook Service (`src/services/LogbookService.ts`):** Der zentrale Datenakquise-Punkt. Alle Trainingsdaten müssen hier durchlaufen und den ZNS-Score berechnen lassen.
2. **State Manager (`src/state/SessionManager.ts`):** Verwaltet den Zustand der aktuellen Session (aktiv, in Bearbeitung, etc.).
3. **Orchestrator Script (`.claude/unified-dev.sh`):** Der Startpunkt für alle Entwicklungsarbeiten.

## 🔄 Workflow-Definition: Vom Rohdaten-Input zum fertigen Feature

### Phase 1: Datenaufnahme (Logbook)
*   **Tool:** `src/utils/MockLogger.ts` / Logbook UI
*   **Aktion:** Der Benutzer gibt die Trainingssätze ein. Die Daten werden durch den `SessionManager` geleitet, der den ZNS-Score berechnet und das Set im Zustand speichert.

### Phase 2: Code-Review & Refactoring (Claude Code)
*   **Tool:** Claude Code CLI (`/Users/saschalagler/.local/bin/claude`)
*   **Aktion:** Nach der Datenaufnahme wird ein Feature, das die Logbook-Daten verarbeitet (z.B. eine neue API-Endpunkt), an Claude Code übergeben.
*   **Fokus:** Qualitätssicherung des Codes, Einhaltung von Best Practices und Fehlerbehebung basierend auf den erfassten Trainingsdaten.

### Phase 3: Schnelle Implementierung & Prototyping (PI)
*   **Tool:** PI Binary (`/Users/saschalagler/.local/bin/pi`)
*   **Aktion:** Für kleine, isolierte Logik-Probleme oder das schnelle Generieren von Boilerplate Code.
*   **Fokus:** Geschwindigkeit und Funktionalität (Minimum Viable Product).

### Phase 4: Orchestrierung & Verifikation (Hermes)
*   **Tool:** Hermes Agent (`hermes`)
*   **Aktion:** Hermes fungiert als "Conductor". Er koordiniert die Tools.
    1.  Er startet den Workflow über `.claude/unified-dev.sh`.
    2.  Er nutzt `session_search` und `memory` um Kontext zu erhalten.
    3.  Er delegiert Aufgaben: Logbook $\rightarrow$ Claude Code (Review) $\rightarrow$ PI (Fix).

## ⚠️ Wichtige Pitfalls & Best Practices
*   **Rate Limits:** Bei der parallelen Nutzung von APIs (Claude, Hermes, etc.) müssen die Tools nacheinander oder in Batches verwendet werden. Der `unified-dev.sh` Script ist dafür konzipiert.
*   **ZNS/Form vs. Physik:** Denken Sie immer daran: Die App fokussiert sich auf **funktionale Performance und Form**, nicht auf Drehmoment (Nm) oder physikalische Berechnungen. Diese Daten müssen im Logbook-Service ignoriert werden, wenn sie nicht direkt aus der Bewegungserfassung stammen.
*   **Modellwahl:** Nutzen Sie Qwen3.5 Coder über LM Studio als primäres Coding-Backend für Konsistenz und lokale Performance.

## 🚀 Nächste Schritte (Action Items)
1.  [ ] **Testen:** Führen Sie `./unified-dev.sh` aus, um die gesamte Kette zu testen.
2.  [ ] **Verfeinern:** Implementieren Sie die API-Schnittstelle für den ZNS-Score in `LogbookService.ts`.
3.  [ ] **Dokumentation:** Aktualisieren Sie dieses Dokument mit erfolgreichen Testläufen und gefundenen Workarounds.