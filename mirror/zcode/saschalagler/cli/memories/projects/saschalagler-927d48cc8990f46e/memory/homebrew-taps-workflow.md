---
name: homebrew-taps-workflow
description: 02.10. Homebrew-Tap-Trust-Entscheidung als Workflow dwfrun-05fa4a67
  gestartet — ojuschugh1/sqz + render-oss/render untrusted, nur
  Entscheidungsvorlage, keine trust/untap-Befehle
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ea4d6e7b-84b7-4777-8062-4dc0a3123686
---

02.10.2026: Homebrew-Doctor-Befunde via `/workflow` analysiert (Run **dwfrun-05fa4a67-facf-4b3c-9797-5162b67b106b**, Script `.zcode/workflow-drafts/Homebrew-Taps-prüfen.dwf.ts`): Befunde = 2 nicht vertraute Taps `ojuschugh1/sqz` + `render-oss/render`, node@20 deprecated, `/usr/local/include/node` unexpected headers, unlinked kegs (ffmpeg, certifi, …). Workflow: brew-Inventar → Web-Recherche je Tap → unabhängiger Prüfer → Markdown-Bericht „Homebrew-Taps: Entscheidungsvorlage" (Artifact).

**Nicht ausgeführt (bewusst, User-GO-Pflicht):** `brew trust`, `brew untap`, Link, Löschen von /usr/local/include/node. Bericht liefert nur Empfehlung. Ergebnis lag zum Zeitpunkt des Memory-Writes noch aus — bei Rückfragen Run-Status via GetWorkflowRun/ListWorkflowRuns prüfen. Siehe [[deja-vu-install]] (brew-Ökosystem).
