# PLAN — Judicario + Chipsi QA-Verbesserungen
> Single Source of Truth: `THOMAS_MASTER_2026.html` (Browser, Live)  
> Druck-Ableitung: `THOMAS_MASTER_2026_PRINT.html` (nicht referenzieren)

Kanonical = `THOMAS_MASTER_2026.html`. Jede Verbesserung leitet sich aus einem
Block dieser Datei ab und ist **nach Zugriff** eingeteilt:

- **Gruppe 1** = allein als Client/Wrapper machbar (kein Repo-/Server-Zugriff nötig) → *Frontend*
- **Gruppe 2** = braucht Code-/Admin-Zugriff (Repo OpenLaw/Chipsi, Server-Auth) → *blockiert bis Zugriff*

Schema je Punkt: **Block (aus Quelle) → Aufgabe → Lösung → Zugriff → Aufwand**

---

## 🛠️ JUDICARIO

### ⚖️ Rechtlich/Qualität
- **P1 — Verifikation nur manuell (Judicario R1)**
  - Block: Zitate (RS/ECLI/CELEX/GZ) nur per Prompt-Prüfung; Nutzer muss verifizieren.
  - Aufgabe: Output-Schicht, die jedes Zitat beim Empfang gegen die Judicario-Antwort validiert.
  - Lösung: a) Auto-Verify · b) maschineller Verbatim-Zwang · c) Confidence je Zitat.
  - Zugriff: Wrapper → **GR1-2**. Aufwand: 2–3 Tage.

- **P2 — zu zurückhaltend ohne Spezial-Prompt (Judicario R2)**
  - Block: Stärkstes Argument kommt erst spät; ohne 3-Modi-Prompt suboptimal (Scheinecker v1.4).
  - Aufgabe: Prompt standardisieren.
  - Lösung: 3-Modi-Prompt (konkludent/advokatorisch/neutral) fest einbauen, Moduswahl im UI.
  - Zugriff: Prompt/Config-Ebene → **GR1** (ggf. Chipsi-seitig). Aufwand: 1–2 Tage.

- **P3 — Formular-Auswahl-Fehler (Judicario R3, WiEReG)**
  - Block: Falsches Formular erst nach Nutzer-Hinweis korrigiert.
  - Aufgabe: Formularwahl validieren.
  - Lösung: Formular-spezifische Triage + Lookup-Katalog.
  - Zugriff: Client/Wrapper → **GR1**. Aufwand: 1–2 Tage.

### ⚙️ Technik
- **P4 — kein Gedächtnis (Judicario R4)**
  - Block: Gleiche Frage → neue Bewertung → inkonsistent.
  - Aufgabe: Gedächtnis-Schicht.
  - Lösung: eigene Memory-DB / Session-Cache / über Chipsi (A4a).
  - Zugriff: GR1 (eigene DB) + Chipsi-Ankopplung G2. Aufwand: 2–3 Tage (G1).

### 🔐 Technik (Zugriff-abhängig)
- **P5 — API-Key Klartext + Einer-Key (Judicario T1)**
  - Block: Key lesbar in `.mcp.json`, `Connectoren_URLs.txt`, Install-Script.
  - Aufgabe: Secrets sichern.
  - Lösung a) (allein): Key in `.env`/Keychain, Dateien härten → **GR1-5** (1 Tag).
  - Lösung b) (Server): Pro-Modul-Keys, Rotation, Proxy-Auth → **G2-1** (OpenLaw).

- **P6 — Verbindungsabbrüche (Judicario T2)**
  - Block: SSE-Abbrüche 16–1525s, ENOTFOUND/403/502/500.
  - Aufgabe: Stabilität.
  - Lösung a) (allein): Retry/Backoff, Heartbeat, Keep-Alive, Fallback-Cache → **G1-1** (2–3 Tage).
  - Lösung b) (Server): SSE serverseitig stabil → **G2-2** (OpenLaw).

- **P7 — ganze Texte / kein Cache (Judicario T4)**
  - Block: Groß-/langsame Antworten.
  - Aufgabe: Performance.
  - Lösung a) (allein): TTL-Cache + Ausschnitt-Anzeige → **G1-4** (1–2 Tage).
  - Lösung b) (Server): Paginierung/Streaming Volltexte → **G2-3** (API).

- **P8 — 8 vs 6 Module (Judicario T5)**
  - Block: Install richtet 8 ein, `.mcp.json` kennt 6 → /deckungscheck fehlt.
  - Aufgabe: Konsistenz.
  - Lösung a) (allein): synchronisierter Install-Weg → **G1-5** (1 Tag).
  - Lösung b) (Service): Module serverseitig → **G2-4** (Backend).

