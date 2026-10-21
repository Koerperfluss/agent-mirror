---
name: audio-stem-separation-setup
description: Working demucs stem-separation venv on this Mac; Python 3.14 pip
  quirk (numpy not auto-installed)
metadata:
  node_type: memory
  type: project
  originSessionId: session_9fccb38cef626fd430b2fa1aa39384d2
---

Music stem separation is set up and verified working on this machine (2026-10-21):
- Venv: `~/.venvs/demucs` (homebrew Python 3.14) with `demucs htdemucs` + numpy/soundfile.
- Quirk: `pip install demucs` on Python 3.14 does NOT pull numpy — first run fails with `ModuleNotFoundError: No module named 'numpy'`; fix with `pip install numpy soundfile` into the venv, then rerun.
- Speed: full 4:30 track → 4 stems (bass/drums/other/vocals, ~48 MB WAV each) in 24 s on the M-chip CPU. Output lands at `-o <dir>/<model>/<trackname>/`.
- First proof run: `~/Desktop/htdemucs/Levela, Kasra - Acid People/` (4 stems).
- User's quality hierarchy for audio separation: MVSEP (BS-Roformer 124 bands) / UVR5 with Roformer models (e.g. HF repo AEmotionStudio/roformer-models) > demucs; reverse sample identification via Splice "Similar Sounds" and Loopcloud AI Search.
- Same venv also runs `librosa` 1.0.0 + `soundfile` (slicer scripts) on Python 3.14 — also needs manual `pip install librosa soundfile`; librosa installs fine, no numba blocker.
- User feedback (2026-10-21): do NOT dump full-length stems loose on the Desktop — stems must be full track length (time-alignment), but the user wants actual SAMPLES: onset-sliced one-shots + bar-aligned loops in a dedicated folder (e.g. `~/Desktop/Acid_People_Samples/{one-shots,loops}`, PCM_16 44.1 kHz mono, ~50 KB/hit). Slicer script kept at `Acid_People_Samples/slicer.py` (librosa beat_track → BPM; energy-fallback tempo must be `60*fps/lag`, not `60/lag`).
