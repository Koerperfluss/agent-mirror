---
name: feedback-aufbau-vor-deploy
description: Sascha korrigierte Plan-Reihenfolge scharf („wtf ist los mit dir")
  — bei anstehendem Umbau/Redesign NIEMALS erst die alte Version
  deployen/perfektionieren; Aufbau zuerst, EIN Deploy der finalen Version am
  Ende
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_ecb2e5e0-e1f7-46fb-a5b9-a997d5485c8e
---

Im Atlas-Master-Prompt (08.09.) wollte ich zuerst Deploy + iPhone-Neuübertragung (P0–P2) und danach Redesign/Übungs-DB/Verkaufs-Agent. Sascha: **„was bringt die App ganz zu machen wenn der Aufbau danach kommt? wtf ist los mit dir"** — Reihenfolge umgedreht.

**Why:** Ein Deploy der Zwischenversion ist verschwendete Arbeit, wenn der Aufbau sie gleich ersetzt. „Fertig/live stellen" hat nur am Ende auf der finalen Version Wert.
**How to apply:** Bei mehrstufigen Plänen mit anstehendem Umbau: (1) vorab nur Daten sichern/committen (Rollback-Basis, kein Deploy), (2) Aufbau-Tickets zuerst (wayfinder-Map), (3) EIN Deploy + Geräte-Übertragung am Ende nach Abnahme-GO. Verwandt: [[feedback-one-action-not-tables]] [[loki-dev-gate-enforcement]] — Kontext [[atlas-stand-2026-09-08]].
