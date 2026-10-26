---
name: subagent-provider-fix-zai-api
description: Subagenten schlugen mit "provider-not-found" fehl — 8 Defs zeigten
  auf toten Provider zai-api; Fix + funktionierende Modell-Formate +
  Session-Cache-Falle
metadata:
  node_type: memory
  type: feedback
  originSessionId: session_58f3f4bfcb9a88671e0595593de28702
---

Saschas ZCode-Subagenten (~/.zcode/agents/*.md: cavecrew-*, implementer, qa-tester, reviewer, code-architect, config-auditor, explore) schlugen beim Dispatch mit `Cannot start subagent: Provider unavailable [provider-not-found; selection=zai-api/GLM-5.3-Flash]` fehl — obwohl die Subagents-UI sie alle anzeigt.

**Why:** Die Defs hatten `model: "zai-api/GLM-5.3-Flash"` — aber `zai-api` existiert NICHT in `~/.zcode/v2/provider_config.json` (providerOrder: `builtin:zai`, `omniroute`, `ollama`, `new-provider`). Der Name war schlicht falsch, nicht das System.

**How to apply:**
1. **Zwei funktionierende Modell-Formate:** `account:zai-individual-coding-plan/GLM-5.3-Flash` (Session-Konto — funktioniert SOFORT, bewiesen mit cavecrew-builder, 73k Tokens sauber) und `omniroute/glm-first` (OmniRoute localhost:20128, LaunchAgent aktiv). Vermeide erfundene Provider-Namen wie `zai-api`.
2. **Session-Cache-Falle:** Agent-Defs werden beim Session-Start geladen — Datei-Fixes am laufenden Prozess wirken erst nach NEUSTART. Sofort-Nutzung: Agent-Typen mit `account:`-Format dispatchen.
3. **Fix-Ablauf** (2026-10-26 ausgeführt): Backups `*.md.bak-20261026`, dann `sed -i '' 's|zai-api/GLM-5.3-Flash|omniroute/glm-first|g'` über alle Defs; OmniRoute-Health vorher mit `curl -sf http://localhost:20128/` prüfen. 8 Defs gefixt; cavecrew-builder + gate-enforcer-test hatten bereits das account:-Format.
4. **Reviewer-Veto ohne Reviewer-Def:** cavecrew-builder mit Review-Briefing („du agierst JETZT als Reviewer mit Vetorecht, hast nichts gebaut") funktioniert als Ersatz — lieferte REQUEST_CHANGES mit 7 echten Findings (Recorder-Race, StemFile-Main-Thread-Block, .build-Artefakte im Git, Dead Code, seek-0-Frame-Guard, Reverb-Preset-Reload). Alle gefixt, 54/54 Tests, Push a30349657.
5. hcom-Bus: `hcom start` macht ZCode als Agent sichtbar (Name „neko"); Antigravity.app in /Applications vorhanden; aber Cline/Antigravity/AutoClaw-Peers standen 16 Tage stale — externes Team nicht verlässlich, Solo-Bau + Ersatz-Reviewer dokumentieren. Kontext: [[qwen-flash-spark-project]], [[custom-skills-read-from-autoclaw]].
