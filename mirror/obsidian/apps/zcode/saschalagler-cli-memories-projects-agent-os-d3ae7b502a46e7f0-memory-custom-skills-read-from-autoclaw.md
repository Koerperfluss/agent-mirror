---
app: zcode
quelle: "saschalagler/cli/memories/projects/agent-os-d3ae7b502a46e7f0/memory/custom-skills-read-from-autoclaw.md"
stand: 2026-10-26
tags: [spiegel, zcode]
---

---
name: custom-skills-read-from-autoclaw
description: Saschas Custom-Skills (roo-code/gsd-core/coderabbit/loki-dev/ponytail) sind
  keine ZCode-Skills — aber SKILL.md direkt lesen und Methodik manuell ausführen akzeptiert er
metadata:
  node_type: memory
  type: feedback
  originSessionId: session_58f3f4bfcb9a88671e0595593de28702
---

Sascha erwartet, dass seine Custom-Skills (/roocode, /coderabbit, /gsd-core, /lokidev, /appagentteam) nutzbar sind — er reagiert gereizt („wo sind meine skills?"), wenn man sie nur als „nicht verfügbar" abtut.

**Why:** Die Skills existieren real als Dateien unter `~/.openclaw-autoclaw/skills/<name>/SKILL.md`, werden aber von ZCode nicht als aufrufbare Skills registriert (nur AutoClaw/Cline-Discovery). ZCode listet nur Plugin-Skills (superpowers, mattpocock-skills, video2code etc.).

**How to apply:** (1) SKILL.md-Dateien direkt lesen (`head -50 ~/.openclaw-autoclaw/skills/<name>/SKILL.md`) und die Methodik **manuell** ausführen — bewährt an TraktorClone Slice 1: loki-dev BUILD-Gate (Sequential Thinking → TodoWrite → PLAN-Tabelle → PLAN.md), gsd-core (Spec vor Code, vertikale Slices), roo-code-Modi, ralph-loop (Build-Loop max 5 Iterationen), coderabbit (4 Dimensionen Security/Logic/Perf/Arch + Findings-Tabelle + APPROVE-Verdict als Eigenreview dokumentieren), ponytail (YAGNI, keine Dependencies, native APIs zuerst). (2) Kurz und faktenbasiert kommunizieren: „Dateien existieren in ~/.openclaw-autoclaw/skills/, ZCode registriert sie nicht → Methodik manuell angewendet" — das hat ihn beruhigt. (3) Kern-Kurzformeln der Skills: loki-dev 4 Stopp-Regeln (Deploy/Löschen/Push/>5000 Credits nachfragen), gsd-core DONE-WHEN pro Slice, coderabbit-Verdict APPROVE/REQUEST_CHANGES. Kontext: [[qwen-flash-spark-project]].
