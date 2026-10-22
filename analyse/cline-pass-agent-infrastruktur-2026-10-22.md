# ClinePass-Modelle + Remote-Setup für KI-Agenten und Thomas' MacBook

**Stand:** 22.10.2026  
**Frage:** Welches ClinePass-Modell ist für Fragen zur technischen Verwirklichung von KI-Agenten und Umgebungsstrukturen optimal – und wie komme ich von unterwegs an Thomas' MacBook, sehe seinem Codex-Agenten im Terminal zu, helfe remote und tausche Dateien aus (Mail, WhatsApp, Desktop)?

**Kontext, den ich berücksichtigt habe:**
- ClinePass ist das 9,99-$/Monat-Abo für **Open-Weight-Modelle**; Frontier-Modelle (Claude, GPT) laufen über den separaten Cline-Provider (Pay-as-you-go) oder BYOK.
- Thomas arbeitet auf einem MacBook mit **Codex CLI/Desktop**; du bist unterwegs (iPhone/iPad) und nicht im Firmennetz.
- In deinen Notizen (Stand 20.09.2026): Tailscale und cloudflared sind installiert, aber **gestoppt**; OmniRoute lauscht auf `*:20128`; lokal ist nur `qwen2.5-coder:1.5b` vorhanden (M4, 16 GB). Lokale Modelle scheiden für Architekturfragen also praktisch aus.

---

## 0. TL;DR – die Empfehlung in fünf Sätzen

1. **Für Architektur- und Agenten-Fragen in ClinePass: GLM-5.3 als „Architekt“** (Cline positioniert die GLM-5-Reihe für Architektur/Planung; GLM-5.2 ist dort explizit so beschrieben, GLM-5.3 ist der aktuelle Nachfolger), **DeepSeek V4 Pro als günstiger Zweitmeiner/Reviewer**, **Kimi K3 nur für lange Umsetzungsläufe**, **GLM-5.3 Flash als Scout** für Repo-Inventar und Zusammenfassungen.
2. **Wenn es wirklich teuer wird (Kundensystem, Sicherheit, Migration): einmal Claude Opus 4.8 oder GPT-5.6 Sol über Cline (usage-billing) dazunehmen** – ClinePass allein ist Open-Weight und damit preislich top, aber nicht immer die letzte Instanz bei nuancierten Systementscheidungen.
3. **Tailscale funktioniert für genau diesen Fall – ja.** Es ist die sauberste Netzschicht: Mac und iPhone im selben Tailnet, MagicDNS, kein Port-Forwarding, WireGuard-verschlüsselt. Wichtig: auf macOS die **Standalone-App** nehmen; die App-Store-Version kann kein SSH-Server sein, und Tailscale läuft nur in der Login-Session (nach Reboot/Logout erst wieder nach Login erreichbar).
4. **Codex im Terminal beobachten – drei Stufen:** (a) Codex in **tmux** starten und per SSH **read-only** attachen (`tmux attach -r`), (b) **Happy** auf dem iPhone (E2E, zeigt Transcript, Approvals, Diffs; kostenlos/MIT), (c) **Cline Kanban** auf Thomas' Mac (läuft auch mit Codex) über Tailscale im Browser – das ist das beste „Dashboard“ für mehrere Agents.
5. **GUI/Dateien:** Für Remote-Hilfe **macOS Screen Sharing über Tailscale** (`vnc://thomas-mac`, Port 5900) oder **RustDesk mit Direct IP** über die Tailnet-IP; Dateien geräteübergreifend per **Taildrop** (`tailscale file cp … thomas-mac:`), nicht per DragonDrop – das ist nur ein lokales Drag-&-Drop-Regal.


## 1. Was ClinePass aktuell ist (Fakten, keine Vermutung)

| Punkt | Stand 22.10.2026 |
|---|---|
| Preis | **9,99 $/Monat** (Aktion; Standardrate 9,99 $), ggf. Processing-Fee |
| Inhalt | Kuratiertes Set **Open-Weight-Modelle** von Z.ai, Moonshot, DeepSeek, MiniMax, MiMo, Qwen |
| Quota | **5-Stunden-Rolling-Fenster + Woche + Monat**; Cline veröffentlicht keine absoluten Token-Zahlen, sondern „2–5× API-Rate“ |
| Nutzung | Provider `ClinePass` in IDE/CLI/Desktop; zusätzlich per **Cline-API-Key** außerhalb von Cline (OpenAI-kompatibel, `cline-pass/<modell>`) |
| Abgrenzung | **Cline (usage-billing)** = Pay-as-you-go mit 100+/300+ Modellen inkl. Claude/GPT; **BYOK** = eigene Keys (Anthropic, OpenAI, Gemini, OpenRouter …) |
| Wichtig | ClinePass ist **kein** Zugang zu Claude/GPT/Gemini. Die Modellpalette ist Open-Weight. |

### Aktuelle ClinePass-Modelle (Docs-Stand)

| Modell | Model-ID | Referenzpreis Input/Output pro 1M (Cache Read) | Positionierung |
|---|---|---:|---|
| GLM-5.3 | `cline-pass/glm-5.3` | 1,40 $ / 4,40 $ (0,26 $) | Long-Horizon-Coding, Reasoning |
| GLM-5.3 Flash | `cline-pass/glm-5.3-flash` | 0,15 $ / 0,50 $ (0,03 $) | effizientes agentisches Coding |
| Kimi K3 | `cline-pass/kimi-k3` | 3,00 $ / 15,00 $ (0,30 $) | Frontier-Agentic-Coding, lange Läufe |
| DeepSeek V4 Pro | `cline-pass/deepseek-v4-pro` | 1,32 $ / 3,96 $ Peak; 0,66 $ / 1,98 $ Off-Peak | große Änderungen, Dependency-Tracing |
| DeepSeek V4.1 Flash | `cline-pass/deepseek-v4.1-flash` | 0,30 $ / 1,20 $ | schnelle Iteration |
| MiMo-V2.5 | `cline-pass/mimo-v2.5` | 0,14 $ / 0,28 $ | effiziente, kleine Edits |
| MiMo-V2.5-Pro | `cline-pass/mimo-v2.5-pro` | 1,74 $ / 3,48 $ | sustained Multi-File-Arbeit |
| MiniMax M3 | `cline-pass/minimax-m3` | 0,30 $ / 1,20 $ | Generalist für Alltagscode |
| Muse Spark 1.3 Contributor | `cline-pass/muse-spark-1.3-contributor` | 0,10 $ / 0,20 $ | sehr günstige Routinearbeit |
| Qwen3.8 Max | `cline-pass/qwen3.8-max` | 2,00 $ / 6,00 $ (Cache Write 2,50 $) | komplexes Coding, schwere Lasten |
| Qwen3.7 Max | `cline-pass/qwen3.7-max` | 2,50 $ / 7,50 $ | große Repos, schwierige Multi-File-Änderungen |
| Qwen3.7 Plus | `cline-pass/qwen3.7-plus` | 0,40 $ / 1,60 $ (≤256K); 1,20 $ / 4,80 $ (>256K) | balanciert |

**Deprecated laut Docs:** GLM-5.2, Kimi K2.6, Kimi K2.7 Code, DeepSeek V4 Flash. Die Marketing-Seite nennt sie teilweise noch – im Model-Picker zählt die Docs-Liste.

**Kontextfenster:** Die aktuelle Generation liegt laut OpenRouter-Modellkatalog bei **~1 Mio. Token** (GLM 5.3: 1.048.576; Kimi K3: 1.048.576; DeepSeek V4 Pro: 1.048.576; Qwen3.8 Max: 1.000.000; MiMo V2.5 Pro: 1.050.000). Cline kann im Harness niedriger kappen – im Zweifel im Model-Picker nachsehen.

