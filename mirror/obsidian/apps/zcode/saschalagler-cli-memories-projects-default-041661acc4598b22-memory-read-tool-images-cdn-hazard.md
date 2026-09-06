---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/read-tool-images-cdn-hazard.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: read-tool-images-cdn-hazard
description: ZCode-Read-Tool lädt lokale Bilder zu einem externen CDN hoch
  (ufileos.com) statt sie nur anzuzeigen — private Fotos nie per Read öffnen;
  lokale OpenCV-Metriken via uv als Ersatz
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_448f3c97-86fc-4e6a-bb85-6f48f325162d
---

Am 26.08.2026 lud das Read-Tool beim Öffnen lokaler Familienfoto-JPEGs diese zu `maas-log-prod.cn-wlcb.ufileos.com` (signierte CDN-URLs, ~2 Tage gültig) hoch, statt sie lokal anzuzeigen — 7 Fotos exponiert, bevor ich stoppte. `analyze_image` (4_5v MCP) ist ebenfalls remote-only (URL-Pflicht) und ratelimitiert (429 „账户已达到速率限制"; ein Upload kam kaputt an → 400 Parse-Fehler). Kein `ollama` installiert → auch kein lokaler Vision-Fallback.

**Why:** Saschas Fotos/Daten sind privat; ich hatte „100 % lokal" zugesagt und musste den Leak transparent machen (habe es sofort gemeldet und die Methode gewechselt).

**How to apply:**
1. Private/sensible Bilder NIEMALS per Read öffnen und nie an analyze_image übergeben, außer die Datei ist ohnehin schon exponiert (bereits existierende CDN-URLs dürfen weitergenutzt werden — keine neue Exposition).
2. Lokale Bild-Diagnostik stattdessen per Metriken: `uv run --python 3.12 --with pillow --with "opencv-python-headless<5" python - <<'PY'` — Kanalmittel (Farbstich), HSV-Sättigung (S/W vs Farbe), Luminanz/std (Belichtung/Kontrast), Laplace-Varianz (Schärfe), Haar-Gesichter. OpenCV 5.x hat CascadeClassifier entfernt → Pin <5.
3. Vor jedem Bild-Upload in irgendeinem Tool kurz prüfen, ob ein lokaler Weg existiert — Sascha arbeitet datensparsam ([[foto-restaurierung-opa-a4]]).

**Ergänzung 06.09. — funktionierende Screenshot-Pipeline (nur für nicht-private UI-Screenshots):** CUA-`screenshot` liefert ablaufende signierte CDN-URLs zurück. Kette: CUA screenshot → URL mit `curl` nach /tmp laden → `Read` lädt sie erneut aufs CDN (frische, gültige Signatur!) → **diese frische Read-URL an `analyze_image` (4_5v) übergeben funktioniert zuverlässig**; alte/expired URLs und lokale Datei-Pfade geben Fehler 1210 „图片输入格式/解析错误". Zoom-Frames (`zoom`-Tool) funktionieren genauso. Das ist für UI-Verifikation ok (App-Inhalte), für private Fotos weiter verboten (Punkt 1).
