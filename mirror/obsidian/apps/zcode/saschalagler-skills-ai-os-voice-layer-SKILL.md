---
app: zcode
quelle: "saschalagler/skills/ai-os-voice-layer/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: ai-os-voice-layer
description: Bauplan für ein persönliches KI-Betriebssystem mit Sprachschicht — Claude Code als Engine, Obsidian-Vault als Memory, lokale STT/TTS als Ohren+Mund, HUD als Face. Nutzen bei „bau mir meine Stimmen-Zentrale", „AI-OS", LokiVoice-Verwandtes. (Paket-Datei „Build a Cinematic Website" war falsch benannt — Inhalt ist dieser Guide.)
---

# AI-OS Voice Layer (4-Teile-System, in dieser Reihenfolge bauen)

Quelle: „Build a Cinematic Website with Claude Code — The Guide" (Codex-Paket; Titel irreführend, Inhalt = One-Voice-Layer-Guide).

## Das Prinzip

Alt: jedes Tool von Hand fahren (Tabs, Tippen, Kontextverlust). Neu: **eine Sprachschicht über allem** — du sprichst, der passende Skill läuft, die Antwort kommt laut zurück.

## Die 4 Teile

| # | Teil | Rolle | Kern |
|---|---|---|---|
| 1 | **Claude Code** | Die Engine | Routed jede Anfrage zum richtigen Skill und arbeitet ab. Nichts anderes muss schlau sein. |
| 2 | **Obsidian** | Das Gedächtnis | Alles landet als verlinktes Markdown in einem Vault (raw/ wiki/ outputs/). Keine DB, kein Lock-in. „Was nicht im Vault ist, ist nicht passiert." |
| 3 | **Lokale Stimme** | Ohren + Mund | Speech-to-Text rein, Text-to-Speech raus — beides LOKAL, Audio verlässt den Rechner nicht. (→ LokiVoice!) |
| 4 | **Ein HUD** | Das Gesicht | Ein Screen für Vitalwerte, Termine, Befehle — liest live aus dem Vault. |

## Skill-Layer-Regeln (Teil 1)

- Ein Ordner kleine Einzel-Skills, je ein SKILL.md (YAML frontmatter: name, description) — **5 kleine Skills schlagen einen Riesenprompt** (nur der passende lädt, Kontext bleibt sauber).
- Start-Set: `metrics` (Zahlen berichten) · `inbox` (Morgen-Brief: 3 Dinge, die zählen) · `trends` (nur Bewegung seit gestern) · `plan` (Top-3 in datierte Markdown-Datei) · `vault` (lesen/schreiben ins Vault — alle anderen Skills nutzen vault zum Persistieren).
- Jede description muss den **Trigger klar nennen**, damit der richtige Skill ohne Namensnennung feuert.
- Erst fragen: Was mache ich täglich wirklich? Dann die 5 darauf zuschneiden.
- Nichts schreibt außerhalb des Vaults ohne Meldung.

## Vault-Struktur (Teil 2)

- `vault/raw/` — alles erfasste, unbearbeitet (Transkripte, Clips, Dumps)
- `vault/wiki/` — destilliertes Wissen, eine Seite pro Thema, laufend umgeschrieben
- `vault/outputs/` — alles, was das System ausliefert

## Bezug zum eigenen Setup

- LokiVoice (V10-Build, lokal: faster-whisper + OpenRouter Free + Seraphina) = Teil 3 „lokale Stimme" bereits gebaut — dieser Guide ist die Anleitung, es zur Schicht über ALLEN Tools auszubauen.
- Cole-Medin-Masterclass (YouTube zbmuiaPuiNM) lehrt denselben Ansatz: PIV-Loop (Plan→Implement→Validate), versionierte Rules/Commands/Skills, „alles 3× Promptierte wird Skill".
