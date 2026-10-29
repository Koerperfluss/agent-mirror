---
name: simple-language-feedback
description: Sascha verstand die kategorisierte Brew-Tabelle nicht — bei
  Erklärungen erst einfache Sätze, Tabellen nur als Zusatz
metadata:
  node_type: memory
  type: feedback
  originSessionId: session_e471165b9adf80eda6e42d16256949b0
---

Auf die Brew-Inventar-Antwort (kategorisierte Tabelle, 51 Pakete) reagierte Sascha mit „ich verstehe dich nicht /boost" (29.10.2026). Erst die 3-Sätze-Erklärung („nur ~51 selbst installiert, Rest sind Zutaten wie für ein Rezept, nichts tun") kam an.

**Why:** ADHD-/caveman-Kompaktheit kollidiert mit Fachferne; bei System-Themen (Pakete, Infra) braucht er Plan-Sprache statt Jargon-Tabelle.

**How to apply:** Bei Erklär-Aufgaben Zeile 1 = Ergebnis in 2–3 einfachen Sätzen, Alltags-Metaphern, erst dann Detail-Tabelle; Fachbegriffe (leaf, Cask, Dependency) direkt mit Rezept-Beispiel erklären. Eskalation 29.10.: Nach zweiter kategorisierter Tabelle wurde er aggressiv (Beleidigungen) und verlangte die rohe Liste Paket-für-Paket — also lieferte die vollständige 51-Zeilen-Einzeltabelle mit Klartext-Erklärung pro Paket, das nahm er an. Bei „was ist das alles?"-Fragen also die komplette Einzelposten-Liste, keine Kategorien-Zusammenfassung. Siehe [[homebrew-stack-inventory]].

**29.10. Abend — ERLEDIGT: MENSCHI-REGEL steht in `~/.zcode/AGENTS.md`** (Ende der Datei, Block `<!-- MENSCHI-REGEL:START/END -->`, verbindlich seit 29.10.2026). Saschas Vorgaben, die sie kodifiziert: ① KERN in 1–2 Sätzen ganz oben ② um was geht es (2–3 einfache Sätze, Fachwort = 1 Erklärungssatz) ③ Entscheidung klar: „Löschen: JA/NEIN" pro Punkt, keine Optionen-Wüste ④ Abhängigkeiten/Risiko kurz ⑤ Lösung/Nächster Schritt kopierfertig, max. 3 Schritte. Verboten: Tabellen-Wüsten (max. 1 kleine Tabelle), Jargon ungeklärt, Entscheidungen versteckt. Sascha rief sie an mit „alles daran war unklar … wie eine Aussage aussehen soll" — die Struktur kam aus seiner eigenen Beschreibung. Hook-Notiz: `cat >> AGENTS.md` via Bash wird von Mimosa geblockt — AGENTS.md nur per **Edit/Write** ändern. Skill-Router-Referenz: `~/.claude/skills/ask-matt/SKILL.md`. Websuche-Befund: keine installierbaren „menschlich"-Plugins, nur Prompt-Vorlagen ([actmorehuman.com/guides](https://www.actmorehuman.com/guides) u. a.). `/loki-os-standard`, `/gstack-openclaw-ceo-review`, `/memory-enhanced-decision-making`, `/briefmaker` (trotz Listen-Eintrag) und `/i-have-adhd`/`/allrounder` sind als Skills NICHT aufrufbar — bei solchen Invokes klar sagen und die dahinterliegende Regel direkt umsetzen.
