---
name: visitenkarte-print-pipeline
description: Saschas Visitenkarten-Finalstand 27.10. — 4 Neubau-Designs A/F/H/I,
  8/8 Visual-Judge-PASS, FINAL-PDFs; bewährte Druck-Pipeline + Fallen
metadata:
  node_type: memory
  type: project
  originSessionId: session_c6838a9a3dbab5ae2ed3f047aa155416
---

Visitenkarte KÖRPERFLUSS (27.10.2026, ENDSTAND): 4 Neubau-Designs **A (Klassiker), F (Goldrahmen), H (Foto-Vollfläche), I (Creme)** — alle 8 Seiten von pdf:visual-judge **PASS mit Druck-Freigabe**. Finale Dateien: `~/Desktop/VISITENKARTE_DESIGNS_2026-10-27/FINAL_{A,F,H,I}_85x55mm_300dpi.pdf` (je 2 Seiten). Übersicht: NEUBAU_UEBERSICHT.png; Quell-HTML highend2.html; Seitengrafiken he2_*.png.

**Warum:** Erste Versuche "wie hingeschossen" (Sascha wütend, 2×) — Emoji-Icons, Times-Fallback, flache Flächen. Fix nach ~/.claude/skills/design-taste-frontend-v2-experimental (Anti-Slop: Emojis banned, kein Pure-Black #000, Em-Dash-Ban, max 1 Mittelpunkt/Zeile). Premium- Merkmale der Finalversion: Marcellus (Name) + Jost lokal via fontsource-CDN (fonts/), Feather-Line-Icons stroke 1.6, Film-Grain (SVG feTurbulence, mix-blend overlay .06), Gold-Foil-Verläufe (#F8C63D→#B87700), Duotone-Fotos (sepia .1), Editorial-Monogramm „K." per -webkit-text-stroke, Off-Black #12100C / Espresso #3E2A08 / Gold #F6B40C.

**How to apply (Pipeline, teuer gelernt):**
1. Design in highend2.html, Karten 500×318px. Extraktion der Seiten NUR zuverlässig über `<!--PAIR:X-->`-Marker im HTML + Index-Split auf `<div class="card`-Vorkommen (String-index/find auf h2-Blöcke scheiterte wiederholt).
2. Seiten-HTMLs MÜSSEN den kompletten `<style>`-Block aus dem Haupt-HTML erben — sonst Serif-Fallback + schwarze SVG-Icons (Judge-FAILs: Telefonnummer 3-zeilig umbrochen, „KÖRPERFLUSS" abgeschnitten).
3. Pro Seite PNG: `chrome --headless --force-device-scale-factor=2.008 --window-size=500,318 --screenshot` → 1004×639 = 300 dpi.
4. PDF: HTML mit 2 `<img>` + `@page{size:85mm 55mm;margin:0}` + `page-break-after:always` → `--print-to-pdf --no-pdf-header-footer`. NIEMALS HTML-Karten direkt printen (Seiten überlappen, Font-Fallback).
5. Abnahme: pdf:visual-judge-Subagent auf die PNGs (kontextbehalten per SendMessage re-checken), Fixes, Re-Check — erst dann PDF. Erster Durchlauf: 5× FAIL → nowrap auf alle Kontaktzeilen + Rand-Fixes → 8/8 PASS.
6. WebGL-Modell-Render (Glas-Kopf): GLB liegt `~/Desktop/Coworkspace_Ich/Körperfluss EDU/3d-UPGRADE-clone/public/LeePerrySmith.glb`; file://-CORS blockt Fetch → lokalen http.server (POST-Endpoint zum Canvas-Speichern), Kamera-Distanz aus Bounding-Box ableiten; headless WebGL = schwarz, MCP-Chrome (echte GPU) funktioniert.

Inhalt (final, nicht ändern ohne GO): Ganzheitlicher Therapeut · KEIN Diplom-Wording (Sascha explizit) · kein Website-Link · Tagline „Schmerzfrei bewegen · Stark bleiben" · nur +43 660 425 3366 + koerperfluss@gmail.com. Offen: 3-mm-Beschnittversionen auf Saschas Wort; altes „Split & Logo"-Design (Runde 1) NICHT in den FINALs.