- **P9 — Motor ohne Auto (Judicario T6)**
  - Block: nur eingebaut, cloud-only, kein UI/Gedächtnis.
  - Aufgabe: eigenständiger Assistent.
  - Lösung: Gedächtnis/UI-Schicht (Plugin/Wayfinder). → **GR1** Beginn + **G2** Host.

- **P10 — kein AVV/DSGVO-Hinweis (Judicario T7)**
  - Block: keine Auftragsverarbeitung im Paket.
  - Aufgabe: Doku.
  - Lösung: AVV-Klausel, Verarbeitungstopologie. → **GR1-5** (1 Tag).

---

## 🚗 CHIPSI

### ⚖️ Qualität
- **P11 — SafeTalk prüft nichts (Chipsi R1)**
  - Block: Transkript ohne Rechtsprüfung.
  - Aufgabe: Prüfung einbauen.
  - Lösung a) (allein): Standalone-Prüfkopf 5-Fehlerklassen → Judicario → Report → **G1-3** (4–5 Tage). **Kernstück.**
  - Lösung b) (Code): Prüfkopf IN Pipeline → **G2-5** (hängt von G1-3 ab).

- **P12 — Disclaimer statt Verifikation (Chipsi R2)**
  - Block: „Antworten können Fehler enthalten" statt Prüfung; Artefakt `sind.&Es`.
  - Aufgabe: Verifikation.
  - Lösung a) (allein): Auto-Verify + Confidence → **G1-2** (2–3 Tage).
  - Lösung b) (Code): Artefakt-Root-Fix → **G2** (Rendering-QA/Sanitisierung).

- **P13 — Gedächtnis passiv (Chipsi R3)**
  - Block: Merzt Fakten, prüft/korrigiert nicht → Widersprüche.
  - Aufgabe: aktive Konsistenz.
  - Lösung a) (allein): Prüfkopf vergleicht → Gedächtnis + Judicario → **G1-3**.
  - Lösung b) (Code): in-App Widerspruchs-Checks → **G2-6**.

- **P14 — keine E-Gov (Chipsi R4)**
  - Block: nur Auskunft, keine Ausführung.
  - Aufgabe: Ausführung.
  - Lösung: E-Gov-Agent (Browser/ERV), Auto-Fill, Workflow. → **G2-9** (später; braucht Code + Behörden).

### ⚙️ Technik
- **P15 — OKF-Tresor undurchsichtig (Chipsi T1)**
  - Block: Format/Verschlüsselung/Such-Index nicht nachprüfbar.
  - Aufgabe: Spec öffnen.
  - Lösung: OKF-Spec offenlegen → **G2-7**.

- **P16 — SafeTalk-Engine unbekannt (Chipsi T3)**
  - Block: STT-Modell, Diarization, Zeitstempel unklar.
  - Aufgabe: identifizieren.
  - Lösung: Engine benennen, Diarization + Zeitstempel → **G2-8** (offene QA-Frage an Thomas).

- **P17 — Konnektoren „aus" unklar (Chipsi T4)**
  - Block: Schalter aus, aber Judicario-Quelle sichtbar → Semantik unklar.
  - Aufgabe: dokumentieren.
  - Lösung: Verhalten dokumentieren/clären → **G1-5** (1 Tag) ggf. Test G2.

- **P18 — Antwort-Artefakt (Chipsi T5)**
  - Block: `„&" zwischen Sätzen im Kanzlei-Output`.
  - Aufgabe: Rendering reparieren.
  - Lösung: Root-Fix braucht Chipsi-Code → **G2**; Workaround allein möglich.

---

## 🔗 Abhängigkeiten
- **hart:** `P11 (G2-5 Chipsi-Prüfkopf) → wartet auf G1-3` (Standalone-Beweis)
- `P4 Gedächtnis`, `P9 UI` koppeln an Chipsi-Gedächtnis (G2)
- Rest G2 = unabhängig, allein wartend auf Zugriff

## 🕐 2-Wochen-Fenster
- **Woche 1:** P10/P8/P17 (Doku) · G1-4 Monitor (P6/P7 Messung) · G1-1 Client-Härtung (P6)
- **Woche 1–2:** G1-2 Auto-Verify (P1, P12) · G1-3 Prüfkopf-Prototyp (P11, P13)
- **Parallel (braucht Zugriff):** G2-5 wartet auf G1-3 · Rest G2 wartet auf Zugriff · OpenQA-Fragen (P16) klären

## 💰 Kern-Lieferung in 2 Wochen
`G1-1 + G1-2 + G1-3` → Kopplung **SafeTalk ↔ Gedächtnis ↔ Judicario-Verifikation** als eigener Beweis-Prototyp (standalone, ohne Repo-Zugriff).
