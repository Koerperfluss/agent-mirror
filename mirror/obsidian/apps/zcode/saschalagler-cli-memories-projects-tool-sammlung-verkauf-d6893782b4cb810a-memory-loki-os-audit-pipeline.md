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

**Sync erledigt (18.10., SYNC-BERICHT-2026-10-18.md im Repo):** 411 Skills additiv gespiegelt (rsync --ignore-existing), alle 3 Harnesses jetzt identisch — `~/.zcode/skills` 213→243, `~/.agents/skills` 175→243, `~/.claude/skills` 212→243. Offen: ① `appagentteam/SKILL.md` hat 2 unterschiedliche Versionen (zcode vs. agents — Universe nennt agents-Version „NEU", Nutzer muss wählen), ② `hcom update` auf 0.7.30 verfügbar (nur mit GO), ③ hcom-Hooks: Codex/Oh-My-Pi/Kimi ✗ konfiguriert.

**Feedback:** Nutzer wurde wütend, als ich nach dem Sync-Auftrag erneut die Vermarktungs-GO-Punkte wiederholte — korrekte Lesart: „alle 24 subagents alle programme SYNCHRONISIEREN" = Skill-/Config-/Agenten-Sync über Harnesses, NICHT Pipeline-Ausführung. Zweite Korrektur (18.10., hart): Ziel ist NICHT der Sync, sondern **Planung/Orchestrierung mit Inventar-Zyklus** — Tool-Finding → Files auslesen → tools-v2.json aktualisieren + komprimieren → technische Auswertung. Antwortformat bei Unmut: Aufgabe in 1 Zeile Klartext, dann ohne Reden ausführen.

**Inventar-Zyklus 18.10. erledigt (TECHNISCHE-AUSWERTUNG-2026-10-18.md im Repo):** Beide Scanner gelaufen — `pipeline/finder.py` (mdfind, 0 echte neue) + `pipeline/inventar_voll.py` (5 Zonen, 50 Tool-Ordner, 33 „NEU"). Komprimierung 33→7: 26 verworfen (9× Körperfluss-Clones = gesperrte Firmen-IP, 6× `.app/Contents`-False-Positives, 11× Unterordner bekannter Tools). **tools-v2.json = 74 Tools** (Backup `tools-v2.backup-inventar-2026-10-18.json`), 7 Neuzugänge als `dev_status=kandidat, tier=C`: macos-app-v17, free-claude-code, antigravity-sdk-python, lokitrigger-ios, loki-mind-ios, loki-mind-dashboard, openclaw-atom (alle `~/loki-ki` + SDK). Konsolidiert: **50 real (14 echt + 36 echt-repo) · 17 ghost · 7 kandidat · Tier 6A/16B/52C**. Auswertungs-Reihenfolge: A zuerst auditieren (D2), B = Asset-Exit-Paket, C parken, Ghost skip. Offen: Zweck von `free-claude-code` klären.

**Builder-Lauf 18.10. abends erledigt (Nutzer pastete den 30-agent-prompts §1 Builder-Prompt → ausführen statt erklären):** `20-audit-scan.sh .` auf Repo-Root → `_AUDIT/{SBOM_AUDIT.json (kein package.json = Skip ok), SECRETS_AUDIT.json (104 Zeilen, 2 verified), BUILD_STATUS.log (PY-COMPILE OK)}`. **1 echter Klartext-Gemini-Key** in `Tools Sammlung und Analyse/ Jules Agent Fixes & Cloud Run Migration Plan.md` → redactiert (Backup .bak-20261018), Key nach **`.env.local`** (chmod 600, in .gitignore aufgenommen — war zunächst NICHT ignored, gefixt). `patch_dashboard2.py:18` SyntaxWarning → raw-string-Fix (Backup), Re-Compile **Exit 0, 0 Warnings** → Stopp-Bedingung nach 1 Iteration erfüllt (≤2 Dateien/Slice eingehalten). `SPEC.md` im Repo-Root = DONE-WHEN Marktreife (2 ✅, 5 ⛔ mit GO). AgentCluster-Marketing/.env = safe (untracked + gitignored). Offen: Git-Historie-Scrub (.git.bak-20261010 enthält weitere Funde — destruktiv, GO nötig), storefront/-Lizenz-Scan, 4 Körperfluss-Dateien entfernen, Gumroad/Deploy.

**Why:** Nutzer wollte vollautomatisierten Multi-Agent-Audit-&-Vermarktungs-Workflow mit verknüpften Apps (Cline/Eigent/Hermes/AutoClaw/Antigravity); bestehende Bewertungs-Pipeline (pipeline/runner.py, 67/67) bleibt — neue Pipeline komplementär.
**How to apply:** Bei Audit-/Vermarktungs-Tasks zuerst LOKI-OS-PIPELINE/00-ANLEITUNG.md + PLAN-ENTWICKLUNG.md + Vault-Notizen 08/09 nutzen; KEINE automatische Ausführung von 10-ip-lock.sh --go (destructiv); Dienste nicht selbst starten/stoppen (Kanban/Kernel nur melden). Verwandt: [[verkaufshub-inventar-und-workflow]]