**Quota-Praxis:** Die 5-Stunden-Rolling-Grenze ist bei langen Architektur-Sessions der relevante Deckel, nicht der Monat. Kimi K3 ist mit 3 $/15 $ der teuerste ClinePass-Baustein; es zählt über die Referenzpreise gegen die Quota. Für „viel lesen, wenig schreiben“ ist GLM-5.3 Flash der günstigste Scout.

---

## 2. Modell-Analyse: Was für Agenten-Architektur wirklich zählt

### 2.1 Bewertungskriterien

Für Fragen wie „Wie baue ich die Kommunikation zwischen zwei Code-Agenten?“, „Tailscale oder Cloudflare Tunnel?“, „Wie überwache ich einen Codex-Agenten remote?“, „Wie strukturieren wir Übergaben und Approvals?“ zählt **nicht** primär SWE-Bench, sondern:

1. **Deliberate Reasoning / Thinking-Effort** – mehrere Optionen abwägen, Trade-offs, Gegenargumente.
2. **Langer Kontext** – Repo, Doku, Logs, Chat-Historie in einem Fenster.
3. **Agentic Tool Use** – Dateien lesen, Kommandos ausführen, Ergebnisse prüfen, nicht nur Text produzieren.
4. **Instruktions-Treue und Ehrlichkeit** – „ich weiß es nicht“ statt erfundener API-Details; besonders wichtig bei Tailscale-/macOS-Eigenheiten.
5. **Deutsch** – Fachbegriffe sauber, keine unnötigen Anglizismen.
6. **Kosten/Latenz** – Architektur ist ein Denk-, kein Tipp-Task; Latenz ist zweitrangig, Preis pro 1M ist relevant.

**Was „Technologie“ hier konkret bedeutet:** (1) **Reasoning-/Thinking-Modus** (explizites Abwägen statt schneller Antwort), (2) **~1M-Kontext plus Prompt-Caching** (Repo + Doku + Logs in einem Lauf), (3) **agentisches Tool-Use-Training** (Dateien lesen, Kommandos ausführen, Ergebnisse prüfen). Alle ClinePass-Modelle sind Open-Weight und werden von Cline gehostet; der Unterschied liegt in Familie, Post-Training und Serving – nicht in der API. Deshalb ist die **Rolle** (Scout/Architekt/Umsetzer/Prüfer) wichtiger als der Anbieter.


### 2.2 Rollen statt „ein Modell für alles“

Cline unterstützt genau das: Plan/Act, `--thinking`, `--config` pro Modell und Multi-Model-Consensus. Empfohlene Rollen:

| Rolle | Modell | Warum |
|---|---|---|
| **Scout** (Repo inventarisieren, Dateien zusammenfassen, Issues triagieren) | **GLM-5.3 Flash** | 0,15 $/0,50 $, 1M Kontext, schnell; Fehler kosten hier wenig |
| **Architekt** (Optionen, Trade-offs, Migrationsplan, Sicherheitsmodell) | **GLM-5.3** mit `--thinking high` | Cline beschreibt GLM-5.2 explizit für „architecture options before implementation“, „ambiguous request → ordered plan“, Multi-Modul-Debugging; GLM-5.3 führt die Reihe fort |
| **Zweitmeiner / Review** (Dependency-Tracing, große Branches, Gegenprüfung) | **DeepSeek V4 Pro** | 1M Kontext, 0,66–1,32 $/1M Input; Off-Peak halber Preis; Cline: „reviewing a large branch for behavioral regressions“ |
| **Umsetzer, kurze Distanz** (Multi-File-Refactor, Feature mit Tests) | **MiMo V2.5 Pro** oder **Qwen3.8 Max** | MiMo Pro: sustained Arbeit über Module; Qwen3.8 Max: schwere Repos/komplexes Coding |
| **Umsetzer, lange Distanz** (Feature end-to-end, viele Schritte) | **Kimi K3** | Cline: „long-horizon agentic coding“, „sustained reasoning across the repository“; teuer, daher gezielt |
| **Clerk** (Tests, Docs, kleine Fixes, Commit-Messages) | **Muse Spark 1.3**, **MiMo V2.5**, **DeepSeek V4.1 Flash** | 0,10–0,30 $/1M Input; für Routinearbeit völlig ausreichend |
| **Letzte Instanz** (High-Stakes-Architektur, Security-Review) | **Claude Opus 4.8** oder **GPT-5.6 Sol** (Cline usage-billing) | Stärkste Reasoning-/Instruktions-Treue; nicht in ClinePass enthalten |

### 2.3 Die konkrete Empfehlung für deine Frage

**Wenn du nur ClinePass nutzt:**

- **Default für Architekturfragen: GLM-5.3**, Plan-Mode, `--thinking high`. Cline beschreibt GLM-5.2 auf der Modellseite explizit für „architecture options“, „migration plan“ und „ambiguous → ordered plan“; GLM-5.3 ist der aktuelle Nachfolger derselben Reihe. Preislich im Mittelfeld, 1M Kontext, gute Deutsch-Leistung.
- **Zweitmeinung: DeepSeek V4 Pro** mit derselben Frage, aber anderem Prompt („widerlege den Plan, suche Fehlerquellen“). Zwei unabhängige Pläne sind bei Agenten-Architektur mehr wert als ein „perfekter“.
- **Umsetzung: MiMo V2.5 Pro** für normale Multi-File-Arbeit, **Kimi K3** nur, wenn der Lauf wirklich lang und verzahnt ist (end-to-end Feature, mehrere Services).
- **Scout/Triage: GLM-5.3 Flash.** Erst damit das Repo und die Doku einlesen, dann die teuren Modelle nur mit der verdichteten Frage füttern. Das senkt die Quota-Last deutlich.

**Wenn du Cline (usage-billing) oder eigene Keys hast:**

