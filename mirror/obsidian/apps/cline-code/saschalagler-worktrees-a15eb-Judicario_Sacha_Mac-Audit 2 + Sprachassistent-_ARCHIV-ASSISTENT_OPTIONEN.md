---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/Audit 2 + Sprachassistent/_ARCHIV/ASSISTENT_OPTIONEN.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# ASSISTENT — OPTIONEN (mehrere Ansätze, offen)
## 24/7-Sprach-Transkriptions-Assistent für Thomas · Vor-/Nachteile je Ansatz
Stand: 04.08.2026 · Basis: AUDIT_2_TIEFENANALYSE.md + SPRACHASSISTENT_MARKTFUEHRER_ANALYSE.md

> Ziel: Assistent hört mit, merkt sich (Second Brain), meldet NUR bei belegtem Fehler oder
> wenn gefragt, assistiert auf Anfrage. **Nie unterbrechen.**
> Hier stehen ALLE Optionen — die Wahl trifft Thomas (siehe QA_SACHA_THOMAS.md).

---

## A. INTEGRATIONS-ANSÄTZE

### A1 · Integriert IN Chipsi (SafeTalk-Pipeline)
Neuer Schritt: `SafeTalk → Transkript → [Prüfkopf + Brain] → Protokoll + Report`
- **+** nativ im Team nutzbar; nutzt bestehende UI/Akten/Gedächtnis; keine Extra-Infrastruktur
- **+** Daten bleiben in Thomas' Plattform
- **−** abhängig von Chipsi-Release-Zyklus; braucht Thomas' Entwicklungsteam

### A2 · Lokal auf Thomas' Rechner (Standalone)
Eigener Dienst (faster-whisper lokal + Brain + Judicario-Calls)
- **+** maximale Kontrolle/Datenschutz; unabhängig von Chipsi
- **+** 0 € laufende STT-Kosten
- **−** zweites System neben Chipsi (Medienbruch); Wartung bei Thomas lokal

### A3 · Als eigener Connector (wie die Judicario-Tools, MCP)
Assistent wird als MCP-Konnektor angeboten, den Chipsi/Claude einbindet
- **+** passt exakt ins bestehende Konnektor-Muster (wie judicario-at/de/…); sauber modular
- **+** wiederverwendbar für andere Kunden
- **−** braucht MCP-Hosting; Latenz über Gateway

### A4 · Hirn-Kopplung: bestehendes Langzeit-Gedächtnis nutzen VS neues Hirn
- **A4a · koppeln:** Assistent liest/schreibt das bestehende Chipsi-Langzeitgedächtnis (OKF)
  - **+** kein Doppel-Gedächtnis; nutzt vorhandene Fakten/Entscheidungen; sofort Kontext
  - **−** abhängig von Chipsi-Speicherformat/-Zugriff
- **A4b · neues Hirn:** eigene Memory-Schicht (Obsidian-artig / Vektor-DB)
  - **+** volle Kontrolle, portabel, unabhängig
  - **−** Doppel-Pflege; Migration/Abgleich nötig

---

## B. SPRACHMODELL-/STT-OPTIONEN (Vor-/Nachteile)

| Option | Echtzeit | Lokal? | Gedächtnis | Vorteile | Nachteile |
|---|---|---|---|---|---|
| **faster-whisper / whisper.cpp** | via VAD/Streaming | ✅ | ❌ | 0 €, Datenschutz, offline | keine native Diarization; nur „Röhre“ |
| **AssemblyAI** | ✅ | ❌ (Self-host opt.) | via LLM | beste DE-Akkuratheit, Diarization | Kosten/Minute, Cloud |
| **Deepgram Nova-3** | ✅ | ❌ (Self-host opt.) | ❌ | −54 % WER, meetings-optimiert | Cloud-Kosten |
| **OpenAI Realtime** | ✅ (232 ms) | ❌ | ❌ | native Turn-Detection, Barge-in | Cloud, keine Wort-Zeitstempel im Live-Modus |
| **Gemini Live** | ✅ | ❌ | ❌ | 70+ Sprachen, Barge-in | Preview, Cloud |
| **Fireflies/Otter-Muster** | ✅ | ❌ | ✅ „perfect memory“ | Second-Brain-Referenz | SaaS-Abo, Cloud |

**Kombinations-Empfehlung (offen):** STT lokal (faster-whisper) + optional Cloud-Fallback
(AssemblyAI/Deepgram) für Qualität; Second-Brain nach Fireflies/Otter-Muster; Rechtsprüfung
via Judicario. Aber: alle Optionen bleiben wählbar (siehe QA).

---

## C. MELDE-VERHALTEN (fix, unverhandelbar im Konzept)
- Nie unterbrechen.
- Melden NUR bei **belegtem** Fehler (Verbatim-Zwang) ODER wenn gefragt.
- Kein Beleg → keine Meldung (höchste diskrete [unklar]-Markierung).
- Auf Anfrage → voll assistieren.

---

## D. OFFENE ENTSCHEIDUNGEN FÜR THOMAS
1. Integrations-Ansatz: A1 / A2 / A3 (oder Kombi)?
2. Hirn: A4a koppeln / A4b neu?
3. STT: lokal / Cloud / hybrid?
4. Meldemodus: nur Report / dezente Live-Markierung zusätzlich?
5. Umfang: nur Rechtsfehler / + Meeting-Struktur (Termine/Themen)?

→ Siehe **QA_SACHA_THOMAS.md**.
