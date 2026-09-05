---
app: antigravity
quelle: "1cf5e412-ad9c-4f02-9f3e-93788dc7476d/cloud_run_migration_plan.md"
stand: 2026-09-05
tags: [spiegel, antigravity]
---

# 🚀 Cloud Run Migration Plan (us-west1 → europe-west3)

This document outlines the project mapping and steps to migrate the Körperfluss-OS and startup services from `us-west1` (USA) to `europe-west3` (Frankfurt, Germany) to achieve minimal latency, compliance, and cost-efficiency.

## 📋 Target Architecture

| Service Name | Source Region | Target Region | Local Path / Repo | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `koerperfluss-hub` | — | `europe-west3` | `/Users/saschalagler/cali-coach-live` | Central platform hub |
| `cali-coach-atlas` | `europe-west1` | `europe-west3` | `/Users/saschalagler/cali-coach-atlas-final` | Movement tracking & coaching atlas |
| `cli-api` | `us-central1` | `europe-west3` | `/Users/saschalagler/antigravity-cloud` | Backend API for CLI / Agents |
| `m4-finanzassistent` | `us-west1` | `europe-west3` | `/Users/saschalagler/Documents/antigravity/happy-hertz` | Billing & financial watcher |
| `k-rperfluss-os` | `us-west1` | `europe-west3` | `/Users/saschalagler/loki-ki` | Local/hybrid intelligence kernel |

---

## 🛠️ Step-by-Step Migration Guide

### Step 1: Enable Billing & GCP Project Config
Ensure project `gen-lang-client-0285074833` is linked to your billing account.
1. Visit: [GCP Billing Console](https://console.developers.google.com/billing/enable?project=gen-lang-client-0285074833)
2. Associate the billing account (with your Google Developer Program Premium cloud credits).

### Step 2: Build & Deploy via CLI
For each service, build and deploy the container in the target region `europe-west3` using the following parameters:
- `--region europe-west3`
- `--allow-unauthenticated` (for web frontends / public APIs)
- `--max-instances 3` (limits concurrency/costs)
- `--min-instances 0` (enables scale-to-zero to minimize idle costs)

**Example command for `cli-api` (antigravity-cloud):**
```bash
gcloud run deploy cli-api \
  --source /Users/saschalagler/antigravity-cloud \
  --region europe-west3 \
  --project gen-lang-client-0285074833 \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 3
```

### Step 3: Clean up Legacy Services
Once the target service in `europe-west3` is verified:
1. Delete the legacy service in `us-west1` or `us-central1` to prevent billing overhead:
```bash
gcloud run services delete <service-name> --region us-west1 --project gen-lang-client-0285074833
```
