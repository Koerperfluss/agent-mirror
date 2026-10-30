---
app: zcode
quelle: "saschalagler/cli/memories/projects/agent-os-d3ae7b502a46e7f0/memory/MEMORY.md"
stand: 2026-10-30
tags: [spiegel, zcode]
---

# Memory Index

- [Traktor DVS Timecode-Decoder](traktor-dvs-timecode-decoder.md) — Slice 12 (30.10., Commit 7264e782b): Traktor-Scratch/Serato-Konstanten, LFSR+LUT-Decoder synthetisch bewiesen (108/108); **DVS geht am Riemenantrieb (Nutzer-Korrektur!)**; GPL-Route: eigene Impl nach §40e UrhG; Live-Kalibrierung braucht Phono-Interface
- [TraktorClone Projekt](qwen-flash-spark-project.md) — **Slices 1–12 ALLE FERTIG (30.10., 108/108 Tests in 24 Suiten, HEAD 7264e782b, 29/37 Features)**: Restfeatures (Beatgrid-Offset, Sync-Phase-Nudge, Cue/Hotcue-Marker, Zoom-Fix, Playlists/Crates, Treiber-Panel, Spotify-Playlist-Import via Env-Keys — kein Audio-Streaming, Spotify-AGB) + DVS (Timecode-Vinyl, Phono-Input); **@State = SwiftUIMacros-Makro, fehlt im CLT komplett** → UI-Flags in EngineHost; agentos M1–M5 DONE (210/210); LokiCanvas v1.0 fertig (Parallel-Session 628ced708)
- [Mimosa-Hook-Schreibconstraints](mimosa-hook-write-constraints.md) — warum Edits/Pushes blockiert werden und welche Gegenmuster funktionieren (validate_host, write_text, lazy, pipefail, Button-Style-Paren-Falle)
- [Custom-Skills manuell ausführen](custom-skills-read-from-autoclaw.md) — roo-code/gsd-core/coderabbit/loki-dev/ponytail liegen in ~/.openclaw-autoclaw/skills/, ZCode registriert sie nicht → SKILL.md lesen + Methodik manuell anwenden
- [Subagent-Provider-Fix](subagent-provider-fix-zai-api.md) — finale Lösung: ALLE 10 Defs `account:zai-individual-coding-plan/GLM-5.3-Flash` + thoughtLevel low; **nach Neustart bewiesen: implementer läuft** (alle 37 aktiv); vor Neustart = Live-Route cavecrew-builder
- [UI/UX-Skills + HUB-Audit](uiux-skills-hub-audit.md) — ~/.claude/skills UI/UX-Set komplett+aktuell, Routing Zeilen 32–35; HUB-Audit Top-3: Kontrast/Focus teils schon von Parallel-Session gefixt, Karten-Keyboard+Dialog noch offen (Datei neu lesen vor Edits!); Klick-Test 5/5, :3300 nohup; chrome-devtools-Screenshots nur via artifacts-Pfad kopierbar
- [LOKI-Workflow-Harness](loki-workflow-harness.md) — Workflows dual (~/.openclaw-autoclaw + ~/.claude/skills), ZCode = manuell nach SKILL.md; **agent-os M1–M5 ALLE DONE 26.10. (210/210 Tests, VICTORY_AUDIT.md, kein Git)**; cavecrew-builder 3× als Team-Builder bewiesen
