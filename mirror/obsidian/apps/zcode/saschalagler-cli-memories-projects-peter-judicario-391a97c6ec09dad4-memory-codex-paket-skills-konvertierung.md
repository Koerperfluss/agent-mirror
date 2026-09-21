---
app: zcode
quelle: "saschalagler/cli/memories/projects/peter-judicario-391a97c6ec09dad4/memory/codex-paket-skills-konvertierung.md"
stand: 2026-09-21
tags: [spiegel, zcode]
---

---
name: codex-paket-skills-konvertierung
description: Codex-Paket-Skills KOMPLETT konvertiert+installiert (21.09., Agenten-Team R1/B1/Q1) — 10 neue Skills, CLIs hcom/skillshare/uipro grün, QA 17/17 PASS; Wayfinder-Map dokumentiert
metadata:
  node_type: memory
  type: project
  originSessionId: sess_8db9086b-109a-4839-8ff9-e33012080869
---

Ordner `/Users/saschalagler/Desktop/Coworkspace_Ich/LOKI_OS_CODEX_PAKET/Local AI /skills/` enthält **keine Skills**, sondern nur PDF/PNG/HTML-Anleitungen (Sascha fragte 21.09., warum sie „nicht ausführbar" sind). Erklärung geliefert: Ein Skill = Ordner mit `SKILL.md` in `~/.agents/skills/`; ZCode scannt nur feste Ordner, nie Desktop-Ordner; Plugin-Auswahl im UI ≠ Skills. Neue Skills erscheinen erst nach Session-Neustart in der Auswahlliste (Liste lädt beim Session-Start).

**Umsetzung (21.09. Abend, auf Saschas expliziten Befehl „Agenten-Team: alles durchsuchen, recherchieren, downloaden, anpassen, einpegeln, melden wenn alles funktioniert"):** Wayfinder-Map `/Users/saschalagler/.agents/.wayfinder/SKILL-AUSBAU-2026-09-21.md` · Subagent R1 (Web-Recherche, agent_60c30aca) → B1-Agent wurde von Sascha abgebrochen → **Bauphase inline erledigt** → QA per Bash (Frontmatter + Binaries). Ergebnisse:

- **agent-hcom** — raw SKILL.md von github.com/aannoo/hcom (`skills/hcom-agent-messaging/`), name-Feld auf `agent-hcom` angeglichen; CLI `brew install aannoo/hcom/hcom` → hcom 0.7.25. (Agent-zu-Agent-Terminal-Messaging.)
- **skillshare-sync** — CLI `brew install skillshare` → v0.21.3; eigene SKILL.md (Kernbefehle init/sync --all/mcp --dry-run/target/ui; `init` NICHT ausgeführt — schreibt Konfigs, braucht GO).
- **ui-ux-pro-max** — raw SKILL.md aus Repo `.claude/skills/ui-ux-pro-max/`; `npm i -g ui-ux-pro-max-cli` → uipro 2.15.0 (129k★, 192 Paletten/119 UX-Guidelines).
- **better-interface / better-ui / better-accessibility** — geklont von github.com/jakubkrehel/skills (7k★) nach `~/.agents/skills/`.
- **design-ux-ui** — aus PDF „Design Skill - UX:UI" (Palette-Rolle: 1 Mikro-UX-Verbesserung/Lauf, A11y-Checks, <50 Zeilen).
- **loki-os-standard** — aus PDF „LOKI-OS_Standard-Skills" (Skill-Tree, Ponytail, Plan-Gate, Routing-Tabelle, GLM-Betrieb, Stop-Regeln).
- **paseo-orchestrate** — eigene SKILL.md (paseo.sh, ~17k★; App-INSTALL NICHT ausgeführt — braucht Sascha-GO).
- **ai-os-voice-layer** — PDF „Build a Cinematic Website" war FALSCH BENANNT, Inhalt = AI-OS/Voice-Layer-Guide (Claude Code Engine + Obsidian-Vault raw/wiki/outputs + lokale STT/TTS + HUD; direkt LokiVoice-relevant).
- Alle nach `~/.openclaw-autoclaw/skills/` gespiegelt. **QA: 17/17 PASS** (SKILL.md + Frontmatter + Binaries hcom/skillshare/uipro/iris/soffice).

**Recherche-Nebenbefunde:** github.com/Santofer/Remindian = macOS Menubar-App (Obsidian-Tasks ↔ Apple Reminders/Things/Todoist, `brew install --cask santofer/tap/remindian`) — KEIN Browser-Automation-Tool (Sascha hatte „Browser ersatz" vermutet). YouTube zbmuiaPuiNM = Cole Medin „Google … Masterclass on Agentic Engineering": PIV-Loop (Plan→Implement→Validate), AI-Layer mit versionierten Rules/Commands/Skills, „alles 3× Promptierte wird Skill".

Siehe [[sascha-output-standard]], [[ma-standard-pipeline]].
