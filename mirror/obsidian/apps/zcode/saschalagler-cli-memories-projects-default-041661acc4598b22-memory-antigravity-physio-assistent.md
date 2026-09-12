---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/antigravity-physio-assistent.md"
stand: 2026-09-12
tags: [spiegel, zcode]
---

---
name: antigravity-physio-assistent
description: Antigravity-IDE „3d Körperfluss" Physio-GPT — 12.09. gelöst: korrupter
  Chat (HTTP 400) nur via NEUEM Chat fixbar; Start-Prompt auf Desktop; Adelina-Datenpfad;
  MCP-Badge nicht-fatal; osascript-Paste-Lesson
metadata:
  node_type: memory
  type: project
  originSessionId: sess_f82a1756-a7b8-4b62-a4f2-2773f3c818b2
---

Sascha nutzt die **Google Antigravity IDE** (Config unter `~/Library/Application Support/Antigravity/`) für den Workflow „3d Körperfluss / Physio Assistant" — ein Gemini-Gem „Physio - Assistent" zur Reha-Planung (Patientin **Adelina Sollböck** + **Simon**: Nacken/HWS > Hüfte/ISG > Fuß/Plantarfaszie; 5-stufiger Evaluierungsplan, 4-Spalten-Übungstabellen, A4-Handouts, M4-BLUF-Stil).

**12.09. GELÖST — wahrer Root Cause:** Alter Chat „Physio Assistant Workflow Configuration" hatte eine **korrupte Trajectory** (16 Messages mit PDFs/Bildern) → JEDER Turn crasht nach 1 s mit **HTTP 400 INVALID_ARGUMENT** (Google cloudaicompanion-Backend, Debug via „Copy debug info"-Button). Retry + App-Restart halfen NICHT. **Fix = NEUER Chat** — funktioniert sofort einwandfrei. Der nächtliche DNS-Ausfall (03:41, `oauth2.googleapis.com` unauflösbar, vgl. [[zcode-hub-1006-netz-fix]]) erklärt nur den separaten, **nicht-fatalen** gelben „MCP Error cloud-cli-execution"-Badge (steht in `~/.gemini/config/mcp_config.json` längst auf `disabled: true`, Badge bleibt trotzdem sichtbar — ignorieren).

**Start-Prompt-Artefakt:** `~/Desktop/ANTIGRAVITY_PHYSIO_START_PROMPT.md` (komplette M4-Systemanweisung + Adelina-Fall + 5 Auftragsschritte). **Patientendaten:** `/Users/saschalagler/Desktop/Körperfluss/Patientenliste/Adelina/` (5 Adelina-PDFs + Anamnese-MDs + `Simon - Adelina Freund.pdf`). Neuer Chat „Physiotherapy Rehab Assistant Setup" lieferte 12.09. Schritt 1–3 komplett (Befundhierarchie, Simon-Profil, Sitzungs-Zettel: FRT 32°, Knee-to-Wall 10–12 cm, NRS <3 = Progression) und wartet im adaptiven Loop.

**UI-Lesson Antigravity (Electron):** AX `set_value` auf Message-Textarea = mismatched, computer-use `type strategy=event` = „not frontmost" trotz activate. **Funktioniert:** `pbcopy` + `osascript` → `tell app "Antigravity" to activate` → `keystroke "v" using {command down}` → `keystroke return`.

Verwandt: [[active-projects-focus]] (Körperfluss), [[google-cloud-genai-credit]] (gleicher Google-Account).
