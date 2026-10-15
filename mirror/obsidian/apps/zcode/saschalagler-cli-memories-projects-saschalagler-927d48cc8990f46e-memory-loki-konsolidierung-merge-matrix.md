---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-konsolidierung-merge-matrix.md"
stand: 2026-10-15
tags: [spiegel, zcode]
---

---
name: loki-konsolidierung-merge-matrix
description: LOKI-Konsolidierung 16.10. — 3 Read-only-Scouts inventarisiert ALLE
  Loki-Versionen; Merge-Matrix in ~/loki-ki/docs/LOKI_KONSOLIDIERUNG_MERGE_MATRIX_2026-10-16.md;
  D1–D6 Duplikate + I1–I3 Integrations + Don't-touch warten auf GO-Gate
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ec044ff8-4d82-412d-b9db-4db95e4da190
---

**LOKI-Konsolidierung — Stand 16.10.2026 Nacht (Ursprung: Saschas Cline-Auftrag „alle loki.os-Versionen suchen, mergen, einpflegen", dort 6× an Hub-1006 gescheitert; in ZCode per 3 general-purpose-Scouts read-only erledigt)**

**SSOT der Inventur:** `~/loki-ki/docs/LOKI_KONSOLIDIERUNG_MERGE_MATRIX_2026-10-16.md` — Endentscheidung = Sascha („GO D1–D4" / „GO alles" / Option C), jeder mv GO-gegate mit tar-Backup.

**Kanonisch (nicht anfassen):** `~/loki-ki` 3,3 G master **368 dirty** (v17 = Live-Kernel :8010 via `LOKI_MASTER_BOOT.sh`, v18 = Nachfolger — VERSIONEN im selben Repo, KEINE Duplikate) · `~/loki-brain` (brain.db live) · `~/loki-voice` 473 M clean (LaunchAgent dev.sascha.voiceagent) · `~/loki-voice-app` (b73391e, LokiVoice.app) · `~/loki-verkaufstool` · `~/e2e/loki-e2e` (heute aktiv, nie in $HOME).

**Duplikat-Kandidaten:** D1 `~/lv-wt-zcode` = git-Worktree von loki-voice-app (Zweig t04-audio-zcode, 4 dirty, gleicher HEAD b73391e) · D2 `~/loki-ki/loki-voice` = verschachteltes Alt-Repo (21.09, ALT ggü. Home-23.09) · D3/D4 `loki-ki/ios` + `LOKI_Mind` + `~/loki_gemma_paper_studio` = Fossilien · D5 Desktop-`ARCHIV/loki-ki` 5,1 M = ältere Repo-Kopie (Diff-first) · D6 11 Loki-Zips in `~/.cline/data/sessions/*/user-attachments` (~10 MB, Attachments der laufenden Konversation — erst später aufräumen).

**Don't-touch (harte Sperren):** `THOMAS - CHIPS JUDICARIO/` = Kunden-Paket (heute geändert, Übergabe-Dokus verlinken Pfade) · `TOOL-SAMMLUNG-VERKAUF/` = aktiver Verkauf (heute 23:18 APK; 6 eBay-Anzeigen live) · leere 0B-Platzhalter (Toolsverkauf/loki-ki etc.) werden von `pipeline/autopilot.py` erwartet — Löschen bricht sie · `_LOKI_KONSOLIDIERUNG/06_unklar_gesichert/tilde_ordner_backup/`. ⚠️ **Pfad-Falle:** mehrere Coworkspace-Ordner haben **Leerzeichen am Ende** (`PRIVATE PORJEKTE `, `TO DOS `, `Local AI `).

**Sonst:** Cloud KEIN Loki-Bulk (nur 3 .gdoc-Referenz-Docs) · Mirror `~/Mirror/agent-mirror` → GitHub Koerperfluss/agent-mirror + GCS (state ok, Push 15.10. 21:27), Risiko `MIRROR_SOURCES=$HOME` (Overscoping = Ursachen-Kreis des runaway-find/Plugin-Timeouts) → Scope-Ticket offen · Zips-Lage: `~/Library/Application Support/Cline` existiert NICHT, Cline-Daten nur in `~/.cline`.

**Harness-Lektionen:** ZCode-Subagent-Typ `explore` pinnt Modell `account:zai-start-plan/GLM-5.3-Flash` = Provider nicht gefunden auf dem individual-coding-plan-Account → Umweg über `general-purpose` (läuft auf Session-Modell).

Link: [[clinepass-zcode-config]] · [[loki-os-v18-endprodukt]] · [[verkaufshub-tool-sammlung]] · [[loki-second-brain]]
