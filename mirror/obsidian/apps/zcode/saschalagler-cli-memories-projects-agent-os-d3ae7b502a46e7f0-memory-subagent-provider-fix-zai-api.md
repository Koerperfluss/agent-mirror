---
app: zcode
quelle: "saschalagler/cli/memories/projects/agent-os-d3ae7b502a46e7f0/memory/subagent-provider-fix-zai-api.md"
stand: 2026-10-26
tags: [spiegel, zcode]
---

---
name: subagent-provider-fix-zai-api
description: Subagenten schlugen mit "provider-not-found"/"reasoning-level" fehl —
  toter Provider zai-api + thoughtLevel max; finale Lösung = account:-Format
  überall (10 Defs), Live-Ausweichroute cavecrew-builder, hcom-Status
metadata:
  node_type: memory
  type: feedback
  originSessionId: session_58f3f4bfcb9a88671e0595593de28702
---

Saschas ZCode-Subagenten (~/.zcode/agents/*.md: cavecrew-*, implementer, qa-tester, reviewer, code-architect, config-auditor, explore) schlugen beim Dispatch mit `Cannot start subagent: Provider unavailable [provider-not-found; selection=zai-api/GLM-5.3-Flash]` fehl — obwohl die Subagents-UI sie alle anzeigt.

**Why:** Die Defs hatten `model: "zai-api/GLM-5.3-Flash"` — aber `zai-api` existiert NICHT in `~/.zcode/v2/provider_config.json` (providerOrder: `builtin:zai`, `omniroute`, `ollama`, `new-provider`). Der Name war schlicht falsch, nicht das System.

**How to apply:**
1. **FINALE Lösung (2026-10-26, mehrstufig getestet):** ALLE 10 Defs einheitlich auf `model: "account:zai-individual-coding-plan/GLM-5.3-Flash"` + `thoughtLevel: low` — das ist das EINZIGE live bewiesene Format. Irrwege dokumentiert: `omniroute/glm-first` wird zwar als Provider erkannt (Progress!), scheitert aber an `reasoning-level-not-supported` (thoughtLevel high/max/xhigh; auch low ungetestet scheiterte) — OmniRoute übernimmt keine Agent-Reasoning-Levels. Backups: `*.md.bak-20261026` (vor dem omniroute-Versuch).
2. **Session-Cache:** Agent-Defs werden beim Session-Start geladen und GECACHT — ein Dispatch nach Datei-Fix zeigte weiterhin die alte Selection. Datei-Fixes greifen erst nach NEUSTART; sofortige Nutzung nur über Agent-Typen, die beim Start schon korrekt waren.
3. **Live-Beweis:** cavecrew-builder (account:-Format) lieferte 2 echte Tasks (73k + 262k Tokens): STATE-Check + vollständigen StemExporter (AVAssetReader→WAV, Build complete, committed 42641ef05). Builder als Ersatz-Reviewer mit Vetorecht funktioniert („hast nichts gebaut") — lieferte REQUEST_CHANGES mit 7 echten Findings, alle gefixt.
4. **Fehler-Diagnose-Kette:** `provider-not-found` = Provider-Name falsch · `reasoning-level-not-supported` = Provider ok aber thoughtLevel nicht unterstützt. UI-Anzeige „GLM-5.3-Flash" im Subagents-Panel ist nur der Modell-Anzeigename — sagt nichts über den Provider.
5. hcom-Bus: `hcom start` macht ZCode als Agent sichtbar (Name „neko"); Antigravity.app in /Applications vorhanden ✅; aber Cline/Antigravity/AutoClaw-Peers standen 16 Tage stale — externes Team nicht verlässlich, dokumentieren statt blocken. Kontext: [[qwen-flash-spark-project]], [[custom-skills-read-from-autoclaw]].
