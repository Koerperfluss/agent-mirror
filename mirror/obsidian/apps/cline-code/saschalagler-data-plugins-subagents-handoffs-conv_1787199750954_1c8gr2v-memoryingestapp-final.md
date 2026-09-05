---
app: cline-code
quelle: "saschalagler/data/plugins/subagents/handoffs/conv_1787199750954_1c8gr2v/memoryingestapp/final.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# MemoryIngestApp — PROJEKT ABGESCHLOSSEN (2026-08-20 06:40)

## Endprodukt
- **App**: ~/Desktop/MemoryIngestApp.app (signiert, lauffähig, Autoboot für LM Studio + Obsidian)
- **Pipeline**: ~/scripts/ingest.py (Single Source, sync mit ~/MemoryIngestApp/ingest.py)
- **Python**: ~/scripts/.venv/bin/python | **LLM**: LM Studio 127.0.0.1:1234, zai-org/glm-4.6v-flash
- **Ziel**: ~/Documents/Obsidian Vault/Knowledge/Research/ (.md + .md.json)

## Alle Tests GRÜN
- Text ✅ | PDF ✅ | URL ✅ (echte LLM-Summaries, Vault-Dateien verifiziert)
- RAM-Schutz ✅: settings.json defaultContextLength=4096, jitTTL=300s → Auto-Unload nach 5 min bewiesen (24%→37% frei)

## Wichtige Fixes
1. PDF: page_count vor doc.close()
2. localhost→127.0.0.1 (IPv6-Hang)
3. max_tokens 1600, temp 0.3, timeout 240s
4. GLM-Box-Tokens <|begin_of_box|> strippen
5. status/category "GENAU EINEN wählen"
6. Nur glm-4.6v-flash passt in 16GB-RAM (gemma-12b/bonsai-27b RAM-blocked)

## Offen / Nächste Session
- AgentMemory (localhost:3111) ist NICHT installiert — nur Skill-Doku vorhanden. Falls gewünscht: Repo klonen + npm start
- LLM-Call dauert ~2-3 min (Hardware-Limit)
- Backups: ~/.lmstudio/settings.json.bak-*
