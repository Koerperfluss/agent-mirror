---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/pruefarchiv/kapitel/07_kommunikation_output.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# KAPITEL 07 — Kommunikation & Output-Protokoll

**Prüfdatum:** 28.07.2026 · **Lead-Audit**

---

## 7.1 Output-Protokoll (6-Elemente-Struktur) ✅

Der Prompt (`legal_ops_omni.txt` Z. 52-59) definiert ein striktes 6-Ausgabeschema:

| # | Element | Inhalt |
|---|---|---|
| 1 | ⚡ ERGEBNIS | Kernlösung + Quelle + Erfolgschance in % |
| 2 | 📋 PRÜFPROTOKOLL | Fakten-Check / Quellen / Strategie |
| 3 | 🎯 MASTERPLAN | Tabelle: Schritt/Rolle/Problem/Norm/Handlung |
| 4 | 🌐 RESSOURCEN | Plattform / Digitaler Klickpfad / Formvorschrift |
| 5 | 🗣️ ADVISORY | Erfolgswahrscheinlichkeit / Taktische Beratung |
| 6 | 💼 EXEKUTION | Kopiervorlage (Schriftsatz/Antrag) mit [WERT]-Platzhaltern |

✅ **Bewertung:** Strukturiert, praxisnah, unterscheidet Beratung von Exekution. Die Platzhalter-Konvention `[WERT]` ist sauberer als LaTeX-`$$` (Z. 48: „verhindert LaTeX-Fehler im UI").

---

## 7.2 Kommunikations-Regeln (Token-Ban) ✅

**Token-Ban (Analyse-Modus):** „gerne", „hoffe das hilft", „zusammenfassend", „als KI-Modell", „es ist wichtig zu beachten" → gesperrt. (`legal_ops_omni.txt` Z. 49)

**Whitelisting (Exekution & Advisory):** natürlicher, höflicher, professioneller, menschlicher Ton GEWÜNSCHT. (Z. 50)

✅ Dies verhindert typische KI-Floskeln („ich hoffe das hilft") und erhält professionelle Qualität.

---

## 7.3 ADHD-Cognitive-Scaffolding ✅

- **BLUF-Pflicht:** Erste Zeile immer ⚡ ERGEBNIS (Bottom-Line-Up-Front)
- **GFM-Tabellen:** 4–5 Spalten, inkl. Kosteneinschätzung (RATG, AHK, GGG) zum wirtschaftlichen Prozessrisiko
- **Platzhalter:** nur `[WERT]`

---

## 7.4 Kommunikations-Vergleich (alle Systeme)

| Dimension | Legal Ops Advisor | Judicario | Chipsi |
|---|---|---|---|
| Output-Struktur | ✅ 6-Element-Protokoll, BLUF-first | ⚠️ abhängig vom Projekt-Prompt | 🔶 |
| Kommunikations-Qualität | ✅ Token-Ban + Whitelisting | ⚠️ abhängig von Claude | 🔶 |
| Tabellen-Güte | ✅ GFM + Kosteneinschätzung | ⚠️ kein Standard-Protokoll | 🔶 |
| Beratungs-Ton | ✅ professionell-menschlich (kein KI-Ton) | ⚠️ variabel | 🔶 |
