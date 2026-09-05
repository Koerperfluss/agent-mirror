---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/Audit 2 + Sprachassistent/TODO_JUDICARIO_CHIPSI.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# TODO — Judicario + Chipsi | QA-To-do (nur beide Tools)
> **Single Source of Truth:** `THOMAS_MASTER_2026_PRINT.html`  
> Fokus: Judicario (🔧 Motor der Rechts-Bibliothek) + Chipsi (🚗 Auto/Kanzlei-App). Legal Ops bleibt Referenz, ist nicht Gegenstand. Kein Angebot/Pitch/Verkauf.

Zero-Source-Prinzip: Jede Zeile leitet sich **direkt** aus einer Zeile im Audit-Dokument ab (AUDIT §-Beleg oder PDF-BELEG), nicht aus Dringlichkeit/Story.

## 🔑 Schlüsselidee
- **Gruppe 1** = kann ich **allein** (als Client/Wrapper via öffentliche Endpunkte, kein Repo-/Server-Zugriff nötig)
- **Gruppe 2** = **braucht Zugriff** (Judicario-Repo/OpenLaw-Server, Chipsi-Code) — ich liefere den Standalone-Beweis + Spezifikation

## ⚙️ GRUPPE 1 — Kann ich allein (Client/Wrapper, kein Zugriff)

| # | Baustein | Lösung (von außen) | Quelle | Aufwand |
|---|----------|--------------------|--------|---------|
| A1 | **Prüfkopf-Standalone-Demo** (SafeTalk-Analyse) | faster-whisper lokal → Transkript → 5 Fehlerklassen → per HTTP gegen Judicario prüfen → Report mit Confidence | T3 (Transkript+STT) + R1 (Prüfkopf) | 4–5 Tage |
| A2 | **Judicario-Client stabil lokal** | Wrapper → Retry+Backoff, Heartbeat/Keep-Alive, Fallback-Cache; fängt ENOTFOUND/403/502/500 + SSE-Drops ein | T2 (Stabilität) | 1–2 Tage |
| A3 | **Zitate per Default verifizieren** | jede Judicario- Antwort validiert jedes Zitat (RS/ECLI/CELEX) gegen die Quelle → Verbatim-Zwang + Confidence (kein Konto mehr ohne Meldung) | R1 (Nachprüfung automatisch) | 2–3 Tage |
| A4 | **8-vs-6 Module konsistent dokumentieren** | `.mcp.json` ←→ Install-Script ←→ README ←→ plugin.json synchronisieren; fehlendes /deckungscheck | T5 (Modul-Differenz) | 1 Tag |
| C0 | **Sicherheitspaket lokal** | Key raus aus `.mcp.json`/`Connectoren_URLs.txt`/Install → `.env`/Keychain; AVV-/Datenschutz-Hinweis ergänzen | T1 (Sicherheit) | 1 Tag |

**→ Machbar in 2 Wochen:** A1+A2+A3+A4+C0 (~7–9 Arbeitstage). A4a ist das Bindeglied zum Gedächtnis (siehe unten).

## 🔐 GRUPPE 2 — Braucht Code-/Admin-Zugriff (ich liefere Beweis + Spec)

### Judicario — Gateway/Server-Ebene (OpenLaw/Admin)
| # | Baustein | Warum nicht allein | Quelle | 2-Wochen-Status |
|---|----------|--------------------|--------|-----------------|
| B1 | API-Key richtig sichern (Scoping/Rotation, Secrets statt URL-Parameter) | Key liegt serverseitig als URL-Param; nur OpenLaw ändert Auth | T1 | Spec fertig; C0 als lokaler Workaround |
| B2 | SSE serverseitig stabil halten (Heartbeat, kein Drop nach 165 s) | Server-/Gateway-Code | T2 | Spec fertig; A2 Client mildert |
| B3 | Paginierung/Streaming Volltexte | Server-API | T4 | Spec fertig |

### Chipsi — App/Code-Ebene
| # | Baustein | Warum nicht allein | Quelle | 2-Wochen-Status |
|---|----------|--------------------|--------|-----------------|
| B4 | Prüfkopf IN die SafeTalk-Pipeline (SafeTalk→Transkript→Prüfkopf→Gedächtnis→Report) | direkt im Chipsi-Code/Release | R3 (Gedächtnis passiv) + Architektur M6 | **hart abhängig von A1** (Standalone-Beweis) |
| B5 | OKF-Tresor öffnen (Format/Verschlüsselung/Index) + Gedächtnis aktiv | internes Memory-Format | T1 (OKF undurchsichtig) | Spec + A4a-Doc; Integration erst nach OKF-Spec |
| B6 | SafeTalk-Engine/Diarization klarstellen (STT-Modell, Sprecher-Trennung, Zeitstempel) | Chipsi-Code | T3 | offene QA-Frage an Thomas |
| B7 | Antwort-Artefakt `sind.&Es` bereinigen | Render-Logik Chipsi | T5 | Spec (Workaround allein möglich) |
| B8 | E-Gov / Amtswege | Chipsi-Code + Behörden | R4 | später, nach Prüfkopf |

## 🔗 Harte Abhängigkeiten
- **B4 → A1** (Standalone-Prüfkopf muss existieren, bevor er in Chipsi integriert wird)
- B5 (OKF-Spec) ist Voraussetzung für A4a (Gedächtnis-Integration)

## 🕐 2-Wochen-Fenster
- **Woche 1 (A4+C0) → G1-4+3 (A2):** 1. Woche mit sichtbarer Stabilität + Sicherheit
- **Woche 1–2 (A1):** Standalone-Prüfkopf-Demo bauen → der Beweis
- **Woche 2 (A3):** Auto-Verify live
- **Parallel (B1–B8):** Specs schreiben, wartend; B4 wartet auf A1

## 💰 Kern-Lieferung in 2 Wochen
`A1 + A2 + A3` → **Kopplung SafeTalk ↔ Gedächtnis ↔ Judicario-Verifikation** als eigener, beweisbarer Prototyp — ohne Repo-Zugriff.
