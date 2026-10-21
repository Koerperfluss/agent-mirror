---
app: claude
quelle: "saschalagler/skills/agent-cluster/SKILL.md"
stand: 2026-10-21
tags: [spiegel, claude]
---

---
name: "agent-cluster"
description: "11 KI-Agenten (A1–A11) bewerten alles Mögliche — Tools, Projekte, Ideen, Geschäftsmodelle: Markt, Wettbewerb, Kunden, Trends, Pricing, Lizenz, Finanzen, Positionierung, GTM, Risiko → finale Verkaufsbewertung. Global installiert, jedes Projekt nutzbar."
---

# Agent-Cluster — 11 Agenten systemweit

Die 11 Agenten leben in `~/.agents/tools/agent-cluster/` (agents.py + runner.py).
LLM-Gehirne via OmniRoute :20128 (glm-first → Free-Fallback-Kette).

## Nutzung (von jedem Ordner)

```bash
# 1. tool-bewertung.json im Projekt anlegen (oder bestehende nutzen)
#    Format: [{ "id": "x", "name": "X", "kat": "...", "stack": [], "funktion": "...", "bewertung": {"verkaufen":"","prio":0,"preis":"","notiz":""} }]

# 2. Bewerten (11 Agenten, Phase 1→2→3)
python3 ~/.agents/tools/agent-cluster/runner.py bewerte x

# 3. Status
python3 ~/.agents/tools/agent-cluster/runner.py status
```

## Die 11 Rollen (für eigene Prompts wiederverwendbar)

| ID | Rolle | Frage |
|---|---|---|
| A1 | Market Research | Wie groß ist der Markt? |
| A2 | Competitor Analysis | Wer macht das schon, für wie viel? |
| A3 | Customer Insight | Wer zahlt und warum? |
| A4 | Trends & Timing | Ist JETZT der richtige Zeitpunkt? |
| A5 | Pricing Benchmark | Was kostet es, in welchen Modellen? |
| A6 | Regulatory & Lizenz | Was blockiert den Verkauf rechtlich? |
| A7 | Financial Modeling | Was bringt es in 12 Monaten? |
| A8 | Value Proposition | Warum das und nicht der Wettbewerber? |
| A9 | GTM Roadmap | Wo verkaufen, wie starten? |
| A10 | Risk & Gaps | Was FEHLT bis verkaufbar? |
| A11 | Strategy Writer | Finale Empfehlung aus allen Ergebnissen |

## Paralleles Prüfer-Team (große Mengen)

```bash
for i in 0 1 2 3; do python3 ~/.agents/tools/agent-cluster/runner.py alle --shard $i/4 & done
# Race-sicher via Datei-Lock + Merge (eingebaut)
```

## LOKI-Regeln

- Ergebnisse in Obsidian: Brain/Tool-Verkauf/<id>.md (Frontmatter: id, tier, preis, kanal, verkaufen)
- Secrets: OMNIROUTE_API_KEY env oder ~/.config/omniroute/api_key (chmod 600)
- Agenten bewerten — MENSCH entscheidet über Verkauf/Publish (Stopp-Regel)
