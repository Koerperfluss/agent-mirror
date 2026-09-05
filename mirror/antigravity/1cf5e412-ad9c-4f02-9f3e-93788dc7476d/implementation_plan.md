# Goal Description: Jules Agent Fix, Premium API Auth Setup & Cloud Run Migration Planning

This plan addresses:
1. **[PROJEKT-FIX]** Fixing the authentication fallback in the Jules Meta-Agent codebase and test suite, allowing the tier-4 pytest suite to run successfully.
2. **[INFRA-SETUP]** Configuring the SDK connection to leverage the Google Developer Program Premium quotas via ADC or a custom Gemini API Key.
3. **[MIGRATION]** Formulating a clean mapping and migration strategy for the Cloud Run startup services to run in the `europe-west3` (Frankfurt) region.

## User Review Required

> [!WARNING]
> The default API key (`AIzaSyAjdGdL5w0g0gR3_sGP9wXR5GMdmmbp8n0`) injected into the session's environment is currently blocked (403 Forbidden). We will implement a workaround in `test_tier4.py` that automatically detects and unsets this blocked key (and any `AQ.` Agent Platform keys) to let the SDK fallback to your working Premium Application Default Credentials (ADC).

## Proposed Changes

### Component 1: Jules Meta-Agent codebase & tests

We will modify the initialization in `agent.py` and the test setup in `test_tier4.py` to allow clean ADC fallback when no valid API key is present.

#### [MODIFY] [agent.py](file:///Users/saschalagler/teamwork_projects/jules_agent/src/jules/agent.py)
- Remove the fallback of setting `GEMINI_API_KEY` to `"dummy_api_key"` in `create_jules_agent` when it is not set.

#### [MODIFY] [test_tier4.py](file:///Users/saschalagler/teamwork_projects/jules_agent/tests/test_tier4.py)
- Update `setUp` to detect the blocked API key `AIzaSyAjdGdL5w0g0gR3_sGP9wXR5GMdmmbp8n0` or any `AQ.` prefixed keys, unsetting them from the environment to trigger the SDK's ADC authentication pathway.

---

### Component 2: Infrastructure & API Verification

We will verify that the SDK connection and auth work correctly using our test script.

#### [NEW] [test_sdk.py](file:///Users/saschalagler/.gemini/antigravity/scratch/test_sdk.py)
- A simple script to verify `google.antigravity` connectivity. (Already created in scratch).

---

### Component 3: Cloud Run Deployment & Migration Plan

We will document the mapping of local repositories to Firebase projects and plan the regional migration from `us-west1` (USA) to `europe-west3` (Frankfurt) for latency and compliance.

#### [NEW] [cloud_run_migration_plan.md](file:///Users/saschalagler/.gemini/antigravity/brain/1cf5e412-ad9c-4f02-9f3e-93788dc7476d/artifacts/cloud_run_migration_plan.md)
- Complete directory-to-service mapping.
- Actionable steps to deploy services in `europe-west3` with scale-to-zero enabled.

## Verification Plan

### Automated Tests
- Run `python3 /Users/saschalagler/.gemini/antigravity/scratch/test_sdk.py` to verify the Antigravity SDK connection.
- Run `PYTHONPATH=src pytest tests/test_tier4.py` inside the `jules_agent` environment to verify all 6 scenarios pass successfully.

### Manual Verification
- Verify that the Cloud Run services are deployed and reachable.
