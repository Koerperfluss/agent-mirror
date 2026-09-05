# Marktführer-Analyse: Sprachassistenten / Speech-to-Text / Meeting-Transkription (Stand 2026)

**Aufgabe A2** · Erstellt am 04.08.2026 · Ziel: Welche Bausteine (STT, Streaming, Second-Brain-Memory, Interrupt-Verhalten) lassen sich zu einem intelligenten 24/7-Transkriptions-Assistenten kombinieren?

Alle Angaben stammen aus **Primärquellen** (offizielle Webseiten, Produkt-Dokumentationen, READMEs der Hersteller). Zitate sind mit URL belegt. Detailgrad und Preis-/Versionsangaben können sich ändern – Stand der Recherche: August 2026.

---

## 0. Kurzüberblick (Executive Summary)

| Anbieter | Typ | Echtzeit/Streaming | Lokal/Offline vs. Cloud | Gedächtnis über Sessions |
|---|---|---|---|---|
| **SoundHound** | Conversational-AI-Agenten, Voice-Commerce | Ja (niedrige Latenz) | Cloud + Edge (hybrid, Wake Word on-device) | Über Unternehmens-Domains, kein allgemeines "Second Brain" |
| **OpenAI (Whisper/Realtime)** | ASR-Modell + Realtime-Voice-API für Agenten/Transkription | Ja (WebSocket/WebRTC/SIP) | Cloud API; Whisper als offenes Modell lokal lauffähig | Nein (Sitzungszustand manuell gepflegt) |
| **Google Gemini Live** | Echtzeit-Voice/Vision-API | Ja (stateful WebSocket) | Cloud | Nein (per Session) |
| **Microsoft (Azure Speech / Copilot / Teams)** | Enterprise-STT + Meeting-AI | Ja (Real-time, Zwischenergebnisse) | Cloud (+ Container/On-prem) | Copilot in Teams nutzt Besprechungs-Historie |
| **AssemblyAI** | Voice-AI-Infrastruktur (STT, Agents, Understanding) | Ja (Streaming, Real-time-Diarization) | Cloud (+ Self-Hosted) | Via LLM/Speech-Understanding-Schicht |
| **Fireflies.ai** | Meeting-AI-Notetaker | Ja (Live, Echtzeit-Transkription) | Cloud | **Ja – "perfect memory", durchsuchbare Talk-History** |
| **Otter.ai** | AI-Notetaker / Conversational Knowledge Engine | Ja (Live-Transkription, Wort-Highlighting) | Cloud | **Ja – AI Chat "within and across meetings"** |
| **Deepgram** | Voice-AI-Plattform (STT/TTS/Agent) | Ja (Nova-3/Flux, Real-time) | Cloud + Self-Hosted/On-prem | Via Voice-Agent/Orchestrierung |
| **whisper.cpp / faster-whisper** | Lokale Whisper-Inferenz | Streaming-Beispiele; VAD-gestützt | **Lokal/offline (Edge)** | Nein (reine ASR-Röhre) |

---

## 1. SoundHound

