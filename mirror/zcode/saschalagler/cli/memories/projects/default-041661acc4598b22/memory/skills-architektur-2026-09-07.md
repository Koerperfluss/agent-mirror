---
name: skills-architektur-2026-09-07
description: Skill-Ausmist 07.09. — .zcode/skills ist BEWUSST leer (Skills laden
  nur via ~/.agents/skills), Archiv-Ort, skill-router existiert
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ecb2e5e0-e1f7-46fb-a5b9-a997d5485c8e
---

Skill-Audit 07.09.2026 (User-Weisung: nicht selbst werten; Vercel/Gemini/Claude/Matt-Pocock/Design BLEIBEN):

- `~/.zcode/skills` ist **bewusst leer** (125 Symlinks entfernt gegen Doppel-Einträge ~260→~126). ZCode lädt Skills NUR via `~/.agents/skills`. NICHT wieder befüllen — sonst Doppel.
- Archiv (reversibel): `~/.agents/skills-archive/2026-09-07/` — 5 Writing-Skills + lisa-therapeut-Echtkopie. Rückholbefehl im Audit-Doc.
- **skill-router** existiert neu (`~/.agents/skills/skill-router/`): wählt bei Build-/Code-Signalen automatisch 1–3 passende Teil-Skills (Matt-Pocock-, Design-, Vercel-, Gemini-, Claude-Suite). In skill-routing.md eingetragen.
- superpowers:*-Routing-Einträge entfernt (Skills existieren nicht mehr); Debug-Route = diagnosing-bugs.
- Nutzungs-Fakten (Memory-Check): caveman, cavecrew, agent-browser = belegt genutzt. Ohne Beleg, aber auf User-Entscheidung drin: market-intelligence-allrounder, persona-selector, jules-meta-agent, cli-serve, developing-ios-apps.
- Achtung: `npx skills add` (skillshare) legt bei Neu-Install wieder Symlinks in `.zcode/skills` an → danach `find ~/.zcode/skills -maxdepth 1 -type l -delete` + Manifest leeren, sonst Doppel zurück.

Audit-Doc: `~/loki-ki/docs/AUDIT_SKILLS_ZCODE_2026-09-07.md` · [[skill-install-conventions]] ist damit ÜBERHOLT (npx-Konvention erzeugt jetzt Doppel).
