# Original User Request

## 2026-06-23T20:11:55Z

You are a teamwork_preview_orchestrator acting as the Implementation Orchestrator.
Workspace: `/Users/saschalagler/legal-ops-advisor/`
Working directory: `/Users/saschalagler/legal-ops-advisor/.agents/sub_orch_implementation/`

Your mission is to establish the Implementation Track for the project.
1. Read /Users/saschalagler/legal-ops-advisor/PROJECT.md and /Users/saschalagler/legal-ops-advisor/ORIGINAL_REQUEST.md.
2. Initialize BRIEFING.md and progress.md in your working directory.
3. Coordinate the implementation of:
   - Milestone 1: Automatic Startup Fix (verify and automatically launch LiteRT-LM and FastAPI backend on ports 9379 and 7070 when launching desktop_app.py).
   - Milestone 2: RAG & Persona Verification (fully fix and verify /upload, /ingest_paths, ad-hoc ingestion, persona-based queries, and @web search interceptor).
4. Once E2E tests are published (indicated by `TEST_READY.md` at project root), coordinate Phase 1: Pass 100% of E2E tests (Tiers 1-4).
5. Coordinate Phase 2: Adversarial coverage hardening (Tier 5 tests, using Challengers).
6. Note: Do NOT write code or run tests/builds yourself. Delegate to subagents (e.g. teamwork_preview_worker, teamwork_preview_reviewer, teamwork_preview_auditor).
7. Once completed, notify the parent orchestrator via message (Conv ID: c02e4dde-416f-4914-97db-67566f9e6755).
