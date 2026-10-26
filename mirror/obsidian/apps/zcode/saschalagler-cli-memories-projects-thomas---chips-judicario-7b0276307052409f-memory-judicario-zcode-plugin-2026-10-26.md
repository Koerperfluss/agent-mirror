---
app: zcode
quelle: "saschalagler/cli/memories/projects/thomas---chips-judicario-7b0276307052409f/memory/judicario-zcode-plugin-2026-10-26.md"
stand: 2026-10-26
tags: [spiegel, zcode]
---

---
name: judicario-zcode-plugin-2026-10-26
description: ZCode-Plugin „judicario" v1.0.0 gebaut 26.10.2026 —
  Judicario-Client + 3 Legal-Agenten (Scout/Analyst/Reviewer mit Veto) im
  Workspace; Client live getestet (MRG § 30, Exit 0); Installation per Plugin-UI
  noch offen
metadata:
  node_type: memory
  type: project
  originSessionId: session_a9d83d5f6d436ee601e9cc6431e574fc
---

ZCode-Plugin `judicario` v1.0.0, gebaut 26.10.2026 im Workspace:

- Quelle: `/Users/saschalagler/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO/plugins/judicario/` — `.zcode-plugin/plugin.json`, `scripts/judicario_mcp_client.py` (Streamable-HTTP-Client 1:1 aus `THOMAS - CHIPS JUDICARIO /Legal_Ops_Zentrale/legal-ops-advisor/`), `skills/judicario/SKILL.md`, `agents/legal-scout.md` / `legal-analyst.md` / `legal-reviewer.md` (Reviewer hat Veto-Recht: jede Fundstelle gegen Gateway verifizieren, sonst streichen).
- Lokaler Dev-Marketplace: `plugins/marketplace.json` (Name `saschalagler-local-dev`, Eintrag source `./judicario`).
- **Live-Test bestanden 26.10.2026:** `at_norms` „Kündigung Mietvertrag Frist" → MRG § 30 Volltext, Exit 0. Gateway-Key (rotiert 06.09.2026) als Fallback im Client; künftige Rotation nur via `export JUDICARIO_API_KEY=…`.
- **Offen:** Plugin per ZCode-UI installieren (Marketplace-Ordner adden → Install → Neustart) — danach Erkennung verifizieren. Altes Tool `legal_research` (judicario_connector.py) ist am Gateway tot, kann archiviert werden.

**Why:** „eigentlich sollt es das schon geben" war falsch — es gab nur den Prompt-Skill `~/.claude/skills/legal-ops-omni` und loki-legal-ops-mcp, kein ZCode-Plugin mit Connector + Agent-Team.
**How to apply:** Nach Installation Trial-Prompt „@judicario: … Scout → Analyst → Reviewer"; bei „Unbekanntes Tool" am Gateway `<module>_search` nutzen (nicht legal_research). Verwandt: [[chipsi-judicario-stand-2026-09-22]], [[umgebungs-blocker-zcode]]
