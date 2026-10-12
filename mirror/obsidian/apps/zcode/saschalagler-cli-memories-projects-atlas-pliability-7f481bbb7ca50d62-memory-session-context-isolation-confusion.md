---
app: zcode
quelle: "saschalagler/cli/memories/projects/atlas-pliability-7f481bbb7ca50d62/memory/session-context-isolation-confusion.md"
stand: 2026-10-12
tags: [spiegel, zcode]
---

---
name: session-context-isolation-confusion
description: Nutzer war wütend, dass eine 5 Min. alte Atlas-Unterhaltung nicht
  in der History der neuen Session auftauchte — Sessions starten isoliert;
  AGENTS.md-Texte werden fälschlich als "übernommener Kontext" gelesen
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_fa18d0dc-72ff-4fb5-ab1c-bed49ca6f9e8
---

Am 12.10.2026 eröffnete der Nutzer (aufgebracht) eine neue Session im Projekt "atlas + pliability" und forderte, warum die Atlas-Unterhaltung von 5 Minuten vorher nicht in der History sei, und beschuldigte die Session, "Cline und AutoClaw-Status übernommen" zu haben.

**Why:** Jede ZCode-Session startet mit leerem Kontext (Design). Die Cline/AutoClaw-Inhalte kommen nicht aus vorherigen Unterhaltungen, sondern werden bei jeder Session aus den dauerhaft geladenen AGENTS.md-Dateien (`~/.zcode/AGENTS.md` + `~/AGENTS.md`) vorangestellt. Der Nutzer verwechselt session-übergreifende Konfig mit Konversationsverlauf.

**How to apply:** Wenn der Nutzer vermissten Kontext beklagt: sofort klarstellen, dass neue Sessions isoliert starten und AGENTS.md bei jeder Session lädt; ihn auf Sidebar/⌘K-Suche für alte Sessions verweisen; anbieten, den Stand aus der alten Session (deja/zcode CLI, LOKI_SESSION_CONTEXT.md) hierherzuholen. Nicht defensiv auf Beschimpfungen reagieren — Sachklärung in 3 Punkten, ADHS-Format.

Bekanntes Problem aus derselben Session: die Bash-Shell scheiterte komplett mit `spawn /bin/zsh ENOENT` — CLI-Recherche (History-Auslesen) war dadurch blockiert; Nutzer muss ggf. App neu starten.
