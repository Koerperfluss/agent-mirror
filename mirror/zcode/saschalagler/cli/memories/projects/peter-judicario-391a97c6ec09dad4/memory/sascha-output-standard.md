---
name: sascha-output-standard
description: Saschas fester Output-Standard — niemals Markdown/Chat-Wände, immer
  druckfähige Datei (PDF weiß), Layout von ihm abnehmen lassen
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_8db9086b-109a-4839-8ff9-e33012080869
---

Sascha will Analyse-/Erklär-Ergebnisse **niemals als Markdown oder lange Chat-Texte**, sondern als **Datei (PDF, weiß/druckfähig; PPTX nur auf Wunsch)**. Fester Aufbau: oben „Die wichtigsten Dinge (komplett)" als nummerierte BLUF-Liste, darunter nummerierte Abschnitte pro Quelle/Screenshot (Nummer + Thema + Aussagen + Lösung + Ziel + Bild), unten Quellenzeile mit Unverifiziert-Markierung. Weißes Papier, schwarze Texte, keine dunklen Flächen.

**Why:** 20.09.2026 heftige Kritik: Inhalt „zu viel, zu komplex, keine visuelle Trennung, ich will keine Markdowns sondern Files PDFs oder ähnliches". Zusätzlich: „du entscheidest sicher nicht ohne mir, wie ich den Text/den Aufbau haben will" — Layout/Aufbau = seine Entscheidung (Entscheidungshoheit), vorab als Optionen fragen oder den [[briefmaker]]-Standard nutzen. Wort „Fiche" von ihm abgelehnt.

**How to apply:** briefmaker-Skill (`~/.agents/skills/briefmaker/SKILL.md` + AutoClaw-Kopie, Vorlage `vorlage.html`) aufrufen. Struktur 21.09. von Sascha bestätigt: **Abschnitt 1 „KERN" = seine fixen Vorgaben** (BLUF-Liste oben komplett, Abschnitte Nummer/Thema/Aussagen/Lösung/Ziel + Screenshot ≤46 mm, Antwort-Text am Ende, Quellenzeile, weiß #fff/#111827, Akzent #B45309 nur Warnungen, „Bericht" statt „Fiche") · **Abschnitt 3 = Ideen-Pool aus anderen Skills, nur situativ:** grilling (nur Entscheidungen fragen, 1 Frage/Runde mit Empfehlung), design-an-interface („Design it twice" nur bei NEUEN Formaten, nie Routine), memory-enhanced-decision-making (Optionen-Tabelle + 🥇, Entscheidung bleibt bei ihm), d3/mermaid (nur Zahlenreihen/Abläufe), higgsfield-brandkit (nur bei Branding-Wunsch). iris 0.4.1 (`~/.local/bin/iris`) jetzt auch ZCode-global in `~/.agents/skills/iris/` installiert. LibreOffice 26.8.0 verfügbar (brew cask; App fehlte in /Applications → `brew reinstall --cask libreoffice`; soffice in /opt/homebrew/bin).

**Zeit-Aufwand (21.09., harte Sascha-Kritik „kann nicht die Nerv sein, so lang"):** Pipeline auf **1 Bash-Kette** komprimiert — python3 -c-Injektion && Chrome `--print-to-pdf=DATEI.pdf` (NUR =-Form, 2-Token-Form = Chrome-Fehler „multiple targets") && pdftoppm && ls → **2,3 s gemessen** (2 Seiten, 5 Bilder) + 1 Read der PNGs + Abnahme-Stop. **PDF = Standard, PPTX nur auf explizites Wort** (sonst doppelter Aufwand). Keine Generator-Skripte (Mimosa, siehe [[mimosa-hook-write-blocks]]). Vor „fertig"-Rufen immer Beweis (PNG) und sein GO. Nicht gebaute „Automatik" nie als laufend behaupten (Kritik 21.09.). Berichte nach KERN ohne Nachfrage bauen; nur bei NEUEN Dokumenttypen Optionen vorlegen. Siehe auch [[mimosa-hook-write-blocks]] und [[lokivoice-v10-stand-presentation]].
