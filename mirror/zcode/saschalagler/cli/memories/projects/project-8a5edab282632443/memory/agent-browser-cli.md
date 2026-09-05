---
name: agent-browser-cli
description: agent-browser-CLI (/opt/homebrew/bin/agent-browser) —
  Browser-Automation via CDP-Attach an Chrome 9223; eval nimmt EXPRESSIONS
  (keine Funktionen); Alternative wenn chrome-devtools-MCP-Seite weg ist
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

**agent-browser-CLI** (`/opt/homebrew/bin/agent-browser`, homebrew) — Browser-Verifikation ohne chrome-devtools-MCP:

- **Attach, nicht launch:** Chrome mit CDP starten: `open -na "Google Chrome" --args --remote-debugging-port=9223 --user-data-dir=/tmp/od-agent-browser-chrome --no-first-run --no-default-browser-check`, dann Poll `curl -fsS http://127.0.0.1:9223/json/version` bis `webSocketDebuggerUrl`, dann `agent-browser connect http://127.0.0.1:9223`. Erst NACH connect `agent-browser open <url>`.
- **`eval` nimmt JS-EXPRESSIONS, keine Funktionen:** `agent-browser eval "(document.body.innerText.match(/\d\/8/)||[])[0]"` ✓ — `agent-browser eval "() => {...}"` gibt nur `{}` zurück (Funktion wird serialisiert statt aufgerufen). Mehrzeilige Abläufe: IIFE `(() => { … return x; })()` als Expression.
- **Nützliche Befehle:** `snapshot` (Accessibility-Tree mit refs), `screenshot /pfad.png`, `get url` / `get title`, `--help` zeigt Befehle. Viewport-Resize-Subcommand existiert NICHT unter diesem Namen („Unknown command: viewport" trotz help-Erwähnung).
- **innerText reflektiert CSS `text-transform`:** Chrome liefert innerText in CAPS, wenn das Element `uppercase` hat — Feature-Checks also case-insensitive (`innerText.toLowerCase().includes(...)`) statt exaktem Case-Matching, sonst false negatives.
- **Nach Deploy ZWEIMAL laden:** auch nach SW-Reset installiert der neue SW beim ersten Load nur im Hintergrund; der erste Reload zeigt oft noch das alte Bundle (Asset-Hash-Check!), der zweite (oder `?v=Date.now()`-Navigation) das neue. Never trust ein einziges Post-Deploy-Messergebnis.
- **Bewährt für:** Glass-Counts (`document.querySelectorAll('.glass-card').length`), Backdrop-Filter-Messung (`getComputedStyle(el).backdropFilter`), Onboarding-Clickthrough (Buttons per textContent-Regex, Klick + sleep-Loops in Bash), Asset-Hash-Check (`performance.getEntriesByType('resource')`).
- **Fremdseiten-Gefahr (wichtig):** agent-browser hängt an Saschas ECHTEM Chrome-Fenster — er kann während deiner Tests selbst navigieren. Passierte: Atlas-Checks liefen plötzlich auf „KLINISCHES REHA DOSSIER / _michael_lagler.html" (alle DOM-Checks false). **Gegenmaßnahme:** vor jeder Auswertung `location.href` + `document.body.innerText.slice(0,80)` sanity-checken; bei Fremdseite mit `location.href='https://<ziel>/?v='+Date.now()` zurücknavigieren.
- **Fallstricke im Umfeld:** chrome-devtools-MCP-Pages können verschwinden („No page found" → neue Seite öffnen); playwright ist im Browser-Use-node_repl NICHT installiert (Cannot find package); GCP-MCPs (google-cloud-storage, firestore) brauchen interaktives OAuth (`no_credentials`) — nicht für Ad-hoc-Checks nutzen.

**Why:** chrome-devtools-MCP ist fragil (Pages Close, Sessions wechseln); agent-browser funktioniert zuverlässig als Shell-Tool mit klaren Fehlern.

**How to apply:** Bei Live-App-Verifikation Atlas (und andere Web-Apps): CDP-Sequenz oben, dann eval-Expressions für DOM-Messungen + Screenshots als Beweise; immer erst SW/Cache-Reset (siehe [[atlas-standort-korrigiert]]) bevor „leakfrei/Glass" behauptet wird.