- **Eine Runde Claude Opus 4.8** (5 $/25 $ pro 1M) oder **GPT-5.6 Sol** (4 $/20 $) für die Entscheidung, die du nicht falsch treffen willst („Soll Thomas' Codex in tmux laufen oder in Kanban?“, „Wie sichern wir den Remote-Zugriff ab?“). Danach die Umsetzung wieder mit ClinePass.
- **Claude Fable 5** (10 $/50 $) nur für sehr lange, verzahnte Läufe oder wenn Opus an Grenzen stößt. Teuer und langsamer; nicht als Default.

**Faustregel:** Architektur = GLM-5.3 + DeepSeek V4 Pro als Paar. Umsetzung = MiMo V2.5 Pro / Qwen3.8 Max. Lange Läufe = Kimi K3. High-Stakes = einmal Opus 4.8 / GPT-5.6 Sol. Scout = GLM-5.3 Flash.

### 2.4 Cline-Workflow, der dazu passt

```bash
# 1) Scout: Repo und Doku einlesen, Frage verdichten
cline --config ~/.cline-glm-flash --json \
  "Lies README, docs/ und die Agenten-Konfiguration. Fasse in 20 Zeilen zusammen, \
   welche Remote-/Agenten-Strukturen es gibt und wo die offenen Fragen liegen."

# 2) Architekt: Optionen + Trade-offs, noch kein Code
cline --config ~/.cline-glm53 --thinking high \
  "Entwirf drei Varianten für Remote-Zugriff auf Thomas' MacBook: \
   (a) Tailscale + SSH/tmux, (b) Tailscale + Kanban, (c) Cloud-Agent über GitHub. \
   Vergleiche Sicherheit, Aufwand, Ausfallverhalten, Kosten. Empfehle eine."

# 3) Zweitmeiner: Plan widerlegen
cline --config ~/.cline-deepseek-v4-pro --thinking high \
  "Prüfe den folgenden Plan auf Sicherheitslücken, Single Points of Failure \
   und Annahmen, die bei macOS/Reboot/Sleep falsch sein könnten."

# 4) Umsetzer: erst nach Freigabe
cline --config ~/.cline-mimo-pro --auto-approve true \
  "Setze Variante A um. Akzeptanzkriterien: ..."
```

`--config` zeigt auf ein eigenes Config-Verzeichnis pro Modell (Cline-Doku „Model Orchestration“). `--thinking high` ist genau für Architektur, Security und Multi-Step-Planung gedacht.

### 2.5 Ehrliche Grenzen dieser Empfehlung

- Cline veröffentlicht **keine Benchmarks** pro Modell, nur Positionierungen („best for“, „limitations“). Die Empfehlung ist daher **positionierungsbasiert**, nicht gemessen.
- Open-Weight-Modelle sind bei Code oft nahe an Frontier, bei **nuancierten Systementscheidungen** und **mehrdeutigen Anforderungen** aber häufiger daneben. Deshalb der Zweitmeiner und die Frontier-Eskalation.
- Die 5-Stunden-Quota kann mitten in einer langen Session greifen. Kimi K3 (3 $/15 $) ist der größte Verbraucher; für reines Lesen ist es Geldverschwendung.

### 2.6 Testbatterie (5 Prompts, die du einmal gegen die Modelle fährst)

1. „Entwirf eine Agenten-Kommunikation zwischen zwei Firmen-Standorten: GitHub-PR, geteiltes Kanban, Chat-Bridge, MCP. Vergleiche Ausfallsicherheit und Auditierbarkeit.“
2. „Thomas' MacBook soll nach einem Reboot ohne lokalen Login remote erreichbar sein. Welche macOS-/Tailscale-/FileVault-Abhängigkeiten brechen, und was ist die ehrliche Antwort?“
3. „Codex CLI läuft in tmux. Ich will vom iPhone nur lesen, nichts auslösen. Welche Befehle, welche Rechte, welche Risiken?“
4. „WhatsApp-Desktop und Apple Mail auf einem remote gesteuerten Mac: Was geht bei Drag & Drop über VNC, was nicht, und welche Alternative für Dateien?“
5. „Wir wollen ClinePass-Modelle für Architektur und Frontier-Modelle für Abnahme kombinieren. Entwirf einen Kosten-/Quota-Plan für 20 Stunden pro Woche.“

Bewertung: Antwortedauer, Anzahl falscher APIs/Flags, Qualität der Gegenargumente, deutsche Lesbarkeit, ob das Modell „ich bin unsicher“ sagt.

---

## 3. Die Fernzugriffs-Architektur: drei Ebenen, nicht ein Tool

Zerlege das Problem in drei Ebenen. Fast alle Enttäuschungen entstehen, weil Leute eine Ebene mit einer anderen verwechseln.

```text
+-------------------------------------------------------------+
| 3  Zusammenarbeit / Kommunikation                           |
|    GitHub-PR, Kanban, Chat-Bridge (WhatsApp/Telegram),      |
|    sshx/tmate, MCP/A2A                                      |
+-------------------------------------------------------------+
| 2  Agenten-Sichtbarkeit / Steuerung                         |
|    tmux + SSH (read-only), Happy, Codex Remote Control,     |
|    Cline Kanban, Termdeck, ttyd                             |
+-------------------------------------------------------------+
| 1  Netz / Identität / Zugriff                               |
|    Tailscale (WireGuard, MagicDNS, ACL), SSH-Keys,          |
|    macOS Remote Login / Screen Sharing (5900)               |
+-------------------------------------------------------------+
```

**Merksatz:** Tailscale liefert nur die *Route*. Es aktiviert kein Screen Sharing, keinen SSH-Server und keinen Agenten. Diese Dienste müssen auf dem Mac eingeschaltet sein – und genau daran scheitern die meisten „Tailscale geht nicht“-Fälle.

## 4. Tailscale: funktioniert das für Thomas' MacBook? Ja – mit fünf Einschränkungen

### 4.1 Was Tailscale leistet

- **WireGuard-Mesh** zwischen Mac, iPhone, iPad, Servern; NAT-Traversal ohne Port-Forwarding; DERP-Relay als Fallback, wenn keine direkte Verbindung möglich ist.
- **MagicDNS**: `thomas-mac` oder `thomas-mac.tailXXXX.ts.net` statt IP.
- **ACLs/Grants**: du kannst exakt erlauben, wer Port 22, 5900 oder 3484 erreichen darf.
- **Taildrop**: Dateien zwischen Geräten, Ende-zu-Ende über die Tailnet-Verbindung; auf macOS landen sie in `~/Downloads`.
- **Tailscale Serve** (nur im Tailnet) für lokale Webdienste; **Funnel** (öffentlich) nur mit der Open-Source-`tailscaled`-Variante.
- **Free/Personal-Plan**: bis zu 6 Nutzer, unbegrenzte eigene Geräte, 3 ACL-Gruppen, 50 getaggte Ressourcen – für euch mehr als genug.
- **Robustheit:** Blockt ein Firmennetz UDP, fällt Tailscale auf **DERP-Relays** zurück – langsamer, aber funktional. Ein grundsätzliches VPN-Verbot im Firmennetz ist dagegen eine organisatorische Hürde, keine technische.


### 4.2 Die macOS-Falle: drei Varianten

| Variante | GUI | SSH-Server | Taildrop | Funnel/Serve | Empfehlung |
|---|---|---|---|---|---|
| **Standalone** (System Extension) | ja | **nein** | ja | Serve eingeschränkt, Funnel nein | **Nimm diese.** |
| Mac App Store (Network Extension) | ja | nein | ja | nein | Nur wenn MDM/App Store zwingend |
| Open Source `tailscaled` (CLI) | nein | **ja** | unvollständig | ja | Nur für unbeaufsichtigte Server |

Für deinen Fall heißt das: **Standalone-App auf Thomas' Mac**, und für SSH den ganz normalen macOS-**Remote Login** (Port 22) über die Tailnet-IP nutzen. Tailscale SSH als Server brauchst du nicht – und er würde mit der Standalone-App auch nicht funktionieren.

### 4.3 Fünf Einschränkungen, die du kennen musst

1. **Login-Session:** Die macOS-App läuft im Benutzer-Login. Nach Reboot/Logout ist der Mac erst wieder erreichbar, wenn sich jemand lokal anmeldet und Tailscale startet. „Unattended mode“ wie unter Windows gibt es in den Mac-Apps nicht.
2. **Sleep:** Ein schlafender Mac ist nicht erreichbar. `caffeinate`, „Amphetamine“ oder Energiespar-Einstellungen; zugeklappt braucht es Netzteil + externen Monitor (Clamshell).
3. **FileVault:** Nach einem Reboot steht der Mac am Pre-Boot-Login; per VNC kommt man dort nicht hinein. Für geplante Reboots `sudo fdesetup authrestart` nutzen – oder lokal anwesend sein.
4. **Key-Expiry:** Für den Mac in der Admin-Konsole **Key Expiry deaktivieren**, sonst fällt er nach der Standardfrist aus dem Tailnet.
5. **VNC ist unverschlüsselt:** Screen Sharing (Port 5900) verschlüsselt den Bildinhalt nach dem Login nicht selbst. Deshalb **nur über Tailscale** erreichen, niemals 5900 ins Internet forwarden.

## 5. Sehen und steuern, was der Codex-Agent im Terminal macht

### 5.1 Stufe 1 – tmux + SSH (nativ, kostenlos, die beste Basis)

Das Prinzip: Codex läuft **in einer tmux-Session** auf Thomas' Mac. SSH trennt nur die Verbindung, nicht den Agenten. Du kannst von überall attachen – auch **read-only**, wenn du nur zusehen willst.

**Auf Thomas' Mac (einmal):**

```bash
brew install tmux
# Codex dauerhaft in einer Session starten:
tmux new-session -d -s codex -c ~/projekte 'codex'
# oder interaktiv: tmux new -s codex  → dann codex starten
```

**Auf deinem Mac/iPhone (SSH-Client):**

```bash
ssh thomas-mac

# nur zusehen (keine Eingaben möglich):
tmux attach -r -t codex

# steuern/approven:
tmux attach -t codex

# Session verlassen, Agent läuft weiter: Ctrl-b, dann d
```

**Für wacklige Mobilfunkverbindungen: mosh.** Es überlebt IP-Wechsel und Verbindungsabbrüche:

```bash
brew install mosh
mosh thomas-mac -- tmux new -A -s codex
```

`tmux new -A -s codex` attached eine bestehende Session oder erstellt sie. Das ist der robusteste „ich will einfach nur sehen, was läuft“-Pfad.

**Wichtig:** Wenn Codex bereits **außerhalb** von tmux gestartet wurde, kannst du nicht nachträglich attachen. Dann bleiben nur die Codex-Logs (5.7) oder ein Neustart in tmux.

### 5.2 Stufe 2 – Happy (die beste iPhone-Erfahrung)

[Happy](https://happy.engineering/mobile-app/) ist ein Open-Source-Harness (MIT), das **Claude Code, Codex und Grok** auf deinem Rechner von einer iPhone-/Android-App aus steuert:

- QR-Code-Pairing zwischen Happy Desktop/CLI auf dem Mac und dem Telefon.
- **Ende-zu-Ende-verschlüsselt**: der Relay sieht nur Ciphertext, keine Inhalte.
- Du kannst Nachrichten (auch Bilder) senden, **Permission-Requests beantworten**, den Turn stoppen, Modell/Effort wechseln, Dateien und den Git-Diff lesen, eine Session in einem Verzeichnis starten.
- Der Agent läuft weiter auf dem Mac; kein offener Port, kein VPN nötig (läuft aber natürlich auch über Tailscale).

**Für deinen Fall:** Das ist die niedrigste Einstiegshürde für „Ich sitze im Zug und will sehen, was Codex macht, und ggf. eine Freigabe geben.“ Thomas installiert Happy Desktop, du scannst den QR-Code – fertig.

### 5.3 Stufe 3 – Cline Kanban als Dashboard (auch für Codex)

Cline Kanban ist ein Browser-Board, das **mehrere CLI-Agenten parallel** in isolierten Git-Worktrees startet:

```bash
cd ~/projekte/repo
npx kanban
# für Zugriff aus dem Tailnet:
KANBAN_RUNTIME_HOST=0.0.0.0 npx kanban
# iPhone: http://thomas-mac.tailXXXX.ts.net:3484
```

- Unterstützt laut Doku **Cline CLI, Claude Code, Codex, OpenCode** (Engine in den Settings wählen).
- Jede Karte: eigener Worktree + Terminal, Status, letzte Agent-Ausgabe, Diff-Ansicht, Inline-Kommentare, Commit/PR.
- **Tailscale ist in der Cline-Doku ausdrücklich die empfohlene Remote-Variante** für Kanban.
- Warnung der Doku: Kanban gibt vollen Zugriff auf Repo und Terminal. Also nur im vertrauenswürdigen Tailnet, ACL restriktiv, nicht ins offene Internet.

**Das ist die Antwort auf „gibt es Alternativen, wie ich zumindest sehen kann, was sein Codex-Agent macht?“** – ja: Kanban zeigt dir alle Tasks als Board, inklusive Live-Output und Diffs, im Browser auf dem iPhone. Es ist mehr „Projekt-Cockpit“ als „Terminal-Spiegel“, aber genau das ist oft nützlicher.

### 5.4 Codex' eigene Remote-Funktionen (offiziell, aber mit Account-Bindung)

OpenAI hat Codex 2026 über mehrere Oberflächen zusammengeführt (CLI, Desktop-App, IDE, Cloud). Zwei Funktionen sind für dich relevant:

1. **Remote Control über die ChatGPT-App (iOS/Android):** In der Codex-Desktop-App auf dem Mac „Allow other devices to connect“ aktivieren, QR-Code scannen, ist das Telefon bereits ein zweites Fenster für Codex. Voraussetzung: **gleicher ChatGPT-Account und Workspace** auf beiden Geräten, Host wach und online, Admin hat Remote Control freigegeben. Für Thomas' eigenen Account kommst du damit also nur rein, wenn ihr denselben Workspace nutzt.
2. **SSH-Remote-Hosts in der Codex-Desktop-App:** Codex kann einen entfernten Rechner per SSH als Umgebung nutzen (Settings → Connections → SSH-Host, `codex` muss im PATH der Remote-Login-Shell liegen). Die Doku empfiehlt dafür ausdrücklich **VPN/Mesh statt offenem Internet** – also Tailscale. Damit könntest du von deinem Mac aus in Thomas' Mac „hineinarbeiten“, wenn der Account passt.

### 5.5 Termdeck (kommerziell, aber sehr passend für Codex CLI)

[Termdeck](https://termdeck.io/) ist eine Browser-/Phone-Konsole für **Codex CLI, Claude Code und Grok**:

- Ein kleiner Agent auf dem Mac dialt out, kein offener Port, kein Tunnel.
- Live-Transcript, Tool-Calls, Command-Output, **Approve/Deny per Push-Benachrichtigung**, Diff-Ansicht, Modell-/Effort-Wechsel, Stop, Follow-up mitten im Turn.
- Rendert aus Codex' eigenen Rollout-Dateien; `codex resume` übernimmt danach denselben Thread.
- Mehrere Maschinen in einem Board; kostenpflichtig (Free Trial).

Für „ich will Codex CLI von unterwegs bedienen, ohne tmux zu lernen“ ist das die komfortabelste kommerzielle Lösung – Happy ist die kostenlose Open-Source-Alternative.

### 5.6 Web-Terminal und Live-Sharing

**ttyd** (Web-Terminal im Tailnet):

```bash
brew install ttyd
ttyd -R -p 7681 tmux attach -t codex
# -R = read-only; bindet standardmäßig alle Interfaces → nur mit Tailscale-ACL/Firewall
```

**sshx** (kollaboratives Web-Terminal, E2E, gut zum gemeinsamen Debuggen mit Thomas):

```bash
brew install sshx
sshx
# gibt eine https://sshx.io/s/...-URL aus; im Browser öffnen, Cursor sind live sichtbar
```

**tmate** (schnelles Session-Sharing über öffentlichen Relay):

```bash
brew install tmate
tmate
# ssh- und web-URL teilen; Agent läuft weiter, auch wenn du dich trennst
```

`tmate` ist praktisch für „Thomas, schau mal mit“, aber der Relay ist ein Dritter – nicht für Kundendaten. `sshx` ist ebenfalls Relay-basiert, aber Ende-zu-Ende-verschlüsselt; Self-Hosting ist laut Projekt nicht supported.

### 5.7 Nur lesen: Codex-Logs, `/status`, `/ps`, `codex resume`

Codex persistiert jede Session als **JSONL-Rollout** unter `~/.codex/sessions/YYYY/MM/DD/*.jsonl.zst` plus `state_5.sqlite` für Metadaten. Im Terminal:

```text
/status   → aktives Modell, Approval-Policy, Session-ID, Kontextstand
/ps       → laufende Background-Terminals + letzte Ausgabezeilen
/title    → Titel für parallele Sessions
```

```bash
codex resume            # letzte Session im Terminal fortsetzen
codex fork --last       # abzweigen und Alternative testen
codex exec --json ...   # headless, maschinenlesbar
```

Für „ich will nur sehen“ ist `tmux attach -r` besser als Logs lesen; die JSONL-Dateien sind komprimiert und für Live-Beobachtung nicht ideal, aber gut für Forensik und Audits.

**Wenn Codex schon außerhalb von tmux läuft:** Du kannst nicht nachträglich attachen. Dann bleiben `ps -axo pid,etime,command | grep -i codex` und `lsof -p <pid>` für den Prozessüberblick, die Rollout-Datei für die Nachvollziehbarkeit – und die Entscheidung, den nächsten Lauf in tmux zu starten.

### 5.8 Vergleich der Optionen

| Lösung | Was du siehst | Steuern | Voraussetzung auf dem Mac | iPhone | Kosten | Sicherheit |
|---|---|---|---|---|---|---|
| **tmux + SSH** | exakt das Terminal | ja, oder read-only | Remote Login, tmux, SSH-Key | SSH-App (Blink/Termius) | 0 | sehr hoch (Tailscale + Key) |
| **Happy** | Transcript, Diffs, Permissions | ja | Happy Desktop/CLI | native App | 0 (MIT) | sehr hoch (E2E) |
| **Cline Kanban** | Tasks, Output, Diffs | ja (Board) | Node, `npx kanban`, Codex-Engine | Browser | 0 | hoch (Tailnet, aber voller Repo-Zugriff) |
| **Codex Remote Control** | Codex-Threads | ja | Codex Desktop, gleicher Account | ChatGPT-App | im Abo | hoch (OpenAI-Konto) |
| **Termdeck** | Transcript, Approvals, Diffs | ja | Termdeck-Agent | App/Browser | kommerziell | hoch (dial-out) |
| **sshx** | Live-Terminal, kollaborativ | ja | `sshx` | Browser | 0 | hoch (E2E, Relay) |
| **tmate** | Live-Terminal | ja | `tmate` | Browser/SSH | 0 | mittel (öffentlicher Relay) |
| **ttyd** | Live-Terminal | ja/read-only | `ttyd` | Browser | 0 | mittel (Bind/ACL beachten) |

**Wenn Thomas nichts installieren will:** (a) **Codex Remote Control**, falls ihr denselben ChatGPT-Workspace habt; (b) **Remote Login** einschalten (nur eine Systemeinstellung, kein Extra-Tool) und per SSH `tmux attach -r`, falls Codex in tmux läuft; (c) **Codex Cloud/PRs**, falls er ohnehin über GitHub arbeitet. Ohne eine dieser Voraussetzungen gibt es keinen sauberen Weg, nur zuzusehen – und heimliche Fernüberwachung ist keine Option.

## 6. Mac-GUI, Remote-Hilfe und Drag & Drop (Mail, WhatsApp, Desktop)

### 6.1 macOS Screen Sharing über Tailscale (der Standardweg)

**Auf Thomas' Mac aktivieren:**

1. `Systemeinstellungen → Allgemein → Freigaben → Bildschirmfreigabe` einschalten, „Nur diese Benutzer“ wählen.
2. `Remote Login` einschalten (für SSH/tmux sowieso nötig).
3. In der Tailscale-App den Mac verbinden; Hostname notieren (`thomas-mac` bzw. `thomas-mac.tailXXXX.ts.net`).
4. Optional: „VNC-Viewer dürfen mit Passwort steuern“ nur setzen, wenn ein Nicht-Apple-VNC-Client (z. B. Screens, Jump Desktop) zugreifen soll – RustDesk nutzt ein eigenes Protokoll.

**Von deinem Mac:**

```bash
open vnc://thomas-mac
# oder mit Tailnet-IP:
open vnc://100.x.y.z
```

**Vom iPhone:** Jump Desktop, Screens oder Remoted installieren, Tailnet-IP/MagicDNS und Port **5900** eintragen, mit dem **macOS-Benutzerkonto** von Thomas anmelden (nicht mit Tailscale).

**Wichtig:**
- Der Mac muss wach und eingeloggt sein; nach einem Reboot ist die Tailscale-App erst nach lokalem Login wieder da.
- VNC überträgt Bilder; über Mobilfunk ist das je nach Verbindung zäh. Für „ich muss nur eine Einstellung umstellen“ reicht es; für stundenlanges Arbeiten ist SSH/Kanban besser.
- **Niemals Port 5900 ins Internet weiterleiten.** Nur Tailnet.

### 6.2 RustDesk über Tailscale (bessere Datei-/Clipboard-Integration)

RustDesk ist Open Source (AGPL), cross-platform, hat iOS/Android-Apps und kann **Direct IP** ohne öffentlichen Relay:

1. RustDesk auf beiden Seiten installieren.
2. In RustDesk `Sicherheit → Direct IP access` aktivieren, permanentes Passwort setzen.
3. In der Tailscale-Admin-Konsole die `100.x.y.z`-Adresse des Macs kopieren.
4. In RustDesk „Remote Desktop“ die Tailnet-IP eintragen, Passwort eingeben.

Vorteile gegenüber Apple Screen Sharing: **Dateiübertragung und Clipboard** sind eingebaut, funktioniert auch von Windows/Android, und du kannst bei Bedarf einen eigenen Relay betreiben. Nachteil: macOS verlangt **Screen Recording** und **Accessibility**-Freigaben; das ist einmalige Klickarbeit (oder per MDM/`tccutil` nicht trivial).

### 6.3 Weitere Optionen (Kurzvergleich)

| Tool | Plattform | Dateitransfer | Bemerkung |
|---|---|---|---|
| **Apple Screen Sharing** | Mac → Mac/iOS (VNC-Client) | nein (nur Clipboard) | kostenlos, kein Extra-Tool, VNC unverschlüsselt → Tailscale |
| **RustDesk** | alle | ja | self-hostbar, Direct IP über Tailnet, Permissions nötig |
| **Jump Desktop** | Mac/iOS/Windows | ja (Fluid/RDP/VNC) | sehr gute iPhone-Bedienung, kostenpflichtig |
| **Screens** | iOS | ja | VNC-Client, schlank |
| **AnyDesk/TeamViewer** | alle | ja | einfach, aber Dritt-Relay, oft von Firmen-ACLs blockiert |
| **Apple Remote Desktop** | nur Mac | ja | Admin-Funktionen, 79,99 $, für diesen Fall Overkill |
| **Messages-Bildschirmfreigabe** | Mac → Mac | nein | nur mit Zustimmung, kein iPhone-Weg |

### 6.4 Drag & Drop: was geht, was nicht

**Innerhalb der remote gesteuerten Sitzung** ist Drag & Drop ganz normal: Du steuerst den echten Mac, also kannst du in Apple Mail einen Anhang packen, auf den Schreibtisch ziehen, in WhatsApp Desktop fallen lassen oder in ein Terminal-Fenster ziehen (dort wird der Pfad eingefügt). Das ist der einfachste Weg für „Mail-Anhang nach WhatsApp“.

**Zwischen deinen Geräten und Thomas' Mac** funktioniert Drag & Drop **nicht** über VNC. Dafür brauchst du einen Dateikanal:

- **Taildrop** (Tailscale): `tailscale file cp ./rechnung.pdf thomas-mac:` – Ende-zu-Ende, auf macOS landet die Datei in `~/Downloads`. In der GUI: Rechtsklick → Teilen → Tailscale.
- **LocalSend** (Open Source, LAN): AirDrop-Alternative für Mac/iPhone/Windows/Android.
- **Syncthing**: kontinuierlicher Ordner-Sync, gut für ein gemeinsames `handoff/`-Verzeichnis.
- **iCloud Drive / Google Drive**: einfach, aber Cloud-Drittpartei.
- **Universal Clipboard / AirDrop**: nur in der Nähe und mit Apple-ID/Handoff – nicht, wenn du unterwegs bist.

**Zu „DragonDrop“:** Die Mac-Utility ist ein lokales Drag-&-Drop-Regal (ähnlich Dropover/Yoink). Sie hilft innerhalb des Macs, aber sie überträgt nichts zwischen Geräten. Für dein Szenario ist sie kein Remote-Werkzeug – Taildrop/LocalSend sind es.

### 6.5 Konkreter Ablauf „Mail-Anhang nach WhatsApp, während Thomas remote hilft“

1. Du verbindest dich per Screen Sharing oder RustDesk auf Thomas' Mac.
2. In Apple Mail den Anhang auf den Schreibtisch oder direkt in das WhatsApp-Desktop-Fenster ziehen.
3. Wenn der Anhang von **deinem** Gerät kommt: erst per Taildrop/LocalSend auf den Mac, dann im remote sichtbaren Finder in WhatsApp ziehen.
4. Terminal: Datei aus dem Finder ins Terminal ziehen fügt den Pfad ein – praktisch für `codex`-Prompts („analysiere diese Datei“).

## 7. Kommunikation mit Thomas' Code-Agenten

### 7.1 Der robusteste Kanal: das Repository

Agenten kommunizieren am zuverlässigsten über **Artefakte**, nicht über Chat:

- Thomas' Codex arbeitet auf einem Branch und öffnet einen **Pull Request**.
- Du reviewst auf dem iPhone (GitHub-App), kommentierst Zeilen, forderst Änderungen.
- Ein Kommentar mit `@codex` / `@cline` kann einen neuen Agenten-Lauf auslösen (Codex-GitHub-Integration bzw. Cline CLI in GitHub Actions).
- Vorteile: auditierbar, wiederaufsetzbar, kein „wer hat was gesagt“-Problem, funktioniert asynchron über Zeitzonen.

Das ist die beste Basis für „Thomas bzw. sein Agent soll etwas umsetzen, ich bin unterwegs“. Alles andere ist Komfort darüber.

**Cline-spezifische Ergänzungen, die dir Arbeit sparen:**
- **Cline Desktop kann Codex-Sessions importieren** und mit einem anderen Modell fortsetzen („Import Sessions“ → Codex/Claude Code). Du kannst also Thomas' Thread übernehmen und ihn mit GLM-5.3 weiterdenken, ohne ihm den Account wegzunehmen.
- **Cline Cloud Agents** laufen auf einem GitHub-Repo im Browser/iPhone: Task starten, Branch + PR abholen. Limits: 10 parallele Sessions, 50 neue pro Tag; Rules/Skills/MCP werden in Cloud-Sessions nicht geladen. Das ist der bequemste Weg, wenn Thomas ohnehin in GitHub pusht.
- **Cline Desktop Remote-SSH** (App bleibt bei dir, Agent läuft auf Thomas' Mac) ist die starke Variante für deinen Mac am Schreibtisch – nicht fürs iPhone. macOS-Host setzt Cline Desktop auf einem Mac voraus; der SSH-Host kann über Tailscale erreichbar sein.


### 7.2 Geteiltes Board: Cline Kanban

Kanban ist die visuelle Variante davon: Thomas' Mac läuft als Board-Host, du öffnest es über Tailscale im Browser. Karten sind Aufgaben, jede Karte hat einen Agenten + Worktree + Diff. Du kannst kommentieren, ohne im Terminal zu sein. Für mehrere parallele Agents ist das deutlich übersichtlicher als drei tmux-Fenster.

### 7.3 Chat-Bridge: WhatsApp, Telegram, Slack

Cline CLI hat **Connectors** (`cline connect`), die einen Chat-Kanal in eine Agenten-Session verwandeln:

```bash
cline connect            # Wizard: Telegram, Slack, Discord, Google Chat, WhatsApp, Linear
cline connect telegram -k <BOT_TOKEN> --allowed-user-id <DEINE_ID>
```

- Jede eingehende Nachricht startet oder verlängert eine Session; Antworten gehen in den Chat zurück.
- **Sicherheit:** ohne `--allowed-user-id`/`--hook-command` kann jeder, der den Bot findet, Kommandos auf dem Mac ausführen. Immer einschränken.
- Gilt für **Cline CLI**, nicht für Codex. Für Codex gibt es Slack-Dispatch über Codex Cloud; Happy kann Bots nach Telegram exportieren.
- **WhatsApp** ist der aufwendigste Connector: er braucht eine Meta-WhatsApp-Business-Cloud-API-Nummer (Phone Number ID, Access Token, App Secret, Verify Token, öffentliche Base-URL). **Telegram** ist der schnellste Einstieg, Slack der beste für Teams.

Für „ich will von WhatsApp aus schnell fragen, was der Agent macht“ ist Cline + WhatsApp-Connector der direkte Weg – aber nur, wenn der Agent auf Cline läuft. Für Codex nimm Happy/Kanban.

### 7.4 Live gemeinsam debuggen

- **sshx:** Thomas startet `sshx` in der tmux-Session, schickt dir die URL; du siehst sein Terminal live und kannst mitsteuern (E2E).
- **tmate:** gleiches Prinzip über öffentlichen Relay; schneller, weniger privat.
- **tmux shared session:** beide attachen dieselbe Session (`tmux attach -t codex`) – einfachste Variante, wenn ihr beide SSH-Zugang habt.
- **Sprachanruf parallel:** für Architekturfragen oft schneller als Tippen; Happy hat Voice-Input, Cline Desktop ebenfalls.

### 7.5 Agent-zu-Agent: MCP, A2A und „Handoff-Ordner“

Wenn du wirklich **Agenten miteinander** sprechen lassen willst:

- **MCP** ist der pragmatische Weg: ein Agent stellt Tools/Resources bereit, der andere konsumiert sie. Cline und Codex unterstützen MCP-Server.
- **A2A** (Agent2Agent) ist der standardisierte Overhead darüber; sinnvoll, wenn mehrere Teams/Produkte zusammenspielen, für zwei Personen aber oft zu viel.
- **Handoff-Ordner im Repo** ist die unterschätzte Lösung: `handoff/<datum>-<thema>.json` mit `from`, `to`, `status`, `question`, `artifacts`, `next_action`. Beide Agenten lesen/schreiben ihn, Git ist die Historie. Cline Kanban macht im Kern genau das (Tasks + Status + Verknüpfung).

**Wichtig:** Agenten sollten sich nicht gegenseitig ungeprüft Kommandos erteilen. Ein Mensch (du oder Thomas) bleibt der Approval-Punkt, mindestens für `git push`, Deploy, Löschen und alles mit Kundendaten.

### 7.6 Guardrails

- Auto-Approve/YOLO nur in isolierten Worktrees/Containern, nicht im Haupt-Repo.
- Keine Secrets in Prompts, Logs oder Screenshots (Taildrop ist E2E, aber der Agent kann Inhalte in Tokens schreiben).
- Codex/Claude-Sessions können lange Kontextlogs enthalten – bei Kundendaten DSGVO/AVV prüfen.
- Remote-Zugriff auf ein Firmen-MacBook: schriftlich festhalten, wer wann zugreifen darf; Tailscale-ACL ist die technische Durchsetzung.

## 8. Konkrete Einrichtung (Copy-Paste-Checkliste)

### 8.1 Auf Thomas' MacBook

```bash
# 1) Tailscale: Standalone-App installieren, mit demselben Tailnet anmelden.
#    Admin-Konsole → Machines → thomas-mac → Key Expiry: Disable

# 2) Remote Login + Screen Sharing
#    Systemeinstellungen → Allgemein → Freigaben
#      → Remote Login: on, nur Benutzer „thomas“
#      → Bildschirmfreigabe: on, nur „thomas“

# 3) SSH-Key von Sascha hinterlegen (auf Saschas Mac ausführen)
ssh-keygen -t ed25519 -C "sascha@remote"
ssh-copy-id thomas@thomas-mac
ssh thomas@thomas-mac 'echo OK && hostname'

# 4) tmux + Codex-Session
brew install tmux mosh
tmux new-session -d -s codex -c ~/projekte 'codex'

# 5) Am Strom wach halten (temporär, für Support-Sessions)
caffeinate -dimsu

# 6) Optional: Happy für iPhone-Steuerung
#    Happy Desktop von happy.engineering installieren, QR-Code für Sascha erzeugen

# 7) Optional: Kanban als Board für Codex-Tasks
cd ~/projekte/repo
KANBAN_RUNTIME_HOST=0.0.0.0 npx kanban
```

### 8.2 Auf deinem iPhone/iPad

```text
Tailscale-App:        einloggen, „thomas-mac“ muss grün sein
Blink Shell/Termius:  ssh thomas-mac  →  tmux attach -r -t codex
Happy:                QR scannen, Sessions lesen/approven
Browser:              http://thomas-mac.tailXXXX.ts.net:3484  (Kanban)
Jump/Remoted/RustDesk:100.x.y.z:5900 bzw. Direct IP (GUI)
```

### 8.3 Tailnet-ACL (Beispiel, restriktiv)

```json
{
  "tagOwners": {
    "tag:thomas-mac": ["autogroup:admin"]
  },
  "grants": [
    {
      "src": ["sascha@example.com"],
      "dst": ["tag:thomas-mac"],
      "ip": ["tcp:22", "tcp:5900", "tcp:3484"]
    }
  ]
}
```

- `grants` gilt für normales SSH/VNC/HTTP. Die `ssh`-Sektion wäre nur für **Tailscale SSH** relevant – die kann die macOS-Standalone-App nicht als Server.
- Für den Mac ggf. ein Tag in der Admin-Konsole zuweisen (oder per CLI `tailscale up --advertise-tags=tag:thomas-mac`).
- Testen: `tailscale ping thomas-mac`, dann `nc -vz thomas-mac 22`, `nc -vz thomas-mac 5900`, `curl -I http://thomas-mac:3484`.
- Wenn du keinen Zugriff mehr hast: ACL ist die Notbremse, nicht der SSH-Key.

### 8.4 SSH-Komfort auf deinem Mac

```sshconfig
Host thomas-mac
  HostName thomas-mac.tailXXXX.ts.net
  User thomas
  IdentityFile ~/.ssh/id_ed25519
  ServerAliveInterval 30
  ServerAliveCountMax 3
  # optional: ProxyJump, falls du über einen anderen Host gehst
```

Damit reicht `ssh thomas-mac`, `mosh thomas-mac`, `open vnc://thomas-mac`.

### 8.5 Abnahmetests

| Test | Erwartung |
|---|---|
| `tailscale ping thomas-mac` | direkte Verbindung oder DERP-Relay, nicht „timeout“ |
| `ssh thomas-mac 'tmux ls'` | `codex: 1 windows ...` |
| `tmux attach -r -t codex` | du siehst den Live-Output, kannst nichts kaputt machen |
| `open vnc://thomas-mac` | Login-Screen/Desktop erscheint |
| `tailscale file cp test.txt thomas-mac:` | Datei liegt in `~/Downloads` |
| `http://thomas-mac:3484` | Kanban-Board lädt |
| Mac schlafen lassen | Verbindung bricht ab – erwartet, dokumentiert |
| Mac neu starten | erst nach lokalem Login wieder erreichbar – erwartet, dokumentiert |
| Mobilfunk statt WLAN | Tailscale bleibt verbunden, tmux überlebt |

## 9. Sicherheit und Betrieb

### 9.1 Technische Mindestabsicherung

- **Tailscale-ACL statt „alle dürfen alles“**: nur dein Account darf auf `tag:thomas-mac` Port 22/5900/3484. Keine `*`-Regeln.
- **Key Expiry** für den Mac deaktivieren, für iPhone/iPad aktiv lassen; Geräteverlust = Key widerrufen.
- **MFA** im Tailscale-/Google-/GitHub-Account; Device Approval im Tailnet aktivieren.
- **SSH nur mit Keys**: `PasswordAuthentication no`, `AllowUsers thomas`, `PermitRootLogin no`; in `authorized_keys` optional `from="100.64.0.0/10"` (Tailscale-CGNAT-Range).
- **VNC nur im Tailnet**: Port 5900 nicht forwarden; „Only these users“; starkes Passwort, falls VNC-Passwort genutzt wird. VNC selbst ist unverschlüsselt – Tailscale liefert die Verschlüsselung.
- **Keine 0.0.0.0-Bindings ohne Not**: Kanban (`KANBAN_RUNTIME_HOST=0.0.0.0`) und OmniRoute (`*:20128` laut deinen Notizen) sind im LAN erreichbar. Besser an `127.0.0.1` oder die Tailnet-IP binden und per `tailscale serve` proxies; mindestens macOS-Firewall + ACL.
- **Auto-Approve/YOLO** nur in separaten Worktrees/Containern; Codex/Cline können sonst alles im Home-Verzeichnis ändern.
- **Prompt Injection** ist bei Agenten mit Shell-Zugriff real: keine ungeprüften Webseiten/Issues als „Anweisung“ ausführen lassen; Approval-Punkte behalten.
- **FileVault + Updates**: FileVault an, aber Remote-Reboot über `fdesetup authrestart` planen; Tailscale Auto-Update an.

### 9.2 Organisatorisch

- Schriftlich festhalten: Thomas erlaubt Sascha Remote-Zugriff auf `thomas-mac` für Support/Reviews; welche Daten gesehen werden dürfen; wie Zugriff entzogen wird (ACL + Key + Tailscale-Device entfernen).
- Getrennte Konten: wenn möglich einen zweiten macOS-Benutzer `sascha-support` anlegen, statt in Thomas' Session zu arbeiten. Screen Sharing kann pro Benutzer freigegeben werden.
- Audit: Codex-Rollouts + Cline-Sessions + Tailscale-Config-Audit sind die Spur. Für Flow-Logs bräuchte es Tailscale Premium; für euch reicht Config-Audit + Git-Historie.
- DSGVO: Prompts und Diffs können personenbezogene Daten enthalten. ClinePass/OpenAI/Anthropic verarbeiten sie in der Cloud; Taildrop schützt nur den Transport. Vor Kundendaten klären, welcher Provider zulässig ist.

## 10. Entscheidungsmatrix und empfohlener Stack

### 10.1 Ziel → Lösung

| Ziel | Beste Lösung | Warum | Aufwand |
|---|---|---|---|
| Nur sehen, was Codex tut | **tmux + SSH read-only** | exakt, kostenlos, keine Zusatzsoftware | 15 Min |
| Vom iPhone approven/steuern | **Happy** | E2E, Permissions, Diffs, native App | 10 Min |
| Mehrere Agents überblicken | **Cline Kanban** | Board, Worktrees, Diffs, Browser | 20 Min |
| Codex ohne Zusatz-App | **Codex Remote Control** | offiziell, aber gleicher Account nötig | 5 Min |
| Kommerzielle Komfortlösung | **Termdeck** | Push-Approvals, Multi-Machine | Trial |
| Remote-Hilfe mit GUI | **Screen Sharing / RustDesk** | kompletter Desktop, Dateitransfer | 15–30 Min |
| Dateien zwischen Geräten | **Taildrop / LocalSend** | E2E, schnell, kein Cloud-Dienst | 5 Min |
| Async Kommunikation | **GitHub-PR + Issues** | auditierbar, asynchron | 0 (vorhanden) |
| Live gemeinsam debuggen | **sshx / tmate** | geteiltes Terminal, URL | 5 Min |
| Chat als UI | **Cline Connectors** | WhatsApp/Telegram/Slack | 30 Min |

### 10.2 Drei Ausbaustufen

**Stufe 1 – „Ich will nur sehen“ (15 Minuten, 0 €):**
Tailscale Standalone auf beiden Geräten, Remote Login an, SSH-Key, Codex in tmux, `tmux attach -r`. Dazu Taildrop für Dateien.

**Stufe 2 – „Ich will vom iPhone steuern“ (1 Stunde):**
Happy auf dem Mac + iPhone, QR-Pairing. Optional Codex Remote Control, wenn ihr denselben Workspace habt. Screen Sharing für GUI-Hilfe.

**Stufe 3 – „Agenten-Cockpit“ (halber Tag):**
Cline Kanban auf Thomas' Mac, Tailscale-ACL, RustDesk für Dateitransfer/Clipboard, Cline-Connectors für Chat, GitHub-PR-Workflow, dokumentierte Runbooks. Dazu ein `handoff/`-Ordner im Repo für Agenten-Übergaben.

**Empfehlung für dich:** Stufe 1 + 2 sofort, Stufe 3 nur, wenn Thomas wirklich regelmäßig mehrere Codex-Tasks parallel laufen lässt. Der größte Nutzen pro Aufwand ist **tmux + Happy + Taildrop**; Kanban ist der beste Zusatz für Übersicht, Screen Sharing/RustDesk für „echte“ Remote-Hilfe.

## 11. Annahmen und offene Fragen

**Annahmen:**
- Thomas' MacBook ist ein macOS-Gerät mit Admin-Rechten für ihn; du darfst Tailscale/SSH/Happy installieren.
- Ihr könnt Geräte in **einem** Tailnet haben (persönlicher Plan oder gemeinsamer Team-Tailnet).
- Codex läuft als CLI oder Desktop-App, nicht nur als Cloud-Task.
- Der Mac darf für Support-Sessions wach bleiben; ein Reboot ohne lokale Anwesenheit ist die Ausnahme.

**Offene Fragen, die die beste Lösung verschieben:**
1. Nutzt Thomas **Codex CLI** oder die **Desktop-App**? (Remote Control vs. tmux/Happy)
2. Habt ihr denselben **ChatGPT-Workspace**? (Codex Remote Control)
3. Gibt es ein **MDM-/Firmenprofil**, das Tailscale, Screen Sharing oder RustDesk einschränkt?
4. Liegen **Kundendaten** auf dem Mac? (Provider-/DSGVO-Entscheidung)
5. Ist das Repo in einer **GitHub-Org**, in der du PRs reviewen und Cloud-Agents starten darfst?
6. Will Thomas überhaupt ein Board/Tool, oder soll es für ihn **unsichtbar** bleiben (nur tmux + SSH)?
7. iPhone oder iPad als Hauptgerät? (Blink Shell vs. Termius; Jump vs. Remoted)

## 12. Quellen (geprüft am 22.10.2026)

- ClinePass (Preis, Modelle, Quota, Referenzpreise): https://docs.cline.bot/getting-started/clinepass
- ClinePass-Marketingseite: https://cline.bot/cline-pass
- Cline-Provider / Pay-as-you-go: https://docs.cline.bot/getting-started/cline-provider
- Cline-Modellverzeichnis: https://cline.bot/models
- Cline Kanban (Agenten-Kompatibilität): https://docs.cline.bot/usage/kanban
- Cline Kanban Remote Access (Tailscale-Empfehlung, Port 3484): https://docs.cline.bot/kanban/remote-access
- Cline Desktop (Import von Codex/Claude-Sessions, SSH-Remote): https://docs.cline.bot/usage/cline-desktop
- Cline Desktop SSH: https://docs.cline.bot/usage/cline-desktop-ssh
- Cline Cloud Agents: https://docs.cline.bot/usage/cloud-agents
- Cline Connectors (WhatsApp/Telegram/Slack): https://docs.cline.bot/cli/connectors
- Cline Model Orchestration (`--thinking`, `--config`): https://docs.cline.bot/cli/samples/model-orchestration
- Tailscale: macOS-Varianten: https://tailscale.com/docs/concepts/macos-variants
- Tailscale SSH: https://tailscale.com/docs/features/tailscale-ssh
- Tailscale Taildrop (inkl. `tailscale file cp`): https://tailscale.com/docs/features/taildrop
- Tailscale Serve: https://tailscale.com/docs/features/tailscale-serve
- Tailscale Preise/Personal-Plan: https://tailscale.com/pricing
- Tailscale + RustDesk: https://tailscale.com/docs/solutions/access-remote-desktops-with-rustdesk
- macOS Screen Sharing über Tailscale (Schritte, Port 5900, Caveats): https://remoted.app/blog/remote-desktop-with-tailscale/
- Vergleich Mac-Fernzugriff (Screen Sharing, SSH, RustDesk, Jump): https://spawnd.dev/remote-access-to-your-mac
- Happy Mobile App (Codex/Claude/Grok, E2E): https://happy.engineering/mobile-app/
- Termdeck (Codex-CLI-Remote, Approvals): https://termdeck.io/blog/codex-remote-control-from-your-phone
- OpenAI Codex Remote Connections (SSH, VPN-Empfehlung, Remote Control): https://learn.chatgpt.com/docs/remote-connections
- Codex-Sessions/Resume/`/status`/`/ps`: https://codex.danielvaughan.com/2026/04/08/cross-surface-session-sync/
- sshx: https://github.com/ekzhang/sshx
- OpenRouter-Modellkatalog (Kontextfenster/Preise): https://openrouter.ai/models

---

**Kurzfazit:** Nimm **GLM-5.3** als Architekten und **DeepSeek V4 Pro** als Zweitmeiner in ClinePass, **Kimi K3** nur für lange Läufe. Für Thomas' MacBook ist **Tailscale + SSH/tmux + Happy** der beste Start; **Cline Kanban** ist die stärkste Alternative, um den Codex-Agenten als Board zu sehen, und **Screen Sharing/RustDesk + Taildrop** decken GUI und Dateien ab. Tailscale funktioniert – aber nur, wenn der Mac wach, eingeloggt und die Dienste (Remote Login, Screen Sharing) eingeschaltet sind.
