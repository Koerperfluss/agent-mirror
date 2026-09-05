---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/Audit 2 + Sprachassistent/PROVENIENZ.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# PROVENIENZ — Warum gibt es THOMAS_MASTER_2026.html, und aus welchen Infos?
Stand: 04.08.2026 · Ziel: vollständige Nachvollziehbarkeit.

## 1. Warum die neue Datei (THOMAS_MASTER_2026.html)?
Der Nutzer (Sacha) forderte: **„alles so kompakt & klar wie möglich in EINER Datei (HTML mit Tabs)“**,
weil zuvor zu viele Einzeldateien entstanden waren. Deshalb wurde THOMAS_MASTER_2026.html als
einziges Nutzungs-Dokument mit 6 Tabs erstellt und die Einzeldateien zuerst gelöscht.
Auf Wunsch wurden die Einzeldateien danach in `_ARCHIV/` **wiederhergestellt** (dieser Ordner).

## 2. Woher die Infos kamen (Quellen → Master-Tabs)
| Master-Tab | Quellen (liegen in `_ARCHIV/`) |
|---|---|
| 📖 Benutzung | eigene Struktur (Einstieg) |
| 🔍 Audit 2 | `AUDIT_2_TIEFENANALYSE.md` + `JUDICARIO_RESEARCH.md` + Judicario-Originaldateien + Chipsi-Screenshots/PDF |
| 🤖 Assistent | `ASSISTENT_OPTIONEN.md` + `SPRACHASSISTENT_ARCHITEKTUR.md` + `SPRACHASSISTENT_MARKTFUEHRER_ANALYSE.md` |
| ❓ QA Thomas | `QA_SACHA_THOMAS.md` |
| 🤝 Zusammenarbeit | `ZUSAMMENARBEIT_BRAINSTORM.md` |
| 📋 Status | `KOMPLETT_ABGABE_2026.md` + `ZIELE_KANBAN_2026.html` |

## 3. Wiederherstellung (Nachweis)
- `SPRACHASSISTENT_MARKTFUEHRER_ANALYSE.md` wurde **byte-identisch (21294 Bytes)** aus der
  Session-Cache-Kopie (`.../CloudDocs/session/i/f47c0ff.md`) zurückkopiert.
- Die übrigen 8 Dateien wurden aus der Sitzungs-Historie wörtlich rekonstruiert.
- `_ARCHIV/` enthält somit den vollständigen Quellenstand, auf dem der Master aufbaut.

## 4. Korrektur-Hinweis (wichtig für die Logik)
Ältere Texte behaupteten „Chipsi hat kein Gedächtnis / Safebox dumm“ — **falsch**.
Richtig: Chipsi HAT Langzeit-Gedächtnis (lokal OKF); die Lücke ist, dass **SafeTalk nicht mit
Fehlerprüfung gekoppelt** ist und das Gedächtnis **passiv** ist. Der Master und alle Archiv-Dateien
tragen diese Korrektur.

## 5. Neuaufbau v2 (05.08.2026)
- **Grund:** Master v1 war unübersichtlich und unvollständig; der Legal Ops Advisor (Sachas Werkzeug) fehlte komplett; Technik und Funktion waren getrennt statt vereint.
- **Neu:** `RESEARCH_QUELLEN.md` — drei zitierte Primärquellen-Research-Läufe (Agenten-Team, 05.08.2026): Legal Ops Advisor (Quellcode + SQLite-Inspektion), Judicario (Plugin-Dateien + 8 Commands, Key maskiert), Chipsi (PDF-Extraktion, strikt getrennt vom Audit-Kontext).
- **Ersetzt:** `THOMAS_MASTER_2026.html` v2 (6 Tabs: Lesen · 3 Werkzeuge · Audit 2 · Assistent · QA · Zusammenarbeit) ersetzt v1. v1 gesichert als `_ARCHIV/THOMAS_MASTER_2026_v1.html`.
- **Unangetastet:** `_ARCHIV/` (9 Quellen) — nur um das v1-Backup ergänzt. `UBIQUITOUS_LANGUAGE.md` um Legal-Ops-Begriffe erweitert.
- **Neue Primärquelle:** `LEGAL_OPS_MASTER_ARCHIV/INDEX.md` (195 Dateien; u. a. `app_v2.py` + `ris_lookup.py`, die in der auditierten Arbeitskopie FEHLEN — im Audit als „Zwei Wahrheiten“ dokumentiert).
