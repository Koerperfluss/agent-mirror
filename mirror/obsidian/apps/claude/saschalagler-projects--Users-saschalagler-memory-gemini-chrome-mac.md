---
app: claude
quelle: "saschalagler/projects/-Users-saschalagler/memory/gemini-chrome-mac.md"
stand: 2026-09-05
tags: [spiegel, claude]
---

---
name: gemini-chrome-mac
description: "Gemini in Chrome + macOS-App auf Saschas M4 (Österreich) — was geht, was regional gesperrt ist, welche Flags Müll sind"
metadata: 
  node_type: memory
  type: project
  originSessionId: 9b268d1e-1156-449b-8c5b-e5a09a930b2a
  modified: 2026-07-21T03:45:19.416Z
---

Stand 2026-07-21, M4 Mac / macOS 26.6 / Chrome 150.0.7871.129.

**Kernwahrheit:** Gemini-Nano-KI-Features in Chrome funktionieren; das volle agentische Gemini-Seitenpanel ("Frag Gemini" / Glic) ist in Österreich **serverseitig gesperrt** (EU-Rollout offen, kein festes AT-Datum). Kein lokales Flag hebt das auf.

**Was funktioniert (verifiziert):**
- `chrome://settings/ai` → KI-Innovationen rendert: "Formuliere für mich" + "Skills in Chrome" (Gemini Nano, on-device).
- Flags in `enabled_labs_experiments` alle korrekt: `glic@1`, `glic-actor@1`, `optimization-guide-on-device-model@1`, `prompt/writer/rewriter-api-for-gemini-nano`.
- `is_glic_eligible: true` in Local State.
- Gemini macOS-App (`com.google.GeminiMacOS` v1.84.x) installiert, Accessibility + Screen Recording TCC erteilt → Screen-Sharing geht.

**Was NICHT geht:**
- "Frag Gemini"-Panel öffnet → "Gemini ist momentan nicht verfügbar" = Region/Konto-Gate.
- Gemini Spark (Mac-Automatisierung) = US-only Beta, Google AI Ultra — in AT nicht aktivierbar.

**Fabrizierter Müll (aus gefälschtem "Bericht", NICHT verwenden):** `#glic-gemini-enterprise-settings-override`, `#glic-guest-url-presets`, `#glic-disable-actor-safety-checks` = Test/Dev-Overrides, machen das Panel grau/kaputt. Wurden auf Default zurückgesetzt.

**Region-Hebel (best-effort, nicht persistent):** `variations_country` in `~/Library/Application Support/Google/Chrome/Local State` → Chrome schreibt beim Start `at` zurück; `us` hält nur mit aktivem US-VPN beim Neustart. Backup lag unter `Local State.bak-*`.

Siehe [[koerperfluss-app]] für andere Google-Projekte.
