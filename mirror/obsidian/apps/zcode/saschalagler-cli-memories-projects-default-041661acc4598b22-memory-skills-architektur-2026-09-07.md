---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/skills-architektur-2026-09-07.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
name: skills-architektur-2026-09-07
description: Skill-Ausmist 07.09. — .zcode/skills ist BEWUSST leer (Skills laden
  nur via ~/.agents/skills), Archiv-Ort, skill-router existiert
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ecb2e5e0-e1f7-46fb-a5b9-a997d5485c8e
---

Skill-Audit 07.09.2026 (User-Weisung: nicht selbst werten; Vercel/Gemini/Claude/Matt-Pocock/Design BLEIBEN):

- `~/.zcode/skills` ist **bewusst leer** (125 Symlinks entfernt gegen Doppel-Einträge ~260→~126). ZCode lädt Skills NUR via `~/.agents/skills`. NICHT wieder befüllen — sonst Doppel.
- Archiv (reversibel): `~/.agents/skills-archive/2026-09-07/` — 5 Writing-Skills + lisa-therapeut-Echtkopie. Rückholbefehl im Audit-Doc.
- **skill-router** existiert neu (`~/.agents/skills/skill-router/`): wählt bei Build-/Code-Signalen automatisch 1–3 passende Teil-Skills (Matt-Pocock-, Design-, Vercel-, Gemini-, Claude-Suite). In skill-routing.md eingetragen.
- superpowers:*-Routing-Einträge entfernt (Skills existieren nicht mehr); Debug-Route = diagnosing-bugs.
- Nutzungs-Fakten (Memory-Check): caveman, cavecrew, agent-browser = belegt genutzt. Ohne Beleg, aber auf User-Entscheidung drin: market-intelligence-allrounder, persona-selector, jules-meta-agent, cli-serve, developing-ios-apps.
- Achtung (ÜBERHOLT/gelöst): skillshare legte beim Sync die Links neu an → **~/.config/skillshare/config.yaml: zcode-Target ENTFERNT** (07.09. spät). skillshare bedient ZCode nicht mehr; ZCode liest nur ~/.agents/skills. Die 119 Links + _sources__-Aliase wurden endgültig aus .zcode/skills entfernt.
- Shadow-Doppel gelöst: .agents/skills/caveman zeigte auf Suite-Root (13 SKILL.md darunter) → jetzt 7 Einzelsymlinks auf .gemini/extensions/caveman/skills/*.
- Obsidian repariert 07.09.: obsidian-second-brain description 1204→484 (der „1 error", lädt wieder); obsidian-vault WSL-Pfad → echter Vault **~/Documents/Obsidian Vault**; obsidian-sync.sh Testlauf grün.
- **Skill-Browser GUI**: `python3 ~/.agents/tools/skill_browser.py` → ~/Desktop/skill-browser.html (Suche+Filter, Status & Nutzungsnotizen). Nach Skill-Änderungen neu generieren.
- **Standard-Agents + Watcher (07.09. spät, Sascha wütend über Langsamkeit/Fanout):** benannte Agents leben in `~/.zcode/agents/*.md` (Format: frontmatter name/description/tools) — angelegt: code-architect, explore, implementer, reviewer (neben bestehenden cavecrew-*). **loki-watcher.py** = PreToolUse-Hook (matcher `Task|Agent`), zählt Agent-Spawns in /tmp/loki-agent-count.json, blockt ab dem 4. (Exit 2) — Fanout-Cap hart erzwungen. gate-enforcer.py war schon als UserPromptSubmit-Hook verdrahtet.
- **Neue Commands in `~/.zcode/commands/`:** /standardskill (Hausregeln reinstiefeln bei Rebellion), /init (Umgebungs-/Modellmessung + karpathy/ponytail/adhd aktivieren), /kanban (kanban-CLI liegt in /opt/homebrew/bin, Port 3484), /todo (todo-sync.py). Wirken erst nach ⌘Q-Neustart — Sascha hielt sie fälschlich für „immer noch nicht da".
- Performance-Lehre: ZCode wirkt langsamer als Cline CLI v.a. durch Skill-Beschreibungs-Ballast pro Call — Hauptfix war die Halbierung der Liste; Rest: 1 Task = 1 Session, /caveman lite (65 % Output-Ersparnis), Flash-first.
- Nutzungs-Fakten (Memory-Check): caveman, cavecrew, agent-browser = belegt genutzt. Ohne Beleg: market-intelligence-allrounder, persona-selector, cli-serve (OmniRoute-CLI-Steuerung), developing-ios-apps (von User als wichtig markiert), jules-meta-agent (Rollen-Skill, Google-Abo, im skill-router angebunden).

Audit-Doc: `~/loki-ki/docs/AUDIT_SKILLS_ZCODE_2026-09-07.md` · [[skill-install-conventions]] ist damit ÜBERHOLT (npx-Konvention erzeugt jetzt Doppel).
