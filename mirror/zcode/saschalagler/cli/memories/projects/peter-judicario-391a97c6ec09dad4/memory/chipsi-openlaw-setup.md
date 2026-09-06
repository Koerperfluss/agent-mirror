---
name: chipsi-openlaw-setup
description: Chipsi ist Cloud-Webapp (chipsi.openlaw.cc) als
  Chrome-App-Shortcut; Judicario-Connector konfiguriert man in Chipsi mit
  MCP-URL+Key; Gmail=koerperfluss@gmail.com
metadata:
  node_type: memory
  type: project
  originSessionId: sess_419a8806-4350-4c0c-92da-4032328e499c
---

**Chipsi** (Rechts- & Steuer-Assistenz von openlaw) ist KEINE lokale App: `Chipsi.app` im Projektordner ist nur ein Chrome-App-Mode-Shortcut auf `https://chipsi.openlaw.cc/` (Login via Google). Ein "Netzwerkproblem — die Antwort konnte nicht erstellt werden" beim Antworten (Recherche→Synthese) kommt vom Connector-/Backend-Aufruf, nicht vom lokalen Netz. Mac-Seite 06.09.2026 verifiziert gesund: DNS/TLS ok, `/api/auth/methods` → 200, gateway.openlaw.cc erreichbar.

Judicario-Connector in Chipsi = MCP-URL (`https://gateway.openlaw.cc/mcp/at/`) + Zugriffsschlüssel — Vorlage mit gültigem Key: `Judicario_Sacha_Mac/tools/CHIPSI_SANDBOX_CONNECTOR.html`. Toter Key war die wahrscheinliche Fehlerursache → [[judicario-gateway-key-rotation]].

**Gmail des Nutzers: koerperfluss@gmail.com** (auch seine primäre Apple-ID → App-Store/TestFlight-Mails landen dort; verifiziert 06.09. via Chrome-History-Kopie, read-only). Zugriffshürden: google-workspace-MCP hat KEINEN Gmail-Scope (Permission denied), Gmail ist NICHT in Apple Mail eingerichtet (nur iCloud + IMAP startup@koerperfluss.at), AppleScript auf Chrome/Mail timed out (Fehler -1712, TCC-Automation-Freigabe fehlt/hängt), Comet-Browser-Debug-Port 9222 liefert keine DevTools-JSON. Funktionsweg: Browser-Tab auf accounts.google.com (Session im ZCode-IAB, liegt seit 06.09. mit TestFlight-Suche bereit) oder Nutzer liest selbst. TestFlight-Prüfung (Judicario/Chipsi-Invites) per 06.09. abends noch offen. openlaw-Support: George george@openlaw.cc, WhatsApp +43 676 3064897. SCREEN-Automation würde vieles lösen → [[zcode-computer-use-status]].
