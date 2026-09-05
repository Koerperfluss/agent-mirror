---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/Audit 2 + Sprachassistent/_ARCHIV/JUDICARIO_RESEARCH.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# RESEARCH — Judicario MCP Tools (Deep Dive)

## 1. Module (aus .mcp.json)
6 Module, alle über `gateway.openlaw.cc/mcp/{modul}/`:

| Modul | URL |
|-------|-----|
| judicario-at | gateway.openlaw.cc/mcp/at/ |
| judicario-de | gateway.openlaw.cc/mcp/de/ |
| judicario-ch | gateway.openlaw.cc/mcp/ch/ |
| judicario-eu | gateway.openlaw.cc/mcp/eu/ |
| judicario-ip | gateway.openlaw.cc/mcp/ip/ |
| judicario-steuer | gateway.openlaw.cc/mcp/steuer/ |

Alle nutzen denselben API-Key (`jud_gtSG0t_...`).

## 2. Commands (Slash-Befehle)
| Befehl | Zweck |
|--------|-------|
| /norm | Gesetzestext nachschlagen + Judikatur |
| /recherche | Urteile/Leitsätze recherchieren |
| /gutachten | Neutrale Prüfung im Gutachtenstil |
| /schriftsatz | Schriftsatz-Entwurf (anwaltlich) |
| /steuer | Steuerrecht AT/DE |
| /rechtsvergleich | AT/DE/CH/EU Vergleich |
| /fall-triage | Rechtsgebiet/Fristen/Dringlichkeit |
| /deckungscheck | Versicherungsdeckung prüfen |

## 3. Response-Format (aus tool-results/)
```json
{
  "kind": "norm",
  "modus": "themensuche",
  "hinweis": "amtlicher Gesetzestext (gemeinfrei) — darf WÖRTLICH/verbatim ausgegeben werden",
  "treffer": {
    "at_norms": {
      "count": 6,
      "results": [{
        "_id": 110150,
        "law_key": "estr",
        "canonical_key": "at|estr|seg1",
        "text_content": "Verbatim Gesetzestext..."
      }]
    }
  }
}
```

**Key Finding:** Judicario liefert **verbatim Gesetzestext** — genau das was die Fehlerhinweis-Engine braucht.

## 4. Tools für die 5 Fehlerklassen

| Fehlerklasse | Judicario-Tool | Wie |
|--------------|----------------|-----|
| 1. Normen-Fehler | at_norm (via /norm) | Gesetzestext holen, § vergleichen |
| 2. Betrags-Fehler | at_norm | Betrag im Gesetzestext suchen |
| 3. Fristen-Fehler | at_norm | Frist im Gesetzestext suchen |
| 4. Logik-Fehler | /gutachten + /recherche | Widerspruch prüfen mit Judikatur |
| 5. Verfahrens-Fehler | at_norm + /fall-triage | Instanzenzug prüfen |

## 5. Technische Realität
- Judicario ist **HTTP JSON-RPC über MCP** — kein Claude nötig für Tool-Calls
- Man kann `gateway.openlaw.cc/mcp/at/` direkt per HTTP-POST anfragen
- Response enthält verbatim Gesetzestext (`text_content`)
- Latenz: Verbindungsaufbau ~1,2s, Tool-Call ~0,3-0,8s
- SSE-Stream droppt nach 165s → muss reconnecten
