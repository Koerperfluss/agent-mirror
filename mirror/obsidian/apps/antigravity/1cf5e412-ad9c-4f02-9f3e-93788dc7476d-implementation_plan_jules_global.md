---
app: antigravity
quelle: "1cf5e412-ad9c-4f02-9f3e-93788dc7476d/implementation_plan_jules_global.md"
stand: 2026-09-05
tags: [spiegel, antigravity]
---

# Masterplan Update: Globaler Jules Meta-Agent

> **Zweck:** Du hast 100+ Projekte, nicht nur 6. Der alte Plan war zu restriktiv. Dieser Plan macht den "Jules Meta-Agent" (und andere Tools) **permanent** als Plugin in deiner Antigravity IDE verfügbar. So kannst du in *jedem* beliebigen Projekt-Ordner `@jules` tippen, um ihn zu rufen.

## 1. System-Architektur (Neu)

| Komponente | Rolle in der Automation |
|---|---|
| **Antigravity IDE** | Zentraler Chat, aus dem heraus du alles steuerst |
| **@jules (Subagent)** | Ein permanentes IDE-Plugin. Er übernimmt die Code-Ausführung im *aktuellen* Projekt-Ordner |
| **Google Premium API** | Liefert die Intelligenz für Jules (Kosten akzeptiert) |
| **Tools (Genkit/SDK)** | Werden von Jules dynamisch genutzt, unabhängig vom Projekt |

## 2. User Review Required

> [!IMPORTANT]
> **Paradigma-Wechsel:** Jules ist dann kein Ordner (`teamwork_projects/jules_agent`) mehr, sondern ein *systemweites Plugin* in `~/.gemini/config/plugins/`. Er operiert immer genau in dem Ordner, den du gerade in der IDE geöffnet hast. Ist das exakt so, wie du dir das wünschst?

## 3. Proposed Changes

### [NEW] `~/.gemini/config/plugins/jules-meta-agent/plugin.json`
- Definiert das Jules-Plugin für deine IDE.

### [NEW] `~/.gemini/config/plugins/jules-meta-agent/agents/jules/AGENT.md`
- Der System-Prompt für den Jules-Agenten.
- Verleiht ihm die Fähigkeit, in beliebigen Codebases (deinen 100 Projekten) Code zu analysieren, zu schreiben und das Antigravity SDK zu nutzen.

### Migration der alten Dateien
- Der alte Ordner `teamwork_projects/jules_agent` wird obsolet. Die Logik wandert direkt in die IDE.

## 4. Verification Plan

### Manual Verification
1. IDE neu laden.
2. In einem beliebigen deiner 100 Projekte `@jules` im Chat tippen.
3. Test-Befehl: "Jules, gib mir eine kurze Zusammenfassung dieses Projekts."
4. Jules muss antworten und den lokalen Kontext nutzen.
