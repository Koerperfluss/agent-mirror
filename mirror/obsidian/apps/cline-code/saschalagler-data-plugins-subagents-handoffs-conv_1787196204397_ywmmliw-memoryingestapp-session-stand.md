---
app: cline-code
quelle: "saschalagler/data/plugins/subagents/handoffs/conv_1787196204397_ywmmliw/memoryingestapp/session-stand.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# MemoryIngestApp — FINAL: Alles fertig & getestet (2026-08-20 06:05)

## E2E-Verifikation — ALLE 3 MODI GRÜN ✅
- ✅ TEXT: LLM-Summary + Vault-Files (Run 1)
- ✅ PDF: LLM-Summary + Vault-Files (Run 2 — nach page_count-fix)
- ✅ URL: LLM-Summary + Vault-Files mit echtem deutschen Titel "Beispiel-Domain" (Run 4)
- App: signiert auf Desktop, Binary aktuell, LM Studio OK

## Architektur (fixiert, vom User bestätigt)
- LLM: **LM Studio** `http://127.0.0.1:1234/v1/chat/completions` — IMMER 127.0.0.1 (localhost→::1→120s-Hang!)
- Modell: DEFAULT=**zai-org/glm-4.6v-flash**, FALLBACK=same (gemma-4-12b-qat UND bonsai-27b fallen durch LM-Studio-RAM-Guard ~45GB!)
- Python: `/Users/saschalagler/scripts/.venv/bin/python` (trafilatura, pymupdf, gitingest, requests, yt-dlp)
- Pipeline: `/Users/saschalagler/scripts/ingest.py` = Single Source (synced nach ~/MemoryIngestApp/ingest.py)
- Vault: `~/Documents/Obsidian Vault/Knowledge/Research/` (.md + .md.json)
- Apps: /Applications/LM Studio.app + /Applications/Obsidian.app (NICHT Desktop!)

## Alle Fixes heute
1. extract_pdf: page_count VOR doc.close() ("document closed"-Bug)
2. localhost→127.0.0.1 (IPv6-Hang, Root-Cause URL-Fail)
3. max_tokens 8192→1600, temp 0.7→0.3, timeout 240s (glm lief sonst in Timeout)
4. JSON-Parsing: stript `<|begin_of_box|>`/`<|end_of_box|>` (GLM-Spezialtokens)
5. Prompt: status/category "GENAU EINEN wählen" (glm kopierte sonst Optionsliste)
6. Swift-App: Config auf echte Pipeline (venv-Python, ~/scripts/ingest.py, 127.0.0.1:1234), Autoboot ohne Ollama (LM Studio+Obsidian aus /Applications), SelfTest erzeugt Test-PDF on-the-fly, autoboot.sh neu
7. Release-Build + Desktop-Deploy + adhoc-Signatur (validiert)

## Bekannte Limitationen (ok)
- LLM-Call dauert ~2-3min (glm auf dieser Hardware) — UI sollte async laufen (tut sie via DispatchQueue)
- YouTube ohne Untertitel → "No transcript available" (erwartetes Verhalten)
- Default/Fallback-Modell identisch — bewusst: nur glm passt in den RAM
