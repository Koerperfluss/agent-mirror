# YouTube Transcription Research Findings

## Current State (ingest.py extract_youtube function)
- Located at `/Users/saschalagler/scripts/ingest.py` lines ~118-148
- Uses yt-dlp with `--write-subs`, `--write-auto-subs`, `--sub-langs 'en,en-US,de'`, `--sub-format vtt`
- Has a syntax bug: `--sub-format vtt` is missing a space before `--output`
- No fallback if no transcript available
- No Whisper/ASR fallback

## yt-dlp Transcript Options

### Key Options
- `--write-subs`: Write official subtitle files
- `--write-auto-subs`: Write auto-generated caption files (YouTube's "auto-generated" captions)
- `--sub-langs LANG[:LIKE],...`: Language priority list (e.g., `en,en-US,de,fr`)
- `--sub-format FORMAT`: Output format (vtt, srt, ass)
- `--skip-download`: Don't download video, just extract info/subtitles
- `--list-subs`: List available subtitles for a video

### Why Some Videos Have Transcripts & Others Don't
1. **Manual vs auto-generated**: Only some videos have manual captions; many only have auto-generated
2. **Uploader settings**: Creators can disable comments/captions entirely
3. **Age/privacy restrictions**: Age-restricted, private, or unlisted videos may lack transcripts
4. **Live vs recorded**: Live streams' captions may not be available as files after the fact
5. **YouTube region/copyright**: Some captions are blocked in certain regions or removed due to copyright
6. **Short videos**: Very short videos may not have captions generated

### yt-dlp `--list-subs` Output Example
```
[youtube] video_id
Available subtitles:
  en (auto-generated)
  de (manual)
  en-US (auto-generated)
No auto-generated subtitles available
```

### Alternative Language Strategies
- Try primary language first: `en`
- Fall back to `en-US`, `en-GB`
- Add common languages: `de, fr, es, pt, ja, zh`
- Use `*` wildcard or `all` to see all available

## Alternative Transcription APIs

### 1. OpenAI Whisper API
- **Model**: `whisper-1`
- **Pros**: High quality, supports 97 languages, audio translation, timestamps
- **Cons**: Cost per token, requires audio extraction first
- **YouTube integration**: Extract audio with yt-dlp, then send to Whisper API
- **Endpoint**: `POST https://api.openai.com/v1/audio/transcriptions`

### 2. AssemblyAI
- **Pros**: YouTube URL direct support, speaker detection, sentiment analysis
- **Cons**: Paid service, limited free tier
- **YouTube**: Can directly transcribe `https://www.youtube.com/watch?v=ID`

### 3. Google Cloud Speech-to-Text
- **Pros**: Enterprise-grade, long audio support
- **Cons**: Costly, complex setup, language model configuration

### 4. Local Whisper (faster-whisper)
- **Pros**: Free, private, no API cost, offline
- **Cons**: Requires GPU for speed, CPU inference is slow, memory usage
- **Setup**: `pip install faster-whisper` + download model

### 5. Whisper.cpp
- **Pros**: CPU-optimized, very memory-efficient, Apple Silicon support via Metal
- **Cons**: Still slower than GPU, requires model download

## Best Practices for Detecting Transcript Availability

### 1. Tiered Approach
1. Try `--write-auto-subs --sub-langs en` first (fast, free)
2. If failed, try `--write-subs --sub-langs en` (manual captions)
3. If still failed, try multiple languages: `--sub-langs en,en-US,de,fr,es`
4. If all fail, fall back to audio + Whisper transcription

### 2. Detection Commands
```bash
# Check available subtitles without downloading
yt-dlp --list-subs https://www.youtube.com/watch?v=VIDEO_ID

# Check with auto-subs only
yt-dlp --write-auto-subs --sub-langs en --skip-download https://www.youtube.com/watch?v=VIDEO_ID
```

### 3. Error Pattern Recognition
- yt-dlp exit code 1 + "No subtitles available" = no transcript
- yt-dlp exit code 0 but no file created = language not available
- Rate limiting (429) = back off and retry

### 4. Fallback Triggers
- No `.vtt` or `.srt` file created after yt-dlp run
- File exists but is empty or contains only `<blank>` markers
- Subtitle file has < 50 characters of actual content

## How Other Apps Solve This

### yt-dlp Frontends (e.g., yt-dlp-gui, pitube)
- Try multiple language combinations
- Show available subtitles before extracting
- Download both manual + auto-generated

### AI-Powered Summarization Tools
- **Obsidian YouTube plugins**: Try yt-dlp subs first, then Whisper API
- **YouTube Digest services**: Always use Whisper API for guaranteed transcript
- **Self-hosted pipelines**: yt-dlp → subtitle extraction → Whisper local processing

### Hybrid Approach (Recommended)
1. Try yt-dlp subtitle extraction (fast, free)
2. If insufficient (> 95% blank, or < 100 chars), extract audio
3. Send audio to Whisper API or local Whisper
4. Use resulting transcript for summarization

## Recommended Changes to ingest.py

### 1. Fix extract_youtube function
- Fix the syntax bug (space between `--sub-format vtt` and `--output`)
- Add multi-language attempts
- Add transcript availability detection
- Add optional Whisper fallback

### 2. New function: extract_youtube_with_whisper_fallback
- Try yt-dlp subs first
- If insufficient, extract audio chunk
- Send to Whisper API (if key available) or local Whisper
- Return complete transcript

### 3. Update classify_input / ingest_url
- Add `--check-transcript` option or auto-detection
- Log when falling back to Whisper
- Track success rates per video

### 4. Configuration
- Add environment variable for Whisper API key
- Add language preference configuration
- Add fallback threshold (minimum chars for "sufficient" transcript)