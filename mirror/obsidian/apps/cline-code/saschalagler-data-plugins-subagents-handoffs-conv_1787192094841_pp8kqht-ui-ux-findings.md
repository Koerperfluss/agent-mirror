---
app: cline-code
quelle: "saschalagler/data/plugins/subagents/handoffs/conv_1787192094841_pp8kqht/ui-ux-findings.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# MemoryIngestApp UI/UX Improvements Plan

## Current State Analysis

### IngestViewModel.swift
- `processInput()` runs Python script via `Process`
- Shows "Processing..." status, then error/success after 2s delay
- No specific YouTube transcript error handling
- ProgressView shown during processing but disappears after fixed 2s
- No clipboard/copy functionality for Obsidian links

### ContentView.swift
- Picker for input type (url, file, text)
- TextEditor for text input
- Status text shown in red/green
- Button with ProgressView during processing
- Drop file support

### ingest.py (Python back-end)
- Supports YouTube, GitHub, PDFs, Web Articles, raw text
- Has `write_to_obsidian()` that generates `[[date — slug]]` links
- Handles transcript extraction for YouTube

## Improvements Needed

### 1. Better Error Handling for YouTube Transcripts
- YouTube transcript failures need specific, user-friendly error messages
- Currently generic error output from Python script
- Need to parse and display specific transcript errors

### 2. Progress Indicators During Python Execution
- Current 2s fixed delay is misleading
- Need spinner during actual processing
- Show processing state more clearly
- Disable UI during processing

### 3. Obsidian Link Display & Copy Functionality
- After successful ingest, display the generated Obsidian link
- Add "Copy" button to copy link to clipboard
- Make link clickable/selectable

### 4. Overall Polish
- Better visual feedback
- More descriptive status messages
- Improved error presentation
- Smoother UI transitions