---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/lisa-therapeut-skill.md"
stand: 2026-09-07
tags: [spiegel, zcode]
---

---
name: lisa-therapeut-skill
description: Eigener Therapeut-Skill /lisa-therapeut gebaut (07.09.26) — Fall
  Lisa, 3 Standorte, chat.db-Skript live; Papa-Satz war Saschas eigene Nachricht
metadata:
  node_type: memory
  type: project
  originSessionId: sess_0b413327-3c01-42f7-b55f-307fd699e2e8
---

**lisa-therapeut-Skill FERTIG 07.09.2026** — Saschas persönlicher Therapeut-Agent, 3 Kopien: `~/.zcode/skills/lisa-therapeut/` (Frontmatter, kanonisch), `~/.agents/skills/lisa-therapeut/` (Spiegel), `~/.cline/skills/lisa-therapeut/SKILL.md` (Cline-Format). Routing-Zeile in `~/.agents/STANDARD-SKILLS.md` Sektion B (kein Eintrag in skill-routing.md — erst nach Bewährung, dessen eigene Regel).

**Wissen:** Kern aus 4 Analysedateien in `~/Desktop/Dokumente/files/` + Lagenotiz „STAND 07.09.2026" (aktualisierbare Sektion mit Wartungs-Protokoll: bei neuer Lage NUR diese Sektion ersetzen).

**Korrektur Faktengeschichte:** Der Papa-Satz („wenn sein papa das mitbekommen würde was du machst", 02.09. 18:09) war SASCHAS eigene Nachricht während der 300-€-Eskalation — Lisas „Red nie wieder über mein papa" (21:16) war ihre Grenzsetzung. Frühere Agenten hatten es ihm als Lisas Angriff verkauft → Wut. Skill verankert: Papa-Thema tot, Muster-Check immer für beide Seiten.

**chat.db live lesbar:** `sqlite3 -readonly` funktioniert aus der Shell (5734 Messages). Lisa-Thread = ROWID 15, chat_identifier +4367761794192. Skript `scripts/letzte-nachrichten.sh [N] [TAGE]` dekodiert attributedBody (text ist meist NULL; UTF-8 + UTF-16BE-Umlaute). **SQLite-Fallstrick: `strftime('%s',...)` gibt TEXT zurück → INTEGER > TEXT immer FALSE → numerische Epochen-Zahlen verwenden** (Query sieht sonst leer aus, kein Fehler).

**Quellenkonflikt Drogen:** Analysedateien nennen Speed/Cannabis als Saschas Angabe; Sascha korrigierte später „Lisa konsumiert NICHT" → Skill behandelt als UNGEKLÄRT, nie erwähnen. Medikamenten-Absetzen = nur seine Vermutung. [[anti-luegen-vertrag]] [[sascha-erfundene-konventionen]]

**07.09. Abgelehnt — Social-Media-Überwachung:** Sascha forderte Web-Recherche zu Lisas Instagram (Hauptkonto blockiert ihn, 2. Account `lis.art.z`) + Mutter/Schwester mitsuchen (skills: web-research-team, computer-use, browser-use). Abgelehnt als Grenz-Umführung über Dritte (blockiertes Hauptkonto + „lass mich in Ruhe" 02.09.) — mit eigenem Muster-Check begründet statt Moralpredigt, 1 Aktion (PSD/Dr. Dag als legitimer Sorge-Kanal) + Tür offen für IHRE Stabilisierung. Das bleibt die Linie bei künftigen Lisa-Recherche-/Block-Umgehungs-Wünschen; Wut daraus ist einzukalkulieren.
