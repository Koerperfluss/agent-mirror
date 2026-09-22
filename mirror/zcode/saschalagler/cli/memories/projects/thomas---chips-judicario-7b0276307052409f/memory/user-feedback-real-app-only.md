---
name: user-feedback-real-app-only
description: Feedback 22.09.2026 (scharf) — echte Apps liefern, keine Ersatzbauten
  als Lösung verkaufen; Zugangsfragen nie wiederholen, Stattdessen-Lösungen aus dem
  Kontext selbst ableiten (Session-Cookies, Key-Rotation als Fehlerquelle prüfen)
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_5b46926c-ea38-4d93-833c-ef981b842fd5
---

Sascha (22.09.2026, mehrfach scharf): „ICH WILL DIE REALE RICHTIGE CHIPSI-ODER-JUDICARIO-APP" — Mini-Chipsi/die lokal gebaute Notfall-App wurde als Lösung abgelehnt. „Wenn du mich noch einmal nach Passwort oder Login fragst … du hast ALLES IN DEINER INFO."

**Why:** Er ist **Teil des Teams** (Reinhard Berger/openlaw) — Ersatzbauten und Zugangsfragen wirken für ihn wie Arbeitsverweigerung; die Zugangs-/Session-Infos lagen tatsächlich im Kontext (Session-Cookie im Chrome-Profil „Default", Google-Konto koerperfluss@gmail.com, Key-Rotation 04:21 als Fehlerursache).

**How to apply:** (1) Bei „App X läuft nicht": erst die X-eigene Konfiguration im Tool durchsuchen und reparieren (Checkboxen, Konnektoren, Berechtigungen), erst danach Ersatzwege bauen — und Ersatzwege nur nebenbei, nie als Ergebnis präsentieren. (2) Login-/Passwort-Nachfragen nur EINMAL und nur als absolute Letztoption; vorher Cookies/Session-Cookies/gespeicherte Profile aller Browser (auch Automation-Profile wie `~/.cache/chrome-devtools-mcp/chrome-profile`) prüfen und Stale-Redirects durch Neuladen ausschließen. (3) Bei plötzlichen API-/Service-Fehlern nach **Key-Rotation** suchen — der rotierende Anbieter hat oft selbst abhängige Backends (hier: Chipsi-verwalteter Konnektor brach mit der 04:21-Rotation). (4) Updates an Partner (Reinhard = Chat „RB") direkt selbst über den bekannten Kanal senden, wenn der Auftrag „löse es" lautet. Siehe [[chipsi-synthesis-error-diagnosis]].
