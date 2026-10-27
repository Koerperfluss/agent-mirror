---
app: zcode
quelle: "saschalagler/cli/memories/projects/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e4-892c7edb1193a737/memory/zcode-skills-landscape.md"
stand: 2026-10-27
tags: [spiegel, zcode]
---

---
name: zcode-skills-landscape
description: Slash-Befehle für alle Skills in ~/.zcode/commands/ (251 Stück seit
  27.10.2026, inkl. /goal); sichtbar erst nach ZCode-Neustart; /workflow fest
  eingebaut; 11 Skill-Ordner kaputt; App-nachbauen = video2code-Plugin
metadata:
  node_type: memory
  type: project
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Sascha fragte wiederholt wütend „WO SIND MEINE SKILLS?" — dauerhafte Fakten (Workflow-Run 27.10.2026, maschinell gezählt):

1. **Persönliche Skills (`~/.claude/skills/`, 249 Ordner, 218 gesund) erscheinen NIE im ZCode-Slash-Menü** — ZCode listet dort nur Plugin-/Bundled-Skills. Sie laufen über AGENTS.md-Routing: Sascha sagt einen Satz („prüfe die UI von X"), der Agent lädt den Skill selbst. Das bei jeder solchen Frage SO erklären.
2. **Befehle:** `init.md`, `boost.md`, `standardskill.md` existieren bereits in `~/.zcode/commands/` (Format: Markdown mit `description:`-Frontmatter); `obsidian-init.md` wurde 27.10. neu angelegt; für `/goal` gab es keine Vorlage (nicht geraten). Ob neue Befehle ohne **App-Neustart** erscheinen, war ungetestet.
3. **`/workflow` und `/dwf` sind fest in ZCode eingebaut** (Registrierung in `/Applications/ZCode.app/Contents/Resources/glm/zcode.cjs`), keine Datei in commands/. 16 gespeicherte Workflow-Vorlagen in `~/.zcode/workflows/`.
4. **11 Skill-Ordner ohne SKILL.md** (kaputt): anatomie, beta, gstack + 4 gstack-openclaw-*, hackernews-frontpage, legal, research-ops-studienchecker, sequential-thinking.
5. **App-nachbauen-Pipeline** (Sascha nannte es „reverse engineering"): kein eigener Skill dieses Namens — das ist das Plugin **video2code** (`web-replicate`, `video2fullstack`, `url2video`, `video2code-3d`) plus `~/.claude/skills/image-to-code`. Voll-Umsetzung laut Routing: loki-dev BUILD → ralph-loop.

**Why:** Diese Fragen kommen wieder; die Antworten sind aus den Dateien nicht ohne Suche ableitbar. Verwandt: [[uiux-skills-repair-2026-10-26]], [[simple-language-responses]].
