---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/vorssaint-mac-tools-research.md"
stand: 2026-09-18
tags: [spiegel, zcode]
---

---
name: vorssaint-mac-tools-research
description: Gemini-Recherche 26.08.2026 — Vorssaint ersetzt Rectangle +
  Clipboard-Manager, NICHT eqMac/BetterDisplay/Monocle
metadata:
  node_type: memory
  type: project
  originSessionId: sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc
---

Sascha prüfte 26.08.2026 per Gemini Deep Research, ob **Vorssaint** (vorssaint.com, kostenlose Open-Source-Menüleisten-App für macOS, Module einzeln deaktivierbar) seine Einzel-Utilities ersetzen kann:

- ✅ Ersetzbar: **Rectangle** (Fenster-Snapping + Shortcuts), **Clipboard-Manager** (Historie, Textbausteine, OCR, Finder-⌘X)
- ❌ Bleibt nötig: **eqMac** (kein Audio-Equalizer, nur App-Volumen-Mixer + Output-Switcher), **BetterDisplay** (kein DDC/CI, keine virtuellen Displays, nur Zusatz-Helligkeit), **Monocle** (kein Auto-Tiling)
- Sonst geboten: System-Monitoring, Screenshots/Aufnahme, Keep-Awake, Scroll-Einstellungen, Cleanup-Tools

**18.09.2026 Fakten nachgereicht (Agent, aus CHANGELOG.md Zeilen-Nachweis + Info.plist + defaults read):** Vorssaint 3.3.5 hat **keine externe Automatisierungsschnittstelle** — kein CLI (nur Haupt-Binary), kein CFBundleURLTypes, keine Shortcuts/App-Intents; GUI-Fenster lehnt zusätzlich synthetische Mausklicks ab („declined left mouse down", Overlay-Layer) → von ZCode NICHT fernsteuerbar, nie wieder versuchen. Homebrew-Modul = reine GUI für brew install/uninstall/upgrade (Brew-Aktionen delegiert es an Terminal via AppleEvents), macht KEIN `brew cleanup`. Cleaner-Modul: App-Reste/Caches/Logs/alte iOS-Backups/Xcode-DeviceSupport → immer Papierkorb zur Selbstprüfung; interner Zeitplan (daily/weekly) + WhatsApp-Downloads-Organizer sind die einzige Automatik (bei Sascha aktiv, ~40 MB/Tag).