**Was es ist:**
SoundHound AI ist ein Anbieter von konversationeller KI ("Voice AI") und baut sprachgesteuerte KI-Agenten für Unternehmen – von Automotive über Restaurants bis zu Callcentern. Eigene Aussage: *"The leading innovator of conversational technologies."* ([soundhound.com](https://www.soundhound.com/))

**Kernfunktionen:**
- **Amelia Platform** – KI-Agenten, die "listen, reason, and act" für Unternehmen ([soundhound.com](https://www.soundhound.com/))
- **Smart Answering** – "Custom AI-powered voice assistant that handles 100% of your phone calls"
- **Chat AI Automotive / Voice Commerce / Smart Ordering / Dynamic Drive-Thru** – branchenspezifische Sprach-Assistenten
- **Wake Word** – Marken-/auslösbares Aktivierungswort
- **Edge and Cloud Connectivity** – "A suite of Edge and Cloud connectivity solutions" (hybrid) ([soundhound.com](https://www.soundhound.com/))
- **Houndify Developer Platform** – "Build your voice assistant and access content domains"
- Analytische Anerkennung: 2026 **Leader im Gartner Magic Quadrant for Conversational AI Platforms**, 2026 "AI Breakthrough Award: Agentic AI Company of the Year" ([soundhound.com](https://www.soundhound.com/))

**Echtzeit/Streaming:** Ja – niedrig-latenzige Dialog-Agenten für Live-Telefonie und Drive-Thru (Real-time Voice-first).

**Lokal/offline vs. Cloud:** Hybrid. SoundHound betont explizit "Edge and Cloud Connectivity" – Wake Word und Teile der Verarbeitung laufen on-device bzw. Edge, das Großmodell/integrierte Intelligenz in der Cloud.

**Gedächtnis über Sessions:** Grundsätzlich über Domains/Wissens-Zugriff in der Amelia- bzw. Houndify-Plattform; kein explizites, allgemeines "Second Brain" über beliebige Nutzersessions wie bei Notetakern.

**Limitationen:** Stark auf Branchen-Use-Cases (Automotive, Gastronomie, Services) und proprietäre Plattform ausgerichtet; für allgemeine Meeting-Transkription/Notetaking nicht das primäre Werkzeug; keine offene, auf Meeting-Protokolle spezialisierte Langzeit-Suche.

---

## 2. OpenAI – Whisper & Realtime API

**Was es ist:**
- **Whisper** ist das offene automatische Spracherkennungs- (ASR-)Modell von OpenAI ("Robust speech recognition via large-scale weak supervision", arXiv 2212.04356) – Grundbaustein für viele STT-Pipelines.
- **GPT-4o/Realtime** ist ein end-to-end trainiertes multimodales Modell (Audio, Vision, Text). *"It can respond to audio inputs in as little as 232 milliseconds, with an average of 320 milliseconds, which is similar to human response time."* ([openai.com/index/hello-gpt-4o/](https://openai.com/index/hello-gpt-4o/))

**Kernfunktionen (Realtime API):**
- **Realtime-Transkription** mit `gpt-live-transcribe`: "when your application needs live transcript deltas from streaming audio" – konfigurierbare Latenz (`minimal/low/medium/high/xhigh`) gegen Qualität ([platform.openai.com/docs/guides/realtime](https://platform.openai.com/docs/guides/realtime))
- **Turn-Detection / Voice Activity Detection (VAD)**: native Erkennung, wann gesprochen wird (Interrupt-/Barge-in-fähig)
- **Transporte**: WebRTC (Browser/Mobil), **WebSocket** (Server-Media-Pipeline), SIP (Telefonie) ([platform.openai.com/docs/guides/realtime](https://platform.openai.com/docs/guides/realtime))
- **Realtime-Transkription**: Audio-Input, Transkript-Deltas; `gpt-transcribe` liefert erkannte Sprachen (z. B. `fr`) ([platform.openai.com/docs/guides/realtime-transcription](https://platform.openai.com/docs/guides/realtime-transcription))
- Vor GPT-4o war Voice Mode eine 3-Modell-Pipeline (STT → LLM → TTS) mit 2,8 s (GPT-3.5) bzw. 5,4 s (GPT-4) Latenz; GPT-4o verarbeitet alles in **einem** Modell end-to-end ([openai.com/index/hello-gpt-4o/](https://openai.com/index/hello-gpt-4o/))

**Echtzeit/Streaming:** Ja – bidirektionales Streaming über WebSocket/WebRTC/SIP mit Turn-Detection.

**Lokal/offline vs. Cloud:** Cloud-API für Realtime (Audio geht an OpenAI-Server). **Whisper selbst als offenes Modell** ist lokal (siehe §9).

**Gedächtnis über Sessions:** Kein automatisches Cross-Session-Gedächtnis; der Kontext einer Realtime-Session muss vom Entwickler gepflegt werden (Session-Lifecycle). `gpt-transcribe` nutzt nur frühere Turns als Kontext.

**Limitationen (Realtime-Transkription):** `gpt-live-transcribe` liefert **keine Wort-Zeitstempel, keine Sprecher-Labels und keine Konfidenzwerte** ("If your application requires timestamps or speaker labels, use a ... file transcription model or add an application-level fallback") ([platform.openai.com/docs/guides/realtime-transcription](https://platform.openai.com/docs/guides/realtime-transcription)). Streaming-Transkription tauscht Latenz gegen Qualität (spätere Teile korrigieren frühere – UI muss Revisionen handhaben).

---

## 3. Google – Gemini Live API

**Was es ist:**
"Gemini Live API enables low-latency, real-time voice and vision interactions with Gemini. It processes continuous streams of audio, images, and text to deliver immediate, human-like spoken responses." Status: **Preview** ([ai.google.dev/gemini-api/docs/live](https://ai.google.dev/gemini-api/docs/live))

**Kernfunktionen:**
- Bidirektionales Streaming über **stateful WebSocket (WSS)**; Audio-Input: raw 16-bit PCM, 16 kHz; Audio-Output 24 kHz ([ai.google.dev/gemini-api/docs/live](https://ai.google.dev/gemini-api/docs/live))
- **VAD / natürliche Turn-Taking** inkl. Unterbrechungen (Barge-in) eingebaut
- **Live Translation** – "Real-time voice-to-voice translation in 70+ languages"
- Ephemeral Tokens für sichere Client-to-Server-Verbindung; Server-to-Server via GenAI SDK
- Einsatzfelder: E-Commerce-Assistenten, NPCs/Gaming, Robotics, Smart Glasses, Fahrzeuge, Healthcare, Finanzen, Bildung, Translation/Übersetzung ([ai.google.dev/gemini-api/docs/live](https://ai.google.dev/gemini-api/docs/live))

**Echtzeit/Streaming:** Ja – kontinuierliche Audio-/Vision-/Text-Streams; Stateful WebSocket.

**Lokal/offline vs. Cloud:** Cloud-API (Gemini). (Ein Modell-"Nano Banana" ist zwar als On-Device-Modell erwähnt, die Live-API selbst läuft über die Cloud.)

**Gedächtnis über Sessions:** Kein automatisches Cross-Session-Gedächtnis beschrieben; Kontext je Session.

**Limitationen:** Preview-Status; Latenz und Kosten bei längeren Dauerstreams; kein integriertes Meeting-Speicher/Retrieval-System (muss ergänzt werden).

---

## 4. Microsoft – Azure AI Speech, Copilot, Teams

**Was es ist:**
Microsoft deckt drei Ebenen ab: (a) **Azure AI Speech (Speech-to-Text)** als Enterprise-API, (b) **Microsoft 365 Copilot** als produktivitäts-integrierter KI-Assistent, (c) **Microsoft Teams** mit Live-Transkription und Copilot-Zusammenfassungen.

**Kernfunktionen (Azure Speech-to-Text):**
- **Real-time transcription**: "Instant transcription with intermediate results for live audio inputs" ([learn.microsoft.com - Speech to Text](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-to-text))
- **Fast transcription**: "Fastest synchronous output for situations with predictable latency" (Meeting-Notizen, Untertitel, Voicemail)
- **Batch transcription**: effiziente Verarbeitung großer, vorab aufgezeichneter Audio-Mengen
- **Custom speech / Custom neural voice**: domain- und akustikspezifische Modell-Optimierung
- **Diarization**: "can identify up to 35 different speakers" ([learn.microsoft.com - Speech to Text](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-to-text))
- **Phrase lists** (Domain-Vokabular) und **Language detection**
- Verfügbar über Speech SDK, Speech CLI und REST-API
- **Copilot in Teams**: "Besprechungen zusammenfassen, Transkripte bereitstellen und Erkenntnisse aus Diskussionen teilen" ([microsoft.com/microsoft-copilot](https://www.microsoft.com/microsoft-copilot))

**Echtzeit/Streaming:** Ja – Real-time mit Zwischenergebnissen; plus Fast/Batch für aufgezeichnete Audio.

**Lokal/offline vs. Cloud:** Primär Cloud (Azure). Microsoft bietet für Speech-Dienste auch **Container-Deployment/On-prem**-Optionen (Enterprise/Sovereignty) an.

**Gedächtnis über Sessions:** Copilot in Teams kann auf Besprechungs-Historie/Transkripte im Microsoft-365-Tenant zugreifen (Organisations-Gedächtnis); Azure STT allein ist stateless (reine ASR).

**Limitationen:** Obergrenze von 35 Sprechern in der Diarization; generative KI in Microsoft 365 Copilot erfordert entsprechende Lizenzen; Transkripte sind an den Tenant/Compliance-Rahmen gebunden.

---

## 5. AssemblyAI

**Was es ist:**
"AssemblyAI is Voice AI infrastructure for developers building products that transcribe, understand, and act on speech." ([assemblyai.com](https://www.assemblyai.com/))

**Kernfunktionen / Produkte:**
- **Pre-recorded Speech-to-Text** – Transkription aufgezeichneter Audio/Video
- **Real-time/Streaming Speech-to-Text** – live Audio, Voice Agents, Captions, Agent Assist
- **Voice Agent API** – Speech-to-Speech-Agenten über ein WebSocket
- **Speech Understanding API** – strukturierte Insights aus Transkripten
- **Guardrails** – PII-Redaktion, Profanity-Filter, Content-Moderation
- **LLM Gateway** – Frontier-LLMs in Voice-Workflows
- **Diarization**: Speaker-Separation; **Universal-3 Pro Streaming**: "real-time diarization and 99+ language support" ([assemblyai.com](https://www.assemblyai.com/), [assemblyai.com/blog/universal-1/](https://www.assemblyai.com/blog/universal-1/))

**Modell Universal-1 (Primärquelle):**
- "Trained on over 12.5 million hours of multilingual audio data"; beste STT-Genauigkeit in English, Spanish, French, **German**
- 600M-Parameter **Conformer RNN-T**
- 10 % oder mehr Verbesserung (EN/ES/DE) gegenüber dem nächstbesten getesteten System; **30 % weniger Halluzination** auf Sprache, **90 % weniger auf Umgebungsgeräuschen** gegenüber Whisper Large-v3
- **Code-Switching** (mehrere Sprachen in einem Audio); präzisere Wort-Zeitstempel (+13 % vs. Conformer-2), bessere Diarization ([assemblyai.com/blog/universal-1/](https://www.assemblyai.com/blog/universal-1/))

**Echtzeit/Streaming:** Ja (Streaming STT, Voice Agent API).

**Lokal/offline vs. Cloud:** Primär Cloud; AssemblyAI bietet **Self-Hosted Voice AI** als Deploy-Option an.

**Gedächtnis über Sessions:** Kein integriertes Cross-Meeting-Speichersystem als eigenständiges Produkt; Gedächtnis/Semantik muss über Speech Understanding + LLM-Gateway aufgebaut werden.

**Limitationen:** Preis nach Minuten/Modell; Diarization-Qualität hängt von Audio-Qualität ab; eigenes "Knowledge/Wissens"-Retrieval über Meetings ist nicht out-of-the-box enthalten.

---

## 6. Fireflies.ai

**Was es ist:**
"**The #1 AI Assistant For Your Meetings** – Transcribe, summarize, search, and analyze all your team conversations." ([fireflies.ai](https://fireflies.ai/))

**Kernfunktionen:**
- Hochwertige Meeting-Transkription & Aufnahme; Webseite nennt "**95% Accurate**" und "**100+ Languages**"
- **AI Note Taker Bot** – Bot wird zu Meetings eingeladen oder tritt automatisch bei, transkribiert/schreibt zusammen
- **Chrome Extension** – "Automatically record your Google Meet calls and get **real-time transcripts**"
- **Speaker Recognition** (mehrere Sprecher erkennen/labeln), Auto-Language-Detection
- **AI-Zusammenfassungen** (Bullet Points, Action Items, Custom Notes)
- **Meeting Search / AskFred**: "Fireflies gives you **perfect memory after every conversation**"; Meetings nach Monaten bis zum einzelnen Satz & Zeitstempel durchsuchbar
- **Live Assist**: "real-time suggestions, coaching, and answers during your meetings"
- **Conversation Intelligence / 200+ AI Skills**; **Fireflies MCP Server** für Claude/Devin/ChatGPT
- Security: "SOC 2 Type II", GDPR, HIPAA ([fireflies.ai](https://fireflies.ai/))

**Echtzeit/Streaming:** Ja – Live-Transkription (Google-Meet-Extension, Live Assist).

**Lokal/offline vs. Cloud:** Cloud-SaaS (SOC2/GDPR/HIPAA).

**Gedächtnis über Sessions:** **Ja – explizit als Kernfeature** ("perfect memory", durchsuchbare Talk-History, AskFred über Meetings hinweg). Das ist genau das "Second-Brain"-Muster.

**Limitationen:** Abhängig von Konferenz-Plattform/Integration; Abo-basiert; Datenschutz beim Aufzeichnen von Meetings (Einwilligung); vor allem auf Meeting-Notetaking fokussiert, weniger auf generische Sprachassistenz außerhalb von Meetings.

---

## 7. Otter.ai

**Was es ist:**
"Your AI notetaker is now also your **Conversational Knowledge Engine**. Otter transcribes every meeting, turning it into searchable knowledge that powers your workflow." ([otter.ai](https://otter.ai/))

**Kernfunktionen:**
- **Live/Real-time-Transkription** in mehreren Sprachen; **Speaker Identification**
- **Synchronized word highlighting** beim Wiedergeben; durchsuchbare Transkripte (nach Keywords, Sprechern, Zeitbereichen)
- **Otter AI Chat**: "searches across your meetings and connected apps to instantly answer questions" – **"within and across meetings"** (Gedächtnis über Sessions!) ([otter.ai/pricing](https://otter.ai/pricing))
- **Automated Action Items**, automatische Zuweisung; CRM-Push (Salesforce, HubSpot)
- **Channels** zur Organisation von Meetings nach Team/Projekt
- **Otter MCP server** für KI-Assistenten; Integrationen mit Zoom, MS Teams, Google Meet, Notion, Jira, Slack, Glean
- "40 million+ people" und "$1.5 billion in customer ROI" (Herstellerangaben)

**Preise (Stand Recherche, [otter.ai/pricing](https://otter.ai/pricing)):**
- **Basic**: kostenlos, 300 Transkriptions-Minuten/Monat
- **Pro**: $16,99/Monat (monatlich) bzw. ~$8,50 bei jährlicher Abrechnung; bis 90 Min/Meeting, 1200 Min Aufnahme, 10 Importe
- **Business**: ~$30 (monatlich) / ~$20 bei jährlicher Abrechnung; unbegrenzte Meetings, bis 4 Std/Meeting, 3 parallele Meetings
- **Enterprise**: auf Anfrage (SSO, SCIM, HIPAA-Add-on, Otter API & Webhooks)

**Echtzeit/Streaming:** Ja – Live-Transkription + Wort-Highlighting.

**Lokal/offline vs. Cloud:** Cloud-SaaS.

**Gedächtnis über Sessions:** **Ja** – AI Chat über alle vergangenen Meetings ("within and across meetings"), longitudinale, durchsuchbare Wissensbasis.

**Limitationen:** Abo-Modell mit Minuten-/Meeting-Limits in unteren Tarifen; abhängig von Meeting-Integrationen; generelle Sprachassistenz außerhalb von Meetings begrenzt.

---

## 8. Deepgram

**Was es ist:**
"The Voice AI Economy is Powered by Deepgram" – Voice-AI-Plattform für STT, TTS und Voice Agents. "Available in real-time and batch, **cloud and self-hosted**." ([deepgram.com](https://www.deepgram.com/))

**Kernfunktionen / Modelle:**
- **Nova-3**: "highest-performing general-purpose ASR ... Recommended for meetings, event captioning, multi-speaker, multilingual, noisy, or far-field audio **in batch or streaming**"; "54.2% reduction in word error" (WER) innerhalb der Modellreihe ([developers.deepgram.com/docs/models-languages-overview](https://developers.deepgram.com/docs/models-languages-overview))
- **Flux**: erstes konversationales STT-Modell für Voice Agents – "first-of-its-kind **model-integrated end-of-turn detection**, configurable turn-taking dynamics, and ultra-low latency" mit "Nova-3 level accuracy"; mehrsprachig (u. a. DE) ([developers.deepgram.com/docs/models-languages-overview](https://developers.deepgram.com/docs/models-languages-overview))
- **Voice Agent API**: vereint STT + TTS + LLM-Orchestrierung in einer API ("reduces complexity, latency, and cost")
- **Audio Intelligence / Speech Analytics**; Speaker-Diarization, Smart Formatting
- **Deepgram Whisper Cloud**: gehostete Version von OpenAI Whisper ([developers.deepgram.com/docs/models-languages-overview](https://developers.deepgram.com/docs/models-languages-overview))

**Echtzeit/Streaming:** Ja – Nova-3 in Streaming; Flux mit nativem Turn-Taking/End-of-Turn-Detection für Agenten.

**Lokal/offline vs. Cloud:** **Beides** – Cloud und **Self-Hosted/On-prem** (explizit "self-hosted" auf Hauptseite und in der Doku).

**Gedächtnis über Sessions:** Kein eigenständiges Cross-Session-"Second Brain"; Gedächtnis/Agent-Orchestrierung über die Voice-Agent-API aufgebaut.

**Limitationen:** Whisper-Modelle in Deepgram sind zugleich stark limitiert hinsichtlich Skalierbarkeit (wenige parallele Requests, max. 20 Min. Verarbeitung, 15 parallele Requests bei Paid-Plan); allgemeines Notetaking/Meeting-Speicher ist nicht Kernprodukt (eher Infrastruktur).

---

## 9. Lokale Edge-Lösungen: whisper.cpp & faster-whisper

### whisper.cpp
**Was es ist:** "High-performance inference of OpenAI's Whisper automatic speech recognition (ASR) model: **Plain C/C++ implementation** ... with zero dependencies." Lizenz MIT; ~52,6k Stars (Stand Recherche). ([github.com/ggerganov/whisper.cpp](https://github.com/ggerganov/whisper.cpp))

**Kernfunktionen:**
- Läuft **lokal/offline** auf CPU (auch GPU via Halb-/Quantisierung, ggml) – on-device
- **whisper-stream** Beispiel: "**Real-time transcription of raw microphone capture**"
- **whisper-talk-llama**: Sprachassistent (Whisper → LLM → Sprachausgabe)
- VAD-Option mit **Silero-VAD** (Sprach-/Pausen-Erkennung, z. B. `--vad-min-silence-duration-ms`)
- **whisper-server**: HTTP-Transkriptionsserver mit OAI-ähnlicher API; WebAssembly-Ports; iOS/Android-Beispiele ([github.com/ggerganov/whisper.cpp](https://github.com/ggerganov/whisper.cpp))

**Echtzeit/Streaming:** Streaming-Beispiele vorhanden (real-time mic), aber Whisper ist grundsätzlich ein **Offline/session-basierter** Transcriber; Echtzeit wird über Chunking + VAD erreicht, nicht über einen nativen Streaming-Decoder.

### faster-whisper
**Was es ist:** "reimplementation of OpenAI's Whisper model using **CTranslate2** ... up to **4 times faster** than openai/whisper for the same accuracy while using less memory. ... 8-bit quantization on both CPU and GPU." ([github.com/SYSTRAN/faster-whisper](https://github.com/SYSTRAN/faster-whisper))

**Kernfunktionen:**
- Deutlich schneller & speicherschonender (CTranslate2, FP16/INT8)
- Automatischer Download der CTranslate2-Modelle vom Hugging Face Hub; Konvertierung eigener/feingetunterter Modelle
- Weit verbreitet als Backend für Echtzeit: **Whisper-Streaming** implementiert "real-time mode for offline Whisper-like speech-to-text models with faster-whisper as the most recommended back-end"; **WhisperLive** – "nearly-live implementation ... to transcribe audio in real-time" ([github.com/SYSTRAN/faster-whisper](https://github.com/SYSTRAN/faster-whisper))
- GUI-Varianten (aTrain – Transkription & Diarization, Uni Graz), API-Backends

**Echtzeit/Streaming:** Echtzeit nur über Zusatzprojekte (Whisper-Streaming / WhisperLive) mit selbstadaptiver Latenz.

**Limitationen (beide):** Whisper-Architektur ist nicht nativ streaming-ausgelegt → Keyword-/Halluzinationsrisiko und Latenz bei sehr langen Streams; keine sprechergetrennte Diarization im Kernmodell; **kein Gedächtnis über Sessions**; erfordert eigene LLM-/Memory-Schicht, um ein "Second Brain" zu bilden. Großer Vorteil: **Datenschutz durch lokale Verarbeitung** und keine laufenden Minutenkosten.
