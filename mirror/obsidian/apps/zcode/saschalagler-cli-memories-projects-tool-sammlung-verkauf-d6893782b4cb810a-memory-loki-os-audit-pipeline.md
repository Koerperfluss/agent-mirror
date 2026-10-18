---
app: zcode
quelle: "saschalagler/cli/memories/projects/tool-sammlung-verkauf-d6893782b4cb810a/memory/loki-os-audit-pipeline.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: loki-os-audit-pipeline
description: LOKI.OS Audit- & Vermarktungs-Pipeline gebaut (18.10.2026) —
  Wissensbank im Obsidian-Vault, Pipeline-Skripte im Repo, App-Verbund live
  geprüft, IP-Konflikt aktiv
metadata:
  node_type: memory
  type: project
  originSessionId: sess_d16e9574-8219-4c77-abee-ea5b9a120e96
---

18.10.2026 gebaut: (1) **Wissensbank** `~/Documents/Obsidian Vault/LOKI-OS/` — INDEX.md, loki-os.base + 9 Notizen (01 Architektur, 02 Audit, 03 Veredelung, 04 IP/Recht, 05 Vertrieb/Steuer AT, 06 GTM, 07 Repo-Inventar, 08 Systemlandkarte, 09 EU-Compliance-Update). (2) **Pipeline** `LOKI-OS-PIPELINE/` im Repo — 00-ANLEITUNG (2 GO-Gates), 10-ip-lock.sh (DRY-RUN default, --go verschiebt; Existenz-Check gegen verschachtelte Ordner), 20-audit-scan.sh (SBOM/Secrets/Build → _AUDIT/), 30-agent-prompts.md (Builder ZCode/Director Cline/Hardware Antigravity), 40-veredelung-loop.md (max 5 Iterationen), 50-release-checklist.md, 60-app-verbund.sh (Health-Check, nur lesend), PLAN-MASTER.md, PLAN-ENTWICKLUNG.md (Phasen D0–D6, Gates 1–4).

**Korrektur (wichtig):** Kleinunternehmergrenze AT seit 1.1.2025 = **55.000 €** (Toleranz 60.500 €), nicht 42.000 €. EU CRA aktiv seit 11.9.2026 (24h-Meldepflicht, CE+SBOM ab 12/2027), GPSR, Hardware-Verkauf = zusätzlich Handelsgewerbe → Notiz 09.

**App-Verbund Live-Befund 18.10. (60-app-verbund.sh):** UP = hcom 0.7.25, BrowserOS :9000/:9200, Hermes-Config (schlafend by design), AutoClaw-CLI (~/.local/bin/openclaw), Antigravity (agy), Ollama :11434, Docker · **DOWN:** Kanban :3484, LOKI-Kernel :8010 (Watchdog greift nicht), OmniRoute :20128 → 401 · Eigent :9222 down = by design.

**Blocker D0:** Cline-Credits negativ (−0,09 $) → Subagenten über Cline-Pfad sterben; ZCode-interne Subagents laufen auf z.ai-Session-Modell und sind NICHT betroffen. GO-Punkte: Cline-Credits + Cline-App-Start, IP-Lock --go (9 Firmen-IP-Orte inkl. `Körperfluss EDU/` + `VERKAUFSPAKETE/koerperfluss-3d-v2-upgrade`), Gumroad-Links, Kernel-Watchdog-Prüfung.

**Why:** Nutzer wollte vollautomatisierten Multi-Agent-Audit-&-Vermarktungs-Workflow mit verknüpften Apps (Cline/Eigent/Hermes/AutoClaw/Antigravity); bestehende Bewertungs-Pipeline (pipeline/runner.py, 67/67) bleibt — neue Pipeline komplementär.
**How to apply:** Bei Audit-/Vermarktungs-Tasks zuerst LOKI-OS-PIPELINE/00-ANLEITUNG.md + PLAN-ENTWICKLUNG.md + Vault-Notizen 08/09 nutzen; KEINE automatische Ausführung von 10-ip-lock.sh --go (destructiv); Dienste nicht selbst starten/stoppen (Kanban/Kernel nur melden). Verwandt: [[verkaufshub-inventar-und-workflow]]
