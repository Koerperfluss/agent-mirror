---
app: claude
quelle: "saschalagler/unified-dev-master.md"
stand: 2026-09-05
tags: [spiegel, claude]
---

# 🧠 Unified Dev Intelligence Stack

## 🏷️ System Name: Unified Dev Intelligence Stack (UDIS)

Dieser Stack synchronisiert drei verschiedene Agenten-Ansätze, um die maximale Effizienz aus Coding, Orchestrierung und Review herauszuholen.

---

## 🛠️ Modell- & Agenten-Matrix

| Agent | Rolle | Modell | Provider | Port | Fokus |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Hermes** | **Orchestrator** | `Qwen3.5 Coder` | LM Studio | 1234 | Strategische Planung, Tool-Steuerung, State-Management |
| **PI** | **Execution** | `Qwen3.5 Coder` | LM Studio | 1234 | Schnelles Coding, Iterative Implementierung, Datei-Edits |
| **Claude Code**| **Reviewer** | `Claude 3.5` | Anthropic | 8082 | Deep Review, Architekturcheck, 1M Kontext Fenster |
| **Ollama** | **Utility** | `Gemma 4` | Local | 11434 | Web-Search, schnelle Validierungen, Backup-Modell |

---

## 🔄 Der Unified Workflow

1. **PLANNING (Hermes)**: Erstellung von TODOs, Definition der Architektur und Zuweisung von Teilaufgaben.
2. **CODING (PI)**: Die eigentliche Umsetzung des Codes. PI schreibt die Dateien und führt erste Tests durch.
3. **REVIEW (Claude Code)**: Claude analysiert den gesamten Kontext (1M Token), findet Edge-Cases und gibt architektonisches Feedback.
4. **REFINEMENT (PI $\rightarrow$ Hermes)**: Fehlerbehebung durch PI und Abschluss der Aufgabe in Hermes.

---

## 📜 Start-Orchestrierungs-Skript (`unified-dev.sh`)

Kopiere diesen Block in deine Datei `~/.claude/unified-dev.sh`:

```bash
#!/bin/bash

# ==============================================================================
# UNIFIED DEV ORCHESTRATOR
# Ziel: Synchronisation von LM Studio, Hermes, PI und Claude Code
# ==============================================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}--- Starting Unified Dev Workflow ---${NC}"

# 1. LM Studio Check
if curl -s http://localhost:1234/v1/models > /dev/null; then
    echo -e "${GREEN}[✓] LM Studio ACTIVE on port 1234 (Qwen3.5 Coder)${NC}"
else
    echo -e "${RED}[!] LM Studio NOT detected! Bitte starte LM Studio.${NC}"
fi

# 2. Ollama Check
if curl -s http://127.0.0.1:11434/api/tags > /dev/null; then
    echo -e "${GREEN}[✓] Ollama ACTIVE on port 11434${NC}"
else
    echo -e "${RED}[!] Ollama NOT detected.${NC}"
fi

echo -e "\n${BLUE}--------------------------------------------------${NC}"
echo -e "🚀 STATUS: ALL SYSTEMS READY"
echo -e "${BLUE}--------------------------------------------------${NC}"
echo -e "Workflow-Anleitung:"
echo -e "1. PI (Coding)     -> Schnelle Umsetzung"
echo -e "2. Hermes (Plan)   -> Steuerung & State"
echo -e "3. Claude (Review) -> Architektur & Kontext"
echo -e "--------------------------------------------------"
```
