---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/zcode-offpeak-ticket-ausfall.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: zcode-offpeak-ticket-ausfall
description: ZCode-Fehlerfall „off-peak-ticket-expired" → Shell stirbt (spawn
  /bin/zsh ENOENT) und Repo-Pfade verschwinden für frische Reads;
  In-Context-Inhalt bleibt gültig
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ee4009c9-e362-4f0f-926c-ecf044833cd1
---

Beobachtet 06.09.2026 (Session mit Off-Peak-Ticket): Nach User-Paste „ZCode Error Info: off-peak-ticket-expired (TraceID: hydrate-trace)" galt innerhalb derselben Session:
1. Bash komplett tot: `spawn /bin/zsh ENOENT` für JEDE Kommandos (auch `echo test`), auch in frischen Subagenten, auch nach 20s Wartezeit — nicht transient.
2. Dateisystem-Verlust nur für frische Zugriffe: zuvor problemlos lesbare Pfade (z. B. `~/ATLAS_MASTER/app`) liefern „File does not exist"; das Working Directory zeigt weiterhin auf den toten Pfad. Home-Verzeichnis (~/.zshrc, ~/Desktop) bleibt lesbar.
3. Bereits in-context gelesene Dateiinhalte und Bash-Outputs (git log etc.) bleiben gültige Beweise — sie waren echt.

**Why:** Ohne dieses Rezept wirkt es wie „Projekt gelöscht/Agent lügt"; tatsächlich ist es ein Sandbox-/Quota-Ausfall nach Ticket-Ablauf (Session-Hydration fehlgeschlagen).

**How to apply:** Bei ENOENT + „File does not exist" auf bekannten Pfaden: NICHT in Pfade schreiben (Ghost-File-Gefahr), NICHT node_repl als fs-Ersatz nutzen (Policy: Browser-Use-only), keine Editierungen auf ungeprüfte zweite-Hand-Claims stützen → Task sauber abbrechen, Scope+Beweise berichten, Fortsetzung nach Re-Login/Quota-Fix anbieten. Diagnose-Reihenfolge: 1× Bash-Retry nach wait(20–30s), 1 frischer Read auf noch nie gelesene Datei im Ziel-Pfad, ggf. Explore-Subagent als zweiter Beweger. Verwandt: [[anti-luegen-vertrag]], [[cline-lebt-diagnose]].
