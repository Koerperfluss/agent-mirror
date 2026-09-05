---
app: zcode
quelle: "saschalagler/cli/memories/projects/atlas-cali-plan-50356199c59dc21f/memory/browser-umstieg-sigma.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: browser-umstieg-sigma
description: Umstieg von Perplexity Comet/Antigravity auf Sigma Browser +
  lokalem LLM (Sigma Eclipse) — App-Befunde, Gatekeeper-Verdacht, Error-Log noch
  ausstehend
metadata:
  node_type: memory
  type: project
  originSessionId: sess_247a3ecc-c1fb-4b27-9018-68eb0a9882b5
---

Sascha steigt von Perplexity Comet (Antigravity-Browser) auf Sigma Browser um (Stand 26.08.2026). Grund: Server-Updates haben Gravity Bar, Skills und Extensions zerschlagen, die KI ist aus seiner Sicht unbrauchbar. Ziel: Perplexity-ähnlicher Recherche-Workflow, aber lokal/offline/privat. Er recherchiert sowas mit seinem eigenen Gemini-Gem „ALLROUNDER OMNI UPDATE".

App-Befunde (26.08.2026, per Info.plist-Direktzugriff):
- `/Applications/Sigma.app`: regulärer Chromium-Fork v149.0.7827.116 (`com.sigmabrowser.sigmabrowser`), Update-Feed `releases.sigmabrowser.com` — sauber.
- `/Applications/Sigma Eclipse LLM.app` v0.1.34 (`com.sigma-eclipse.llm`): kaputte ATS-Exception (leerer Domain-Key in `NSExceptionDomains`) + veraltetes `LSRequiresCarbon`-Flag — schlampige Tauri-artige Verpackung; Provenienz nicht verifizierbar. Vorsicht bei `xattr`-Quarantäne-Remove — nur wenn Herkunft vertrauenswürdig.

Geklärt (26.08., 2. Session): Screenshot zeigte kein Terminal-Log, sondern die App-eigene Fehlerseite „SYSTEM-FEHLER – Die App ist auf ein unerwartetes Problem gestoßen. Bitte lade die Seite neu." + „NEU LADEN". Explorer-Diagnose per Read (Shell kaputt: spawn /bin/zsh ENOENT): Tauri-App (WKWebView, Binary 15,6 MB, kein Electron), Backend = eigener llama.cpp-Server. `~/Library/Application Support/com.sigma-eclipse.llm/settings.json`: active_model „model", port 10345, ctx_size 12000, gpu_layers 41. Root Cause: `models/model/` enthält NUR nie entpacktes `model.zip`, kein .gguf → Backend-Bootstrap schlägt fehl, Frontend-Error-Boundary zeigt Fehlerseite (Reload bringt nichts, Zustand persistiert). Gatekeeper ausgeschlossen (Prozess läuft, WKWebView-Profil existiert, keine Crash-Reports). Fix übergeben: model.zip entpacken bzw. Modell-Ordner + settings.json-Reset; plist-ATS-Leerkey bleibt Qualitätsmanko, aber nicht ursächlich (Loopback ist ATS-exempt). Nachtrag Session 2: Bash bleibt auch mit dangerouslyDisableSandbox kaputt (spawn /bin/zsh ENOENT, harness-seitig); CUA-Computer-Use-Tools waren trotz Skill-Load nicht in der Session verfügbar. Fix als fertiges Skript auf Desktop abgelegt: `~/Desktop/Sigma-Eclipse-Fix.sh` (bestätigt Fehlerstring im Binary, entpackt model.zip, GGUF-Magic-Check auf models/model.bin, Plan-B-Reset mit Desktop-Backup, RAM-Sanity für gpu_layers/ctx_size, Health-Check Port 10345). Nutzer führt es per Einzeiler aus; warte auf Ausgabe (PASS/FAIL). Verwandt: [[task-scope-clarify-first]], [[user-adhd-preferences]].
