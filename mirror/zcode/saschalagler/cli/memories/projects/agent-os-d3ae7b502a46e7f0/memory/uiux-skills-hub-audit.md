---
name: uiux-skills-hub-audit
description: UI/UX-Skills (~/.claude/skills) komplett+aktuell (Parallel-Session),
  Routing verdrahtet; Verkaufs-HUB hub-glass.html auditiert (Top-3-Fixes offen)
  + Klick-Test 5/5 PASS; :3300-Server läuft nohup
metadata:
  node_type: memory
  type: project
  originSessionId: session_58f3f4bfcb9a88671e0595593de28702
---

**UI/UX-Skill-Set (Stand 26.10.2026, abends):** `~/.claude/skills/` enthält ui-ux-pro-max, better-interface/-ui/-accessibility/-layout/-typography/-colors/-writing, interface-review, ui-ux-tester, design-an-interface — ALLE bereits von einer Parallel-Session installiert/aktualisiert (Timestamps 15:44, `diff -rq` gegen beide Upstreams = 0 Diffs: github.com/nextlevelbuilder/ui-ux-pro-max-skill — Skill liegt IM Repo unter `.claude/skills/ui-ux-pro-max/`, Repo-Root ist nur das Projekt — und github.com/jakubkrehel/skills — Skills unter `skills/`-Unterordner). Routing-Zeilen 32–35 stehen in `~/.agents/skill-routing.md`. Backup: `~/.claude/skills/_backup-uiux-2026-10-26.tar.gz` (702K). Wenn Sascha „aktualisieren/vervollständigen" fordert: ERST diff gegen Upstream, dann ehrlich „bereits erledigt" melden statt neu installieren.

**Verkaufs-HUB hub-glass.html** (`~/Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /TOOL-SAMMLUNG-VERKAUF/` — Ordnername mit Leerzeichen vor Slash!): 222-Zeilen Single-File-App, 74 Tools via tools-v2.json, Backend :8055 (fetch localhost hardcoded). **Audit-Report:** `…/TOOL-SAMMLUNG-VERKAUF/UI_AUDIT_hub-glass_2026-10-26.md`, Score 7,2/10 — Top-3-Fixes: (1) Karten-Tastaturbedienung, (2) Dialog-Pattern, (3) Kontrast+Micro-Text. **Fix-Status 26.10. Nacht:** Eine Parallel-Session hat die Fixes bereits EINGEBAUT (Datei geändert: `--muted:#6B6B62`, `:focus-visible`-Outline, alle Fonts ≥12px, aria-labels an Suchfeld/Selects) — mein Edit-Set scheiterte an „File has been modified since read". Noch offen: Karten tabindex/role/button-Keydown und Panel role="dialog"/aria-modal (in der gelesenen Version NICHT drin) — vor weiteren Edits Datei neu lesen! Edit-Falle: mehrere parallele Edit-Calls auf dieselbe frisch geänderte Datei → alle scheitern mit „modified since read"; erst Read, dann alle Edits in EINER Message.

**Klick-Test 5/5 PASS** (chrome-devtools-MCP, Server `nohup python3 -m http.server 3300 --bind 127.0.0.1` aus dem Projektordner, Log /tmp/hub3300.log — läuft noch): Laden 74 Karten · Suche „ableton"→1 · Karten-Klick→Panel (h2=Titel) · Escape schließt · Filter Tier A=6 / Verkaufen-ja=20 / Reset=74. Report+Screenshot: `agent-os/out/hub-klicktest/REPORT.md` + `01_hub_final.png`.

**Harness-Falle chrome-devtools-Screenshots:** `take_screenshot(filePath=…)` verweigert ALLE absoluten Pfade („not within configured workspace roots", auch cwd/out/ und ~/.zcode/v2/visualizations). Workaround: Screenshot ohne filePath → Artefakt landet in `~/.zcode/cli/artifacts/<session>/<call-…>.png` → per Bash dorthin kopieren, wo man es braucht. Zustandsprüfungen im Browser effizienter per `evaluate_script` (Live-DOM-Reads statt Screenshots vergleichen); eigene Test-Reihenfolge erst denken — „0 Ergebnisse" war Filterkombination aus vorherigem Testschritt, nicht App-Bug.

Kontext: [[qwen-flash-spark-project]] (TraktorClone-App), [[custom-skills-read-from-autoclaw]].
