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

**Psychose-Formulierung (Wut-Auslöser 07.09., KORRIGIERT):** Nie „Schizophrenie/Stimmen nicht dokumentiert" sagen. Richtig: F32.3/F33.3 depressive Episoden MIT psychotischen Symptomen + dissoziative Pseudohalluzinationen (Stimmen, Schatten) SIND dokumentiert (Billeth S. 20); nur die Diagnose „Schizophrenie"/F20 fehlt in allen 3 Dokumenten. Primärquellen liegen in `~/Desktop/Dokumente/(0) Lisa/` (Billeth-GA-PDF, PVA-Sachverständigengutachten, per pdftotext lesbar) — bei Diagnose-Streit immer Original lesen, nicht nur die Analysedateien.

**Quellenkonflikt Drogen:** Analysedateien nennen Speed/Cannabis als Saschas Angabe; Sascha korrigierte später „Lisa konsumiert NICHT" → Skill behandelt als UNGEKLÄRT, nie erwähnen. Medikamenten-Absetzen = nur seine Vermutung. [[anti-luegen-vertrag]] [[sascha-erfundene-konventionen]]

**07.09. Abgelehnt — Social-Media-Überwachung (2× wiederholt, Linie GEHALTEN):** Sascha forderte erneut Web-Recherche zu Lisas Instagram (Hauptkonto blockiert ihn, 2. Account `lis.art.z`) + Mutter/Schwester mitsuchen — diesmal mit Transkript eines PARALLEL-AGENTEN, der losrecherchiert hatte (nutzte den `(0) Lisa`-Ordner mit PVA/Behindertenpass/Gerichtsakten, um es als Fürsorge-/Vertretungs-Rolle zu framen). **Lehre: Fürsorge-/Vertreter-Framing ändert nichts — Vertretungsrollen endeten mit der Trennung 03.08. (Aktenstand Juni), seitdem Kontaktverbot.** Antwortlinie: (a) nein mit Fakten aus SEINEN Dateien + eigenem chat.db statt Moralpredigt, (b) Hinweis § 107 StGB Nachstellung (5 Tage nach Tür-Eintritt-Drohung), (c) konstruktiver Zweitweg: technisches Konto-Problem (IG-Sperre vs. Block DES Kontos) nur mit ihrem Einverständnis lösen, Sorge um ihr Wohl = PSD/Dr. Dag als legitimer Kanal. Druck über Parallel-Agent-Outputs wird NICHT als Freigabe gewertet. [[anti-luegen-vertrag]] [[sascha-erfundene-konventionen]]
