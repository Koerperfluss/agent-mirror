# MemoryIngestApp — RAM-SCHUTZ KONFIGURIERT (2026-08-20 06:35)

## Problem
LM Studio lud glm-4.6v-flash auf 16GB-M4 mit max. Kontext + 1h-TTL → Dauerhaft ~7-10GB RAM belegt → Memory Pressure → System-Instabilität.

## Lösung (aktiv, persistent in ~/.lmstudio/settings.json — Backup vorhanden!)
- `defaultContextLength`: {"type":"custom","value":4096} (war "max"!)
- `developer.jitModelTTL`: {"enabled":true,"ttlSeconds":300} (war 3600!)
- Effekt: Modell JIT-loaded NUR bei echtem Ingest, entlädt automatisch nach 5 min Idle → RAM nur bei Nutzung
- KEIN Preload mehr: autoboot.sh lädt das Modell NICHT mehr vor, prüft nur Status
- Swift Autoboot.swift lädt ebenfalls nicht vor (startet nur LM Studio Server + Obsidian)
- Settings-Backups: ~/.lmstudio/settings.json.bak-*

## Wichtige Erkenntnisse
- `lms load --context-length=4096 --ttl=300 zai-org/glm-4.6v-flash --yes` funktioniert via CLI (~/.lmstudio/bin/lms)
- MLX-Engine zeigt loaded_context_length 13568 — interner Minimum-Fit für glm4v-Architektur, ignorierbar: KV-Cache wächst bei MLX dynamisch mit echter Nutzung
- GLM ist Reasoning-Modell: bei winzigen max_tokens kommt leerer content (alles im Reasoning) — Test brauchen ≥200 Tokens
- LM Studio Settings-Änderungen greifen erst nach App-Restart (quit via osascript, pkill als Fallback)
- App (Autoboot.swift) ruft autoboot.sh NICHT auf — Swift macht eigenen Boot; RAM-Schutz liegt in settings.json, wirkt global

## Status
- LLM-Check nach Restart: ✅ antwortet (content mit box-Tokens, ingest.py stript sie)
- autoboot.sh: ✅ SYNTAX-OK, meldet "RAM-Schutz aktiv: JIT-Load mit 300s TTL"
- Monitor läuft: auto-unload nach 5 min wird verifiziert (job dab4399e)
