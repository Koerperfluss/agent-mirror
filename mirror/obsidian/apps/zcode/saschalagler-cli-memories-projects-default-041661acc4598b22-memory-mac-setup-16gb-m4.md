---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/mac-setup-16gb-m4.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
name: mac-setup-16gb-m4
description: Sascha's Mac is a fanless MacBook Air M4, 16 GB RAM, ~103 GB disk free
  (2026-09-08), macOS 27 „Golden Gate" Developer Beta (seit 09.2026) — RAM is the hard
  constraint for local models; Beta-Bugs siehe macos-27-beta-status
metadata:
  node_type: memory
  type: user
  originSessionId: sess_a4fac12a-8aa1-4ca6-abd4-c5a2048eb9e7
---

Sascha's machine: Apple M4 **MacBook Air** — **fanless**, 60 Hz panel, no ProMotion (confirmed during the 2026-08-25 thermal diagnosis; earlier noted as MacBook Pro). **16 GB unified memory** — under real workload (Docker VM + browser renderers) only ~140 MB free with 1.78 GB swap active; realistically ~4–6 GB headroom. Disk: **38 GB free of 460 GB** (2026-08-26; was 42 GB on 2026-08-25, ~25 GB before cleanup). Dev toolchain (2026-08-26): System-Python **3.14.6** (too new for old ML stacks like basicsr — use `uv venv --python 3.11` instead, see [[foto-restaurierung-opa-a4]]) and **uv 0.11.18**. **No `ollama` on PATH** (checked 2026-08-26) — no local vision-LLM via ollama; local models run via Sigma/llama.cpp only. OpenCV gotcha: **opencv 5.0 removed `cv2.CascadeClassifier`** → pin `"opencv-python-headless<5"` for classic CV scripts. OS: macOS 26.6 **Beta 4 (25G5057c)** as of 2026-08-25 — the night's `sudo softwareupdate -ia` run **finished WITHOUT installing anything** (catalog cache still on the beta branch; LastResultCode 0, build unchanged). Remaining path (told Sascha): **restart the Mac**, then install **26.7 Final (25G224)** via System Settings GUI; if still "No updates" after reboot, turn off the Beta-Updates toggle in the GUI (Apple Account koerperfluss@gmail.com still bound there) — see [[mac-cleanup-2026-08-25]] Runde 7. `softwareupdate` error **7507** = System Settings GUI blocking the update daemon → `killall "System Settings"` first. On this beta build the System Settings GUI tends to hang — `killall "System Settings"` + reopen fixes it. Uses Sigma browser (bundle `com.sigma-eclipse.llm`) for local GGUF models via llama.cpp.

**Implication:** only models with min RAM ≤ 12 GB fit. MoE models must still be fully resident in RAM. Qwen 3.5 9B remains the recommended primary Sigma model (Gemma 4 E4B fallback). Fanless design means sustained background load (e.g. Docker) directly heats the chassis — see [[mac-overheating-2026-08-25]]. Related: [[skill-install-conventions]].
