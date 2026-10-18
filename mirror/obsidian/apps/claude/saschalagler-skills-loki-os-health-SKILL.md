---
app: claude
quelle: "saschalagler/skills/loki-os-health/SKILL.md"
stand: 2026-10-18
tags: [spiegel, claude]
---

---
name: loki-os-health
description: Health-Check des LOKI.Ökosystems („ist alles gesund/online?", Ports, MCP) mit Green/Yellow/Red-Brief und Checkpoint-Decision, plus kompakte Ökosystem-Landkarte. Aktivieren wenn der Nutzer "/status-check", "Status-Check", "System-Status prüfen", "Ist alles gesund/online?" oder einen täglich-automatisierten Check verlangt.
---

# LOKI.OS Health Check (AUSFÜHRBAR)

## WICHTIG: So läuft dieser Skill

**Schritt 1 — Skript ausführen (immer zuerst):**

```bash
bash ~/.agents/skills/loki-os-health/status_check.sh
```

(Der Pfad ist ein Symlink auf diesen Skill — bewusst so belassen für Kompatibilität mit memory-enhanced-decision-making.)

Das Skript prüft das VERIFIZIERTE reale System (Stand: Audit 31.08.2026) und schreibt einen Report nach `~/loki-ki/logs/status_check_*.md`. Die letzte Zeile des Outputs ist maschinenlesbar: `CHECKPOINT: CONTINUE | REVIEW | ACTION_NEEDED`.

**Schritt 2 — Ergebnis interpretieren und dem Nutzer den Brief zeigen:**

| Checkpoint | Bedeutung | Deine Reaktion |
|---|---|---|
| `CONTINUE` | Alles grün | Kurz melden, fertig |
| `REVIEW` | Nur Warnings (bekannte Issues wie Ollama.app-Duplikat :11435) | Warnings auflisten, fragen ob fixen |
| `ACTION_NEEDED` | Mindestens ein kritischer Dienst DOWN (z.B. OmniRoute :20128, Ollama :11434, claude-mem in .mcp.json) | Sofort Diagnose anbieten: Audit-Findings (F-1 bis F-7) in `~/loki-ki/docs/AUDIT_LOKI_OS_2026-08-31.md` konsultieren |

**Schritt 3 — Bekannte Referenz-Zustände (damit du Warnungen einordnen kannst):**

| Service | Port | Soll-Zustand | Warum |
|---|---|---|---|
| LOKI Kernel | 8010 | UP (v15.3.0) | Läuft, aber CRITICAL: lauscht auf `*:8010` ohne Auth (LAN-RCE) |
| OmniRoute | 20128 | UP | Zentraler AI-Gateway |
| LegalOps MCP | 7070 | UP (4× dupliziert, Ziel 1×) | Domain-Tools |
| Ollama Brew | 11434 | UP | GLM-Cloud-Modelle |
| Ollama.app | 11435 | DOWN (F-4) | Duplikat, kollidiert mit Claude Desktop |
| Kanban | 3484 | UP | Task-Tracking |
| LM Studio / n8n / Antigravity Hub / LiteRT | 1234/5678/8081/9379 | DOWN ist OK | Wurden nie dauerhaft betrieben (Audit §3.2) |

**Regeln:**
- KEINE Prozesse killen oder Dienste starten ohne explizites GO des Nutzers.
- Bei `ACTION_NEEDED`: immer zuerst den konkreten Finding-Link aus dem Audit nennen.
- Der Nutzer will Tabellen — Brief in Tabellenform, keine Prosa.
- Report-Datei-Pfad im Brief nennen.

## Agent-Landschaft

> ⚠️ Stand Aug 2026, veraltet — live-Zustand: `loki-memory-sync status`. Die damalige MCP-Liste ist nicht mehr aktuell.

- **Antigravity** – Haupt-Orchestrierer, MCP-Integration, Docker Profile
- **Hermes Agent** – Self-improving AI, Learning Loop, Multi-Platform Gateway
- **Cline** – Entwicklungsagent mit CLI-Integration, Session Management
- **Gemini CLI** – Google Multi-Modal AI Integration
- **Claude Code** – Anthropic Agent mit Plugin-System
- **ZCode** – aktueller Coding-Agent (Eclipse)

Projekt-Ökosystem (damals): Loki OS (Port 8010), Cali Atlas (GCP Cloud Run), Antigravity PWA (Hub, 8081), Hermes Gateway (LaunchAgents).
