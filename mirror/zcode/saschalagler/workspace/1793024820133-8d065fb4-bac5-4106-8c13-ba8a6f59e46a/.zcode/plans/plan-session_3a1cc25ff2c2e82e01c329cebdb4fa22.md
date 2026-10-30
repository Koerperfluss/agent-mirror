# Product Canvas Local — Funktionsparität: 3 kaputte Teile heilen + Rest sauber kappen

## Context
Der 1:1-Klon des Google Product Canvas läuft nativ als Tauri-App (Canvas, Docs, KI-Text/Code über Ollama, lokale DB). Die Exploration (2 Agenten, Pfad-Beweise) zeigt jetzt GENAU, was im LOCAL-Modus noch kaputt ist — und was davon lokal überhaupt machbar ist. Neues ZIP = identisch mit Original, keine Sync nötig (nur unsere 3 bewussten Zusätze).

## Befunde (bewiesen)
| Feature | Status | Ursache |
|---|---|---|
| AI-Cursor, Wiki/Tiptap, Slash-Befehle, Onboarding, Mini-App-Generator | ✅ läuft | Adapter deckt Text-Generierung |
| **Live-Voice** (`live/LiveAPI.tsx:200`) | ❌ TypeError-Crash | Adapter hat kein `ai.live` → Boot nutzt es → Crash-Gefahr beim Voice-Button |
| **Bild-Generierung** (`ai/nano-banana.ts`) | ❌ Fehlermeldung statt Bild | Adapter liefert kein `inlineData`; `getDownloadURL()` rejected bewusst |
| **Mini-App-Runtime** (iframe) | ❌ offline | React/Lucide/Tailwind kommen von esm.sh/jsdelivr-CDN |

## Schritte (Backups .bak-2026-10-30 vor jedem Original-Edit)

| # | Was | Wie | Beweis |
|---|---|---|---|
| 1 | **Live-Voice sauber kappen**: `ai-local.ts` erhält `live`-Stub, dessen `connect()` eine klare deutsche Fehlermeldung wirft; Editor versteckt Voice-UI im LOCAL-Modus (statt TypeError-Crash) | Code-Diff + kein Crash mehr beim Voice-Versuch |
| 2 | **Bild-Speicher heilen**: `firebase-local.ts` `getDownloadURL()` → liefert lokale Data-URL statt Reject (saveImage-Pfad läuft dann ohne Absturz); nano-banana `generateImage` → klare Meldung „Bild malen lokal nicht möglich (Ollama kann nur Text/Bild verstehen)" im Node-Text | Bild-Node zeigt sauberen Hinweis |
| 3 | **Mini-App-Runtime offline-tauglich**: React/ReactDOM aus dem App-Bundle lokal servieren (importmap auf `tauri://localhost/vendor/`), lucide-react+Tailwind bleiben CDN mit Offline-Hinweis im Frame — Prototyp-Preview läuft mit React-Teil offline | Mini-App-Node zeigt Vorschau ohne Netz für React |
| 4 | **Frontend + Tauri neu bündeln**, App starten | Build-Exits |
| 5 | **Beweis-Batterie**: Canvas + KI-Text-Antwort (Ollama live) + Notebook + Mini-App-Hinweis + kein Voice-Crash + Persistenz-Datei wächst | Screenshots (fenster-exakt) + boot.log + canvas-db.json |

## Nicht tun (klar abgegrenzt)
- Echtes Bild-MALEN lokal: braucht Diffusions-Modell (ComfyUI/Draw Things) — separater Auftrag auf Wunsch.
- Echte Live-Voice lokal: Whisper+Ollama-Pipeline — Ausbau später.
- Multiplayer/Video: bleibt raus (Befehl).

## Zeitaufwand
~45–60 Min. · Credits gering (alles lokal, nur 1 Build-Zyklus + Screenshots).