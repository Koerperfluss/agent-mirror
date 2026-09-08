---
app: zcode
quelle: "saschalagler/workspace/default/.zcode/plans/plan-sess_ecb2e5e0-e1f7-46fb-a5b9-a997d5485c8e.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

NETZ-FIX: Hotspot/IPv6-Problematik konfigurieren (1006-Abbrüche)

MAC-SEITE (führe ich nach Freigabe aus):
1. DNS hart auf saubere Resolver setzen (fixt das kaputte www.z.ai-DNS und Aliyun-CDN-Auflösungschaos):
   networksetup -setdnsservers Wi-Fi 1.1.1.1 8.8.8.8
2. IPv6 auf der Wi-Fi-Schnittstelle AUS (CDN-Cache war AAAA-only — ohne v6 nutzt macOS IPv4 und umgeht das Problem):
   networksetup -setv6off Wi-Fi
3. Verifikation: dscacheutil -q host -a name www.z.ai (muss jetzt IPv4 + Antwort liefern) + curl-Check api.z.ai/api/anthropic (200 OK).
Hinweis: braucht dein Admin-Passwort (sudo) — falls die Sandbox es verweigert, bekommst du die 2 Befehle als Terminal-Block zum Pasten.

IPHONE-SEITE (2 Klicks, nur du kannst das am Gerät):
Einstellungen → Persönlicher Hotspot → „Maximale Kompatibilität" AN → Hotspot einmal aus/an.
(Zwingt den Hotspot in den IPv4-freundlicheren Modus — der bekannte Fix für abbrechende Langverbindungen/WebSockets über iPhone-Hotspot.)

DANACH (bekanntes Ritual):
ZCode ⌘Q-Neustart → im Atlas-Tab NEUE Session → Provider „OmniRoute Gateway (localhost:20128)" → Vollautomatik-Prompt einfügen. Die 9,7-GB-Rollout-Datei der alten Session komprimiere ich dabei ins Archiv (I/O-Blocker weg).