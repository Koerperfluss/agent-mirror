# web-template (cline-code)

Zuletzt gespiegelt: 2026-10-19 16:42 UTC

## rule

---
name: ai-model-cloudbase
description: Complete guide for calling AI models with CloudBase - covers JS/Node SDK and WeChat Mini Program. Text generation, streaming, and image generation.
alwaysApply: false
---

## When to use this skill

Use this skill for **calling AI models using CloudBase** across all platforms.

**Supported platforms:**

| Platform | SDK/API | Section |
|----------|---------|---------|
| Web (Browser) | `@cloudbase/js-sdk` | Part 1 |
| Node.js (Server/Cloud Functions) | `@cloudbase/node-sdk` ≥3.16.0 | Part 1 (same API, different init) |
| Any platform (HTTP) | HTTP API / OpenAI SDK | Part 2 |
| WeChat Mini Program | `wx.cloud.extend.AI` | Part 3 ⚠️ Different API |

---

## How to use this skill (for a coding agent)

1. **Identify the target platform** - Ask user which platform they're developing for
2. **Confirm CloudBase environment** - Get `env` (environment ID) and credentials
3. **Pick the appropriate section** - **Part 1** for JS/Node SDK, **Part 3** for WeChat Mini Program
4. **Follow CloudBase API shapes exactly** - Do not invent new APIs

---

# Part 1: CloudBase JS SDK & Node SDK

**JS SDK and Node SDK share the same AI API.** Only initialization differs.

## Installation

```bash
# For Web (Browser)
npm install @cloudbase/js-sdk

# For Node.js (Server/Cloud Functions)
npm install @cloudbase/node-sdk
```

⚠️ **Node SDK AI feature requires version 3.16.0 or above.** Check your version with `npm list @cloudbase/node-sdk`.

## Initialization - Web (JS SDK)

```js
import cloudbase from "@cloudbase/js-sdk";

const app = cloudbase.init({
  env: "<YOUR_ENV_ID>",
  accessKey: "<YOUR_PUBLISHABLE_KEY>"  // Get from CloudBase console
});

const auth = app.auth();
await auth.signInAnonymously();

const ai = app.ai();
```

## Initialization - Node.js (Node SDK)

```js
const tcb = require('@cloudbase/node-sdk');
const app = tcb.init({ env: '<YOUR_ENV_ID>' });

exports.main = async (event, context) => {
  const ai = app.ai();
  // Use AI features - same API as JS SDK
};
```

## generateText() - Non-streaming

```js
const model = ai.createModel("hunyuan-exp");

const result = await model.generateText({
  model: "hunyuan-lite",
  messages: [{ role: "user", content: "你好，请你介绍一下李白" }],
});

console.log(result.text);           // Generated text string
console.log(result.usage);          // { prompt_tokens, completion_tokens, total_tokens }
console.log(result.messages);       // Full message history
console.log(result.rawResponses);   // Raw model responses
```

## streamText() - Streaming

```js
const model = ai.createModel("hunyuan-exp");

const res = await model.streamText({
  model: "hunyuan-turbos-latest",
  messages: [{ role: "user", content: "你好，请你介绍一下李白" }],
});

// Option 1: Iterate text stream (recommended)
for await (let text of res.textStream) {
  console.log(text);  // Incremental text chunks
}

// Option 2: Iterate data stream for full response data
for await (let data of res.dataStream) {
  console.log(data);  // Full response chunk with metadata
}

// Option 3: Get final results
const messages = await res.messages;  // Full message history
const usage = await res.usage;        // Token usage
```

## generateImage() - Image Generation

⚠️ **Image generation is currently only available in Node SDK**, not in JS SDK (Web) or WeChat Mini Program.

```js

## api-reference

# AI Model SDK API Reference (@cloudbase/node-sdk)

> Prerequisite for all calls: the two-step preflight (eligibility + group readiness) in SKILL.md has passed.

## generateText() — non-streaming

```js
const model = ai.createModel("cloudbase");

const result = await model.generateText({
  model: "deepseek-v4-flash",  // must already be enabled in this env (DescribeAIModels → UpdateAIModel)
  messages: [{ role: "user", content: "Give me a one-paragraph intro to Li Bai." }],
});

console.log(result.text);           // generated text string
console.log(result.usage);          // { prompt_tokens, completion_tokens, total_tokens }
console.log(result.messages);       // full message history
console.log(result.rawResponses);   // raw model responses
```

## Error Handling Pattern

```js
const model = ai.createModel("cloudbase");

try {
  const result = await model.generateText({
    model: "deepseek-v4-flash",
    messages: [{ role: "user", content: "Summarize today's deployment logs." }],
  });

  console.log(result.text);
} catch (error) {
  console.error("AI request failed", error);
}
```

## streamText() — streaming

```js
const model = ai.createModel("cloudbase");

const res = await model.streamText({
  model: "deepseek-v4-flash",
  messages: [{ role: "user", content: "Give me a one-paragraph intro to Li Bai." }],
});

// Option 1: iterate the text stream (recommended)
for await (let text of res.textStream) {
  console.log(text);  // incremental text chunks
}

// Option 2: iterate the data stream for full response chunks
for await (let data of res.dataStream) {
  console.log(data);  // full response chunk with metadata
}

// Option 3: access final results
const messages = await res.messages;  // full message history
const usage = await res.usage;        // token usage
```

## generateImage() — image generation

⚠️ **Image generation is only available in the Node SDK**, not in the JS SDK (Web) or WeChat Mini Program.

⚠️ **Image generation also consumes the Token Credits resource pack**, so the two-step preflight must pass before calling it. Per-call cost is higher than text and calls take longer (set cloud function timeout to 900 s).

```js
const imageModel = ai.createImageModel("hunyuan-image");

const res = await imageModel.generateImage({
  model: "hunyuan-image",
  prompt: "A cute kitten playing on the grass",
  size: "1024x1024",
  version: "v1.9",
});

console.log(res.data[0].url);           // image URL (valid for 24 hours)
console.log(res.data[0].revised_prompt);// revised prompt when revise=true
```

### Image Generation Parameters

```ts
interface HunyuanGenerateImageInput {
  model: "hunyuan-image";      // required
  prompt: string;                       // required: image description
  version?: "v1.8.1" | "v1.9";         // default: "v1.8.1"
  size?: string;                        // default: "1024x1024"
  negative_prompt?: string;             // v1.9 only
  style?: string;                       // v1.9 only
  revise?: boolean;                     // default: true
  n?: number;                           // default: 1
  footnote?: string;                    // watermark, max 16 chars
  seed?: number;                        // range: [1, 4294967295]
}

interface HunyuanGenerateImageOutput {
  id: string;
  created: number;
  data: Array<{
    url: string;                        // image URL (24h valid)
    revised_prompt?: string;
  }>;
}
```

## Type Definitions

```ts
interface BaseChatModelInput {
  model: string;                        // required: model name
  messages: Array<ChatModelMessage>;    // required: message array
  temperature?: number;                 // optional: sampling temperature
  topP?: number;                        // optional: nucleus sampling
}

type ChatModelMessage =
  | { role: "user"; content: string }

## custom-onboarding

# Custom Model Onboarding (models outside the managed catalog)

When the user wants a **non-managed** text model (self-hosted, enterprise-internal, third-party OpenAI-compatible endpoint, …), **do not block**. Guide them through onboarding:

## Option 1: console flow (recommended, user handles it)

`https://tcb.cloud.tencent.com/dev?envId={envId}#/ai`

## Option 2: programmatic onboarding (`CreateAIModel`)

```
callCloudApi(service="tcb", action="CreateAIModel", params={
  EnvId: "<envId>",
  GroupName: "custom-<your-name>",  // MUST start with "custom-" (e.g. custom-kimi, custom-openai-compat); never start with "cloudbase"
  BaseUrl: "<OpenAI-compatible endpoint, e.g. https://api.moonshot.cn/v1>",
  Models: [
    { Model: "<model name, e.g. kimi-k2.5>", EnableMCP: true }
  ],
  Remark: "<optional remark>",
  Status: 1,
  Secret: { ApiKey: "<vendor api key supplied by the user>" }
})
```

Once onboarded, confirm with `DescribeAIModels` that the group is ready, then call `ai.createModel("<the GroupName you just registered>")` from your code. Use `UpdateAIModel` to add/remove models, rotate keys, or change `BaseUrl` (remember `Models` is a **full replacement**). Use `DeleteAIModel` to remove a custom group (builtin groups cannot be deleted).

> Custom-model billing is covered by the third-party provider and does not draw from the Token Credits resource pack. Field casing follows the live contract — fall back to camelCase on `InvalidParameter`.

## rule

---
name: ai-model-nodejs
description: "Use this skill for Node.js backend AI via @cloudbase/node-sdk (>=3.16.0) — cloud functions, CloudRun, Express/Koa/NestJS, serverless APIs, scheduled jobs, LLM proxies, agent orchestration. The only SDK supporting image generation (ai.createImageModel + generateImage). Text via ai.createModel with groups cloudbase, hunyuan-exp, or custom-*; model ids (e.g. deepseek-v4-flash, glm-5, kimi-k2.6) go in the `model` field of generateText/streamText. MUST run two-step preflight before code — see body. NOT for browser/Web (use ai-model-web) or Mini Program (use ai-model-wechat)."
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## When to use this skill

Use this skill for **calling AI models from Node.js backends, cloud functions, or CloudRun services** via `@cloudbase/node-sdk`.

> 🧭 **Runtime-plane fit.** This is the right skill when the AI call truly belongs on the server: image generation (the only SDK that supports it), long-running agent jobs, orchestration across multiple tools, scheduled tasks, or flows that must keep secrets server-side. **If the user is building a Web page / frontend AI chat UI, do NOT wrap this SDK behind a backend proxy** — route to `ai-model-web` and call the model directly from the browser. For WeChat Mini Programs use `ai-model-wechat`. Routing is decided by runtime plane first; the concrete model (`deepseek-*`, `glm-*`, `hunyuan-*`, `kimi-*`, …) only affects the `model` field.

**Use it when you need to:**

- Integrate AI text generation into a backend service
- Generate images with the Hunyuan Image model
- Call AI models from CloudBase cloud functions or CloudRun
- Do server-side AI processing (agent orchestration, batch jobs, scheduled tasks)

**Do NOT use for:**

- Browser/Web apps → use the `ai-model-web` skill
- WeChat Mini Program → use the `ai-model-wechat` skill
- Runtimes without a CloudBase SDK (Python, Go, PHP, curl, etc.) → use the `http-api-cloudbase` skill (it now includes the `ai_model` OpenAPI spec for direct HTTP calls to the AI model endpoint; do NOT wrap this SDK behind an HTTP proxy)

---

## ⛔ STOP — `ai.createModel(...)` argument is **not** a vendor / model name

Read this before writing any `createModel(...)` line. Agents frequently hallucinate this argument. There are **exactly three** legal shapes. Anything else is a bug.

| ✅ Legal `ai.createModel(...)` argument | When to use it |
|----------------------------------------|----------------|
| `"cloudbase"` | **The main managed group for server-side projects** (TokenHub-backed, multi-vendor pool). Vendor + concrete model go into the **`model` field** of `generateText` / `streamText`, e.g. `{ model: "deepseek-v4-flash" }`. **No model is enabled by default — always check `DescribeAIModels` first and, if the target model is missing, enable it with `UpdateAIModel` before calling the SDK.** |
| `"hunyuan-exp"` | Only if `DescribeAIModels` explicitly returns this legacy builtin group for the current env. |
| `"custom-<your-name>"` | A user-defined GroupName you onboarded via `CreateAIModel`. **Must** start with `custom-` (e.g. `custom-kimi`, `custom-openai-compat`). |

> Image generation is a separate entry point: `ai.createImageModel("hunyuan-image")`. Do not mix it with `createModel(...)`.

### ❌ Wrong argument patterns

Anything that is not one of the three legal values above: vendor names (`"deepseek"`, `"glm"`, `"kimi"`, `"openai"`, `"moonshot"`, …), concrete model ids (`"deepseek-v4-flash"`, `"hunyuan-2.0-instruct-20251111"`), the bare placeholder `"custom"`, or a variable holding the model id. All of these are bugs in `createModel(...)`.

### ✅ Correct pattern — GroupName vs Model are two different fields

```js
const model = ai.createModel("cloudbase");          // ← GroupName
await model.generateText({
  model: "deepseek-v4-flash",                       // ← concrete model id
  messages: [...]
});
```

### Decision procedure (when the user names a specific model)

1. The user says "use DeepSeek v3.2" / "use hunyuan instruct" / "use Kimi k2.6" / "use GLM-5" / …
2. `createModel("cloudbase")` stays the same.
3. Put the model id into the **`model` field**: `{ model: "deepseek-v3.2" }`, `{ model: "hunyuan-2.0-instruct-20251111" }`, `{ model: "kimi-k2.6" }`, `{ model: "glm-5" }`, …
4. **Never assume the model is already enabled.** Before calling the SDK, verify it is present in `DescribeAIModels({ GroupName: "cloudbase" }).Models[]`. If missing, call `DescribeManagedAIModelList` to confirm the exact `Model` name the platform supports (case-sensitive — do **not** guess the spelling) and then enable it via `UpdateAIModel` with `Status: 1` (remember `Models` is a full replacement).

> If you are about to type `ai.createModel(` and the thing inside the parentheses is a vendor name, a model name, or a guess — **stop**. It is almost certainly one of the three legal values above.

---

## Mandatory Two-Step Preflight (before any SDK code)

Before calling any AI API on the server, **run the two-step preflight**: ① eligibility, ② group readiness. **Text generation and image generation draw from the same Token Credits resource pack**, and both must complete the preflight before code is emitted.

### Step 0: obtain the environment ID

Call the MCP tool `queryEnv` with `action=info` and read `EnvId` from the response.

---

### Preflight ① — Eligibility (Token Credits resource pack)

Call the MCP tool:

```
callCloudApi(service="tcb", action="DescribeEnvPostpayPackage", params={ EnvId })
```

**Pass conditions (all required):**
- `envPostpayPackageInfoList` contains at least one entry
- That entry's `postpayPackageId` starts with `pkg_tcb_tokencredits_`
- That entry's `status` is NOT in `[3, 4]` (3 / 4 typically mean expired / disabled; trust the live response)

- ❌ **Not satisfied** → **stop writing code** and surface this to the user (replacing `{envId}` with the real id):
  > The current environment has no active Token Credits resource pack. Please purchase one before calling any AI API:
  > https://buy.cloud.tencent.com/lowcode?buyType=resPack&envId={envId}&resourceType=token
  >
  > Let me know once it's done and I'll re-check the resource pack status.

- ✅ **Satisfied** → proceed to preflight ②.

> Parameter casing is PascalCase by contract. If the call returns `InvalidParameter`, fall back to camelCase (`envId`) and trust the live response.

---

### Preflight ② — Group readiness (`DescribeAIModels` → `UpdateAIModel` if needed)

Eligibility alone is not enough. **Do not write `createModel("cloudbase")` yet.** First confirm that the target `GroupName` exists in the env with `Status=1`, and that the target `Model` is present in its `Models[]`.

1. **List groups configured in the current env:**

   ```
   callCloudApi(service="tcb", action="DescribeAIModels", params={ EnvId })
   ```

   Returns `AIModelGroups: AIModelGroup[]` with `GroupName`, `Type` (`builtin` / `custom`), `Models: [{ Model, EnableMCP, Tags }]`, `Status` (1 / 2), `BaseUrl`, `Secret`, `Remark`. The main managed `GroupName` is `cloudbase`.

2. **Never assume a model is already enabled.** Inspect `AIModelGroups[?].Models[].Model` for the target group. If the text model you plan to use (e.g. `deepseek-v4-flash`, or whatever the user asked for) is missing from the `cloudbase` group's `Models[]`, jump to step 4 and enable it — do not call `createModel("cloudbase")` yet. Image generation uses `createImageModel("hunyuan-image")` + `model: "hunyuan-image"`; verify it is likewise enabled before the call.

## rule

---
name: ai-model-web
description: "Use this skill when a browser/Web app (React, Vue, Next, Nuxt, static sites, SPAs, dashboards, AI chat UI, 页面, 前端, 网页) needs AI models via @cloudbase/js-sdk. Default routing for Web/frontend AI — call directly from the browser, do NOT propose a Node.js proxy. Covers generateText and streamText; models via ai.createModel with groups cloudbase, hunyuan-exp, or custom-*, model id in the `model` field. MUST run two-step preflight before code — see body. NOT for Node.js backend (use ai-model-nodejs), Mini Program (use ai-model-wechat), or image generation (Node SDK only)."
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## When to use this skill

Use this skill for **calling AI models in browser/Web applications** via `@cloudbase/js-sdk`.

> 🧭 **Runtime-plane default for Web.** Any time the user's request is framed around a page, a Web app, the frontend, React/Vue/Next/Nuxt, a dashboard UI, or "add AI to my H5", this skill is the default routing target. **Do NOT first propose a Node.js / cloud-function / CloudRun proxy**; `@cloudbase/js-sdk` can call the model from the browser directly. Only switch to `ai-model-nodejs` if the user explicitly asks for a backend/server call, image generation, or a scenario that truly needs server-side keys or long-running work. This decision is independent of which concrete model the user picks — model names (`deepseek-*`, `glm-*`, `hunyuan-*`, `kimi-*`, …) only affect the `model` field, not the routing plane.

**Use it when you need to:**

- Integrate AI text generation into a frontend Web app
- Stream AI responses for a better UX
- Call Hunyuan / DeepSeek / GLM / Kimi / MiniMax models from the browser

**Do NOT use for:**

- Node.js backend or cloud functions → use the `ai-model-nodejs` skill
- WeChat Mini Program → use the `ai-model-wechat` skill
- Image generation → use the `ai-model-nodejs` skill (Node SDK only)
- Runtimes without a CloudBase SDK (native apps, Python, Go, etc.) → use the `http-api-cloudbase` skill (it now includes the `ai_model` OpenAPI spec for direct HTTP calls; do NOT build a custom HTTP proxy)

---

## ⛔ STOP — `ai.createModel(...)` argument is **not** a vendor / model name

Read this before writing any `createModel(...)` line. The single most common mistake when agents generate code for this SDK is hallucinating the argument. There are **exactly three** legal shapes. Anything else is a bug.

| ✅ Legal `ai.createModel(...)` argument | When to use it |
|----------------------------------------|----------------|
| `"cloudbase"` | **The main managed group for new projects** (TokenHub-backed, multi-vendor pool). Vendor + concrete model go into the **`model` field** of `generateText` / `streamText`, e.g. `{ model: "deepseek-v4-flash" }`. **No model is enabled by default — always check `DescribeAIModels` first and, if the target model is missing, enable it with `UpdateAIModel` before calling the SDK.** |
| `"hunyuan-exp"` | Only if `DescribeAIModels` explicitly returns this legacy builtin group for the current env (mainly the Mini Program Growth Plan — see `ai-model-wechat`). |
| `"custom-<your-name>"` | A user-defined GroupName you onboarded via `CreateAIModel`. **Must** start with `custom-` (e.g. `custom-kimi`, `custom-openai-compat`). |

### ❌ Do NOT write any of these — they are all wrong

```js
ai.createModel("deepseek")                 // wrong — that's a vendor, not a GroupName
ai.createModel("deepseek-v4-flash")        // wrong — that's a model name, goes in the `model` field
ai.createModel("hunyuan")                  // wrong — vendor family, not a GroupName
ai.createModel("hunyuan-2.0-instruct-20251111")  // wrong — model name
ai.createModel("glm") / ai.createModel("kimi") / ai.createModel("minimax")  // wrong — vendor names
ai.createModel("openai") / ai.createModel("moonshot")  // wrong — vendor names
ai.createModel("custom")                   // wrong — placeholder; use your real custom-<name>
ai.createModel(modelName)                  // wrong — do not reuse the variable that holds the model id
```

### ✅ Correct pattern — GroupName vs Model are two different fields

```js
const model = ai.createModel("cloudbase");          // ← GroupName
await model.generateText({
  model: "deepseek-v4-flash",                       // ← concrete model id
  messages: [...]
});
```

### Decision procedure (when the user names a specific model)

1. The user says "use DeepSeek v3.2" / "use hunyuan instruct" / "use Kimi k2.6" / "use GLM-5" / …
2. `createModel("cloudbase")` stays the same.
3. Put the model id into the **`model` field**: `{ model: "deepseek-v3.2" }`, `{ model: "hunyuan-2.0-instruct-20251111" }`, `{ model: "kimi-k2.6" }`, `{ model: "glm-5" }`, …
4. **Never assume the model is already enabled.** Before writing the SDK call, verify it is present in `DescribeAIModels({ GroupName: "cloudbase" }).Models[]`. If missing, call `DescribeManagedAIModelList` to confirm the exact `Model` name the platform supports (case-sensitive — do **not** guess the spelling), then enable it via `UpdateAIModel` with `Status: 1` (remember `Models` is a full replacement, so resend everything already enabled + the new one).

> If you are about to type `ai.createModel(` and the thing inside the parentheses is a vendor name, a model name, or a guess — **stop**. It is almost certainly one of the three legal values above.

---

## Mandatory Two-Step Preflight (before any SDK code)

Before generating any AI-related SDK code, **run the two-step preflight**: ① eligibility, ② group readiness. Emitting `createModel(...)` straight away and letting the user debug runtime errors is significantly more costly.

### Step 0: obtain the environment ID

Call the MCP tool `queryEnv` with `action=info` and read `EnvId` from the response. Every subsequent check and purchase link uses this `EnvId`.

---

### Preflight ① — Eligibility (Token Credits resource pack)

Call the MCP tool:

```
callCloudApi(service="tcb", action="DescribeEnvPostpayPackage", params={ EnvId })
```

**Pass conditions (all required):**
- `envPostpayPackageInfoList` contains at least one entry
- That entry's `postpayPackageId` starts with `pkg_tcb_tokencredits_`
- That entry's `status` is NOT in `[3, 4]` (3 / 4 typically mean expired / disabled; trust the live response)

- ❌ **Not satisfied** → **stop writing code** and surface this to the user (replacing `{envId}` with the real id):
  > The current environment has no active Token Credits resource pack. Please purchase one before calling any AI API:
  > https://buy.cloud.tencent.com/lowcode?buyType=resPack&envId={envId}&resourceType=token
  >
  > Let me know once it's done and I'll re-check the resource pack status.

- ✅ **Satisfied** → proceed to preflight ②.

> Parameter casing is PascalCase by contract. If the call returns `InvalidParameter`, fall back to camelCase (`envId` / `envPostpayPackageInfoList`) and trust the live response. For the Mini Program scenario there is an additional growth-plan branch — switch to the `ai-model-wechat` skill.

---

### Preflight ② — Group readiness (`DescribeAIModels` → `UpdateAIModel` if needed)

Eligibility alone is not enough. **Do not write `createModel("cloudbase")` yet.** First confirm that the target `GroupName` exists in the env with `Status=1`, and that the target `Model` is present in its `Models[]`.

1. **List groups configured in the current env:**


## rule

---
name: ai-model-wechat
description: "Use this skill for WeChat Mini Program AI via wx.cloud.extend.AI (小程序, 企业微信小程序, wx.cloud apps). Features generateText and streamText with callbacks (onText, onEvent, onFinish). Models via wx.cloud.extend.AI.createModel with groups hunyuan-exp (小程序成长计划), cloudbase (main managed), or custom-*. Model IDs (deepseek-v4-flash, deepseek-v3.2, hunyuan-2.0-instruct-20251111, glm-5, kimi-k2.6) go in the data wrapper model field. API differs from JS/Node SDK — streamText needs data wrapper, generateText returns raw response. MUST run two-step preflight before code — see body. Keywords: Mini Program AI, wx.cloud.extend.AI, 小程序成长计划, ai_miniprogram_inspire_plan, Token Credits 资源包, generateText, streamText, createModel, hunyuan-exp, TokenHub, Hunyuan, DeepSeek, GLM, Kimi, MiniMax. NOT for browser/Web (use ai-model-web), Node.js backend (use ai-model-nodejs), or image generation (use ai-model-nodejs)."
version: 2.20.1
alwaysApply: false
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/ai-model-wechat/SKILL.md`

Keep local `references/...` paths for files that ship with the current skill directory. When this file points to a sibling skill such as `auth-tool` or `web-development`, use the standalone fallback URL shown next to that reference.

## When to use this skill

Use this skill for **calling AI models in WeChat Mini Program** using `wx.cloud.extend.AI`.

**Use it when you need to:**

- Integrate AI text generation in a Mini Program
- Stream AI responses with callback support
- Call Hunyuan models from the WeChat environment

**Do NOT use for:**

- Browser/Web apps → use `ai-model-web` skill
- Node.js backend or cloud functions → use `ai-model-nodejs` skill
- Image generation → use `ai-model-nodejs` skill (not available in Mini Program)
- Runtimes without a CloudBase SDK (native apps, Python, etc.) → use `http-api` skill (it now includes the `ai_model` OpenAPI spec for direct HTTP calls)

---

## ⛔ STOP — `wx.cloud.extend.AI.createModel(provider)` argument is **not** a vendor / model name

Read this before writing any `createModel(...)` line. Agents frequently hallucinate this argument. There are **exactly three** legal shapes. Anything else is a bug.

| ✅ Legal `createModel(provider)` argument | When to use it |
|-----------------------------------------|----------------|
| `"hunyuan-exp"` | The Mini Program **成长计划** (`ai_miniprogram_inspire_plan`) is enrolled for the current env. Default model: `hunyuan-2.0-instruct-20251111`. |
| `"cloudbase"` | Default fallback. Main managed group (TokenHub-backed, multi-vendor pool). Vendor + concrete model go into the **`model` field**, e.g. `{ model: "deepseek-v4-flash" }`. |
| `"custom-<your-name>"` | A user-defined GroupName you onboarded via `CreateAIModel`. **Must** start with `custom-` (e.g. `custom-kimi`, `custom-openai-compat`). |

### ❌ Do NOT write any of these — they are all wrong

```js
wx.cloud.extend.AI.createModel("deepseek")                   // wrong — vendor, not GroupName
wx.cloud.extend.AI.createModel("deepseek-v4-flash")          // wrong — model id goes in `model`
wx.cloud.extend.AI.createModel("hunyuan")                    // wrong — vendor family
wx.cloud.extend.AI.createModel("hunyuan-2.0-instruct-20251111")  // wrong — model name
wx.cloud.extend.AI.createModel("glm") / "kimi" / "minimax"   // wrong — vendor names
wx.cloud.extend.AI.createModel("custom")                     // wrong — placeholder
wx.cloud.extend.AI.createModel(modelName)                    // wrong — do not reuse the model-id variable
```

### ✅ Correct pattern — provider vs model are two different fields

```js
// Growth Plan branch
const model = wx.cloud.extend.AI.createModel("hunyuan-exp"); // ← provider / GroupName
await model.streamText({
  data: { model: "hunyuan-2.0-instruct-20251111", messages: [...] }  // ← concrete model id
});

// Token Credits branch
const model = wx.cloud.extend.AI.createModel("cloudbase");
await model.streamText({
  data: { model: "deepseek-v4-flash", messages: [...] }
});
```

### Decision procedure (when the user names a specific model)

1. The user says "use DeepSeek v3.2" / "use hunyuan thinking" / "use Kimi k2.6" / …
2. First run the eligibility decision tree below — the correct `provider` may be `"hunyuan-exp"` (if the env is on Growth Plan and the user asked for a `hunyuan-*` model) or `"cloudbase"` (anything else in the managed catalog).
3. Put the model id into the **`model` field** inside `data`: `{ model: "deepseek-v3.2" }`, `{ model: "hunyuan-2.0-instruct-20251111" }`, `{ model: "kimi-k2.6" }`, …
4. Before using the model id, make sure it is present in `DescribeAIModels({ GroupName: "cloudbase" }).Models[]`. If not, enable it via `UpdateAIModel`.

> If you are about to type `wx.cloud.extend.AI.createModel(` and the thing inside the parentheses is a vendor name or a model id — **stop**. It is almost certainly one of the three legal values above.

---

## Mandatory Two-Step Preflight

You MUST NOT jump straight into `wx.cloud.extend.AI.createModel(...)`. Before writing any business code, confirm **billing eligibility** and **group readiness** in this fixed order: **① eligibility → ② group readiness**. Do not swap the two.

### Preflight ① · Billing Eligibility (two parallel billing paths)

The Mini Program side has two billing paths: **小程序成长计划** (checked first; if enrolled, use `hunyuan-exp`) and **Token Credits 资源包** (generic fallback; if available, use the `cloudbase` main managed group).

1. Fetch `envId` via the MCP tool `envQuery action=info`.

2. Pick the branch by user intent:

| User intent | Eligibility to check first | `createModel` provider on hit | Model selection | Guidance on miss |
|-------------|----------------------------|-------------------------------|-----------------|------------------|
| No model specified / default call | Check **小程序成长计划** enrollment first; if not enrolled, fall back to Token Credits resource pack | Enrolled: `"hunyuan-exp"`; otherwise: `"cloudbase"` | Enrolled: `hunyuan-2.0-instruct-20251111` (the 成长计划 default). Otherwise: pick a text model with the user, then verify/enable it in the `"cloudbase"` group via `DescribeAIModels` → `DescribeManagedAIModelList` → `UpdateAIModel` | Plan not enrolled → point to `https://docs.cloudbase.net/ai/ai-inspire-plan`; resource pack missing → purchase link |
| User requests a `hunyuan-*` model | **小程序成长计划** enrollment | `"hunyuan-exp"` (plan-exclusive Token pack billing) | `hunyuan-2.0-instruct-20251111` if present; otherwise verify via `DescribeAIModels({ GroupName: "hunyuan-exp" }).Models[]` and `UpdateAIModel` to enable | Not enrolled → enroll first, or switch to `"cloudbase"` + a non-hunyuan model |
| User requests `deepseek-*` / `glm-*` / `kimi-*` / `minimax-*` / other non-hunyuan managed models | **Token Credits 资源包** activation | `"cloudbase"` | Do NOT assume the model is already enabled. `DescribeAIModels` → if missing, `DescribeManagedAIModelList` for the canonical `Model` string → `UpdateAIModel` with `Status: 1` (full-replacement `Models[]`) | Resource pack not activated → purchase link |
| User requests a third-party / self-hosted (non-managed) model | Skip billing eligibility and go to "Custom onboarding" | Custom GroupName (must start with `custom-`) | Registered via `CreateAIModel.Models[]` | Offer both console + `CreateAIModel` paths |

3. Check 小程序成长计划 enrollment:

```ts
callCloudApi({
  service: "tcb",
  action: "DescribeActivityInfo",
  params: {
    ActivityNames: ["ai_miniprogram_inspire_plan"], // PascalCase preferred; switch to camelCase if InvalidParameter is returned
  },
})
```

**Hit criterion:** the response's `attendRecords` contains at least one entry where `activityName === "ai_miniprogram_inspire_plan"` and `envId` matches the current environment. On hit, default to `createModel("hunyuan-exp")` + `hunyuan-2.0-instruct-20251111`; billing uses the plan-exclusive Token pack `pkg_hunyuan_token_la_inspire_100m`.

**On miss:** do NOT silently fall back. Tell the user "the current environment is not enrolled in 小程序成长计划", surface the enrollment entry `https://docs.cloudbase.net/ai/ai-inspire-plan`, and ask whether to enroll and retry, or to switch to the Token Credits resource pack path with a non-hunyuan model.

4. Check the Token Credits resource pack (when the path leads to the `"cloudbase"` main managed group):

## rule

---
name: auth-nodejs-cloudbase
description: CloudBase Node SDK auth guide for server-side identity, user lookup, and custom login tickets. This skill should be used when Node.js code must read caller identity, inspect end users, or bridge an existing user system into CloudBase; not when configuring providers or building client login UI.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## Activation Contract

### Use this first when

- Node.js code in cloud functions or backend services must read caller identity, look up users, or issue custom login tickets.
- The backend responsibility is auth / identity, not provider setup or frontend login UI.

### Read before writing code if

- The task mentions `@cloudbase/node-sdk`, server-side auth, custom login tickets, or "who is calling".
- The request mixes frontend login with backend identity logic; split the flow and route client-side work elsewhere.

### Then also read

- Provider setup / publishable key -> `../auth-tool-cloudbase/SKILL.md`
- Web login UI that consumes custom tickets -> `../auth-web-cloudbase/SKILL.md`
- Raw HTTP auth client -> `../http-api-cloudbase/SKILL.md`

### Do NOT use for

- Provider enable/disable or login console configuration.
- Frontend login / sign-up UI.
- Mini program native auth.

### Common mistakes / gotchas

- Using this skill as the entry point for every auth request.
- Mixing provider-management work with Node-side identity code.
- Reaching for raw HTTP examples when Node SDK already covers the job.

## When to use this skill

Use this skill whenever the task involves **server-side authentication or identity** in a CloudBase project, and the code is running in **Node.js**, for example:

- CloudBase 云函数 (Node runtime) that needs to know **who is calling**
- Node services that use **CloudBase Node SDK** to look up user information
- Backends that issue **custom login tickets** for Web / mobile clients
- Admin or ops tools that need to inspect CloudBase end-user profiles

**Do NOT use this skill for:**

- Frontend Web login / sign-up flows using `@cloudbase/js-sdk` (handle those with the **auth-web** skill, not this Node skill).
- Direct HTTP auth API integrations (this skill does not describe raw HTTP endpoints; use the **http-api** skill instead).
- Database or storage operations that do not involve identity (use database/storage docs or skills).

When the user request mixes frontend and backend concerns (e.g. "build a web login page and a Node API that knows the user"), treat them separately:

- Use Web-side auth docs/skills for client login and UX.
- Use this Node Auth skill for how the backend sees and uses the authenticated user.

---

## How to use this skill (for a coding agent)

When you load this skill to work on a task:

1. **Clarify the runtime and responsibility**

   Ask the user:

   - Where does this Node code run?
     - CloudBase 云函数
     - Long‑running Node service using CloudBase
   - What do they need from auth?
     - Just the **caller identity** for authorization?
     - **Look up arbitrary users** by UID / login identifier?
     - **Bridge their own user system** into CloudBase via custom login?

2. **Confirm CloudBase environment and SDK**

   - Ask for:
     - `env` – CloudBase environment ID
   - Install the latest `@cloudbase/node-sdk` from npm if it is not already available.
   - Always initialize the SDK using this pattern (values can change, shape must not):

   ```ts
   import tcb from "@cloudbase/node-sdk";

   const app = tcb.init({ env: "your-env-id" });
   const auth = app.auth();
   ```

3. **Pick the relevant scenario from this file**

   - For **caller identity inside a function**, use the `getUserInfo` scenarios.
   - For **full user profile or admin lookup**, use the `getEndUserInfo` and `queryUserInfo` scenarios.
   - For **client systems that already have their own users**, use the **custom login ticket** scenarios built on `createTicket`.
   - For **logging / security**, use the `getClientIP` scenario.

4. **Follow Node SDK API shapes exactly**

   - Treat all `auth.*` methods and parameter shapes in this file as canonical.
   - You may change variable names and framework (e.g. Express vs 云函数 handler), but **do not change SDK method names or parameter fields**.
   - If you see a method in older code that is not listed here or in the Node SDK docs mirror, treat it as suspect and avoid using it.

5. **If you are unsure about an API**

   - Consult the official CloudBase Auth Node SDK documentation.
   - Only use methods and shapes that appear in the official documentation.
   - If you cannot find an API you want:
     - Prefer composing flows from the documented methods, or
     - Explain that this skill only covers Node SDK auth, and suggest using the relevant CloudBase Web or HTTP auth documentation for client-side or raw-HTTP flows.

---

## Node auth architecture – how Node fits into CloudBase Auth

## rule

---
name: auth-nodejs-cloudbase
description: CloudBase Node SDK auth guide for server-side identity, user lookup, and custom login tickets. This skill should be used when Node.js code must read caller identity, inspect end users, or bridge an existing user system into CloudBase; not when configuring providers or building client login UI.
version: 2.24.1
alwaysApply: false
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-nodejs/SKILL.md`

Keep local `references/...` paths for files that ship with the current skill directory. When this file points to a sibling skill such as `auth-tool` or `web-development`, use the standalone fallback URL shown next to that reference.

## Activation Contract

### Use this first when

- Node.js code in cloud functions or backend services must read caller identity, look up users, or issue custom login tickets.
- The backend responsibility is auth / identity, not provider setup or frontend login UI.

### Read before writing code if

- The task mentions `@cloudbase/node-sdk`, server-side auth, custom login tickets, or "who is calling".
- The request mixes frontend login with backend identity logic; split the flow and route client-side work elsewhere.

### Then also read

- Provider setup / publishable key -> `../auth-tool/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-tool/SKILL.md`)
- Web login UI that consumes custom tickets -> `../auth-web/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-web/SKILL.md`)
- Raw HTTP auth client -> `../http-api/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/http-api/SKILL.md`)

### Do NOT use for

- Provider enable/disable or login console configuration.
- Frontend login / sign-up UI.
- Mini program native auth.

### Common mistakes / gotchas

- Using this skill as the entry point for every auth request.
- Mixing provider-management work with Node-side identity code.
- Reaching for raw HTTP examples when Node SDK already covers the job.

## When to use this skill

Use this skill whenever the task involves **server-side authentication or identity** in a CloudBase project, and the code is running in **Node.js**, for example:

- CloudBase 云函数 (Node runtime) that needs to know **who is calling**
- Node services that use **CloudBase Node SDK** to look up user information
- Backends that issue **custom login tickets** for Web / mobile clients
- Admin or ops tools that need to inspect CloudBase end-user profiles

**Do NOT use this skill for:**

- Frontend Web login / sign-up flows using `@cloudbase/js-sdk` (handle those with the **auth-web** skill, not this Node skill).
- Direct HTTP auth API integrations (this skill does not describe raw HTTP endpoints; use the **http-api** skill instead).
- Database or storage operations that do not involve identity (use database/storage docs or skills).

When the user request mixes frontend and backend concerns (e.g. "build a web login page and a Node API that knows the user"), treat them separately:

- Use Web-side auth docs/skills for client login and UX.
- Use this Node Auth skill for how the backend sees and uses the authenticated user.

---

## How to use this skill (for a coding agent)

When you load this skill to work on a task:

1. **Clarify the runtime and responsibility**

   Ask the user:

   - Where does this Node code run?
     - CloudBase 云函数
     - Long‑running Node service using CloudBase
   - What do they need from auth?
     - Just the **caller identity** for authorization?
     - **Look up arbitrary users** by UID / login identifier?
     - **Bridge their own user system** into CloudBase via custom login?

2. **Confirm CloudBase environment and SDK**

   - Ask for:
     - `env` – CloudBase environment ID
   - Install the latest `@cloudbase/node-sdk` from npm if it is not already available.
   - Always initialize the SDK using this pattern (values can change, shape must not):

   ```ts
   import tcb from "@cloudbase/node-sdk";

   const app = tcb.init({ env: "your-env-id" });
   const auth = app.auth();
   ```

3. **Pick the relevant scenario from this file**

   - For **caller identity inside a function**, use the `getUserInfo` scenarios.
   - For **full user profile or admin lookup**, use the `getEndUserInfo` and `queryUserInfo` scenarios.
   - For **client systems that already have their own users**, use the **custom login ticket** scenarios built on `createTicket`.
   - For **logging / security**, use the `getClientIP` scenario.

4. **Follow Node SDK API shapes exactly**

   - Treat all `auth.*` methods and parameter shapes in this file as canonical.
   - You may change variable names and framework (e.g. Express vs 云函数 handler), but **do not change SDK method names or parameter fields**.
   - If you see a method in older code that is not listed here or in the Node SDK docs mirror, treat it as suspect and avoid using it.

5. **If you are unsure about an API**

   - Consult the official CloudBase Auth Node SDK documentation.
   - Only use methods and shapes that appear in the official documentation.
   - If you cannot find an API you want:
     - Prefer composing flows from the documented methods, or
     - Explain that this skill only covers Node SDK auth, and suggest using the relevant CloudBase Web or HTTP auth documentation for client-side or raw-HTTP flows.

---

## checklist

# Authentication Activation Checklist

Use this checklist before generating any CloudBase authentication flow.

## When this checklist applies

- Web login or registration
- SMS, email, anonymous (disabled by default), Google, or WeChat provider setup
- HTTP API auth flows for native apps or backend integrations

## Required checks

1. Identify the client platform: Web, mini program, native app, or backend.
2. Confirm whether provider configuration must happen before code generation.
3. Check which login methods are required and enable them first.
4. For Web flows, get or confirm the publishable key before writing frontend auth code.
5. Route to the matching implementation skill after provider setup:
   - Web -> `auth-web-cloudbase`
   - Mini program -> `auth-wechat-miniprogram`
   - Native app / raw HTTP -> `http-api-cloudbase`
6. Keep MCP tool routing explicit:
   - management-side login -> `auth`
   - application-side auth config -> `queryAppAuth` / `manageAppAuth`

## Common failure patterns

- Writing a login page before enabling SMS or email login.
- Implementing Web login in cloud functions instead of CloudBase Auth.
- Using Web SDK patterns in native App code.

## Done criteria

- Required providers are enabled.
- Platform-specific auth path is selected.
- The next skill to read is explicit before code generation starts.

## extended-guide

# Extended guide — auth-tool-cloudbase

> Moved from SKILL.md to satisfy Agent Skills Spec 500-line limit.

## Authentication Scenarios

### 1. Get Login Config

Preferred MCP tool path: `queryAppAuth(action="getLoginConfig")`

Recommended MCP request:

```json
{
  "action": "getLoginConfig"
}
```

`queryAppAuth` uses the currently selected environment and returns a short result by default:

```json
{
  "success": true,
  "envId": "your-full-env-id",
  "loginMethods": {
    "usernamePassword": true,
    "email": true,
    "anonymous": false,
    "phone": false
  }
}
```

Fallback API path: use the official login-config API. Do **not** use `lowcode/DescribeLoginStrategy` or `lowcode/ModifyLoginStrategy` as the default path.

Query current login configuration:
```js
{
    "params": { "EnvId": `env` },
    "service": "tcb",
    "action": "DescribeLoginConfig"
}
```

The underlying login strategy contains fields such as:

- `AnonymousLogin`
- `UserNameLogin`
- `PhoneNumberLogin`
- `EmailLogin`
- `SmsVerificationConfig`
- `MfaConfig`
- `PwdUpdateStrategy`

Parameter mapping for downstream Web auth code:

- `queryAppAuth(action="getLoginConfig")` and `manageAppAuth(action="patchLoginStrategy")` return `sdkStyle: "supabase-like"` plus `sdkHints`; treat that as the preferred frontend-auth calling guide
- `PhoneNumberLogin` controls phone OTP flows used by `auth-web-cloudbase` `auth.signInWithOtp({ phone })` and `auth.signUp({ phone })`
- `EmailLogin` controls email OTP flows used by `auth-web-cloudbase` `auth.signInWithOtp({ email })` and `auth.signUp({ email })`
- `UserNameLogin` controls username/password Web login flows used by `auth-web-cloudbase` `auth.signInWithPassword({ username, password })`; direct username/password `signUp` support is SDK/provider dependent and must be verified before use
- If the account identifier is a plain username string, do not route it through email-only helpers such as `signInWithEmailAndPassword`
- `UserNameLogin` also enables the broader password-login surface exposed by `auth.signInWithPassword({ username|email|phone, password })`
- `SmsVerificationConfig.Type = "apis"` requires both `Name` and `Method`
- `EnvId` is always the CloudBase environment ID, not the publishable key
- If the conversation only contains an environment alias, nickname, or other shorthand, resolve it to the canonical full `EnvId` first before generating auth config, SDK init examples, or console links

Internal behavior of `manageAppAuth(action="patchLoginStrategy")`:

1. Read the currently selected environment
2. Query the current login strategy
3. Merge the short `patch` into the writable strategy fields
4. Update through Manager SDK
5. Query again and return a short `loginMethods` result

---

### 2. Anonymous Login

> ⚠️ **Anonymous login is disabled by default.** Publishable `accessKey` alone does **not** create a gateway-authenticated anonymous session. Only enable anonymous login when the application explicitly requires unauthenticated client access (e.g. NoSQL CRUD demos) and you accept the associated security trade-offs. After enabling, Web clients using `@cloudbase/js-sdk` **3.x** must still call `await auth.signInAnonymously()` (or an equivalent authenticated session) **before** NoSQL `app.database()` CRUD — otherwise the gateway returns **401**. `checkLogin()` / `getSession()` alone do **not** create a usable write session. Anonymous users are also denied AI model invocation permissions by default.

Preferred MCP tool path: `manageAppAuth(action="patchLoginStrategy")`

To explicitly enable anonymous login (only when required):

```json
{
  "action": "patchLoginStrategy",
  "patch": {
    "anonymous": true
  }
}
```

The tool handles read-merge-write internally. The model does not need to build a full `ModifyLoginConfig` payload.

**Important**: Even after enabling anonymous login, anonymous users cannot call AI models by default. This permission must be explicitly granted separately if needed.

---

### 3. Username/Password Login

Preferred MCP tool path: `manageAppAuth(action="patchLoginStrategy")`

Recommended MCP request:

```json
{
  "action": "patchLoginStrategy",
  "patch": {
    "usernamePassword": true
  }
}
```

The tool handles read-merge-write internally. The model does not need to build a full `ModifyLoginConfig` payload.

---

### 4. SMS Login


## rule

---
name: auth-tool-cloudbase
description: CloudBase auth provider configuration and login-readiness guide. This skill should be used when users need to inspect, enable, disable, or configure auth providers, publishable-key prerequisites, login methods, SMS/email sender setup, or other provider-side readiness before implementing a client or backend auth flow.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## Activation Contract

### Use this first when

- The task is to inspect, enable, disable, or configure CloudBase auth providers, login methods, publishable key prerequisites, SMS/email delivery, or third-party login readiness.
- An auth implementation cannot proceed until provider status and login configuration are confirmed.
- A CloudBase Web auth flow needs provider verification before `auth-web-cloudbase`.

### Read before writing code if

- The request mentions provider setup, auth console configuration, publishable key retrieval, login method availability, SMS/email sender setup, or third-party provider credentials.
- The task mixes provider configuration with Web, mini program, Node, or raw HTTP auth implementation.

### Then also read

- Web auth UI -> `../auth-web-cloudbase/SKILL.md`
- Mini program native auth -> `../auth-wechat-miniprogram/SKILL.md`
- Node server-side identity / custom ticket -> `../auth-nodejs-cloudbase/SKILL.md`
- Native App / raw HTTP auth client -> `../http-api-cloudbase/SKILL.md`

### Do NOT use this as

- The default implementation guide for every login or registration request.
- A replacement for mini program native auth behavior when no provider change is involved.
- A replacement for Node-side caller identity, user lookup, or custom login ticket flows.
- A replacement for frontend integration, session handling, or client UX implementation.

### Common mistakes / gotchas

- Writing login UI before enabling the required provider.
- Treating any mention of "auth" as a provider-management task.
- Implementing Web login in cloud functions.
- Routing native App auth to Web SDK flows.
- Making configuration or code changes without first following the Change Safety Protocol (`cloudbase-platform/references/protocols/change-safety-protocol.md`).
- In an existing application, looping on provider queries after readiness is already known instead of wiring the active login and register handlers.

### Minimal checklist

- Read [Authentication Activation Checklist](checklist.md) before auth implementation.
- Anonymous login is disabled by default. Publishable `accessKey` alone does **not** create a gateway-authenticated anonymous session. With `@cloudbase/js-sdk` **3.x**, enable anonymous via this skill when needed, then clients must call `await auth.signInAnonymously()` (or an equivalent authenticated session) **before** NoSQL `app.database()` CRUD — otherwise the gateway returns **401**. For apps that require verified login (e.g. admin panels), enforce AuthGuard / RLS and reject `is_anonymous` rather than relying on the login strategy toggle alone.

## Overview

Configure CloudBase authentication providers: Anonymous, Username/Password, SMS, Email, WeChat, Google, and more.

**Prerequisites**: CloudBase environment ID (`env`)

## MCP Tool Boundary

Keep these two auth domains separate:

- `auth`: MCP / management-side login only. Use it for `status`, `start_auth`, `set_env`, `logout`, and `get_temp_credentials`.
- `queryAppAuth` / `manageAppAuth`: app-side authentication configuration. Use them for login methods, provider settings, publishable key, static domain, client config, and custom login keys.

Preferred execution order for this skill:

1. Use `queryAppAuth` / `manageAppAuth` first when the needed action exists there.
2. Use `callCloudApi` only as a fallback or for debugging raw request shapes.
3. Do not route app-side provider configuration back to the MCP `auth` tool.
4. In existing projects with active login and register handlers, stop revisiting provider setup after the required login method and publishable key are confirmed. Move back to the active frontend handler and finish the actual user flow.

### Credential scope — what each login can actually reach

Read this before telling a user to "re-authorize" after a permission-shaped failure. Re-authorizing does not widen a key's scope; it just issues the same scope again.

- **Account-level** (`auth(status)` → `credential_scope: account`): reaches control-plane APIs, subject to that identity's own CAM policies.
- **Environment API Key** (`credential_scope: single_env`): scoped to **one environment's data plane** plus the fixed TCB policies. It is not an account-level credential, so control-plane calls outside that scope fail, and there is **no channel to attach additional CAM policies to a single key** — issuing the key again changes nothing. When a task needs a capability the current credential cannot have, switch to an account-level login or follow the role route rather than retrying the same key.

Full identity table and how to grant what is missing: `../../cloud-api-operations/references/calling-methods.md`.

---

## Extended guide

For detailed scenarios, examples, and patterns, read [extended-guide.md](references/extended-guide.md).

## Reference index

All packaged reference files (required for skill lint reachability):

- [extended-guide.md](references/extended-guide.md)

## checklist

# Authentication Activation Checklist

Use this checklist before generating any CloudBase authentication flow.

## When this checklist applies

- Web login or registration
- SMS, email, anonymous (disabled by default), Google, or WeChat provider setup
- HTTP API auth flows for native apps or backend integrations

## Required checks

1. Identify the client platform: Web, mini program, native app, or backend.
2. Confirm whether provider configuration must happen before code generation.
3. Check which login methods are required and enable them first.
4. For Web flows, get or confirm the publishable key before writing frontend auth code.
5. Route to the matching implementation skill after provider setup:
   - Web -> `auth-web`
   - Mini program -> `auth-wechat`
   - Native app / raw HTTP -> `http-api`
6. Keep MCP tool routing explicit:
   - management-side login -> `auth`
   - application-side auth config -> `queryAppAuth` / `manageAppAuth`

## Common failure patterns

- Writing a login page before enabling SMS or email login.
- Implementing Web login in cloud functions instead of CloudBase Auth.
- Using Web SDK patterns in native App code.

## Done criteria

- Required providers are enabled.
- Platform-specific auth path is selected.
- The next skill to read is explicit before code generation starts.

## rule

---
name: auth-tool-cloudbase
description: CloudBase auth provider configuration and login-readiness guide. This skill should be used when users need to inspect, enable, disable, or configure auth providers, publishable-key prerequisites, login methods, SMS/email sender setup, or other provider-side readiness before implementing a client or backend auth flow.
version: 2.24.1
alwaysApply: false
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-tool/SKILL.md`

Keep local `references/...` paths for files that ship with the current skill directory. When this file points to a sibling skill such as `auth-tool` or `web-development`, use the standalone fallback URL shown next to that reference.

## Activation Contract

### Use this first when

- The task is to inspect, enable, disable, or configure CloudBase auth providers, login methods, publishable key prerequisites, SMS/email delivery, or third-party login readiness.
- An auth implementation cannot proceed until provider status and login configuration are confirmed.
- A CloudBase Web auth flow needs provider verification before `auth-web`.

### Read before writing code if

- The request mentions provider setup, auth console configuration, publishable key retrieval, login method availability, SMS/email sender setup, or third-party provider credentials.
- The task mixes provider configuration with Web, mini program, Node, or raw HTTP auth implementation.

### Then also read

- Web auth UI -> `../auth-web/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-web/SKILL.md`)
- Mini program native auth -> `../auth-wechat/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-wechat/SKILL.md`)
- Node server-side identity / custom ticket -> `../auth-nodejs/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-nodejs/SKILL.md`)
- Native App / raw HTTP auth client -> `../http-api/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/http-api/SKILL.md`)

### Do NOT use this as

- The default implementation guide for every login or registration request.
- A replacement for mini program native auth behavior when no provider change is involved.
- A replacement for Node-side caller identity, user lookup, or custom login ticket flows.
- A replacement for frontend integration, session handling, or client UX implementation.

### Common mistakes / gotchas

- Writing login UI before enabling the required provider.
- Treating any mention of "auth" as a provider-management task.
- Implementing Web login in cloud functions.
- Routing native App auth to Web SDK flows.
- Making configuration or code changes without first following the Change Safety Protocol (`cloudbase-platform/references/protocols/change-safety-protocol.md`).
- In an existing application, looping on provider queries after readiness is already known instead of wiring the active login and register handlers.

### Minimal checklist

- Read [Authentication Activation Checklist](checklist.md) before auth implementation.
- Anonymous login is disabled by default. The SDK initialized with `accessKey` still creates a lightweight anonymous session for API access. If the app requires authentication (e.g. admin panels, personal dashboards), enforce access control through AuthGuard or RLS policies rather than relying on the login strategy toggle.

## Overview

Configure CloudBase authentication providers: Anonymous, Username/Password, SMS, Email, WeChat, Google, and more.

**Prerequisites**: CloudBase environment ID (`env`)

## MCP Tool Boundary

Keep these two auth domains separate:

- `auth`: MCP / management-side login only. Use it for `status`, `start_auth`, `set_env`, `logout`, and `get_temp_credentials`.
- `queryAppAuth` / `manageAppAuth`: app-side authentication configuration. Use them for login methods, provider settings, publishable key, static domain, client config, and custom login keys.

Preferred execution order for this skill:

1. Use `queryAppAuth` / `manageAppAuth` first when the needed action exists there.
2. Use `callCloudApi` only as a fallback or for debugging raw request shapes.
3. Do not route app-side provider configuration back to the MCP `auth` tool.
4. In existing projects with active login and register handlers, stop revisiting provider setup after the required login method and publishable key are confirmed. Move back to the active frontend handler and finish the actual user flow.

---

## Authentication Scenarios

### 1. Get Login Config

Preferred MCP tool path: `queryAppAuth(action="getLoginConfig")`

Recommended MCP request:

```json
{
  "action": "getLoginConfig"
}
```

`queryAppAuth` uses the currently selected environment and returns a short result by default:

```json
{
  "success": true,
  "envId": "your-full-env-id",
  "loginMethods": {
    "usernamePassword": true,
    "email": true,
    "anonymous": false,
    "phone": false
  }
}
```

Fallback API path: use the official login-config API. Do **not** use `lowcode/DescribeLoginStrategy` or `lowcode/ModifyLoginStrategy` as the default path.

Query current login configuration:
```js
{
    "params": { "EnvId": `env` },
    "service": "tcb",
    "action": "DescribeLoginConfig"
}
```

The underlying login strategy contains fields such as:

## extended-guide

# Extended guide — auth-web-cloudbase

> Moved from SKILL.md to satisfy Agent Skills Spec 500-line limit.

## Login Methods

> ⚠️ **OTP verification must go through the `data.verifyOtp({ token })` callback returned by `signInWithOtp` / `signUp`.** Do NOT invent a standalone `auth.verifyOtp({ token })` call — the standalone form additionally requires `messageId` and fails with `"messageId is required"` when it is missing. The full flow is three steps: send code → keep the returned `data` (or its `verifyOtp` callback) → verify with `data.verifyOtp({ token })`.

**1. Phone OTP (Recommended)**
- Automatically use `auth-tool-cloudbase` to turn on `SMS Login` through `manageAppAuth`
- Send the phone number to `auth.signInWithOtp({ phone, ... })`, then call the returned `verifyOtp({ token })`.
- `signInWithOtp` can automatically create a new user if the user does not exist; control this via `shouldCreateUser` parameter (default `true`).
```js
const { data, error } = await auth.signInWithOtp({ phone: '13800138000' })
const { data: loginData, error: loginError } = await data.verifyOtp({ token: '123456' })
```

**2. Email OTP**
- Automatically use `auth-tool-cloudbase` to turn on `Email Login` through `manageAppAuth`
```js
const { data, error } = await auth.signInWithOtp({ email: 'user@example.com' })
const { data: loginData, error: loginError } = await data.verifyOtp({ token: '654321' })
```

**3. Password**

All auth methods return `{ data, error }`. Always check `error` first:
```js
// Login — returns { data: { user, session }, error: null } on success
// Supports optional is_encrypt for password encryption (default false)
const { data, error } = await auth.signInWithPassword({ username: 'test_user', password: 'pass123' })
if (error) {
  // Handle login failure (wrong password, user not found, provider not enabled)
  console.error('Login failed:', error.message)
  return false
}
// data.user.id is the uid; data.session contains the active session
const uid = data.user.id

// Also works with email or phone:
// await auth.signInWithPassword({ email: 'user@example.com', password: 'pass123' })
// await auth.signInWithPassword({ phone: '13800138000', password: 'pass123' })
// Optional: encrypt password during transmission
// await auth.signInWithPassword({ email: 'user@example.com', password: 'pass123', is_encrypt: true })
```

**Checking login state (for route guards / auth checks):**
```js
// Use auth.getSession() — NOT the deprecated getLoginState().
//
// Why: getLoginState() may return an object with uid even when only accessKey is
// present (no real login), causing route guards to incorrectly treat the caller
// as authenticated. That misleading uid is NOT a gateway session for NoSQL CRUD.
// getSession() returns data.session === undefined when no real login exists,
// making the check reliable and simple.
const { data, error } = await auth.getSession()

if (!data?.session) {
  // No real login — redirect to sign-in page
  window.location.href = '/login'
  return
}

// Also reject anonymous sessions (when signInAnonymously() was called explicitly)
if (data.session.user?.is_anonymous) {
  // Anonymous user — not allowed for protected routes
  window.location.href = '/login'
  return
}

// data.session contains: access_token, refresh_token, expires_in, user
// data.session.user contains the authenticated user info
const currentUser = data.session.user

// Optional: further verify identity type from the session user if needed
const hasVerifiedIdentity = Boolean(
  currentUser.phone_confirmed_at ||
  currentUser.email_confirmed_at ||
  currentUser.user_metadata?.username
)

// ❌ Do NOT use auth.getLoginState() — it's deprecated and returns
//    misleading data (uid/loginState) even without real login
// ❌ Do NOT use auth.getUser(), !!loginState, or !!loginState.uid as auth checks
```

**4. Registration**
- For username-style account systems, verify whether direct username/password signup is supported before wiring the form
- Username/password login can use plain identifiers such as `admin` or `editor`, but raw signup APIs may enforce stricter username patterns or be disabled
- Do not switch to email OTP or phone OTP unless the task explicitly says the account identifier is an email address or phone number
- If direct username signup is unsupported, create users through a backend or management API boundary; never put secret keys in browser code
```js
// Username + Password login
const login = await auth.signInWithPassword({
  username: 'editor',
  password: 'editor123',
})

// Email Otp
// Use only when the task explicitly requires email addresses.
// Email Otp
const emailSignUp = await auth.signUp({ email: 'new@example.com', nickname: 'User' })
const emailVerifyResult = await emailSignUp.data.verifyOtp({ token: '123456' })

// Phone Otp
// Use only when the task explicitly requires phone numbers.
// Phone Otp
const phoneSignUp = await auth.signUp({ phone: '13800138000', password: 'pass123', nickname: 'User' })
const phoneVerifyResult = await phoneSignUp.data.verifyOtp({ token: '123456' })
```

When the project already has `handleSendCode` / `handleRegister` or similar UI handlers, wire the SDK calls there directly instead of leaving them commented out in `App.tsx`.

For username-style account tasks:

```tsx
const handleRegister = async () => {
  const { error } = await auth.signUp({
    username,
    password,

## rule

---
name: auth-web-cloudbase
description: CloudBase Web Authentication Quick Guide for frontend integration after auth-tool has already been checked. Provides concise and practical Web authentication solutions with multiple login methods and complete user management.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## Activation Contract

### Use this first when

- The task is a CloudBase Web login, registration, session, or user profile flow built with `@cloudbase/js-sdk` and the auth provider setup has already been checked.

### Read before writing code if

- The user needs a login page, auth modal, session handling, or protected Web route. Read `auth-tool-cloudbase` first to ensure providers are enabled, then return here for frontend integration.

### Then also read

- `../auth-tool-cloudbase/SKILL.md` for provider setup
- `../web-development/SKILL.md` for Web project structure and deployment

### Do not start here first when

- The request is a Web auth flow but provider configuration has not been verified yet.
- In that case, activate `auth-tool-cloudbase` before `auth-web-cloudbase`.

### Do NOT use for

- Mini program auth, native App auth, or server-side auth setup.

### Common mistakes / gotchas

- Skipping publishable key and provider checks.
- Replacing built-in Web auth with cloud function login logic.
- Reusing this flow in Flutter, React Native, or native iOS/Android code.
- Creating a detached helper file with `auth.signUp` / `verifyOtp` but never wiring it into the existing form handlers, so the actual button clicks still do nothing.
- Using `signInWithEmailAndPassword` or `signUpWithEmailAndPassword` for username-style accounts such as `admin` and `editor`.
- Keeping the login or register account input as `type="email"` when the task explicitly says the account identifier is a plain username string.
- Starting implementation before calling `queryAppAuth(action="getLoginConfig")` and enabling `usernamePassword` when it is still off.
- **Writing `auth.signInWithPassword(...)` or `auth.signUp(...)` code without first confirming the provider is enabled via MCP.** Before writing any sign-in or sign-up code in the browser, call `queryAppAuth(action="listProviders")` to verify the target provider (e.g. `email`, `phone`, `usernamePassword`) has `On: "TRUE"`. For email-based sign-up (`auth.signUp({ email, password })`), additionally confirm SMTP is configured — otherwise the provider may throw `"provider email not found"` or similar errors. For username/password login, use `auth.signInWithPassword({ username, password })`; registration is best done through the management API (`manageAppAuth(action="createUser")`) or by confirming email provider readiness first.
- **Treating `auth.getUser()` or deprecated `auth.getLoginState()` as proof of real login.** When the SDK is initialized with `accessKey`, the deprecated `getLoginState()` may still return an object with a valid `uid` even without any login — causing route guards that check `!!loginState` or `!!uid` to incorrectly pass. That misleading `uid` is **not** a gateway-authenticated session. Use `auth.getSession()` instead: it returns `data.session === undefined` when no real login has occurred. Only `!!data.session` from `getSession()` is a reliable authentication check.
- **Assuming publishable `accessKey` alone is enough for NoSQL CRUD.** NoSQL `app.database()` `get` / `add` / `update` / `watch` requires a gateway-authenticated **session**: use a real login (password / OTP / OAuth). Anonymous login is a demo-only escape hatch for explicitly-public, non-user data — it is disabled by default, denied AI model permissions, and must never stand in for real auth in user-scoped apps. Skipping any login yields **gateway 401**. `checkLogin()` / `getSession()` alone do **not** create a usable write session.
- **Copying old CloudBase auth snippets from training data.** Do not use `auth.getLoginState()`, `auth.hasLoginState()`, `auth.getCurrentUser()`, or `auth.toDefaultLoginPage()` as the default Web flow. Use the Web SDK v3 auth methods in this file and provider readiness from `auth-tool-cloudbase`.
- **Calling a standalone `auth.verifyOtp({ token })` for OTP login.** CloudBase Web SDK v3 returns `verifyOtp` as a callback on the `signInWithOtp` / `signUp` result: send the code first, keep the returned `data`, then call `data.verifyOtp({ token })`. A standalone `auth.verifyOtp({ token })` without `messageId` fails with `"messageId is required"` — seeing that error means the callback form was skipped. See `references/extended-guide.md` for the full send → save callback → verify flow.
  
  Note: anonymous login is **disabled by default** for new environments and inactive existing environments. Do not enable it to work around permission errors — enable via `auth-tool-cloudbase` only when the app explicitly serves public non-user data (e.g. NoSQL read-only demos). Always use `auth.getSession()` for auth guards.

## Overview

**Prerequisites**: CloudBase environment ID (`env`)
**Prerequisites**: CloudBase environment Region (`region`)

---

## Core Capabilities

**Use Case**: Web frontend projects using `@cloudbase/js-sdk@latest` for user authentication  
**Key Benefits**: **Supabase-compatible Auth API** — all methods return `{ data, error }`, supports phone, email, anonymous (disabled by default), username/password, OAuth, and third-party login methods

> 📌 **Supabase API Compatibility**: CloudBase Web SDK v3 auth module is designed with Supabase-like API ergonomics. If you are familiar with `supabase-js` auth patterns, the same mental model applies:
> - All methods return `Promise<{ data, error }>` — always check `error` first
> - `signInWithPassword`, `signInWithOtp`, `signUp`, `signOut`, `getSession`, `getUser` follow the same naming as Supabase
> - `onAuthStateChange(callback)` provides reactive auth state observation (events: `INITIAL_SESSION`, `SIGNED_IN`, `SIGNED_OUT`, `TOKEN_REFRESHED`, `USER_UPDATED`, `PASSWORD_RECOVERY`, `BIND_IDENTITY`)
> - Session management via `getSession()` / `refreshSession()` / `setSession()` mirrors Supabase patterns
> 
> **Key differences from Supabase**:
> - **OTP verification**: Supabase uses a standalone `auth.verifyOtp({ phone, token, type })` call; CloudBase returns `verifyOtp` as a callback on `data` — call `data.verifyOtp({ token })` from the `signInWithOtp` / `signUp` result
> - **`accessKey`** replaces Supabase's `anonKey`; environment uses `env` + `region` instead of Supabase's `url`
> - **`signInWithIdToken`** for direct third-party token login (similar to Supabase's same-named method)

Use npm installation for modern Web projects. In React, Vue, Vite, and other bundler-based apps, install and import `@cloudbase/js-sdk` from the project dependencies instead of using a CDN script.

## Prerequisites

- Automatically use `auth-tool-cloudbase` to check app-side auth readiness via `queryAppAuth` / `manageAppAuth`, then get the `publishable key` and configure login methods.
- **Publishable key readiness (do not skip):** call `queryAppAuth(action="getPublishableKey")`. If it is empty, call `manageAppAuth(action="ensurePublishableKey")` first — new environments may not have one provisioned, and skipping this step leaves the frontend without a data-plane credential, surfacing later as gateway auth failures instead of an obvious missing-key error.
- **Persist the key, don't hoard it in conversation:** after retrieval, write the publishable key to `.env.local` as `VITE_PUBLISHABLE_KEY` (create the file if missing) and read it in client code via `import.meta.env.VITE_PUBLISHABLE_KEY`. Never hardcode the key into source files, and never ask the user to fetch it from the console — fall back to the console link below only if both MCP calls fail.
- If `auth-tool-cloudbase` failed, let user go to `https://tcb.cloud.tencent.com/dev?envId={env}#/env/apikey` to get `publishable key` and `https://tcb.cloud.tencent.com/dev?envId={env}#/identity/login-manage` to set up login methods

### Parameter map

- For username-style identifiers, the required precondition is `loginMethods.usernamePassword === true` from `queryAppAuth(action="getLoginConfig")`. If it is false, enable it with `manageAppAuth(action="patchLoginStrategy", patch={ usernamePassword: true })` before wiring frontend auth code.
- If the conversation only provides an environment alias, nickname, or other shorthand, resolve it with `queryEnv(action="list", alias=..., aliasExact=true)` first and use the returned canonical full `EnvId` for SDK init, console links, and generated config. Do not pass alias-like short forms directly into `cloudbase.init({ env })`.
- Treat CloudBase Web Auth as **Supabase-like**, not “every `supabase-js` auth example is valid unchanged”
- When `queryAppAuth` / `manageAppAuth` returns `sdkStyle: "supabase-like"` and `sdkHints`, follow those method and parameter hints first
- `auth.signInWithOtp({ phone })` and `auth.signUp({ phone })` use the phone number in a `phone` field, not `phone_number`
- `auth.signInWithOtp({ email })` and `auth.signUp({ email })` use `email`
- `auth.signInWithPassword({ username, password })` is the canonical Web login path for username/password accounts
- Treat direct Web `auth.signUp({ username, password })` as conditional. Verify `sdkHints` and the installed SDK first; some versions only support `signUp` for OTP/provider-token flows and will not create username/password users.
- If the task gives accounts like `admin`, `editor`, or another plain string without `@`, treat it as a username-style identifier rather than an email address
- `data.verifyOtp({ token })` — the `verifyOtp` callback on the `signInWithOtp` / `signUp` result `data` — expects the SMS or email code in `token`; do not invent a standalone `auth.verifyOtp({ token })` call, which additionally requires `messageId`
- `accessKey` is the publishable key from `queryAppAuth` / `manageAppAuth` via `auth-tool-cloudbase`, not a secret key
- **`accessKey` alone does not create a gateway-authenticated session.** Publishable `accessKey` initializes the SDK; it does **not** replace a login for NoSQL CRUD. Any `app.database()` `get` / `add` / `update` / `watch` needs a session — prefer a real login (password / OTP / OAuth); `signInAnonymously()` only for explicitly-public demo data (disabled by default, denied AI model permissions). Otherwise the gateway returns **401**. Separately: the deprecated `auth.getLoginState()` may still return a misleading `uid` without login; use `auth.getSession()` for route guards (`data.session === undefined` when not logged in). `checkLogin()` / `getSession()` alone do **not** create a usable write session.
- Never set `accessKey` to `envId`, a username, or any placeholder string. If you do not have a real Publishable Key yet, do not fabricate one.
- If the task mentions provider setup, stop and read `auth-tool-cloudbase` before writing frontend code

## Quick Start

SDK init reference: [docs.cloudbase.net/api-reference/webv3/initialization.md](https://docs.cloudbase.net/api-reference/webv3/initialization.md)（URL 加 `.md` 可取 raw markdown 原文）

```js
// npm install @cloudbase/js-sdk
import cloudbase from '@cloudbase/js-sdk'

const app = cloudbase.init({
  env: 'your-full-env-id', // Canonical full CloudBase environment ID resolved from queryEnv or the console, not an alias or shorthand
  region: 'ap-shanghai',  // CloudBase environment Region, default 'ap-shanghai'
  accessKey: 'publishable key', // required, get from auth-tool-cloudbase
  // ⚠️ accessKey alone ≠ a login session. NoSQL CRUD needs a session —
  // real login preferred; signInAnonymously() only for public demo data.
  // Use auth.getSession() for route guards; deprecated getLoginState()
  // may return a misleading uid without a real session.

## rule

---
name: auth-web-cloudbase
description: CloudBase Web Authentication Quick Guide for frontend integration after auth-tool has already been checked. Provides concise and practical Web authentication solutions with multiple login methods and complete user management.
version: 2.24.1
alwaysApply: false
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-web/SKILL.md`

Keep local `references/...` paths for files that ship with the current skill directory. When this file points to a sibling skill such as `auth-tool` or `web-development`, use the standalone fallback URL shown next to that reference.

## Activation Contract

### Use this first when

- The task is a CloudBase Web login, registration, session, or user profile flow built with `@cloudbase/js-sdk` and the auth provider setup has already been checked.

### Read before writing code if

- The user needs a login page, auth modal, session handling, or protected Web route. Read `auth-tool` first to ensure providers are enabled, then return here for frontend integration.

### Then also read

- `../auth-tool/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-tool/SKILL.md`) for provider setup
- `../web-development/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/web-development/SKILL.md`) for Web project structure and deployment

### Do not start here first when

- The request is a Web auth flow but provider configuration has not been verified yet.
- In that case, activate `auth-tool-cloudbase` before `auth-web-cloudbase`.

### Do NOT use for

- Mini program auth, native App auth, or server-side auth setup.

### Common mistakes / gotchas

- Skipping publishable key and provider checks.
- Replacing built-in Web auth with cloud function login logic.
- Reusing this flow in Flutter, React Native, or native iOS/Android code.
- Creating a detached helper file with `auth.signUp` / `verifyOtp` but never wiring it into the existing form handlers, so the actual button clicks still do nothing.
- Using `signInWithEmailAndPassword` or `signUpWithEmailAndPassword` for username-style accounts such as `admin` and `editor`.
- Keeping the login or register account input as `type="email"` when the task explicitly says the account identifier is a plain username string.
- Starting implementation before calling `queryAppAuth(action="getLoginConfig")` and enabling `usernamePassword` when it is still off.
- **Writing `auth.signInWithPassword(...)` or `auth.signUp(...)` code without first confirming the provider is enabled via MCP.** Before writing any sign-in or sign-up code in the browser, call `queryAppAuth(action="listProviders")` to verify the target provider (e.g. `email`, `phone`, `usernamePassword`) has `On: "TRUE"`. For email-based sign-up (`auth.signUp({ email, password })`), additionally confirm SMTP is configured — otherwise the provider may throw `"provider email not found"` or similar errors. For username/password login, use `auth.signInWithPassword({ username, password })`; registration is best done through the management API (`manageAppAuth(action="createUser")`) or by confirming email provider readiness first.
- **Treating `auth.getUser()` or deprecated `auth.getLoginState()` as proof of real login.** When the SDK is initialized with `accessKey`, the deprecated `getLoginState()` returns an object with a valid `uid` even without any login — causing route guards that check `!!loginState` or `!!uid` to incorrectly pass. The fix is to use `auth.getSession()` instead: it returns `data.session === undefined` when no real login has occurred. Only `!!data.session` from `getSession()` is a reliable authentication check.
- **Copying old CloudBase auth snippets from training data.** Do not use `auth.getLoginState()`, `auth.hasLoginState()`, `auth.getCurrentUser()`, or `auth.toDefaultLoginPage()` as the default Web flow. Use the Web SDK v3 auth methods in this file and provider readiness from `auth-tool`.
  
  Note: anonymous login is now **disabled by default** for new environments and inactive existing environments. Always use `auth.getSession()` for auth guards.

## Overview

**Prerequisites**: CloudBase environment ID (`env`)
**Prerequisites**: CloudBase environment Region (`region`)

---

## Core Capabilities

**Use Case**: Web frontend projects using `@cloudbase/js-sdk@latest` for user authentication  
**Key Benefits**: **Supabase-compatible Auth API** — all methods return `{ data, error }`, supports phone, email, anonymous (disabled by default), username/password, OAuth, and third-party login methods

> 📌 **Supabase API Compatibility**: CloudBase Web SDK v3 auth module is designed with Supabase-like API ergonomics. If you are familiar with `supabase-js` auth patterns, the same mental model applies:
> - All methods return `Promise<{ data, error }>` — always check `error` first
> - `signInWithPassword`, `signInWithOtp`, `signUp`, `signOut`, `getSession`, `getUser` follow the same naming as Supabase
> - `onAuthStateChange(callback)` provides reactive auth state observation (events: `INITIAL_SESSION`, `SIGNED_IN`, `SIGNED_OUT`, `TOKEN_REFRESHED`, `USER_UPDATED`, `PASSWORD_RECOVERY`, `BIND_IDENTITY`)
> - Session management via `getSession()` / `refreshSession()` / `setSession()` mirrors Supabase patterns
> 
> **Key differences from Supabase**:
> - **OTP verification**: Supabase uses a standalone `auth.verifyOtp({ phone, token, type })` call; CloudBase returns `verifyOtp` as a callback on `data` — call `data.verifyOtp({ token })` from the `signInWithOtp` / `signUp` result
> - **`accessKey`** replaces Supabase's `anonKey`; environment uses `env` + `region` instead of Supabase's `url`
> - **`signInWithIdToken`** for direct third-party token login (similar to Supabase's same-named method)

Use npm installation for modern Web projects. In React, Vue, Vite, and other bundler-based apps, install and import `@cloudbase/js-sdk` from the project dependencies instead of using a CDN script.

## Prerequisites

- Automatically use `auth-tool-cloudbase` to check app-side auth readiness via `queryAppAuth` / `manageAppAuth`, then get the `publishable key` and configure login methods.
- If `auth-tool-cloudbase` failed, let user go to `https://tcb.cloud.tencent.com/dev?envId={env}#/env/apikey` to get `publishable key` and `https://tcb.cloud.tencent.com/dev?envId={env}#/identity/login-manage` to set up login methods

### Parameter map

- For username-style identifiers, the required precondition is `loginMethods.usernamePassword === true` from `queryAppAuth(action="getLoginConfig")`. If it is false, enable it with `manageAppAuth(action="patchLoginStrategy", patch={ usernamePassword: true })` before wiring frontend auth code.
- If the conversation only provides an environment alias, nickname, or other shorthand, resolve it with `envQuery(action="list", alias=..., aliasExact=true)` first and use the returned canonical full `EnvId` for SDK init, console links, and generated config. Do not pass alias-like short forms directly into `cloudbase.init({ env })`.
- Treat CloudBase Web Auth as **Supabase-like**, not “every `supabase-js` auth example is valid unchanged”
- When `queryAppAuth` / `manageAppAuth` returns `sdkStyle: "supabase-like"` and `sdkHints`, follow those method and parameter hints first
- `auth.signInWithOtp({ phone })` and `auth.signUp({ phone })` use the phone number in a `phone` field, not `phone_number`
- `auth.signInWithOtp({ email })` and `auth.signUp({ email })` use `email`
- `auth.signInWithPassword({ username, password })` is the canonical Web login path for username/password accounts
- Treat direct Web `auth.signUp({ username, password })` as conditional. Verify `sdkHints` and the installed SDK first; some versions only support `signUp` for OTP/provider-token flows and will not create username/password users.
- If the task gives accounts like `admin`, `editor`, or another plain string without `@`, treat it as a username-style identifier rather than an email address
- `verifyOtp({ token })` expects the SMS or email code in `token`
- `accessKey` is the publishable key from `queryAppAuth` / `manageAppAuth` via `auth-tool-cloudbase`, not a secret key
- **`accessKey` triggers automatic anonymous session creation** — the deprecated `auth.getLoginState()` returns an object with a valid `uid` even without explicit login, which misleads route guards into thinking the user is authenticated. Use `auth.getSession()` instead — it returns `data.session === undefined` when no real login has occurred, making auth checks straightforward and reliable.
- Never set `accessKey` to `envId`, a username, or any placeholder string. If you do not have a real Publishable Key yet, do not fabricate one.
- If the task mentions provider setup, stop and read `auth-tool-cloudbase` before writing frontend code

## Quick Start

```js
// npm install @cloudbase/js-sdk
import cloudbase from '@cloudbase/js-sdk'

const app = cloudbase.init({
  env: 'your-full-env-id', // Canonical full CloudBase environment ID resolved from envQuery or the console, not an alias or shorthand
  region: 'ap-shanghai',  // CloudBase environment Region, default 'ap-shanghai'
  accessKey: 'publishable key', // required, get from auth-tool-cloudbase
  // ⚠️ With accessKey, the deprecated getLoginState() returns misleading auth data (uid)
  // even without login. Always use auth.getSession() — returns undefined when not logged in.
  auth: { detectSessionInUrl: true }, // required
})

const auth = app.auth
```


## rule

---
name: auth-wechat-miniprogram
description: CloudBase WeChat Mini Program native authentication guide. This skill should be used when users need mini program identity handling, OPENID/UNIONID access, or `wx.cloud` auth behavior in projects where login is native and automatic.
version: 2.20.1
alwaysApply: false
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-wechat/SKILL.md`

Keep local `references/...` paths for files that ship with the current skill directory. When this file points to a sibling skill such as `auth-tool` or `web-development`, use the standalone fallback URL shown next to that reference.

## Activation Contract

### Use this first when

- The task is about WeChat Mini Program auth behavior, `wx.cloud` identity, `OPENID` / `UNIONID`, or how a mini program caller is identified in CloudBase.
- The project is a CloudBase mini program and the auth question is about native mini program identity rather than provider configuration.

### Read before writing code if

- The request mentions mini program login, user identity in cloud functions, or `wx.cloud` auth assumptions.
- The user expects a Web-style login page or explicit token exchange in a mini program; route them back to native mini program auth behavior.

### Then also read

- Mini program project implementation -> `../miniprogram-development/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/miniprogram-development/SKILL.md`)
- Cloud function implementation -> `../cloud-functions/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/cloud-functions/SKILL.md`)

### Do NOT use for

- Web-based WeChat login or Web auth UI.
- Provider enable/disable or auth console setup.
- Generic Node-side auth flows outside mini program identity handling.

### Common mistakes / gotchas

- Generating a Web-style login page for a `wx.cloud` mini program.
- Treating mini program auth as a provider-configuration problem.
- Forgetting that caller identity is injected in cloud functions automatically.

## When to use this skill

Use this skill for **WeChat Mini Program (小程序) authentication** in a CloudBase project.

Use it when you need to:

- Implement identity-aware WeChat Mini Program flows with CloudBase
- Access user identity (openid, unionid) in cloud functions
- Understand how WeChat authentication integrates with CloudBase
- Build Mini Program features that require user identification

**Key advantage:** WeChat Mini Program authentication with CloudBase is **seamless and automatic** - no complex OAuth flows needed. When a Mini Program calls a cloud function, the user's `openid` is automatically injected and verified by WeChat.

**Do NOT use for:**

- Web-based WeChat login (use the **auth-web** skill)
- Server-side auth with Node SDK (use the **auth-nodejs** skill)
- Non-WeChat authentication methods (use appropriate auth skills)

---

## How to use this skill (for a coding agent)

1. **Confirm CloudBase environment**
   - Ask the user for:
     - `env` – CloudBase environment ID
     - Confirm the Mini Program is linked to the CloudBase environment

2. **Understand the authentication flow**
   - WeChat Mini Program authentication is **native and automatic**
   - No explicit login API calls needed in most cases
   - User identity is automatically available in cloud functions
   - CloudBase handles all authentication verification

3. **Pick a scenario from this file**
   - For basic user identity in cloud functions, use **Scenario 2**
   - For Mini Program initialization, use **Scenario 1**
   - For calling a cloud function from the Mini Program and receiving user identity, use **Scenario 3**
   - For testing authentication, use **Scenario 4**

4. **Follow CloudBase API shapes exactly**
   - Use `wx-server-sdk` in cloud functions
   - Use `wx.cloud` in Mini Program client code
   - Treat method names and parameter shapes in this file as canonical

5. **If you're unsure about an API**
   - Consult the official CloudBase Mini Program documentation
   - Only use methods that appear in official documentation

---

## Core concepts

### How WeChat Mini Program authentication works with CloudBase

1. **Automatic authentication:**
   - When a Mini Program user calls a cloud function, WeChat automatically injects the user's identity
   - No need for complex OAuth flows or token management
   - CloudBase verifies the authenticity of the identity

2. **User identifiers:**
   - `OPENID` – Unique identifier for the user in this specific Mini Program
   - `APPID` – The Mini Program's App ID
   - `UNIONID` – (Optional) Unique identifier across all apps under the same WeChat Open Platform account
     - Only available when the Mini Program is bound to a WeChat Open Platform account
     - Useful for identifying the same user across multiple Mini Programs or Official Accounts

3. **Security:**
   - The `openid`, `appid`, and `unionid` are **verified and trustworthy**
   - WeChat has already completed authentication
   - Developers can directly use these identifiers without additional verification

4. **No explicit login required:**
   - Users are automatically authenticated when they use the Mini Program
   - No need to call login APIs in most cases

## calling-methods

# Calling Methods — MCP callCloudApi / SDK / CAM authorization

## §1 MCP `callCloudApi`（会话内交互式操作）

```json
{
  "service": "cam",                // 腾讯云产品标识，任意产品可调，见下
  "action": "DescribeRoleList",    // 官方 Action 名，禁止猜测
  "version": "2019-01-16",         // 官方 API 版本；多数可省，多版本产品必传
  "region": "ap-shanghai",         // 可选，X-TC-Region；跨地域必传，禁止写进 params
  "params": { "Page": 1, "Rp": 50 }
}
```

- **service 是白名单枚举**：只接受白名单内的产品标识，名单外的取值（对象存储 COS 这类不在云 API 体系内的产品、以及任何拼写错误）会被直接拒绝 —— 不要臆造 service 名、也不要试近义词。与中文名不一致的常见项：云数据库 MySQL 是 `cdb`、日志服务是 `cls`、DNS 解析是 `dnspod`、SSL 证书是 `ssl`。**完整清单（按产品线分组）：[`./service-versions.md`](./service-versions.md)。**
- **version 多数可以省**：只有一个官方版本的产品会按映射表自动补齐（例如 `ssl` → `2019-12-05`）。**只有多版本产品必须显式传** —— `tke`、`mongodb`、`teo`、`vod`、`sms`、`monitor`：缺省会报错并列出可选版本，不会替你猜（猜错会被服务端报成 Action 不存在，很难排查）。
- **最常用的几个**：

  | service | version | 用途 |
  | --- | --- | --- |
  | `tcb` | `2018-06-08` | 云开发环境 / 用户 / 认证 / 函数 / 数据库 |
  | `tcbr` | `2022-02-17` | 云托管 |
  | `scf` | `2018-04-16` | 云函数 |
  | `sts` | `2018-08-13` | 临时密钥与调用者身份 |
  | `cam` | `2019-01-16` | 权限、角色、策略 |
  | `monitor` | `2018-07-24` | 云监控 / 告警策略（多版本） |
  | `postgres` | `2017-03-12` | PostgreSQL |
  | `ssl` | `2019-12-05` | SSL 证书 |
- **前置条件**：首次调用若返回 `ENV_REQUIRED`，先完成环境绑定（`auth` 工具 `set_env`）再重发；这不是云 API 错误，是工具自身的会话状态要求。
- **错误分类**（错误信息前缀决定下一步）：
  - `The parameter 'X' is not recognized` → Action 正确、参数名错；对照官方文档修正字段名/大小写
  - `action ... is invalid or not found` → Action 名未经文档来源确认就发起调用；回官方文档核对后用确认过的名字（实测案例：控制台代理的 `ListRoles` 在官方 CAM 2019-01-16 API 中不存在，真实 Action 为 `DescribeRoleList`）
  - `UnauthorizedOperation / AuthFailure` → CAM 权限不足；走 §3 授权升级
  - `Region is not recognized` → region 传到顶层参数，不放进 params

### 常用 Action 与参数示例（tcb / tcbr）

`tcb`（云开发管控面）：

| 用途 | Action |
| --- | --- |
| 环境管理 | `CreateEnv` / `ModifyEnv` / `DescribeEnvs` / `DestroyEnv` |
| 用户管理 | `CreateUser` / `ModifyUser` / `DescribeUserList` / `DeleteUsers` |
| 认证配置 | `EditAuthConfig` |
| 云函数 | `DescribeFunctions` / `CreateFunction` |
| 数据库 | `CreateMySQLInstance` |

`tcbr`（云托管）：`CreateCloudRunEnv`（初始化）、`DescribeEnvBaseInfo`（查单个环境，`EnvId` 必填）、`DescribeCloudRunEnvs`（查环境列表 / 资源，`EnvId` 可选过滤）、`CreateCloudRunServer` / `DescribeCloudRunServers`。

参数示例：

```json
{ "service": "tcb", "action": "DestroyEnv", "params": { "EnvId": "env-xxx", "BypassCheck": true } }
```

环境已处于隔离期时可再补 `params.IsForce: true`；更新环境别名：

```json
{ "service": "tcb", "action": "ModifyEnv", "params": { "EnvId": "env-xxx", "Alias": "demo" } }
```

跨地域查询时 `region` 走顶层，不要放进 `params`：

```json
{ "service": "tcb", "action": "DescribeEnvs", "region": "ap-singapore" }
```

## §2 代码管控（用户侧脚本/服务）

1. **优先 `@cloudbase/manager-node`**：环境、存储、函数等常见操作有现成方法（https://docs.cloudbase.net/api-reference/manager/node/introduction）。
2. **其他产品走官方 SDK + TC3-HMAC-SHA256 签名**：公共头部 `X-TC-Action` / `X-TC-Version` / `X-TC-Timestamp` / `X-TC-Region`（涉及时）/ `Authorization`；密钥只参与签名，不进 body。SDK 语言细节路由到官方文档（https://cloud.tencent.com/document/api 及各产品 SDK 页）或 sdkHints，不在此复制。
3. 手写签名前先用 **API Explorer**（https://console.cloud.tencent.com/api/explorer）验证参数组合，再落代码。
4. **AI 快速取参数 schema：直接抓 SDK 源码**（腾讯云官方**没有**公开 OpenAPI/Swagger 规范下载，SDK 源码就是最权威的机器可读 schema）。不用管用户用哪种语言，按下面的固定规律**按图索骥**即可：
   - **托管三处，国内用户优先 CNB**：仓库命名 `tencentcloud-sdk-<lang>`（`-python` / `-go` / `-java` 等）。CNB 上挂在 `cnb.cool/tencent/cloud/api/sdk/` 路径下，raw 直链格式是 `/-/git/raw/master/`（不是 `/-/raw/`，用错会返回 404 HTML 但 HTTP 200，极易误判）；GitHub raw 是 `raw.githubusercontent.com/TencentCloud/<repo>/master/`；Gitee raw 是 `gitee.com/TencentCloud/<repo>/raw/master/`。
   - **目录规律**：除 Node.js 外都是 `tencentcloud/<service>/<version>/`；schema 文件就在该目录下（Python `models.py`、Go `models.go`、Java 同包 `<Action>Request.java`）。每个接口一个 `<Action>Request` / `<Action>Response` 定义，字段名、参数名（json tag / 注解）、类型、必填性、注释齐全；同目录的 client 文件（`<service>_client.py` / `client.go`）可确认该 service 的 Action 全集。
   - **Node.js 特例**：按服务 npm 分包 `tencentcloud-sdk-nodejs-<service>`，types `.d.ts` 就是 schema；源码在 `tencentcloud-sdk-nodejs` 仓库 `src/services/<service>/<version>/` 下。
   - **不确定语言或路径时**：先抓仓库根目录的文件列表（GitHub API `https://api.github.com/repos/TencentCloud/<repo>/contents/tencentcloud`）确认实际结构，不要凭猜构造 URL；各仓库根路径 `examples/` 有每接口调用示例。
   - 已实测锚点（Python 与 Go 结构完全同构）：
     `https://raw.githubusercontent.com/TencentCloud/tencentcloud-sdk-python/master/tencentcloud/monitor/v20180724/models.py` → `CreateAlarmPolicyRequest` 结构体直接可读。

## §3 权限：先认凭据身份，再给一键授权链接

### 3.1 权限来自谁

管控面调用「没权限」，先看是哪种凭据在调用 —— 三种身份的权限来源不同：

| 凭据身份 | 实际调用者 | 权限来自 | 不足时怎么补 |
| --- | --- | --- | --- |
| 账号级登录（device code / OAuth STS / 腾讯云密钥） | 登录的用户 / 子账号本人 | 该身份自身的 CAM 策略 | 由主账号给**这个子账号**追加策略（控制台操作） |
| 环境级 API Key | 服务端固定模型 | 单环境数据面 + 固定的 TCB 策略 | **没有为单个 Key 追加任意 CAM 策略的通道** —— 换账号级凭据，或走下面的角色路线 |
| CLI / MCP 用 TCB 服务角色换取的临时密钥 | 角色（`TCB_QcsRole` 等） | 挂在**角色**上的策略 | 给**角色**追加策略（一键授权链接） |

TCB 服务角色族挂的是 TCB 自己声明的策略集（`QcloudAccessForTCBRole` 等），跨产品能力覆盖到哪一步由这份策略决定；`TCBMonitor_QCSRole` 只覆盖 `monitor:GetMonitorData`（拉指标）。所以跨产品调用报 `UnauthorizedOperation` 是预期内的，不是配置出错 —— 先按上表确认你的凭据属于哪一行，再决定给谁补策略。

自己在哪一行，用 `auth(action="status")` 看 `credential_scope`：`account` = 账号级登录，`single_env` = 环境级 API Key。

**角色挂载的策略会随产品迭代变化**，别照着文档里的旧结论判断。确认当前覆盖范围要现场读，但**读 cam 需要调用身份自己就有 cam 策略**：

1. `ListAttachedRolePolicies`：看角色挂了哪些策略
2. `GetPolicy(PolicyId=…)`：直接回 `PolicyDocument` —— 一段**字符串**，二次解析后看 `statement[].action`；`GetPolicyVersion` 也能读，但 `VersionId` **必须是数字**（传字符串报 `InvalidParameter ... should be uint64`）

⚠️ **能不能读，取决于调用那一刻的身份，而不是「登录时是谁」**：账号级身份（`federated-user`）下 `GetRole` / `ListAttachedRolePolicies` / `ListPolicies` / `GetPolicy` 都**能调通**（2026-10-12 实测）；一旦调过云开发产品接口、身份被换成 `TCB_QcsRole`，同一批调用全被拒（`resource (*) has no permission`）。⇒ **要读 cam 就先读 cam**；真读不了再让用户换一个有 `QcloudCamReadOnlyAccess` 的身份。读不了不影响 §3.2 —— 那里的 `principal` 用固定值。

**确认「我到底是谁」用 `sts/GetCallerIdentity`，不依赖 cam**：返回 `Type`（`CAMRole` / `Account`）、`Arn`、`UserId`；以 `TCB_QcsRole` 调用时 `UserId` 形如 `<ownerUin>:TCB_QcsRole-<uin>-<timestamp>`。哪一行身份由此判定，比 `credential_scope` 更准 —— `credential_scope: account` 只说明「不是环境级 API Key」，实际落地仍可能是角色扮演身份。

临时密钥用于代码侧调用：`auth(action="get_temp_credentials", confirm="yes", reveal=true)` 返回明文 STS 三元组，直接喂官方 SDK / TC3 手工签名，即 §2 代码管控路径。

### 3.2 一键授权链接（交给用户点一下）

调不通、且身份落在上表「服务角色」那一行时，直接给用户一条链接，比让他自己去 CAM 里找入口快得多 —— 控制台自己就是这么做的：捕获到 `AuthFailure.UnauthorizedOperation` 且 message 含 `Check your CAM policies` 后弹「CAM 授权提示」，点「前往 CAM 授权」跳的就是这个页面。

```
https://console.cloud.tencent.com/cam/role/grant?roleName=<角色名>&policyName=<策略名>&principal=<URL 编码后的 base64>&serviceType=<展示用>&s_url=<授权后回跳地址>
```

| 参数 | 必填 | 说明 |
| --- | --- | --- |
| `roleName` | 是 | 要补策略的角色，如 `TCB_QcsRole` |
| `policyName` | 是 | 预设策略名。**可以逗号连接多个**（`A,B,C`），一条链接一次挂多个 —— 控制台建角色时就是把 5 个策略拼成一条 |
| `principal` | 是 | 角色载体的 base64，见下表 |

## README

# Recipes — 实证工作流索引

**一个场景一篇文档**，新增 recipe 时在本目录新建 `<场景名>.md`，并登记到下方目录表。**编号取目录表里当前未被占用的下一个**，并让它同时出现在三处：文件名（信息性）、文件首行的 `# Recipe N — 标题`、目录表首列。三处不一致或编号与别人撞车会直接让 `tests/skill-recipes-numbering.test.js` 变红（多人并行加 recipe 时最容易撞的就是这个）。

每个 recipe 固定结构：**When to use → 前置权限 → 接口序列 → 踩坑清单 → 验证步骤**（入口特殊的可加「入口」一节）。`When to use` 写可判定的触发条件（出现什么症状就该翻这篇），并用一句划出本篇不管什么、该转哪去。

正文只写使用者照着做什么：**不写出处与验证过程**（取自哪份文档/源码、比对过哪些版本、我们怎么核对的），**不留维护者待办**；可信度只记在下表「状态」列：

- `✅ 生产实证（日期）` = 接口序列已在真实环境端到端跑通
- `🟡 部分实证（日期）` = 只跑通了其中一部分路径，**未跑到的部分必须写在这一列里**；引用未跑到的步骤时按「文档核对」的谨慎度处理
- `🟡 文档核对，未实跑` = 接口序列尚未在真实环境跑过，先按「验证步骤」做只读自检再用

一篇 recipe 里「跑过」与「没跑过」混着是常态（写操作要真实破坏、权限或计费限制都可能挡住）。分档写清楚，比给整篇贴一个 `✅` 更省事：后者会让未验证的那几条也一起被高置信采信。

「实测」是**值级**标记：贴在某个参数、接口或返回值上，最多一个，未标注的按官方文档核对后再用。不要给整节或整表贴「（全部实测）」这类状态括注——它没有逐行分辨率，不能改变任何具体动作，而后来补进未验证内容时会继承这个标签，正好让 AI 高置信采信未验证的东西。

## 目录

| # | Recipe | 文档 | 状态 |
| --- | --- | --- | --- |
| 1 | PostgreSQL 存储空间使用率告警 | [pg-storage-alarm.md](./pg-storage-alarm.md) | ✅ 生产实证（2026-09-08） |
| 2 | ICP 备案提交前自查与等待期查询 | [icp-filing-readiness.md](./icp-filing-readiness.md) | ✅ 生产实证（2026-09-21） |
| 3 | PostgreSQL 实例变配与升级独享 | [pg-instance-spec.md](./pg-instance-spec.md) | 🟡 部分实证（2026-10-16）：`ModifyPGInstanceSpec` 升配 + 降配已跑通；**共享升独享已跑通**（标准版环境 → `1 核 2 GiB` + 10 GB，`SwitchTag: 0`，约 2 分 49 秒到 `Succeed`，规格与 `TenantType` 均已复核；个人版环境的套餐拒绝报错原文已取得）；**未跑**——套餐准入在「标准版以上」各档逐个验证（现有结论来自内部口径）、`SwitchTag: 1` 指定时间切换、独享 → 共享（文档明确不支持）；「费用与套餐」一节的资源点单价、以及「目标 = 现状回 `unchanged`」按文档与界面核对，**未实跑** |
| 4 | 自定义域名接入云开发 | [custom-domain.md](./custom-domain.md) | 🟡 部分实证（2026-09-24）：现状查询、只读预检、证书读取、真实绑定与解绑（含收尾）已跑通；**未跑**——轮询到 `Status = SUCCESS`（测试域名一直停在 `PROCESSING`）、代改 DNS 解析、备案（`dnspod` / `ba` 未授权） |
| 5 | 云开发环境的操作追溯（操作审计） | [cloud-audit-operation-trace.md](./cloud-audit-operation-trace.md) | 🟡 部分实证（2026-10-12）：账号级身份下的 `LookUpEvents` 只读查询、`cam AttachRolePolicy` 挂 `QcloudAuditReadOnlyAccess`（挂后 `ListAttachedRolePolicies` 复核条数 +1）已跑通；**未跑**——`DescribeEvents` 全序列、`GetAttributeKey`、以及**角色态（`TCB_QcsRole`）下 `cloudaudit` 是否可见**（要等一个走角色态的 MCP 会话才能验） |
| 6 | 资源点耗尽与停服报错的判别 | [credits-exhaustion.md](./credits-exhaustion.md) | 🟡 文档核对，未实跑（2026-10-15）：判别序列与恢复路径按官方计费文档与套餐规则整理，**未在资源点耗尽的环境上实跑**；`InsufficientBalance` 的触发条件、以及无 `billing` 权限时账户余额查询的报错形态，先按「验证步骤」只读自检再用 |
| 7 | 平台版接入：建环境、发凭证 | [platform-onboarding.md](./platform-onboarding.md) | 🟡 文档核对，未实跑 |
| 8 | 把环境接到用户的 Agent | [platform-agent-connect.md](./platform-agent-connect.md) | 🟡 文档核对，未实跑 |
| 9 | 收口 Agent：工具裁剪、封装审计、专家约束 | [platform-agent-guardrails.md](./platform-agent-guardrails.md) | 🟡 文档核对，未实跑 |
| 10 | 平台版用量、账期与环境回收 | [platform-usage-and-recycle.md](./platform-usage-and-recycle.md) | 🟡 文档核对，未实跑 |
| 11 | 计费口径自查：为什么这笔费用会出现 | [billing-charges-explained.md](./billing-charges-explained.md) | 🟡 文档核对，未实跑（2026-10-15）：三套计费体系的口径（云托管免费额度为 3 个月总量、实例数不为 0 即计费、次日扣费；云开发资源点抵扣顺序；成长计划 Token 的来源限制）逐条取自官方文档；**未对真实账单逐项复算**，先按「验证步骤」只读自检再用 |

## 没有独立 recipe 的场景

- **MySQL / CVM 等依赖产品告警**：复用 Recipe 1 的框架，换 monitor namespace。
- **MySQL 备份回档、SCF 函数触发器**：暂无 recipe，从 `api-reference` 的依赖产品段起查。

## billing-charges-explained

# Recipe 11 — 计费口径自查：为什么这笔费用会出现

## When to use

用户对账单有疑问时：

- 「没经过我确认就扣费」/「找不到退订入口」
- 「免费额度明明没用完，怎么提示欠费」
- 「Token 包没抵扣，反而扣了资源点」
- 「我只买了月付，怎么续成一年」

管到「说清这笔用量由哪套计费体系产生、去哪查明细」为止。

- 环境**停服 / 资源点耗尽**的判别与恢复不在本篇，转 [Recipe 6](./credits-exhaustion.md)
- 退款、发票、订单争议走控制台与费用中心，**本篇不代下单、不代退款**（见「边界」）

## 三套计费体系，先分清是哪一套

同一个账号下可能同时存在三套计量，混在一起讲就是"算不清"的来源。

| 体系 | 谁产生用量 | 什么条件下计费 | 额度 / 免费 | 明细去哪看 |
| --- | --- | --- | --- | --- |
| **云开发资源点（套餐）** | 云开发环境的数据库读写、云函数调用与资源、存储与 CDN、网关/认证调用、日志、内置 AI 模型 Token | 每次调用与流量，**实时计量**（用量统计有更新周期，不超过 2 天） | 免费体验版 **3,000 点/月**（**不支持**资源包与按量）；个人版 40,000 点/月起，支持资源包加购与超限按量；**余额低于 10% 时发送告警** | 控制台「套餐用量」页；接口侧 `manageEnv(action="usage")` |
| **微信云托管按量** | 微信云托管环境的容器、构建、MySQL、对象存储、CDN | 容器：**环境中任意服务下任意版本，实例数量不为 0 就按 CPU/内存 × 时长计费**；另有构建时长与流量 | 首个环境赠送免费额度，**有效期 3 个月（是总量，不是每月额度）** | 微信云托管控制台 → 费用中心 → 充值与账单 |
| **AI Token 额度** | 小程序 AI 调用（`wx.cloud.extend.AI`） | 按 Token 消耗结算 | 小程序成长计划赠送的 Token **仅限「小程序端调用」与「管理员身份调用」**（含控制台体验、云函数内调用） | 云开发控制台 → AI 模块 → 各模型 Token 消耗 |

换算与顺序（云开发侧）：**1,000 资源点 ≈ 1 元**；抵扣顺序 **套餐资源点 → 资源包 → 按量计费**，互不替代——买了资源包不会补回已耗尽的套餐额度，也不会冲掉已产生的欠费。

结算节奏：云托管是**每日结算、次日扣费**（特殊情况可能延迟几天，但不超过当月最后一天）；云开发资源点在用量统计完成后抵扣。

## 四条最常被误读的口径

1. **「额度没用完却欠费」——多数是两套额度被当成一套**。微信云托管的免费额度是**有效期 3 个月的总量**，不是每月刷新；把"三个月总量"当"每月额度"看，就会觉得"才用了一点怎么就超了"。
2. **「我什么都没跑，怎么一直计费」**——云托管容器**实例数不为 0 就计费**，与有没有人访问无关。要停就停实例（缩容到 0）。
3. **「充了钱怎么还是不行」**——充进的是**腾讯云账户余额**，它与环境资源点/套餐额度是**两个独立维度**；余额为正不代表环境有可用资源点。恢复环境要按 [Recipe 6](./credits-exhaustion.md) 的三条路径走。
4. **「Token 包没抵扣」**——先确认**调用来源**是否在赠送 Token 的适用范围内（仅小程序端调用与管理员身份调用）。来源不符时请求会落到资源点池，看起来像"没抵扣"。

## 自查顺序（只读）

| 步 | 查什么 | 用什么 |
| --- | --- | --- |
| 1 | 环境当期资源点用量与计费周期 | `manageEnv(action="usage")`（透传计费周期 + 分模块用量） |
| 2 | 环境计费信息（到期时间、套餐） | `queryEnv(action="info")`；或 `DescribeBillingInfo` |
| 3 | 账户侧余额（排除欠费，不是找充值理由） | `callCloudApi`（`billing` / `DescribeAccountBalance`） |
| 4 | AI 侧 Token 消耗与来源 | 控制台 AI 模块；`DescribeAIModels` 看已启用的模型与分组 |

拿到 1-4 后，把结论落成三句话：**是哪套计费体系的用量、口径是什么、去哪个控制台页看明细**。

## 边界

- **不代下单、不代退款、不提供充值通道**：退款与发票在控制台 / 费用中心，订单争议走工单
- 子账号或托管授信用户可能**没有计费权限**——给链接并说明「转主账号管理员处理」，不要反复重试
- 用量数字有更新周期，**不要拿刚发生的几分钟去对账**；对不上时先看统计窗口

## 验证步骤

1. 跑 `manageEnv(action="usage")`，确认能拿到当前计费周期与分模块用量。
2. 按「三套计费体系」表判断用户描述的用量属于哪一套——判错体系，后面全错。
3. 把对应控制台入口给用户，让其自行核对账单明细（机器人/客服侧同样适用这套口径）。

## cloud-audit-operation-trace

# Recipe 5 — 云开发环境的操作追溯（操作审计）

## When to use

需要回答**「谁、在什么时候、从哪个 IP，对我的云开发环境或它的资源做了什么操作」** —— 凭据被谁用过、某个环境/函数/数据库/域名是谁删的、配置被谁改的、某个操作到底发生过没有。

典型症状：

- 客户报「我的环境/配置莫名其妙变了或被删了」，要查操作来源。
- 排查异常调用：想知道某个 AccessKey 在某个时间窗内都调了什么。
- 合规/交付场景要导出一段时间内的管理面操作清单。

**本篇不管什么**：

- **数据面的业务请求**（用户访问你的云函数、数据库读写、HTTP 访问）→ 那是运行/网关日志，走日志服务查，本篇的接口查不到。
- 环境自身的运行报错与性能问题 → 走日志与监控。
- 本篇只解决**管理面云 API 调用**的追溯。

## 前置权限

| 项 | 值 |
| --- | --- |
| service / version | `cloudaudit` · `2019-03-19` |
| 开通与计费 | **无需开通、免费** —— 账号创建时即自动启用，查看/检索事件历史不额外计费 |
| 凭据身份 | **必须是账号级**，且**当前工作目录不能残留项目级凭据**。审计按**账号**记录，与环境无关：环境级凭据（环境 API Key / 托管授权 token）到不了；被换成服务角色 `TCB_QcsRole` 时也到不了。两者都要先认人再动手 |
| 查询所需策略 | `QcloudAuditReadOnlyAccess`（`PolicyId` `4732274`），覆盖 `cloudaudit:List*` / `Describe*` / `Get*` / `Look*`（`LookUpEvents` 属 `Look*`），另带 `cam:DescribeRoleList`、`cls:DescribeLogsets`、`cos:GetService` 等只读。**只查事件用这条就够** |
| 跟踪集管理所需策略 | `QcloudAuditFullAccess`（`PolicyId` `638468`），比只读版多出跟踪集管理。**仅在需要建/改跟踪集时才加**：`TCB_QcsRole` 是全平台共用的服务角色，能不给写权限就别给 |

### 先认人：三类凭据，权限面完全不同

被拒时**先 `pwd`，再 `sts/GetCallerIdentity`** —— 身份类型直接决定后面补什么：

| 凭据形态 | 落地身份（`Type` / `UserId`） | `cloudaudit` | 要补什么 |
| --- | --- | --- | --- |
| **账号级登录**（控制台扫码 / 设备码 / `tcb login`），且当前目录无残留凭据 | `CAMUser` · `federated-user/<uid>` | **通** | 不用补 |
| **账号级登录，但被换成服务角色** | `CAMRole` · `TCB_QcsRole-<uin>-<ts>` | 拒（`resource (*) has no permission`） | 给**角色**关联 `QcloudAuditReadOnlyAccess`（改信任策略没用） |
| **环境级（单环境）凭据**：环境 API Key / 托管授权 token | `CAMUser` · `<uin>:TCB-CAPI-Configured-idaas-apikey` | 拒（报错与角色被拒**长得一样**，根因不同） | 补策略没用，**必须换账号级凭据** |

两条机制各判一半：

1. **凭据按「项目根」分级解析，项目槽里那份优先于全局登录态。** 三层顺序：① 项目槽 `~/.config/.cloudbase/projects/<项目根路径转义>/auth.json`（**只在存着真凭据时生效**）→ ② 全局槽 `~/.config/.cloudbase/auth.json` → ③ 环境变量（`CLOUDBASE_API_KEY` + `CLOUDBASE_ENV_ID`，其次 `TENCENTCLOUD_SECRETID` / `KEY` / `SESSIONTOKEN`）。
   - **槽按「项目根」定位，不是按当前目录**：从 `cwd` 向上找 `cloudbaserc.json` / `cloudbaserc.js` / `.cloudbaserc` / `.git`，到 `$HOME` 为止，找不到就用 `cwd` 本身；目录名 = 该绝对路径里非字母数字全换成 `-`。⇒ **同一个仓库里换子目录没用**，仍是同一个槽；要拿到干净解析得换到**仓库外**没有 marker 的目录。
   - **空槽不遮蔽**：首次运行留下的 `{}` 不影响解析，会正常落回全局槽（已实测）。真正抢先的是槽里那份**环境级 API Key** —— 命中它时全局登录态**根本不会被读取**。
   - ⇒「我在别的目录登录过、这里却说是单环境」「登录了却只看得见一个环境」基本都是这条：先确认当前目录属于哪个项目根，再看那个项目的槽里存的是什么。
2. **调云开发自己的产品接口会把身份换成服务角色。** 同一份账号级登录，**先查审计是通的**；调用过 `tcb` / `tcbr` 系接口之后，再回来查审计就可能已被换成 `TCB_QcsRole` 而被拒。
   - ⇒ **要查审计就先查审计**；把顺序反过来是自己给自己制造「没权限」。

⇒「换个客户端试试」可以划掉：MCP、SDK、命令行走的是同一套凭据解析，病根在凭据本身（目录槽 + 是否被换成角色），不在客户端。

**三种错误形态，别混判**：

| 错误 | 形态 | 含义 |
| --- | --- | --- |
| `AuthFailure.UnauthorizedOperation`（`resource (*) has no permission`） | 带 `RequestId` | **已经到服务了**，是 CAM 拒绝 —— 要补权限 |
| `invalid token`（`RequestId: 0`） | 无有效 `RequestId` | **接入层就拦了**，凭据对不上这条链路 —— 换凭据，不是补策略 |
| `InvalidAction` | 带 `RequestId` | action 名或 `version` 写错。反过来，拿到 `AuthFailure` 就说明这个 action 存在 |

最小「认人 + 试查」，只给 `service / version / action / params` 四件套：

| 步 | service / version | Action | params |
| --- | --- | --- | --- |
| 认人 | `sts` · `2018-08-13` | `GetCallerIdentity` | 无 |
| 试查 | `cloudaudit` · `2019-03-19` | `LookUpEvents` | `{"StartTime":<整数秒>,"EndTime":<整数秒>,"MaxResults":3}` |

> **本篇与通道无关**：所有调用只写到 `service / version / action / params`，不绑定客户端 —— MCP 用 `callCloudApi` 传这四项、SDK 用对应产品的同名方法与同一段参数、命令行用 `tcb api <service> <Action> --body '{…}'`，三者入参与结论一致，任选其一即可。仅在命令行下要注意 `version` 必须显式给，不给会落到错误默认版本（例如 `sts` 被当成 `2018-04-16`，报 `InvalidAction`）。

### 给服务角色补权限（身份已是 `TCB_QcsRole` 时）

**要授的是「调用方身份所属账号」**，不是「用户控制台当前登录的账号」，两者经常不是同一个。`sts/GetCallerIdentity` 一次返回两个账号，别只看一个：`AccountId` 是**角色宿主主账号**（资源与环境在它名下），`PrincipalId` 是**申请该角色密钥的账号**（真正的调用方）。控制台要切到 `AccountId` 那个账号，并**优先用角色名定位，别用 `roleId`** —— `roleId` 是账号内资源，跨账号必然报「未查询到相关角色」。若该账号用户本人拿不到（MCP 走平台侧托管账号时就会这样），这条路直接不通：要么请账号主人在其上挂策略，要么改用「用户自己账号 + 自建**账号级**（非环境级）API Key」。

- ① **一键授权链接（首选）** —— 交给用户点一下，是这条路的**规范做法**（链接怎么拼、`principal` 取值表、两条边界都在 `../calling-methods.md` §3.2，不在这里重复）。本次要挂的就是把 `policyName` 换成审计只读：

  ```
  https://console.cloud.tencent.com/cam/role/grant?roleName=TCB_QcsRole&policyName=QcloudAuditReadOnlyAccess&principal=eyJzZXJ2aWNlIjpbInRjYi5jbG91ZC50ZW5jZW50LmNvbSJdfQ%3D%3D
  ```

- ② **调用 cam API 直接挂**（可重复执行，不用等人点；要求当前是**账号级身份**，否则自己也会被拒）：

  | 步 | service / version | Action | params | 取什么 |
  | --- | --- | --- | --- | --- |
  | 1 | `cam` · `2019-01-16` | `ListPolicies` | `{"Scope":"QCS","Keyword":"Audit","Page":1,"Rp":50}` | 预设策略的 `PolicyId`（`QcloudAuditReadOnlyAccess` = `4732274`） |
  | 2 | `cam` · `2019-01-16` | `AttachRolePolicy` | `{"AttachRoleName":"TCB_QcsRole","PolicyId":4732274}` | 只回 `RequestId`，**不代表已生效** |
  | 3 | `cam` · `2019-01-16` | `ListAttachedRolePolicies` | `{"RoleName":"TCB_QcsRole","Page":1,"Rp":100}` | 条数 +1，且能列出刚挂的那条 |

  三个 action 的入参就是上表，换通道只是换发送方式：MCP 走 `callCloudApi`（`service` / `action` / `version` / `params` 四项）、SDK 走 `cam` 客户端的同名方法与同一段参数、命令行走 `tcb api cam AttachRolePolicy --body '{…}'`。

  ⚠️ `ListPolicies` 要带 `Scope: QCS`（不带搜不到预设策略）；**关联的参数名是 `AttachRoleName`，复核的参数名又叫 `RoleName`**。**挂完之后立刻复核**（理由见下）。

- ③ **控制台手动关联**（需要**主账号**或**拥有访问管理读写权限**的账号）：

  ```
  https://console.cloud.tencent.com/cam/role?roleName=TCB_QcsRole
  ```

  页内两条路都行：**角色详情 → 关联策略**，或**策略页搜策略名 → 关联用户/组/角色**。

**挂完怎么确认（有两个验证死角）**：

- **没法在本地扮演该角色做端到端验证**：`sts:AssumeRole` 必被拒（该角色的信任策略 `principal` 只写了服务）；`cam:SimulatePrincipalPolicy` 报 `InvalidAction`（该 action 不存在）。
- ⇒ 判据只能落在两件确定性事实上：**策略已挂**（`ListAttachedRolePolicies` 条数 +1）与 **action 被覆盖**（策略正文里能看到 `cloudaudit:Look*`）。
- 读策略正文（都要求账号级身份）：`cam/GetPolicy`（`{"PolicyId":4732274}`）直接回 `PolicyDocument`，是一段**字符串**，二次解析后看 `statement[].action`；`cam/GetPolicyVersion` 多要一个 `VersionId`，且**必须是数字**（传字符串报 `InvalidParameter ... should be uint64`）。
- 🔴 **挂完立刻复核**：任何客户端会话（MCP / SDK / CLI）都可能把内存里的旧凭据快照写回凭据槽，隔几分钟当前身份可能已经不是刚才那个了，跨窗口的复核结论不可信。

边界与备注：

- **给服务角色加策略 = 扩大该角色的权限面**，不只是「让这一次调用通过」—— 拿到该角色临时密钥的任何调用方都会带上这份新权限，能用只读就别上全读写。
- **能不能用 `cam` 读接口「现场判断缺什么」，取决于当前身份**：账号级联邦身份（`federated-user`）可直接调通 `cam:GetRole` / `ListAttachedRolePolicies` / `ListPolicies` / `ListPolicyVersions`；换成 `TCB_QcsRole` 角色态后同样被拒。⇒ 「想查清缺什么权限」本身就要求先有账号级身份，**先 `pwd` + 认人**。
- **初始状态参照**：某账号的 `TCB_QcsRole` 起步挂 6 条策略（MongoDB / PostgreSQL / TCR / Lighthouse / CloudBase Run 等云开发自身资源），**一条 cloudaudit 都没有** —— 所以「调云开发没问题、查审计却没权限」是这个角色的常态，不是配置出了问题。
- **判断「现在挂在哪个账号」有两个入口**：① `sts/GetCallerIdentity` 的角色链（`Type` / `AccountId` / `PrincipalId` / `UserId`）；② `cam/GetUserAppId` 返回 `OwnerUin` 与 `AppId`，比读角色更直接。两者都不告诉你账号名，只能拿数字去核对。

控制台入口（人工核对与浏览）：`https://console.cloud.tencent.com/cloudaudit` → 左侧**操作记录**。控制台的「操作记录」**默认就有数据**，不要求先建跟踪集；跟踪集（最多 5 个）用于把日志**投递**到 COS 或 CLS 做长期归档，需要更长留存时才要碰它。

## 接口序列

### 1. 选一个检索接口

云审计有**两个**检索操作日志的接口，能力不同，按需求选：

| 接口 | 单次时间跨度 | 可回溯 | `NextToken` 类型 | 检索维度 |
| --- | --- | --- | --- | --- |

## credits-exhaustion

# Recipe 6 — 资源点耗尽与停服报错的判别

## When to use

业务请求开始失败，怀疑是环境的计费状态问题时：

- 云函数调用返回 `InsufficientBalance`（HTTP 410），或数据库写入返回 `EXCEED_REQUEST_LIMIT`
- 用户说「我充值了，还是不行」「是不是账号欠费了」
- 静态托管 / 网关 / 认证 / 内置模型调用大面积失败，看起来像「整个环境停了」

管到「判定是哪一种停服原因、把恢复路径讲清楚」为止。

- 本篇**不代下单、不代变配、不提供充值通道**：购买与充值由用户在控制台完成（原因见「权限分支」）
- 报错码的通用排障协议（先查官方错误码含义再行动）见 `../../../cloudbase-platform/SKILL.md` 的错误码排障一节
- 云函数自身的运行时报错（`430` 用户代码异常、`433` 超时等）不看本篇，去函数日志

## 判别序列（全只读）

先取证，再下结论。两条证据必须都拿到，只看一条就会误判。

| 步 | 查什么 | 用什么 | 看什么 |
| --- | --- | --- | --- |
| A | 环境当期资源点用量 | `manageEnv(action="usage")` | 当周期（计费周期）分模块的 `CreditsValue`；明细里 `DeductValue`（已抵扣）/ `PackageDeductValue`（资源包抵扣）。看**当期合计是否已达到套餐额度** |
| B | 套餐与有效期 | `queryEnv` 的环境信息 | 当前套餐名与到期时间。**免费体验版 = 3000 点/月**，与付费套餐的额度不是一个量级 |
| C | 账户侧 | `callCloudApi`（`billing` / `DescribeAccountBalance`，只读） | 账户余额是否为正。这一步是为**排除**欠费，不是找充值理由 |

拿到 A/B/C 后按下表落结论，不要停在前两步就猜。

## 四分支决策表

| 分支 | 判别特征 | 一句话结论 | 恢复动作 |
| --- | --- | --- | --- |
| **免费体验版资源点耗尽** | A 显示当期用量已达 3000 点量级；B 显示免费体验版；C 余额为正 | 资源点用完了，**不是欠费** | **升级为付费套餐**（唯一途径） |
| **付费套餐资源点耗尽**（超限停服） | A 显示用量耗尽；B 显示付费套餐且在有效期内 | 套餐内资源点用尽，环境已超限停服 | 升配套餐 / 购买资源包 / 开启按量计费，**三选一**（见下表建议） |
| **套餐到期** | B 显示已过期 | 套餐过期进入停服隔离期 | 隔离期内续费找回；逾期环境被销毁、数据不可恢复 |
| **账户欠费** | C 余额为负 | 账户欠费 | 费用中心充值冲正。**注意**：套餐仍有效且环境还有资源点时，业务不受影响，只是无法续费/变配 |

### 付费套餐耗尽时怎么选

| 用量形态 | 建议 |
| --- | --- |
| 短促尖峰（活动、大促） | 购买资源包，按量冲高那几天靠它抵 |
| 持续高位、长期增长 | 升配套餐，单位成本更低 |
| 波动大、说不准 | 开启超限按量，用多少扣多少（次日结算） |

## 超限按量开关（`EnableOverrun`）

**默认是关的**。关着的时候，套餐内资源用量耗尽即**直接停服** —— 数据库、云函数、云存储等所有服务不可用，不是"降级"也不是"只读"。官方的原话是「**强烈建议所有生产环境开启此功能**」。

- 开启后：超出套餐额度的部分自动转为按量计费，业务不中断
- 两种开法：购买时（`CreateEnv` 传 `EnableOverrun: "TRUE"`，一步到位）；购买后（改环境附加信息的接口，传 `EnvId` + `EnableOverrun: TRUE/FALSE`）
- 所以**付费套餐耗尽那一支，最省事的止血动作是先把开关打开**，再谈升配还是买资源包
- 口径出处：https://docs.cloudbase.net/solutions/cloudbase-for-platforms/quota

⚠️ 免费体验版**不能**开按量、也不能买资源包（见「踩坑清单」），别对体验版用户提这个开关。

## 恢复入口

- **套餐 / 资源包 / 超限按量**：云开发控制台 `https://tcb.cloud.tencent.com/dev?envId=<envId>` 的**套餐用量页**——升级套餐、购买资源包、开启超限按量都在这一页
- **价格与规则**：https://buy.cloud.tencent.com/price/tcb/overview
- **账户充值**：腾讯云费用中心 https://console.cloud.tencent.com/expense

## 权限分支

使用者可能是**子账号**或经托管授信登录的用户，未必有计费权限。这时：

- 正常做法是**给出上面三个入口链接**，并说明「没有计费权限时请转给主账号管理员处理」
- 不要因为调用失败就反复重试，也不要尝试代为下单或支付——计费类写操作（下单、支付）不该由工具代执行
- 子账号自己确认权限范围看 CAM：https://console.cloud.tencent.com/cam

## 踩坑清单

- **`InsufficientBalance` 不一定指账户欠费**。云函数状态码表把它解释为「账号余额不足，请充值后重试」，照做往往无效：可用量由**环境资源点**决定，账户余额是另一个独立维度。
- **不只是云函数**。资源点覆盖数据库读写、云存储/CDN 流量、网关与认证调用、日志、以及 CloudBase 内置模型的 Token——任一模块耗尽都会表现为「业务请求失败」。看到大面积失败时按资源点查，不要逐个模块归因。
- **抵扣顺序是套餐资源点 → 资源包 → 按量计费**，互不替代。买了资源包不会自动补上已耗尽的套餐额度、也不会冲掉已产生的欠费。
- **换算**：1000 资源点 ≈ 1 元。
- **免费体验版不支持加购资源包，也不支持开启按量计费**。给体验版用户推荐「买资源包」是无效建议，唯一途径是升级付费套餐。
- **套餐名固定这几个**：免费体验版 / 个人版 / 标准版 / 企业版 / 企业高级版。没有「专业版」这类叫法。
- **用量统计有更新周期**（不超过 2 天）。刚耗尽的那几个小时里，用量页看到的数字可能还没反映到最新，别据滞后数字下「还有余量」的结论。
- **套餐到期与账户欠费是两件事**：套餐到期会进停服隔离期（15 天后销毁）；账户欠费在套餐有效且有资源点时不中断业务。
- 环境进入停服状态后，控制台部分页面也会不可用，此时以「到期时间 + 资源点用量」两条证据判断，不要等控制台恢复。

## 验证步骤

1. 先跑 A：`manageEnv(action="usage")`，确认能拿到当前计费周期与分模块 `CreditsValue`。
2. 再跑 C：账户余额查询返回数值（无 `billing` 权限会报权限错，按「权限分支」处理）。
3. 两条证据对照四分支决策表，落到唯一结论；结论里要能回答「是不是欠费」——**答错的代价就是用户去充值**。
4. 恢复动作交给用户在控制台执行；执行后重跑 A + C 复核用量与余额状态。

## custom-domain

# Recipe 4 — 自定义域名接入云开发

## When to use

要让用户的**自有域名**指向云开发上的服务（静态托管 / 云函数 / 云托管）时：

- 要把 `www.example.com` 接到自己的站点
- 已经绑过域名但访问不了，要定位卡在哪一步（归属权 / 证书 / 解析 / 备案）
- 环境还没有自定义域名，要先弄清「能不能绑、需要先做什么、绑完多久生效」

管到「域名在云开发侧接入成功、能访问」为止。

- 绑定 / 解绑 / 改域名的**工具选择**在 `../../../cloudbase-platform/SKILL.md` 的域名工具对照表
- 控制台的图形化步骤（带截图）在 https://docs.cloudbase.net/service/custom-domain
- **ICP 备案**的提交前自查与等待期查询转 [Recipe 2](./icp-filing-readiness.md)；买域名 / 实名 / 加解析在域名侧控制台，不在本 recipe 的接口序列里（原因见「前置权限」）

## 前置权限

| service | 用途 | 账号级身份 |
| --- | --- | --- |
| `tcb` | 自定义域名的预检 / 绑定 / 解绑 / 查状态 | 可用 |
| `ssl` | 按域名检索证书（绑定要 `CertId`） | 可用 |
| `domain` | 域名注册：查可注册性、价格、下单、信息模板 | **未授权**（`qcs::domain::uin/<uin>:domainId/* has no permission`） |
| `dnspod` | 解析记录的增删查 | **未授权** |
| `ba` | 备案订单 / 主体 / 域名状态 | **未授权** |

这张表的用法：**云开发侧（`tcb` + `ssl`）能自己做完；域名侧三段（买、解析、备案）默认做不了**。但「调不通」不等于「这个域名不能用」—— 云开发侧的绑定照旧能走。

实测确认这一点（2026-09-24）：账号级登录、只带 `tcb` + `ssl`，`tcb/CreateHTTPServiceRoute` **一次就绑上了**（域名 + 有效证书）。绑定这一步**不依赖** `domain` / `dnspod` / `ba` 里的任何一家。真正需要域名侧权限的只有两件事：

- 域名的**归属权校验记录还没加**（预检报 `OWNERSHIP_VERIFY_FAILED`）—— 这时要写一条 TXT，得有 `dnspod` 写权限，或让用户自己加
- 接入完成后要**把 CNAME 解析改过去** —— 同上

注意这两件都是**写**。**只读地看解析当前指哪里不需要 `dnspod`** —— 用 `dig` 问公开解析即可（见序列 E）。也就是说：**归属校验已经过了、解析也指对了的环境，AI 可以独立完成绑定和解绑**；缺的从来不是绑定的权限，是 DNS 的**写**权限。

缺权限时先认清是**谁**缺。实测（2026-09-24，账号级 device 登录）：`sts/GetCallerIdentity` 返回 `Type: CAMRole`、`UserId: <ownerUin>:TCB_QcsRole-<uin>-<ts>` —— 调用者是以 **`TCB_QcsRole`** 换来的临时密钥，缺的是挂在**这个角色**上的策略，而不是「用户没授权」。落点定了，补权限就有明确做法（链接拼法与使用边界见 [calling-methods.md §3.2](../calling-methods.md)）：

**加解析** —— 最高频的一段（代加归属校验的 TXT、或接入成功后代加 CNAME）：

- 只读（先看现状、判断解析配对没有）：
  `https://console.cloud.tencent.com/cam/role/grant?roleName=TCB_QcsRole&policyName=QcloudDNSPodReadOnlyAccess&principal=eyJzZXJ2aWNlIjpbInRjYi5jbG91ZC50ZW5jZW50LmNvbSJdfQ%3D%3D`
- 需要**代写**解析记录，把 `policyName` 换成 `QcloudDNSPodFullAccess`，其余不变
- 想让用户授权完跳回原页面，在末尾加 `&s_url=` + URL 编码后的当前地址

两条链接都是**账号下全部域名解析**的口子，给之前先跟用户讲清代价（见 §3.2 的第二条边界）。

**买域名 / 备案这两段故意不给链接**：

- 买域名是**消费操作**。给服务角色开下单权限，等于把花钱的能力交出去 —— 让用户自己在 https://console.cloud.tencent.com/domain 完成。
- 备案不在 CAM 策略体系里，没有「加一条策略就能调 API」的入口，只能走控制台或备案小程序。自查与等待期见 [Recipe 2](./icp-filing-readiness.md)。

给链接时一并说清**用哪个账号点**：授权页要主账号或具备 CAM 写权限的身份登录，子账号点开同样授不了 —— 别只丢一条 URL 就当交代完了。

## 接口序列

### A. 先看环境侧现状（只读）

| 步 | 工具 / Action | 关键参数 | 取什么 |
| --- | --- | --- | --- |
| 1 | `queryGateway(action="listCustomDomains")` | — | `domains[]` 的 `Domain` / `AccessType` / `CertId` / `Status` / `DNSStatus` / `Cname` / `IsDefault` / `Routes[]` |
| 2 | `queryGateway(action="listRoutes")` | `domain` 可选 | 该域名下已有的 `Path` 与 `UpstreamResourceType` / `UpstreamResourceName` |

环境还没有自定义域名时，步骤 1 只会回一条 `Domain: "*"`。它代表**默认 HTTP 域名**（`*.{region}.app.tcloudbase.com`），里面挂着"没指定域名"创建的那些路由 —— 判断「有没有自定义域名」时把它排除，但它的 `Routes[]` 是有效信息，别当成空。

### A2. 两套同形接口，按维度选

域名相关的 action 都有「环境维度」和「平台维度」两份，形状几乎一样：

| 维度 | action 前缀 | 关键参数 | 什么时候用 |
| --- | --- | --- | --- |
| 环境 | `*HTTPServiceRoute`（`Create` / `Verify` / `Describe` / `Modify` / `Delete`） | `EnvId` | 给某个云开发环境绑域名 —— **本 recipe 讲的是这套** |
| 平台 | `*PlatformHTTPServiceRoute`（同名五个） | `PlatformId`（如 `pf-t960szfwv1cs`） | 平台统管的域名池 |

平台版有两点不同：**请求地域要按平台选的地域传**（不能跟随 `envId`，否则不符合平台维度语义）；暂时没有域名级自定义 Headers（控制台的「Headers 设置」入口据此隐藏）。别把两套的参数混着传 —— 后果是报参数缺失，很难一眼看出是维度选错了。

### B. 绑定前先跑只读预检

`callCloudApi(service="tcb", action="VerifyHTTPServiceRoute")`：**只读预检，不创建任何资源**。

```json
{
  "EnvId": "<envId>",
  "Domain": {
    "Domain": "www.example.com",
    "CertId": "<ssl 里该域名的证书 ID>",
    "AccessType": "DIRECT",
    "Protocol": "HTTP_AND_HTTPS",
    "Enable": true
  }
}
```

返回九个检查项，每项 `Status`（`PASS` / `FAIL` / `SKIPPED`），失败时带 `Code` / `Message`；`Passed` 是总开关。

| 检查项 | 判定什么 | 什么时候 `SKIPPED` |
| --- | --- | --- |
| `Ownership` | 域名归属权 | — |
| `Cert` | 证书是否存在、是否可用 | `CertId` 传空 |
| `DomainConflict` | 域名是否已被**其他环境**占用 | — |
| `Quota` | 域名 / 路径配额（含套餐能力） | — |
| `RouteConflict` | 同域名下路径是否被占 | 请求里没带 `Routes` |
| `Blacklist` | 域名是否在黑名单 | — |
| `InternalAccount` | 内部域名与当前账号是否匹配 | 不是内部域名 |
| `CDNResource` | 云开发 CDN 资源状态。域名还没接进来时返回 `PASS` + 一句「备案由 CDN 后端在创建时校验」的说明（原话见 E 节） | 未实测 |
| `EO` | 边缘加速域名归属权 | `AccessType` 不是 `EO` |

失败项里 `Code` 的完整取值（照这张表分流，不用逐个试）：

`OWNERSHIP_VERIFY_FAILED` · `OWNERSHIP_DNS_LOOKUP_FAILED` · `CERT_VERIFY_FAILED` · `QUOTA_EXCEEDED` · `ROUTE_CONFLICT` · `DOMAIN_IN_USE` · `NON_INTERNAL_ACCOUNT` · `DOMAIN_IN_BLACKLIST` · `CDN_RESOURCE_PROCESSING` · `CDN_RESOURCE_OFFLINE` · `EO_OWNERSHIP_VERIFY_FAILED` · `EO_DOMAIN_NOT_ICP` · `EO_DOMAIN_IN_USE` · `INTERNAL_CHECK_ERROR`

预检之外，改 / 删域名与路由时另外几个会撞上的错误码：`OperationDenied.HTTPServiceDomainProcessing`（域名处理中，稍后再试）· `LimitExceeded.HTTPServiceRoute`（路由数超上限）· `OperationDenied.HTTPServiceDomainEOFrozen`（EO 域名被冻结，要先充正资源点）· `InvalidParameter.CertVerifyFailed`。

同一环境、四种真实输入下的结果：

| 输入 | `Cert` | `Ownership` | `DomainConflict` | `Passed` |
| --- | --- | --- | --- | --- |
| 自己的域名 + 本域有效证书 | `PASS` | `PASS` | `PASS` | `true` |
| 自己的域名 + `CertId: ""` | `SKIPPED` | `PASS` | `PASS` | `true` |
| 自己的域名 + 不存在的证书 ID | `FAIL` `CERT_VERIFY_FAILED`「证书ID不存在」 | `PASS` | `PASS` | `false` |
| 别人的域名 | `PASS` | `FAIL` `OWNERSHIP_VERIFY_FAILED` | `FAIL` `DOMAIN_IN_USE` | `false` |

## icp-filing-readiness

# Recipe 2 — ICP 备案：提交前自查与等待期查询

## When to use

准备用云开发环境作为备案云资源，或已在备案流程中需要把「能不能提、要等多久、被什么卡住」查清楚时：

- 提交前想知道当前云开发环境够不够格当备案云资源（套餐、剩余有效期、固定 IP）
- 判定出「未开启云托管固定 IP」后，要把它开启（序列 E；前置是环境已开通云托管，没开通先走 0a–0c）
- 想知道**现在能不能提交下一条备案**（同一主体下多条备案不能并行）
- 想知道某个省大概要审多少天、这个省对个人/企业有什么硬性限制
- 想知道某个域名的备案状态（管局是否通过、是否已落地、是否被拦）

本篇覆盖「判定能不能备」和「把环境调到能备（开固定 IP）」，到此为止。**提交备案、上传材料、人脸/视频核身**在腾讯云备案小程序里完成，不走云 API；域名注册 / 实名转 [domain](../service-versions.md)；证书申请转 `ssl`；备案通过后往云开发绑自定义域名转 `manageHosting` / HTTP 网关。

## 前置权限

用到的 service：

| service | version | 用途 |
| --- | --- | --- |
| `tcb` | `2018-06-08` | 读环境准入判定（备案资源与不符合项） |
| `tcbr` | `2022-02-17` | 读 / 改云托管固定 IP 状态（前置：该环境已开通云托管） |
| `ba` | `2020-07-20` | 读备案订单、主体、省份规则、域名状态 |

**凭据身份：账号级。** 备案数据挂在腾讯云账号下，与环境无关 —— 但 `callCloudApi` 有环境绑定门禁，账号级登录后仍需先 `auth(action="set_env", envId=…)` 绑一个环境（任一正常环境即可，不参与备案判定），否则首个调用返回 `ENV_REQUIRED`。

`ba` 的接口是**操作级**授权，而且**结果强依赖凭据所属账号**：备案数据挂在**备案主体所属账号**下，用不含该主体的账号级凭据调用，序列 B–D 的九个只读接口会**全部**返回 `UnauthorizedOperation`（`resource (*) has no permission`）—— action 名被正常识别，卡在策略层，看起来像「这批接口不可用」，其实只是账号不对；换回备案主体所属账号即正常返回数据。所以第一步是确认凭据与备案主体同账号，再给该身份追加 ICP 备案（`ba`）的读权限。链接拼法与角色载体读法见 [calling-methods.md §3](../calling-methods.md)。

官方接口文档：https://cloud.tencent.com/document/api/243/ （请求域名 `ba.tencentcloudapi.com`）。

## 接口序列

### A. 环境够不够格当备案云资源

| 步 | Action | service | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 1 | DescribeICPResourcesInfo | `tcb` | `{ "EnvId": "<envId>" }` | `IcpNotAllowedReason[]`、`ICPResources[]`、`Total` |

**一条调用给出三项准入的完整判定**，不用逐项去查。`IcpNotAllowedReason` 是**不符合项**的枚举数组，三项都满足时为空数组：

| 值 | 含义 | 解法 |
| --- | --- | --- |
| `packageUnsupported` | 当前套餐不支持备案 | 升级套餐 |
| `validPeriod` | 剩余有效期不足（需大于 6 个月） | 续费环境 |
| `fixedIpNotEnabled` | 未开启云托管固定 IP | 开启固定 IP（序列 E） |

`ICPResources[]` 是可用于备案的资源列表，每项含 `ResourceId`（云托管服务 ID）、`ResourceIp`（**备案时要填的那个 IP**）、`Region`；有任一项不满足时该数组为空。

⚠️ **够格判据是「`IcpNotAllowedReason` 为空 **且** `ICPResources` 非空」，两者同时成立才算** —— 只看前者会被误判。传进来的环境不属于当前凭据（账号不对、envId 写错）时，这个接口同样返回 `success` + 空数组 + `Total: 0`（实测），与「三项全满足」长得一模一样；同一批探测里只有 `tcb/DescribeEnvInfo` 会明确报 `env not found`。判准入前先用它确认环境可达。

会同时出现的是 `packageUnsupported` + `validPeriod`（套餐不对时有效期必然也不够）—— 按「先解决 `packageUnsupported`」的顺序推进，否则续完费仍然备案不了。

需要看页面时，该环境的**备案管理**页 `https://tcb.cloud.tencent.com/dev?envId=<envId>#/env/filing-manage` 会把上述状态与对应操作入口一并列出。要单独读套餐与到期时间的原始值，用 `tcb/DescribeEnvInfo` 的 `EnvInfo.BillingInfo.PackageId` 与 `ExpireTime`；但准入判定以 `DescribeICPResourcesInfo` 为准，不要自己按天数算 —— 边界（是否严格大于 6 个月）由服务端定。

### B. 现在能不能提交备案（同主体互斥判定）

| 步 | Action | service | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 2 | DescribeLastIcpOrderInProgress | `ba` | `{}` | `IcpOrderId` |
| 3 | DescribeIcpOrders | `ba` | `{ "Offset": 0, "Limit": 10 }` | `TotalCount`、`Rows` |
| 4 | DescribeUserSummary | `ba` | `{}` | `PassedCount`、`PendingCount` |

步骤 2 是互斥判定的正解：`IcpOrderId` 返回**空串表示当前没有进行中的订单**（实测），可以发起新订单；非空则表示已有一条在路上，此时提交第二条会被拦。提交前先查这一步，比等到被驳回再排查省一轮等待。

步骤 3 看历史订单总量，步骤 4 看通过 / 待处理计数。

### C. 要等多久、这个省有什么硬规则

| 步 | Action | service | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 5 | DescribeEvaluateAuditDays | `ba` | `{}` | `Result`（JSON 字符串，`ProvinceCode` → 预计天数） |
| 6 | DescribeProvinceRules | `ba` | `{}` | `ProvinceRules[].Personal` / `.Enterprise`（HTML 片段） |
| 7 | DescribeOrganizationTypes | `ba` | `{}` | `OrganizationTypes[].Type` 与 `CertTypes[]`（主体类型 / 证件类型枚举） |

步骤 5 返回各省预计审核天数（`ProvinceCode` 是六位行政区划码，如 `110000` 北京、`440000` 广东），用来给使用者一个量级预期，而不是「一般 1-20 个工作日」。

步骤 6 返回各省管局对个人 / 企业的硬规则原文（HTML），提交前按自己所在省读一遍，网站命名、域名后缀、负责人年龄这类限制都在里面。

### D. 域名与主体当前状态

| 步 | Action | service | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 8 | DescribeDomainIcpStatus | `ba` | `{ "Domain": "<domain>" }` | `GovStatus`、`LandedStatus`、`AuditTicket`、`Ban` |
| 9 | DescribeIcpSubject | `ba` | `{}` | `Result`、`ContentData` |
| 10 | DescribeIcpRegister | `ba` | `{}` | `Webs[]`（该账号已备案的网站） |
| 11 | DescribeInWhiteList | `ba` | `{}` | `Rows[]` |

步骤 8 的四个布尔字段分别对应：管局是否已通过、是否已落地到腾讯云、是否有核查工单、是否被拦。域名不是自己的、已在别处备案未接入、被列入限制名单，都会在这里体现，不必等到提交后才被打回。

### E. 开启云托管固定 IP（写操作）

序列 A 判定出 `fixedIpNotEnabled` 时走到这里。

固定 IP 是**同一个环境上的云托管能力**，不是另一个环境、也不是另一个产品 —— `tcbr` 接口的 `EnvId` 就是云开发环境 ID。但**云托管本身可能还没开通**，没开通时后面的固定 IP 三步无从谈起。判断开通状态有专用工具，不要为它走裸云 API：

| 步 | 工具 | 关键参数 | 取什么 |
| --- | --- | --- | --- |
| 0a | `queryCloudRun(action="envStatus")` | `envId` | `status`：`normal` = 已开通 / `creating` = 开通中 / `unopened` = 未开通 |
| 0b | `manageCloudRun(action="initEnv")` | `envId` | 异步开通、幂等；只在 `unopened` / `creating` 时调 |
| 0c | 再跑一次 0a | `envId` | 轮询到 `status: "normal"` 才往下走 |

控制台上对应的入口是「环境 → 云托管 → 开通」，`https://tcb.cloud.tencent.com/dev?envId=<envId>#/platform-run`。

`status` 为 `normal` 之后，固定 IP 也只能走裸云 API：两个云托管专用工具都没有固定 IP 的 action（`queryCloudRun` 是 `list` / `detail` / `templates` / `getDeployLog` / `getProcessLog` / `getDeployRecords` / `envStatus` / `getManageTask`，`manageCloudRun` 是 `init` / `download` / `run` / `deploy` / `delete` / `createAgent` / `updateConfig` / `initEnv` / `traffic`），Manager SDK 也没有对应方法。

| 步 | Action | service | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 12 | DescribeStableIP | `tcbr` | `{ "EnvId": "<envId>" }` | `Status`（`normal` = 已开启，其余值含空串 = 未开启）、`Address`、`ExpireTime` |
| 13 | ModifyStableIPStatus | `tcbr` | `{ "EnvId": "<envId>", "Status": "ON" }` | `TaskId` |
| 14 | DescribeStableIPTask | `tcbr` | `{ "EnvId": "<envId>", "TaskId": <TaskId> }` | `Result`（`running` / `success` / `failed`） |

步骤 12 先确认现状：`Status` 只有 `normal` 算已开启，其余值（含空串）都按未开启处理，`Address` 是已分配的固定 IP。但**这个字段不是充分判据** —— 实测在一个不属于当前凭据的 envId 上，这一步照样返回成功、`Status` 也是空串，与「环境已开通云托管、但固定 IP 没开」从返回值上区分不出来，所以先用 `tcb/DescribeEnvInfo` 确认环境可达，再走 0a 判云托管开通状态。

步骤 13 是**异步任务**，只返回 `TaskId`，不等于已生效；步骤 14 用它轮询，`Result` 仍为 `running` 就继续等（间隔 2 秒量级）。生效后重跑序列 A，`fixedIpNotEnabled` 才会消失。

关闭固定 IP 把步骤 13 的 `Status` 换成 `OFF`，轮询同一套。

## 踩坑清单

| 坑 | 现象 | 正确做法 |

## pg-instance-spec-and-password

# Recipe 3 — PostgreSQL 实例变配与升级独享

## When to use

要让云开发环境的 PostgreSQL 实例改变**租户形态或规格**时：

- 规格撑不住：CPU / 内存打满、慢查询变多，要调大（或调小）实例规格
- 环境用的是**共享** PG，要升级成**独享**实例
- 已经提交了变配 / 升独享，要知道**任务跑完没有、失败原因是什么**

本篇管 PG 的**实例管控面**：租户形态、规格、存储、异步任务。

- 数据面（建表、跑 SQL、schema、migration）转 `queryPgDatabase` / `managePgDatabase`
- 存储空间告警转 [Recipe 1](./pg-storage-alarm.md)
- 环境套餐（`baas_personal` 这类）的续费 / 升级转 `tcb/ModifyEnvPlan`

## 前置权限

| service | version | 用途 |
| --- | --- | --- |
| `tcb` | `2018-06-08` | 环境的 PG 实例管控面：变配 / 升独享 / 查任务 |
| `postgres` | `2017-03-12` | 读实例现状与可售规格 |

**凭据身份：账号级。** 实例挂在云开发环境上，但读它的现状要走 `postgres` 产品接口。`callCloudApi` 有环境绑定门禁，账号级登录后先 `auth(action="set_env", envId=…)` 绑到目标环境；实例不在默认地域时，`postgres` 的读接口要在顶层传 `region`。

权限按凭据身份分开补：

- **账号级身份**（腾讯云密钥 / 子账号 / device 登录）：读实例现状与规格表需要 `QcloudPostgreSQLReadOnlyAccess`；`tcb` 的这几个 Action 属云开发自身能力，一般不额外要策略。**先直接往下做**，只有真的返回 `UnauthorizedOperation` 时才回来补。
- **CLI / MCP 用 TCB 服务角色换临时密钥**：权限挂在角色上，给角色追加同一条策略。

一键授权链接（以 `TCB_QcsRole` 为例，`principal` 是该角色载体的 base64）：

- `https://console.cloud.tencent.com/cam/role/grant?roleName=TCB_QcsRole&policyName=QcloudPostgreSQLReadOnlyAccess&principal=eyJzZXJ2aWNlIjoidGNiLmNsb3VkLnRlbmNlbnQuY29tIn0%3D`

账号级身份缺权限时，由主账号给**这个身份**追加策略，别去点角色的链接。链接拼法与角色载体的读法见 [calling-methods.md §3](../calling-methods.md)。

官方接口文档：云开发 API 概览 https://cloud.tencent.com/document/api/876/34809 （请求域名 `tcb.tencentcloudapi.com`）；云数据库 PostgreSQL API 概览 https://cloud.tencent.com/document/api/409/16761 （请求域名 `postgres.tencentcloudapi.com`）。

## 接口序列

### A. 先读现状：这个环境的 PG 是哪种、现在什么规格

| 步 | Action | service / version | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 1 | DescribeEnvInfo | `tcb` / `2018-06-08` | `{ "EnvId": "<envId>" }` | `EnvBaseInfo.PostgreSQL[].InstanceName`（= 下一步的 `DBInstanceId`）、`.TenantType` |
| 2 | DescribeDBInstanceAttribute | `postgres` / `2017-03-12` | `{ "DBInstanceId": "<上一步的 InstanceName>" }`，地域走顶层 `region` | `DBInstance` 下的 `DBInstanceCpu` / `DBInstanceMemory` / `DBInstanceStorage` / `DBInstanceClass` / `DBMajorVersion` / `DBInstanceStorageType` / `Zone` / `DBInstanceStatus` |

`PostgreSQL` 是数组：空数组说明这个环境没有开 PG，不要在它上面做变配。`TenantType` 是分流开关 —— `SHARED` 走序列 B2 升独享，`DEDICATED` 走序列 B1 调规格。

### B1. 独享实例调规格

| 步 | Action | service / version | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 3 | DescribeClasses | `postgres` / `2017-03-12` | `{ "Zone": "<A2 的 Zone>", "DBEngine": "postgresql", "DBMajorVersion": "<A2 的 DBMajorVersion>", "StorageType": "<A2 的 DBInstanceStorageType>", "InstanceCategory": "cloudbase" }` | `ClassInfoSet[]`：`SpecCode` / `CPU` / `Memory` / `MinStorage` / `MaxStorage` / `State` |
| 4 | ModifyPGInstanceSpec（预检） | `tcb` / `2018-06-08` | 步骤 5 的全部参数 + `"DryRun": true` | `DealName` / `BillId`（预检通过时都是空串） |
| 5 | ModifyPGInstanceSpec（正式） | `tcb` / `2018-06-08` | `{ "EnvId": …, "Cpu": <核数>, "Memory": <GB>, "SwitchTag": 0\|1\|2, "Storage": <GB，可选> }` | `DealName` / `BillId` |

步骤 3 只从返回列表里挑规格 —— `State` 为 `1` 表示在售；`CPU` / `Memory` 与 `SpecCode` 三列要一致地挑同一行。`Storage` 目标值必须落在该行的 `MinStorage` ~ `MaxStorage` 之间。

步骤 4 是提交前的安全网：`DryRun: true` 只做校验、不发起变配。预检报错就直接改参数重来，**不要跳过预检直接提交**（规格非法时会留下无效订单）。

步骤 5 的 `SwitchTag` 决定切换时机：`0` 立即、`1` 指定时间、`2` 维护时间窗口内。用 `1` 时 `SwitchStartTime` / `SwitchEndTime` 的格式是 **`YYYY-MM-dd HH:mm:ss`**：

```json
{
  "EnvId": "<envId>",
  "Cpu": 2,
  "Memory": 4,
  "Storage": 50,
  "SwitchTag": 0
}
```

返回 `DealName`（账单名）与 `BillId`（账单标识）。**变配是异步的：拿到订单号 ≠ 已经变完**，规格要按序列 C 回查。

### B2. 共享实例升级为独享

| 步 | Action | service / version | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 6 | DescribeClasses | `postgres` / `2017-03-12` | 同步骤 3，`StorageType` 可以不传 | 同步骤 3 |
| 7 | UpgradePGInstanceToDedicated | `tcb` / `2018-06-08` | `{ "EnvId": …, "SwitchTag": 0\|1, "SpecCode": "<步骤 6 的 SpecCode>", "Storage": <GB> }` | `TaskId` |

`SwitchTag` 是**必填**（`0` 立即切换、`1` 指定时间切换）。用 `1` 时 `SwitchStartTime` / `SwitchEndTime` 的格式是 **`HH:MM:SS`** —— 和 B1 的 `ModifyPGInstanceSpec` **不是同一套格式**。

```json
{
  "EnvId": "<envId>",
  "SwitchTag": 0,
  "SpecCode": "pg.it.small2",
  "Storage": 10
}
```

返回 `TaskId`，用序列 C 回查进度。

### C. 回查：任务与规格

| 步 | Action | service / version | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 9 | DescribeTaskResult | `tcb` / `2018-06-08` | `{ "EnvId": …, "TaskId": "<B2 的 TaskId>" }` | `Status` / `Phase` / `Reason` / `TaskType` |
| 10 | DescribeDBInstanceAttribute | `postgres` / `2017-03-12` | 同步骤 2 | 规格是否已变成目标值 |

两个回查入口分工不同：

- **升独享（B2）** 有 `TaskId` → 用步骤 9 看 `Status`（`Accepted` / `Running` / `Succeed` / `Failed`）与 `Phase`，失败读 `Reason`。
- **调规格（B1）不返回 `TaskId`** → 用步骤 10 比对 `DBInstanceCpu` / `DBInstanceMemory` / `DBInstanceStorage`，看 `UpdateTime` 是否晚于提交时间。

想用图形界面看这两条，控制台入口是：PG 实例页 `https://tcb.cloud.tencent.com/dev?envId=<envId>#/db/postgres/setting`（规格），任务列表 `https://tcb.cloud.tencent.com/dev?envId=<envId>#/db/postgres/tasks`。

## 踩坑清单

| 坑 | 现象 | 正确做法 |
| --- | --- | --- |
| 两个变配接口的时间格式不同 | 照 B1 的格式往 `UpgradePGInstanceToDedicated` 填、或反过来，报参数格式错 | `ModifyPGInstanceSpec` 用 `YYYY-MM-dd HH:mm:ss`，`UpgradePGInstanceToDedicated` 用 `HH:MM:SS`；不确定就用 `SwitchTag: 0` 立即切换，绕开时间参数 |
| 内存单位在两处不一样（实测） | 顺手把 `DescribeClasses.ClassInfoSet[].Memory` 填进 `ModifyPGInstanceSpec.Memory` | 规格表的 `Memory` 是 **MB**（同一规格 `DBInstanceMemory` 是 2、`ClassInfoSet` 里是 2048），要先除以 1024 换算成 GB |
| 提交了不在售的规格 | `spec 3C3G is not available in region ap-shanghai` | 先跑步骤 3 / 6 拿 `ClassInfoSet`，从列表里挑 `SpecCode` / `CPU` / `Memory`；不要凭经验凑核数与内存 |
| 拿 `DescribeTaskResult` 回查变配 | `Task not found.` | `ModifyPGInstanceSpec` 不返回 `TaskId`，变配回查走 `DescribeDBInstanceAttribute`；只有 `UpgradePGInstanceToDedicated` 返回 `TaskId` |
| 漏传 `DescribeTaskResult` 的入参 | 缺 `EnvId` 报 `The request is missing the required parameter \`EnvId\`.`，补齐后又报缺 `TaskId` | 入参只有 `EnvId` + `TaskId` 两个；`TaskType` 是返回字段、不是入参，不要往请求里塞 |
| 用 `TaskType` 做白名单过滤 | 按文档枚举只认 `PGUserMigration`，升独享的任务被当成"查不到" | `TaskType` 的文档枚举不含升级任务；判读只看 `Status` / `Phase` / `Reason`，不要去匹配 `TaskType` 的取值 |
| 在共享实例上直接调调规格接口 | `FailedOperation.InstanceStatusConflict`（Instance status does not match the required status for this operation） | 先看步骤 1 的 `TenantType`：`SHARED` 先走 B2 升独享，变 `DEDICATED` 之后再走 B1 调规格。升独享是单向的 |

## pg-instance-spec

# Recipe 3 — PostgreSQL 实例变配与升级独享

## When to use

要让云开发环境的 PostgreSQL 实例改变**租户形态或规格**时：

- 规格撑不住：CPU / 内存打满、慢查询变多，要调大（或调小）实例规格
- 环境用的是**共享** PG，要升级成**独享**实例
- 已经提交了变配 / 升独享，要知道**任务跑完没有、跑到哪、失败原因是什么**
- 变配 / 升独享**还没提交或刚提交**，用户先问「要多久、业务会不会断」—— 这类「给用户的预期」按序列 D 的口径回答，不要自己估
- 用户问「是不是得先升套餐才能升配」「升完每月多花多少」—— 按「费用与套餐」一节的结论与口径回答，不要凭感觉

本篇管 PG 的**实例管控面**：租户形态、规格、存储、异步任务。

- 数据面（建表、跑 SQL、schema、migration）转 `queryPgDatabase` / `managePgDatabase`
- 存储空间告警转 [Recipe 1](./pg-storage-alarm.md)
- 环境套餐（`baas_personal` 这类）的续费 / 升级转 `tcb/ModifyEnvPlan`

## 前置权限

| service | version | 用途 |
| --- | --- | --- |
| `tcb` | `2018-06-08` | 环境的 PG 实例管控面：变配 / 升独享 / 查任务（写） |
| `postgres` | `2017-03-12` | 读实例现状与可售规格 |

**凭据身份：账号级。** 实例挂在云开发环境上，但读它的现状要走 `postgres` 产品接口。`callCloudApi` 有环境绑定门禁，账号级登录后先 `auth(action="set_env", envId=…)` 绑到目标环境；实例不在默认地域时，`postgres` 的读接口要在顶层传 `region`。

权限按凭据身份分开补：

- **账号级身份**（腾讯云密钥 / 子账号 / device 登录）：读实例现状与规格表需要 `QcloudPostgreSQLReadOnlyAccess`；`tcb` 的这几个 Action 属云开发自身能力，一般不额外要策略。**先直接往下做**，只有真的返回 `UnauthorizedOperation` 时才回来补。
- **CLI / MCP 用 TCB 服务角色换临时密钥**：权限挂在角色上，给角色追加同一条策略。

一键授权链接（以 `TCB_QcsRole` 为例，`principal` 是该角色载体的 base64）：

- `https://console.cloud.tencent.com/cam/role/grant?roleName=TCB_QcsRole&policyName=QcloudPostgreSQLReadOnlyAccess&principal=eyJzZXJ2aWNlIjpbInRjYi5jbG91ZC50ZW5jZW50LmNvbSJdfQ%3D%3D`

账号级身份缺权限时，由主账号给**这个身份**追加策略，别去点角色的链接。链接拼法、`principal` 的固定取值与使用边界见 [calling-methods.md §3.2](../calling-methods.md)。

官方接口文档：云开发 API 概览 https://cloud.tencent.com/document/api/876/34809 （请求域名 `tcb.tencentcloudapi.com`）；云数据库 PostgreSQL API 概览 https://cloud.tencent.com/document/api/409/16761 （请求域名 `postgres.tencentcloudapi.com`）。

## 费用与套餐：调规格无套餐门槛，升独享有套餐门槛

**B1 调规格（独享实例）没有套餐门槛。** 调用条件只有两类：实例状态可操作、目标规格合法。没有「套餐档位」「计费模式」这类前置。

🔴 **B2 升独享有套餐门槛，而且是硬门槛**（实测 2026-10-16）。个人版（`baas_personal`）环境调用被直接拒：

```
current package does not support upgrading to dedicated instance
```

同样的参数换到标准版（`baas_pf_standard`）环境就成功升到独享并跑到 `Succeed`。准入范围（内部口径 + 实测一致）：**标准版及以上（标准版 / 企业版 / 企业高级版）+ 集成版 / 平台版**。

门槛的几个反直觉点，别用别处的经验套：

- ⚠️ **不要试图从套餐字段预判**：`ResourceLimit` 里没有 `PostgreSQL.DedicatedInstance` 键并不等于不能升 —— 标准版就没有这个键，照样能升；有这个键的只有企业版 / 企业高级版。`PackageType` 也不可靠：`tcb/DescribeEnvPlans` 与 `manageEnv listPackages` 对同一档位给出的值并不一致。直接调用接口，以返回为准。
- ⚠️ **没有可读的资格字段，也没有 DryRun**：判断某个环境能不能升，只能真调一次；调完没报套餐错就是能升。
- ⚠️ **先复查实例再查套餐**：目标环境如果压根没开 PG，接口先报 `PG instance not found.`，压根走不到套餐那道校验。所以「报错说没实例」和「报错说套餐不行」要分开读，别把没开 PG 讲成套餐问题。
- ⚠️ 选环境时另有坑：`manageEnv listPackages` 按新购页口径只返回 `default` 族，标准版 / 企业版（`basic` 族）不在列表里，但它们合法可建。详见 `cloudbase-platform` skill 的 `manageEnv` 一节。

别把边缘加速那道门槛套到这里。边缘加速确实要求「标准版及以上套餐 + 环境处于资源点计费模式」（见 [Recipe 4](./custom-domain.md)），那是**加速能力**的准入要求；PG 变配是**实例自身**的规格调整，两件事。

费用按**实例规格**扣资源点，与访问量无关（没人连库也照扣）：

| 项 | 口径 |
| --- | --- |
| CPU | **342 资源点 / CU / 小时** |
| 存储 | **0.5 资源点 / GB / 小时** |

按这个口径，2 核 4 GiB + 50 GB 的独享实例是 **709 资源点/小时**（约 1.7 万/天）；从 1 核 2 GiB + 10 GB 升到它，每小时多 362 资源点。控制台提交页的「用量推算」就按这个口径给，细则可以引其中的「PostgreSQL 数据库计量说明」链接给用户。

「要不要升套餐」的判据要分开说：**B1 只看资源点够不够扣**；**B2 先过套餐准入，再看资源点**。B1 升配后消耗变快，扣到不足时才需要升套餐或加购资源包 —— 那是**额度**问题，不是 B1 的前置条件。回答用户时把这两件事分开说，别让「先升套餐」变成一次白忙。

这一节的口径只适用于**独享**实例：共享实例的计费规则不同，升独享提交时的提示就是「升级后按独享实例的计费规则计量计费」。

## 接口序列

### A. 先读现状：这个环境的 PG 是哪种、现在什么规格

| 步 | Action | service / version | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 1 | DescribeEnvInfo | `tcb` / `2018-06-08` | `{ "EnvId": "<envId>" }` | `EnvBaseInfo.PostgreSQL[].InstanceName`（= 下一步的 `DBInstanceId`）、`.TenantType` |
| 2 | DescribeDBInstanceAttribute | `postgres` / `2017-03-12` | `{ "DBInstanceId": "<上一步的 InstanceName>" }`，地域走顶层 `region` | `DBInstance` 下的 `DBInstanceCpu` / `DBInstanceMemory` / `DBInstanceStorage` / `DBInstanceClass` / `DBMajorVersion` / `DBInstanceStorageType` / `Zone` / `DBInstanceStatus` |

`PostgreSQL` 是数组：空数组说明这个环境没有开 PG，不要在它上面做变配。`TenantType` 是分流开关 —— `SHARED` 走序列 B2 升独享，`DEDICATED` 走序列 B1 调规格。

### B1. 独享实例调规格

| 步 | Action | service / version | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 3 | DescribeClasses | `postgres` / `2017-03-12` | `{ "Zone": "<A2 的 Zone>", "DBEngine": "postgresql", "DBMajorVersion": "<A2 的 DBMajorVersion>", "StorageType": "<A2 的 DBInstanceStorageType>", "InstanceCategory": "cloudbase" }` | `ClassInfoSet[]`：`SpecCode` / `CPU` / `Memory` / `MinStorage` / `MaxStorage` / `State` |
| 4 | ModifyPGInstanceSpec（预检） | `tcb` / `2018-06-08` | 步骤 5 的全部参数 + `"DryRun": true` | `DealName` / `BillId`（预检通过时都是空串） |
| 5 | ModifyPGInstanceSpec（正式） | `tcb` / `2018-06-08` | `{ "EnvId": …, "Cpu": <核数>, "Memory": <GB>, "SwitchTag": 0\|1\|2, "Storage": <GB，可选> }` | `DealName` / `BillId` |

步骤 3 只从返回列表里挑规格 —— `State` 为 `1` 表示在售；`CPU` / `Memory` 与 `SpecCode` 三列要一致地挑同一行。`Storage` 目标值必须落在该行的 `MinStorage` ~ `MaxStorage` 之间。

步骤 4 是提交前的安全网：`DryRun: true` 只做校验、不发起变配。预检报错就直接改参数重来，**不要跳过预检直接提交**（规格非法时会留下无效订单）。

步骤 5 的 `SwitchTag` 决定切换时机：`0` 立即、`1` 指定时间、`2` 维护时间窗口内。用 `1` 时 `SwitchStartTime` / `SwitchEndTime` 的格式是 **`YYYY-MM-dd HH:mm:ss`**：

```json
{
  "EnvId": "<envId>",
  "Cpu": 2,
  "Memory": 4,
  "Storage": 50,
  "SwitchTag": 0
}
```

返回 `DealName`（账单名）与 `BillId`（账单标识）。**变配是异步的：拿到订单号 ≠ 已经变完**，规格要按序列 C 回查。

### B2. 共享实例升级为独享

| 步 | Action | service / version | 关键参数 | 取什么 |
| --- | --- | --- | --- | --- |
| 6 | DescribeClasses | `postgres` / `2017-03-12` | 同步骤 3，`StorageType` 可以不传 | 同步骤 3 |
| 7 | UpgradePGInstanceToDedicated | `tcb` / `2018-06-08` | `{ "EnvId": …, "SwitchTag": 0\|1, "SpecCode": "<步骤 6 的 SpecCode>", "Storage": <GB> }` | `TaskId` |

`SwitchTag` 是**必填**（`0` 立即切换、`1` 指定时间切换）。用 `1` 时 `SwitchStartTime` / `SwitchEndTime` 的格式是 **`HH:MM:SS`** —— 和 B1 的 `ModifyPGInstanceSpec` **不是同一套格式**。


## pg-storage-alarm

# Recipe 1 — PostgreSQL 存储空间使用率 ≥ 80% 告警

## When to use

要给 CloudBase PostgreSQL 实例配存储空间（磁盘）使用率告警时：

- 新建使用率阈值告警策略，并绑定到指定实例
- 已有策略但不生效：需要回查绑定维度（`resourceId` / `uid` 为 null、策略被 `alarm_disabled` 禁用）

本篇只覆盖告警策略的创建 / 绑定 / 回查；查监控数据（`GetMonitorData`）或控制台可视化不在这里。

## 前置权限

需要 `monitor` 告警策略族的**写**权限 + `postgres` 读实例权限。

权限来自哪种凭据身份，见 [calling-methods.md §3](../calling-methods.md)：账号级登录取该身份自身策略，服务角色发起的调用取角色挂载的策略，环境级 API Key 没有追加 CAM 策略的通道。**先直接往下做**，只有写操作真的返回 `UnauthorizedOperation` 时才回来补：

- 告警策略族：`QcloudMonitorFullAccess`（`QcloudMonitorReadOnlyAccess` 对「告警策略」只有访问权、没有操作权，写操作挂它没用）
- postgres 读实例：`QcloudPostgreSQLReadOnlyAccess`

补权限的一键链接（`TCB_QcsRole` 为例，角色名与 `principal` 按实际角色替换）：

- `https://console.cloud.tencent.com/cam/role/grant?roleName=TCB_QcsRole&policyName=QcloudMonitorFullAccess&principal=eyJzZXJ2aWNlIjpbInRjYi5jbG91ZC50ZW5jZW50LmNvbSJdfQ%3D%3D`
- `https://console.cloud.tencent.com/cam/role/grant?roleName=TCB_QcsRole&policyName=QcloudPostgreSQLReadOnlyAccess&principal=eyJzZXJ2aWNlIjpbInRjYi5jbG91ZC50ZW5jZW50LmNvbSJdfQ%3D%3D`

两条可以合成一条：`policyName` 支持逗号连接多个策略（`policyName=QcloudMonitorFullAccess,QcloudPostgreSQLReadOnlyAccess`）。

账号级身份（腾讯云密钥 / 子账号 / device 登录）缺权限时，由主账号给**这个身份**追加策略，别去点角色的链接。

链接的拼法、`principal` 的固定取值与使用边界见 [calling-methods.md §3.2](../calling-methods.md)。

官方 API 文档：监控告警 API 概览 https://cloud.tencent.com/document/product/649/30343（单个 Action 详细文档在 `document/api/248/` 下）。

## 接口序列

| 步 | Action | service / version | 关键参数 |
| --- | --- | --- | --- |
| 1 | DescribeAllNamespaces | monitor / 2018-07-24 | `{ "Module": "monitor", "SceneType": "ST_ALARM" }`，从 `QceNamespacesNew` 取策略命名空间（PG = `POSTGRESQL`） |
| 2 | DescribeAlarmMetrics | monitor / 2018-07-24 | `{ "Module": "monitor", "MonitorType": "MT_QCE", "Namespace": "POSTGRESQL" }`，确认指标与可选值：StorageRate（Period 60/300，ContinuePeriod 1-5） |
| 3 | DescribeDBInstances | **postgres / 2017-03-12** | `{ "Limit": 100, "Offset": 0 }`，按地域逐次调用；取实例 `DBInstanceId` 与 **`Uid`** |
| 4 | DescribeAlarmNotices | monitor / 2018-07-24 | 复用已有通知模板（系统预设即可），或 CreateAlarmNotice 新建 |
| 5 | CreateAlarmPolicy | monitor / 2018-07-24 | 见下方完整请求 |
| 6 | BindingPolicyObject | monitor / 2018-07-24 | 顶层 region 必传 + 双维度绑定，见坑 3/4 |
| 7 | DescribeAlarmPolicies / DescribeBindingPolicyObjectList | monitor / 2018-07-24 | 回查验证 |

CreateAlarmPolicy 实测可用的请求体：

```json
{
  "Module": "monitor",
  "PolicyName": "PostgreSQL磁盘使用率80%告警",
  "Remark": "磁盘(存储空间)使用率>=80%告警",
  "MonitorType": "MT_QCE",
  "Enable": 1,
  "ProjectId": 0,
  "Namespace": "POSTGRESQL",
  "Condition": {
    "IsUnionRule": 0,
    "Rules": [{
      "MetricName": "StorageRate", "Period": 60, "Operator": "ge",
      "Value": "80", "ContinuePeriod": 1, "NoticeFrequency": 3600, "IsPowerNotice": 0
    }]
  },
  "NoticeIds": ["notice-xxxxxxxx"]
}
```

返回 `PolicyId`（策略 ID）与 `OriginId`（数字，即后续绑定接口的 **GroupId**）；维度里的 `uid` 取自步骤 3 的实例返回。

绑定请求（步骤 6）：

```json
{
  "Module": "monitor",
  "PolicyId": "policy-xxxxxxxx",
  "Dimensions": [{
    "Region": "sh",
    "Dimensions": "{\"uid\":<实例Uid>,\"resourceId\":\"<PostgreSQL实例ID>\"}"
  }]
}
```

## 踩坑清单

| 坑 | 现象 | 正确做法 |
| --- | --- | --- |
| Namespace 用错 | `QCE/POSTGRES` / `postgres` 查指标返回空 | 策略族接口用 `DescribeAllNamespaces` 返回的 `QceNamespacesNew.N.Id`（PG = `POSTGRESQL`）；`QCE/POSTGRES` 只是监控数据命名空间 |
| CreateAlarmPolicy 缺 ProjectId | `InvalidParameter: this namespace requires projectID: -1` | 显式传 `ProjectId=0`（默认项目，与实例一致；不要传 -1） |
| 绑定缺 X-TC-Region | `MissingParameter: Region` | 顶层 region 传完整码（如 `ap-shanghai`）；同时 `Dimensions[].Region` 用**短码**（如 `sh`），两个字段不同 |
| 绑定维度缺 uid | 表面成功，回查 `resourceId:null,uid:null`，告警被 alarm_disabled 禁用 | `Dimensions` 内 JSON 必须同时含 `uid`（来自 DescribeDBInstances）与 `resourceId` |
| 回查绑定用错参数 | 传 PolicyId 或 PageNumber 均报错 | DescribeBindingPolicyObjectList 传 `Module="monitor"` + `GroupId`（= OriginId），不传分页 |
| 解绑残留 | MissingParameter GroupId / UniqueId 类型错 | UnBindingPolicyObject 传 `GroupId` + `UniqueId`（**数组**，从绑定列表取） |
| DescribeAlarmNotices 参数 | 缺 `Order` 报 MissingParameter；小写 `asc` 报 invalid input param | 必传 `Module` + `Order="ASC"`（大写）+ `PageNumber/PageSize`；响应字段是 `Id`（不是 NoticeId） |
| 服务端报错吞首字母 | `RojectId` / `RderType` / `SUnionRule` / `Egion` 等未定义参数报错 | 这是服务端报错**显示**怪癖（首字母被吞），实际核对的是完整参数名；先对照 SDK models 的字段定义，别被报错带偏 |
| SDK 类名陷阱（Python） | `ConditionTemplate`/`AlertRule`/`Dimension` 不存在或形状不对 | Condition 用 `AlarmPolicyCondition`、规则用 `AlarmPolicyRule`、绑定维度用 `BindingPolicyObjectDimension`（`Dimension` 是别的接口的，只有 Name/Value） |
| 以为只能 HTTP 直调 | 目标 service 不在 `callCloudApi` 支持的范围内，以为做不了 | 同序列可走官方 SDK 直调（[calling-methods.md §3](../calling-methods.md) 取临时密钥），两条路径结论一致、可互换 |

## 验证步骤

1. `DescribeAlarmPolicies` 按 PolicyName 回查：确认 Enable=1、Condition 规则、NoticeIds。
2. `DescribeBindingPolicyObjectList`（Module + GroupId）：确认 Total=1 且 Dimensions 双字段非 null。
3. 若出现 null 维度残留记录，用 UnBindingPolicyObject 清理。

## platform-agent-connect

# Recipe 8 — 把环境接到用户的 Agent

## When to use

环境 ID 与 API Key 已经发到用户手上（见 [Recipe 7](./platform-onboarding.md)），现在要把这份凭证真正接进 Agent：

- 用户在同一台机器上开发多个项目，每个项目一个环境，要求互不串
- 想做到「用户不用手填任何东西」，甚至完全不看到密钥
- 换过 key 或换过环境之后，Agent 还在操作旧的那个

不管什么：环境还没建、凭证还没发，先做 [Recipe 7](./platform-onboarding.md)。要限制 Agent 能调哪些工具、要审计与审批，见 [Recipe 9](./platform-agent-guardrails.md)。

## 前置权限

- 客户端能跑 Node.js（MCP 与 CLI 都依赖它）
- 已经拿到成对的两个值：环境 ID 与环境 API Key
- 凭证的身份边界见 [calling-methods.md §3](../calling-methods.md)：环境级 API Key 只能看到它绑定的那个环境，看不到别的环境不是环境不存在

## 接口序列

三条路径选一条。选择的判据只有一条：**用户能不能看到密钥明文**。

### A. 写进 MCP 配置的 `env`（主流做法，一个项目一套）

```json
{
  "mcpServers": {
    "cloudbase": {
      "command": "npx",
      "args": ["@cloudbase/cloudbase-mcp@latest"],
      "env": {
        "CLOUDBASE_ENV_ID": "<本项目的环境 ID>",
        "CLOUDBASE_API_KEY": "<本项目的环境 API Key>"
      }
    }
  }
}
```

MCP 进程启动时读这两个变量，读到就已是登录态，用户不需要再走任何登录步骤。

**一个项目一份配置 = 一个项目一个环境。** 隔离靠的是配置的**位置**：把这段 `mcpServers` 放在**项目目录**而不是全局用户目录，换项目就换一份配置，`env` 里那对值跟着换。

变量名与别名：

| 变量 | 说明 |
| --- | --- |
| `CLOUDBASE_API_KEY` | 环境 API Key，主用名 |
| `CLOUDBASE_APIKEY` | 兼容别名，语义相同；新配置写主用名 |
| `CLOUDBASE_ENV_ID` | 环境 ID。单独设置它时不代替登录，只是指定"操作哪个环境" |

同一个环境只设 `CLOUDBASE_ENV_ID`、让用户自己登录也是一种用法（无浏览器环境下的兜底）：它决定用哪个环境，但不提供凭证。

### B. CLI 非交互登录（机器上已有 CloudBase CLI）

```bash
tcb login --cloudbase-api-key <API Key> -e <envId>
```

`--cloudbase-api-key` 必须同时给 `-e`。注意区分两组长得像的参数：

| 参数 | 含义 |
| --- | --- |
| `--cloudbase-api-key` | 云开发**环境** API Key（本 Recipe 用的这个） |
| `--apiKeyId` / `--apiKey` | 腾讯云**账号**级凭据，CI 用，不是同一回事 |

### C. 平台内嵌本地授权回调（用户完全不碰密钥）

1. 平台在客户端侧起一个只监听 `127.0.0.1` 的本地服务，端口随机
2. 打开云开发授权页（`/login?cliAuth=1`，带上 `_redirect_uri` 与 `authCallbackUrl`）
3. 用户完成一次网页授权，回调带回 `authSource=api_key`、`envId`、`apiKey`
4. 本地进程用 `@cloudbase/toolbox` 的 `loginByApiKey()` 换临时密钥，写进本机凭证文件
5. 关掉本地服务，提示用户在客户端里启用连接器并**新开一个会话**

换证地址可用环境变量 `CLOUDBASE_API_ENDPOINT` 覆盖 —— 客户要求走自己内网网关时用它。

### 凭证从哪读、什么时候读

MCP 的登录态只有两个来源，这决定了"为什么换 key 之后老会话不管用"：

| 来源 | 读取时机 | 影响范围 |
| --- | --- | --- |
| `CLOUDBASE_API_KEY` / `CLOUDBASE_ENV_ID` 环境变量 | MCP **进程启动**时 | 这个 MCP 进程，也就是这个会话 |
| 本机凭证文件（toolbox / CLI 写入） | 登录或换证时 | 该机器上之后启动的会话 |

两个来源都不会在会话中途重读 ⇒ **凭证一变就必须新开会话**，改配置后继续用老会话是没用的。

## 踩坑清单

| 坑 | 现象 | 正确做法 |
| --- | --- | --- |
| 改完配置继续用老会话 | 还是旧环境、旧 key | 关掉会话重开；环境变量只在进程启动时读一次 |
| 配置放全局而不是项目目录 | 所有项目共用一份凭证，互相串环境 | 每个项目一份 MCP 配置，放在项目目录内 |
| 以为环境级 key 能看所有环境 | 查别的环境查不到，像"环境不存在" | 这是权限边界（`credential_scope: single_env`），不是环境丢了 |
| 只设 `CLOUDBASE_ENV_ID` 就交付 | 用户没登录，工具报未登录 | 环境 ID 决定用哪个环境，不代替凭证 |
| 环境开在国际站却按国内站登录 | 登录成功但看不到环境 | 国际站环境登录要显式传 `site=intl`（`auth` 工具的 `site` 参数），否则走国内站链路 |
| `--cloudbase-api-key` 不带 `-e` | CLI 报错 | 两者必须同时给 |
| 把账号级 `--apiKey` 当成环境 key | 权限范围与预期不符 | 环境级用 `--cloudbase-api-key`，账号级用 `--apiKeyId`/`--apiKey` |
| 密钥写进会被提交的文件 | 泄漏且不可撤 | MCP 配置加进 `.gitignore`；要更高安全就走路径 C |

## 验证步骤

1. `auth(action="status")`：登录态正常，`envId` 与给用户的那个一致，`credential_scope` 说明这是环境级还是账号级身份。
2. `queryEnv(action="info", envId="<envId>")`：返回的环境就是本项目该用的那个。
3. 跑一次只读资源查询（列集合或列云函数），确认能取到该环境的资源。
4. **反向验证**：在同一台机器上换成另一个项目的配置（另一个环境），确认看不到上一个项目的资源。
5. 换 key 后按第 1 步复查：新会话里 `envId` 不变、凭证已更新，老会话仍是旧凭证 —— 用来确认"必须新开会话"这件事在你这边也成立。

## platform-agent-guardrails

# Recipe 9 — 收口 Agent：工具裁剪、封装审计、专家约束

## When to use

企业侧对「Agent 能做什么」有硬要求时：

- 要按角色裁剪工具表面：给终端用户的会话不该能调通用云 API，也不该能碰本地文件
- 要能审计：谁、在哪个会话、调了哪个工具、传了什么参数，事后查得到
- 要让 Agent 遵守公司规范：新建云函数必须挂内网 VPC、对外服务必须绑自定义域名

不管什么：凭证怎么进到 Agent 见 [Recipe 8](./platform-agent-connect.md)；自定义域名的具体接口序列见 [custom-domain.md](./custom-domain.md)。

## 前置权限

- 能改客户端侧的 MCP 配置（本地 stdio），或能改远端 MCP 的连接 URL
- 网关/代理与审计存储由企业自己提供；云开发侧只提供工具与插件开关

## 接口序列

### A. 裁剪工具表面

MCP 的工具按**插件**分组，用一个变量就能整组关掉：本地 stdio 用 `CLOUDBASE_MCP_PLUGINS_DISABLED`，远端 URL 用 `disable_plugins`（逗号分隔多值）。

| 目的 | 配置 |
| --- | --- |
| 去掉通用云 API 工具（`callCloudApi`） | `"CLOUDBASE_MCP_PLUGINS_DISABLED": "capi"` |
| 只保留白名单（比逐项禁用更严） | `CLOUDBASE_MCP_PLUGINS_ENABLED=env,functions,hosting` |
| 去掉本地文件与进程类工具（自托管调用方） | `CLOUDBASE_MCP_CLOUD_MODE=true` |

插件名取自 `mcp/src/server.ts` 的 `DEFAULT_PLUGINS`，共 20 个：

```
env  database  pg_database  pg_storage  mysql_database  functions  hosting
storage  setup  rag  cloudrun  deploy  gateway  app-auth  apps  permissions
logs  agents  capi  feedback
```

`capi` 这个插件注册的工具就是 `callCloudApi`（通用云 API 通道）。**禁它是有代价的：平台版那套管控面接口（`CreatePlatformEnv` / `DescribePlatforms` / `CreateApiKey` …）在这个会话里也一起调不了了。**

所以常见做法是**两套配置**：

| 配置 | 谁用 | `capi` |
| --- | --- | --- |
| 运维侧 | 平台自己的运营/发放流程 | 保留 |
| 终端用户侧 | 发给用户的 MCP 配置 | 禁用 |

### B. 封装 MCP 做审计与审批

把 MCP 调用收敛到自己的一个进程/端点后面，是「可观测 + 可拦截」的前提。两种形态：

| 形态 | 做法 | 能拦到什么 |
| --- | --- | --- |
| 本地 stdio 代理 | 客户端连你的代理进程，代理起真正的 MCP 子进程，转发 `initialize` / `tools/list` / `tools/call` | 单机上的全部工具调用；可对破坏性调用挂起等审批 |
| 远端网关 | 客户端连公司网关的 MCP 端点，网关解析 `tools/call` 后决定放行或阻断，再转发给云开发的远端 MCP | 所有接入该网关的调用；可做限流、配额、集中审计 |

审计要能回答「是谁做的」，就有两点必须遵守：

1. **身份在你的这一层取**（员工登录态 / 网关的鉴权结果），不要取工具参数里的自报字段。
2. **连 `params` 一起记**。只记工具名查不出"改了什么" —— 写操作的入参里才有 `EnvId`、`Alias`、上游资源名这些定位信息。

### C. 用自定义专家固化企业约束

系统提示词与专家提示词适合放**软约束**：命名规范、必须带哪个参数、先做什么后做什么。写法上只有一条要求 —— **落到具体的参数名**，"注意安全""遵循规范"这类句子没法执行也没法验收。

两个可以照抄的例子：

**新建云函数必须挂内网 VPC。** 要求调 `manageFunctions(action="createFunction")` 时 `func.vpc` 必须传 `{ vpcId, subnetId }`。这句话是可判定的：`func.vpc` 没有就是违规。不要写成同一入口顶层的 `vpc` —— 建函数只读 `func`，顶层那个只在改配置（`updateFunctionConfig`）时生效。

```json
{
  "action": "createFunction",
  "func": {
    "name": "order-hook",
    "vpc": { "vpcId": "<企业 VPC ID>", "subnetId": "<子网 ID>" }
  }
}
```

**对外服务必须先绑自定义域名。** 要求站点/服务对外前先用 `manageGateway` 完成域名接入；平台版场景下域名池是按 `PlatformId` 维度管理的，两套同形接口别混用，见 [custom-domain.md](./custom-domain.md)。

### 软约束不是防线

提示词会被改写、也可能被注入绕过。真正的收口放在另外两层：

| 层 | 手段 | 拦什么 |
| --- | --- | --- |
| 提示词 | 专家里的规范 | 让 Agent 默认做对（不保证） |
| 网关 / 代理 | 工具裁剪、破坏性调用审批 | 让违规调用发不出去 |
| 数据层 | 数据库安全规则 / 行级安全 | 即使调用发出去了，越权请求在物理层被拒 |

## 踩坑清单

| 坑 | 现象 | 正确做法 |
| --- | --- | --- |
| 以为裁剪工具就等于收口 | 参数换个写法又能调通 | 裁剪只缩小工具表面；硬约束要放网关与数据层 |
| 禁 `capi` 之后平台运维也用同一套配置 | 管控面接口调不了 | 运维侧一套配置、终端用户侧一套配置 |
| 专家提示词里写死内网域名、子网 ID | 换环境即失效，且内部信息进了会被分发的产物 | 参数从环境变量或自家配置读取；提示词里只写规则、不写值 |
| 审计只记工具名 | 事后查不出改了什么 | 记 `tools/call` 的 `params` 原文 |
| 报名身份的字段做审计 | 身份可伪造 | 身份在自己的网关/代理层取，不取工具参数 |
| 把 `MCP_CLOUD_MODE` 当安全开关 | 以为它也挡住了云资源操作 | 它只关本地文件与进程类工具，不限制云资源调用 |
| 用 `enable_plugins` 写在本地 stdio 配置里 | 不生效 | 本地用 `CLOUDBASE_MCP_PLUGINS_ENABLED`，`enable_plugins` 是远端 URL 的参数 |

## 验证步骤

1. 连接后看工具清单：被禁插件对应的工具**确实不在列表里**（不是"应该不在"）。
2. 直接调一次被禁的工具名：应报未知工具，而不是执行成功。
3. 走一次写操作（例如建一个函数），在代理或网关日志里能查到三样东西：工具名、`params` 原文、发起者身份。
4. 反向测试专家规范：故意让 Agent 不提 `vpc` 就建函数，确认它被规范挡住，或你在网关侧收到了违规记录。

## platform-onboarding

# Recipe 7 — 平台版接入：建环境、发凭证

## When to use

平台型客户要把云开发环境开给**没有腾讯云账号**的下游用户或员工：

- 用户不该各自注册腾讯云、也不该各自买套餐，环境由平台统一开、账号统一计费
- 需要一次拿到「环境 ID + 环境 API Key」这一对东西，再交给用户侧
- 要按用户/租户批量建环境，既可能随用随建，也可能提前预创建

不管什么：单个开发者自己开通自己用，走 getting-started。拿到凭证之后怎么让 Agent 用上，见 [Recipe 8](./platform-agent-connect.md)；用量、账期与环境回收见 [Recipe 10](./platform-usage-and-recycle.md)。

## 前置权限

两条硬前提，缺一条第一步就失败：

- **账号已购平台版套餐。** 未购时 `DescribePlatforms` 返回空列表，后面无以为继。
- **用账号级凭据调。** `CreatePlatformEnv` / `CreateApiKey` / `DestroyPlatformEnv` 这些管控面接口不接受环境级 API Key。`auth(action="status")` 返回 `credential_scope: single_env` 就是环境级身份，需换成账号级密钥或登录态。

权限不足的判据、身份分类与一键授权链接见 [calling-methods.md §3](../calling-methods.md)。

## 接口序列

| 步 | Action | service / version | 关键参数 |
| --- | --- | --- | --- |
| 1 | `DescribePlatforms` | tcb / 2018-06-08 | `{ "Limit": 10 }`，`Limit` 取值 [10, 100]；从 `PlatformList[]` 取 `PlatformId`（**套餐池标识**，第 2 步必传） |
| 2 | `CreatePlatformEnv` | tcb / 2018-06-08 | `{ "Alias": "<环境别名>", "PlatformId": "<第 1 步的值>", "ReqKey": "<幂等键>" }`，返回 `EnvId` |
| 3 | `DescribeEnvs` | tcb / 2018-06-08 | 无参数，返回 `EnvList[]`；按 `EnvId` 找到目标环境，等 `Status` 变为 `NORMAL` |
| 4 | `CreateApiKey` | tcb / 2018-06-08 | `{ "EnvId": "<第 2 步的值>", "KeyType": "api_key", "KeyName": "<能认出用户的别名>" }`，返回 `ApiKey`（明文**只返回一次**） |
| 5 | 记映射 | — | 落到自己的库里：`用户 ↔ EnvId ↔ ApiKey`。轮换、回收、审计都靠这张表 |

前两步的完整请求体：

```json
{ "service": "tcb", "action": "DescribePlatforms", "params": { "Limit": 10 } }
```

```json
{
  "service": "tcb",
  "action": "CreatePlatformEnv",
  "params": { "Alias": "user-10086", "PlatformId": "pf-t960szfwv1cs", "ReqKey": "user-10086-20261014" }
}
```

`Alias` 只用于区分与展示，**用户和环境的对应关系云开发不记录**，必须由第 5 步自己维护。

### 按需创建与预创建

| 方式 | 适用 | 流程 |
| --- | --- | --- |
| 按需创建 | 用户量小或建环境频率不高 | 用户请求时调第 2 步 → 记映射 → 第 3 步确认就绪 → 分配 |
| 预创建 | 对开通体验有要求，希望用户无感 | 循环调第 2 步批量建（不同 `Alias`）→ 第 3 步确认就绪后进池 → 用户请求时从池里挑一个绑定 |

预创建的环境**建出来就开始消耗资源点**，数量按预期用户量估。

### 环境生命周期（运营动作见 Recipe 10）

| 操作 | Action | 关键参数 |
| --- | --- | --- |
| 暂停 / 恢复 | `ModifyPlatformEnv` | `{ "EnvId": "...", "Status": "DISABLE" }` 暂停，`"ENABLE"` 恢复 |
| 销毁 | `DestroyPlatformEnv` | `{ "EnvId": "..." }`，环境内数据一并清除、**不可逆** |

## 踩坑清单

| 坑 | 现象 | 正确做法 |
| --- | --- | --- |
| 拿 `CreateEnv` 当平台版建环境用 | 报缺少 `PackageId`；语义上也走偏了 —— 那是给**单个环境**买套餐 | 平台版用 `CreatePlatformEnv`，只传 `PlatformId`（套餐在账号维度） |
| 没先取 `PlatformId` | `CreatePlatformEnv` 缺参数直接失败 | 先调 `DescribePlatforms`；返回空列表说明账号下没有已购平台版资源 |
| 重试时换了 `ReqKey` | 一次重试多出一个环境，用户手里两个环境 | `ReqKey` 是幂等键，重试**复用同一个值** |
| 建完立刻发凭证 | 用户拿到 key 却操作不了 | 用 `DescribeEnvs` 等到 `Status = NORMAL` 再发 |
| 一把 key 跨环境复用 | 用户 A 的操作落到用户 B 的环境 | 一把 key 只绑一个环境，换环境必须换 key |
| 用环境级 API Key 建环境 | 返回无权限 | 管控面接口只接受账号级凭据 |
| key 明文散落 | 写进对话、日志、工单后收不回来 | `ApiKey` 只返回一次，只走平台自己的下发通道交给用户；不要贴进对话 |
| 单环境建超过 5 把 key | 创建失败 | 单环境最多 5 个 API Key；轮换时先淘汰旧的 |

## 验证步骤

1. `DescribePlatforms` 回查 `PlatformList[]`：`PlatformId` 与预期一致，计费状态正常。
2. `DescribeEnvs` 按 `EnvId` 找到目标环境，`Status` = `NORMAL`。
3. 用第 4 步发出的 key 在用户侧走一次只读查询，见 [Recipe 8](./platform-agent-connect.md) 的验证步骤。
4. **反向验证**：换另一个环境的 key 调同一个查询，应看不到本环境的资源 —— 这一步验证的是隔离真的生效，而不只是接口能通。

## platform-usage-and-recycle

# Recipe 10 — 平台版用量、账期与环境回收

## When to use

平台版已经在给用户发环境，接下来要在自己的业务里回答「用完额度怎么办」：

- 按账期结算：某个用户这个周期用了多少资源点
- 找出高消耗环境，或按环境、按资源类型看用量明细
- 试用到期或欠费，要暂停环境，必要时销毁

不管什么：怎么建环境、怎么发凭证见 [Recipe 7](./platform-onboarding.md)。本篇只讲"看用量 + 处置"，不管支付、发票与退款。

## 前置权限

账号级凭据，且账号已购平台版套餐。环境级 API Key 调不了这批接口 —— 身份判定与补齐见 [calling-methods.md §3](../calling-methods.md)。

## 接口序列

| 步 | Action | service / version | 关键参数 |
| --- | --- | --- | --- |
| 1 | `DescribePlatforms` | tcb / 2018-06-08 | `{ "Limit": 10 }`，取 `PlatformList[].PlatformId` —— 后面几乎每个接口都要它 |
| 2 | `DescribePlatformAccountCircle` | tcb / 2018-06-08 | `{ "PlatformId": "...", "WithHistoryCircle": true }`，返回当前周期 `StartTime` / `EndTime`，`true` 时附带最近两个历史周期与 `Expired` |
| 3 | `DescribePlatformCreditsUsage` | tcb / 2018-06-08 | `{ "PlatformId": "...", "StartDate": "YYYY-MM-DD", "EndDate": "YYYY-MM-DD" }`，返回四类总量 + 每日明细 |
| 4 | `DescribePlatformCreditsUsageDetail` | tcb / 2018-06-08 | `{ "PlatformId": "...", "Modules": ["FLEXDB", "SCF"], "StartDate": "...", "EndDate": "...", "NeedUsageDetails": true }`，按模块 → 指标 → 每日拆开 |
| 5 | `DescribePlatformEnvUsage` | tcb / 2018-06-08 | `{ "EnvId": "...", "StartDate": "...", "EndDate": "...", "ResourceTypes": ["Storage", "Function"] }`，单个环境的按资源类型用量 |
| 6 | `DescribePlatformEnvCreditsRanking` | tcb / 2018-06-08 | `{ "PlatformId": "...", "TimeRange": "Recent7Days", "PageSize": 50 }`，各环境用量排行 |
| 7 | `ModifyPlatformEnv` | tcb / 2018-06-08 | `{ "EnvId": "...", "Status": "DISABLE" }` 暂停；`"ENABLE"` 恢复 |
| 8 | `DestroyPlatformEnv` | tcb / 2018-06-08 | `{ "EnvId": "..." }`，删环境并清除数据，**不可逆** |

### 两套时间参数别混

| 接口 | 时间参数 | 取值 |
| --- | --- | --- |
| `DescribePlatformCreditsUsage` / `...Detail` / `DescribePlatformEnvUsage` | `StartDate` / `EndDate` | 任意区间，格式 `YYYY-MM-DD` |
| `DescribePlatformAccountCircle` / `DescribePlatformEnvCreditsRanking` | `TimeRange` | 只能填枚举值：`Today`（近 1 天，默认）/ `Recent7Days` / `CurrentCycle` / `PreviousCycle` / `Previous2Cycle` |

账期**自购买日起算、按月滚**，不是自然月。要对账就用第 2 步返回的 `StartTime` / `EndTime` 当区间，不要自己按自然月推。

### 四类用量的口径

第 3 步的返回把用量分四类，用途不同：

| 字段 | 口径 | 用来判断 |
| --- | --- | --- |
| 套餐内抵扣 | 套餐额度里扣掉的 | 额度还剩多少 |
| 资源包抵扣 | 资源包里扣掉的 | 同上（有买资源包时） |
| 按量上报 | 超出套餐后按量计费的 | 超出多少钱 |
| 原价消耗 | 不折扣的原价口径 | 成本分析 |

判断"额度用完没有"看前两类；算"超了多少"看后两类。

### 用量感知只有轮询

判断"哪些环境该处置"目前只有一种方式：定时任务遍历环境列表，按各自账期查用量、比对额度、再下发处置。

用量变化的事件回调**暂未开放**，别去文档里找开关。环境数量多时，全量轮询的调用量是「环境数 × 轮询频率」，要控制频率或只轮询有风险的那批。

## 踩坑清单

| 坑 | 现象 | 正确做法 |
| --- | --- | --- |
| 给 `TimeRange` 传具体日期 | 报参数不合法 | 任意区间用 `StartDate` / `EndDate`；`TimeRange` 只吃那五个枚举值 |
| 按自然月算账期 | 对账对不上 | 账期自购买日起算；用 `DescribePlatformAccountCircle` 的返回值当区间 |
| 拿排行数据做实时判定 | 数字比实际少，像漏报 | 排行由后台定时计算，**有小时级延迟**；实时判定用 `DescribePlatformEnvUsage` |
| 把暂停当省钱手段 | 暂停后资源点照旧消耗 | 暂停只停服务不停计费；要停止消耗只能销毁 |
| 在停服状态下调暂停 / 恢复 | 调用失败 | 账号处于超限停服或到期隔离时这两个动作不可用；先恢复套餐 |
| 销毁前没确认依赖 | 用户数据一起没了 | 销毁不可逆；先暂停观察一段时间，或先导出需要的数据 |
| 只查账号总量就下发处置 | 不知道该停哪个环境 | 先按环境查（第 5 步）或看排行（第 6 步），再决定处置对象 |

## 验证步骤

1. `DescribePlatformAccountCircle`：当前周期起止时间与套餐购买日推得出的一致，`Expired` 与套餐实际状态相符。
2. `DescribePlatformCreditsUsage`（区间取当前周期）：四类总量与每日明细都在；**每日之和应等于对应总量**，不等说明区间没对齐。
3. `DescribePlatformEnvCreditsRanking`：排行靠前的环境与你已知的高消耗环境吻合。
4. 处置后回查：`DescribeEnvs` 里目标环境状态已变；再调一次 `ModifyPlatformEnv` 传 `"ENABLE"` 把它恢复，确认启停双向可用。

## service-versions

# Service 索引 — `callCloudApi` 支持的产品

`service` 是**枚举白名单**：只接受下表的产品标识，名单外的取值（对象存储 COS 这类不在云 API 体系内的产品、以及任何拼写错误）在请求出网前就被拒。

**权威顺序**：工具 schema 的 `enum`（随版本发布）> 本页。本页用于人工查阅 —— 尤其是「中文产品名 → service 标识」的对照，以及哪些产品必须显式传 `version`。

## 用法要点

- `version` 多数可以省：只有一个官方版本的产品由映射表自动补齐（例如 `ssl` → `2019-12-05`）。
- **多版本产品必须显式传**（下表标 ⚠️）：缺省会报错并列出可选值，不会替你猜 —— 猜错会被服务端报成 `action is invalid or not found`，很难排查。
- service 标识就是官方 SDK 的目录名：`tencentcloud/<service>/v<YYYYMMDD>`。
- 常用 **Action 名与参数示例**（`tcb` / `tcbr` 的常见操作）见 [`./calling-methods.md`](./calling-methods.md) §1。

## 云开发 / 管控面

| service | 产品 | version |
| --- | --- | --- |
| `tcb` | 云开发 CloudBase | `2018-06-08` |
| `tcbr` | 云托管 CloudBase Run | `2022-02-17` |
| `scf` | 云函数 SCF | `2018-04-16` |
| `sts` | 临时密钥服务 | `2018-08-13` |
| `cam` | 访问管理 | `2019-01-16` |
| `cloudaudit` | 云审计 | `2019-03-19` |
| `tag` | 标签 | `2018-08-13` |
| `billing` | 计费 | `2018-07-09` |
| `region` | 地域 | `2022-06-27` |

## 备案

| service | 产品 | version |
| --- | --- | --- |
| `ba` | ICP 备案 | `2020-07-20` |

## 计算 / 容器 / 存储

| service | 产品 | version |
| --- | --- | --- |
| `cvm` | 云服务器 | `2017-03-12` |
| `lighthouse` | 轻量应用服务器 | `2020-03-24` |
| `tke` | 容器服务 TKE | ⚠️ `2018-05-25` / `2022-05-01` |
| `cbs` | 云硬盘 | `2017-03-12` |
| `cfs` | 文件存储 | `2019-07-19` |
| `tcr` | 容器镜像服务 | `2019-09-24` |

## 数据库

| service | 产品 | version |
| --- | --- | --- |
| `cdb` | 云数据库 MySQL | `2017-03-20` |
| `mariadb` | 云数据库 MariaDB | `2017-03-12` |
| `postgres` | 云数据库 PostgreSQL | `2017-03-12` |
| `sqlserver` | 云数据库 SQL Server | `2018-03-28` |
| `redis` | 云数据库 Redis | `2018-04-12` |
| `mongodb` | 云数据库 MongoDB | ⚠️ `2018-04-08` / `2019-07-25` |
| `cynosdb` | 云数据库 TDSQL-C MySQL | `2019-01-07` |
| `dcdb` | 分布式数据库 TDSQL | `2018-04-11` |
| `tcaplusdb` | 游戏数据库 TcaplusDB | `2019-08-23` |
| `keewidb` | 云数据库 KeeWiDB | `2022-03-08` |

## 网络 / 域名 / 证书

| service | 产品 | version |
| --- | --- | --- |
| `vpc` | 私有网络 | `2017-03-12` |
| `clb` | 负载均衡 | `2018-03-17` |
| `cdn` | 内容分发网络 | `2018-06-06` |
| `ecdn` | 全站加速网络 | `2019-10-12` |
| `dnspod` | DNS 解析 DNSPod | `2021-03-23` |
| `privatedns` | 私有域解析 Private DNS | `2020-10-28` |
| `domain` | 域名注册 | `2018-08-08` |
| `ssl` | SSL 证书 | `2019-12-05` |
| `teo` | 边缘安全加速平台 EdgeOne | ⚠️ `2022-01-06` / `2022-09-01` |
| `gaap` | 全球应用加速 | `2018-05-29` |

## 安全

| service | 产品 | version |
| --- | --- | --- |
| `kms` | 密钥管理系统 | `2019-01-18` |
| `ssm` | 凭据管理系统 | `2019-09-23` |
| `waf` | Web 应用防火墙 | `2018-01-25` |
| `cwp` | 主机安全 | `2018-02-28` |
| `tcss` | 容器安全服务 | `2020-11-01` |

## 中间件 / 消息

| service | 产品 | version |
| --- | --- | --- |
| `ckafka` | 消息队列 CKafka | `2019-08-19` |
| `tdmq` | 消息队列 TDMQ | `2020-02-17` |
| `tdmysql` | 云数据库 TDSQL MySQL 版 | `2021-11-22` |
| `apigateway` | API 网关 | `2018-08-08` |

## 可观测 / 运维

| service | 产品 | version |
| --- | --- | --- |
| `monitor` | 云监控（可观测平台） | ⚠️ `2018-07-24` / `2023-06-16` |
| `cls` | 日志服务 | `2020-10-16` |
| `apm` | 应用性能监控 | `2021-06-22` |
| `tsf` | 微服务平台 | `2018-03-26` |
| `tat` | 自动化助手 | `2020-10-28` |

## AI / 音视频

| service | 产品 | version |
| --- | --- | --- |
| `hunyuan` | 混元大模型 | `2023-09-01` |
| `lkeap` | 大模型知识引擎 | `2024-05-22` |
| `tts` | 语音合成 | `2019-08-23` |
| `trtc` | 实时音视频 | `2019-07-22` |
| `live` | 云直播 | `2018-08-01` |
| `vod` | 云点播 | ⚠️ `2018-07-17` / `2024-07-18` |

## 通信

| service | 产品 | version |
| --- | --- | --- |
| `sms` | 短信 | ⚠️ `2019-07-11` / `2021-01-11` |
| `ses` | 邮件推送 | `2020-10-02` |

## rule

---
name: cloud-api-operations
description: Operate Tencent Cloud control-plane resources (monitoring/alarms, CLB, CAM roles, COS, MySQL, SCF) via cloud APIs when no dedicated MCP tool covers the task. Use when a task needs control-plane operations beyond CloudBase's own tooling, or when a callCloudApi call failed and needs classifying.
version: 2.35.2
license: MIT
---

# Cloud API Operations

Operate Tencent Cloud resources that CloudBase depends on but that no dedicated MCP tool covers (monitoring & alarms, CLB, CAM roles, cross-product infra). Two goals: **find the right API without guessing**, and **reuse proven workflows instead of re-exploring**.

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../cloudbase-platform/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## When to use

- The user asks to manage/operate Tencent Cloud resources beyond CloudBase's dedicated MCP tools (e.g. configure alarm policies, inspect CLB, attach CAM policies).
- The user wants to control these resources from code and asks which API/SDK to use.
- A callCloudApi call failed and you need to classify the error (wrong Action / wrong params / missing CAM permission) and recover.

## Workflow

### 1. Discover the API — resolve names from a documented source

1. **Read the API index first**: https://docs.cloudbase.net/ai/cloudbase-ai-toolkit/api-reference.md — auto-synced daily, action-level coverage (TCB 105 + dependency products: MySQL / SCF / COS). Check rate limits there too. The index check is a quick grep — run it in parallel with step 2/3 fetches, do not serialize.
2. If the index does not cover the target product, go to the product's official API docs (e.g. monitor: https://cloud.tencent.com/document/product/649/30343) and confirm the exact Action name, Version, and parameters.
3. For machine-readable parameter schema, fetch the official SDK models source directly — see `./references/calling-methods.md` §2 item 4.

**Done when**: the Action name, Version, and full parameter shape each trace to the index, official product docs, or SDK models source — nothing from memory. A call that still returns `action ... is invalid or not found` means a name was not resolved this way; classify and recover via the error table in `./references/calling-methods.md` §1.

> **API first：公开 API 概览就是契约边界。** 索引里查不到某个能力，它就不在公开契约内 —— 不要拿某个 SDK 的封装方法反推未公开的 Action 名去调（这类 Action 不受公开文档保护，非该语言的使用者也无从照做）。此时改用有公开 API 的等价路径，或把缺口明确告诉用户。本 skill 的 recipes 只收录公开 API 覆盖的场景。

### 2. Choose the calling path

| Scenario | Path | Reference |
| --- | --- | --- |
| Interactive ops inside this session | MCP `callCloudApi` | `./references/calling-methods.md` §1 |
| Picking the `service` identifier / deciding whether `version` is needed | MCP `callCloudApi` | `./references/service-versions.md` |
| User's code / scripts | Official SDKs (TC3-HMAC-SHA256) or `@cloudbase/manager-node` | `./references/calling-methods.md` §2 |
| Quick one-off verification | API Explorer (https://console.cloud.tencent.com/api/explorer) | — |

Priority rule: if `@cloudbase/manager-node` has a matching method, use it; drop to raw cloud API only when it does not.

### 3. Check credentials before the first call

**Three identities produce the same error text.** Before reading anything into an `UnauthorizedOperation`, find out which one you are holding:

| Identity | How it is reached | CAM / CloudAudit |
| --- | --- | --- |
| Account-level login (`federated-user/<id>`) | Device-code / web login, or account-level SecretId + Key | reachable, subject to that identity's CAM policies |
| `TCB_QcsRole` service role | what CLI / MCP **become** after calling a CloudBase product API | refused (`resource (...) has no permission`) |
| Environment API Key (`<uin>:TCB-CAPI-Configured-idaas-apikey`) | `--cloudbase-api-key -e <envId>` | refused — the API Key model has no channel to attach arbitrary CAM policies |

Confirm the identity with `sts GetCallerIdentity` (`--api-version 2018-08-13`) before concluding anything: the refusal text is identical across all three rows, so it cannot tell you which row you are in.

**Order matters.** Calling a CloudBase product API swaps the identity to `TCB_QcsRole` for the rest of the session, so a CAM / CloudAudit call issued *after* any product call is refused even though the login is account-level. Do the CAM / audit work **first**.

- Read the current credential scope from `auth` tools: `credential_scope: account` = account-level, reaches control-plane APIs subject to that identity's CAM policies; `env` = API Key, scoped to one environment's data plane plus the fixed TCB policies.
- Permission comes from a different place per credential identity: the account-level identity's own policies, the API Key model (no channel to attach arbitrary CAM policies), or the TCB service role that CLI / MCP assume. Which cross-product capabilities that role family already covers is not fixed — read the attached policies (`ListAttachedRolePolicies` + `GetPolicy`) instead of assuming, and treat `UnauthorizedOperation` as "this identity lacks this action", never as a broken setup.
- On `UnauthorizedOperation` / `AuthFailure`, hand the user a **one-click CAM grant link** (role name + policy name + `principal`) instead of telling them to go find the policy in the console, then retry the original call. Role targets, the `principal` values, and which preset policy covers what: `./references/calling-methods.md` §3.

**Done when**: the credential identity has been confirmed with `sts GetCallerIdentity` (not inferred from the error text), and every permission error has been converted into a clickable authorization link carrying a concrete policy name before any retry.

### 4. Follow a proven recipe when one exists

Recipes encode the exact call sequence, required parameters, and empirically discovered pitfalls so the flow works on the first pass. One scenario per file — start from the index `./references/recipes/README.md`, whose 状态 column records how far each recipe has been verified:

- **PostgreSQL storage-usage alarm**: `./references/recipes/pg-storage-alarm.md`
- **ICP filing readiness and wait-time checks**: `./references/recipes/icp-filing-readiness.md`
- **PostgreSQL instance spec change and shared-to-dedicated upgrade**: `./references/recipes/pg-instance-spec.md`
- **Custom domain onboarding for an env (HTTP access domain, certificate, DNS binding)**: `./references/recipes/custom-domain.md`
- **Operation trace / 操作审计 — who did what, from which IP, with which key**: `./references/recipes/cloud-audit-operation-trace.md`
- **Platform edition onboarding — create env and issue the environment API key**: `./references/recipes/platform-onboarding.md`
- **Wiring that credential into a user's agent, one env per project**: `./references/recipes/platform-agent-connect.md`
- **Closing down the agent's tool surface — plugin trimming, gateway wrap for audit, expert-enforced constraints**: `./references/recipes/platform-agent-guardrails.md`
- **Platform edition usage, billing cycle, and environment recycling**: `./references/recipes/platform-usage-and-recycle.md`

**Done when**: every parameter value in the call sequence traces to a recipe value marked as verified (实测) or to official docs.

## Constraints

- Region is a top-level `region` argument (X-TC-Region), never a body param. Some APIs additionally take a short region code inside `Dimensions` (e.g. `sh` vs `ap-shanghai`) — these are different fields.
- Route SDK-language details to official SDK docs or sdkHints; keep this skill SDK-language-agnostic.

## checklist

# Cloud Functions Execution Checklist

Use this checklist before creating or updating a CloudBase function.

## Required checks

1. Decide whether this is an Event Function or an HTTP Function.
   - Event Function: `exports.main(event, context)`, SDK/timer driven
   - HTTP Function: `req` / `res`, listens on port `9000`
2. Pick the runtime before creation and state it explicitly.
   - For a managed runtime, choose a language runtime (e.g. `Nodejs18.15`).
   - For a container-image HTTP Function, set `runtime: "CustomImage"` and provide `imageConfig` (`imageUri` with tag; `registryId` for enterprise TCR). The image still listens on port `9000`. See `references/http-functions-custom-image.md`.
3. For HTTP Functions on a managed runtime, confirm `scf_bootstrap` exists and the Node.js binary path matches the runtime (e.g. `Nodejs18.15` → `/var/lang/node18/bin/node`). Custom Image functions do not use `scf_bootstrap`.
4. If an HTTP Function calls CloudBase resources through `@cloudbase/node-sdk` or `@cloudbase/manager-node`, complete `references/http-function-credentials.md`. Do not rely on the default temporary credential path:
   - Node SDK: inject `CLOUDBASE_APIKEY`, preferably after creating a server key with `manageAppAuth(action="createApiKey", keyType="api_key")`, or inject a Tencent Cloud key pair.
   - Manager SDK: inject a Tencent Cloud `SecretId` / `SecretKey` pair.
   - Never commit credentials, return them to clients, or overwrite unrelated function environment variables.
5. Confirm no response path echoes `x-cloudbase-context`, full `req.headers` / `event` / `context`, or `process.env`. Follow `../cloudbase-platform/references/protocols/sensitive-runtime-data-protection.md`.
6. Confirm the function root path points to the parent directory, not the function directory itself. (Not needed for Custom Image deploys — the code lives in the image.)
7. For Custom Image deploys, confirm TCR, the CloudApp build, and SCF are in the same region, and the image tag is unique (not `:latest`). Remember Stage A (CloudApp custom build → TCR push) is a raw Tencent Cloud API path, not covered by MCP tools.
8. For HTTP Functions that need public access, configure the function security rule with `managePermissions(action="updateResourcePermission", resourceType="function")` after creation. Default rules reject unauthenticated callers with `EXCEED_AUTHORITY`. Note: anonymous login is disabled by default — use `rule: "true"` for public endpoints.
9. If creating or mutating a function **layer**, follow the account-scoped naming contract (same as MCP tool descriptions):
   - New layer names must use `{layerName}_{当前envId}` (e.g. `common_cloud1-d9ghadgak3edf6b36`). Pass that full string as `layerName`; do not auto-append suffixes in client code.
   - Before `createLayerVersion`, call `queryFunctions(action="listLayers")` to avoid colliding with another env's bare name.
   - Treat envelope `warnings` as soft advisories (success still means the call ran). Deleting a layer version or rebinding layers can impact every env that shares that LayerName.
   - Details: `references/operations-and-config.md`.
10. If the request is really for a long-running container service, reroute to `cloudrun-development`.

## Common failure patterns

- Choosing the wrong function type and compensating later.
- Mixing Event Function and HTTP Function handler shapes in the same implementation.
- Forgetting that runtime cannot be changed after creation.
- Mismatching the `scf_bootstrap` Node.js binary path with the function runtime.
- Relying on passwordless/default temporary credentials when an HTTP Function calls a CloudBase SDK.
- Returning request headers, environment dumps, or `x-cloudbase-context` from debug/hello endpoints.
- For Custom Image functions: using `:latest`, mismatched regions across TCR/CloudApp/SCF, or assuming MCP covers the CloudApp build → TCR push stage (it does not).
- Forgetting to configure function security rules for HTTP Functions that need public access.
- Treating Cloud Functions as the default answer for Web authentication.
- Creating layers with a bare name (e.g. `common`) so multiple envs share one version sequence, or ignoring MCP layer `warnings` about account-scoped sharing.

## Done criteria

- Function type and runtime are explicit.
- Packaging constraints are checked.
- HTTP Function SDK credentials are explicit and a real SDK operation was verified after deployment.
- No response echoes `x-cloudbase-context`, full headers, or credential env vars.
- If layers were created, names follow `{layerName}_{当前envId}` and duplicate checks were done via `listLayers`.
- The task is confirmed to be a function workflow rather than CloudRun.

## references

# Cloud Functions Reference Map

Use this file to decide which detailed reference to read after the main skill.

## Read this next when

- You already know the task belongs to Cloud Functions, but the main `SKILL.md` is intentionally keeping only the routing and guardrails.

## Reference routing

### `./references/event-functions.md`

Read this when the task is about:

- `exports.main(event, context)`
- SDK-invoked serverless functions
- timer-triggered jobs
- Event Function deployment or invocation patterns

### `./references/http-functions.md`

Read this when the task is about:

- HTTP endpoints
- REST APIs
- SSE or WebSocket services
- `scf_bootstrap`
- browser/public access paths for HTTP Functions

### `./references/http-function-credentials.md`

Read this whenever a managed-runtime or Custom Image HTTP Function calls CloudBase resources through:

- `@cloudbase/node-sdk`
- `@cloudbase/manager-node`
- `CLOUDBASE_APIKEY`
- Tencent Cloud `SecretId` / `SecretKey`

HTTP Functions must use an explicit credential path. The Event Function passwordless runtime path does not apply reliably to HTTP Functions.

### `./references/http-functions-custom-image.md`

Read this when the task is about:

- deploying an HTTP Function from a **container image** (`Runtime: CustomImage`)
- `imageConfig` / `ImageUri` / TCR image addresses
- the zip → COS → CloudApp custom build → TCR → SCF image pipeline
- choosing between a managed-runtime HTTP Function, a Custom Image HTTP Function, and a CloudRun container

### `./references/operations-and-config.md`

Read this when the task is about:

- function logs
- timeout / environment-variable updates
- timer cron format
- VPC field shape only (examples) — for TCP DB policy see `vpc-and-tcp-database.md` (exception-only)
- gateway exposure for Event Functions
- SCF layers: account-scoped naming `{layerName}_{当前envId}`, soft `warnings`, list/create/bind/delete actions
- legacy tool-name translation
- `callCloudApi` fallback for Cloud Functions

### `./references/vpc-and-tcp-database.md` (exception-only — do not read by default)

Read this **only** when the task is migrating an **existing** app that already uses classic TCP clients:

- existing `DATABASE_URL` / Prisma / TypeORM / Sequelize / `mysql2` / `pg` / Redis TCP clients
- private MySQL / PostgreSQL / Redis connectivity from Event or HTTP Functions that cannot use native SDK

**Do NOT read this for new business CRUD.** Prefer CloudBase native SDK (`app.rdb()` / `app.database()`) or MCP SQL tools. New apps must not introduce TCP DB clients, ask users for DB passwords, or treat VPC binding as the default path.

When this exception applies:

- `vpc.vpcId` / `vpc.subnetId` is mandatory for private TCP access
- **never guess** VPC IDs

## Keep these distinctions straight

- Event Function code shape: `exports.main(event, context)`
- HTTP Function code shape: `req` / `res` web server on port `9000`
- Event Functions can use the platform-provided runtime credential path; HTTP Functions that call CloudBase SDKs must follow `http-function-credentials.md`
- HTTP Access for Event Functions is a gateway configuration, not the HTTP Function runtime model
- CloudRun is the right route when the task is actually a long-lived service or broader container workload
- Custom Image HTTP Function (`Runtime: CustomImage`) still listens on the fixed port `9000` and is request-driven — distinct from a CloudRun container, which listens on the injected `PORT` and runs long-lived

## event-functions

# Event Functions Reference

Use this reference when the task is clearly about an Event Function (`exports.main(event, context)`) rather than an HTTP Function.

## Runtime and packaging facts

- Runtime is fixed at creation time and cannot be changed later.
- For new functions, prefer `Nodejs18.15` unless dependency compatibility forces an older runtime.
- Event Functions auto-install dependencies from `package.json` during deployment, so you normally do not ship `node_modules`.
- The function root path must point to the parent directory that contains the function folder.

## Minimal structure

```text
cloudfunctions/
└── myFunction/
    ├── index.js
    └── package.json
```

```javascript
exports.main = async (event, context) => {
  return {
    code: 0,
    message: "ok",
    data: { event }
  };
};
```

## Create or update flow

### Create

Use `manageFunctions(action="createFunction")` and make the function type explicit.

```javascript
manageFunctions({
  action: "createFunction",
  func: {
    name: "myFunction",
    type: "Event",
    runtime: "Nodejs18.15",
    timeout: 30
  },
  functionRootPath: "/absolute/path/to/cloudfunctions"
});
```

### Update code

Use `manageFunctions(action="updateFunctionCode")` when only code changes.

```javascript
manageFunctions({
  action: "updateFunctionCode",
  functionName: "myFunction",
  functionRootPath: "/absolute/path/to/cloudfunctions"
});
```

### Key reminders

- `updateFunctionCode` does not change runtime.
- If runtime must change, recreate the function.
- Prefer MCP management tools when available; if MCP tools are missing in this session, use `tcb fn deploy` via `cloudbase-cli` (see guideline `tooling-fallback.md`).

## Invocation patterns

### Web

```javascript
import cloudbase from "@cloudbase/js-sdk";

const app = cloudbase.init({ env: "your-env-id" });
const result = await app.callFunction({
  name: "myFunction",
  data: { userId: "123" }
});
```

### Mini Program

```javascript
const result = await wx.cloud.callFunction({
  name: "myFunction",
  data: { userId: "123" }
});
```

### Node.js backend

```javascript
const tcb = require("@cloudbase/node-sdk");
const app = tcb.init({ env: "your-env-id" });

const result = await app.callFunction({
  name: "myFunction",
  data: { userId: "123" }
});
```

### Raw HTTP API

Use the CloudBase HTTP API only when the task is explicitly about raw API invocation.

```text
https://{envId}.api.tcloudbasegateway.com/v1/functions/{functionName}
```

This path requires authentication and belongs with the `http-api-cloudbase` skill, not browser-facing anonymous access.

## Common patterns

### Error handling

```javascript
exports.main = async (event, context) => {
  try {
    const result = await doWork(event);

## http-function-credentials

# Runtime Credentials for CloudBase SDKs

Use this reference whenever a **server-side compute resource** calls CloudBase resources through `@cloudbase/node-sdk` or `@cloudbase/manager-node`:

- HTTP Functions (managed runtime or Custom Image)
- CloudBase Run services, **Function mode** and **Container mode** both

CloudRun containers do not automatically carry usable CloudBase credentials for this path — the same explicit credential gate below applies before deployment.

## Credential boundary

> **STOP:** Do not assume a server-side compute resource — HTTP Function or CloudRun service — can use CloudBase SDKs without explicit credentials.

Event Functions can use the platform-provided runtime credential path. HTTP Functions must not depend on that default temporary credential injection: credential rotation can leave the process with invalid credentials and cause intermittent authorization failures.

Before deploying an HTTP Function that calls CloudBase SDKs:

1. Identify which SDK the function uses.
2. Select one supported explicit credential path below.
3. Issue the credential through the platform API, never by copying a key out of a local client login state (`auth.json`, `.cloudbase/`). A key with no `keyName` has no owner, no rotation record, and no `keyId` to revoke.
4. Store credentials in environment variables, never in source code.
   - HTTP Function → read the current config, merge, then `manageFunctions(action="updateFunctionConfig")`.
   - CloudRun service → merge into `serverConfig.EnvParams` via `manageCloudRun(action="deploy" | "updateConfig")`.
5. Verify one real SDK operation after deployment, more than once.
6. Record the key owner and the rotation/revocation path. Rotating a key invalidates the in-container copy silently, so redeploy after every rotation.

## `@cloudbase/node-sdk`

Choose one of these server-side paths:

### Preferred: CloudBase server API Key

First inspect existing server keys:

```javascript
queryAppAuth({
  action: "listApiKeys",
  keyType: "api_key",
  pageNumber: 1,
  pageSize: 20
});
```

If no suitable dedicated key exists, create one through MCP:

```javascript
manageAppAuth({
  action: "createApiKey",
  keyType: "api_key",
  keyName: "http-function-my-service",
  expireIn: 0
});
```

Inject the returned key as `CLOUDBASE_APIKEY`. Do not print it, commit it, return it to a client, or put it in browser code.

- HTTP Function → `manageFunctions(action="updateFunctionConfig", ...)`
- CloudRun service → `manageCloudRun(action="deploy" | "updateConfig", serverConfig={ "EnvParams": "{\"CLOUDBASE_APIKEY\":\"<key>\"}" })`, merging existing env keys instead of replacing the whole object

Use a dedicated key name for each service and define a rotation/revocation owner. `expireIn: 0` avoids automatic expiry but creates a long-lived secret, so use it only when the deployment's secret-rotation process is explicit.

The Node SDK reads this variable automatically:

```javascript
const tcb = require("@cloudbase/node-sdk");

const app = tcb.init({
  env: process.env.TCB_ENV
});
```

The equivalent explicit initialization field is `accessKey`, but the environment-variable path avoids embedding the key in source:

```javascript
const app = tcb.init({
  env: process.env.TCB_ENV,
  accessKey: process.env.CLOUDBASE_APIKEY
});
```

### Alternative: Tencent Cloud permanent key pair

Inject both:

- `TENCENTCLOUD_SECRETID`
- `TENCENTCLOUD_SECRETKEY`

Then initialize the Node SDK with the environment ID. The SDK reads the key pair from those environment variables:

```javascript
const tcb = require("@cloudbase/node-sdk");

const app = tcb.init({
  env: process.env.TCB_ENV
});
```

Do not inject only one member of the pair.

Use a dedicated CAM sub-account with the minimum permissions required by the function instead of a root-account key.

## `@cloudbase/manager-node`

The Manager SDK documentation supports Tencent Cloud credentials, not the CloudBase server API Key used by `@cloudbase/node-sdk`.

Inject:

- `TENCENTCLOUD_SECRETID`
- `TENCENTCLOUD_SECRETKEY`

Pass them explicitly during initialization:

```javascript
const CloudBase = require("@cloudbase/manager-node");

const app = CloudBase.init({
  envId: process.env.TCB_ENV,
  secretId: process.env.TENCENTCLOUD_SECRETID,
  secretKey: process.env.TENCENTCLOUD_SECRETKEY
});

## http-functions-custom-image

# HTTP Functions — Custom Image Deployment Reference

Use this reference when an HTTP Function must run from a **container image** instead of the managed Node.js/Python runtime. This is the `Runtime: CustomImage` path: the code is packaged as a Docker image, pushed to TCR (Tencent Container Registry), and SCF runs that image.

## When to choose Custom Image (vs the other two HTTP options)

| Deployment form | Choose when | How it deploys |
| --- | --- | --- |
| **Managed runtime** (default, see `http-functions.md`) | Plain Node.js / Python, dependencies are simple | `manageFunctions(createFunction)` + `scf_bootstrap` + zip |
| **Custom Image** (this file) | Need custom system libraries / arbitrary runtime, but still want SCF request-driven execution and scale-to-zero | CloudApp custom build → TCR → SCF image function |
| **CloudRun container** (see `cloudrun-development`) | Long-lived process, persistent connections, listens on injected `PORT` | `manageCloudRun` |

Keep Custom Image HTTP Functions distinct from CloudRun containers — both use a Dockerfile, but:

- **Custom Image HTTP Function**: container listens on a **fixed port `9000`**, request-driven, scales to zero. SCF gateway sends each HTTP request into the container.
- **CloudRun container**: container listens on the **injected `PORT`** env var, long-lived process.

Do not blend the two contracts.

## CloudBase SDK credential gate

Custom Image changes packaging, not the HTTP Function credential boundary. If the image calls CloudBase resources through `@cloudbase/node-sdk` or `@cloudbase/manager-node`, read `./http-function-credentials.md` before deployment.

- Do not rely on the Event Function passwordless/default temporary credential path.
- For `@cloudbase/node-sdk`, inject `CLOUDBASE_APIKEY` from a server API Key created through `manageAppAuth(action="createApiKey", keyType="api_key")`, or inject a Tencent Cloud key pair.
- For `@cloudbase/manager-node`, inject a Tencent Cloud `SecretId` / `SecretKey` pair.
- Keep credentials out of the Dockerfile, image layers, build arguments, source code, logs, and responses.

## End-to-end pipeline (6 steps)

The link between the two stages is the TCR image address:

```text
ImageUri = {TCR_REGISTRY}/{TCR_NAMESPACE}/{ServiceName}:{VersionName}
example:   ccr.ccs.tencentyun.com/your-ns/demo-app:demo-app-001
```

```text
Stage A — build the image (CloudApp custom build pipeline)
  ① DescribeCloudAppCosInfo   -> get COS upload credentials + UnixTimestamp
  ② PUT zip to COS            -> upload source
  ③ CreateCloudApp            -> trigger docker build + docker push to TCR
  ④ DescribeCloudAppVersion   -> poll until Status=SUCCESS, read VersionName

Stage B — deploy to SCF (based on the TCR image)
  ⑤ createFunction / updateFunctionCode  -> SCF image function
  ⑥ getFunctionDetail (optional)         -> confirm Status=Active
```

## Tooling boundary (read this before acting)

- **Stage B (SCF image deploy) is covered by `manageFunctions`.** Use `manageFunctions(action="createFunction")` with `func.runtime="CustomImage"` + `imageConfig`, and `manageFunctions(action="updateFunctionCode")` + `imageConfig` for later iterations. The Manager SDK auto-fills `ImageType=enterprise` and `ImagePort=9000`, and strips Handler / dependency install for image functions.
- **Stage A (CloudApp custom build → TCR) is NOT covered by MCP tools.** The `manageApps` / `queryApps` tools only support `static-hosting`. The custom-build pipeline (`DeployType=custom`, `CustomSteps`, `DescribeCloudAppCosInfo` with `DeployType=custom`) is a **raw Tencent Cloud API path**. Treat it as a `callCloudApi` fallback:
  - Confirm the exact action name, parameters, and `X-TC-Version` from official docs **before** calling — do not guess payloads from memory.
  - CloudApp build APIs are on `tcb.tencentcloudapi.com` (`X-TC-Version: 2018-06-08`).
  - SCF APIs are on `scf.tencentcloudapi.com` (`X-TC-Version: 2018-04-16`).
- **Region must match.** TCR, the CloudApp build, and SCF must be in the same region (e.g. all `ap-shanghai`). Cross-region image pulls time out.

## Stage B with `manageFunctions` (the supported path)

### Create (first deploy)

```javascript
manageFunctions({
  action: "createFunction",
  func: {
    name: "my-scf-func",
    type: "HTTP",
    runtime: "CustomImage"
  },
  imageConfig: {
    imageType: "enterprise",
    imageUri: "ccr.ccs.tencentyun.com/your-ns/demo-app:demo-app-001",
    registryId: "tcr-xxxxxxxx",
    command: "python",
    args: "-u app.py",
    imagePort: 9000,
    containerImageAccelerate: true
  }
});
```

### Update image (later iterations)

Only the tag changes; no local code packaging.

```javascript
manageFunctions({
  action: "updateFunctionCode",
  functionName: "my-scf-func",
  imageConfig: {
    imageType: "enterprise",
    imageUri: "ccr.ccs.tencentyun.com/your-ns/demo-app:demo-app-002",
    registryId: "tcr-xxxxxxxx"
  }
});
```

### `imageConfig` fields

| Field | Required | Notes |
| --- | --- | --- |
| `imageUri` | yes | Full address **with tag**: `{domain}/{ns}/{image}:{tag}`. Never `:latest`. |
| `imageType` | — | `"enterprise"` (TCR enterprise) or `"personal"`. Defaults to `enterprise`. |
| `registryId` | enterprise only | TCR instance id `tcr-xxxxxxxx`. Required when `imageType=enterprise`. |
| `command` | — | Overrides `ENTRYPOINT`. Omit to use the Dockerfile default. |
| `args` | — | Overrides `CMD`, space-separated. |
| `imagePort` | — | Web Server: `9000` (default). Job-style image: `-1`. |
| `containerImageAccelerate` | — | Image acceleration; enable for large images to cut cold-start time. |

After deploy, confirm readiness with `queryFunctions(action="getFunctionDetail", functionName="my-scf-func")` and look for `Status=Active`. If the tool result already contains `accessUrl` / `accessUrls`, prefer those links directly. If no URL is returned yet, create a Domain/Route explicitly with `manageGateway(action="createRoute", upstreamResourceType="WEB_SCF")` and set the function security rule (anonymous login is disabled by default — see `http-functions.md`).

## Source packaging (Stage A input)

Package the **contents** of the project root, with a `Dockerfile` at the root — do not nest an extra top-level folder.

```bash
# correct: zip the contents from inside the project root
cd ./my-app
zip -r ../my-app.zip .

## http-functions

# HTTP Functions Reference

Use this reference when the task is clearly about an HTTP Function: REST API, browser-facing endpoint, SSE stream, or WebSocket service.

## Core model

HTTP Functions are standard web services, not `exports.main(event, context)` handlers.

- Handle requests through `req` and `res`.
- Listen on port `9000`.
- Ship an executable `scf_bootstrap` file.
- Include runtime dependencies in the package; HTTP Functions do not auto-install `node_modules` for you.
- For simple HTTP APIs, prefer the Node.js native `http` module so the function shape stays explicit and dependency-light. Only introduce Express, Koa, NestJS, or similar frameworks when the user explicitly asks for one or the service complexity justifies it.
- If the service calls CloudBase resources through `@cloudbase/node-sdk` or `@cloudbase/manager-node`, read `./http-function-credentials.md` first. HTTP Functions must use explicit credentials and must not rely on the Event Function passwordless/default temporary credential path.

## Minimal structure

```text
my-http-function/
├── scf_bootstrap
├── package.json
├── node_modules/
└── index.js
```

### `scf_bootstrap`

```bash
#!/bin/bash
/var/lang/node18/bin/node index.js
```

Requirements:

- File name must be exactly `scf_bootstrap`.
- Use LF line endings.
- Make it executable with `chmod +x scf_bootstrap`.

The `scf_bootstrap` Node.js binary path must match the function runtime. Use this mapping:

| Runtime value | `scf_bootstrap` binary path |
| --- | --- |
| `Nodejs20.19` | `/var/lang/node20/bin/node` |
| `Nodejs18.15` | `/var/lang/node18/bin/node` |
| `Nodejs16.13` | `/var/lang/node16/bin/node` |

If the user specifies "Node.js 18", use runtime `Nodejs18.15` and the path `/var/lang/node18/bin/node`.

## Minimal Node.js example

```javascript
const http = require("http");
const { URL } = require("url");

// CORS: leave this empty when the function is reached through the HTTP gateway.
// The gateway already fills Access-Control-Allow-Origin from the environment
// security-domain allowlist; adding a second value makes the header illegal
// ('<origin>,*') and browsers block every request. Only set CORS headers here
// when the function is called directly, outside the gateway.
const CORS_HEADERS = {};

function sendJson(res, statusCode, data) {
  res.writeHead(statusCode, {
    "Content-Type": "application/json; charset=utf-8",
    ...CORS_HEADERS,
  });
  res.end(JSON.stringify(data));
}

function sendOptions(res) {
  res.writeHead(204, CORS_HEADERS);
  res.end();
}

function readJsonBody(req) {
  return new Promise((resolve, reject) => {
    let raw = "";

    req.on("data", (chunk) => {
      raw += chunk;
    });

    req.on("end", () => {
      if (!raw) {
        resolve({});
        return;
      }

      try {
        resolve(JSON.parse(raw));
      } catch (error) {
        reject(new Error("Invalid JSON body"));
      }
    });

    req.on("error", reject);
  });
}

const server = http.createServer(async (req, res) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return sendOptions(res);
  }

  const url = new URL(req.url || "/", "http://127.0.0.1");

  if (req.method === "GET" && url.pathname === "/health") {
    sendJson(res, 200, { ok: true });
    return;
  }

  if (req.method === "POST" && url.pathname === "/echo") {
    try {
      const body = await readJsonBody(req);
      sendJson(res, 200, { received: body });
    } catch (error) {
      sendJson(res, 400, { error: error.message });
    }
    return;

## operations-and-config

# Cloud Functions Operations and Config Reference

Use this reference for logs, gateway exposure, environment-variable updates, triggers, and legacy tool-name translation.

## Logs

### Preferred path

- `queryFunctions(action="listFunctionLogs")` for the log list.
- `queryFunctions(action="getFunctionLogDetail")` for a specific request log.

### Plan B: `callCloudApi`

Only use raw cloud API calls after reading the official docs or knowledge-base entry for the action and parameter contract. Do not guess the action name or payload shape from memory.

#### Log list

```javascript
callCloudApi({
  service: "tcb",
  action: "GetFunctionLogs",
  params: {
    EnvId: "{envId}",
    FunctionName: "functionName",
    Offset: 0,
    Limit: 10,
    StartTime: "2024-01-01 00:00:00",
    EndTime: "2024-01-01 23:59:59"
  }
});
```

#### Log detail

```javascript
callCloudApi({
  service: "tcb",
  action: "GetFunctionLogDetail",
  params: {
    StartTime: "2024-01-01 00:00:00",
    EndTime: "2024-01-01 23:59:59",
    LogRequestId: "request-id-from-log-list"
  }
});
```

### Log query limits

- `Offset + Limit` cannot exceed `10000`.
- `StartTime` to `EndTime` cannot span more than one day.
- For large ranges, page through day-sized windows.

## Event Function HTTP access

### Preferred path

Use Domain/Route via `manageGateway(action="createRoute")`. Omit `domain` to attach the route on the HTTP gateway IsDefault domain (`DomainType=HTTPSERVICE`, typically `*.{region}.app.tcloudbase.com`).

```javascript
manageGateway({
  action: "createRoute",
  targetName: "functionName",
  upstreamResourceType: "SCF", // Event function -> SCF; HTTP function -> WEB_SCF
  path: "/api/users",
  auth: false
});
```

**IsDefault vs static hosting CDN:** many environments also list an IsDefault `STATIC_STORE` domain (`*.tcloudbaseapp.com`). Omitting `domain` does **not** attach to that static-hosting CDN hostname, and it is **not** a `STATIC_STORE` upstream binding. Confirm with `queryGateway(action="listRoutes")` — inspect `Domain`, `DomainType`, `Path`, and `UpstreamResourceType` on the created route.

**Disable / enable routes:** use `manageGateway(action="disableRoute"|"enableRoute")` with `path` (and prefer an explicit `domain`). This sets `Routes[].Enable` through `ModifyHTTPServiceRoute` (there is no `ModifyGatewayRoute` action). To close the static hosting default domain, list routes, take the `STATIC_STORE` IsDefault host, then:

```javascript
manageGateway({
  action: "disableRoute",
  domain: "<envId>-<appId>.tcloudbaseapp.com",
  path: "/"
});
```

Do not expect a `manageHosting` disable-default-domain action. `updateRoute` may also pass `enable=false` / `route.enable=false` when you already have the full route fields.

Upstream type:

- HTTP cloud function -> `upstreamResourceType="WEB_SCF"`
- Event cloud function -> `upstreamResourceType="SCF"`
- CloudRun -> `upstreamResourceType="CBR"`
- Static hosting -> `upstreamResourceType="STATIC_STORE"` (serviceName often `staticstore`)

Do **not** use deprecated GWAPI / `CreateCloudBaseGWAPI` via `callCloudApi` (blocked in evaluate mode and removed from MCP).
Do **not** pass `manageFunctions` `type="HTTP"|"Event"` into `manageGateway`; gateway uses `upstreamResourceType` only.
When a deploy/create tool returns `accessUrl` or `accessUrls`, prefer those values directly; they already rank gateway custom domains before default domains when routes exist.
## Environment variable updates

Do not overwrite function environment variables blindly.

### Safe pattern

1. Read current config with `queryFunctions(action="getFunctionDetail")`.
2. Merge existing variables with the new variables.
3. Update with `manageFunctions(action="updateFunctionConfig")`.

```javascript
const current = await queryFunctions({
  action: "getFunctionDetail",
  functionName: "functionName"
});

const mergedEnvVariables = {
  ...current.EnvVariables,
  ...newEnvVariables
};

await manageFunctions({
  action: "updateFunctionConfig",
  functionName: "functionName",
  envVariables: mergedEnvVariables
});
```


## vpc-and-tcp-database

# VPC and non-native TCP database access (cloud functions)

> **STOP — exception-only path.** Prefer CloudBase native SDK (`app.database()` / `app.rdb()`) or MCP SQL tools (`queryMysqlDatabase` / `manageMysqlDatabase` / `queryPgDatabase` / `managePgDatabase`) for business data. Do **not** read this file for new CRUD, notepads, CMS, or greenfield APIs. Continue only when migrating an **existing** app that already ships classic TCP clients (`DATABASE_URL`, Prisma, `mysql2`, `pg`, Redis). Credentials must come from the user or console env config — do **not** infer passwords from standard MCP instance-status queries (`getInstanceInfo`).

## When this applies

Use this only when the Event Function or HTTP Function uses a **classic TCP client** to reach MySQL / PostgreSQL / Redis / MongoDB (for example `DATABASE_URL`, `mysql2`, `pg`, Prisma, TypeORM, Sequelize).

**Does NOT apply** when the function uses CloudBase native SDK surfaces only:

- Document DB: `app.database()` / `db.collection(...)`
- CloudBase PG: `app.rdb()` / HTTP API gateway paths documented for CloudBase PG

Native SDK access is platform-managed and does **not** require function VPC binding for typical CloudBase DB usage.

## Required config for TCP / non-native SDK

| Field | Meaning |
| --- | --- |
| `envVariables.DATABASE_URL` (or `MYSQL_*` / `PG*` / `REDIS_*`) | Connection string / host for the **private** DB endpoint. Set from console or user-provided secrets — never invent credentials. |
| `vpc.vpcId` | Real VPC ID of that database (same region) |
| `vpc.subnetId` | Real subnet ID in that VPC with free IPs |

Event Functions and HTTP Functions share the same SCF networking model: both need `vpc` for private TCP access.

Official MySQL integration docs require enabling 私有网络 on the function and selecting the DB VPC: [Configure network connection](https://docs.cloudbase.net/cloud-function/resource-integration/mysql).

## Do not guess VPC IDs

Agents must **not**:

- Invent `vpc-xxxxx` / `subnet-xxxxx` placeholders
- Copy sample IDs from docs into a real deploy
- Assume “same environment” implies a default VPC without reading a real source

Resolve IDs from one of:

1. Database console / CloudBase MySQL settings (intranet VPC + subnet)
2. An existing resource that already works in that VPC (`queryFunctions getFunctionDetail`, CloudRun detail, CVM, etc.)
3. `callCloudApi` VPC/subnet describe APIs after confirming action names from docs
4. The user (ask and wait)

If IDs are still unknown after those steps: **stop**, report the gap, and do not deploy TCP DB env vars as if connectivity were solved.

## MCP usage

```javascript
await manageFunctions({
  action: "createFunction", // or updateFunctionConfig
  func: {
    name: "api",
    type: "HTTP", // or Event — same VPC rule
    envVariables: {
      // Replace with user/console-provided secret — do not paste passwords into chat logs
      DATABASE_URL: "<private-db-url-from-console-or-user>"
    },
    vpc: {
      vpcId: "<real-vpc-id>",
      subnetId: "<real-subnet-id>"
    }
  },
  functionRootPath: "/abs/path/to/cloudfunctions"
});
```

After create/update, call `queryFunctions(action="getFunctionDetail")` and verify `VpcConfig.VpcId` / `SubnetId`. Do not treat create/update success alone as proof that private TCP DB access works.

For TCP migration only, connection payloads may be fetched via `queryMysqlDatabase(action="getConnectionInfo")`. Standard `getInstanceInfo` does **not** return credentials.

## Side effects of enabling VPC

After VPC is bound, public internet egress may require NAT / public gateway in that VPC. Prefer fixing that network path over removing VPC just to “make outbound work” when the DB is private.

## rule

---
name: cloud-functions
description: CloudBase function runtime guide for building, deploying, and debugging your own Event Functions or HTTP Functions. This skill should be used when users need application runtime code on CloudBase, not when they are merely calling CloudBase official platform APIs.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

**Cross-cutting protocols** (required before code changes or deployments):
- Change Safety Protocol: `../cloudbase-platform/references/protocols/change-safety-protocol.md`
- Deployment Gate: `../cloudbase-platform/references/protocols/deployment-gate.md`
- Sensitive Runtime Data Protection: `../cloudbase-platform/references/protocols/sensitive-runtime-data-protection.md`

# Cloud Functions Development

## Activation Contract

### Use this first when

- The task is to create, update, deploy, inspect, or debug a CloudBase Event Function or HTTP Function that serves application runtime logic.
- The request mentions function runtime, function logs, `scf_bootstrap`, function triggers, or function gateway exposure.

### Read before writing code if

- You still need to decide between Event Function and HTTP Function.
- The task mentions `manageFunctions`, `queryFunctions`, `manageGateway`, or legacy function-tool names.
- The task might require `callCloudApi` as a fallback for logs or gateway setup.
- An HTTP Function will call CloudBase resources through `@cloudbase/node-sdk` or `@cloudbase/manager-node` -> read `./references/http-function-credentials.md`. HTTP Functions must use explicit credentials; do not rely on the Event Function passwordless runtime path.

### Exception only (do not read by default)

- Migrating an **existing** app that already uses classic TCP DB clients (`DATABASE_URL` / Prisma / `mysql2` / `pg` / Redis) → read `./references/vpc-and-tcp-database.md` via `./references.md`. New business CRUD must prefer CloudBase native SDK (`app.database()` / `app.rdb()`) or MCP SQL tools instead of TCP.

### Then also read

- Detailed reference routing -> `./references.md`
- Auth setup or provider-related backend work -> `../auth-tool-cloudbase/SKILL.md`
- CloudBase Integration Center generated WeChat Pay or Official Account functions -> `../cloudbase-wechat-integration/SKILL.md` (official docs: `https://docs.cloudbase.net/integration/introduce.md`)
- AI in functions -> `../ai-model-nodejs/SKILL.md`
- Long-lived container services or Agent runtimes -> `../cloudrun-development/SKILL.md`
- Calling CloudBase official platform APIs from a client or script -> `../http-api-cloudbase/SKILL.md`

### Do NOT use for

- CloudRun container services.
- Web authentication UI implementation.
- Database-schema design or general data-model work.
- CloudBase official platform API clients or raw HTTP integrations that only consume platform endpoints.
- Creating Integration Center instances through guessed APIs. For WeChat Pay or Official Account generated functions, use `cloudbase-wechat-integration` for the business contract and this skill only for function operations.
- **Tasks that the CloudBase JS SDK can handle directly** — simple data reads/writes, leaderboards, file uploads, real-time queries. Reach for the matching SDK surface before writing a function: `db.collection(...).get/add/update` only for confirmed NoSQL collections, and `app.rdb().from(...)` for CloudBase PG tables. Functions add deployment complexity, CORS configuration, and HTTP gateway binding that the SDK eliminates entirely.

### Common mistakes / gotchas

- Picking the wrong function type and trying to compensate later.
- Confusing official CloudBase API client work with building your own HTTP function.
- Mixing Event Function code shape (`exports.main(event, context)`) with HTTP Function code shape (`req` / `res` on port `9000`).
- Treating HTTP Access as the implementation model for HTTP Functions. HTTP Access is a gateway configuration for Event Functions, not the HTTP Function runtime model.
- Assuming `db.collection("name").add(...)` will create a missing document-database collection automatically. Collection creation is a separate management step.
- **Baking static content into the deployment package — media files, user uploads, or assets that change on their own cadence.** The package is uploaded on every deploy and a function package has a hard size ceiling, so large or independently-changing content makes every deploy slower and can push the package over the limit.
  - **Media files** (`*.mp4`, large images, fonts) — go to cloud storage, referenced by URL, not into the package.
  - **User uploads written to the function's local filesystem** — the function is ephemeral and `/tmp` is small and not shared. Uploads go to cloud storage.
  - **Frequently-updated static resources bundled in** — every change forces a full function redeploy. Serve them from cloud storage so the function only redeploys when the *code* changes.
- Forgetting that runtime cannot be changed after creation.
- Using cloud functions as the first answer for Web login.
- Forgetting that HTTP Functions must ship `scf_bootstrap`, listen on port `9000`, and include dependencies.
- Assuming an HTTP Function can use CloudBase SDKs without explicit credentials. The default temporary credential path is not reliable for HTTP Functions and credential rotation can break a running service. Use a CloudBase server API Key or Tencent Cloud key pair for `@cloudbase/node-sdk`; use a Tencent Cloud key pair for `@cloudbase/manager-node`. See `references/http-function-credentials.md`.
- Forgetting how an HTTP Function is meant to be reached. A call with no credential fails `401 MISSING_CREDENTIALS`; a call that carries one but is not allowed fails `403 EXCEED_AUTHORITY`. For browser, game or app clients, add a gateway route (`manageGateway(action="createRoute", auth: false)`) instead of widening the function security rule — in PostgreSQL environments that rule lives in an environment-wide `authz.user.rego` document, so editing it overwrites the policy for the whole environment. See `references/http-functions.md`.
- **Reading an `InsufficientBalance` invoke failure as an account problem.** A cloud function answers HTTP 410 with this code and the code reads as a short account balance, but what runs out is the environment's resource points — drawn down before any account balance and not restored by a top-up. The four causes (trial points exhausted / plan points exhausted / plan expired / account in arrears) need four different answers, only the last of which involves topping up, so diagnose with `manageEnv(action="usage")` plus the account balance before advising. See `../cloud-api-operations/references/recipes/credits-exhaustion.md`.
- Mismatching the `scf_bootstrap` Node.js binary path with the function runtime (e.g. using `/var/lang/node18/bin/node` but setting `runtime: "Nodejs16.13"`).
- For Custom Image HTTP Functions: forgetting that TCR, the CloudApp build, and SCF must be in the same region; using `:latest` instead of a unique tag; or confusing the request-driven port-`9000` image model with a long-lived CloudRun container that listens on the injected `PORT`.
- Assuming MCP covers the whole image pipeline. `manageFunctions` covers SCF image deploy (Stage B) via `runtime: "CustomImage"` + `imageConfig`, but the CloudApp custom build → TCR push (Stage A) is a raw Tencent Cloud API path — confirm action names and parameters from official docs before any `callCloudApi` fallback.
- Making code or configuration changes without first following the Change Safety Protocol (`cloudbase-platform/references/protocols/change-safety-protocol.md`).
- Exposing functions publicly or deploying without first completing the checks in `cloudbase-platform/references/protocols/deployment-gate.md`.
- **Returning `req.headers`, `process.env`, `event`, or `context` wholesale** — gateways may inject `x-cloudbase-context` (base64 temporary credentials). Never echo that header or dump credential env vars to clients. Follow `../cloudbase-platform/references/protocols/sensitive-runtime-data-protection.md`.
- **Using a bare layer name (e.g. `common`) across environments.** SCF LayerName is an account-scoped shared namespace: same name → shared version sequence. Create new layers with fixed format `{layerName}_{当前envId}` (e.g. `common_cloud1-d9ghadgak3edf6b36`). Pass the full name as `layerName` — do not invent automatic suffixes. Treat MCP layer `warnings` as soft advisories (operation still succeeds). Details: `./references/operations-and-config.md`.
- **Long-running MCP image deployments must complete the full workflow**: When using `manageFunctions` with `deployFunction` for a real `cloud` or `local` deployment, prefer `wait=false` to avoid blocking a single Tool Call for an extended period. If the tool returns a `taskId`, do not end the workflow, report success, or ask the user to wait while the status is `running`. Automatically call `queryFunctions(action="getFunctionDeployStatus", taskId="...")` and continue polling according to the reported progress until the status becomes `succeeded` or `failed`. Only after reaching a reasonable polling limit may you report that the deployment is still in progress; include the `taskId`, current stage, and latest progress. On success, report the image URI or build ID, function status, and Gateway URL. On failure, report the failed stage, error code, request ID, and diagnostic guidance. If the status is `expired`, explain that the local task record exceeded its retention window; the cloud deployment may still be running, so call `getFunctionDetail` to confirm the actual cloud-side status instead of treating it as a failure.

### Minimal checklist

- Read [Cloud Functions Execution Checklist](checklist.md) before deployment or runtime changes.
- Decide whether the task is Event Function, HTTP Function, or actually CloudRun.
- **Separate static from dynamic**: media, user uploads and frequently-updated assets live in cloud storage, not in the function package.
- Pick the detailed reference file in [references.md](references.md) before writing implementation code.

## MCP image deployment with polling

For real `cloud` or `local` custom-image deployments, prefer:

```json
{
  "action": "deployFunction",
  "dryRun": false,
  "confirm": true,
  "wait": false,
  "deployConfig": {}
}
```

The `wait` field controls whether the current MCP Tool call waits for the complete deployment:

- `wait=true`: wait for the manager deployment to reach a terminal result and return it.
- `wait=false`: return a `taskId` promptly while the deployment continues in the MCP background.

When `wait=false` returns a `taskId`, the deployment workflow is not complete. Automatically call `queryFunctions` with `action="getFunctionDeployStatus"` and that `taskId`; continue while the status is `running`, then stop only at `succeeded` or `failed`. Wait about 5 seconds before the first follow-up query and use the returned progress/`nextActions` to continue without aggressive polling. Do not tell the user to ask again or imply success before a terminal status is returned. An `expired` status means the task exceeded the maximum retention window and was force-terminated locally — the cloud deployment may still be in progress, so confirm the real state with `getFunctionDetail` instead of reporting failure.

If a reasonable polling limit is reached, report only that the task is still running, including the `taskId`, current status, current stage, and latest progress. For a terminal result, report the deployment strategy, action, image URI/digest, build ID, function status, Gateway URL, or the failed stage, error code, request ID, and diagnostic next step.

### Personal-tier TCR credentials — never put the password in tool arguments

Personal-tier image builds (`imageConfig.imageType="personal"` with `local` / `cloud`) need a TCR push credential. Read it from the MCP process environment, not from tool arguments:

- Leave `func.imageConfig.build.registryCredential` **out of the request** when `TCB_TCR_USERNAME` and `TCB_TCR_PASSWORD` are set in the MCP server `env` block — the MCP fills them in automatically, the same way `TENCENTCLOUD_SECRETID` works.
- **Never ask the user to paste the password into chat, and never write it into tool arguments.** Anything placed in arguments enters the model context and the tool-call history.
- If deployment fails with `CLOUD_REGISTRY_CREDENTIAL_MISSING` or `CLOUD_REGISTRY_CREDENTIAL_INVALID`, instruct the user to add these two variables to the `env` block of their MCP configuration and restart the MCP server. Do not work around it by passing the credential inline.

## rule

---
name: cloud-storage-web
description: Complete guide for CloudBase cloud storage using Web SDK (@cloudbase/js-sdk) - upload, download, temporary URLs, file management, and best practices.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

# Cloud Storage Web SDK

## Activation Contract

### Use this first when

- A browser or Web app must upload, download, or manage CloudBase storage objects through `@cloudbase/js-sdk`.
- The request mentions `uploadFile`, `getTempFileURL`, `deleteFile`, or `downloadFile` in frontend code.

### Read before writing code if

- The task is browser-side storage work but you still need to separate it from Mini Program storage, backend storage management, or static hosting deployment.
- The request may be blocked by security domains or frontend auth.

### Then also read

- Web login and identity -> `../auth-web-cloudbase/SKILL.md`
- General Web app setup -> `../web-development/SKILL.md`
- Direct storage management through MCP tools -> `../cloudbase-platform/SKILL.md`

### Do NOT use for

- Mini Program file APIs.
- Backend or agent-side direct storage management through MCP.
- Static website hosting deployment via `manageHosting(action="upload")`.
- Database operations.

### Common mistakes / gotchas

- Uploading from browser code without configuring security domains.
- Using this skill for static hosting instead of storage objects.
- Mixing browser SDK upload flows with server-side file-management tasks.
- Assuming temporary download URLs are permanent links.
- Ignoring `STORAGE_NOT_EXIST`; it means the target storage bucket/resource is not ready, not that the browser upload code should fabricate a URL.
- On local Vite or dev-server tasks, forgetting to whitelist the exact current browser `host:port` before testing `app.uploadFile()`.
- Treating CloudBase PG / `pgstore` like the legacy NoSQL CloudBase storage. PG environments use a separate `pgstore` backend whose buckets are NOT auto-created from your old NoSQL bucket. If `pgstore` has no bucket, every upload returns `STORAGE_BUCKET_NOT_FOUND` and the SDK then issues `PUT https://undefined/` (visible in DevTools as `net::ERR_NAME_NOT_RESOLVED`). Treat bucket existence as a hard prerequisite, just like Supabase: in Supabase Storage every upload must target an already-created bucket; CloudBase PG follows the same model.

### Minimal checklist

- Confirm the caller is a browser/Web app.
- Initialize the Web SDK once.
- Confirm CloudBase storage exists in the current environment before testing upload. Use available MCP management/query tools to inspect or create/select the storage bucket when the environment has no default bucket. **In a PG / pgstore environment, the legacy NoSQL bucket from `DescribeEnvs` does NOT count as a usable pgstore bucket; create one explicitly before any browser upload. The legacy NoSQL bucket itself is still fine for legacy `app.uploadFile()` flows that already target it — PG and NoSQL storage coexist; this skill applies to BOTH.**
- Check security-domain/CORS requirements.
- Pick the right storage method before coding.

### Local dev recipe

When the app runs on a local browser origin and must upload files from the frontend:

1. Use `queryEnv` with `action="domains"` to inspect the current security-domain whitelist.
2. Convert the browser origin into the CloudBase whitelist entry format:
   - Browser origin `http://127.0.0.1:4173` -> whitelist entry `127.0.0.1:4173`
   - Browser origin `http://localhost:5173` -> whitelist entry `localhost:5173`
3. If the exact current host entry is missing, call `envDomainManagement` with `action="create"` and add that host entry before relying on `app.uploadFile()`.
4. If the runtime port may change between runs, do not assume any fixed default port list is sufficient. Re-check the actual browser origin you are really using for testing or final validation, then add that exact `host:port`.
5. Tell the user that security-domain changes may take a few minutes to propagate; poll `queryEnv(action="domains")` rather than blind-sleeping for a fixed long interval.
6. Only after that should you implement and test browser-side `app.uploadFile()` flows.

If `app.uploadFile()` returns `STORAGE_NOT_EXIST`, stop editing frontend code and fix the environment-side storage resource first. Re-check the environment storage list, create or select an available bucket if the task allows it, then retry the same SDK upload flow.

If the task uses browser-side file upload, treat this as a prerequisite rather than an optional cleanup.

### Bucket existence prerequisite (mandatory before any upload code)

Just like Supabase Storage, CloudBase Storage requires the target bucket to exist before any client-side upload. This is true for both legacy CloudBase NoSQL storage (`STORAGE_NOT_EXIST`) and the newer PG / `pgstore` backend (`STORAGE_BUCKET_NOT_FOUND`).

Mental model parity with Supabase:

| Step | Supabase | CloudBase |
| ---- | -------- | --------- |
| Create bucket | `supabase.storage.createBucket('covers', { public: true })` (admin-side, with service role) | In PG mode, create a `storage.buckets` bucket through PG storage HTTP API / CLI / console / SQL on `storage.buckets` when appropriate. The browser SDK cannot create one. |
| Upload | `supabase.storage.from('covers').upload('a.png', file)` | **PG 模式**: `app.storage.from('covers').upload('a.png', file)` — `from(bucketName)` 指定 pgstore 存储桶。<br>**非 PG 模式**: `app.storage.from().upload('covers/a.png', file)` — bucket 名作为路径第一段。|
| Bucket missing error | `Bucket not found` | Browser sees `STORAGE_BUCKET_NOT_FOUND` (PG) or `STORAGE_NOT_EXIST` (NoSQL), then a follow-up `PUT https://undefined/` because the SDK still tries to PUT a missing `metadata.url`. |

Required pre-upload steps in any task that needs browser uploads:

1. List existing buckets first. For PG / pgstore, the legacy NoSQL bucket (the `6d63-…-1409864723` shape returned by `DescribeEnvs.Storages[]`) is NOT a valid pgstore bucket — do not assume it works.
2. If no usable bucket exists for the upload target (e.g. `covers`), create one through the PG storage management surface BEFORE editing frontend upload code. Adding `covers` as a path prefix in code does not auto-create a bucket.
3. After creating the bucket, the upload pattern depends on environment:
   - **PG / pgstore**: `app.storage.from('covers').upload('<file>', file)` — bucket 名传入 `from()`
   - **Non-PG (NoSQL)**: `app.storage.from().upload('covers/<file>', file)` — bucket 名作为路径第一段
4. If you see `net::ERR_NAME_NOT_RESOLVED` going to `https://undefined/` in DevTools, that is the SDK reacting to a missing `metadata.url` field — almost always because the bucket does not exist or the SDK request was rejected upstream. Inspect the failed `POST .../v1/storages/get-objects-upload-info` response in DevTools first; the `code` field (e.g. `STORAGE_BUCKET_NOT_FOUND`, `STORAGE_CONTENT_LENGTH_REQUIRED`, `INVALID_PARAM`) tells you exactly what to fix.

Do not silently swallow upload failures. If `uploadCoverImage()` rejects, the parent `createArticle()` MUST also reject — never proceed to `db.from(...).insert(...)` with a fabricated URL or a placeholder, and never let the UI show a success toast.

### ⚠️ PG mode upload: use `app.storage.from('bucket')`, NOT `app.uploadFile()`

In PG / pgstore environments, use `app.storage.from('covers').upload(key, file)` for uploads and `app.storage.from('covers').createSignedUrl(path, expiresIn)` for getting access URLs.

Do NOT use the legacy NoSQL APIs in PG mode:
- ❌ `app.uploadFile()` — 这是旧 NoSQL 的上传 API
- ❌ `app.getTempFileURL()` — 这是旧 NoSQL 的获取 URL 方式
- ❌ `app.storage.from().upload('covers/file', file)` — 没有传 bucket 名

Use instead:
- ✅ `app.storage.from('covers').upload('file', file)` — PG 模式上传
- ✅ `app.storage.from('covers').createSignedUrl('file', 3600)` — 获取签名 URL（返回 `fullSignedURL` 字段）

**Return shapes differ between modes (v3 SDK) — copy the right column:**

| call | 传统模式 (`from()` 无参, `cloud://` fileID) | PG 模式 (`from('bucket')`, bucket 内对象名) |
|---|---|---|
| `upload(path, file)` | `{ data: { id, path, fullPath } }`；`upsert` 默认 **true** | `{ data: { id, ... } }`；`upsert` 默认 **false** |
| `createSignedUrl(path, expiresIn)` | `await` → `{ data: { signedUrl } }` | `await` → `{ data: { fullSignedURL } }` |
| `getPublicUrl(path)` | `await` → `{ data: { publicUrl } }` | **同步调用（不 await）** → `{ data: { publicUrl } }` |


## adapter-development

# Building Custom Adapters

An adapter bridges your AI framework to the AG-UI protocol. It converts AG-UI input (messages, tools, state) into your framework's format, and converts your framework's streaming output into AG-UI events.

**Prerequisites:** Deep understanding of both your AI framework's API and the AG-UI protocol events.

**When to build your own:** No existing adapter for your framework (check AG-UI ecosystem first).

Extend `AbstractAgent` and implement `run()` that returns `Observable<BaseEvent>`.

## Structure

```typescript
import { AbstractAgent, RunAgentInput, BaseEvent, EventType } from "@ag-ui/client";
import { Observable, Subscriber } from "rxjs";

export class MyAdapter extends AbstractAgent {
  run(input: RunAgentInput): Observable<BaseEvent> {
    return new Observable((subscriber) => this._run(subscriber, input));
  }

  private async _run(subscriber: Subscriber<BaseEvent>, input: RunAgentInput) {
    const { messages, runId, threadId, tools } = input;

    subscriber.next({ type: EventType.RUN_STARTED, threadId, runId });

    try {
      // 1. Convert AG-UI input to your framework's format
      // 2. Call your framework
      // 3. Convert your framework's output to AG-UI events (see Event Sequence below)

      subscriber.next({ type: EventType.RUN_FINISHED, threadId, runId });
    } catch (error) {
      subscriber.next({ type: EventType.RUN_ERROR, message: error.message });
    }
    subscriber.complete();
  }
}
```

## Event Sequence (Brief)

**Text:** `TEXT_MESSAGE_START` → `TEXT_MESSAGE_CONTENT` (repeat) → `TEXT_MESSAGE_END`

**Tool call:** `TOOL_CALL_START` → `TOOL_CALL_ARGS` → `TOOL_CALL_END`

**Tool result (server-executed tools only):** `TOOL_CALL_RESULT`

Always emit full lifecycle. `parentMessageId` links tool calls to their parent message.

For complete event reference, see [AG-UI Protocol](https://docs.ag-ui.com/concepts/events).

## adapter-langchain

# @cloudbase/agent-adapter-langchain

Adapter that wraps LangChain's `createAgent()` as an AG-UI compatible agent. Provides `LangchainAgent` wrapper class and `clientTools()` middleware for client tools support.

## Basic Usage

```typescript
import { createAgent as createLangchainAgent } from "langchain";
import { MemorySaver } from "@langchain/langgraph";
import { ChatOpenAI } from "@langchain/openai";
import { LangchainAgent, clientTools } from "@cloudbase/agent-adapter-langchain";

const model = new ChatOpenAI({ model: "gpt-4o" });
const checkpointer = new MemorySaver();

const lcAgent = createLangchainAgent({
  model,
  checkpointer,
  middleware: [clientTools()],
});

const agent = new LangchainAgent({ agent: lcAgent });
```

## Checkpointer (Required)

`LangchainAgent` requires the agent to be created with a checkpointer.

### MemorySaver (Development)

```typescript
import { MemorySaver } from "@langchain/langgraph";

const lcAgent = createLangchainAgent({
  model,
  checkpointer: new MemorySaver(),
  middleware: [clientTools()],
});
```

### CloudBaseSaver (Production)

Persistent storage using Tencent CloudBase document database. On CloudBase cloud function/cloudrun, requests are authenticated - extract user ID from the JWT in Authorization header.

```typescript
import { run } from "@cloudbase/agent-server";
import { LangchainAgent, clientTools } from "@cloudbase/agent-adapter-langchain";
import { CloudBaseSaver } from "@cloudbase/agent-adapter-langgraph";
import { createAgent as createLangchainAgent } from "langchain";
import tcb from "@cloudbase/node-sdk";

const app = tcb.init({ env: process.env.CLOUDBASE_ENV_ID });

run({
  createAgent: ({ request }) => {
    // Extract user ID from JWT (sub field)
    const token = request.headers.get("Authorization")?.slice(7);
    const payload = JSON.parse(atob(token.split(".")[1]));
    const userId = payload.sub;

    const checkpointer = new CloudBaseSaver({
      db: app.database(),
      userId,  // Multi-tenant isolation
    });

    const lcAgent = createLangchainAgent({
      model,
      checkpointer,
      middleware: [clientTools()],
    });

    return { agent: new LangchainAgent({ agent: lcAgent }) };
  },
  port: 9000,
});
```

## With @cloudbase/agent-server

```typescript
import { run } from "@cloudbase/agent-server";

run({
  createAgent: () => ({ agent }),
  port: 9000,
});
```

## clientTools() Middleware

Enables client-defined tools in your LangChain agent:

- **Injects client tools** - Adds client tools to the LLM's available tool list
- **Routes to END** - When a client tool is called, skips ToolNode and routes to END so client can execute

## adapter-langgraph

# @cloudbase/agent-adapter-langgraph

Adapter that wraps a compiled LangGraph `StateGraph` workflow as an AG-UI compatible agent. Provides `ClientStateAnnotation` with pre-wired `messages` and `client.tools` fields for seamless AG-UI protocol integration.

## Installation

```bash
npm install @cloudbase/agent-adapter-langgraph @langchain/langgraph @langchain/openai
```

## Exports

```typescript
import {
  LanggraphAgent,
  ClientStateAnnotation,
  ClientState,
  CloudBaseSaver  // Tencent CloudBase checkpointer
} from "@cloudbase/agent-adapter-langgraph";
```

## Basic Usage

```typescript
import { LanggraphAgent } from "@cloudbase/agent-adapter-langgraph";

const agent = new LanggraphAgent({
  compiledWorkflow: graph,  // compiled StateGraph (required)
  logger: myLogger,         // optional
});
```

## Checkpointer (Required)

`LanggraphAgent` requires the workflow to be compiled with a checkpointer.

### MemorySaver (Development)

```typescript
import { MemorySaver } from "@langchain/langgraph";

const graph = workflow.compile({ checkpointer: new MemorySaver() });
```

### CloudBaseSaver (Production)

Persistent storage using Tencent CloudBase document database. On CloudBase cloud function/cloudrun, requests are authenticated - extract user ID from the JWT in Authorization header.

```typescript
import { run } from "@cloudbase/agent-server";
import { CloudBaseSaver, LanggraphAgent } from "@cloudbase/agent-adapter-langgraph";
import tcb from "@cloudbase/node-sdk";

const app = tcb.init({ env: process.env.CLOUDBASE_ENV_ID });

run({
  createAgent: ({ request }) => {
    // Extract user ID from JWT (sub field)
    const token = request.headers.get("Authorization")?.slice(7);
    const payload = JSON.parse(atob(token.split(".")[1]));
    const userId = payload.sub;

    const checkpointer = new CloudBaseSaver({
      db: app.database(),
      userId,  // Multi-tenant isolation
    });

    const graph = workflow.compile({ checkpointer });
    return { agent: new LanggraphAgent({ compiledWorkflow: graph }) };
  },
  port: 9000,
});
```

## Client Tools

Client tools are tools defined by the client, not the server. They let the agent request actions only the client can perform (e.g., show modal, navigate, access local storage). The flow:

1. **Client** defines tools with handlers and sends them in request
2. **Server** binds client tools alongside server tools, LLM can call any
3. **Server** detects client tool call → routes to END (doesn't execute)
4. **Client** receives `TOOL_CALL_*` events, executes handler locally
5. **Client** sends tool result back, agent resumes

### Server Side: Bind and Route

```typescript
import { ClientState } from "@cloudbase/agent-adapter-langgraph";

// 1. Bind client tools to model (alongside server tools)
async function chatNode(state: ClientState) {
  const clientTools = state.client?.tools || [];
  const modelWithTools = model.bindTools([...clientTools, ...serverTools]);
  // ...
}

// 2. Route client tool calls to END (let client handle)
function shouldContinue(state: ClientState): "tools" | "end" {
  const lastMessage = state.messages[state.messages.length - 1];
  if (lastMessage.tool_calls?.length > 0) {
    const hasServerToolCall = lastMessage.tool_calls.some(tc => serverToolNames.has(tc.name));
    if (hasServerToolCall) return "tools";  // Server executes
  }
  return "end";  // Client tool or no tool → end, client handles
}
```

## Complete Workflow Pattern

```typescript
import { StateGraph, START, END, Command } from "@langchain/langgraph";
import { ClientStateAnnotation, ClientState } from "@cloudbase/agent-adapter-langgraph";
import { MemorySaver } from "@langchain/langgraph";
import { ChatOpenAI } from "@langchain/openai";
import { SystemMessage } from "@langchain/core/messages";
import { RunnableConfig } from "@langchain/core/runnables";

async function chatNode(state: ClientState, config?: RunnableConfig) {
  const model = new ChatOpenAI({ model: "gpt-4o" });
  const modelWithTools = model.bindTools([...(state.client?.tools || [])], {

## agui-protocol

# AG-UI Protocol

Open, event-based protocol for agent-UI communication. Server streams events to client via SSE.

## Event Patterns

**Start-Content-End**: For streaming content
```
TEXT_MESSAGE_START → TEXT_MESSAGE_CONTENT (repeat) → TEXT_MESSAGE_END
TOOL_CALL_START → TOOL_CALL_ARGS (repeat) → TOOL_CALL_END
```

**Lifecycle**: Wraps every agent run
```
RUN_STARTED → [events] → RUN_FINISHED | RUN_ERROR
```

**Snapshot-Delta**: For state sync
```
STATE_SNAPSHOT (full state) → STATE_DELTA (JSON Patch updates)
```

## Core Events

| Event | Key Fields |
|-------|------------|
| `RUN_STARTED` | threadId, runId |
| `RUN_FINISHED` | threadId, runId |
| `RUN_ERROR` | message, code? |
| `TEXT_MESSAGE_START` | messageId, role |
| `TEXT_MESSAGE_CONTENT` | messageId, delta |
| `TEXT_MESSAGE_END` | messageId |
| `TOOL_CALL_START` | toolCallId, toolCallName, parentMessageId? |
| `TOOL_CALL_ARGS` | toolCallId, delta |
| `TOOL_CALL_END` | toolCallId |
| `TOOL_CALL_RESULT` | toolCallId, messageId, content |
| `STATE_SNAPSHOT` | snapshot |
| `STATE_DELTA` | delta (RFC 6902 JSON Patch) |
| `MESSAGES_SNAPSHOT` | messages[] |

## Input Types

```typescript
interface RunAgentInput {
  threadId: string;
  runId: string;
  messages: Message[];
  tools: Tool[];
  state?: unknown;
  context?: Context[];
  forwardedProps?: Record<string, unknown>;
}

interface Message {
  id: string;
  role: "user" | "assistant" | "system" | "tool";
  content: string;
  name?: string;                    // for tool messages
  toolCalls?: ToolCall[];           // for assistant messages
  toolCallId?: string;              // for tool messages
}

interface ToolCall {
  id: string;
  type: "function";
  function: { name: string; arguments: string };
}

interface Tool {
  name: string;
  description: string;
  parameters?: JSONSchema;
}
```

## Tool Execution Flow

**Server-executed tools:**
1. Agent emits `TOOL_CALL_START/ARGS/END`
2. Server executes tool
3. Server emits `TOOL_CALL_RESULT`
4. Agent continues with result

**Client tools:**
1. Agent emits `TOOL_CALL_START/ARGS/END`
2. Server emits `RUN_FINISHED` (run pauses)
3. Client executes tool locally
4. Client sends new request with tool result in messages
5. Agent continues

## Full Reference

For complete protocol specification: https://docs.ag-ui.com/concepts/events

## rule

---
name: cloudbase-agent-ts
description: "Build and deploy AI agents with Cloudbase Agent (TypeScript), a TypeScript SDK implementing the AG-UI protocol. Use when: (1) deploying agent servers with @cloudbase/agent-server, (2) using LangGraph adapter with ClientStateAnnotation, (3) using LangChain adapter with clientTools(), (4) building custom adapters that implement AbstractAgent, (5) understanding AG-UI protocol events, (6) building web UI clients with @ag-ui/client, (7) building WeChat Mini Program UIs with @cloudbase/agent-ui-miniprogram."
alwaysApply: false
---

# Cloudbase Agent (TypeScript)

TypeScript SDK for deploying AI agents as HTTP services using the AG-UI protocol.

> **Note:** This skill is for **TypeScript/JavaScript** projects only.

## When to use this skill

Use this skill for **AI agent development** when you need to:

- Deploy AI agents as HTTP services with AG-UI protocol support
- Build agent backends using LangGraph or LangChain frameworks
- Create custom agent adapters implementing the AbstractAgent interface
- Understand AG-UI protocol events and message streaming
- Build web UI clients that connect to AG-UI compatible agents
- Build WeChat Mini Program UIs for AI agent interactions

**Do NOT use for:**
- Simple AI model calling without agent capabilities (use `ai-model-*` skills)
- CloudBase cloud functions (use `cloud-functions` skill)
- CloudRun backend services without agent features (use `cloudrun-development` skill)

## How to use this skill (for a coding agent)

### MUST READ: Read ALL docs that match your task

**Before writing any code**, identify which docs you need and read ALL of them. Reading only a subset leads to incomplete implementations (missing CORS, wrong adapter patterns, no UI client code).

#### Scenario-based reading lists

| If the task asks you to... | You MUST read these docs |
|---|---|
| **Build a full-stack agent** (backend + frontend) | `server-quickstart.md` + adapter doc + `ui-clients.md` |
| **Deploy an agent server only** | `server-quickstart.md` |
| **Use LangGraph for agent logic** | `adapter-langgraph.md` + `server-quickstart.md` |
| **Use LangChain for agent logic** | `adapter-langchain.md` + `server-quickstart.md` |
| **Build a custom adapter** (no LangGraph/LangChain) | `adapter-development.md` + `agui-protocol.md` + `server-quickstart.md` |
| **Build a web/mini-program UI client** | `ui-clients.md` + `agui-protocol.md` |

### Step-by-step workflow

1. **Identify the adapter type** from the task description (LangGraph / LangChain / custom)
2. **Read the matching docs** from the table above — read ALL listed docs, not just one
3. **Set up the agent server** using `@cloudbase/agent-server` — always include `cors: true`
4. **Implement the agent logic** using the chosen adapter
5. **If building UI**, read `ui-clients.md` and create the client code

## Reference doc index

| Doc | When to read |
|------|------|
| [server-quickstart](server-quickstart.md) | Always — deployment, CORS, logging, endpoints |
| [adapter-langgraph](adapter-langgraph.md) | Task mentions LangGraph, StateGraph, or graph-based workflows |
| [adapter-langchain](adapter-langchain.md) | Task mentions LangChain, chains, or chain-based patterns |
| [adapter-development](adapter-development.md) | Task requires custom adapter (no existing framework adapter) |
| [agui-protocol](agui-protocol.md) | Task requires custom adapter or deep protocol understanding |
| [ui-clients](ui-clients.md) | Task mentions web UI, frontend, client, or SSE streaming |
| [ui-miniprogram](ui-miniprogram.md) | Task mentions WeChat Mini Program or miniprogram UI |

## Quick Start

```typescript
import { run } from "@cloudbase/agent-server";
import { LanggraphAgent } from "@cloudbase/agent-adapter-langgraph";

run({
  createAgent: () => ({ agent: new LanggraphAgent({ workflow }) }),
  port: 9000,
});
```

## server-quickstart

# @cloudbase/agent-server

Deploy AG-UI compatible agents as HTTP servers.

## Deployment Methods

### run() - Standalone

```typescript
import { run } from "@cloudbase/agent-server";
run({ createAgent: () => ({ agent }), port: 9000 });
```

### createExpressServer() - Get App

```typescript
import { createExpressServer } from "@cloudbase/agent-server";
const app = createExpressServer({ createAgent: () => ({ agent }) });
app.listen(9000);
```

### createExpressRoutes() - Add to Existing

```typescript
import { createExpressRoutes } from "@cloudbase/agent-server";
createExpressRoutes({ createAgent: () => ({ agent }), express: app, basePath: "/api/" });
```

## Endpoints Created

| Endpoint | Purpose |
|----------|---------|
| `/agui` | CopilotKit RPC endpoint |
| `/send-message` | AG-UI endpoint (SSE) |
| `/healthz` | Health check |
| `/chat/completions` | OpenAI-compatible endpoint |
| `/v1/aibot/bots/:agentId/...` | Same endpoints with bot ID (when no basePath) |

## AgentCreatorContext

```typescript
interface AgentCreatorContext {
  request: Request;      // Web Standard Request
  logger?: Logger;       // Pino-style logger (AGUI routes only)
  requestId?: string;    // Unique request ID (AGUI routes only)
}

createAgent: (ctx: AgentCreatorContext) => ({
  agent,                 // Your adapter instance
  cleanup?: () => void   // Called when request ends
})
```

## Cleanup Pattern

```typescript
createAgent: (ctx) => {
  const db = connectToDatabase();
  ctx.logger?.info("Connected to database");
  return {
    agent: new LanggraphAgent({ workflow }),
    cleanup: () => db.close()
  };
}
```

## All Options

```typescript
run({
  createAgent,
  port: 9000,
  basePath: "/api/",           // Custom base path (default: dual endpoints)
  cors: true,                  // or { origin: "https://..." }
  useAGUI: true,               // Enable /agui endpoint (default: true)
  aguiOptions: {
    runtimeOptions: {},        // CopilotRuntimeOptions
    endpointOptions: {}        // CreateCopilotRuntimeServerOptions
  },
  logger: createConsoleLogger("debug"),
  observability: { type: "otlp", url: "...", headers: {...} }
});
```

## Logger Exports

```typescript
import {
  noopLogger,           // Silent logger (default)
  createConsoleLogger,  // Console logger
  generateRequestId,
  extractRequestId,
  getOrGenerateRequestId
} from "@cloudbase/agent-server";

// Custom logger (Pino-style interface)
const logger = {
  info: (obj, msg) => console.log(msg, obj),
  error: (obj, msg) => console.error(msg, obj),
  debug: (obj, msg) => console.debug(msg, obj),
  child: (bindings) => ({ ...logger })
};
```

## Observability

Requires `@cloudbase/agent-observability` package:

```typescript
run({
  createAgent,
  observability: { type: "console" }  // Logs traces to stdout
});

// OTLP exporter (Langfuse, Jaeger, etc.)
run({
  createAgent,
  observability: {
    type: "otlp",
    url: "https://cloud.langfuse.com/api/public/otlp/v1/traces",

## ui-clients

# Building UI Clients

Connect your UI to AG-UI endpoints served by @cloudbase/agent-server.

## Web Applications

Use `@ag-ui/client` (official AG-UI SDK):

```bash
npm install @ag-ui/client
```

```typescript
import { HttpAgent } from "@ag-ui/client";

const agent = new HttpAgent({ url: "http://localhost:9000/send-message" });

for await (const event of agent.run({
  threadId: "thread-1",
  runId: "run-1",
  messages: [{ id: "m1", role: "user", content: "Hello" }]
})) {
  console.log(event.type, event);
}
```

See AG-UI documentation for full API: https://docs.ag-ui.com

## WeChat Mini Program

Use `@cloudbase/agent-ui-miniprogram` (headless behavior mixin):

```bash
npm install @cloudbase/agent-ui-miniprogram
```

```typescript
import { createAGUIBehavior, CloudbaseTransport } from "@cloudbase/agent-ui-miniprogram";

Component({
  behaviors: [createAGUIBehavior({
    transport: new CloudbaseTransport({ botId: "your-bot-id" })
  })],
  methods: {
    onSend() {
      this.agui.sendMessage(this.data.inputText);
    }
  }
});
// State: this.data.agui.uiMessages, this.data.agui.isRunning
```

Beyond basic usage, the package offers more `createAGUIBehavior` options, `this.agui.*` namespace methods, state getters, and UIMessage format for rendering.

## ui-miniprogram

# @cloudbase/agent-ui-miniprogram

WeChat Mini Program SDK for AG-UI protocol. Headless behavior mixin pattern.

## Installation

```bash
npm install @cloudbase/agent-ui-miniprogram
```

## Basic Usage

```typescript
import { createAGUIBehavior, CloudbaseTransport } from "@cloudbase/agent-ui-miniprogram";

const transport = new CloudbaseTransport({ botId: "your-bot-id" });

Component({
  behaviors: [createAGUIBehavior({ transport })],
  methods: {
    onSend() {
      this.agui.sendMessage(this.data.inputText);
    }
  }
});
```

## createAGUIBehavior Options

```typescript
createAGUIBehavior({
  transport,              // Transport instance (CloudbaseTransport)
  messages: [],           // Initial message history
  tools: [{               // Client tools the agent can invoke
    name: "get_weather",
    description: "Get weather",
    parameters: { type: "object", properties: { city: { type: "string" } } },
    handler: async ({ args }) => ({ temp: 72 })
  }],
  threadId: "custom-id",  // Custom thread ID (auto-generated if omitted)
  contexts: [],           // Additional context objects
  onRawEvent: (event) => {} // Callback for each raw AG-UI event
})
```

## Namespace Methods (this.agui.*)

| Method | Description |
|--------|-------------|
| `init({ transport, threadId? })` | Initialize transport at runtime |
| `sendMessage(text \| Message[])` | Send message and run agent |
| `appendMessage(message)` | Add message without running agent |
| `setMessages(messages)` | Replace entire message history |
| `reset()` | Reset to initial state |
| `setThreadId(id)` | Change thread ID |
| `addTool(tool)` | Register a client tool |
| `removeTool(name)` | Remove tool by name |
| `updateTool(name, updates)` | Update tool properties |
| `clearTools()` | Remove all tools |

## State Getters (this.agui.* or this.data.agui.*)

| Property | Type | Description |
|----------|------|-------------|
| `messages` | `Message[]` | Raw message history |
| `uiMessages` | `UIMessage[]` | Messages formatted for UI rendering |
| `isRunning` | `boolean` | Agent is processing |
| `runId` | `string \| null` | Current run ID |
| `activeToolCalls` | `ToolCallState[]` | Tool calls in progress |
| `error` | `AGUIClientError \| null` | Last error |
| `threadId` | `string` | Current thread ID |
| `tools` | `Tool[]` | Registered tools (definitions only) |
| `contexts` | `Context[]` | Context objects |
| `config` | `CreateAGUIBehaviorOptions` | Current configuration |

## CloudbaseTransport

Production transport for WeChat Cloud Development:

```typescript
import { CloudbaseTransport } from "@cloudbase/agent-ui-miniprogram";

const transport = new CloudbaseTransport({
  botId: "bot-xxxxxx"  // From Cloud Development console
});
```

Requires `wx.cloud.extend.AI.bot.sendMessage` API.

## Imperative Pattern

Use `aguiBehavior` (no static config) for runtime-only initialization:

```typescript
import { aguiBehavior, CloudbaseTransport } from "@cloudbase/agent-ui-miniprogram";

Component({
  behaviors: [aguiBehavior],
  lifetimes: {
    attached() {
      this.agui.init({
        transport: new CloudbaseTransport({ botId: "my-bot" })
      });
    }
  }
});
```

## Client Tool Example

```typescript
Component({
  behaviors: [createAGUIBehavior({ transport })],
  lifetimes: {
    attached() {
      this.agui.addTool({
        name: "show_toast",
        description: "Show a toast message",
        parameters: {
          type: "object",

## adapter-coze

# Coze Adapter

This guide covers using the Coze platform integration with CloudBase Agent Python SDK.

## Overview

The Coze adapter allows you to use Coze's hosted AI bots as your backend, while still exposing them through the AG-UI protocol. This is useful when:

- You want to leverage Coze's bot building capabilities
- You need to integrate Coze bots into AG-UI-compatible frontends
- You want unified authentication and middleware with other adapters

## Installation

Coze adapter is included in the `cloudbase-agent-coze` package:

```bash
pip install cloudbase-agent-coze
```

## Basic Usage

```python
from cloudbase_agent.coze import CozeAgentAdapter
from cloudbase_agent.server import AgentServiceApp

def create_agent():
    return CozeAgentAdapter(
        bot_id="your-bot-id",
        api_key="your-api-key"
    )

AgentServiceApp().run(create_agent, port=9000)
```

## Configuration

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `bot_id` | `str` | Coze bot identifier |
| `api_key` | `str` | Coze API key |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `base_url` | `str` | `https://api.coze.com` | Coze API endpoint |
| `debug_mode` | `bool` | `False` | Enable debug logging |

### Example with All Options

```python
adapter = CozeAgentAdapter(
    bot_id="bot_1234567890",
    api_key="sk-1234567890",
    base_url="https://api.coze.com",
    debug_mode=True
)
```

## Authentication Integration

The Coze adapter automatically extracts user ID from the request context set by authentication middleware.

### Server Setup with Auth

```python
from cloudbase_agent.server import AgentServiceApp
from cloudbase_agent.coze import CozeAgentAdapter
import jwt

def auth_middleware(input_data, request):
    """Extract user from JWT and inject into state."""
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    
    if token:
        jwt_payload = jwt.decode(token, "your-secret", algorithms=["HS256"])
        
        if input_data.state is None:
            input_data.state = {}
        
        # Inject user ID (Coze adapter reads from here)
        input_data.state["__request_context__"] = {
            "user": {
                "id": jwt_payload["sub"],
                "jwt": jwt_payload
            }
        }
    
    yield

def create_agent():
    return CozeAgentAdapter(
        bot_id="your-bot-id",
        api_key="your-api-key"
    )

app = AgentServiceApp()
app.use(auth_middleware)
app.run(create_agent, port=9000)
```

### User ID Extraction

The Coze adapter reads user ID from:
```python
state["__request_context__"]["user"]["id"]
```

This is used as the `user_id` parameter when calling Coze API, enabling:
- User-specific conversation history
- Multi-tenant isolation
- Personalized responses

## Environment Variables

For production, use environment variables:


## adapter-development

# Custom Adapter Development

This guide explains how to build custom AG-UI protocol adapters in Python.

## Overview

An adapter bridges an Agent framework (LangGraph, LangChain, custom logic) to the AG-UI protocol. It translates framework events into standardized AG-UI events that clients can consume.

## AbstractAgent Interface

All adapters must implement the `AbstractAgent` interface:

```python
from typing import Any, AsyncGenerator
from cloudbase_agent.core import RunAgentInput, Event

class AbstractAgent:
    """Abstract base class for all AG-UI protocol adapters."""
    
    async def run(self, run_input: RunAgentInput) -> AsyncGenerator[Event, None]:
        """
        Execute the agent and yield AG-UI protocol events.
        
        :param run_input: Input data containing messages, state, tools, etc.
        :yields: AG-UI protocol events
        """
        raise NotImplementedError
```

## Event Types

AG-UI protocol defines these event types:

```python
from cloudbase_agent.core import EventType

class EventType:
    RUN_STARTED = "RUN_STARTED"
    RUN_FINISHED = "RUN_FINISHED"
    TEXT_MESSAGE_START = "TEXT_MESSAGE_START"
    TEXT_MESSAGE_CONTENT = "TEXT_MESSAGE_CONTENT"
    TEXT_MESSAGE_END = "TEXT_MESSAGE_END"
    TOOL_CALL_START = "TOOL_CALL_START"
    TOOL_CALL_ARGS_CHUNK = "TOOL_CALL_ARGS_CHUNK"
    TOOL_CALL_END = "TOOL_CALL_END"
    TOOL_RESULT = "TOOL_RESULT"
    STATE_SNAPSHOT = "STATE_SNAPSHOT"
    ERROR = "ERROR"
```

## Minimal Adapter Example

```python
from typing import Any, AsyncGenerator
from cloudbase_agent.core import RunAgentInput, Event, EventType
from uuid import uuid4

class SimpleEchoAgent:
    """Simplest possible adapter - echoes user messages."""
    
    async def run(self, run_input: RunAgentInput) -> AsyncGenerator[Event, None]:
        """Echo back the user's message."""
        # 1. Yield RUN_STARTED
        yield Event(type=EventType.RUN_STARTED, runId=run_input.runId)
        
        # 2. Get last user message
        last_message = run_input.messages[-1] if run_input.messages else None
        user_content = last_message.get("content", "") if last_message else ""
        
        # 3. Generate response
        message_id = str(uuid4())
        response_text = f"Echo: {user_content}"
        
        # 4. Yield TEXT_MESSAGE events
        yield Event(
            type=EventType.TEXT_MESSAGE_START,
            runId=run_input.runId,
            messageId=message_id,
            role="assistant"
        )
        
        yield Event(
            type=EventType.TEXT_MESSAGE_CONTENT,
            runId=run_input.runId,
            messageId=message_id,
            content=response_text
        )
        
        yield Event(
            type=EventType.TEXT_MESSAGE_END,
            runId=run_input.runId,
            messageId=message_id
        )
        
        # 5. Yield RUN_FINISHED
        yield Event(type=EventType.RUN_FINISHED, runId=run_input.runId)
```

Deploy it:

```python
from cloudbase_agent.server import AgentServiceApp

AgentServiceApp().run(lambda: SimpleEchoAgent(), port=9000)
```

## Streaming Response Pattern

For LLM streaming responses:

```python
from openai import AsyncOpenAI

class StreamingLLMAgent:
    """Agent with streaming LLM responses."""
    
    def __init__(self, api_key: str):
        self.client = AsyncOpenAI(api_key=api_key)
    
    async def run(self, run_input: RunAgentInput) -> AsyncGenerator[Event, None]:

## adapter-langgraph

# LangGraph Adapter Guide

Complete guide for integrating LangGraph agents with CloudBase Agent Python SDK.

---

## Overview

The CloudBase Agent LangGraph adapter (`cloudbase_agent.langgraph`) provides seamless integration with LangGraph workflows, offering:

- **Native LangGraph Support**: Wrap any `CompiledStateGraph` as an CloudBase Agent agent
- **AG-UI Compatibility**: Automatic stability patches for frontend integration
- **Streaming Support**: Real-time message streaming to clients
- **Memory Persistence**: LangGraph checkpoint support for conversation history
- **Callback System**: Monitor agent events in real-time
- **Resource Cleanup**: Automatic cleanup after request completion

---

## Quick Start

### 1. Install Dependencies

```bash
pip install cloudbase-agent-langgraph cloudbase-agent-server langgraph langchain-openai
```

This installs:
- `cloudbase-agent-langgraph` - LangGraph adapter
- `langgraph` - LangGraph framework
- `langchain` - LangChain core
- `langchain-openai` - OpenAI integration

### 2. Create Your First Agent

```python
# agent.py
from langgraph.graph import StateGraph, MessagesState, END, START
from langgraph.checkpoint.memory import MemorySaver
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage
from cloudbase_agent.langgraph import LangGraphAgent

# Define state
class State(MessagesState):
    pass

# Define chat node
def chat_node(state: State, config, writer):
    """Generate AI response."""
    chat_model = ChatOpenAI(model="gpt-4o-mini")
    system = SystemMessage(content="You are a helpful assistant.")
    messages = [system, *state["messages"]]
    
    chunks = []
    for chunk in chat_model.stream(messages, config):
        writer({"messages": [chunk]})  # Stream to client
        chunks.append(chunk)
    
    return {"messages": chunks}

# Build workflow
def build_workflow():
    graph = StateGraph(State)
    graph.add_node("chat", chat_node)
    graph.add_edge(START, "chat")
    graph.add_edge("chat", END)
    
    memory = MemorySaver()
    return graph.compile(checkpointer=memory)

# Wrap with CloudBase Agent
agent = LangGraphAgent(
    name="chatbot",
    description="A helpful conversational assistant",
    graph=build_workflow()
)
```

### 3. Deploy as HTTP Service

```python
# server.py
from cloudbase_agent.server import AgentServiceApp

AgentServiceApp().run(
    lambda: {"agent": agent},
    port=9000,
    enable_openai_endpoint=True
)
```

---

## LangGraphAgent Configuration

### Basic Configuration

```python
from cloudbase_agent.langgraph import LangGraphAgent

agent = LangGraphAgent(
    name="my-agent",  # Required: Agent identifier
    description="Agent description",  # Optional: For documentation
    graph=build_workflow(),  # Required: CompiledStateGraph
    use_callbacks=True,  # Optional: Enable callback system (default: False)
)
```

### Advanced Configuration

```python
agent = LangGraphAgent(
    name="advanced-agent",
    description="Advanced agent with full configuration",
    graph=compiled_graph,
    use_callbacks=True,
    
    # Add callbacks
    callbacks=[ConsoleLogger(), MetricsCollector()],

## agent-deployment

# Agent Deployment Guide

## Core Principle

**Always use the `manageAgent` MCP tool to deploy Agent services.**

It natively supports SSE streaming, session persistence, and Python 3.10 runtime — purpose-built for Agent scenarios.

Do **NOT** use `createFunction` or `manageCloudRun` for Agent deployment.

## Why HTTP Cloud Functions First

| Dimension | HTTP Cloud Functions | CloudRun |
|-----------|---------------------|----------|
| SSE Streaming | ✅ Native support | ✅ Supported |
| WebSocket | ✅ Native support | ✅ Supported |
| Deployment Complexity | Low (no Dockerfile needed) | High (container config required) |
| Cost | Pay-per-invocation, scales to zero | Pay-per-instance-hour |
| Cold Start | Yes, mitigated with provisioned instances | Yes, mitigated with min instances |
| Supported Runtimes | Node.js, Python | Any |

---

## ⚠️ DEPLOYMENT IS A 4-STEP BLOCKING PIPELINE

<!-- INSTRUCTION (AI MUST EXECUTE EVERY STEP IN ORDER) -->

> **AI: You MUST execute Steps 1→2→3→4 in order. Do NOT skip any step.**
> **Do NOT call `manageAgent` until Step 3 (Verification) passes ALL checks.**

```
Step 1: Ensure Python 3.10  ──▶  Step 2: Build env/  ──▶  Step 3: Verify  ──▶  Step 4: Deploy
       (BLOCKING)                   (BLOCKING)              (BLOCKING)           (final)
```

---

## Step 1: Ensure Python 3.10

<!-- INSTRUCTION (AI MUST EXECUTE) -->

Execute one of the following to ensure Python 3.10 is available:

```bash
# Check if python3.10 already exists
python3.10 --version 2>/dev/null || python3 --version

# If NOT 3.10.x, install it:
# Option A: brew (macOS)
brew install python@3.10

# Option B: pyenv
pyenv install 3.10
pyenv local 3.10
```

**Verification (REQUIRED before proceeding):**
```bash
python3.10 --version
# MUST output: Python 3.10.x
# If it shows 3.11+ or 3.9-, STOP and fix before continuing.
```

<details>
<summary>Why must it be Python 3.10? (background info, AI may skip)</summary>

pip's `--python-version` flag correctly selects wheel files for the target version, but it does **NOT** reliably evaluate environment markers (e.g., `exceptiongroup; python_version < "3.11"`) — it may use the **host interpreter's version** instead of the target version. This causes conditional dependencies like `exceptiongroup` (required by `anyio` on Python < 3.11) to be silently skipped, leading to `ModuleNotFoundError` at runtime on the cloud (which runs Python 3.10).
</details>

---

## Step 2: Build env/ (One-Shot Install)

<!-- INSTRUCTION (AI MUST EXECUTE) -->

> ### ⚠️ CRITICAL: `env/` is an immutable build artifact
>
> The ONLY correct workflow is:
> 1. **Delete** → `rm -rf ./env`
> 2. **Install** → single `pip install` command (below)
> 3. **Never touch again**
>
> **NEVER** run a second `pip install` into `env/`. **NEVER** manually copy/move/delete files inside `env/`.
> If you need to change anything, edit `requirements.txt` and redo steps 1–2 from scratch.

**Execute this script as-is. Do NOT break it into separate steps. Do NOT modify any line.**

```bash
#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(pwd)"

# ── Detect Python 3.10 ──
PYTHON_BIN=""
if command -v python3.10 &>/dev/null; then
  PYTHON_BIN="python3.10"
elif python3 --version 2>&1 | grep -q "3\.10\."; then
  PYTHON_BIN="python3"
else
  echo "❌ ERROR: Python 3.10 not found. Run Step 1 first."
  exit 1
fi
echo "✅ Using: $PYTHON_BIN ($($PYTHON_BIN --version 2>&1))"

# ── Atomic env/ rebuild ──
rm -rf ./env && mkdir ./env

# ── One-shot install ALL deps ──
$PYTHON_BIN -m pip install -r ./requirements.txt \
  --platform manylinux2014_x86_64 \
  --target ./env \
  --python-version 3.10 \
  --only-binary=:all: \
  --upgrade

echo "✅ env/ built successfully"
```

If `pip install` reports **any** errors, **STOP** and resolve the error first. Do NOT ignore errors and proceed to deploy — the resulting `env/` will be incomplete.

## authentication

# Authentication and User Context

This guide explains how to implement authentication and manage user context in CloudBase Agent Python SDK using the framework's reserved fields pattern.

## Overview

CloudBase Agent uses a standardized approach for passing user context through the request lifecycle:

```
HTTP Request (JWT in header)
  ↓ (middleware extracts)
state["__request_context__"]["user"]["id"]
state["__request_context__"]["user"]["jwt"]
  ↓ (available to)
Agent / Adapter / Tools
```

## Framework Reserved Fields

CloudBase Agent reserves specific fields in `state` for user authentication:

| Field | Type | Description | Access |
|-------|------|-------------|--------|
| `state["__request_context__"]["user"]["id"]` | `str` | User identifier | Read-only (set by middleware) |
| `state["__request_context__"]["user"]["jwt"]` | `dict` | JWT payload | Read-only (set by middleware) |

**⚠️ Security Warning**: These fields are set by authentication middleware and should be treated as read-only. Modifying them in your agent logic may lead to security vulnerabilities.

## Implementation Pattern

### 1. Authentication Middleware (Write)

Middleware extracts user information from the request and injects it into `state`:

```python
import jwt
from fastapi import Request
from cloudbase_agent.server.send_message.models import RunAgentInput
from typing import Generator

def auth_middleware(
    input_data: RunAgentInput, 
    request: Request
) -> Generator[None, None, None]:
    """
    Extract user from JWT and inject into state.
    
    This middleware:
    1. Extracts JWT from Authorization header
    2. Verifies the token
    3. Injects user info into framework reserved fields
    """
    # Extract token
    auth_header = request.headers.get("Authorization", "")
    token = auth_header.replace("Bearer ", "")
    
    if token:
        try:
            # Verify JWT (use your own secret and algorithm)
            jwt_payload = jwt.decode(
                token, 
                "your-secret-key", 
                algorithms=["HS256"]
            )
            
            # Initialize state if needed
            if input_data.state is None:
                input_data.state = {}
            
            # ✅ Inject into framework reserved fields
            input_data.state["__request_context__"] = {
                "user": {
                    "id": jwt_payload["sub"],  # User ID from JWT sub claim
                    "jwt": jwt_payload         # Full JWT payload
                }
            }
            
        except jwt.InvalidTokenError as e:
            # Handle invalid token (log but don't block in this example)
            print(f"Invalid JWT token: {e}")
            # You could raise an exception here to block the request
            # raise InvalidRequestError(message="Invalid authentication token")
    
    yield  # Continue to next middleware or agent
```

### 2. Register Middleware

```python
from cloudbase_agent.server import AgentServiceApp

app = AgentServiceApp()
app.use(auth_middleware)  # Register before run()
app.run(create_agent, port=9000)
```

### 3. Adapter/Agent (Read)

In your adapter or agent, read the user information:

```python
def get_user_id_from_state(state: dict) -> str:
    """
    Safely extract user ID from framework reserved field.
    
    :param state: Agent state dictionary
    :return: User ID string
    :raises ValueError: If user ID not found
    """
    request_context = state.get("__request_context__", {})
    user = request_context.get("user", {})
    user_id = user.get("id")
    
    if not user_id:
        raise ValueError(
            "user_id is required but not found in "
            "state.__request_context__.user.id. "
            "Please ensure auth middleware is registered."
        )
    

## observability

# CloudBase Agent Observability Reference

## Overview

CloudBase Agent provides comprehensive observability features including logging, metrics, and distributed tracing.

## Logging

### Basic Configuration

```python
from cloudbase_agent.server import create_server
import logging

server = create_server(
    log_level="INFO",
    log_format="json",  # or "text"
    log_output="stdout"  # or file path
)
```

### Structured Logging

```python
from cloudbase_agent.server.logging import get_logger

logger = get_logger(__name__)

# Structured log with context
logger.info(
    "Agent request received",
    extra={
        "conversation_id": "conv_123",
        "user_id": "user_456",
        "agent_type": "react",
        "duration_ms": 150
    }
)
```

### Log Levels

```python
logger.debug("Detailed debugging information")
logger.info("General information")
logger.warning("Warning messages")
logger.error("Error messages", exc_info=True)
logger.critical("Critical errors")
```

## Metrics

### Prometheus Metrics

```python
from cloudbase_agent.server.metrics import (
    Counter,
    Histogram,
    Gauge,
    Summary
)

# Define metrics
requests_total = Counter(
    "agent_requests_total",
    "Total agent requests",
    ["agent_type", "status"]
)

request_duration = Histogram(
    "agent_request_duration_seconds",
    "Request duration in seconds",
    ["agent_type"],
    buckets=[0.1, 0.5, 1.0, 2.5, 5.0, 10.0]
)

active_conversations = Gauge(
    "active_conversations",
    "Number of active conversations"
)

# Use metrics
requests_total.labels(agent_type="react", status="success").inc()
request_duration.labels(agent_type="react").observe(1.23)
active_conversations.set(42)
```

### Metrics Endpoint

```python
from cloudbase_agent.server import create_server

server = create_server(
    enable_metrics=True,
    metrics_path="/metrics"  # Default Prometheus endpoint
)
```

### Custom Metrics

```python
from cloudbase_agent.server.metrics import register_metric

# Register custom metric
tool_calls = Counter(
    "agent_tool_calls_total",
    "Total tool calls",
    ["tool_name", "status"]
)
register_metric(tool_calls)

# Use in tool
@tool
def my_tool(param: str) -> dict:
    try:
        result = do_work(param)
        tool_calls.labels(tool_name="my_tool", status="success").inc()
        return result
    except Exception as e:
        tool_calls.labels(tool_name="my_tool", status="error").inc()

## recipes

# CloudBase Agent Recipes

Common patterns and complete examples for building agents with CloudBase Agent.

## Recipe 1: Basic Chat Agent

Complete example of a simple conversational agent.

```python
from cloudbase_agent.server import create_server, tool
from cloudbase_agent.langgraph import create_react_agent
from langchain_openai import ChatOpenAI

# Define tools
@tool
def get_weather(city: str) -> str:
    """Get current weather for a city."""
    return f"Weather in {city}: Sunny, 22°C"

# Create model and agent
model = ChatOpenAI(model="gpt-4")
agent = create_react_agent(
    model=model,
    tools=[get_weather]
)

# Create server
server = create_server()
server.add_agent("/chat", agent)

if __name__ == "__main__":
    server.run(host="0.0.0.0", port=9000)
```

## Recipe 2: Multi-Agent System

Orchestrate multiple specialized agents.

```python
from cloudbase_agent.langgraph import create_react_agent, create_router_agent

# Specialized agents
research_agent = create_react_agent(
    model=model,
    tools=[search_web, read_document],
    system_message="You are a research assistant."
)

writing_agent = create_react_agent(
    model=model,
    tools=[grammar_check, format_text],
    system_message="You are a writing assistant."
)

# Router agent
router = create_router_agent(
    agents={
        "research": research_agent,
        "writing": writing_agent
    },
    model=model
)

server.add_agent("/assistant", router)
```

## Recipe 3: Persistent Conversations

Maintain conversation history across sessions.

```python
from cloudbase_agent.server.storage import RedisStorage, ConversationStorage
from cloudbase_agent.langgraph import create_checkpointer

# Setup storage
storage = RedisStorage(url="redis://localhost:6379")
conv_storage = ConversationStorage(storage)
checkpointer = create_checkpointer(storage)

# Create agent with persistence
agent = create_react_agent(
    model=model,
    tools=tools,
    checkpointer=checkpointer
)

# Handle request with conversation ID
@server.post("/chat")
async def chat(request):
    conversation_id = request.conversation_id
    
    # Load conversation
    messages = await conv_storage.load_conversation(conversation_id)
    
    # Invoke agent
    result = await agent.ainvoke(
        {"messages": messages + [request.message]},
        config={"configurable": {"thread_id": conversation_id}}
    )
    
    # Save conversation
    await conv_storage.save_conversation(
        conversation_id,
        messages + [request.message, result["messages"][-1]]
    )
    
    return result
```

## Recipe 4: Streaming Responses

Stream agent responses in real-time.

```python
from cloudbase_agent.server import StreamingResponse

@server.post("/chat/stream")
async def chat_stream(request):
    async def generate():
        async for chunk in agent.astream(request.data):

## server

# Server Reference (`cloudbase_agent.server`)

FastAPI-based HTTP server with dual-protocol support (AG-UI + OpenAI).

## Exports

| Export | Purpose |
|--------|---------|
| `AgentServiceApp` | FastAPI wrapper with CORS, healthz, middleware |
| `create_send_message_adapter` | AG-UI native SSE streaming adapter |
| `create_openai_adapter` | OpenAI-compatible `/chat/completions` adapter |
| `RunAgentInput` | Request model (messages, thread_id, run_id, state, tools, context, forwarded_props) |
| `OpenAIChatCompletionRequest` | OpenAI-compatible request model |
| `AgentCreatorResult` | TypedDict: `{"agent": ..., "cleanup": optional_fn}` |
| `HealthzConfig` | Health check config (service_name, version, custom_checks) |

## Three Deployment Methods

### Method 1: One-line (simplest)

```python
AgentServiceApp().run(create_agent, port=9000)
```

### Method 2: Build + customize (recommended for multi-agent)

```python
app = AgentServiceApp()
fastapi_app = app.build(
    create_agent,
    base_path="/api",
    enable_openai_endpoint=True,
    enable_healthz=True,
)
# Add custom routes to fastapi_app...
uvicorn.run(fastapi_app, host="0.0.0.0", port=9000)
```

### Method 3: Core adapters (maximum flexibility)

```python
from fastapi import FastAPI
from cloudbase_agent.server import create_send_message_adapter, create_openai_adapter

app = FastAPI()

@app.post("/my-agent/send-message")
async def send_message(request: RunAgentInput):
    return await create_send_message_adapter(create_my_agent, request)

@app.post("/my-agent/chat/completions")
async def chat(request: OpenAIChatCompletionRequest):
    return await create_openai_adapter(create_my_agent, request)
```

## AgentServiceApp Constructor

```python
AgentServiceApp(
    observability=None,  # Optional[ObservabilityConfig | List[ObservabilityConfig]]
)
```

## AgentServiceApp Methods

| Method | Returns | Purpose |
|--------|---------|---------|
| `.set_cors_config(allow_origins, allow_credentials, allow_methods, allow_headers)` | self | Configure CORS |
| `.use(middleware)` | self | Register middleware (generator pattern) |
| `.build(create_agent, base_path, enable_cors, enable_openai_endpoint, enable_healthz, healthz_config)` | FastAPI | Build configured app |
| `.run(create_agent, base_path, host, port, enable_openai_endpoint, enable_healthz, healthz_config)` | None | Build + run with uvicorn |

## Middleware Pattern

Middlewares use Python's generator pattern with `yield` — code before yield runs pre-processing, code after yield runs post-processing (onion model).

```python
def my_middleware(input_data: RunAgentInput, request: Request):
    # Pre-processing (runs before agent)
    auth = request.headers.get("Authorization")
    if auth and auth.startswith("Bearer "):
        if not input_data.forwarded_props:
            input_data.forwarded_props = {}
        input_data.forwarded_props["user_id"] = decode_jwt(auth[7:])
    
    yield  # Control passes to agent
    
    # Post-processing (runs after agent, optional)
    print("Request completed")

app = AgentServiceApp()
app.use(my_middleware)
app.run(create_agent, port=9000)
```

## Agent Creator Pattern

Factory function called per-request. Supports optional cleanup callback:

```python
def create_agent() -> AgentCreatorResult:
    db = connect_database()
    agent = LangGraphAgent(graph=workflow, name="my-agent")
    
    def cleanup():
        db.close()  # Guaranteed to run after stream completes
    
    return {"agent": agent, "cleanup": cleanup}
```

## Multi-Agent Server

### Option A: Manual routes

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from cloudbase_agent.server import create_send_message_adapter, create_openai_adapter, RunAgentInput, OpenAIChatCompletionRequest
from cloudbase_agent.server.errors import install_exception_handlers


## storage

# CloudBase Agent Storage System Reference

## Overview

CloudBase Agent provides a unified storage interface for managing agent state, conversation history, and persistent data.

## Storage Interface

### Basic Operations

```python
from cloudbase_agent.server.storage import Storage

# Initialize storage
storage = Storage(backend="redis", url="redis://localhost:6379")

# Store data
await storage.set("key", {"data": "value"})

# Retrieve data
data = await storage.get("key")

# Delete data
await storage.delete("key")

# Check existence
exists = await storage.exists("key")
```

## Storage Backends

### Redis Backend

```python
from cloudbase_agent.server.storage import RedisStorage

storage = RedisStorage(
    url="redis://localhost:6379",
    db=0,
    decode_responses=True,
    max_connections=10
)
```

### Memory Backend (Development)

```python
from cloudbase_agent.server.storage import MemoryStorage

storage = MemoryStorage()  # In-memory, no persistence
```

### PostgreSQL Backend

```python
from cloudbase_agent.server.storage import PostgresStorage

storage = PostgresStorage(
    connection_string="postgresql://user:pass@localhost/cloudbase_agent_db",
    table_name="agent_storage"
)
```

## Conversation Storage

### Store Conversation State

```python
from cloudbase_agent.server.storage import ConversationStorage

conv_storage = ConversationStorage(storage)

# Save conversation
await conv_storage.save_conversation(
    conversation_id="conv_123",
    messages=[
        {"role": "user", "content": "Hello"},
        {"role": "assistant", "content": "Hi there!"}
    ],
    metadata={"user_id": "user_456"}
)

# Load conversation
conversation = await conv_storage.load_conversation("conv_123")
```

### Conversation History

```python
# Get all conversations for a user
conversations = await conv_storage.list_conversations(
    user_id="user_456",
    limit=10,
    offset=0
)

# Search conversations
results = await conv_storage.search_conversations(
    query="agent features",
    user_id="user_456"
)
```

## Checkpointing

### LangGraph Checkpointer

```python
from cloudbase_agent.langgraph import create_checkpointer

# Create checkpointer from storage
checkpointer = create_checkpointer(storage)

# Use with LangGraph
graph = create_react_agent(
    model=model,
    tools=tools,
    checkpointer=checkpointer
)
```

## tools

# CloudBase Agent Tools System Reference

## Overview

CloudBase Agent provides a flexible tool system for integrating external capabilities into agents.

## Core Concepts

### Tool Definition

```python
from cloudbase_agent.server import tool

@tool
def search_database(query: str, limit: int = 10) -> list[dict]:
    """Search the database for matching records.
    
    Args:
        query: Search query string
        limit: Maximum number of results to return
        
    Returns:
        List of matching records
    """
    # Implementation
    return results
```

### Tool Registry

```python
from cloudbase_agent.server import ToolRegistry

# Create registry
registry = ToolRegistry()

# Register tools
registry.register(search_database)
registry.register(update_record)

# Get all tools
tools = registry.get_tools()
```

## Built-in Tool Types

### HTTP Tools

```python
from cloudbase_agent.server.tools import HttpTool

http_tool = HttpTool(
    name="fetch_data",
    method="GET",
    url="https://api.example.com/data",
    headers={"Authorization": "Bearer TOKEN"}
)
```

### Database Tools

```python
from cloudbase_agent.server.tools import DatabaseTool

db_tool = DatabaseTool(
    name="query_users",
    connection_string="postgresql://localhost/mydb",
    query="SELECT * FROM users WHERE active = true"
)
```

## Tool Execution

### Synchronous Execution

```python
result = await tool.execute({"query": "search term", "limit": 5})
```

### Async Tool Support

```python
@tool
async def async_search(query: str) -> dict:
    """Async tool example."""
    async with httpx.AsyncClient() as client:
        response = await client.get(f"https://api.example.com/search?q={query}")
        return response.json()
```

## Tool Validation

### Input Validation

```python
from pydantic import BaseModel, Field

class SearchParams(BaseModel):
    query: str = Field(..., min_length=1, max_length=100)
    limit: int = Field(default=10, ge=1, le=100)

@tool
def validated_search(params: SearchParams) -> list[dict]:
    """Tool with Pydantic validation."""
    return search(params.query, params.limit)
```

## Error Handling

```python
from cloudbase_agent.server.tools import ToolError

@tool
def safe_operation(data: dict) -> dict:
    """Tool with error handling."""
    try:
        result = risky_operation(data)
        return {"success": True, "data": result}
    except ValueError as e:
        raise ToolError(f"Invalid input: {e}")

## server-quickstart

# Server Quickstart Guide

This guide shows you how to create and deploy CloudBase Agent Python agents as HTTP services using FastAPI.

---

## Three Deployment Methods

CloudBase Agent Python SDK provides three flexible deployment methods, each suited for different use cases:

### Method 1: Core Adapters (Maximum Flexibility)

Use `create_send_message_adapter()` and `create_openai_adapter()` directly for complete control over routes.

```python
from fastapi import FastAPI
from cloudbase_agent.server import (
    create_send_message_adapter,
    create_openai_adapter,
    RunAgentInput,
    OpenAIChatCompletionRequest
)
from cloudbase_agent.server.errors import install_exception_handlers

app = FastAPI()

# Required: Install exception handlers for AG-UI protocol compatibility
install_exception_handlers(app)

# Define routes manually
@app.post("/my-agent/send-message")
async def send_message(request: RunAgentInput):
    return await create_send_message_adapter(create_agent, request)

@app.post("/my-agent/chat/completions")
async def openai_endpoint(request: OpenAIChatCompletionRequest):
    return await create_openai_adapter(create_agent, request)
```

**Advantages:**
- Full control over route paths
- Easy to add custom middleware per route
- Clear separation of concerns
- Ideal for complex multi-agent systems

**Use when:**
- You need custom route structures
- You want fine-grained control
- You're building complex applications

### Method 2: AgentServiceApp with Custom Routes (Recommended)

Use `AgentServiceApp.build()` for automatic features with flexibility:

```python
from fastapi import FastAPI
from cloudbase_agent.server import AgentServiceApp, HealthzConfig

# Create main app
main_app = FastAPI(title="My Service")

# Build agent app with automatic features
agent_app = AgentServiceApp()
agent_fastapi = agent_app.build(
    create_agent,
    base_path="",
    enable_cors=False,  # Handle in main app
    enable_openai_endpoint=True,
    enable_healthz=True,
    healthz_config=HealthzConfig(
        service_name="my-agent",
        version="1.0.0"
    )
)

# Mount to main app
main_app.mount("/my-agent", agent_fastapi)
```

**Advantages:**
- Automatic health check endpoints
- Built-in OpenAI compatibility
- Less boilerplate code
- Modular agent deployment

**Use when:**
- You want automatic health checks
- You're deploying multiple agents
- You need both CloudBase Agent native and OpenAI endpoints

### Method 3: One-Line Deployment (Simplest)

For single-agent deployments, use the one-line approach:

```python
from cloudbase_agent.server import AgentServiceApp, HealthzConfig

AgentServiceApp().run(
    create_agent,
    port=9000,
    enable_openai_endpoint=True,
    healthz_config=HealthzConfig(
        service_name="my-agent",
        version="1.0.0"
    )
)
```

**Advantages:**
- Extremely simple (one line!)
- Perfect for prototyping
- Automatic CORS and health checks
- No boilerplate needed

**Use when:**
- You have a single agent
- You want the fastest way to start
- You don't need custom routes

---

## skill

---
name: cloudbase-agent-python
description: "Build production-ready AI agent backends using the CloudBase Agent Python SDK — create agents with LangGraph/CrewAI/LlamaIndex, serve them via FastAPI with AG-UI protocol streaming + OpenAI-compatible endpoints, add tools (bash, filesystem, MCP, code execution), memory (in-memory, TDAI, MySQL, MongoDB), observability (OpenTelemetry/Langfuse), and middleware (auth, logging). Use this skill when the user wants to create an AI agent server, build a chatbot backend, set up human-in-the-loop workflows, integrate MCP tools, add agent observability, or deploy an agent API — even if they don't explicitly mention 'CloudBase Agent.'"
version: 2.35.2
license: MIT
alwaysApply: true
---

# CloudBase Agent Python SDK

Build production-ready AI agent backends with multi-framework support, streaming
protocol, rich tools, persistent memory, and full observability.

> **Note:** This skill is for **Python** projects only.

## When to use this skill

Use this skill for **AI agent development** when you need to:

- Deploy AI agents as HTTP services with AG-UI protocol support
- Build agent backends using LangGraph, CrewAI, or LlamaIndex frameworks
- Create custom agent adapters implementing the AbstractAgent interface
- Understand AG-UI protocol events and message streaming
- Build production-ready agent servers with FastAPI

**Do NOT use for:**
- Simple AI model calling without agent capabilities (use `ai-model-*` skills)
- CloudBase cloud functions (use `cloud-functions` skill)
- CloudRun backend services without agent features (use `cloudrun-development` skill)
- TypeScript/JavaScript agent projects (use `cloudbase-agent` skill, refer to the `ts/` sub-directory)

## How to use this skill (for a coding agent)

1. **Choose the right adapter**
   - Use LangGraph adapter for stateful, graph-based workflows
   - Use CrewAI adapter for multi-agent collaboration patterns
   - Build custom adapter for specialized agent logic

2. **Write agent code** — follow the adapter-specific doc from the Routing table

3. **Deploy the agent server** — follow the **blocking deployment pipeline** in [agent-deployment](agent-deployment.md)

## Routing (Execution Order)

> ⚠️ **Deployment is a BLOCKING 4-step pipeline.** Steps marked ✅ BLOCKING
> must be completed AND verified before proceeding to the next step.
> Do NOT call `manageAgent` until all blocking steps pass.

| Step | Task | Document | Blocking? |
|------|------|----------|-----------|
| 0 | **Choose adapter & write agent code** | See "Adapter Selection" below | — |
| 1 | **Ensure Python 3.10** | [agent-deployment](agent-deployment.md) § Step 1 | ✅ BLOCKING |
| 2 | **Build env/ (one-shot)** | [agent-deployment](agent-deployment.md) § Step 2 | ✅ BLOCKING |
| 3 | **Verify env/ integrity** | [agent-deployment](agent-deployment.md) § Step 3 | ✅ BLOCKING |
| 4 | **Deploy with manageAgent** | [agent-deployment](agent-deployment.md) § Step 4 | — |

### Adapter Selection (Step 0)

| Framework | Read | Install |
|-----------|------|---------|
| LangGraph (stateful graphs) | [adapter-langgraph](adapter-langgraph.md) | `cloudbase-agent-langgraph` |
| CrewAI (multi-agent crews) | [adapter-development](adapter-development.md) | `cloudbase-agent-crewai` |
| Coze platform | [adapter-coze](adapter-coze.md) | `cloudbase-agent-coze` |
| Custom / raw FastAPI | [server-quickstart](server-quickstart.md) + [adapter-development](adapter-development.md) | `cloudbase-agent-server` |

### Additional References (read on demand, NOT required for deployment)

| Task | Read |
|------|------|
| Server setup, middleware, multi-agent, CORS | [server-quickstart](server-quickstart.md) |
| Authentication and user context | [authentication](authentication.md) |

## Quick Start (Framework-Agnostic)

**Prerequisites:** Python >= 3.10 is required.

**1. Install dependencies (pick ONE adapter):**

```bash
# Option A: LangGraph-based agent
pip install cloudbase-agent-langgraph

# Option B: CrewAI-based agent
pip install cloudbase-agent-crewai

# Option C: Custom / minimal
pip install cloudbase-agent-server
```

**2. Create server entry point:**

```python
# server.py — this pattern works with ANY adapter
import os
from dotenv import load_dotenv
load_dotenv()

from cloudbase_agent.server import AgentServiceApp, AgentCreatorResult

# Import your agent (framework-specific, see adapter docs)
# from agents.chat.agent import create_my_agent

def create_agent() -> AgentCreatorResult:
    agent = create_my_agent()  # Your agent factory
    return {"agent": agent}

app = AgentServiceApp()
app.set_cors_config(allow_origins=["*"])

if __name__ == "__main__":
    port = int(os.environ.get("SCF_RUNTIME_PORT", "9000"))
    app.run(create_agent, port=port, host="0.0.0.0")
```

**3. Deploy to CloudBase:**

Follow the **4-step deployment pipeline** in [agent-deployment](agent-deployment.md).

---


## rule

---
name: cloudbase-agent
description: Build and deploy AI agents with CloudBase Agent SDK (TypeScript & Python). Implements the AG-UI protocol for streaming agent-UI communication. Use when deploying agent servers, using LangGraph/LangChain/CrewAI adapters, building custom adapters, understanding AG-UI protocol events, or building web/mini-program UI clients. Supports both TypeScript (@cloudbase/agent-server) and Python (cloudbase-agent-server via FastAPI).
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

# CloudBase Agent SDK — Language Router

This skill supports **TypeScript** and **Python**. Determine the language first, then read the corresponding skill file. If the user does not explicitly specify which programming language to use, TypeScript must be enforced.

## Step 1: Determine Language

| Signal | Language |
|--------|----------|
| User says "TypeScript", "Node.js", "TS" | **TypeScript** |
| User says "Python", "FastAPI", "pip" | **Python** |
| No clear signal | **TypeScript** |

## Step 2: Read the Language-Specific Skill File

- **TypeScript** → Read [ts/skill.md](ts/skill.md) — then follow ALL instructions in that file
- **Python** → Read [py/skill.md](py/skill.md) — then follow ALL instructions in that file

**⚠️ IMPORTANT:** After determining the language, you MUST read the corresponding skill file above. Do NOT proceed with any code generation until you have read it. Each language skill file is self-contained with its own quick start, routing table, deployment instructions, and adapter guides.

## adapter-development

# Building Custom Adapters

An adapter bridges your AI framework to the AG-UI protocol. It converts AG-UI input (messages, tools, state) into your framework's format, and converts your framework's streaming output into AG-UI events.

**Prerequisites:** Deep understanding of both your AI framework's API and the AG-UI protocol events.

**When to build your own:** No existing adapter for your framework (check AG-UI ecosystem first).

Extend `AbstractAgent` and implement `run()` that returns `Observable<BaseEvent>`.

## Structure

```typescript
import { AbstractAgent, RunAgentInput, BaseEvent, EventType } from "@ag-ui/client";
import { Observable, Subscriber } from "rxjs";

export class MyAdapter extends AbstractAgent {
  run(input: RunAgentInput): Observable<BaseEvent> {
    return new Observable((subscriber) => this._run(subscriber, input));
  }

  private async _run(subscriber: Subscriber<BaseEvent>, input: RunAgentInput) {
    const { messages, runId, threadId, tools } = input;

    subscriber.next({ type: EventType.RUN_STARTED, threadId, runId });

    try {
      // 1. Convert AG-UI input to your framework's format
      // 2. Call your framework
      // 3. Convert your framework's output to AG-UI events (see Event Sequence below)

      subscriber.next({ type: EventType.RUN_FINISHED, threadId, runId });
    } catch (error) {
      subscriber.next({ type: EventType.RUN_ERROR, message: error.message });
    }
    subscriber.complete();
  }
}
```

## Event Sequence (Brief)

**Text:** `TEXT_MESSAGE_START` → `TEXT_MESSAGE_CONTENT` (repeat) → `TEXT_MESSAGE_END`

**Tool call:** `TOOL_CALL_START` → `TOOL_CALL_ARGS` → `TOOL_CALL_END`

**Tool result (server-executed tools only):** `TOOL_CALL_RESULT`

Always emit full lifecycle. `parentMessageId` links tool calls to their parent message.

For complete event reference, see [AG-UI Protocol](https://docs.ag-ui.com/concepts/events).

## adapter-langchain

# @cloudbase/agent-adapter-langchain

Adapter that wraps LangChain's `createAgent()` as an AG-UI compatible agent. Provides `LangchainAgent` wrapper class and `clientTools()` middleware for client tools support.

## Basic Usage

```typescript
import { createAgent as createLangchainAgent } from "langchain";
import { MemorySaver } from "@langchain/langgraph";
import { ChatOpenAI } from "@langchain/openai";
import { LangchainAgent, clientTools } from "@cloudbase/agent-adapter-langchain";

const model = new ChatOpenAI({ model: "gpt-4o" });
const checkpointer = new MemorySaver();

const lcAgent = createLangchainAgent({
  model,
  checkpointer,
  middleware: [clientTools()],
});

const agent = new LangchainAgent({ agent: lcAgent });
```

## Checkpointer (Required)

`LangchainAgent` requires the agent to be created with a checkpointer.

### MemorySaver (Development)

```typescript
import { MemorySaver } from "@langchain/langgraph";

const lcAgent = createLangchainAgent({
  model,
  checkpointer: new MemorySaver(),
  middleware: [clientTools()],
});
```

### CloudBaseSaver (Production)

Persistent storage using Tencent CloudBase document database. On CloudBase cloud function/cloudrun, requests are authenticated - extract user ID from the JWT in Authorization header.

```typescript
import { run } from "@cloudbase/agent-server";
import { LangchainAgent, clientTools } from "@cloudbase/agent-adapter-langchain";
import { CloudBaseSaver } from "@cloudbase/agent-adapter-langgraph";
import { createAgent as createLangchainAgent } from "langchain";
import tcb from "@cloudbase/node-sdk";

const app = tcb.init({ env: process.env.CLOUDBASE_ENV_ID });

run({
  createAgent: ({ request }) => {
    // Extract user ID from JWT (sub field)
    const token = request.headers.get("Authorization")?.slice(7);
    const payload = JSON.parse(atob(token.split(".")[1]));
    const userId = payload.sub;

    const checkpointer = new CloudBaseSaver({
      db: app.database(),
      userId,  // Multi-tenant isolation
    });

    const lcAgent = createLangchainAgent({
      model,
      checkpointer,
      middleware: [clientTools()],
    });

    return { agent: new LangchainAgent({ agent: lcAgent }) };
  },
  port: 9000,
});
```

## With @cloudbase/agent-server

```typescript
import { run } from "@cloudbase/agent-server";

run({
  createAgent: () => ({ agent }),
  port: 9000,
});
```

## clientTools() Middleware

Enables client-defined tools in your LangChain agent:

- **Injects client tools** - Adds client tools to the LLM's available tool list
- **Routes to END** - When a client tool is called, skips ToolNode and routes to END so client can execute

## adapter-langgraph

# @cloudbase/agent-adapter-langgraph

Adapter that wraps a compiled LangGraph `StateGraph` workflow as an AG-UI compatible agent. Provides `ClientStateAnnotation` with pre-wired `messages` and `client.tools` fields for seamless AG-UI protocol integration.

## Installation

```bash
npm install @cloudbase/agent-adapter-langgraph@latest @langchain/langgraph @langchain/openai
```

**Important:** Always use `@latest` for `@cloudbase/agent-*` packages to get the newest stable releases. Do NOT specify version ranges like `^1.0.0` or exact versions like `1.0.0`, as the package versions may not follow semantic versioning expectations and such versions may not exist.

For projects requiring version locking, install first with `@latest`, then commit `package-lock.json`.

## Exports

```typescript
import {
  LanggraphAgent,
  ClientStateAnnotation,
  ClientState,
  CloudBaseSaver  // Tencent CloudBase checkpointer
} from "@cloudbase/agent-adapter-langgraph";
```

## Basic Usage

```typescript
import { LanggraphAgent } from "@cloudbase/agent-adapter-langgraph";

const agent = new LanggraphAgent({
  compiledWorkflow: graph,  // compiled StateGraph (required)
  logger: myLogger,         // optional
});
```

## Checkpointer (Required)

`LanggraphAgent` requires the workflow to be compiled with a checkpointer.

### MemorySaver (Development)

```typescript
import { MemorySaver } from "@langchain/langgraph";

const graph = workflow.compile({ checkpointer: new MemorySaver() });
```

### CloudBaseSaver (Production)

Persistent storage using Tencent CloudBase document database. On CloudBase cloud function/cloudrun, requests are authenticated - extract user ID from the JWT in Authorization header.

```typescript
import { run } from "@cloudbase/agent-server";
import { CloudBaseSaver, LanggraphAgent } from "@cloudbase/agent-adapter-langgraph";
import tcb from "@cloudbase/node-sdk";

const app = tcb.init({ env: process.env.CLOUDBASE_ENV_ID });

run({
  createAgent: ({ request }) => {
    // Extract user ID from JWT (sub field)
    const token = request.headers.get("Authorization")?.slice(7);
    const payload = JSON.parse(atob(token.split(".")[1]));
    const userId = payload.sub;

    const checkpointer = new CloudBaseSaver({
      db: app.database(),
      userId,  // Multi-tenant isolation
    });

    const graph = workflow.compile({ checkpointer });
    return { agent: new LanggraphAgent({ compiledWorkflow: graph }) };
  },
  port: 9000,
});
```

## Client Tools

Client tools are tools defined by the client, not the server. They let the agent request actions only the client can perform (e.g., show modal, navigate, access local storage). The flow:

1. **Client** defines tools with handlers and sends them in request
2. **Server** binds client tools alongside server tools, LLM can call any
3. **Server** detects client tool call → routes to END (doesn't execute)
4. **Client** receives `TOOL_CALL_*` events, executes handler locally
5. **Client** sends tool result back, agent resumes

### Server Side: Bind and Route

```typescript
import { ClientState } from "@cloudbase/agent-adapter-langgraph";

// 1. Bind client tools to model (alongside server tools)
async function chatNode(state: ClientState) {
  const clientTools = state.client?.tools || [];
  const modelWithTools = model.bindTools([...clientTools, ...serverTools]);
  // ...
}

// 2. Route client tool calls to END (let client handle)
function shouldContinue(state: ClientState): "tools" | "end" {
  const lastMessage = state.messages[state.messages.length - 1];
  if (lastMessage.tool_calls?.length > 0) {
    const hasServerToolCall = lastMessage.tool_calls.some(tc => serverToolNames.has(tc.name));
    if (hasServerToolCall) return "tools";  // Server executes
  }
  return "end";  // Client tool or no tool → end, client handles
}
```

## Complete Workflow Pattern

```typescript
import { StateGraph, START, END, Command } from "@langchain/langgraph";
import { ClientStateAnnotation, ClientState } from "@cloudbase/agent-adapter-langgraph";
import { MemorySaver } from "@langchain/langgraph";
import { ChatOpenAI } from "@langchain/openai";
import { SystemMessage } from "@langchain/core/messages";
import { RunnableConfig } from "@langchain/core/runnables";

## agent-deployment

# Agent Deployment Guide

## Core Principle

**Always use the `manageAgent` MCP tool to deploy Agent services.**

It natively supports SSE streaming, session persistence, and Node.js 20 runtime — purpose-built for Agent scenarios.

Do **NOT** use `createFunction` or `manageCloudRun` for Agent deployment.

## Why HTTP Cloud Functions First

| Dimension | HTTP Cloud Functions | CloudRun |
|-----------|---------------------|----------|
| SSE Streaming | ✅ Native support | ✅ Supported |
| WebSocket | ✅ Native support | ✅ Supported |
| Deployment Complexity | Low (no Dockerfile needed) | High (container config required) |
| Cost | Pay-per-invocation, scales to zero | Pay-per-instance-hour |
| Cold Start | Yes, mitigated with provisioned instances | Yes, mitigated with min instances |
| Supported Runtimes | Node.js, Python | Any |

## Deployment Steps (HTTP Cloud Functions)

1. Ensure project has `scf_bootstrap` startup script (see below)
2. Deploy using `manageAgent` MCP tool with `runtime="Nodejs20.19"`:

```
manageAgent(action="create", runtime="Nodejs20.19", installDependency=true, targetPath="...")
```

3. Set environment variables (OPENAI_API_KEY, OPENAI_BASE_URL, OPENAI_MODEL, etc.)
4. Verify SSE connectivity

> ⚠️ **CRITICAL**: Always set `installDependency=true` to let cloud install dependencies automatically. Without this, you'll get `ERR_MODULE_NOT_FOUND` errors.

> For server code and adapter usage, see [server-quickstart](server-quickstart.md) and [adapter-langgraph](adapter-langgraph.md).

## Dependency Alignment Policy (CRITICAL)

**Always use `latest` for `@cloudbase/agent-*` and `@langchain/*` packages. Never specify version ranges.**

**Reference example** (adapt based on your actual dependencies):

```json
{
  "dependencies": {
    "@cloudbase/agent-server": "latest",
    "@cloudbase/agent-adapter-langgraph": "latest",
    "@langchain/langgraph": "latest",
    "@langchain/openai": "latest"
  }
}
```

> **Why?** `@cloudbase/agent-adapter-langgraph` has peer dependency on specific `@langchain/core` versions. Specifying version ranges like `^0.3.44` causes `[ResourceNotFound.Package] Dependency error` during cloud build.

---

## Node.js Runtime Version

**Always select Node.js 20 runtime** (`runtime="Nodejs20"`):

- Full compatibility with all `@cloudbase/agent-*` packages
- ES Module support (`"type": "module"` in package.json)
- Stable and well-tested on the CloudBase platform

Do **NOT** use Node.js 16 or earlier — many SDK features require Node.js >= 20.

## Startup Script (scf_bootstrap)

The startup script must be named `scf_bootstrap` (no file extension), placed in the project root, and have executable permissions:

```bash
#!/bin/sh
node src/index.js
```

```bash
chmod +x scf_bootstrap
```

> **IMPORTANT**: The `scf_bootstrap` script should be minimal — just start the Node.js application. Do NOT include `npm install` in this script. Dependencies are handled during deployment.

> **NOTE**: Use `#!/bin/sh` (not `#!/bin/bash`) for maximum compatibility. The entry point should match your actual server entry file.

## Port & CORS

- Your server **should** listen on port `9000` (the default for CloudBase Agent)
- In production (CloudBase), CORS is handled by the API gateway — no need to enable it in code
- For local development, conditionally enable CORS via an environment variable (e.g., `ENABLE_CORS=true`)

## Environment Variables

| Variable | Required | Purpose |
|----------|----------|---------|
| `OPENAI_API_KEY` | ✅ | OpenAI API key or compatible service key |
| `OPENAI_BASE_URL` | ✅ | API base URL, e.g. `https://api.openai.com/v1` |
| `OPENAI_MODEL` | ✅ | Model name, e.g. `gpt-4o` or `gpt-3.5-turbo` |
| `LOG_LEVEL` | ❌ | Log level: `trace`/`debug`/`info`/`warn`/`error`/`fatal` (default: `info`) |
| `ENABLE_CORS` | ❌ | Set to `true` to enable CORS (local dev only) |

## When to Use CloudRun Instead

Despite HTTP Cloud Functions being preferred, use CloudRun in these cases:

- Custom Docker image required (special system-level dependencies like FFmpeg, Chromium, etc.)
- Resource requirements exceed Cloud Function limits
- Persistent local file storage needed
- Need to install native C extensions that require specific OS packages

For CloudRun deployment, use a Dockerfile:

```dockerfile
FROM node:20-alpine
WORKDIR /app

COPY package*.json ./
RUN npm i --production

COPY src ./src

## agui-protocol

# AG-UI Protocol

Open, event-based protocol for agent-UI communication. Server streams events to client via SSE.

## Event Patterns

**Start-Content-End**: For streaming content
```
TEXT_MESSAGE_START → TEXT_MESSAGE_CONTENT (repeat) → TEXT_MESSAGE_END
TOOL_CALL_START → TOOL_CALL_ARGS (repeat) → TOOL_CALL_END
```

**Lifecycle**: Wraps every agent run
```
RUN_STARTED → [events] → RUN_FINISHED | RUN_ERROR
```

**Snapshot-Delta**: For state sync
```
STATE_SNAPSHOT (full state) → STATE_DELTA (JSON Patch updates)
```

## Core Events

| Event | Key Fields |
|-------|------------|
| `RUN_STARTED` | threadId, runId |
| `RUN_FINISHED` | threadId, runId |
| `RUN_ERROR` | message, code? |
| `TEXT_MESSAGE_START` | messageId, role |
| `TEXT_MESSAGE_CONTENT` | messageId, delta |
| `TEXT_MESSAGE_END` | messageId |
| `TOOL_CALL_START` | toolCallId, toolCallName, parentMessageId? |
| `TOOL_CALL_ARGS` | toolCallId, delta |
| `TOOL_CALL_END` | toolCallId |
| `TOOL_CALL_RESULT` | toolCallId, messageId, content |
| `STATE_SNAPSHOT` | snapshot |
| `STATE_DELTA` | delta (RFC 6902 JSON Patch) |
| `MESSAGES_SNAPSHOT` | messages[] |

## Input Types

```typescript
interface RunAgentInput {
  threadId: string;
  runId: string;
  messages: Message[];
  tools: Tool[];
  state?: unknown;
  context?: Context[];
  forwardedProps?: Record<string, unknown>;
}

interface Message {
  id: string;
  role: "user" | "assistant" | "system" | "tool";
  content: string;
  name?: string;                    // for tool messages
  toolCalls?: ToolCall[];           // for assistant messages
  toolCallId?: string;              // for tool messages
}

interface ToolCall {
  id: string;
  type: "function";
  function: { name: string; arguments: string };
}

interface Tool {
  name: string;
  description: string;
  parameters?: JSONSchema;
}
```

## Tool Execution Flow

**Server-executed tools:**
1. Agent emits `TOOL_CALL_START/ARGS/END`
2. Server executes tool
3. Server emits `TOOL_CALL_RESULT`
4. Agent continues with result

**Client tools:**
1. Agent emits `TOOL_CALL_START/ARGS/END`
2. Server emits `RUN_FINISHED` (run pauses)
3. Client executes tool locally
4. Client sends new request with tool result in messages
5. Agent continues

## Full Reference

For complete protocol specification: https://docs.ag-ui.com/concepts/events

## server-quickstart

# @cloudbase/agent-server

Deploy AG-UI compatible agents as HTTP servers.

## Installation

```bash
npm install @cloudbase/agent-server@latest
```

**Important:** Always use `@latest` for `@cloudbase/agent-*` packages. Do NOT use version ranges like `^1.0.0` or exact versions, as these versions may not exist. The packages do not follow traditional semantic versioning.

## Deployment Methods

### run() - Standalone

```typescript
import { run } from "@cloudbase/agent-server";
run({ createAgent: () => ({ agent }), port: 9000 });
```

### createExpressServer() - Get App

```typescript
import { createExpressServer } from "@cloudbase/agent-server";
const app = createExpressServer({ createAgent: () => ({ agent }) });
app.listen(9000);
```

### createExpressRoutes() - Add to Existing

```typescript
import { createExpressRoutes } from "@cloudbase/agent-server";
createExpressRoutes({ createAgent: () => ({ agent }), express: app, basePath: "/api/" });
```

## Endpoints Created

| Endpoint | Purpose |
|----------|---------|
| `/agui` | CopilotKit RPC endpoint |
| `/send-message` | AG-UI endpoint (SSE) |
| `/healthz` | Health check |
| `/chat/completions` | OpenAI-compatible endpoint |
| `/v1/aibot/bots/:agentId/...` | Same endpoints with bot ID (when no basePath) |

## AgentCreatorContext

```typescript
interface AgentCreatorContext {
  request: Request;      // Web Standard Request
  logger?: Logger;       // Pino-style logger (AGUI routes only)
  requestId?: string;    // Unique request ID (AGUI routes only)
}

createAgent: (ctx: AgentCreatorContext) => ({
  agent,                 // Your adapter instance
  cleanup?: () => void   // Called when request ends
})
```

## Cleanup Pattern

```typescript
createAgent: (ctx) => {
  const db = connectToDatabase();
  ctx.logger?.info("Connected to database");
  return {
    agent: new LanggraphAgent({ workflow }),
    cleanup: () => db.close()
  };
}
```

## All Options

```typescript
run({
  createAgent,
  port: 9000,
  basePath: "/api/",           // Custom base path (default: dual endpoints)
  cors: true,                  // or { origin: "https://..." }
  useAGUI: true,               // Enable /agui endpoint (default: true)
  aguiOptions: {
    runtimeOptions: {},        // CopilotRuntimeOptions
    endpointOptions: {}        // CreateCopilotRuntimeServerOptions
  },
  logger: createConsoleLogger("debug"),
  observability: { type: "otlp", url: "...", headers: {...} }
});
```

## Logger Exports

```typescript
import {
  noopLogger,           // Silent logger (default)
  createConsoleLogger,  // Console logger
  generateRequestId,
  extractRequestId,
  getOrGenerateRequestId
} from "@cloudbase/agent-server";

// Custom logger (Pino-style interface)
const logger = {
  info: (obj, msg) => console.log(msg, obj),
  error: (obj, msg) => console.error(msg, obj),
  debug: (obj, msg) => console.debug(msg, obj),
  child: (bindings) => ({ ...logger })
};
```

## Observability

Requires `@cloudbase/agent-observability` package:

```typescript
run({
  createAgent,
  observability: { type: "console" }  // Logs traces to stdout

## skill

---
name: cloudbase-agent
description: "Build and deploy AI agents with Cloudbase Agent (TypeScript), a TypeScript SDK implementing the AG-UI protocol. Use when: (1) deploying agent servers with @cloudbase/agent-server, (2) using LangGraph adapter with ClientStateAnnotation, (3) using LangChain adapter with clientTools(), (4) building custom adapters that implement AbstractAgent, (5) understanding AG-UI protocol events, (6) building web UI clients with @ag-ui/client, (7) building WeChat Mini Program UIs with @cloudbase/agent-ui-miniprogram."
version: 2.35.2
license: MIT
alwaysApply: true
---

# Cloudbase Agent (TypeScript)

TypeScript SDK for deploying AI agents as HTTP services using the AG-UI protocol.

> **Note:** This skill is for **TypeScript/JavaScript** projects only.

## When to use this skill

Use this skill for **AI agent development** when you need to:

- Deploy AI agents as HTTP services with AG-UI protocol support
- Build agent backends using LangGraph or LangChain frameworks
- Create custom agent adapters implementing the AbstractAgent interface
- Understand AG-UI protocol events and message streaming
- Build web UI clients that connect to AG-UI compatible agents
- Build WeChat Mini Program UIs for AI agent interactions

**Do NOT use for:**
- Simple AI model calling without agent capabilities (use `ai-model-*` skills)
- CloudBase cloud functions (use `cloud-functions` skill)
- CloudRun backend services without agent features (use `cloudrun-development` skill)

## How to use this skill (for a coding agent)

1. **Choose the right adapter**
   - Use LangGraph adapter for stateful, graph-based workflows
   - Use LangChain adapter for chain-based agent patterns
   - Build custom adapter for specialized agent logic

2. **Deploy the agent server**
   - Use `@cloudbase/agent-server` to expose HTTP endpoints
   - Configure CORS, logging, and observability as needed
   - **Prefer deploying to CloudBase using `manageAgent` MCP tool** (see [agent-deployment](agent-deployment.md))
   - **Before deploy, read Dependency Alignment Policy in [agent-deployment](agent-deployment.md) to avoid cloud build dependency errors**

3. **Build the UI client**
   - Use `@ag-ui/client` for web applications
   - Use `@cloudbase/agent-ui-miniprogram` for WeChat Mini Programs
   - Connect to the agent server's `/send-message` or `/agui` endpoints

4. **Follow the routing table below** to find detailed documentation for each task

## Routing

| Task | Read |
|------|------|
| Deploy agent to CloudBase (**read this first**) | [agent-deployment](agent-deployment.md) |
| Deploy agent server (@cloudbase/agent-server) | [server-quickstart](server-quickstart.md) |
| Use LangGraph adapter | [adapter-langgraph](adapter-langgraph.md) |
| Use LangChain adapter | [adapter-langchain](adapter-langchain.md) |
| Build custom adapter | [adapter-development](adapter-development.md) |
| Understand AG-UI protocol | [agui-protocol](agui-protocol.md) |
| Build UI client (Web or Mini Program) | [ui-clients](ui-clients.md) |
| Deep-dive @cloudbase/agent-ui-miniprogram | [ui-miniprogram](ui-miniprogram.md) |

## Quick Start

**Prerequisites:** Node.js >= 20 is required.

**1. Install dependencies:**

```bash
npm install @cloudbase/agent-server@latest @cloudbase/agent-adapter-langgraph@latest
```

**Critical:** Always use `@latest` for all `@cloudbase/agent-*` packages. For dependency version rules, see [Dependency Alignment Policy](agent-deployment.md#dependency-alignment-policy-critical) in agent-deployment.md.

**2. Create and run your agent:**

```typescript
import { run } from "@cloudbase/agent-server";
import { LanggraphAgent } from "@cloudbase/agent-adapter-langgraph";

run({
  createAgent: () => ({ agent: new LanggraphAgent({ workflow }) }),
  port: 9000,
});
```



## ui-clients

# Building UI Clients

Connect your UI to AG-UI endpoints served by @cloudbase/agent-server.

## Web Applications

Use `@ag-ui/client` (official AG-UI SDK):

```bash
npm install @ag-ui/client@latest
```

```typescript
import { HttpAgent } from "@ag-ui/client";

const agent = new HttpAgent({ url: "http://localhost:9000/send-message" });

for await (const event of agent.run({
  threadId: "thread-1",
  runId: "run-1",
  messages: [{ id: "m1", role: "user", content: "Hello" }]
})) {
  console.log(event.type, event);
}
```

See AG-UI documentation for full API: https://docs.ag-ui.com

## WeChat Mini Program

Use `@cloudbase/agent-ui-miniprogram` (headless behavior mixin):

```bash
npm install @cloudbase/agent-ui-miniprogram@latest
```

```typescript
import { createAGUIBehavior, CloudbaseTransport } from "@cloudbase/agent-ui-miniprogram";

Component({
  behaviors: [createAGUIBehavior({
    transport: new CloudbaseTransport({ botId: "your-bot-id" })
  })],
  methods: {
    onSend() {
      this.agui.sendMessage(this.data.inputText);
    }
  }
});
// State: this.data.agui.uiMessages, this.data.agui.isRunning
```

Beyond basic usage, the package offers more `createAGUIBehavior` options, `this.agui.*` namespace methods, state getters, and UIMessage format for rendering.

## ui-miniprogram

# @cloudbase/agent-ui-miniprogram

WeChat Mini Program SDK for AG-UI protocol. Headless behavior mixin pattern.

## Installation

```bash
npm install @cloudbase/agent-ui-miniprogram@latest
```

## Basic Usage

```typescript
import { createAGUIBehavior, CloudbaseTransport } from "@cloudbase/agent-ui-miniprogram";

const transport = new CloudbaseTransport({ botId: "your-bot-id" });

Component({
  behaviors: [createAGUIBehavior({ transport })],
  methods: {
    onSend() {
      this.agui.sendMessage(this.data.inputText);
    }
  }
});
```

## createAGUIBehavior Options

```typescript
createAGUIBehavior({
  transport,              // Transport instance (CloudbaseTransport)
  messages: [],           // Initial message history
  tools: [{               // Client tools the agent can invoke
    name: "get_weather",
    description: "Get weather",
    parameters: { type: "object", properties: { city: { type: "string" } } },
    handler: async ({ args }) => ({ temp: 72 })
  }],
  threadId: "custom-id",  // Custom thread ID (auto-generated if omitted)
  contexts: [],           // Additional context objects
  onRawEvent: (event) => {} // Callback for each raw AG-UI event
})
```

## Namespace Methods (this.agui.*)

| Method | Description |
|--------|-------------|
| `init({ transport, threadId? })` | Initialize transport at runtime |
| `sendMessage(text \| Message[])` | Send message and run agent |
| `appendMessage(message)` | Add message without running agent |
| `setMessages(messages)` | Replace entire message history |
| `reset()` | Reset to initial state |
| `setThreadId(id)` | Change thread ID |
| `addTool(tool)` | Register a client tool |
| `removeTool(name)` | Remove tool by name |
| `updateTool(name, updates)` | Update tool properties |
| `clearTools()` | Remove all tools |

## State Getters (this.agui.* or this.data.agui.*)

| Property | Type | Description |
|----------|------|-------------|
| `messages` | `Message[]` | Raw message history |
| `uiMessages` | `UIMessage[]` | Messages formatted for UI rendering |
| `isRunning` | `boolean` | Agent is processing |
| `runId` | `string \| null` | Current run ID |
| `activeToolCalls` | `ToolCallState[]` | Tool calls in progress |
| `error` | `AGUIClientError \| null` | Last error |
| `threadId` | `string` | Current thread ID |
| `tools` | `Tool[]` | Registered tools (definitions only) |
| `contexts` | `Context[]` | Context objects |
| `config` | `CreateAGUIBehaviorOptions` | Current configuration |

## CloudbaseTransport

Production transport for WeChat Cloud Development:

```typescript
import { CloudbaseTransport } from "@cloudbase/agent-ui-miniprogram";

const transport = new CloudbaseTransport({
  botId: "bot-xxxxxx"  // From Cloud Development console
});
```

Requires `wx.cloud.extend.AI.bot.sendMessage` API.

## Imperative Pattern

Use `aguiBehavior` (no static config) for runtime-only initialization:

```typescript
import { aguiBehavior, CloudbaseTransport } from "@cloudbase/agent-ui-miniprogram";

Component({
  behaviors: [aguiBehavior],
  lifetimes: {
    attached() {
      this.agui.init({
        transport: new CloudbaseTransport({ botId: "my-bot" })
      });
    }
  }
});
```

## Client Tool Example

```typescript
Component({
  behaviors: [createAGUIBehavior({ transport })],
  lifetimes: {
    attached() {
      this.agui.addTool({
        name: "show_toast",
        description: "Show a toast message",
        parameters: {
          type: "object",

## access

# Access — CloudBase CLI

Four modules for configuring external access to CloudBase environments:

| Module | Commands | Purpose |
|--------|----------|---------|
| **CORS / safe domains** | `tcb cors list/add/rm` — or `tcb env domain list/create/delete` | Security domains for cross-origin access |
| **Domains** | `tcb domains ls/add/edit/rm` + `tcb domains cache purge/task` | Bind/unbind custom domains with TLS, purge CDN cache |
| **Routes** | `tcb routes list/add/edit/delete` | Map request paths to backend services (**environment level only**) |
| **Platform pool** | the `--platform-id` flag on `env` / `domains` only | Target a platform resource pool instead of one environment |

> ⚠️ Routes require the domain to exist first — use the system default domain or bind one via `tcb domains add` before creating routes.

> ⚠️ `tcb cors` and `tcb env domain` are the **same capability** (both manage 环境安全域名) but split
> multiple values differently: `tcb cors add "a.com,b.com"` uses a **comma**, while
> `tcb env domain create "a.com/b.com"` uses a **slash**. Pick one pair and stay consistent.

> ⚠️ **Platform-pool mode: `tcb routes` does NOT support it.** Only `tcb env …` and `tcb domains …`
> accept `--platform-id <platformId>`.
>
> `tcb routes list --platform-id pf-xxx` fails with `error: unknown option '--platform-id'`. This is a
> **deliberate CLI contract** (pinned by a test in the CLI repo that asserts routes commands contain no
> `--platform-id`), not an oversight.
>
> Platform-level domains **and their routes** are managed through `tcb domains * --platform-id`, which
> covers the route APIs too — e.g. `tcb domains ls --platform-id pf-xxx`. `tcb routes` stays
> environment-scoped: `tcb routes delete <domain> -p <path>` even points you to `tcb domains rm` when
> you need domain-level operations.
>
> In platform mode pass `--platform-id` **instead of** `-e/--env-id` — the two are mutually exclusive
> (`-e <envId> 与 --platform-id <platformId> 不能同时使用`). Confirm with the user which one they mean.

---

## When to Use

- Configuring CORS security domains for cross-origin access
- Binding, editing, or unbinding custom domains (incl. TLS) to a CloudBase environment
- Purging the CDN cache of a bound domain
- Creating, editing, or deleting routing rules (path -> service mapping)
- Setting up a complete domain + routing + CORS workflow
- Doing the **domain** part against a platform resource pool (`tcb domains … --platform-id`) — for
  platform routes, use the same `tcb domains` commands, never `tcb routes`

## Do NOT use for

- Storage ACL permissions (use `references/storage.md`)
- Resource authorization policies / roles / users (use `references/permission.md`)
- Static file hosting deployment (use `references/hosting.md`)
- Web app deployment (use `references/app.md`)
- Environment API keys / login policy / env lifecycle (use `references/env.md`)

---

## Workflow 1: CORS Configuration

### Step 1 — List current security domains

```bash
tcb cors list -e <envId> --json
```

### Step 2 — Add domains

```bash
# Single domain
tcb cors add api.example.com -e <envId> --yes

# Multiple domains (comma-separated, no protocol prefix)
tcb cors add localhost:3000,dev.example.com,app.example.com -e <envId> --yes
```

> ⚠️ CORS domains do NOT auto-include subdomains — each subdomain must be added separately.

### Step 3 — Remove domains

```bash
tcb cors rm old.example.com -e <envId> --yes
```

### Step 4 — Verify

```bash
tcb cors list -e <envId> --json
```

**Parameters:** `<domain>` (no `https://` prefix, comma-separated for multiple), `-e/--env-id`, `--yes`, `--json`, `--dry-run`

> ⚠️ Use the kebab-case `--env-id`. `--envId` still resolves as a hidden deprecated alias but prints a
> deprecation warning on every call.

---

## Workflow 2: Custom Domain Binding

### Step 1 — Check existing domains

```bash
tcb domains ls -e <envId> --json
```

### Step 2 — Bind domain (SSL cert required)

```bash
# Direct connection (default)
tcb domains add api.example.com --certid <certId> -e <envId> --yes

# CDN-accelerated
tcb domains add cdn.example.com --certid <certId> --access-type CDN -e <envId> --yes

# Custom CNAME
tcb domains add custom.example.com --certid <certId> --access-type CUSTOM --custom-cname <cname> -e <envId> --yes
```

**Access types:** `DIRECT` (default, request goes straight to CloudBase), `CDN` (CDN-accelerated), `CUSTOM` (custom CNAME target)

### Step 3 — Configure DNS

After binding, set a CNAME record pointing your domain to the CloudBase endpoint returned in the response.


## agent

# Agent — CloudBase CLI

`tcb agent` manages CloudBase **Agents** — function-based (SCF) agents that are created, updated and
deleted together with their underlying cloud resources.

## When to Use

- Creating an Agent from a local code directory (pack + upload in one step)
- Listing / inspecting existing Agents and their underlying resource readiness
- Updating an Agent's code, runtime, timeout, memory or environment variables
- Deleting an Agent (and its underlying function / CloudRun resources)

## Do NOT use for

- Plain cloud functions → `functions.md`
- CloudRun container services → `cloudrun.md`
- Web app hosting → `app.md` / `hosting.md`
- The `cloudbase-agent` SDK (writing agent code) → `../cloudbase-agent/SKILL.md`

---

## Commands

```bash
tcb agent list --env-id <envId>
tcb agent list --limit 20 --offset 0 --env-id <envId>

tcb agent detail <agentId> --env-id <envId>
tcb agent detail <agentId> --env-id <envId> --json   # underlying resource readiness + config

tcb agent create --env-id <envId> \
  --name my-agent \
  --code ./my-agent \
  --runtime Nodejs20.19 \
  --timeout 7200 \
  --memory-size 512 \
  --install-dep \
  --ignore ".git,node_modules,.DS_Store" \
  --env "KEY1=VALUE1,KEY2=VALUE2"

tcb agent update <agentId> --env-id <envId> --code ./my-agent --timeout 3600

tcb agent delete <agentId> --env-id <envId> --dry-run   # preview
tcb agent delete <agentId> --env-id <envId> --yes
```

### `agent create` flags

| Flag | Meaning | Default |
|------|---------|---------|
| `--name <name>` | Agent name (**required**) | — |
| `--agent-id <agentId>` | Explicit id | auto-generated |
| `--code [path]` | Local code directory, packed and uploaded | current directory |
| `--runtime <runtime>` | e.g. `Nodejs20.19` | — |
| `--timeout <seconds>` | Execution timeout | `7200` (agents need long-lived connections) |
| `--memory-size <MB>` | `64`, or `128`-`3072` | `128` |
| `--install-dep` | Install dependencies in the cloud (needed when the upload excludes them) | off |
| `--ignore <patterns>` | Comma-separated excludes | `.git,node_modules,.DS_Store` |
| `--env <envVars>` | Environment variables, `KEY1=VALUE1,KEY2=VALUE2` | — |

### `agent update` flags

Same as create **except** `--name` and `--agent-id` (the id is positional): `--code`, `--runtime`,
`--timeout`, `--memory-size`, `--install-dep`, `--ignore`, `--env`.

> ⚠️ `agent delete` **also removes the underlying function / CloudRun resources** and is not
> recoverable. Always run `--dry-run` first, show the preview, and wait for explicit confirmation.

> ⚠️ `--env` is a comma-separated `KEY=VALUE` list on one line. Values containing commas need
> different handling — verify the parsed result with `tcb agent detail <agentId>` afterwards.

> ⚠️ Prefer injecting secrets through the environment/CI secret store rather than typing them into the
> command line (shell history + process list). Never commit them.

---

## Command Quick Reference

```bash
tcb agent list [--limit N] [--offset N]   # List agents
tcb agent detail <agentId>                # Detail + underlying resource status
tcb agent create --name <n> [...]         # Create (packs --code and uploads)
tcb agent update <agentId> [...]          # Update code / config
tcb agent delete <agentId> [--dry-run]    # Delete agent + underlying resources
```

**Global flags:** `-e/--env-id <envId>`, `--json`, `--yes`.

---

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `--name is required` | `agent create` without `--name` | `agent update` takes the id positionally; `create` needs `--name` |
| Agent created but code missing | `--code` pointed at the wrong directory | Re-run `agent update <agentId> --code <dir>` |
| `MODULE_NOT_FOUND` at runtime | Dependencies not uploaded and not installed | Add `--install-dep` (or bundle `node_modules`) |
| Timeout too short | Agents hold long connections | Raise `--timeout` (default is already 7200 s) |
| Delete removed more than expected | `agent delete` also cleans the underlying function | Confirm with the user; use `--dry-run` first |

---

## Self-Check

- [ ] Confirmed the envId with the user?
- [ ] For `create`: passed `--name` and the correct `--code` directory?
- [ ] `--ignore` excludes `.git` / `node_modules` unless intentionally uploadable?
- [ ] Timeout large enough for the agent's connection pattern?
- [ ] For `delete`: ran `--dry-run` and got explicit approval?
- [ ] Secrets injected via env vars, not hardcoded in the command?

## app

# App — CloudBase CLI

> ⚠️ **Agent default: prefer MCP `manageApps` / `manageHosting`, or CLI `hosting.md` (local build + `tcb hosting deploy`).**
> `tcb deploy` in this file is an experimental all-in-one shorthand — use only when the user explicitly asks for it.

Deploy web applications with automatic framework detection, cloud build, and CDN hosting.
App = framework build + deploy; for pre-built static files only, use `hosting` instead.

## When to Use

- User **explicitly** asks for `tcb deploy` / zero-config cloud-build web deploy
- Managing web app versions, build status, or redeployment after that path was already chosen
- Deploying monorepo sub-projects with that experimental flow

## Do NOT use for

- Default agent fallback when MCP is missing — use `hosting` (or MCP when available)
- Pre-built static files without build step — use `hosting`
- Cloud functions — use `functions`
- Containerized long-running services — use `cloudrun`
- Database operations — use `mysql` or `nosql`

---

## Workflow 1: First Deploy (Zero Config)

```bash
# 1. Confirm target environment
tcb env list

# 2. Deploy from project root (auto-detects framework)
tcb deploy --env-id <envId>

# Or specify a service name
tcb deploy my-app --env-id <envId>
```

CLI auto-completes: detect framework -> infer build command + output dir -> upload to COS -> cloud build (~3-5 min) -> output access URL -> save config to `cloudbaserc.json`.

### Supported Frameworks

| Framework | Detection signal | Default build cmd | Default output dir |
|-----------|-----------------|-------------------|-------------------|
| React | `react-scripts` in package.json | `npm run build` | `build` |
| Vue | `@vue/cli-service` / `vite` | `npm run build` | `dist` |
| Vite | `vite` in devDependencies | `npm run build` | `dist` |
| Next.js | `next` in dependencies | `npm run build` | `.next` |
| Nuxt | `nuxt` in dependencies | `npm run build` | `.output` |
| Angular | `@angular/core` | `ng build` | `dist/<name>` |
| Static | No build tool detected | _(none)_ | `.` |

> ⚠️ If framework is not detected (`Cannot auto-detect project framework`), specify explicitly with `--framework react --build-command "npm run build" --output-dir dist`.

---

## Workflow 1b: Local build for declarative hosting (`tcb app build`)

For **declarative hosting** projects (a `hosting[]` array in `cloudbaserc.json`), the CLI no longer
builds locally during deploy. The two steps are now separate:

```bash
tcb app build        # 1. Run the configured build commands (local only)
tcb deploy           # 2. Upload the built artifacts
```

`tcb app build`:
- reads `cloudbaserc.json` and runs each hosting item's `buildCommand`
- **does NOT install dependencies** — run your package manager first
- **does NOT deploy** anything
- is a **pure local command**: no envId, no auth required

> ⚠️ If you run `tcb deploy` while the build output directory is missing or empty, it fails and tells you
> to run `tcb app build` first.
>
> ⚠️ If the output directory exists but is **stale**, `tcb deploy` uploads it as-is and only warns. It
> cannot tell whether the sources changed — always `tcb app build` before `tcb deploy` after editing
> code, or you will ship the previous build.

---

## Workflow 2: Redeployment

```bash
# Redeploy (reads saved config from cloudbaserc.json)
tcb deploy --env-id <envId>

# Force overwrite — skip confirmation prompt
tcb deploy my-app --env-id <envId> --force
```

> ⚠️ Overwrite creates a new version (e.g. `my-app-002 -> my-app-003`). Previous versions are preserved, never deleted.

### Monorepo Sub-project

```bash
# Option A: CLI flag (relative path only)
tcb deploy my-app --env-id <envId> --cwd ./packages/frontend

# Option B: cloudbaserc.json
# { "app": { "root": "packages/frontend" } }
```

> ⚠️ `--cwd` must be a relative path, not absolute. `root` in config is relative to `cloudbaserc.json`, not CWD.

---

## Workflow 3: Version Management

```bash
# List all versions
tcb app versions list my-app --env-id <envId>

# View latest version details
tcb app versions detail my-app --env-id <envId>

# View a specific version
tcb app versions detail my-app --version-name my-app-001 --env-id <envId>

# Extract fail reason (JSON mode)
tcb app versions detail my-app --env-id <envId> --json | jq '.data.failReason'

## cloudrun

# CloudRun — CloudBase CLI

Deploy and manage containerized/server-rendered applications with traffic shifting and canary releases.
CloudRun = persistent containers; for event-triggered serverless, use `functions` instead.

## When to Use

- Deploying containerized or server-rendered applications to CloudBase
- Managing CloudRun services (init, deploy, list, delete)
- Setting up canary deployment or traffic shifting between versions
- Running function-based CloudRun services locally for testing
- Need persistent long-running services (web APIs, backends)

## Do NOT use for

- Serverless event-triggered functions — use `functions`
- Static file hosting — use `hosting`
- Web app deployment with framework auto-detection — use `app`
- Database operations — use `mysql` or `nosql`

---

## Workflow 1: Init and Deploy

### Step 1: Initialize project

```bash
# Initialize from template
tcb cloudrun init --service-name <serviceName> --template <templateName>

# Initialize in a specific directory
tcb cloudrun init --service-name <serviceName> --template <templateName> --target-path <path>
```

### Step 2: Deploy

> ⚠️ **Brand-new environment first-time deploy** — confirm CloudRun is initialized in the target env before the first deploy (console `环境 → 云托管 → 开通`, or `CreateCloudRunEnv` via the tcbr service). Deploying to an env with no 大租户 record silently lands in the legacy 小租户 path and creates wrong small-tenant services/versions.

```bash
# Basic deploy
tcb cloudrun deploy --service-name <serviceName> --env-id <envId>

# Container-based: specify port
tcb cloudrun deploy --service-name <serviceName> --port 8080 --env-id <envId>

# With online dependency installation
tcb cloudrun deploy --service-name <serviceName> --install-dependency true --env-id <envId>

# Deploy with canary mode (new version starts at 0% traffic)
tcb cloudrun deploy --service-name <serviceName> --traffic --env-id <envId>

# CI/CD: skip confirmation
tcb cloudrun deploy --service-name <serviceName> --force --env-id <envId>
```

> ⚠️ Without `--traffic` flag, the new version replaces the old one with 100% traffic immediately. Use `--traffic` when you want gradual rollout.

> ⚠️ `--force` skips the confirmation prompt but does NOT preview changes — it just skips the prompt.

### Step 3: Verify

```bash
# List all services
tcb cloudrun list --env-id <envId>

# Filter by name or type (the flag is --server-type, values: function | container)
tcb cloudrun list --service-name <serviceName> --env-id <envId>
tcb cloudrun list --server-type container --env-id <envId>
```

### Container-based Deploy Example (Node.js API)

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 80
CMD ["node", "server.js"]
```

```bash
# Build and push image
docker build -t ccr.ccs.tencentyun.com/my-repo/api:v1.0.0 .
docker push ccr.ccs.tencentyun.com/my-repo/api:v1.0.0

# Deploy the container image (created on first run, updated afterwards)
tcb cloudrun deploy \
  --service-name api \
  --image-url ccr.ccs.tencentyun.com/my-repo/api:v1.0.0 \
  --port 80 \
  --env-id <envId>
```

> ⚠️ Container deploys go through **`tcb cloudrun deploy --image-url`** — that is the only
> image-deploy flag in this CLI. `tcb app deploy` is the **web-app** path (cloud build +
> hosting): it takes a *positional* service name and has no `--service-name` / `--image` /
> `--remark`. `--image` and `--remark` exist only on the deprecated `tcb run service:deploy`.

---

## Workflow 2: Traffic Shifting (Canary)

Traffic shifting enables canary releases, blue/green deployments, and instant rollbacks.

> ⚠️ The only command is **`tcb cloudrun traffic [action]`**, with options `-s/--service-name`,
> `--stable <0-100>` and `--canary <0-100>`. There is **no `traffic get`**, **no `traffic set`**
> subcommand, and **no `--version-weights`** flag.
> - no action + `--stable` / `--canary` → set the gray ratio
> - `traffic promote` → complete the gray release
> - `traffic rollback` → revert to the previous stable version

### View current traffic

```bash
# Per-version status (shows each version and its current traffic weight)
tcb cloudrun version detail --service-name <serviceName> --env-id <envId>

# Full service detail (traffic config is in the JSON payload)

## config

# Config & Project — CloudBase CLI

`tcb config` is **two different things** — know which half you are in:

| Half | Subcommands | Operates on |
|------|-------------|-------------|
| **CLI local settings** | `config get / set / list / delete` | The CLI's own local store (site, language) |
| **Project config sync** | `config init / pull / diff / update` | `cloudbaserc.json` ↔ the cloud |

Plus the project / tooling bootstrap commands: `init`, `new`, `pull`, `open`, `validate`,
`self-update`, `rollback`, and the **`tcb ai` setup wizard**.

## When to Use

- Switching the CLI between the **domestic site and the international site** persistently
- Changing the CLI language
- Generating / pulling / pushing `cloudbaserc.json` instead of hand-writing it
- Diffing local config against what is actually deployed
- Bootstrapping a new project from a template
- Validating that a project matches CloudBase application standards
- Upgrading the CLI itself

## Do NOT use for

- `cloudbaserc.json` field-by-field reference → `core.md`
- Function config fields (timeout / memory / runtime) → `functions.md`
- Data model definitions and DB migrations → `schema.md`
- Integration instance lifecycle → `integration.md`

---

## Workflow 1: CLI local settings (`config get/set/list/delete`)

This half touches the CLI's **local store only** — no envId, no auth needed.

```bash
tcb config list
tcb config list --json

tcb config get isIntl
tcb config set isIntl true          # switch to the international site
tcb config set lang en
tcb config delete isIntl            # fall back to env var / default
```

Only two keys exist:

| Key | Type | Meaning | Env var override |
|-----|------|---------|------------------|
| `isIntl` | boolean | Whether to use the international site | `TCB_IS_INTL` |
| `lang` | string | Language: `zh` (中文) / `en` (English) | `TCB_LANG` |

Resolution order for `get`: local store → env var → default.

> ⚠️ **Site confusion is the #1 cause of "invalid token" / "env not found".** `isIntl` decides which
> site the CLI talks to. A credential issued on one site does not work on the other.
> - One-off: `tcb login --intl true` / `--intl false` (takes effect immediately for that process)
> - Persistent: `tcb config set isIntl <true|false>`
>
> Pick one method, and make sure it matches the site the target envId actually lives on.

---

## Workflow 2: `cloudbaserc.json` sync (`config init/pull/diff/update`)

Supported modules: **`fn`** (云函数) and **`integration`** (集成)。

### Initialize a template

```bash
tcb config init                              # common all-in-one template + directory skeleton
tcb config init --no-directory               # config file only, no skeleton
tcb config init fn myFunc                    # function module config
tcb config init integration key-xxx
tcb config init integration key-xxx --type weixinpaydc
tcb config init -o ./config/cloudbaserc.json # custom output path
```

### Pull cloud state into the config file

```bash
tcb config pull fn                           # pull function config
tcb config pull fn myFunc workFn             # only the listed functions (comma-separated also works)
tcb config pull fn --all
tcb config pull integration key-xxx
tcb config pull fn --stdout                  # print instead of writing the file
tcb config pull fn -o cloudbaserc.json
tcb config pull fn --dir ./functions         # infer config when the function does not exist in the cloud
tcb config pull fn --code-secret <secret>    # for code-encrypted functions
```

### Diff local vs cloud

```bash
tcb config diff fn                           # only the `fn` module is supported
tcb config diff fn myFunc
tcb config diff fn --all
```

> ⚠️ `config diff` currently supports **only `fn`**. `pull` / `update` / `init` also accept
> `integration`. Do not assume `diff integration` works.

### Push the config file to the cloud

```bash
tcb config update fn myFunc                  # push one function's config (no code upload)
tcb config update fn myFunc --timeout 30 --memory 512
tcb config update fn --all
tcb config update integration key-xxx
```

`config update fn` per-field overrides: `--timeout <seconds>`, `--memory <MB>`, `--runtime <runtime>`,
`--handler <handler>`, `--vpc <vpcId/subnetId>`.

> ⚠️ `tcb fn config update <name>` is deprecated — this is its replacement. See `functions.md`.

> ⚠️ **Verify before pushing.** `config update` overwrites the cloud-side config. Run
> `tcb config diff fn` first and show the user what will change.

---

## core

# Core — CloudBase CLI

> Core foundation for all CloudBase CLI operations (云开发 CLI 核心基础).
> Covers authentication (incl. site selection), picking the working environment, documentation
> queries, `cloudbaserc.json`, and error diagnosis.

## When to Use

- **Any** CloudBase CLI operation (always start here)
- Authenticating with `tcb login` or switching environments with `tcb env use`
- Choosing between the domestic site and the international site
- Querying CLI docs with `tcb docs` or checking command help
- Diagnosing CLI errors via exit codes
- **First-session fallback:** CloudBase MCP tools are not in this conversation yet (not installed, or installed but session not restarted) — use `tcb login` + the matching domain command now while MCP is configured for next time (do **not** use `tcb deploy`; see guideline `tooling-fallback.md` if npm/npx is missing)

## Do NOT use for

- CloudBase SDK development (use matching SDK skills)
- CloudBase MCP server operations when MCP tools are already available (prefer MCP unless the user asked for CLI)
- Tencent Cloud console-only operations (this reference is CLI-only)

## Route elsewhere

| Task | Read |
|------|------|
| Create / modify / renew / destroy an environment, API Keys, login policy, safe domains | `env.md` |
| `tcb config` (CLI settings, `cloudbaserc.json` sync), `tcb init` / `pull` / `validate` / `self-update` | `config.md` |
| Log search | `logs.md` |
| Metric monitoring | `monitor.md` |
| Data model / PostgreSQL migrations | `schema.md` |
| Sandbox / Agent / Integration instances | `sandbox.md` / `agent.md` / `integration.md` |

## First-session + MCP coexistence

1. If MCP is missing: install/configure it (plugin / `mcp.json` / mcporter) so the **next** session gets tools.
2. Immediately continue with CLI in **this** session: `tcb login` → confirm envId → `tcb env use <envId>` → domain command from the matching reference (`functions` / `hosting` / `cloudrun` / …). Do **not** use `tcb deploy`.
3. Tell the user briefly that after restart/reload, MCP becomes the preferred path.
4. Do not hard-code SecretId/SecretKey into MCP config as the default path.
5. If `npm`/`npx`/`node` are missing, stop and follow guideline `tooling-fallback.md` (“No npm/npx”) before retrying installs.

---

## Workflow 1: Authentication

### Quick Commands

```bash
tcb login                      # Interactive login (device code, recommended; has Tencent Cloud account)
tcb login --flow web           # Web authorization (same-machine only)
tcb login --cloudbase-api-key <cloudbaseApiKey> -e <envId>  # Env API Key (no Tencent Cloud account)
tcb login --apiKeyId <Id> --apiKey <Key>            # CI / Tencent Cloud SecretId+SecretKey
tcb login --apiKeyId <Id> --apiKey <Key> --token <T> # Temp token (CI, more secure)
tcb login --intl true          # Use the INTERNATIONAL site for this process only
tcb login --intl false         # Use the DOMESTIC site for this process only
tcb login -k                   # Interactive secret-key input mode (permanent key)
tcb login --endpoint <url>     # Custom device-authorization endpoint
tcb logout                     # Clear account-level credentials (account-login mode only)
```

### Site selection (国内站 / 国际站) — read this before debugging "invalid token"

`tcb` talks to **one** site at a time. A credential issued on one site does not work on the other, and
the failure looks like an auth problem rather than a site problem.

| Scope | How |
|-------|-----|
| This process only | `tcb login --intl true` / `tcb login --intl false` (persisted for the login, effective immediately) |
| Persistent | `tcb config set isIntl true` / `false` (see `config.md`) |
| CI / one-off | `TCB_IS_INTL=true` environment variable |

> ⚠️ Pick **one** mechanism per session and keep it consistent. Mixing a persistent `isIntl false` with
> a one-off `--intl true` produces credentials the other half of the session cannot use.

> ⚠️ `--cloudbase-api-key` is a CloudBase **environment** API Key; `--apiKeyId` / `--apiKey` are Tencent
> Cloud **account** credentials. Do not confuse them (see the table above).

> ⚠️ `tcb logout` clears **account-level** logins only. In **environment API Key** mode the CLI refuses it (`LOGOUT_NOT_ALLOWED`) — there is no account session to clear; remove the credential file instead (see *Where credentials are read from* below).

### Choosing a login method

| Situation | Method |
|-----------|--------|
| User has a Tencent Cloud account | Device code (`tcb login`) — default / recommended |
| Same machine + local browser OK | Web flow (`tcb login --flow web`) |
| No Tencent Cloud account; only an environment API Key | `--cloudbase-api-key` **with** `-e` / `--env-id` |
| CI / automation with SecretId + SecretKey | `--apiKeyId` + `--apiKey` (+ optional `--token`) |

> Do **not** confuse `--cloudbase-api-key` (CloudBase **environment** API Key) with `--apiKeyId` / `--apiKey` (Tencent Cloud **account** credentials).

### Login Methods

**1. Device Code Authorization (default, recommended)**

Use when the user **has a Tencent Cloud account**. Typical IDE path (e.g. CodeBuddy): start chatting and complete Device login when prompted — no pre-login required.

```bash
tcb login
# Prints a device code + verification URL.
# Open URL in any browser (can be a different machine), enter code to authorize.
```

> Works in remote SSH, headless servers, WSL. Browser and CLI need **not** be on the same machine.

**2. Web Authorization (same-machine only)**

```bash
tcb login --flow web
# Opens browser on local machine; CLI receives token via local callback.
```

> ⚠️ Requires browser and CLI on the same machine. Falls back to key-based login if browser cannot open.

**3. CloudBase Environment API Key (no Tencent Cloud account)**

Use when the user **does not** have a Tencent Cloud account and only holds an environment-level API Key (e.g. issued by a partner/admin). Must specify the target envId via global `-e` / `--env-id`.

```bash
# Install CLI if needed
npm i -g @cloudbase/cli


## env

# Environment — CloudBase CLI

Full lifecycle for CloudBase environments (环境): create, inspect, change package, renew, destroy —
plus the per-environment sub-resources the CLI exposes under `tcb env`.

> The login → `tcb env use` → confirm envId basics live in `core.md`. That is the flow you run
> **before every task**. This reference is for everything that **changes** an environment.

## When to Use

- Creating a new environment (including PG-mode and platform-pool environments)
- Changing an environment's package (套餐变更) or renewing it
- Inspecting environment detail / resource configuration / usage
- Managing environment API Keys (`tcb env apikey`)
- Configuring login methods and MFA (`tcb env login`)
- Managing environment safe domains (`tcb env domain`) — this is the **same capability** as `tcb cors`

## Do NOT use for

- Picking / switching the working environment → `core.md`
- Resource-level operations inside an env (functions, storage, database) → their own references
- Custom domain binding, routing rules, CDN cache → `access.md`
- Migrating data out of a database → `mysql.md` / `nosql.md`

---

## `--platform-id`: environment vs platform pool

Several `tcb env` subcommands switch behaviour when `--platform-id <platformId>` is passed:
they then target the **platform resource pool** instead of a single environment.

| Command | Without `--platform-id` | With `--platform-id` |
|---------|------------------------|----------------------|
| `env create` | Create an environment (needs `--package` etc.) | Create an environment under the pool — **mutually exclusive** with `--package/--region/--duration/--auto-renew/--postgresql` |
| `env modify` | Change the environment package | Change **platform environment status** (`--status` / `--storage-status` / `--flexdb-status`) — mutually exclusive with `--package` |
| `env delete` | Destroy the environment | Destroy a platform-pool environment (the pool and its other environments are untouched) |
| `env usage` | Environment usage details | Pool usage by resource type, incl. credit consumption |

> ⚠️ Never mix the two modes: passing `--platform-id` together with `--package` is rejected.

---

## Workflow 1: Inspect

```bash
tcb env list --env-id <envId>            # env list supports pagination
tcb env list --limit 20 --offset 0
tcb env detail --env-id <envId>          # resource configuration detail
tcb env detail --env-id <envId> --json

# Resource metric usage (module-filtered)
tcb env info --env-id <envId>
tcb env info --env-id <envId> --type FLEXDB,SCF,COS
tcb env info --env-id <envId> --type SCF --start 2026-10-01 --end 2026-10-16
```

`env info --type` modules: `FLEXDB` (文档型数据库), `TDSQL` (MySQL), `SCF` (云函数), `EKS` (云托管),
`COS` (云存储), `AI`, `HOSTING` (静态托管), `Auth` (身份认证), `APIInvocation`, `HTTPInvocation`,
`VM` (云主机), `Workflow`, `Other`.

> ⚠️ `tcb env list` may return incomplete results under sub-account permissions. Prefer asking the
> user for the envId instead of auto-discovering it (see `core.md`).

### Usage / billing

```bash
# Environment mode — resource usage / billing summary
tcb env usage --env-id <envId>

# Platform pool mode — usage by resource type, with resource-point consumption
tcb env usage --platform-id <platformId> \
  --start-date 2026-10-01 --end-date 2026-10-16 \
  --resource-types Database,Function,Storage --need-details
```

`env usage` flags: `-e/--env-id`, `--platform-id`, `--start-date <YYYY-MM-DD>`, `--end-date <YYYY-MM-DD>`,
`--resource-types <types>`, `--need-details`. The last four are **platform-mode only**.

`--resource-types` values: `Database | Function | Storage | HOSTING | Log | Gateway | Cloudrun | Token | EO` (comma-separated, default = all).

> ⚠️ `--type <modules>` is **NOT** a flag of `env usage` — it belongs to `tcb env info` (per-module metric
> detail, using module ids like `FLEXDB,SCF,COS`). Passing `--type` to `env usage` fails as an unknown option.
> The two commands answer different questions: `env info` = resource metrics per module, `env usage` = billing / consumption.

---

## Workflow 2: Create

```bash
# Interactive: omit --package to pick from the printed package list
tcb env create

# Non-interactive / CI
tcb env create --alias staging --package baas_pf_standard --region ap-shanghai --yes
```

`--package` values: `baas_personal` (个人版) | `baas_pf_standard` (标准版) | `baas_pf_enterprise` (企业版)

Other flags:

| Flag | Meaning |
|------|---------|
| `--alias <alias>` | Environment alias |
| `-r, --region <region>` | Region, default `ap-shanghai` |
| `--duration <duration>` | Purchase duration in months: `1-12`, `24` (default `1`) |
| `--auto-renew` | Enable auto-renewal (default off) |
| `--postgresql` | Create the environment in **PG (PostgreSQL) mode** |
| `--platform-id <platformId>` | Create under a platform resource pool |

### PG mode

```bash
tcb env create --alias pg-demo --package baas_personal --postgresql --yes
```

> ⚠️ PG mode is a different data plane, not "one more database". Auth, storage, permissions and
> migrations all change (RLS, `pgstore`, `cloudbase/migrations/`). After creating a PG environment,
> switch to the `postgresql-development-cloudbase` skill — do not drive a PG environment through the
> NoSQL / MySQL references in this skill. See also `../postgresql-development-cloudbase/SKILL.md`.


## functions

# Functions — CloudBase CLI

Deploy, update, debug, and manage cloud functions (云函数) via `tcb fn` commands.
Covers both Event Functions (普通云函数) and HTTP Functions (HTTP 云函数).

## When to Use

- Deploy or update cloud functions from terminal / CI pipeline
- Query function logs, diagnose runtime errors
- Manage triggers (timer/定时触发器), layers, versions
- Inject secrets / environment variables
- Batch deploy via `cloudbaserc.json`

## Do NOT use for

- Calling functions from client code (web/miniprogram) → use `cloud-functions` skill
- CloudRun container deployments → use `references/cloudrun.md`
- SDK-based in-app function invocation → use `@cloudbase/js-sdk`
- Console UI operations

## Command Quick Reference

| Task | Command |
|------|---------|
| List all functions (列出函数) | `tcb fn list` |
| Function detail (查看详情) | `tcb fn detail <name>` |
| Deploy all functions | `tcb fn deploy --all` |
| Deploy single Event Function | `tcb fn deploy <name>` |
| Deploy HTTP Function | `tcb fn deploy <name> --httpFn` |
| Deploy HTTP + WebSocket | `tcb fn deploy <name> --httpFn --ws` |
| Deploy multiple | `tcb fn deploy fn1 fn2` |
| Update code only (仅更新代码) | `tcb fn code update <name>` |
| Download deployed code | `tcb fn code download <name> [dest]` |
| Update config only (仅更新配置) | `tcb config update fn [name]` |
| Invoke remotely (调用函数) | `tcb fn invoke <name>` |
| Invoke with params | `tcb fn invoke <name> --params '{"key":"val"}'` |
| Run locally (本地调试) | `tcb fn run <name>` |
| View logs (查看日志) | `tcb logs search --query 'function_name:"<name>"'` |
| View log by RequestId | `tcb logs search --query 'request_id:("<requestId>")'` |
| Create trigger (创建触发器) | `tcb fn trigger create <functionName> --trigger-name <t> --cron <cron>` |
| List triggers | `tcb fn detail <name>` (triggers are shown in the detail output) |
| Delete trigger | `tcb fn trigger delete <functionName> <triggerName>` |
| List layers (层) | `tcb fn layer list` |
| Publish version (发布版本) | `tcb fn publish-version <name>` |
| List versions (版本列表) | `tcb fn list-function-versions <name>` |
| Copy to another env | `tcb fn copy <name> --env-id <target>` |
| Delete function | `tcb fn delete <name>` |

> Always run `tcb fn <subcommand> --help` first to check current syntax.

> ⚠️ **Renamed / deprecated (命令已改名或废弃，别再用旧写法):**
> - `tcb fn list-version` → **`tcb fn list-function-versions <name>`**
> - `tcb fn config update` → **`tcb config update fn [name]`** (deprecated; the new command additionally supports `--all`, `--timeout`, `--memory`, `--runtime`, `--handler`, `--vpc`)
> - `tcb fn log <name>` → **`tcb logs search`** (deprecated since v3.0.0; CLS query syntax, see Workflow 3)

> 🚫 **Two separate function command families still register and are NOT `tcb fn`.** They are
> **not recommended for use** — always answer with `tcb fn`:
> - **`tcb cloudfunction <deploy|download|run>`** — 云函数服务 (older service API; uses
>   `-s/--serviceName` + `--source`, not `fn`'s `--path` / `--dir` / `[name]` shape)
> - **`tcb cloudrunfunction <deploy|download|run>`** — 云函数 2.0 服务 (函数型云托管 lineage)
>
> Status: **not recommended** (product decision). They carry **no `[已废弃]` marker** and are absent from
> `tcb --help`, so this status is not discoverable from code — but do not propose them for new work, and
> do not offer them as an alternative to `tcb fn`. If the user already has working tooling on them, they
> still run; if they ask which to use, say `tcb fn`.
>
> ⚠️ Do not describe them as "deprecated" either — the CLI marks deprecation explicitly
> (`[已废弃]`, e.g. `tcb framework`, `tcb run`), and these are not marked.

---

## Workflow 1: Deploy Functions

### Deploy All

```bash
# Reads cloudbaserc.json → deploys every function listed
tcb fn deploy --all
# Verify
tcb fn list
```

### Deploy Single Function

```bash
# Event Function（普通云函数）
tcb fn deploy my-function

# HTTP Function（HTTP 云函数）— requires scf_bootstrap
tcb fn deploy my-http-fn --httpFn

# Force overwrite existing
tcb fn deploy my-function --force
```

### Deploy Multiple (Selective)

```bash
tcb fn deploy func-a func-b func-c
```

### Config-Only Update (仅更新配置，不上传代码)

```bash
# Push cloudbaserc.json function config to the cloud (no code upload)
tcb config update fn my-function

# Override individual fields from the CLI
tcb config update fn my-function --timeout 30 --memory 512

# Batch: push every function listed in cloudbaserc.json
tcb config update fn --all
```

> ⚠️ `tcb fn config update <name>` is **deprecated** — use `tcb config update fn`. The old form does not support `--all` / `--timeout` / `--memory` / `--runtime` / `--handler` / `--vpc`.

> ⚠️ **Function type is locked after creation (函数类型创建后不可更改).**
> Cannot change Event → HTTP or vice versa. To switch: delete → recreate.

> ⚠️ **Runtime is locked after creation.** To change (e.g., Nodejs16 → Nodejs18):

## hosting

# Hosting — CloudBase CLI

Deploy pre-built static files (HTML/CSS/JS) to CloudBase CDN hosting.
Hosting = pre-built static files with CDN; for framework build + deploy, use `app` instead.

## When to Use

- Deploying pre-built static files to CloudBase CDN hosting
- Managing hosted files: listing, downloading, or deleting
- Setting up a static website or SPA with CDN acceleration
- Need fine-grained control over individual file deployment

## Do NOT use for

- Web app deployment with framework auto-detection and build — use `app`
- File storage with ACL rules — use `storage`
- Cloud functions — use `functions`
- Containerized services — use `cloudrun`

---

## Workflow 1: Deploy Static Site

```bash
# 1. Confirm target environment
tcb env list

# 2. Build locally first
npm run build

# 3. Deploy built assets (hosting must already be enabled)
tcb hosting deploy ./dist --env-id <envId>

# 4. Verify
tcb hosting list --env-id <envId>
```

> `tcb hosting deploy` only checks the hosting status, it never enables the service. If hosting is not enabled, the command fails and the environment owner must enable it in the CloudBase console first. If the service was just enabled and is still initializing (`init` / `process`), the command waits until it reports `online` (checks every 5 seconds, up to about 6 minutes) and then uploads.

### Deploy Variations

```bash
# Deploy current directory
tcb hosting deploy --env-id <envId>

# Deploy to a sub-path
tcb hosting deploy ./dist /v2 --env-id <envId>

# Deploy a single file
tcb hosting deploy ./index.html --env-id <envId>

# Update only one file (incremental)
tcb hosting deploy ./dist/index.html /index.html --env-id <envId>

# CI/CD: non-interactive with JSON output
tcb hosting deploy ./dist --env-id $ENV_ID --json
```

> ⚠️ Deploy overwrites existing files at the same path. There is no built-in versioning — consider cleaning old files before redeploying.

### Deploying to a Shared Bucket Environment

Platforms that create many environments under one account may keep hosting files for all of them in one shared COS bucket, each environment under its own BasePath. The bucket is chosen by the platform when hosting is enabled and cannot be changed afterwards; the CLI has no flag for it.

- Keep writing `cloudPath` as a plain path (`./dist app`). The CLI adds the BasePath, and the hosting domain resolves it too, so site URLs use the plain path — adding the BasePath to a URL returns 404.

---

## Workflow 2: Safe Deletion

```bash
# 1. Always preview first
tcb hosting delete --dry-run --env-id <envId>

# 2. Delete a specific file
tcb hosting delete path/to/file --env-id <envId> --yes

# 3. Delete a directory
tcb hosting delete path/to/dir --dir --env-id <envId> --yes
```

> ⚠️ Always use `--dry-run` first before bulk deletions.

> ⚠️ CDN cache delay: deleted files may remain accessible for 5-10 minutes. Flush CDN cache in console if needed.

### Clean Redeploy Pattern

```bash
# Preview what will be deleted
tcb hosting delete --dry-run --env-id <envId>

# Delete all hosted files
tcb hosting delete --env-id <envId> --yes

# Deploy fresh build
tcb hosting deploy ./dist --env-id <envId>
```

---

## Workflow 3: List and Download

### List files

```bash
# List all files
tcb hosting list --env-id <envId>

# List a path prefix
tcb hosting list images/ --env-id <envId>

# JSON output
tcb hosting list --env-id <envId> --json
```

`tcb hosting list` flags are only `-e/--env-id`, a positional `[cloudPath]` and `--json`.

> ⚠️ **There is no `--limit` / `--offset` on `hosting list`** — passing them fails as unknown options.
> The command returns the whole listing. (Pagination exists on `fn list` / `app list` with `-l/--limit`
> and `-o/--offset`, and on `cloudrun list` with `--page-size` / `--page-num` — not here.)

## integration

# Integration — CloudBase CLI

`tcb integration` manages **integration instances** (集成) — the environment's connections to external
services (payments, messaging, data sources…). Instance configuration comes from `cloudbaserc.json`,
so creating one is normally a **config + CLI** pair of steps.

> ✅ **`tcb integration` is officially supported — recommend it normally.** It is simply **not listed in
> `tcb --help`** (that list is hand-maintained), which must not be read as "internal" or "experimental".

## When to Use

- Listing the integration types available for an environment
- Listing / inspecting existing integration instances
- Creating integration instances from `cloudbaserc.json`
- Binding an integration instance to a cloud function
- Deleting an integration instance

## Do NOT use for

- Function configuration itself → `functions.md` / `config.md`
- Environment API keys → `env.md` (`tcb env apikey`)
- Storage / database credentials → `storage.md` / `mysql.md`
- Reading the masked secret values → the CLI deliberately does not return them (see below)

---

## Commands

```bash
# 1. Discover what integrations exist
tcb integration types --env-id <envId>
tcb integration types --auth-type-code <code> --env-id <envId>

# 2. Inspect what is already configured
tcb integration list --env-id <envId>
tcb integration list --name <fuzzyName> --env-id <envId>
tcb integration list --auth-type-code <code> --limit 20 --offset 0 --env-id <envId>

tcb integration get <keyId> --env-id <envId>
tcb integration get <keyId> --env-id <envId> --json

# 3. Create from cloudbaserc.json (see below)
tcb integration create --env-id <envId>
tcb integration create <keyId> --env-id <envId>

# 4. Bind to a resource (cloud functions only today)
tcb integration bind-resource <keyId> --function <functionName> --env-id <envId>

# 5. Delete
tcb integration delete <keyId> --env-id <envId>
```

| Flag | Applies to | Meaning |
|------|-----------|---------|
| `--auth-type-code <code>` | `types`, `list` | Exact-match filter on the authorization type code |
| `--name <name>` | `list` | Fuzzy name filter |
| `--limit <n>` / `--offset <n>` | `list` | Pagination |
| `--function <functionName>` | `bind-resource` | Cloud function to bind (the only supported resource type) |

> ⚠️ `tcb integration get` **masks sensitive fields on purpose**. It is the intended way to inspect an
> instance — do not try to read raw secrets through `tcb api` just to "see the value". If the user
> truly needs the secret, they should read it in the console.

---

## The `cloudbaserc.json` step

`integration create` **reads the instance definition from `cloudbaserc.json`** — it has no flags for
service name, credentials or endpoints.

```bash
# 1. Generate / refresh the integration section of the config
tcb config init integration <keyId>
tcb config init integration <keyId> --type <authTypeCode>

# 2. Fill in the parameters in cloudbaserc.json

# 3. Push the config and create the instance
tcb config update integration <keyId> --env-id <envId>
tcb integration create --env-id <envId>

# 4. Verify (sensitive fields will be masked)
tcb integration get <keyId> --env-id <envId>
```

See `config.md` for `tcb config init` / `tcb config update` semantics, and `integration`
in the routing table when the task is really about the config file.

> ⚠️ Do not put real credentials in `cloudbaserc.json` if that file is committed. Check the project's
> `.gitignore` and the user's convention first; the config supports placeholders that resolve at
> deploy time.

---

## Command Quick Reference

```bash
tcb integration types [--auth-type-code <code>]     # Available integration type templates
tcb integration list [--name <n>] [--auth-type-code <c>] [--limit N] [--offset N]
tcb integration get <keyId>                         # Detail (secrets masked)
tcb integration create [keyId]                      # Create from cloudbaserc.json
tcb integration bind-resource <keyId> --function <fn>
tcb integration delete <keyId>
```

**Global flags:** `-e/--env-id <envId>`, `--json`, `--yes`.

---

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `create` does nothing / errors immediately | No matching integration entry in `cloudbaserc.json` | Run `tcb config init integration <keyId>` and fill it in first |
| Secret shows as `***` | Intentional masking | Read it in the console; do not work around it |
| `bind-resource` fails | Resource type is not a cloud function | Only `--function` is supported today |
| Wrong instance targeted | Several share a name prefix | Filter with `--name` first, then act on the exact keyId |
| `delete` on a bound instance | Instance still bound to a function | Unbind / redeploy the function first |

---

## logs

# Logs — CloudBase CLI

`tcb logs search` is the **single** log-search entry point across CloudBase: cloud functions,
CloudRun, database, auth, model, workflow, LLM and gateway access logs — all through CLS query syntax.

## When to Use

- Debugging a cloud function from its runtime logs
- Finding a specific invocation by RequestId
- Reading CloudRun build / runtime logs (see also `cloudrun.md` for `logs build|process`)
- Checking rate-limit / freeze / slow-query events of a database
- Auditing gateway access logs

## Do NOT use for

- CloudRun build / runtime logs by service → `tcb cloudrun logs build|process` (`cloudrun.md`)
- Metrics (QPS, latency, memory curves) → `monitor.md`
- Local function logs → run the function locally (`functions.md`)

---

## Core command

```bash
tcb logs search --env-id <envId>
tcb logs search --env-id <envId> --query 'function_name:"my-func"' --timeRange 6h
tcb logs search --env-id <envId> --json
```

| Flag | Meaning | Default |
|------|---------|---------|
| `-e, --env-id <envId>` | Target environment | interactive pick if omitted |
| `-q, --query <queryString>` | CLS query string | `*` |
| `-t, --timeRange <timeRange>` | `30m` / `1h` / `6h` / `1d`, or absolute `"2026-10-16 14:00:00,2026-10-16 15:00:00"` | `1h` |
| `-l, --limit <limit>` | Result count (max 100) | `20` |
| `--sort <sort>` | `desc` (newest first) / `asc` (oldest first) | `desc` |
| `--context <context>` | Pagination cursor from the previous result | — |
| `--service <service>` | `tcb` (functions / database / LLM …) or `tcbr` (CloudRun) | `tcb` |

> ⚠️ **`--service` is a log *service*, not a service name.** For CloudRun use `--service tcbr` and put
> the service name into the query. `--service my-service` silently queries the wrong backend.

Pagination: pass the returned `Context` back via `--context` to get the next page (the CLI prints the
exact next command).

---

## Cloud function queries

Fields: `function_name`, `request_id`, `status_code`, `src` (`system` = platform logs,
`app` = user-code logs), `log` (message body), `namespace` (envId), `qualifier` (version, `$LATEST`),
`retry_num`.

`status_code`: `200` = success; **`202` = the START/END middle state and must be excluded** when you
are counting real failures.

```bash
# Recent logs of one function
tcb logs search --query 'function_name:"my-func"'

# Full-text AND
tcb logs search --query 'function_name:"my-func" AND "timeout"'

# Only user-code logs
tcb logs search --query 'function_name:"my-func" AND src:"app"'

# Failures only, aggregated per request (note 202 exclusion and retry_num=0)
tcb logs search --query 'function_name:"my-func" | select request_id, max(status_code) as status_code, max(ret_msg) as ret_msg where status_code>200 AND status_code!=202 AND retry_num=0 group by request_id limit 10'

# One invocation by RequestId (sort asc to read it in order)
tcb logs search --query 'request_id:("abc-123-def-456")' --sort asc

# Absolute time window
tcb logs search --timeRange "2026-10-16 14:00:00,2026-10-16 15:00:00"
```

> ℹ️ This replaces the deprecated `tcb fn log` (removed since v3.0.0). See `functions.md`.

---

## CloudRun queries

```bash
tcb logs search --service tcbr --query '"error"' --timeRange 1h
tcb logs search --service tcbr --query '"error" AND "timeout"' --limit 50
tcb logs search --service tcbr --query '__TAG__.container_name:/my-service-[0-9]+/'
```

Full-text matching uses `__CONTENT__` for CloudRun. Fields: `__TAG__.container_name`
(service + instance, regex supported), `__TAG__.pod_name`.

---

## Platform-log queries (database / auth / model / workflow / LLM / gateway)

Filter by `module:` (and optionally `eventType:` / `logType:`):

```bash
# Document database slow queries
tcb logs search --query 'module:database AND eventType:MongoSlowQuery'

# Relational DB events
tcb logs search --query 'module:rdb'
tcb logs search --query 'module:rdb AND eventType:MysqlFreeze'
tcb logs search --query 'module:rdb AND eventType:MysqlSlowQuery'

# Data model / workflow / auth
tcb logs search --query 'module:model'
tcb logs search --query 'module:workflow'
tcb logs search --query 'module:auth'

# LLM trace logs
tcb logs search --query 'module:llm AND logType:llm-tracelog'

# App publish / delete
tcb logs search --query 'module:app AND eventType:AppProdPub'

# Gateway access logs
tcb logs search --query 'logType:accesslog'
```

## lowcode

# Low-code / WeDa (`tcb lowcode`)

`tcb lowcode` drives the **WeDa 低代码 (微搭)** toolchain: low-code **apps** and **components**
(自定义组件) — build, local preview, debug in WeChat DevTools, publish, version.

## When to Use

- The user explicitly works with **微搭 / WeDa low-code** projects
- Building or previewing a low-code **app** locally
- Creating / building / publishing a low-code **component**
- Managing low-code dependencies

## Do NOT use for

- CloudBase-native web apps (framework build + CDN) → `app.md` / `hosting.md`
- Cloud functions → `functions.md`
- Containerised services → `cloudrun.md`
- Anything that is not a WeDa low-code project — **most CloudBase tasks do not need this module**

> ⚠️ This is a **different product surface** from the rest of the CLI. Do not reach for `tcb lowcode`
> just because the task mentions "app" — confirm with the user that the project really is a 微搭
> low-code project first. Several commands also expect a Windows/macOS WeChat DevTools installation
> (`--wx-devtool-path`), which CI does not have.

---

## App commands

```bash
tcb lowcode watch                     # build in watch mode (local dev loop)
tcb lowcode watch -p ./src --force-install
tcb lowcode watch --wx-devtool-path <path>

tcb lowcode build:app                 # build the low-code app
tcb lowcode build:app --clean --out ./dist

tcb lowcode preview:app               # preview in WeChat DevTools
tcb lowcode preview:app --platform <platform> --wx-devtool-path <path>

tcb lowcode build:app-config          # generate the app config bundle
tcb lowcode build:app-config --out ./out --build-type-list <list> --domain <domain>

tcb lowcode publish:app               # publish the app
tcb lowcode publish:app --src ./dist --sync-cloud

tcb lowcode sync                      # sync low-code sources
```

## Component commands

```bash
tcb lowcode create my-component       # scaffold a component
tcb lowcode create my-component --skip-validate

tcb lowcode build                     # build the component
tcb lowcode debug                     # debug the component
tcb lowcode debug --debug-port 9229 --wx-devtool-path <path>

tcb lowcode publish                   # publish the component
tcb lowcode publish --admin

tcb lowcode publishVersion            # publish a new component version
tcb lowcode publishVersion --comment "fix" --tag latest --admin
```

## Dependencies

```bash
tcb lowcode deps                      # install low-code dependencies
tcb lowcode deps --force --registry https://registry.npmjs.org
```

---

## Command Quick Reference

```bash
tcb lowcode watch                      # App: local watch/build
tcb lowcode build:app [--clean --out <dir>]
tcb lowcode preview:app [--platform <p>]
tcb lowcode build:app-config [--out <dir>]
tcb lowcode publish:app [--src <dir> --sync-cloud]
tcb lowcode sync

tcb lowcode create <name>              # Component: scaffold
tcb lowcode build | debug | publish
tcb lowcode publishVersion [--comment <c>] [--tag <t>] [--admin]

tcb lowcode deps [--force] [--registry <url>]
```

> ℹ️ `tcb lowcode` **is** listed in `tcb --help`, but the `build:app` / `preview:app` /
> `build:app-config` / `publish:app` names use a colon — some shells and docs render them oddly.
> Copy them exactly.

---

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| Cannot find WeChat DevTools | `preview:app` / `debug` need it installed | Install DevTools and pass `--wx-devtool-path <path>`; not available in CI |
| `publish` asks for admin | The account lacks publishing rights | Use `--admin` only with an admin account, or ask the owner |
| Component build fails after editing | Stale deps | Re-run `tcb lowcode deps --force` |
| Wrong project targeted | Project is not a 微搭 project | Confirm with the user; use `app.md` / `hosting.md` for CloudBase-native web apps |

---

## Self-Check

- [ ] Confirmed the project really is a **WeDa low-code** project (not a CloudBase web app)?
- [ ] For `preview:app` / `debug`: is WeChat DevTools available (not a headless CI box)?
- [ ] For `publish:app` / `publishVersion`: does the user have publish rights, and did they approve?
- [ ] Used `--out` / `--src` explicitly rather than relying on defaults?

## monitor

# Monitor — CloudBase CLI

`tcb monitor` queries **metric** data (call counts, latency, resource usage, error rates) for the
resources in an environment. Logs are a different command — see `logs.md`.

## When to Use

- Checking a function's invocation count / error rate / resource usage over a window
- Checking CloudRun CPU / memory / instance curves
- Checking database metrics, hosting traffic, auth and LLM usage
- Checking gateway call metrics (API dimension or resource dimension)
- Building a quick "is it healthy?" report before or after a deploy

## Do NOT use for

- Log lines / error messages → `logs.md`
- Billing and credit consumption → `tcb env usage` (`env.md`)
- Resource configuration / quotas → `tcb env detail` (`env.md`)

---

## Command map

| Subcommand | Target |
|------------|--------|
| `tcb monitor function [function-name]` | Cloud function metrics |
| `tcb monitor database [collection-name]` | Document database metrics |
| `tcb monitor mysql` | MySQL metrics |
| `tcb monitor cloudrun <service-name>` | CloudRun service metrics |
| `tcb monitor hosting` | Static hosting metrics |
| `tcb monitor auth` | Authentication metrics |
| `tcb monitor ai` | Foundation-model metrics |
| `tcb monitor knowledgebase` | Knowledge-base metrics |
| `tcb monitor userlogin` | User login metrics |
| `tcb monitor gateway <dimension>` | Gateway calls — `dimension` = `api` or `resource` |
| `tcb monitor dbconnector <connector-id>` | Database connector metrics |
| `tcb monitor env` | Environment-level metrics |
| `tcb monitor schema [resource]` | Available metric names (all resource types when omitted) |

> ✅ **`tcb monitor` is officially supported — recommend it normally.** It is simply **not listed in
> `tcb --help`** (that list is hand-maintained), which must not be read as "internal" or "experimental".
> Use it whenever the user asks for metrics / health / usage curves.

---

## Shared flags

Almost every subcommand accepts the same four:

| Flag | Meaning | Default |
|------|---------|---------|
| `--since <since>` | Start time; relative (`1h`, `30m`, `2d`) or absolute | `1h` |
| `--until <until>` | End time; relative (`now`, `5m`) or absolute | `now` |
| `--metric-name <name...>` | Metric(s) to query; comma-separated single value (`A,B`) or repeat the flag. Omitted = all metrics for that resource | all |
| `--period <period>` | Aggregation period **in seconds**: `300` (5 min) / `3600` (1 h) / `86400` (1 d) | auto by range |

Two subcommands add their own:

| Subcommand | Extra flag |
|------------|-----------|
| `monitor cloudrun` | `--service-version <version>` — restrict to one version |
| `monitor gateway` | `--api-type wx\|http_openapi` (only `dimension=api`); `--resource-id <id>` (only `dimension=resource`, value contains `\|` so quote it) |

---

## Examples

```bash
# Last hour of a function's metrics (default window and period)
tcb monitor function my-func --env-id <envId>

# Last 6 hours, 5-minute buckets, only two metrics
tcb monitor function my-func --since 6h --period 300 \
  --metric-name Invocation,MemoryUse --env-id <envId>

# Absolute window
tcb monitor function my-func \
  --since "2026-10-16 00:00:00" --until "2026-10-16 12:00:00" --env-id <envId>

# CloudRun service, single version
tcb monitor cloudrun my-service --service-version my-service-001 --since 2h --env-id <envId>

# Gateway API-dimension calls from mini-program APIs
tcb monitor gateway api --api-type wx --since 1h --env-id <envId>

# Gateway resource dimension (quote the id — it contains |)
tcb monitor gateway resource --resource-id "<domain>|<path>|<resource>" --env-id <envId>

# JSON for programmatic use
tcb monitor function my-func --env-id <envId> --json
```

> ⚠️ `monitor gateway` takes a **positional** `dimension` (`api` | `resource`). Unlike `--api-type`,
> it cannot be omitted.

> ⚠️ `--period` is in **seconds**, not a string like `5m`. `--period 300`, not `--period 5m`.

---

## Common Errors

| Symptom | Cause | Fix |
|---------|-------|-----|
| Empty metrics | Window too short, or the resource had no traffic | Widen `--since`; confirm the resource name |
| "unknown metric" | `--metric-name` value not valid for that resource type | Run `tcb monitor schema <resource>` to list valid names |
| `monitor cloudrun` complains about the target | Service name missing | CloudRun monitor takes the service name **positionally** |
| `--period` rejected | Passed `5m` instead of seconds | Use `300` / `3600` / `86400` |
| `monitor gateway` errors on dimension | Dimension omitted | Pass `api` or `resource` positionally |

---

## Self-Check

- [ ] Confirmed the envId with the user?
- [ ] Chose metrics (`monitor`) vs log lines (`logs search`) correctly?
- [ ] `--period` expressed in seconds?
- [ ] For CloudRun: passed the service name positionally and optionally a version?
- [ ] For gateway: passed the dimension positionally and the type/resource flag that goes with it?

## mysql

# MySQL Database Operations (`tcb db`)

Execute SQL, manage instances, backups, and slow queries for CloudBase MySQL via `tcb db` commands.

⚠️ MySQL commands live under **`tcb db ...`** (NOT `tcb db mysql ...`). Don't confuse with `tcb db nosql ...` (NoSQL).

## When to Use

- Execute SQL queries or mutations against CloudBase MySQL
- Inspect, restart, or resize MySQL instances
- Create, list, restore, or delete backups
- Analyze slow queries for performance troubleshooting

## Do NOT use for

- NoSQL/MongoDB operations → use `references/nosql.md` (commands are `tcb db nosql ...`)
- **PostgreSQL** (a different data plane, not "MySQL v2") → `../postgresql-development-cloudbase/SKILL.md`
- Data model definitions / `database-schemas/` sync → `references/schema.md` (`tcb db model`)
- In-app MySQL queries via server SDK → use `cloud-functions` skill
- Storage file management → use `references/storage.md`
- Complex stored procedures or multi-statement transactions → use a MySQL client directly

> ⚠️ Environment-level `db backup` targets the **MySQL** instance. NoSQL backups are the separate
> `tcb db nosql backup ...` family (`references/nosql.md`). The two share a word, not an API.
> `tcb db model *` is a third, unrelated thing (low-code data definitions, `references/schema.md`).

## Command Quick Reference

```
tcb db execute              Execute SQL statement
tcb db instance list        List MySQL instances
tcb db instance restart     Restart a MySQL instance
tcb db instance config get  Read instance configuration
tcb db instance config set  Resize CPU/memory
tcb db backup list          List backups
tcb db backup create        Create a backup
tcb db backup restore       Restore from backup
tcb db backup drop          Delete a backup
tcb db monitor slow-query   Analyze slow queries
```

### Global options

- `-e, --env-id <envId>` — target environment
- `--json` — structured output (use for automation)
- `--yes` — skip confirmation for destructive/confirmation-gated operations

> ⚠️ Use the kebab-case `--env-id`. The old camelCase `--envId` still resolves as a hidden deprecated
> alias, but it prints `⚠️ --envId 已废弃，请使用 --env-id` on every call — do not generate it.

⚠️ In `--json` mode, interactive prompts are suppressed — commands that need `--instance-id` or `--yes` will **fail silently** without them.

---

## Workflow 1: Safe SQL Execution

Always start with read-only queries for discovery:

```bash
# Read-only query
tcb db execute -e <envId> --sql "SELECT * FROM users WHERE status = 'active' LIMIT 10" --read-only --json

# Simple connectivity test
tcb db execute -e <envId> --sql "SELECT 1" --read-only --json
```

⚠️ Always use `--read-only` for SELECT queries to prevent accidental mutations.

### Data mutations (INSERT/UPDATE/DELETE)

```bash
# Insert
tcb db execute -e <envId> --sql "INSERT INTO users (name, age, status) VALUES ('alice', 25, 'active')" --json

# Update (keep WHERE clauses narrow)
tcb db execute -e <envId> --sql "UPDATE users SET status = 'inactive' WHERE id = 1001" --json
```

⚠️ Do NOT add `--read-only` to mutation SQL. Show the exact SQL to the user before execution.

⚠️ Always include a `WHERE` clause in `UPDATE` and `DELETE`. Without it, **all rows** are affected.

### `tcb db execute` options

| Option | Description |
|--------|-------------|
| `-s, --sql <sql>` | Required — the SQL statement |
| `--read-only` | Run in read-only mode |
| `--json` | Rows for SELECT; affected-row info for mutations |

---

## Workflow 2: Instance Management

### Inspect instances

```bash
# List all instances
tcb db instance list -e <envId> --json

# Get instance configuration
tcb db instance config get -e <envId> --instance-id <instanceId> --json
```

### Resize instance

```bash
# Step 1: Check current config
tcb db instance config get -e <envId> --instance-id <instanceId> --json

# Step 2: Resize (both --cpu and --memory required)
tcb db instance config set -e <envId> --instance-id <instanceId> --cpu 2 --memory 4 --yes
```

⚠️ Resizing changes CPU and memory together. May cause brief service interruption.

⚠️ In `--json` mode, `config set` **requires `--yes`** — otherwise it fails silently (no interactive prompt available).

### Restart instance


## nosql

# NoSQL Database Operations (`tcb db nosql`)

Execute MongoDB-style commands against CloudBase document database — CRUD, aggregation, backup, and restore.

⚠️ **Always run `tcb db nosql execute --help` first** — this is the most error-prone command family due to nested JSON encoding.

## When to Use

- Execute MongoDB-style CRUD against CloudBase NoSQL document database
- Run aggregation or count commands on document collections
- Manage backup/restore workflows for document collections
- Query restoreable timestamps or collections
- Track restore task status

## Do NOT use for

- MySQL/SQL database operations → use `references/mysql.md` (commands are `tcb db ...` without `nosql`)
- In-app database queries via Web/Mini-Program SDK → use `cloudbase-document-database-web-sdk` skill
- Cloud function database access via server SDK → use `cloud-functions` skill
- Storage file management → use `references/storage.md`

## Command Quick Reference

```
tcb db nosql execute              Run Mongo-style commands
tcb db nosql dump <collection>    Export a collection's data
tcb db nosql backup time          Discover restoreable timestamps
tcb db nosql backup collection    List restoreable collections at a given time
tcb db nosql backup restore       Submit a restore task
tcb db nosql backup task          Track restore task status
```

⚠️ Three similarly-named families — keep them apart:

| Command | What it is |
|---------|-----------|
| `tcb db nosql <...>` | **NoSQL** document DB (this file) |
| `tcb db <instance\|backup\|execute\|monitor>` | **MySQL** (see `mysql.md`) — note `db backup` is the MySQL backup |
| `tcb db model <list\|pull\|push>` | Low-code **data model** definitions (see `schema.md`) |

### Global options

- `-e, --env-id <envId>` — target environment
- `--json` — structured output (use for automation)
- `--tag <tag>` — select instance when multiple document DBs exist in the environment

> ⚠️ Use the kebab-case `--env-id`. The old camelCase `--envId` still resolves as a hidden deprecated
> alias, but it prints `⚠️ --envId 已废弃，请使用 --env-id` on every call — do not generate it.

### Export a collection

```bash
tcb db nosql dump orders -e <envId>
tcb db nosql dump orders --fields "_id,status,createdAt" -e <envId>   # CSV requires --fields
```

`--fields` is a comma-separated field list and is **required for CSV output**.

---

## The MgoCommandParam Format (Critical)

Every `execute` call takes a `--command` argument: a **JSON array** of `MgoCommandParam` objects.

```json
[
  {
    "TableName": "users",
    "CommandType": "QUERY",
    "Command": "{\"find\":\"users\",\"filter\":{\"status\":\"active\"},\"limit\":10}"
  }
]
```

⚠️ The `Command` field must be a **JSON-encoded string** (with escaped quotes), NOT a raw JSON object. This is the #1 source of errors.

### Two-layer structure

1. **Outer layer** — the `MgoCommands` JSON array (parsed by the CLI)
2. **Inner layer** — the `Command` value: a stringified MongoDB shell command

**Build process:** Write the inner MongoDB JSON first → stringify it (escape all `"` as `\"`) → paste into the `Command` field.

### CommandType → Command template

| `CommandType` | `Command` template |
|---|---|
| `QUERY` | `{"find":"<coll>","filter":{...},"limit":N}` |
| `INSERT` | `{"insert":"<coll>","documents":[{...}]}` |
| `UPDATE` | `{"update":"<coll>","updates":[{"q":{...},"u":{"$set":{...}}}]}` |
| `DELETE` | `{"delete":"<coll>","deletes":[{"q":{...},"limit":1}]}` |
| `COMMAND` (count) | `{"count":"<coll>","query":{...}}` |
| `COMMAND` (aggregate) | `{"aggregate":"<coll>","pipeline":[...],"cursor":{}}` |

Notes:
- `TableName` usually matches the target collection name.
- ⚠️ `UPDATE` and `DELETE` commonly fail because users pass an object instead of the required `updates`/`deletes` **array**.
- ⚠️ Aggregation requires `"cursor":{}` — omitting it causes an error.

---

## Workflow 1: Query Documents

```bash
tcb db nosql execute -e <envId> --command \
  '[{"TableName":"users","CommandType":"QUERY","Command":"{\"find\":\"users\",\"filter\":{\"status\":\"active\"},\"limit\":10}"}]' --json
```

⚠️ Always start with a single **read** command before attempting writes.

---

## Workflow 2: Insert Documents

```bash
tcb db nosql execute -e <envId> --command \
  '[{"TableName":"products","CommandType":"INSERT","Command":"{\"insert\":\"products\",\"documents\":[{\"name\":\"Widget A\",\"price\":29.99},{\"name\":\"Widget B\",\"price\":49.99}]}"}]' --json
```

---

## permission

# Permission — CloudBase CLI

CloudBase access control has **four independent layers** — know which one to use before running any command:

| Layer | Command | Controls |
|-------|---------|----------|
| **Resource Authorization (OPA Rego)** | `tcb policy list / get / set` | Environment-level Rego policy that the gateway evaluates for resource access |
| **Resource Permission (legacy)** | `tcb permission get/set` — ⚠️ **offline** | Prints a migration notice and performs nothing. Do not use. |
| **Role** | `tcb role ...` | Policy bundles + member assignments (identity dimension) |
| **User** | `tcb user ...` | Account attributes only (name, email, status) — NOT role binding |

> ⚠️ **`tcb permission get/set` has been taken offline.** These commands now only print
> "请使用 tcb policy …" and execute no operation — they are not deprecated aliases, they do nothing.
> Any task that used to be done with `tcb permission` must go through `tcb policy`.

> ⚠️ Saving a Rego policy with `tcb policy set` **immediately disables legacy gateway authorization** —
> after that, the role/gateway policies no longer decide access. Role policies and the Rego policy are
> **two parallel systems with NO automatic sync**: audit both separately.

---

## When to Use

- Managing resource-level authorization (now: environment OPA Rego policy via `tcb policy`)
- Creating, updating, or deleting roles with policies and user assignments
- Managing user accounts (create, update status, delete)
- Auditing authorization state across policies and roles

## Do NOT use for

- Storage ACL rules (use `tcb-storage` `rules get/update`)
- CORS / domain / routing access (use `tcb-access`)
- CloudBase console access control (CLI-managed permissions only)

---

## Workflow 1: Manage Resource Authorization (`tcb policy`)

### Step 1 — Inspect the current policy

```bash
tcb policy list --env-id <envId>                    # legacy gateway authorization policy list
tcb policy list --resource-type policy --env-id <envId>
tcb policy get --env-id <envId>                     # the user-configured policy
tcb policy get --extension --env-id <envId>          # the policy configured specifically for this environment
```

> ⚠️ `tcb policy list` returns an **empty list for PG environments and OPA-engine environments** — that
> is expected, not an error. Use `tcb policy get` to read the effective policy in those environments.

### Step 2 — Set the Rego policy

```bash
# Inline Rego (quoted)
tcb policy set 'package authz.user

default allow := false

# 放通匿名用户访问云函数
allow if {
  input.cloudbase.resource_type == "functions"
  input.subject.auth_type == "anonymous"
}' --env-id <envId>

# From a file
tcb policy set "$(cat policy.rego)" --env-id <envId>
```

> ⚠️ `tcb policy set` asks for confirmation — saving **immediately disables legacy gateway authorization**.
> In CI/scripts add `--yes`. Show the policy to the user and get explicit approval before writing it.

**Rego entry points seen in the CLI's own examples:**
- `package authz.user` + `default allow := false` — the rule set is the user policy
- `input.cloudbase.resource_type` — e.g. `"functions"` (resource type being accessed)
- `input.subject.auth_type` — e.g. `"anonymous"` (caller identity type)

> ⚠️ Verify field names against `tcb policy get` output and the official docs before authoring a
> non-trivial policy — an incorrect Rego policy takes effect immediately.

### Step 3 — Verify

```bash
tcb policy get --env-id <envId>          # read back the policy you just wrote
tcb policy list --env-id <envId>         # confirm legacy list state
```

### Legacy level model (historical reference only — NOT settable via CLI)

The old `tcb permission set --level <level>` model used these levels. **`tcb permission` is offline**,
so these values can no longer be applied through the CLI — express the equivalent intent as Rego.

| Resource | Old levels |
|----------|--------|
| `table` | `readonly`, `private`, `adminwrite`, `adminonly` |
| `collection` | `readonly`, `private`, `adminwrite`, `adminonly`, `custom` |
| `function` | `custom` only |
| `storage` | `readonly`, `private`, `adminwrite`, `adminonly`, `custom` |

---

## Workflow 2: Manage Roles (`tcb role`)

### Step 1 — List and inspect

```bash
tcb role list --env-id <envId>
tcb role list --type custom --detail --env-id <envId>
tcb role get --id <roleId> --detail --env-id <envId>
```

> ⚠️ `role get` query conditions `--id` / `--identity` / `--name` are **mutually exclusive** — pass exactly one.

### Step 2 — Create or update (parameter sets differ!)

| Action | Policies param | Members param |
|--------|---------------|---------------|
| `role create` | `--policies` | `--users` |
| `role update` | `--add-policies` / `--remove-policies` | `--add-users` / `--remove-users` |

> ⚠️ Do NOT use `--add-policies` with `create`, or `--policies` with `update` — they will fail.

## sandbox

# Sandbox — CloudBase CLI

CloudBase **Sandbox** (沙箱) runs isolated tool environments (browser automation, code interpreter,
custom images) as short-lived instances. `tcb sandbox` manages the tool *definitions*, the running
*instances*, and the *API keys* used to reach them.

## When to Use

- Creating / updating a reusable sandbox **tool** (image, network mode, resources, mounts)
- Starting, pausing, resuming, stopping sandbox **instances**
- Fetching an instance's access token
- Managing sandbox **API keys** for programmatic access

## Do NOT use for

- Deploying application code → `functions.md` / `cloudrun.md` / `app.md`
- Environment-level resources → `env.md`
- Generic cloud API escape hatch → `tcb api` (`core.md`)

---

## Tool definitions (`tcb sandbox tool`)

```bash
tcb sandbox tool list --env-id <envId>
tcb sandbox tool list --limit 50 --offset 0 --filter "Name=my-tool" --env-id <envId>

tcb sandbox tool create my-tool --env-id <envId> \
  -t browser \
  --network-mode PUBLIC \
  -d "headless browser sandbox" \
  --timeout 30m

tcb sandbox tool update <toolId> --env-id <envId> -d "new description"
tcb sandbox tool delete <toolId> --env-id <envId>
```

`tool create` flags:

| Flag | Meaning |
|------|---------|
| `-t, --tool-type <type>` | `browser` \| `code-interpreter` \| `custom` |
| `--network-mode <mode>` | `PUBLIC` \| `VPC` \| `SANDBOX` |
| `-d, --description <desc>` | Description (max 200 chars) |
| `--timeout <timeout>` | Default timeout, `5m` / `300s` / `1h` style, max 24h |
| `--tags <key=value>` | Extra tags, repeatable |
| `--client-token <token>` | Idempotency token (max 64 chars) |
| `--role-arn <arn>` | Role ARN |
| `--storage-mounts <json>` | `StorageMount[]` JSON (each needs `Name` / `StorageSource`) |
| `--custom-configuration <json>` | `CustomConfiguration` JSON (`Image` / `ImageRegistryType` / `Command` / `Args` / `Env` / `Ports` / `Resource…`) |
| `--log-configuration <json>` | `LogConfiguration` JSON |
| `--subnet-ids <id>` | VPC subnet id — **only** when `--network-mode VPC`, exactly one |
| `--security-group-ids <ids...>` | Security groups — only with `--network-mode VPC`, duplicates de-duplicated |

`tool update` accepts a subset: `-d/--description`, `--tags`, `--network-mode`, `--subnet-ids`,
`--security-group-ids`, `--custom-configuration`.

> ⚠️ `--timeout` accepts human forms (`5m`, `300s`, `1h`) — unlike `tcb monitor --period`, which takes
> seconds. Do not mix the two conventions up.

---

## Instances (`tcb sandbox instance`)

```bash
# Start — pick the tool by id or by name (exactly one)
tcb sandbox instance start --tool-name my-tool --env-id <envId>
tcb sandbox instance start --tool-id <toolId> --timeout 1h \
  --auth-mode TOKEN --metadata purpose=test --env-id <envId>

tcb sandbox instance list --env-id <envId>
tcb sandbox instance list --tool-id <toolId> --limit 20 --offset 0 --env-id <envId>
tcb sandbox instance list --instance-ids <id1>,<id2> --env-id <envId>

tcb sandbox instance update <instanceId> --timeout 2h --metadata stage=warm
tcb sandbox instance pause  <instanceId> --env-id <envId>
tcb sandbox instance resume <instanceId> --env-id <envId>
tcb sandbox instance token  <instanceId> --env-id <envId>   # access token for the instance
tcb sandbox instance stop   <instanceId> --env-id <envId>
```

`instance start` flags: `--tool-id` **or** `--tool-name` (mutually exclusive, one required),
`--timeout <t>`, `--auth-mode DEFAULT|TOKEN|NONE`, `--client-token <token>`,
`--mount-options <json>` (`MountOption[]`, each needs `Name`), `--custom-configuration <json>`,
`--metadata key=value` (repeatable).

`instance list` flags: `--instance-ids <ids...>` (max 100), `--tool-id <id>`, `--filter Name=Values`
(repeatable; multiple conditions AND, multiple values in one condition OR), `--offset`, `--limit`
(default 20, max 100).

> ⚠️ `instance update --timeout` **restarts the timeout clock** from the moment you set it — it is not
> "extend by N". Minimum 30s, maximum 24h.
>
> ⚠️ `instance token` returns a live access credential. Do not print it into logs, commits, or the
> conversation transcript; hand it to the user, not into a file under version control.

---

## API keys (`tcb sandbox apikey`)

```bash
tcb sandbox apikey list --env-id <envId>
tcb sandbox apikey create my-key --env-id <envId>
tcb sandbox apikey delete <keyId> --env-id <envId>
```

> ⚠️ `sandbox apikey delete` is **irreversible**. Confirm the keyId with the user and check
> `sandbox apikey list` first.
>
> ⚠️ A sandbox API key grants programmatic access. Treat it like any other credential: env vars only,
> never in the repo.

---

## Command Quick Reference

```bash
tcb sandbox tool list                    # List tool definitions
tcb sandbox tool create <toolName>       # Create a tool (-t browser|code-interpreter|custom)
tcb sandbox tool update <toolId>

## schema

# Schema & Migrations — CloudBase CLI

Schema-definition tooling exposed by the CLI: the low-code **data model** sync (`tcb db model`),
the generated TypeScript types (`tcb sync-model-dts`), and **PostgreSQL migrations**
(`tcb db pg migration`).

## When to Use

- Syncing data-model definitions between local files and the cloud
- Generating TypeScript type definitions from the data model
- Creating / listing / applying / repairing PostgreSQL migrations from the terminal or CI

## Do NOT use for

- **Designing** a data model (ER diagrams, multi-entity modelling) → `../data-model-creation/SKILL.md`
  (deprecated; for new work prefer PostgreSQL DDL)
- **PostgreSQL schema design, RLS, queries** → `../postgresql-development-cloudbase/SKILL.md`
- MySQL instance / backup operations → `mysql.md`
- NoSQL collection data operations → `nosql.md`
- Function config in `cloudbaserc.json` → `config.md` / `functions.md`

---

## Data model (`tcb db model`)

Local definitions live in `database-schemas/` by default.

```bash
tcb db model list                        # list all cloud-side data models
tcb db model list --json

tcb db model pull                        # cloud -> local (all models)
tcb db model pull -n user,order          # only the named models (comma-separated)
tcb db model pull -d ./database-schemas  # custom local directory

tcb db model push                        # local -> cloud (all models in the dir)
tcb db model push -n user,order
tcb db model push -d ./database-schemas
```

| Flag | Meaning |
|------|---------|
| `-d, --dir <dir>` | Local directory holding model definitions, default `database-schemas` |
| `-n, --name <name>` | Model identifiers, comma-separated; omitted = all |

> ⚠️ `tcb db list` / `tcb db pull` / `tcb db push` are **deprecated aliases** of
> `tcb db model list` / `pull` / `push`. They still run but print a migration warning — use the
> `db model` form so the user is not told about a soon-to-be-removed command.

> ⚠️ `db model push` writes model definitions to the cloud. Run `db model list` and show the diff
> intent to the user first; a wrong push changes the live model.

### Generate TypeScript types

```bash
tcb sync-model-dts --env-id <envId>
```

Writes type-definition files for the cloud data model so application code can import them.
It needs a real envId (`requiredEnvId: true`).

---

## PostgreSQL migrations (`tcb db pg migration`)

> ⚠️ **PostgreSQL is a different data plane.** Do not drive a PG environment through `mysql.md` /
> `nosql.md`. This section only covers the CLI surface; for the migration *workflow*, conflict
> handling and RLS, read `../postgresql-development-cloudbase/SKILL.md`.

Migration files live in **`cloudbase/migrations/<YYYYMMDDHHMMSS>_<name>.sql`**. That path must match
what the MCP `managePgDatabase` tools use — if an older workspace keeps `migrations/` at the repo
root, move the files into `cloudbase/migrations/` before mixing CLI and MCP.

```bash
tcb db pg migration new add_user_table        # scaffold a new migration file
tcb db pg migration list                      # local + remote status
tcb db pg migration list --remote-only        # remote-applied only
tcb db pg migration list --remote-only --limit 100 --offset 0

tcb db pg migration fetch                     # remote history -> local files
tcb db pg migration fetch 20261016120000      # one version
tcb db pg migration fetch --force             # overwrite existing local files
tcb db pg migration fetch --dry-run           # preview only

tcb db pg migration up                        # apply pending migrations
tcb db pg migration up --dry-run              # preview pending migrations
tcb db pg migration up --include-all          # allow out-of-order (backfill) versions

tcb db pg migration repair <version> --status applied  --reason "manual fix"
tcb db pg migration repair <version> --status reverted --reason "manual fix" --dry-run
```

| Command | Flags |
|---------|-------|
| `new <name>` | — (creates `cloudbase/migrations/<version>_<name>.sql`) |
| `list` | `--remote-only`, `--limit <n>` (1-500, default 100), `--offset <n>` — `--limit/--offset` are **only** valid together with `--remote-only` |
| `fetch [version]` | `-f/--force` (overwrite local), `--dry-run` |
| `up` | `--dry-run`, `--include-all` |
| `repair <version>` | `--status applied\|reverted` (**required**), `--reason <text>` (**required**), `--dry-run` |

> ⚠️ `--include-all` applies versions **older** than the latest applied one. Use it only for branch
> merges / backfills the user explicitly asked for — never for routine work.

> ⚠️ `repair` rewrites recorded migration state, not the database. It does **not** run SQL. Always
> `--dry-run` first and get the user's approval, because it can desynchronise history from reality.

---

## Command Quick Reference

```bash
tcb db model list                         # List cloud data models
tcb db model pull [-n a,b] [-d <dir>]     # Model definitions: cloud -> local
tcb db model push [-n a,b] [-d <dir>]     # Model definitions: local -> cloud
tcb sync-model-dts --env-id <id>          # Generate TS type definitions

tcb db pg migration new <name>            # Scaffold a migration
tcb db pg migration list [--remote-only]  # Status
tcb db pg migration fetch [version]       # Remote history -> local
tcb db pg migration up [--dry-run]        # Apply

## storage

# Cloud Storage Management (`tcb storage`)

Manage CloudBase cloud storage — upload, download, delete, copy/move files, generate temp URLs, search
files, and configure ACL rules.

> ⚠️ **Two storage generations share one command.** Check the environment first:
> - **COS storage** (default / NoSQL / MySQL environments) → the commands below plus `storage rules`
> - **PG storage** (`pgstore`, PostgreSQL environments) → `storage buckets` / `storage policies` /
>   `storage objects`
> See *COS vs PG storage* at the end of this file.

## When to Use

- Upload or download files to/from CloudBase cloud storage
- Delete files (single, batch, or wildcard-based)
- Generate temporary access URLs for stored files
- Copy or move files within cloud storage
- Search for files by name pattern
- Manage storage ACL permission rules
- (PG envs) manage buckets, objects and RLS policies

## Do NOT use for

- Static website hosting with CDN → use `references/hosting.md`
- Web app deployment → use `references/app.md`
- Database operations → use `references/mysql.md` or `references/nosql.md`
- PostgreSQL RLS **design** and `pgstore` semantics → `../postgresql-development-cloudbase/SKILL.md`
- In-app file operations via Web/Mini-Program SDK → use `cloud-storage-web` skill
- Large-scale data migration (>10 GB) → use the console bulk-import tool

## Command Quick Reference

```
tcb storage upload        Upload local file(s) or directory
tcb storage download      Download file(s) or directory
tcb storage rm            Delete file(s) — supports wildcards and --dry-run
tcb storage list          List files in storage
tcb storage url           Get temporary access URL
tcb storage detail        Get file metadata
tcb storage cp            Copy or move files in cloud
tcb storage search        Find files by name pattern
tcb storage rules get     Get storage ACL rules
tcb storage rules update  Update storage ACL rules
```

⚠️ `storage delete`, `storage get-acl`, `storage set-acl` are **deprecated** — use the new commands:

| Old (deprecated) | New command |
|-------------------|-------------|
| `storage delete` | `storage rm` |
| `storage get-acl` | `storage rules get` |
| `storage set-acl` | `storage rules update` |

---

## Workflow 1: Upload Files

```bash
# Single file
tcb storage upload ./logo.png images/logo.png -e <envId>

# Directory (recursive)
tcb storage upload ./images images/ -e <envId>

# With retry (0-10 retries, default 1)
tcb storage upload ./images images/ --times 3 --interval 1000 -e <envId>
```

⚠️ **`cloudPath` must NOT start with `/`** — this is the #1 upload error.

```bash
# WRONG — errors with "cloudPath cannot start with /"
tcb storage upload ./logo.png /images/logo.png
# CORRECT
tcb storage upload ./logo.png images/logo.png
```

**Shared-bucket environments.** Some environments keep their files in a COS bucket shared with other environments, each isolated under its own directory prefix (BasePath). The CLI resolves the shared bucket and BasePath by itself, so you do not need to detect this: **write `cloudPath` exactly as in a normal environment** and never prepend the BasePath or the bucket name. `list`, `detail`, `url`, `cp` and `rm` accept and return the same plain paths.

```bash
# Environment whose storage BasePath is "tenant-a"
# WRONG — the file ends up under tenant-a/tenant-a/images/logo.png
tcb storage upload ./logo.png tenant-a/images/logo.png -e <envId>
# CORRECT — stored as tenant-a/images/logo.png in the shared bucket
tcb storage upload ./logo.png images/logo.png -e <envId>
```

For 50+ file uploads, check `cloudbase-error.log` for partial failure details. Retry with `--times 5 --interval 1000`.

---

## Workflow 2: Download Files

```bash
# Single file
tcb storage download images/logo.png ./logo.png -e <envId>

# Directory — requires --dir
tcb storage download images/ ./images --dir -e <envId>
```

⚠️ Missing `--dir` when downloading a folder will fail or only affect one file.

---

## Workflow 3: Safe File Deletion

Always preview before executing:

```bash
# 1. Dry-run preview (no actual deletion)
tcb storage rm "*.tmp" --dry-run -e <envId>

# 2. Execute after confirming
tcb storage rm "*.tmp" --force -e <envId>
```

### Deletion patterns

```bash

## rule

---
name: cloudbase-cli
description: CloudBase CLI (tcb, 云开发CLI, Tencent CloudBase命令行) resource management skill. Use when deploying cloud functions, CloudRun, storage, NoSQL/MySQL, static hosting, permissions, CORS/domains via tcb; for CI/CD and batch ops; when the user prefers CLI; or as the first-session fallback when CloudBase MCP tools are not loaded yet (after install/config, before IDE restart). Also covers tcb login and site switching (国内站/国际站 via --intl or config isIntl), environment lifecycle (env create/modify/renew/delete/apikey/login/domain), tcb config and cloudbaserc.json sync, log search (logs search, CLS), metric monitoring (monitor), data model and PostgreSQL migrations (db model, db pg migration), sandbox/agent/integration management — do not default to tcb deploy.
version: 2.35.2
license: MIT
alwaysApply: false
---

# CloudBase CLI

Manage CloudBase resources via `tcb` CLI — deterministic, scriptable, auditable.
Primary interface for CI/CD and batch ops; **also the first-session fallback** when MCP tools are not yet available in the conversation.

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

**Cross-cutting protocols** (required before code changes or deployments):
- Change Safety Protocol: `../cloudbase-platform/references/protocols/change-safety-protocol.md`
- Deployment Gate: `../cloudbase-platform/references/protocols/deployment-gate.md`
- MCP vs CLI fallback: `../cloudbase/references/tooling-fallback.md` (packaged beside this skill as the `cloudbase` entry guideline)

**Route, do not improvise** — when a task belongs to another skill, hand over instead of guessing flags here:
- PostgreSQL schema / RLS / `pgstore` → `../postgresql-development-cloudbase/SKILL.md`
- Data-model design (ER / Mermaid) → `../data-model-creation/SKILL.md`
- In-app SDK code (web / miniprogram / node) → the matching SDK skill

## Core Principles

1. **`--help` first — but its failure does NOT mean the command is missing.**
   Run `tcb <command> --help` to check parameters and find official doc links. On current CLI versions many
   **second-level** commands reject `--help` (`error: unknown option '--help'`), while some accept `-h`, and
   `tcb help <cmd>` only works one level deep. Try `-h`, then `tcb help <cmd>`, then
   `tcb docs search "<keyword>"` — never conclude a command does not exist from a help error.
   `tcb --help` itself is a **hand-maintained static list**, so absence from it says nothing about
   lifecycle: `init`, `pull`, `new`, `open`, `rollback`, `self-update`, `monitor`, `integration`,
   `service`, `cloudfunction`, `cloudrunfunction` and `run:deprecated` are all registered yet unlisted.
   **Absence from help ≠ deprecated**, and **"no marker" ≠ endorsed** — the statuses differ:
   `tcb monitor` / `tcb integration` are **officially supported** (recommend normally), while
   `tcb service` and `tcb cloudfunction` / `tcb cloudrunfunction` are **not recommended**
   (product decision, no code marker). Full status table: `references/core.md`.

2. **Confirm the site (国内站 / 国际站) as well as the envId.**
   A credential from one site does not work on the other, and the failure looks like an auth error.
   One-off: `tcb login --intl true|false`; persistent: `tcb config set isIntl true|false`.
   Pick one mechanism and keep it consistent — see `references/core.md` / `references/config.md`.

3. **Deployment Gate.**
   Before any deployment, publish, custom domain, or CloudRun operation, you must first complete the checks in `cloudbase-platform/references/protocols/deployment-gate.md`.

4. **Verify your work.**
   After deploying or modifying any resource, run the corresponding list/detail
   command to confirm the change took effect.

5. **Dry-run before destructive actions.**
   Use `--dry-run` for delete/overwrite operations. Show the preview to the user
   and wait for explicit confirmation before executing.

6. **Confirm environment first.**
   Always verify envId with the user before operations. Run `tcb env use <envId>`
   to avoid accidentally modifying production.

7. **Recover from errors, don't loop.**
   If a command fails after 2-3 attempts, check the exit code (`$?`), read the
   error message, consult `tcb docs search`, and try a different approach.

8. **First-session fallback, not MCP replacement.**
   If CloudBase MCP tools are missing in this session, use this skill to unblock
   login/manage. Still configure MCP (plugin / mcp.json) so the **next** session
   can prefer MCP. When MCP tools are already available, prefer MCP unless the
   user asked for CLI/CI. Route deploy work through the domain reference table
   below — **do not** recommend `tcb deploy`.

9. **No npm/npx.**
   If Node/npm/npx are missing, tell the user to install Node.js LTS (or use the
   IDE marketplace MCP path) before retrying CLI/plugin install. See guideline
   `tooling-fallback.md`.

## When to use this skill

Use when the user wants to manage CloudBase resources via command line, **or** when MCP is not usable yet:
- **First session / post-install:** MCP not in the tool list, or just configured and needs restart → `tcb login` + the matching domain command now; leave MCP ready for next session
- Deploy/debug cloud functions, static hosting, CloudRun services (via domain refs — not `tcb deploy`)
- Manage storage, hosting, databases (NoSQL / MySQL / PostgreSQL), data models and migrations
- Manage environments (create / package / renew / destroy, API Keys, login policy, safe domains, usage)
- Configure resource authorization (`tcb policy`), roles, users, CORS, domains, routing
- Search logs and read monitoring metrics
- Manage sandbox, agent and integration instances
- CI/CD scripting, batch operations, terminal-based resource management
- User explicitly prefers CLI over MCP

## Do NOT use for

- SDK-based in-app integration (web/miniprogram/node) → use `cloud-functions`,
  `cloudbase-document-database-web-sdk`, `auth-web-cloudbase`, etc.
- PostgreSQL schema design, RLS and migration workflow → `postgresql-development-cloudbase`
- When CloudBase MCP tools are already available in this session and the user did not ask for CLI → prefer MCP
- Console UI operations
- CloudBase Agent SDK development → use `cloudbase-agent-ts`

## How to use this skill (for a coding agent)

1. **Always load `references/core.md` first** — it covers authentication, site selection,
   environment switching, `tcb docs` queries, and error diagnosis.
2. **Route to the correct reference** using the Routing table below.
3. **Load only the reference files** that match the user's task. Do not preload all of them.
4. **Stop loading more context** once you have the workflow and command syntax for the current task.
5. **If the task shifts to SDK/in-app code or PostgreSQL design**, switch to the appropriate
   sibling skill instead.

## Routing

| User Task | Read |
|-----------|------|
| Login, site (国际站/国内站), env switching, `tcb docs`, error diagnosis | `references/core.md` |
| Create / modify / renew / destroy an environment, API Keys, login policy, safe domains, usage | `references/env.md` |
| `tcb config` (CLI settings, `cloudbaserc.json` sync), `tcb init` / `new` / `pull` / `open` / `validate` / `self-update` / `rollback` | `references/config.md` |
| Configure an AI tool + MCP + Skills (`tcb ai`) | `references/config.md` |

## RULES_INDEX

# Rule Index Matrix

Rules are extracted from CloudBase skill documentation. Each rule has a unique ID, module, severity, and applicable frontends.

## Rule inclusion boundary

Only add rules that are backed by stable SDK/API documentation, repeated evaluation failures, or deterministic runtime behavior. Do not add a hard rule from one trace's workaround alone; record those as attribution observations until independently verified.

## Cartesian Product: Module × Frontend → Applicable Rules

| Module | Web | MiniProgram | Node.js | CloudRun |
|--------|-----|-------------|---------|----------|
| auth | AUTH-WEB-001~019, AUTH-TOOL-001~014 | AUTH-WX-001~011, AUTH-TOOL-001~014 | AUTH-NODE-001~014, AUTH-TOOL-001~014 | AUTH-NODE-001~014, AUTH-TOOL-001~014 |
| nosql | NOSQL-001~016 | NOSQL-MP-001~005, NOSQL-004~016 inter | — | — |
| relational-database | RDB-WEB-001~005, RDB-TOOL-001~008 | — | RDB-TOOL-001~008 | RDB-TOOL-001~008 |
| storage | STO-001~007 | — | — | — |
| data-model | — | — | DM-001~007 | DM-001~007 |
| security / runtime-credentials | — | — | SEC001 | SEC001 |

---

## Module: security / runtime-credentials

| Rule ID | Severity | Check | Applies to | Description |
|---------|----------|-------|-----------|-------------|
| SEC001 | error | lint + LLM | Node, CR | 禁止回显 `x-cloudbase-context`、完整 headers / `process.env`，禁止部署 httpbin 类反射镜像 |

---

## Module: auth

### Web (AUTH-WEB-)

| Rule ID | Severity | Check | Description |
|---------|----------|-------|-------------|
| AUTH-WEB-001 | error | LLM | 禁止用云函数登录逻辑替代内置 Web Auth |
| AUTH-WEB-002 | error | LLM | 禁止在 Flutter/React Native/原生中复用 Web Auth |
| AUTH-WEB-003 | warning | LLM | 创建 auth 辅助函数后必须接入现有表单处理器 |
| AUTH-WEB-004 | error | lint | 用户名账号禁止使用 signInWithEmailAndPassword/SignUpWithEmailAndPassword |
| AUTH-WEB-005 | error | lint | 用户名输入框不得保留 type="email" |
| AUTH-WEB-006 | error | LLM | 必须先 queryAppAuth 确认 provider 已启用，再写登录代码 |
| AUTH-WEB-007 | error | lint | 禁止用 auth.getUser() / getLoginState() 做路由守卫判断 |
| AUTH-WEB-008 | error | lint | 必须用 auth.getSession() 做路由守卫（data.session === undefined 判断） |
| AUTH-WEB-009 | warning | LLM | 匿名登录默认禁用；accessKey ≠ 匿名会话，NoSQL 前须 signInAnonymously() |
| AUTH-WEB-010 | error | lint | 禁止把 accessKey 设为 envId 或占位符字符串 |
| AUTH-WEB-011 | error | lint | auth 方法返回 { data, error }，必须先检查 error |
| AUTH-WEB-012 | error | lint | 禁止使用已废弃的 auth.getLoginState() |
| AUTH-WEB-013 | error | lint | 禁止使用旧 Web Auth API（hasLoginState/getCurrentUser/toDefaultLoginPage） |
| AUTH-WEB-013 | warning | LLM | 用户名注册必须 5-24 字符（字母/数字/下划线） |
| AUTH-WEB-014 | error | LLM | 用户名字符串禁止使用邮箱 OTP 或手机 OTP |
| AUTH-WEB-015 | warning | lint | OTP 验证是 signInWithOtp 返回的 data 上的回调，非独立调用 |
| AUTH-WEB-016 | warning | lint | signInWithOtp({ phone }) 使用 phone 字段非 phone_number |
| AUTH-WEB-017 | warning | lint | 现代 Web 项目必须用 npm install @cloudbase/js-sdk，非 CDN |
| AUTH-WEB-018 | error | lint | 匿名用户 session 也需拒绝（检查 is_anonymous） |
| AUTH-WEB-019 | warning | LLM | SDK 调用必须接入已有 UI 处理器 |

### Auth Provider 配置 (AUTH-TOOL-, 跨所有前端)

| Rule ID | Severity | Check | Applies to | Description |
|---------|----------|-------|-----------|-------------|
| AUTH-TOOL-001 | error | LLM | Web, MP, Node, CR | 禁止在启用 provider 之前编写登录 UI |
| AUTH-TOOL-002 | warning | LLM | Web, MP, Node, CR | 禁止把"auth"的任意提及都当作 provider-management 任务 |
| AUTH-TOOL-003 | error | lint | Web, Node | 禁止在云函数中实现 Web 登录逻辑 |
| AUTH-TOOL-004 | error | LLM | Web, Node | 禁止将原生 App 认证路由到 Web SDK |
| AUTH-TOOL-005 | error | LLM | Web, MP, Node, CR | 配置/代码改动前必须遵循 Change Safety Protocol |
| AUTH-TOOL-006 | warning | LLM | Web | 确认 provider 后必须回前端完成用户流，不要循环查询 |
| AUTH-TOOL-007 | error | LLM | Web, MP, Node, CR | MCP auth 与 queryAppAuth/manageAppAuth 是两个独立域 |
| AUTH-TOOL-008 | error | LLM | Web, MP, Node, CR | 禁止将应用侧 provider 配置路由到 MCP auth 工具 |
| AUTH-TOOL-009 | error | lint | Web, MP, Node, CR | 禁止使用 lowcode/DescribeLoginStrategy/ModifyLoginStrategy |
| AUTH-TOOL-010 | error | lint | Web | 用户名禁止路由到 email-only 辅助函数 |
| AUTH-TOOL-011 | error | LLM | Web, MP, Node, CR | EnvId 是环境 ID，不是 publishable key |
| AUTH-TOOL-012 | error | LLM | Web, MP, Node, CR | 环境别名必须通过 queryEnv 解析为规范 EnvId |
| AUTH-TOOL-013 | warning | LLM | Web, MP, Node, CR | 匿名登录默认禁用 |
| AUTH-TOOL-014 | warning | LLM | Web, MP, Node, CR | 匿名用户调用 AI 模型需显式授权 |

### Node.js (AUTH-NODE-)

| Rule ID | Severity | Check | Applies to | Description |
|---------|----------|-------|-----------|-------------|
| AUTH-NODE-001 | warning | LLM | Node | 禁止爬取原始 HTTP 示例当 Node SDK 已覆盖时 |
| AUTH-NODE-002 | error | lint | Node, CR | SDK 初始化必须使用规范模式（tcb.init → app.auth()） |
| AUTH-NODE-003 | warning | LLM | Node, CR | 不在文档中的方法视为可疑 |
| AUTH-NODE-004 | error | lint | Node, CR, MP | 禁止仅凭 openId/appId 做授权决策 |
| AUTH-NODE-005 | error | lint | Node, Web | 禁止将 tcb_custom_login.json 打包到前端代码 |
| AUTH-NODE-006 | warning | LLM | Node, CR | customUserId 必须 4-32 字符 |
| AUTH-NODE-007 | error | LLM | Node, CR | 禁止对不同用户复用同一 customUserId |
| AUTH-NODE-008 | error | LLM | Node, CR | tcb_custom_login.json 必须像私钥一样保护 |
| AUTH-NODE-009 | error | LLM | Node, Web, CR | ticket 签发必须使用 HTTPS + 认证 |
| AUTH-NODE-010 | error | lint | Node, CR | auth.* 调用必须包裹在 try/catch |
| AUTH-NODE-011 | error | lint | Node, CR | 禁止将 getEndUserInfo 原始结果直接暴露给客户端 |
| AUTH-NODE-012 | warning | LLM | Node, CR | 优先用 uid 查用户，仅在必要时用 queryUserInfo |
| AUTH-NODE-013 | warning | LLM | Node, CR | platformId 必须使用注册时的精确格式 |
| AUTH-NODE-014 | error | LLM | Node, CR | ticket 只在用户自身认证成功后签发 |

### MiniProgram (AUTH-WX-)

| Rule ID | Severity | Check | Description |
|---------|----------|-------|-------------|
| AUTH-WX-001 | error | lint | 禁止为 wx.cloud 小程序生成 Web 风格登录页 |
| AUTH-WX-002 | error | LLM | 禁止将小程序 auth 当作 provider-configuration 问题 |
| AUTH-WX-003 | error | lint | 云函数中直接使用 cloud.getWXContext() 获取调用者身份 |
| AUTH-WX-004 | error | lint | 云函数必须使用 cloud.DYNAMIC_CURRENT_ENV |
| AUTH-WX-005 | error | LLM | 禁止将 OPENID 暴露给其他用户 |
| AUTH-WX-006 | error | lint | 小程序 auth 不需要显式登录 API 调用 |
| AUTH-WX-007 | error | lint | 云函数必须用 wx-server-sdk，客户端用 wx.cloud |
| AUTH-WX-008 | warning | lint | UNIONID 仅绑定微信开放平台后才可用，需处理 undefined |
| AUTH-WX-009 | info | LLM | OPENID/APPID/UNIONID 已微信验证，不需要额外验证 |
| AUTH-WX-010 | error | lint | app.js 的 onLaunch 中必须 wx.cloud.init |
| AUTH-WX-011 | error | lint | 禁止为小程序用户生成 Web 风格 OAuth 流 |

---

## Module: nosql

### Web (NOSQL-)

| Rule ID | Severity | Check | Description |
|---------|----------|-------|-------------|
| NOSQL-001 | error | lint | 禁止在浏览器中使用 wx.cloud.database() 或 Node SDK |
| NOSQL-002 | error | lint | 禁止动态 import 懒加载初始化 CloudBase |

## README

# cloudbase-lint: CloudBase 代码检查脚本

> 安全说明：本目录不提交可执行脚本文件。下面只提供可审阅的 JavaScript 代码块；仅在用户明确同意时，将其复制到临时本地文件 `cloudbase-lint.mjs` 后运行。

## 使用方法

```bash
# 可选：用户同意后，从下方代码块复制全部内容到临时 cloudbase-lint.mjs
# 然后在项目根目录运行
node cloudbase-lint.mjs --project-dir .
```

## 脚本代码

```javascript
#!/usr/bin/env node

/**
 * cloudbase-lint: CloudBase 项目代码检查脚本
 *
 * 检查 CloudBase 项目中的常见错误：
 * - auth 路由守卫误用（getUser 代替 getSession）
 * - 密码错误 API（signInWithEmailAndPassword 等）
 * - PG 表未创建
 * - 安全域名未配置
 * - 存储 URL 拼接
 * - 已废弃 API 使用
 * - 云函数/云托管回显 x-cloudbase-context、headers、process.env 或 httpbin
 *
 * 返回 0 表示无错误，返回 1 表示发现问题。
 */

import { readFileSync, existsSync, readdirSync, statSync } from 'node:fs';
import { join, resolve } from 'node:path';

const args = process.argv.slice(2);
const projectDirIdx = args.indexOf('--project-dir');
const projectDir = projectDirIdx >= 0 ? resolve(args[projectDirIdx + 1]) : process.cwd();

if (!existsSync(projectDir)) {
  console.error(`[cloudbase-lint] project-dir not found: ${projectDir}`);
  process.exit(1);
}

function findSourceFiles(dir) {
  const results = [];
  const entries = readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const fullPath = join(dir, entry.name);
    if (entry.isDirectory() && entry.name !== 'node_modules' && entry.name !== 'dist' && entry.name !== '.git') {
      results.push(...findSourceFiles(fullPath));
    } else if (entry.isFile() && /\.(ts|tsx|js|jsx|html|sql|json)$/i.test(entry.name)) {
      results.push(fullPath);
    }
  }
  return results;
}

function readFileSafe(filePath) {
  try {
    const stat = statSync(filePath);
    if (stat.size > 1024 * 1024) return '';
    return readFileSync(filePath, 'utf-8');
  } catch { return ''; }
}

const results = [];

function record(ruleId, severity, message, filePath, line) {
  results.push({ ruleId, severity, message, filePath, line });
}

// ─── Auth Rules ─────────────────────────────────────────────────────────────

function checkAuthGetUser(files) {
  const authGuardFiles = files.filter(f =>
    /(auth|guard|ProtectedRoute|checkAuth)/i.test(f) || /auth\.(ts|tsx|js)$/i.test(f)
  );
  for (const file of authGuardFiles) {
    const content = readFileSafe(file);
    if (!content) continue;
    const lines = content.split('\n');
    for (let i = 0; i < lines.length; i++) {
      if (/auth\.getUser\s*\(\s*\)/.test(lines[i]) && !content.includes('getSession')) {
        record('AUTH001', 'error',
          `路由守卫中使用 auth.getUser()。getUser() 不是可靠登录证明（显式 signInAnonymously() 后也会返回匿名 user）。应使用 auth.getSession() 并检查 data?.session；accessKey 不会自动创建 gateway 会话。`,
          file, i + 1);
      }
    }
  }
}

function checkEmailPasswordApi(files) {
  const pattern = /sign(?:In|Up)WithEmailAndPassword\s*\(/;
  for (const file of files.filter(f => /auth|login|register|sign/i.test(f))) {
    const content = readFileSafe(file);
    if (!content) continue;
    content.split('\n').forEach((line, i) => {
      if (pattern.test(line)) {
        record('AUTH-WEB-004', 'error',
          `用户名场景禁止使用 signInWithEmailAndPassword / signUpWithEmailAndPassword。应使用 auth.signInWithPassword({ username, password }) / auth.signUp({ username, password })`,
          file, i + 1);
      }
    });
  }
}

function checkLoginFormType(files) {
  for (const file of files.filter(f => /login|register/i.test(f))) {
    const content = readFileSafe(file);
    if (!content) continue;
    content.split('\n').forEach((line, i) => {
      if (/type\s*=\s*["']email["']/.test(line) && /user|account|用户名|账号/.test(content)) {
        record('AUTH-WEB-005', 'error',
          `登录/注册表单中 input type="email" 不适用于用户名场景。应使用 type="text"。`,
          file, i + 1);
      }
    });
  }
}

## AUTH001

# AUTH001 路由守卫必须用 `auth.getSession()` 而非 `auth.getUser()`

- **Module**: cross-cutting (auth)
- **Severity**: error
- **Stage**: code-generation
- **适用于**: Web, MiniProgram, Node.js

---

## 正则检查 (Lint)

`references/lint-rules/README.md` 中可选 lint 代码块的扫描条件：

- 查找文件名匹配 `auth | guard | ProtectedRoute | checkAuth` 的文件
- 检查文件内容是否包含 `auth.getUser()`
- 如果发现 `auth.getUser()` 且同一文件 **没有** `getSession`，触发 AUTH001

## LLM 检查

请人工或 LLM 审查以下问题：

1. 项目中的路由守卫（通常是 `ProtectedRoute.tsx` 或类似组件）如何判断用户是否已登录？
2. 是否使用了 `auth.getSession()` 来获取当前会话？
3. 检查 `data?.session` 而非 `data?.user`？

   ```typescript
   // ✅ 正确写法
   const { data } = await auth.getSession()
   if (!data?.session) return <Navigate to="/login" replace />

   // ❌ 错误写法 — getUser() 不是可靠登录证明；显式 signInAnonymously() 后也会返回匿名 user
   const { data } = await auth.getUser()
   if (!data?.user) return <Navigate to="/login" replace />  // 匿名用户会绕过
   ```

4. 是否也检查了 `data.session.user?.is_anonymous` 来排除显式匿名登录？

## 修复指引

1. 在路由守卫中将 `auth.getUser()` 替换为 `auth.getSession()`
2. 将判断条件从 `data?.user` 改为 `data?.session`
3. 可选：增加 `data.session.user?.is_anonymous` 检查

```typescript
const { data, error } = await auth.getSession()
if (error || !data?.session) {
  // 未登录或会话已过期，重定向到登录页
  return <Navigate to="/login" replace />
}
// data.session 存在；若产品不允许匿名，再检查 is_anonymous
```

## 根因

Publishable `accessKey` 仅初始化 SDK，**不会**自动创建可供 gateway 鉴权的匿名会话。`@cloudbase/js-sdk` **3.x** 下 NoSQL `app.database()` CRUD 前必须显式 `await auth.signInAnonymously()`（或等价登录），否则 gateway **401**。

路由守卫侧：不要用 `auth.getUser()` 判断是否已登录——在调用过 `signInAnonymously()` 后它会返回匿名 user，导致「需真实登录」的守卫被绕过；废弃的 `getLoginState()` 甚至可能在未登录时返回误导性 `uid`。应使用 `auth.getSession()`：未登录时 `data.session === undefined`。若产品不允许匿名访问，再检查 `data.session.user?.is_anonymous`。

## SEC001

# SEC001 禁止回显 `x-cloudbase-context`、完整 headers 或敏感环境变量

- **Module**: cross-cutting (security / runtime-credentials)
- **Severity**: error
- **Stage**: code-generation
- **适用于**: Node.js (Cloud Functions), CloudRun

---

## 正则检查 (Lint)

`references/lint-rules/README.md` 中可选 lint 代码块的扫描条件：

- 查找后端 / 函数 / 云托管相关源码（路径或文件名含 `cloudfunctions`、`cloudrun`、`functions`、`server`、`api`，或内容含 `createServer` / `express` / `exports.main`）
- 若同一文件出现以下任一模式，触发 SEC001：
  - 字面量 `x-cloudbase-context`（任意大小写）出现在响应拼装路径附近
  - `res.json` / `res.end` / `res.send` / `return {` 同时回传 `req.headers`、`event.headers`、`process.env`、或完整 `context`
  - Dockerfile / compose / deploy 配置引用 `httpbin` 镜像

## LLM 检查

请人工或 LLM 审查以下问题：

1. HTTP 处理函数是否把 `req.headers`、`event`、`context` 或 `process.env` **整包**写进响应？
2. 是否存在 debug / echo / inspect 路由会打印全部请求头？
3. CloudRun 是否部署了 `httpbin` 或同类「反射请求」镜像？
4. 响应里是否可能包含 `x-cloudbase-context`、`TENCENTCLOUD_SECRET*`、`CLOUDBASE_APIKEY` 等凭证？

```js
// ❌ 错误 — 网关注入的 x-cloudbase-context 会被泄露
app.get('/debug', (req, res) => res.json({ headers: req.headers, env: process.env }))

// ✅ 正确 — 只返回业务需要的非敏感字段
app.get('/health', (_req, res) => res.json({ ok: true }))
```

## 修复指引

1. 删除或改写所有「回显 headers / env / context」的 debug 接口
2. 将 CloudRun 调试镜像换成固定返回的 hello-world / health check
3. 凭证只用于服务端 SDK 初始化，绝不写入 HTTP 响应
4. 完整协议见 `../../../../cloudbase-platform/references/protocols/sensitive-runtime-data-protection.md`

## 根因

CloudBase 网关可能在云托管 / 容器请求中注入 `x-cloudbase-context`（base64，可含临时云密钥）。业务代码若像 httpbin 一样原样返回请求头，或把 `process.env` 返回给客户端，攻击者即可获得账号下云资源访问权限。这与主动返回云函数环境变量属于同一类开发者侧泄露。

## SKILL001

# SKILL001 `searchKnowledgeBase` 后必须 `Read` 完整文件内容

- **Module**: cross-cutting (skill-usage)
- **Severity**: warning
- **Stage**: code-generation

---

## 正则检查 (Lint)

`references/lint-rules/README.md` 中可选 lint 代码块的扫描条件：

- 检查 trace 或日志中是否有 `searchKnowledgeBase` 调用
- 检查对应的 skill 文件是否被 `Read` 过
- 如果 `searchKnowledgeBase(mode="skill")` 返回了文件路径但未 `Read` 该路径，触发 SKILL001

当前 lint 脚本暂不覆盖此项（需要解析 trace.json）。

## LLM 检查

请人工或 LLM 审查以下问题：

1. 本次开发过程中是否调用了 `searchKnowledgeBase(mode="skill")` 来查询 skill？
2. 如果是，是否 `Read` 了返回的完整 skill 文件路径？
3. `searchKnowledgeBase` 返回的通常是 skill 路径 + 元信息（name, description），**不是完整内容**。关键的 API 签名、参数说明、陷阱警告都在完整 SKILL.md 中。
4. 确认没有"搜到了但没读完"的情况。

## 修复指引

1. 调用 `searchKnowledgeBase(mode="skill", skillName="xxx")`
2. 从返回结果中提取 `absolute path`（如 `/Users/.../.claude/skills/xxx/SKILL.md`）
3. 执行 `Read` 工具，传入该绝对路径
4. 阅读完整内容后再写代码

## 根因

`searchKnowledgeBase(mode="skill")` 返回的内容以元信息为主（路径、标题、简介），不包含完整文档。agent 如果只依赖返回的片段就写代码，容易遗漏 skill 中的重要约束和陷阱。必须再 `Read` 一次拿到完整内容。

## PG-CR001

# PG-CR001 PG 表必须显式创建（CREATE TABLE）

- **Module**: postgresql
- **Severity**: error
- **Stage**: code-generation
- **适用于**: Web, CloudRun

---

## 正则检查 (Lint)

`references/lint-rules/README.md` 中可选 lint 代码块的扫描条件：

- 在项目所有 `.ts/.tsx/.js/.jsx` 文件中搜索 `db.from("表名")` 模式
- 如果发现 `db.from("articles")` 或 `db.from("posts")` 等调用
- 检查是否同时存在 `CREATE TABLE` / `createTable` / `executePgSql` / `manageMysqlDatabase` 等建表操作
- 如果只有 `db.from()` 调用但没有建表操作，触发 PG-CR001

## LLM 检查

请人工或 LLM 审查以下问题：

1. 项目代码中使用了哪些 PG 表名（`db.from("xxx")`）？
2. 这些表是否已在 PG 中被创建？
3. **建表前是否先检查了表结构？** 在 CREATE TABLE 之前，是否先调用了 `queryPgDatabase(action="sql", sql="SELECT column_name, data_type FROM information_schema.columns WHERE table_name='xxx'")` 确认表是否存在及其精确列名？
4. **是否依赖了 `CREATE TABLE IF NOT EXISTS` 的静默跳过行为？** 如果表已存在但列名不匹配（例如预期 `uid` 但实际是 `user_id`），`IF NOT EXISTS` 会静默跳过，导致所有 CRUD 查询用错字段名。必须使用 `ALTER TABLE` 或 `DROP TABLE ... CASCADE`（确认数据影响后）重建。
5. 建表是通过什么方式完成的？
   - MCP 工具 `executePgSql` 或 `manageMysqlDatabase`？
   - SQL 脚本？
   - ORM migration？
6. 表结构是否包含必要字段？
   - articles 表：`title`, `content`, `author_id`, `status`, `created_at`, `updated_at`
   - users 表：`id/uid`, `username`, `role`
7. 建表操作是否在实际 CRUD 调用**之前**执行？顺序对吗？

## 修复指引

通过 MCP 工具执行建表 SQL。对于 CloudBase PG 环境，使用 `managePgDatabase(action=execute, confirm=true)`；对于 MySQL 环境，使用 `manageMysqlDatabase(action=executeSQL)`。

示例 SQL：```sql
CREATE TABLE IF NOT EXISTS public.articles (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  summary TEXT,
  cover_image TEXT,
  content TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'draft',
  author_id TEXT NOT NULL,
  author_name TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

- 确保建表 SQL 在 CRUD 代码之前执行
- 如果已有 `db.from("users")` 调用但使用 CloudBase Auth 内置的 `auth.users` 表，可以不额外建表
- 业务角色扩展表（`user_roles` / `profiles` 等）仍需显式创建

## 根因

CloudBase PG 不会自动根据 `db.from("表名")` 建表。agent 写了 CRUD 代码但没有建表步骤，运行时所有查询都会返回 404。

## PG-CR002

# PG-CR002 RLS 策略不能只开启不配置

- **Module**: postgresql
- **Severity**: error
- **Stage**: code-generation
- **适用于**: Web, CloudRun

---

## 正则检查 (Lint)

不支持。RLS 策略的语义检查无法通过正则可靠判断，此规则仅通过 LLM 检查。

## LLM 检查

请人工或 LLM 审查以下问题：

1. 项目中是否在 PG 上启用了行级安全（RLS）？
2. 如果启用了 RLS，是否为每张表创建了对应的策略（policy）？
3. 检查策略是否覆盖了目标业务场景：

| 操作 | admin 策略 | editor 策略 |
|------|-----------|------------|
| SELECT | 所有文章可见 | 所有文章可见（或仅自己的？按需求） |
| INSERT | 可创建 | 可创建（author_id = uid） |
| UPDATE | 可更新所有 | 仅更新自己的（author_id = uid） |
| DELETE | 可删除所有 | 仅删除自己的（author_id = uid） |

4. **检查策略中是否使用了 `current_user` 或 `current_setting(...)`？** 这是常见错误！`current_user` 返回的是数据库角色名（如 `authenticated`），不是 CloudBase 认证用户 ID。必须使用 `auth.uid()`。
5. 检查策略是否使用了 `auth.uid()` 来获取当前用户 ID？
6. **检查 `auth.uid()` 与 owner 列的类型是否匹配。** CloudBase 的 `auth.uid()` 返回 **`text`**（不是 `uuid`，与 Supabase 不同）。owner 列应优先用 `varchar(64)` / `text`；若列类型是 `uuid`，策略中必须写 `auth.uid()::uuid`，否则会报 `operator does not exist: uuid = text`。当身份可能是微信 openid 等非 UUID 字符串时，不要用 `uuid` 列。
7. 仅开启了 RLS（`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`）但没有创建策略，等于拒绝所有访问。
8. 如果选择不放 RLS 而用在应用层（CRUD 代码中）做权限判断，确认后端/数据库层确实限制了 editor 只能操作自己的文章，而 admin 可以操作全部。

## 修复指引

```sql
-- 开启 RLS
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;

-- admin：所有操作放行（假设 admin 角色记录在业务角色表中）
CREATE POLICY admin_all ON public.articles
  FOR ALL
  USING (auth.uid() IN (
    SELECT uid FROM public.user_roles WHERE role = 'admin'
  ));

-- editor：只能操作自己的文章
CREATE POLICY editor_select ON public.articles
  FOR SELECT
  USING (true);  -- editor 可查看所有

CREATE POLICY editor_insert ON public.articles
  FOR INSERT
  WITH CHECK (author_id = auth.uid());

CREATE POLICY editor_update ON public.articles
  FOR UPDATE
  USING (author_id = auth.uid());

CREATE POLICY editor_delete ON public.articles
  FOR DELETE
  USING (author_id = auth.uid());
```

## 根因

只执行 `ENABLE ROW LEVEL SECURITY` 而不创建策略，所有操作会被默认拒绝（等同于 `FOR ALL USING (false)`）。agent 经常只做了"开启 RLS"这一步，但没创建实际策略。

## PG-CR003

# PG-CR003 PG Web 文件/图片上传需要 CloudBase 存储配置

- **Module**: postgresql
- **Severity**: warning
- **Stage**: code-generation
- **适用于**: Web

---

## 正则检查 (Lint)

`references/lint-rules/README.md` 中可选 lint 代码块的扫描条件：

- 检查项目中是否包含 `uploadFile` / `upload` / `storage` / 文件字段 URL 写入等关键词
- 如果存在上传逻辑，检查是否同时处理了：
  - 安全域名（`localhost`）
  - 存储初始化（`app.upload` / `cloudbase.upload`）
- 如果只有上传逻辑但没有安全域名和存储配置，触发 PG-CR003（仅 warning）

## LLM 检查

请人工或 LLM 审查以下问题：

1. 文件/图片上传用的是什么方式？
   - 浏览器直传到 CloudBase 存储？
   - 经过后端代理上传？
2. 如果使用浏览器直传，`localhost:5173`（Vite 默认端口）是否已加入安全域名？
3. 上传失败时是否有错误处理？是否会在 PG 记录创建/更新时静默失败但不提示用户？
4. 如果云存储尚未开通（`STORAGE_NOT_EXIST` 错误），是否先调用了存储相关 API 开通？
5. 上传后的 URL / fileID 是否正确写入对应 PG 记录字段？

## 修复指引

```typescript
// 1. 确保安全域名已配置（通过 MCP 或 CloudBase Console）
// 2. 检查存储是否已开通
// 3. 上传文件
// 具体上传 API 形态以当前 PG Web skill / SDK 文档为准
const result = await uploadFileOrImage(fileObject);
const uploadedUrlOrFileID = result.url || result.fileID;
```

## 根因

浏览器直传 CloudBase 存储需要：
1. 环境已开通存储资源
2. 当前访问 `host:port` 在安全域名白名单中
3. Vite 默认 `localhost:5173` 不在默认白名单中

agent 经常写了上传逻辑但忽略了安全域名配置，导致上传 403/跨域错误，而文章创建时又没做错误处理，让上传失败静默消失。

## PG-CR004

# PG-CR004 CloudBase PG 场景文件/图片上传推荐使用 Storage v3 API

- **Module**: postgresql (PG storage)
- **Severity**: mixed（`app.storage()` 为 error；旧式/非推荐上传 API 为 warning）
- **Stage**: code-generation
- **适用于**: Web + CloudBase PG 场景

---

## 正则检查 (Lint)

`references/lint-rules/README.md` 中可选 lint 代码块的扫描条件：

仅当项目使用 CloudBase PG（例如出现 `app.rdb()`、`.rdb()` 或 `db.from(...)`）时启用本规则：

- 如果代码中出现 `app.storage()`：记录 **error**。`app.storage` 是属性，不是函数。
- 如果 PG 场景上传逻辑中使用 `app.uploadFile(...)`：记录 **warning**。旧式顶层上传 API 不推荐用于 PG Web 文件/图片上传。
- 如果上传逻辑中出现 `storage.upload({ cloudPath, filePath })`：记录 **warning**。PG 场景推荐 Storage v3 的 `app.storage.from("bucket").upload("key", file)` 参数形态。

## LLM 检查

请人工或 LLM 审查以下问题：

1. 当前项目是否是 CloudBase PG Web 应用，并涉及文件/图片上传？
2. 上传实现是否优先使用 `app.storage.from("bucket").upload("key", file)`，并把 bucket 放在 `from()` 参数里？
3. 是否避免在 `upload(key, file)` 的 key 中重复 bucket 前缀？
4. 是否错误地把 `app.storage` 当函数调用为 `app.storage()`？
5. 是否使用了旧式 `app.uploadFile(...)`；如果使用，是否有明确理由且与当前 SDK/评测约束一致？
6. 上传返回结果是否被检查，失败时是否阻止文章继续保存？

## 修复指引

CloudBase PG Web 场景推荐使用以下模式：

```typescript
const storage = app.storage.from(bucketName)
const { data, error } = await storage.upload(path, file)

if (error) {
  throw new Error(error.message || "上传失败")
}
```

避免以下写法：

```typescript
// ❌ app.storage 不是函数
const storage = app.storage()

// ⚠️ PG Web 场景不推荐优先使用旧式顶层上传 API
await app.uploadFile({ cloudPath, filePath: file })

// ⚠️ 参数形态不符合推荐 Storage v3 API
await storage.upload({ cloudPath, filePath: file })
```

## 边界

这不是通用 CloudBase Storage 规则；它只适用于 CloudBase PG Web 这类需要在 PG 数据模型中关联文件/图片 URL 或 fileID 的场景。非 PG 场景是否使用其他 Storage API，应以对应 skill、SDK 文档和项目约束为准。

## 根因

CloudBase PG Web 场景中，文件/图片上传更适合走 Web Storage v3 API：`app.storage.from("bucket").upload("key", file)`，其中 bucket 必须放在 `from()` 参数中，`upload()` 的 key 不要重复 bucket 前缀。agent 容易从旧示例、顶层 storage API 或类型片段误推成 `app.storage()`、`app.uploadFile(...)` 或 `storage.upload({ cloudPath, filePath })`。其中 `app.storage()` 是确定性运行时错误；旧式 API 则不符合当前 PG 场景的推荐路径。

## PG-CR005

# PG-CR005 PG 模式下存储上传必须配置 storage.objects RLS

- **Module**: postgresql
- **Severity**: error
- **Stage**: code-generation
- **适用于**: Web (PG / pgstore)

---

## 正则检查 (Lint)

`references/lint-rules/README.md` 中可选 lint 代码块的扫描条件：

- 检查项目中是否包含 `uploadFile` / `upload` / `storage` / 文件字段 URL 写入等关键词
- 如果存在上传逻辑，检查项目文件中是否包含 `ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY` 或 `CREATE POLICY.*ON storage.objects` 或 `authenticated_upload`
- 如果只有上传逻辑但没有 storage RLS 配置语句，触发 PG-CR005（error）

## LLM 检查

请人工或 LLM 审查以下问题：

1. 项目是否运行在 CloudBase PG / pgstore 环境？
2. 如果是，存储桶创建后是否配置了 `storage.objects` 表的 RLS 策略？
3. 存储 RLS 策略是否至少允许认证用户上传（`FOR INSERT TO authenticated WITH CHECK (true)`）和读取（`FOR SELECT TO authenticated USING (true)`）？`TO authenticated` 已经是角色门，不需要重复调用 `auth.role()`。
4. 配置方式是否正确使用了 `managePgDatabase(action="execute", confirm=true)` 执行 SQL？不要使用 CloudBase 传统安全规则 API（`managePermissions` / `ModifyStorageSafeRule`），那是 NoSQL 环境用的。
5. 如果上传失败（`STORAGE_PERMISSION_DENIED`），是否检查了 storage RLS 配置？

## 修复指引

通过 `managePgDatabase(action="execute", confirm=true)` 执行以下 SQL：

```sql
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "authenticated_upload" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (true);

CREATE POLICY "authenticated_read" ON storage.objects
  FOR SELECT TO authenticated
  USING (true);
```

详细指引见 `cloud-storage-web/SKILL.md` "Post-bucket: storage RLS" 章节。

## 根因

PG / pgstore 模式下，存储权限通过 PostgreSQL RLS 在 `storage.objects` 表上控制（类似 Supabase Storage），**不是** CloudBase 传统 NoSQL 安全规则。默认 RLS 为 deny all，上传前必须配置允许策略，否则浏览器端 `app.uploadFile()` 会返回 `STORAGE_PERMISSION_DENIED`。Agent 通常只配置了数据库业务表（articles/user_roles）的 RLS，不知道存储桶也需要配置。

## STORAGE001

# STORAGE001 本地开发安全域名必须包含 `localhost:5173`

- **Module**: storage
- **Severity**: error
- **Stage**: config
- **适用于**: Web

---

## 正则检查 (Lint)

`references/lint-rules/README.md` 中可选 lint 代码块的扫描条件：

- 检查项目代码中是否包含 CloudBase 相关引用（`cloudbase` / `tcb` / `upload`）
- 如果是，检查所有文件的内容是否包含 `localhost:5173` 或 `CreateAuthDomain` 或 `authDomain`
- 如果都没有，触发 STORAGE001（仅在项目使用 CloudBase 时触发）

## LLM 检查

请人工或 LLM 审查以下问题：

1. 项目是否使用了 CloudBase 云存储？（上传文件、图片等）
2. 如果是，`localhost:5173`（Vite dev server 默认地址）是否已加入安全域名？
3. 加入方式：
   - 通过 MCP 的 `manageEnv(action="addSecurityDomain")` 工具（旧工具名 `envDomainManagement` 已废弃收编）？
   - 通过 CloudBase Console 手动添加？
   - 通过 `CreateAuthDomain` API？
4. 如果有其他开发端口（如 `5174`、`4173`），是否也加了？
5. 生产环境的域名是否也已在安全域名列表中？

## 修复指引

通过 MCP 工具 `manageEnv(action="addSecurityDomain", domains=[...])` 添加安全域名（旧工具名 `envDomainManagement` 已废弃），或通过 `CreateAuthDomain` API 添加：

```typescript
// 通过 CreateAuthDomain API
await cloudbase.commonService("tcb", TCB_VERSION).call({
  Action: "CreateAuthDomain",
  Param: {
    EnvId: envId,
    Domains: ["localhost:5173"],
  },
});
```

> 注意：`localhost:5173` 是 Vite 默认 dev server 地址。如果修改了 Vite 配置（如使用 `--port` 或 `--host`），需相应调整。

## 根因

CloudBase 安全域名机制会拦截未注册的 origin 发出的请求。Vite 默认的 `localhost:5173` 不在白名单中，浏览器直传 CloudBase 存储时会因跨域失败。agent 在写本地项目时需要主动把 dev server 地址加入安全域名。

## rule

---
name: cloudbase-code-review
description: "Code review and validation for CloudBase projects. After writing code for Web / miniprogram / CloudRun / cloud-function projects, call this skill to check for known pitfalls — auth guard misuse, missing database tables, RLS misconfiguration, storage domain setup, and SDK API misuse. Supports automated lint scripts (regex-based) + LLM semantic review."
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

# CloudBase Code Review

> **One-liner**: After implementing CloudBase features, call this skill to catch common mistakes before users do.

## When to use

Call this skill **after** completing a CloudBase implementation task, before declaring done:

- You implemented auth (login / register / route guard)
- You created database tables or wrote CRUD (NoSQL / PostgreSQL / MySQL)
- You set up CloudBase Storage (file upload, hosting)
- You configured security rules or RLS policies
- You wrote MCP-dependent code
- You wrote Cloud Function or CloudRun HTTP handlers (check for credential / header echo leaks)

## How it works

The skill runs in two layers:

| Layer | Method | Speed | What it catches |
|-------|--------|-------|-----------------|
| **Lint (optional)** | No executable script is shipped. If the user approves running lint, review the code block in `references/lint-rules/README.md`, copy it to a temporary local `cloudbase-lint.mjs`, then run `node cloudbase-lint.mjs --project-dir <path>` | Seconds | Deterministic regex checks — wrong API calls, missing configs, pattern mismatches |
| **LLM review** | Read each rule's "LLM 检查" section, inspect code semantically | Variable | Semantic issues — route guard logic, RLS completeness, architecture-level problems |

## Rule index

See `references/RULES_INDEX.md` for the full matrix (module × frontend type → applicable rules).

## Rule boundary

Do not promote a single failed run or case-specific workaround into a hard rule. A rule should be backed by stable SDK/API documentation, repeated failures, or deterministic runtime behavior. Case-specific observations belong in attribution reports; only broadly applicable constraints should enter `RULES_INDEX.md` or the optional lint checklist.

## Quick start

```bash
# Step 1: Read relevant rules for identified modules
#   references/rules/cross-cutting/AUTH001.md
#   references/rules/cross-cutting/SEC001.md
#   references/rules/postgresql/PG-CR001.md
#   ...

# Optional: if the user approves running lint, review the script code block in
# references/lint-rules/README.md, copy it to a temporary cloudbase-lint.mjs,
# then run: node cloudbase-lint.mjs --project-dir .

# Step 2: For each applicable rule, read the "LLM 检查" section
#         and manually inspect your code before claiming done.
```

## Rule format

Each rule `.md` file follows this structure:

```markdown
# RULE-ID Rule Name

- **Module**: which module (auth / postgresql / storage / ...)
- **Severity**: error | warning
- **Stage**: code-generation | deployment | config

## 正则检查 (Lint)

The condition checked by the optional script code block in `references/lint-rules/README.md`.

## LLM 检查

Semantic review prompt for human or LLM to evaluate.

## 修复指引

How to fix the issue.
```

## Reference index

All packaged reference files (required for skill lint reachability):

- [RULES_INDEX.md](references/RULES_INDEX.md)
- [lint-rules/README.md](references/lint-rules/README.md)
- [rules/cross-cutting/AUTH001.md](references/rules/cross-cutting/AUTH001.md)
- [rules/cross-cutting/SEC001.md](references/rules/cross-cutting/SEC001.md)
- [rules/cross-cutting/SKILL001.md](references/rules/cross-cutting/SKILL001.md)
- [rules/postgresql/PG-CR001.md](references/rules/postgresql/PG-CR001.md)
- [rules/postgresql/PG-CR002.md](references/rules/postgresql/PG-CR002.md)
- [rules/postgresql/PG-CR003.md](references/rules/postgresql/PG-CR003.md)
- [rules/postgresql/PG-CR004.md](references/rules/postgresql/PG-CR004.md)
- [rules/postgresql/PG-CR005.md](references/rules/postgresql/PG-CR005.md)
- [rules/storage/STORAGE001.md](references/rules/storage/STORAGE001.md)

## config-schema

# cloudbaserc — Declarative Config Schema

The `cloudbaserc` config declares the **desired state** of a CloudBase project.
Supported file formats (searched from `cwd` downward): `cloudbaserc.json`,
`cloudbaserc.yaml`, `cloudbaserc.yml`, `cloudbaserc.js`.

> Local-mode note: `deployPlan` / `deployApply` discover these files from local `cwd`.
> In cloud-hosted MCP mode, those tools are not registered; use the cloud upload pipeline
> path described in `references/plan-and-apply.md` (no local `cwd` / filesystem execution).
> The config contract remains the same desired-state model.

`deployBuild` / `deployApply` / `deployPlan` validate the parsed config against the official
cloudbaserc schema before building / applying. A schema failure aborts with the offending
field path and reason.

> Official schema source: `https://static.cloudbase.net/cli/cloudbaserc.schema.json` (JSON Schema Draft-07)

## Top-level fields (official schema)

Top-level `required` is empty (no globally required field), but some conditional branches make
specific fields required in certain function image build scenarios.

| field | purpose |
|-------|---------|
| `$schema` | JSON Schema declaration for tooling/IDE validation |
| `version` | config schema version (official schema currently enumerates `"2.1"`) |
| `envId` | target environment ID (can be overridden by an explicit tool param) |
| `region` | target region (official enum includes `ap-shanghai` / `ap-guangzhou`) |
| `functionRoot` | base dir for cloud function code |
| `functionDefaultConfig` | defaults merged into every entry under `functions` |
| `functions` | array of cloud function definitions |
| `hosting` | hosting site definitions |
| `integrations` | integration definitions |
| `database` | database config (e.g. migration path) |
| `gateway` | gateway route config |
| `envOverrides` | per-`mode` overrides merged in when a matching `mode` is passed |
| `servers` | local/dev server settings |
| `app` | cloud app deployment config |
| `ai` | AI-related config |
| `privateSettings` | private settings |
| `lowcodeCustomComponents` | lowcode custom component config |

The resource sections the deploy orchestrator understands, in dependency order:

```text
database → functions → app → hosting → gateway
```

Use `only` / `skip` on the tools to restrict which of these sections are processed.

## functions

Each entry describes one cloud function. `functionDefaultConfig` is merged into every
entry (entry-level values win).

### Core function notes

- Function entry required field: `name`
- Common fields include: `type`, `runtime`, `handler`, `entry`, `timeout`, `memorySize`,
  `envVariables`, `triggers`, `vpc`, `buildStrategy`, `imageConfig`
- `type` enum: `Event` / `HTTP`
- `buildStrategy` enum: `zip` / `cloud` / `local` / `image`
- Runtime enum includes Node.js, Python, Java, Go, and `CustomImage` (follow official schema as source of truth)

Declarative image/HTTP functions are passed through without flattening — do not manually inline
`imageConfig` fields.

```jsonc
{
  "functionDefaultConfig": { "timeout": 5 },
  "functions": [
    { "name": "fn-a" },                 // inherits timeout: 5
    { "name": "fn-b", "timeout": 10 },  // overrides to 10
    {
      "name": "fn-image",
      "type": "HTTP",
      "buildStrategy": "local",
      "imageConfig": {
        "imageType": "enterprise",
        "registryId": "reg-1",
        "build": { "dockerfile": "Dockerfile", "repository": "ns/app" }
      }
    }
  ]
}
```

### Function image constraints (official schema highlights)

- If `runtime = CustomImage`, both `buildStrategy` and `imageConfig` are required.
- If `buildStrategy = image`, `imageConfig.imageUri` is required.
- If `buildStrategy = cloud` or `local`, `imageConfig.build` is required.
- If `buildStrategy = local`, `imageConfig.build.repository` is also required.
- For enterprise image paths (`imageType = enterprise` with image build flows),
  registry identity is required (`registryId` or `build.registryId`).

There is also a top-level conditional rule in the official schema:
- In personal cloud image build scenarios (e.g. `buildStrategy = cloud` + `imageType = personal`),
  top-level `envId` becomes required.

## Other resource sections (schema quick view)

- `database`: currently constrained to `type = postgresql`; supports `migrations` path.
- `hosting`: per-entry `name` required; supports `root`, `framework`, `installCommand`,
  `buildCommand`, `outputDir`, `deployPath`, `envVariables`, `ignore`.
- `app`: supports `root`, `serviceName`, `framework`, `installCommand`, `buildCommand`,
  `outputDir`, `deployPath`, `envVariables`, `ignore`.

Build/install fields are declarative intent in the spec. Execution side depends on
resource path: some flows execute locally, while cloud-mode-compatible flows execute in
cloud pipeline (staticCmd declarations) or consume prebuilt artifacts.
- `gateway`: built around `routes[]`; each route requires `path` and `target`, with
  protocol/auth/QPS-related constraints.

## Template variables

The parser renders `{{env.*}}` and `{{tcb.*}}` template variables, loading
`.env` / `.env.local` / `.env.<mode>` from the project root.
Keep secrets in env files, never hard-coded in `cloudbaserc`.


## multi-env

# Multi-Environment Deploy

## mode + envOverrides

Pass `mode` (e.g. `production`, `staging`) to merge the matching `envOverrides.<mode>`
block into the base config. When no `mode` is passed, the base config is used untouched
and `envOverrides` is not applied.

```jsonc
{
  "envId": "env-base",
  "functions": [ { "name": "api" } ],
  "envOverrides": {
    "staging":    { "envId": "env-staging" },
    "production": { "envId": "env-prod" }
  }
}
```

- `deployPlan({ mode: "staging" })` → effective `envId` becomes `env-staging`, and the
  merged config no longer carries the raw `envOverrides` block.
- `deployPlan({})` (no mode) → `envId` stays `env-base`, `envOverrides` untouched.

## envId resolution priority

```
explicit envId param  >  (merged) cloudbaserc envId  >  logged-in / bound environment
```

1. If the tool is called with an explicit `envId`, it wins over everything.
2. Otherwise the `envId` in the (mode-merged) config is used.
3. Otherwise the current MCP login / bound environment is used.
4. If none resolve, the tool errors:
   > 未能确定部署环境 ID：请在 cloudbaserc 配置 envId、通过 envId 参数指定，或先登录并绑定环境。

**Always confirm the resolved envId with the user before applying to production.** An
explicit `envId` param lets you deploy an `envId`-less config against a chosen environment
without editing the config file.

## Env-specific variables

The parser loads `.env`, `.env.local`, and `.env.<mode>` from the project root and renders
`{{env.*}}` / `{{tcb.*}}` template variables in the config. Use `.env.<mode>` to supply
per-environment values (keys, endpoints) without duplicating whole config blocks.

Keep all secrets in env files; never hard-code them in `cloudbaserc`.

## Typical multi-env flow

```
# preview staging
deployPlan({ mode: "staging" })
# apply staging
deployApply({ confirm: true, mode: "staging" })

# preview production (confirm envId with user first)
deployPlan({ mode: "production" })
# apply production
deployApply({ confirm: true, mode: "production" })
```

## plan-and-apply

# Build → Plan → Apply: deployBuild, deployPlan & deployApply

Three MCP tools implement the declarative flow. **Build first when hosting needs it,
then always run `deployPlan` before applying.**

## deployBuild (local hosting build)

Parses `cloudbaserc`, and for every `hosting` item that resolves a `buildCommand`
(explicit config > framework mapping > package.json auto-detection) executes that
command locally. It does **not** install dependencies and does **not** upload.

Parameters:

| param | type | notes |
|-------|------|-------|
| `cwd` | string? | project root; defaults to current working dir |
| `mode` | string? | env name; merges `envOverrides.<mode>` when matched |

Notes:

- Pure-static `hosting` items (no `buildCommand`) are skipped — nothing to build.
- No `envId` resolution and no login required: it never calls the cloud.
- A missing `node_modules` when `package.json` declares dependencies fails with
  `DEPENDENCY_NOT_INSTALLED` (run install first; `deployBuild` never installs for you).
- A failed build command fails with `BUILD_FAILED`.
- `deployApply` no longer runs hosting builds implicitly: after source changes, run
  `deployBuild` again so the uploaded artifact is fresh.

## deployPlan (read-only dry-run)

Parses `cloudbaserc`, validates it, resolves `envId`, and computes the plan **without
making any change**.

> `deployBuild` / `deployPlan` / `deployApply` are local-form tools. In cloud-hosted MCP
> mode they are intentionally not registered; use the cloud upload-channel fallback
> below.

Parameters:

| param | type | notes |
|-------|------|-------|
| `cwd` | string? | project root; defaults to current working dir |
| `mode` | string? | env name; merges `envOverrides.<mode>` when matched |
| `envId` | string? | overrides the cloudbaserc `envId`; else config value or bound env |
| `only` | (database\|functions\|app\|hosting\|gateway)[]? | compute plan for these only |
| `skip` | same enum[]? | skip these resource types |
| `yes` | boolean? | align with `deployApply` `yes`: recompute the effective action for existing functions. `false` (default) previews them as `skip`; `true` previews them as `update` |

Returns `{ cwd, mode, envId, yes, plan }` where `plan` is a list of entries like:

```json
{ "type": "functions", "name": "fn-a", "status": "create", "action": "新建" }
```

The plan is already reconciled to the *actual* action `deployApply` would take: with
`yes` unset, an already-existing function is reported as `skip` (with `declaredStatus:
"update"` preserved), so the preview never contradicts the execution.

See `SKILL.md` for the meaning of each `status` (create / update / skip / conflict / deploy).

## deployApply (destructive write)

Applies the plan in dependency order: database → functions → app → hosting → gateway.
This is the **local-form apply** (reads the local `cloudbaserc` and builds the upload
artifact locally); it is the execution counterpart of `deployPlan`.

Parameters:

| param | type | notes |
|-------|------|-------|
| `confirm` | boolean | **required `true`**, otherwise the call is rejected |
| `confirmDestructive` | boolean? | **required `true`** when a pending database migration contains destructive SQL (DROP/TRUNCATE/DELETE, ALTER…DROP/RENAME); otherwise the call is rejected and lists the offending migrations. No effect when no destructive migration is pending |
| `cwd` | string? | project root; defaults to current working dir |
| `mode` | string? | env name; merges `envOverrides.<mode>` |
| `envId` | string? | overrides cloudbaserc `envId`; else config value or bound env |
| `only` | enum[]? | deploy only these resource types |
| `skip` | enum[]? | skip these resource types |
| `yes` | boolean? | on existing resource: `true`=overwrite/update; `false` (default)=skip conservatively |
| `concurrency` | int ≥ 1? | max parallelism for same-type resources; default 1 (serial) |
| `continueOnError` | boolean? | keep going after a non-database failure; database failure always aborts |

### Safety rules

- Without `confirm=true`, `deployApply` throws and does nothing — this is intentional.
- A pending destructive database migration additionally requires `confirmDestructive=true`
  on top of `confirm=true`; back up or review first.
- `yes=false` (default) never overwrites existing resources in a non-interactive context.
- `concurrency` only parallelizes within one resource type; cross-type order is preserved.
- A database-stage failure aborts the whole deploy even with `continueOnError=true`.

## Build-first mental model

Do not model declarative deploy as only `plan → apply`. Operationally, use:

```text
build → plan → apply
```

Where build runs depends on resource and path:

- `hosting`: run `deployBuild` first (local build when `buildCommand` exists), then
  `deployApply` uploads the artifacts. A missing output aborts apply with
  `BUILD_OUTPUT_NOT_FOUND` and directs you back to `deployBuild`
- `app` (`framework=static`): local/prebuilt artifacts uploaded directly
- `app` (non-static): source package uploaded, cloud pipeline builds and deploys
- `functions`: path depends on `buildStrategy` (`zip`/`cloud`/`local`/`image`)

## Cloud-hosted upload pipeline path (not local-form deployPlan/deployApply)

In cloud-hosted MCP mode, `deployBuild` / `deployPlan` / `deployApply` are intentionally not
registered.
Treat this as an **execution-channel switch**, not a change in declarative intent.

Use this supported cloud path:

1. `queryApps(action=getUploadUrl)` to receive `uploadUrl`, `uploadHeaders`, `unixTimestamp`
2. Upload source/build package zip to `uploadUrl` using returned headers
3. `manageApps(action=deployApp, cosTimestamp=<unixTimestamp>, installCmd?, buildCmd?, deployCmd?)`

`installCmd` / `buildCmd` / `deployCmd` are pipeline declarations (staticCmd) executed by

## rule

---
name: cloudbase-declarative-deploy
description: CloudBase declarative deployment from a cloudbaserc config (声明式部署, 配置式部署, cloudbaserc 部署) through the deployBuild / deployPlan / deployApply MCP tools. Use when deploying database, functions, app, hosting, or gateway resources described in cloudbaserc.json/yaml as a single desired-state config, when a user wants to build static hosting artifacts locally first (deployBuild), or wants a dry-run plan before applying (deployPlan), or when handling multi-environment deploys via mode / envOverrides. Covers build-plan-apply flow (deployBuild local build → deployPlan dry-run → deployApply confirm=true), hosting build-output neutralization, envId resolution priority, only/skip filtering, concurrency, and continueOnError. Prefer deployBuild (when hosting declares a buildCommand) and deployPlan before deployApply; do not confuse with per-resource tcb CLI deploy or single-function deploy.
version: 2.35.2
license: MIT
alwaysApply: false
---

# CloudBase Declarative Deploy

Deploy a whole CloudBase project from one `cloudbaserc` config as **desired state**,
using the `deployBuild` (local hosting build), `deployPlan` (dry-run) and `deployApply`
(apply) MCP tools. The orchestrator applies resources in a fixed dependency order:

```
database → functions → app → hosting → gateway
```

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as
`../cloudbase-cli/SKILL.md`.

Cloud-hosted MCP mode does not guarantee access to a local workspace filesystem or
stable relative paths. If a referenced sibling file is not available in cloud mode,
use this skill's embedded guidance as source of truth and ask the user for any
missing constraints (or to install the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

**Cross-cutting protocols** (required before applying any deploy):
- Change Safety Protocol: `../cloudbase-platform/references/protocols/change-safety-protocol.md`
- Deployment Gate: `../cloudbase-platform/references/protocols/deployment-gate.md`

## When to use this skill

- The project has a `cloudbaserc.json` / `.yaml` / `.yml` / `.js` describing multiple
  resources, and the user wants to deploy them together as one config.
- The user asks for 声明式部署 / 配置式部署 / "deploy from cloudbaserc" / "deploy the whole project".
- The user wants to preview what a deploy will change before applying (dry-run plan).
- The user wants to build the static hosting artifact locally first (declarative
  hosting deploys no longer build implicitly — see `deployBuild`).
- Multi-environment deploy: production/staging via `mode` + `envOverrides`.

## Do NOT use for

- Deploying a single cloud function or one static site via `tcb` CLI → `../cloudbase-cli/SKILL.md`.
- In-app SDK integration (web/miniprogram/node) → the matching SDK skill.
- Console UI operations.

## Cloud mode

`deployBuild` / `deployPlan` / `deployApply` in this skill are the **local-form declarative
executor**. In cloud-hosted MCP mode these tools are intentionally not registered
(filtered at tool registration), because that runtime has no local `cwd` /
filesystem-bound execution path.

If you are in cloud mode and do not see `deployBuild` / `deployPlan` / `deployApply` in the
tool list, this is expected behavior.

Use the cloud upload-channel path instead:

1. `queryApps(action=getUploadUrl)` to get `uploadUrl`, `uploadHeaders`, `unixTimestamp`
2. Upload source/build zip to `uploadUrl` with returned headers
   - If cloud build requires private/offline dependencies, package `node_modules` explicitly
   - For public dependencies, uploading `package.json` + lockfile is typically enough
3. `manageApps(action=deployApp, cosTimestamp=<unixTimestamp>, installCmd?, buildCmd?, deployCmd?)`
   - `installCmd` / `buildCmd` / `deployCmd` are pipeline declarations executed in cloud container
   - Agent passes data + declarations; it does not execute local shell commands

Planned cloud declarative path (incremental roadmap): upload `cloudbaserc` as a data
artifact, then run server-side plan/apply orchestration. `deployApply` remains the
local-form executor of the same declarative spec.

For parameter details, see `references/plan-and-apply.md` (`Cloud-hosted upload pipeline path`).

## Core principles

1. **Plan before apply — always.**
   Run `deployPlan` first (dry-run, zero side effects). Read the per-resource action
   classification and show it to the user before calling `deployApply`.

2. **Apply requires explicit confirm.**
   `deployApply` will refuse unless `confirm=true` is passed. This is the destructive-write guard.

3. **Deployment Gate.**
   Before any apply, complete `cloudbase-platform/references/protocols/deployment-gate.md`
   and present the mandatory declaration.

4. **Conservative on existing resources by default.**
   `yes` defaults to `false` → existing resources are skipped, not overwritten. Only pass
   `yes=true` when the user explicitly wants to overwrite/update existing resources.

5. **database failure always aborts.**
   Even with `continueOnError=true`, a database-stage failure stops the whole deploy,
   because later resources depend on it.

6. **Resolve envId explicitly.**
   Never rely on implicit defaults silently — know which environment is targeted (see
   the priority table below) and confirm it with the user before applying.

## Plan action classification

`deployPlan` returns a list of resource entries. Each `status` means:

| status | meaning |
|--------|---------|
| `create` | new resource, will be created |
| `update` | exists, will be overwritten/updated |
| `skip` | no change needed |
| `conflict` | conflict detected — deploy will abort, must resolve first |
| `deploy` | direct overwrite upload |

If any entry is `conflict`, stop and resolve it before applying.

## envId resolution priority

```
explicit envId param  >  cloudbaserc `envId`  >  logged-in / bound environment
```

If none can be resolved, the tool errors out. Prefer confirming the resolved envId

## aggregation

# Aggregation Queries with CloudBase

This document explains how to perform aggregation operations for data analysis and statistics in CloudBase document database.

## Overview

Aggregation queries allow you to:
- Group data by specific fields
- Calculate statistics (count, sum, average, etc.)
- Transform and reshape data
- Perform complex data analysis

## Basic Aggregation Syntax

```javascript
const result = await db.collection('collectionName')
    .aggregate()
    .group({ /* grouping configuration */ })
    .end();

console.log('Results:', result.list);
```

**Note:** Aggregation queries use `.end()` instead of `.get()`

## Grouping Data

### Simple Grouping with Count

Count documents by a specific field:

```javascript
// Count todos by priority
const result = await db.collection('todos')
    .aggregate()
    .group({
        _id: '$priority',  // Group by priority field
        count: {
            $sum: 1        // Count documents in each group
        }
    })
    .end();

console.log('By priority:', result.list);
// Output: [
//   { _id: 'high', count: 15 },
//   { _id: 'medium', count: 23 },
//   { _id: 'low', count: 8 }
// ]
```

### Field Reference Syntax

Use `$` prefix to reference document fields:
- `$priority` - References the `priority` field
- `$status` - References the `status` field
- `$user.name` - References nested fields

## Aggregation Operators

### Accumulator Operators

| Operator | Description | Usage |
|----------|-------------|-------|
| `$sum` | Sum values | `{ total: { $sum: '$amount' } }` |
| `$avg` | Average values | `{ avgScore: { $avg: '$score' } }` |
| `$min` | Minimum value | `{ minPrice: { $min: '$price' } }` |
| `$max` | Maximum value | `{ maxPrice: { $max: '$price' } }` |
| `$first` | First value | `{ first: { $first: '$date' } }` |
| `$last` | Last value | `{ last: { $last: '$date' } }` |
| `$push` | Array of all values | `{ items: { $push: '$name' } }` |

## Common Aggregation Patterns

### Count by Category

```javascript
// Count users by role
const result = await db.collection('users')
    .aggregate()
    .group({
        _id: '$role',
        count: { $sum: 1 }
    })
    .end();
```

### Sum and Average

```javascript
// Calculate total and average order amount by customer
const result = await db.collection('orders')
    .aggregate()
    .group({
        _id: '$customerId',
        totalAmount: { $sum: '$amount' },
        averageAmount: { $avg: '$amount' },
        orderCount: { $sum: 1 }
    })
    .end();
```

### Find Min and Max

```javascript
// Find price range by product category
const result = await db.collection('products')
    .aggregate()
    .group({
        _id: '$category',
        minPrice: { $min: '$price' },
        maxPrice: { $max: '$price' },
        avgPrice: { $avg: '$price' }
    })
    .end();
```

### Multiple Groups

```javascript

## complex-queries

# Complex Queries with CloudBase

This document provides detailed guidance on constructing complex queries using CloudBase document database.

## Query Operators

Access operators through `db.command`:

```javascript
const _ = db.command;
```

### Comparison Operators

| Operator | Usage | Description |
|----------|-------|-------------|
| `gt` | `_.gt(value)` | Greater than |
| `gte` | `_.gte(value)` | Greater than or equal |
| `lt` | `_.lt(value)` | Less than |
| `lte` | `_.lte(value)` | Less than or equal |
| `eq` | `_.eq(value)` | Equal to |
| `neq` | `_.neq(value)` | Not equal to |

### Array Operators

| Operator | Usage | Description |
|----------|-------|-------------|
| `in` | `_.in([values])` | Value exists in array |
| `nin` | `_.nin([values])` | Value not in array |

## Building Complex Queries

### Multiple Conditions

Combine multiple conditions in the `where()` object:

```javascript
const result = await db.collection('todos')
    .where({
        // Age greater than 18
        age: _.gt(18),
        // Tags include 'tech' or 'study'
        tags: _.in(['tech', 'study']),
        // Created within last week
        createdAt: _.gte(new Date(Date.now() - 7 * 24 * 60 * 60 * 1000))
    })
    .get();
```

### Sorting Results

Use `orderBy()` to sort results:

```javascript
// Single field sorting
db.collection('posts')
    .orderBy('createdAt', 'desc')
    .get()

// Multiple field sorting (chain multiple orderBy calls)
db.collection('products')
    .orderBy('category', 'asc')
    .orderBy('price', 'desc')
    .get()
```

**Sort directions:**
- `'asc'` - Ascending order
- `'desc'` - Descending order

### Limiting Results

Control the number of results returned:

```javascript
// Limit to 10 results
db.collection('posts')
    .limit(10)
    .get()
```

**Limits:**
- Default: 100 records
- Maximum: 1000 records per query

### Field Selection

Optimize queries by selecting only needed fields:

```javascript
const result = await db.collection('users')
    .field({
        title: true,        // Include title
        completed: true,    // Include completed
        createdAt: true,    // Include createdAt
        _id: false          // Exclude _id
    })
    .get();
```

**Field selection rules:**
- `true` - Include field in results
- `false` - Exclude field from results
- If not specified, all fields are included by default

## Complete Complex Query Example

Here's a comprehensive example combining all query features:

```javascript
const _ = db.command;

const result = await db.collection('todos')
    .where({
        // Status must be 'active' or 'pending'
        status: _.in(['active', 'pending']),
        // Priority is high
        priority: 'high',
        // Age greater than 18
        age: _.gt(18),

## crud-operations

# CRUD Operations with CloudBase

This document covers Create, Update, and Delete operations for CloudBase document database.

## Create Operations

### Adding a Single Document

Add a new document to a collection:

```javascript
// Add a single document
// Note: _openid is automatically added by SDK, do not include it in the data
const result = await db.collection('todos').add({
    title: 'Learn CloudBase',
    description: 'Study the database API',
    completed: false,
    priority: 'high',
    createdAt: new Date()
    // _openid is automatically populated from authenticated user session
});

console.log('Added document with ID:', result._id);
```

**Return Value:**
```javascript
{
    _id: "generated-doc-id",  // Auto-generated document ID
    // ... other metadata
}
```

### Adding with Custom ID

Specify your own document ID:

```javascript
// Add with custom ID
const result = await db.collection('todos')
    .doc('custom-todo-id')
    .set({
        title: 'Custom ID Todo',
        completed: false,
        createdAt: new Date()
    });
```

**Note:** Use `.set()` with `.doc()` to specify a custom ID. If document exists, it will be overwritten.

### Adding Multiple Documents

Add multiple documents at once:

```javascript
// Batch add documents
const todos = [
    { title: 'Task 1', completed: false },
    { title: 'Task 2', completed: false },
    { title: 'Task 3', completed: true }
];

// Add one by one
for (const todo of todos) {
    await db.collection('todos').add(todo);
}

// Or use Promise.all for parallel insertion
const results = await Promise.all(
    todos.map(todo => db.collection('todos').add(todo))
);

console.log('Added', results.length, 'documents');
```

### Data Validation

Validate data before insertion:

```javascript
function validateTodo(todo) {
    if (!todo.title || todo.title.trim() === '') {
        throw new Error('Title is required');
    }
    if (typeof todo.completed !== 'boolean') {
        throw new Error('Completed must be a boolean');
    }
    return true;
}

async function addTodo(todoData) {
    try {
        validateTodo(todoData);
        
        const result = await db.collection('todos').add({
            ...todoData,
            createdAt: new Date(),
            updatedAt: new Date()
        });
        
        return result;
    } catch (error) {
        console.error('Failed to add todo:', error);
        throw error;
    }
}
```

## Update Operations

### Update by Document ID

Update a specific document by its ID:

```javascript
// Update by ID
// Note: Do not include _openid in update data - it cannot be modified
const result = await db.collection('todos')
    .doc('todo-id-123')
    .update({

## geolocation

# Geolocation Queries with CloudBase

This document explains how to work with geographic data and perform location-based queries in CloudBase.

## Prerequisites

**⚠️ CRITICAL**: Before performing any geolocation queries, you **MUST** create a geolocation index on the field you're querying. Queries will fail without proper indexing.

## Geographic Data Types

CloudBase supports several geographic data types through `db.Geo`:

```javascript
const db = app.database();
```

### Point (Single Location)

Represents a single geographic coordinate:

```javascript
// Create a Point: longitude, latitude
const point = new db.Geo.Point(116.404, 39.915);  // Tiananmen Square coordinates
```

**Note:** Coordinates are in `[longitude, latitude]` format (NOT latitude, longitude).

### LineString (Path/Route)

Represents a path or route:

```javascript
// Create a LineString (array of Points)
const line = new db.Geo.LineString([
    new db.Geo.Point(116.404, 39.915),  // Start
    new db.Geo.Point(116.405, 39.916),  // Waypoint
    new db.Geo.Point(116.406, 39.917)   // End
]);
```

### Polygon (Area)

Represents an enclosed area:

```javascript
// Create a Polygon (array of LineStrings, first is outer boundary)
const polygon = new db.Geo.Polygon([
    new db.Geo.LineString([
        new db.Geo.Point(116.404, 39.915),
        new db.Geo.Point(116.404, 39.916),
        new db.Geo.Point(116.405, 39.916),
        new db.Geo.Point(116.405, 39.915),
        new db.Geo.Point(116.404, 39.915)   // Must close the polygon
    ])
]);
```

**Note:** The first and last points must be identical to close the polygon.

## Storing Geographic Data

Store location data in documents:

```javascript
// Add a user with location
await db.collection('users').add({
    name: 'John',
    location: new db.Geo.Point(116.404, 39.915),
    address: 'Beijing, China'
});

// Add a delivery route
await db.collection('routes').add({
    name: 'Route A',
    path: new db.Geo.LineString([
        new db.Geo.Point(116.404, 39.915),
        new db.Geo.Point(116.405, 39.916),
        new db.Geo.Point(116.406, 39.917)
    ])
});

// Add a service area
await db.collection('serviceAreas').add({
    name: 'Downtown',
    area: new db.Geo.Polygon([
        new db.Geo.LineString([
            new db.Geo.Point(116.404, 39.915),
            new db.Geo.Point(116.404, 39.916),
            new db.Geo.Point(116.405, 39.916),
            new db.Geo.Point(116.405, 39.915),
            new db.Geo.Point(116.404, 39.915)
        ])
    ])
});
```

## Geolocation Query Operators

CloudBase provides three main geolocation query operators:

### 1. geoNear (Proximity Search)

Find documents near a specific location, ordered by distance:

```javascript
const _ = db.command;

// Find users within 1000 meters of a location
const result = await db.collection('users').where({
    location: _.geoNear({
        geometry: new db.Geo.Point(116.404, 39.915),  // Center point
        maxDistance: 1000,   // Maximum distance in meters
        minDistance: 0       // Minimum distance in meters
    })
}).get();

console.log('Nearby users:', result.data);
```

**Parameters:**

## pagination

# Pagination with CloudBase

This document explains how to implement pagination for large datasets in CloudBase document database.

## Basic Pagination Concepts

Pagination allows you to retrieve large datasets in smaller, manageable chunks (pages).

**Key Parameters:**
- `pageSize` - Number of records per page
- `pageNum` - Current page number (1-based)
- `skip()` - Number of records to skip
- `limit()` - Maximum records to return

## Simple Pagination Implementation

### Basic Page-based Query

```javascript
const pageSize = 10;  // Records per page
const pageNum = 1;    // Current page (1-based)

const result = await db.collection('todos')
    .orderBy('createdAt', 'desc')
    .skip((pageNum - 1) * pageSize)
    .limit(pageSize)
    .get();

console.log('Page', pageNum, 'data:', result.data);
```

### Calculation Formula

```javascript
// For page N:
const skip = (pageNum - 1) * pageSize;
const limit = pageSize;
```

## Complete Pagination Function

Here's a reusable pagination function:

```javascript
/**
 * Paginate through a collection
 * @param {string} collectionName - Name of the collection
 * @param {number} page - Page number (1-based)
 * @param {number} pageSize - Records per page
 * @param {object} whereConditions - Query conditions (optional)
 * @param {string} sortField - Field to sort by (optional)
 * @param {string} sortDirection - 'asc' or 'desc' (optional)
 */
async function paginateCollection(
    collectionName, 
    page = 1, 
    pageSize = 10,
    whereConditions = {},
    sortField = 'createdAt',
    sortDirection = 'desc'
) {
    const skip = (page - 1) * pageSize;
    
    let query = db.collection(collectionName);
    
    // Apply conditions if provided
    if (Object.keys(whereConditions).length > 0) {
        query = query.where(whereConditions);
    }
    
    // Apply sorting
    if (sortField) {
        query = query.orderBy(sortField, sortDirection);
    }
    
    // Apply pagination
    const result = await query
        .skip(skip)
        .limit(pageSize)
        .get();
    
    return {
        data: result.data,
        page: page,
        pageSize: pageSize,
        hasMore: result.data.length === pageSize
    };
}

// Usage
const pageData = await paginateCollection('todos', 2, 20, { status: 'active' });
console.log('Page 2 data:', pageData);
```

## Getting Total Count

To show "Page X of Y", you need the total count:

```javascript
async function paginateWithCount(collectionName, page, pageSize, whereConditions = {}) {
    const skip = (page - 1) * pageSize;
    
    // Get paginated data
    const dataQuery = db.collection(collectionName);
    const countQuery = db.collection(collectionName);
    
    if (Object.keys(whereConditions).length > 0) {
        dataQuery.where(whereConditions);
        countQuery.where(whereConditions);
    }
    
    // Execute both queries
    const [dataResult, countResult] = await Promise.all([
        dataQuery
            .orderBy('createdAt', 'desc')
            .skip(skip)
            .limit(pageSize)
            .get(),
        countQuery.count()
    ]);

## realtime

# Realtime Database with CloudBase

> **Scope:** this page documents document-database `collection.watch()` only — module `@cloudbase/js-sdk/realtime` (`registerRealtime`). PostgreSQL realtime through `app.realtime()` (Broadcast / Presence / Postgres CDC) is a **separate module** — `@cloudbase/js-sdk/realtime-js` (`registerRealtimeJs`) — and the two are not interchangeable. If the project is in PG mode, or the request mentions broadcast / presence / live table changes, read `../postgresql-development-cloudbase/references/realtime.md` instead.

CloudBase document database supports **real-time push** functionality that allows applications to listen to all update events for documents in a specified collection that match query conditions. When monitored documents undergo any changes (such as addition, modification, deletion), the client receives notifications in real-time, enabling real-time data synchronization and updates.

## Core Features

### Real-time Data Change Monitoring
- Listen to all change events for documents in a collection that match query conditions
- Support for all types of changes: addition, modification, deletion
- Automatically push change snapshots to clients

### Use Cases
- Chat applications
- Real-time collaborative editing
- Live interactive features
- Real-time dashboards
- Multiplayer game state synchronization

## Basic Usage

### 1. Establish Monitoring

Use the `.watch()` method on the collection reference to establish monitoring:

```javascript
// db is the database instance from cloudbase js client sdk 
const watcher = db.collection("todos") // Specify collection
  .where({ // Specify query conditions
    status: 'active',
    priority: _.in(['high', 'medium'])
  })
  .watch({
    onChange: function(snapshot) { // Data change callback
      console.log("Received data snapshot", snapshot);
      // Update your UI or process data here
      handleDataChange(snapshot);
    },
    onError: function(err) { // Error handling callback
      console.error("Monitoring closed due to error", err);
      // Handle errors, such as attempting to re-establish connection
      handleWatchError(err);
    }
  });
```

### 2. Close Monitoring

When you no longer need to monitor data changes, call the `watcher.close()` method:

```javascript
// Close monitoring when page or component unmounts
watcher.close();
```

## API Details

### watch(options)

Create a real-time data listener that returns a `watcher` object.

**Parameters:**
- `options.onChange` (Function): Callback function when data changes
- `options.onError` (Function): Callback function when monitoring encounters an error

**onChange callback parameter snapshot:**
```javascript
{
  docChanges: [
    {
      id: 'document-id',
      dataType: 'init' | 'update' | 'delete' | 'add',
      queueType: 'init' | 'update' | 'delete' | 'enqueue' | 'dequeue',
      doc: { // Document content after change
        // Document fields
      }
    },
    // More changes...
  ],
  docs: [ // All documents in the query result set
    // Document content...
  ]
}
```

**Change types in onChange callback:**
- `init`: Initialization, sends all data when first establishing connection
- `update`: Document content update
- `add`: New document added
- `delete`: Document deleted

**Watcher object methods:**
- `watcher.close()`: Close monitoring and release resources

## Best Practices

### 1. Specific Query Conditions

Set as specific query conditions as possible in the `.where()` method to monitor only the data changes you truly need:

```javascript
// Recommended: Specific query conditions
db.collection("messages")
  .where({
    chatRoomId: currentChatRoomId,
    isDeleted: false
  })
  .watch({...});

// Not recommended: Monitoring entire collection
db.collection("messages").watch({...});
```

### 2. Close Monitoring in a Timely Manner

Be sure to close monitoring when pages or components unmount to prevent memory leaks:

**React Component Example:**
```javascript

## rule

---
name: cloudbase-document-database-web-sdk
description: Use CloudBase document database Web SDK only for confirmed NoSQL collection work. Query, create, update, and delete document data; if the task mentions PostgreSQL / CloudBase PG / app.rdb(), route to postgresql-development instead.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

# CloudBase Document Database Web SDK

## Activation Contract

### Use this first when

- A browser or Web app must read or write CloudBase document database data through `@cloudbase/js-sdk`.
- The request mentions `app.database()`, `db.collection()`, `.where()`, `.watch()`, pagination, aggregation, or geolocation queries in a Web frontend.

### Read before writing code if

- The task is clearly browser-side, but you still need to decide between Web SDK, Mini Program SDK, or backend access.
- The request touches login state, collection permissions, or realtime updates.

### Then also read

- Web login and caller identity -> `../auth-web-cloudbase/SKILL.md`
- General Web app structure -> `../web-development/SKILL.md`
- Mini Program database code -> `../cloudbase-document-database-in-wechat-miniprogram/SKILL.md`

### Do NOT use for

- Mini Program code using `wx.cloud.database()`.
- Server-side or cloud-function database access.
- SQL / MySQL database operations.
- Pure resource-permission administration with no browser SDK code.
- **NEW business tables that the task explicitly asks to put in CloudBase PostgreSQL (CloudBase PG).** Before applying this skill, call `queryEnv(action="info", envId=...)` and read `EnvInfo.RuntimeBackends`. If `postgresql === true` AND the task asks for a new business table to live in PG, switch to the `postgresql-development-cloudbase` skill for that table: it goes through `app.rdb()`, uses PG row-level security (`CREATE POLICY`), and uploads via `app.storage.from('<bucket>').upload('<key>', file)` against an explicitly-created pgstore bucket.
  - Existing NoSQL collections in the same env keep using THIS skill — PG and NoSQL coexist in CloudBase PG environments. The rule is "follow the task / existing surface", not "PG env forbids NoSQL".

### SDK Code vs MCP Tools

**When to write SDK code (use this skill):**
- The task explicitly asks to "modify code" or "use SDK"
- The task asks to implement app/frontend logic
- The task mentions specific SDK methods like `db.collection().add()`, `.get()`, `.update()`
- The context shows an existing Web project with SDK initialization (e.g., `index.js` already has `cloudbase.init()`)

**When to use MCP tools instead:**
- The task asks to manage CloudBase resources (create collection, set permissions, etc.)
- The task involves admin/management operations without writing app code
- The task mentions tools like `writeNoSqlDatabaseContent`, `managePermissions`, etc.

**Key distinction:** If the user says "使用 JS SDK 执行 XX 操作" (use JS SDK to perform XX operation) or "修改代码" (modify code), write SDK code in the project files. Do not use MCP database write tools for app-level data operations.

### Common mistakes / gotchas

- Querying before the user is signed in when the collection rules require identity.
- Using `wx.cloud.database()` or Node SDK patterns in browser code.
- Initializing CloudBase lazily with dynamic imports instead of a shared synchronous app instance.
- Treating security rules as result filters rather than request validators.
- **Expecting a `CUSTOM` security rule to take effect immediately after you call `managePermissions(updateResourcePermission)`.** The backend caches rule evaluators for **2–5 minutes**; first writes after a rule change may silently fail or be rejected with `DATABASE_PERMISSION_DENIED` even when the expression is correct. Either (a) wait a few minutes and retry the same write before assuming the rule is wrong, or (b) verify the rule is live by reading `result.code` / `result.message` on every write and by doing a `get()` round-trip on the just-written `_id`; do not treat a resolved promise as success. See `security-rules.md` → "Propagation And Verification" for the full pattern.
- Misreading the return shape of `db.collection(...).add(...)`. In the CloudBase Web SDK, the created document ID is exposed at top-level `result._id`, not `result.id`, `result.data.id`, or `result.insertedId`.
- For CMS-style collections that need **app-level admin users** to edit/delete all records while editors can only edit/delete their own records, do not oversimplify the rule to `READONLY`. A validated pattern is a `CUSTOM` rule that reads role from `user_roles` by `auth.uid` and combines it with `doc.authorId == auth.uid`, while frontend writes can stay on `.doc(id).update()` / `.doc(id).remove()`.
- Forgetting pagination or indexes for larger collections.

### Minimal checklist

- Confirm this is browser-side document database work.
- Initialize CloudBase once and reuse the same `app` / `db` instance.
- Verify auth expectations before CRUD.
- Read the right companion reference file for the specific operation.

## Overview

This skill covers **browser-side document database usage** via `@cloudbase/js-sdk`.

Use it for:

- CRUD in a Web app
- complex queries and pagination
- aggregation
- realtime listeners with `watch()`
- geolocation queries

## Canonical initialization

```javascript
import cloudbase from "@cloudbase/js-sdk";

const app = cloudbase.init({
  env: "your-env-id"
});

const db = app.database();
const _ = db.command;
```

Important rules:

- Sign in before querying if the collection rules require identity.
- Keep a single shared app/database instance.
- Do not hide initialization inside ad-hoc async loaders unless the framework truly requires it.

## Quick routing

- CRUD -> `./crud-operations.md`
- Complex queries -> `./complex-queries.md`
- Pagination -> `./pagination.md`
- Aggregation -> `./aggregation.md`
- Realtime listeners -> `./realtime.md`
- Geolocation -> `./geolocation.md`
- Security rules -> `./security-rules.md`

## Working rules for a coding agent

1. **Start from the auth model**

## security-rules

# CloudBase NoSQL Database Security Rules

This document covers how to configure security rules for CloudBase NoSQL database collections to control read/write permissions.

## Overview

**Important:** To control database permissions, you **MUST** use `managePermissions(action="updateResourcePermission")` to configure security rules. Security rule changes take effect after a few minutes due to caching.

**General Rule:** In most cases, use **simple permissions** (READONLY, PRIVATE, ADMINWRITE, ADMINONLY). Only use CUSTOM rules when you need fine-grained control.

**Scope note:** The detailed semantics in this document apply only to CloudBase **NoSQL database collections** with `resourceType: "noSqlDatabase"`. Examples such as `doc._openid`, `auth.openid`, query-condition subset validation, and `create` / `update` / `delete` JSON rule templates are **not** generic rules for `function`, `storage`, or `sqlDatabase` resources.

**Official references:**
- General security rules overview: `https://cloud.tencent.com/document/product/876/41802`
- NoSQL database security rules: `https://docs.cloudbase.net/database/security-rules`
- Cloud function security rules: `https://docs.cloudbase.net/cloud-function/security-rules`
- Storage security rules: `https://docs.cloudbase.net/storage/security-rules`

### Critical Understanding: Query Condition Requirements

**Security rules are validation-based, NOT filter-based.**

For query or update operations, the **input query conditions must be a subset of the security rules**. The system does **not** actually fetch data from the database. Instead, it validates whether the input query conditions form a subset of the security rules. If the query conditions are not a subset of the rules, it indicates an attempt to access data without permission, and the operation will be **directly rejected**.

**Example:**
- If you define a read/write rule: `auth.openid == doc._openid`
- This means the query condition's `_openid` must equal the current user's `openid` (provided by the system-assigned, non-tamperable `auth.openid`)
- If the query condition doesn't include this constraint, it indicates an attempt to access records where `_openid` is not equal to the user's own, which will be rejected by the backend

**Key Points:**
- Security rules **validate** queries, they don't **filter** results
- The system performs **rule matching** before any database access
- Query conditions must match or be more restrictive than the security rule
- Missing required conditions in queries will result in permission denied errors
- For **create** operations, the system validates the **written data** against the security rules, not query conditions

## Data Permission Management System

CloudBase provides a multi-layered data permission management mechanism that ensures data security while meeting different business scenario permission control requirements.

### Permission Management Hierarchy

CloudBase data permission management includes two levels:

| Permission Type | Control Granularity | Applicable Scenarios | Configuration Complexity |
|----------------|---------------------|----------------------|--------------------------|
| **Basic Permission Control** | Collection level | Simple permission needs | Low |
| **Security Rules** | Document level | Complex business logic | High |

### Basic Permission Control

**Configuration Method:**
Configure permissions for each collection in the [CloudBase Platform](https://tcb.cloud.tencent.com/dev) collection management page.

**Permission Options:**

| Permission Type | Applicable Scenarios | Usage Recommendation |
|----------------|----------------------|----------------------|
| **Read all data, modify own data** | Public content, such as articles, products | Suitable for content display applications |
| **Read and modify own data** | Private data, such as user profiles | Suitable for personal information management |
| **Read all data, cannot modify** | Configuration data, such as system settings | Suitable for read-only configuration and reference data |
| **No permission** | Sensitive data, such as financial information | Suitable for sensitive data requiring server-side processing |

### Security Rules (CUSTOM)

**Function Overview:**

Security rules provide more flexible, extensible, and fine-grained permission control capabilities, supporting dynamic permission judgment based on document content.

**Core Features:**
- **Document-level control**: Can decide access permissions based on specific document content
- **Expression-driven**: Uses programming-like expressions to define permission logic
- **Dynamic permissions**: Supports dynamic permission judgment based on user identity, time, and data content
- **Client-only restriction**: Only restricts client user access, does not affect server-side (cloud function) operations

**Configuration Entry:**
Configure security rules in the [CloudBase Platform/Database](https://tcb.cloud.tencent.com/dev#/db/doc/model) collection management page.

## Permission Categories

CloudBase provides two types of permissions:

### 1. Simple Permissions (Recommended for Most Cases)

These are pre-configured permission templates that cover most common scenarios:

- **READONLY**: All users can read, only creator and admin can write
- **PRIVATE**: Only creator and admin can read/write
- **ADMINWRITE**: All users can read, only admin can write
- **ADMINONLY**: Only admin can read/write

### 2. Custom Security Rules (CUSTOM)

Use CUSTOM when you need fine-grained control based on document data, user identity, or complex conditions.

## Configuring Security Rules

### Using MCP Tool `managePermissions`

**Important:** When developing applications that need permission control, you **MUST** call `managePermissions(action="updateResourcePermission")` to configure database security rules. Do not assume permissions are already configured.

Compatibility note:
- Canonical plugin name: `permissions`
- Legacy plugin aliases `security-rule`, `security-rules`, `secret-rule`, `secret-rules`, and `access-control` still resolve to the `permissions` plugin
- Legacy tools `readSecurityRule` and `writeSecurityRule` are removed; use `queryPermissions` and `managePermissions`

**Scope reminder:** The examples below are for `resourceType: "noSqlDatabase"` only. Do not reuse NoSQL-only expressions such as `doc._openid`, `auth.openid`, query-subset validation, or `create` / `update` / `delete` rule templates as generic guidance for `function`, `storage`, or `sqlDatabase` permissions.

**Basic Usage:**

```javascript
// Example: Set simple permission (PRIVATE)
await managePermissions({
  action: "updateResourcePermission",
  resourceType: "noSqlDatabase",
  resourceId: "collectionName",  // Collection name
  permission: "PRIVATE",
  // securityRule parameter not needed for simple permissions
});
```

## rule

---
name: cloudbase-mcp
description: CloudBase MCP reference. Use when connecting local or remote MCP, calling tools from the shell with mcporter, reading tool schemas, choosing the domestic or international endpoint, setting site, region, cloud mode, or plugin flags, or contributing a fix to the open-source MCP server, skills, or CLI.
version: 2.35.2
license: MIT
alwaysApply: false
---

# CloudBase MCP

Open source:

- GitHub: https://github.com/TencentCloudBase/CloudBase-AI-ToolKit
- Domestic mirror: https://cnb.cool/tencent/cloud/cloudbase/CloudBase-AI-ToolKit

The server source is `mcp/` in that repo. The package name is `@cloudbase/cloudbase-mcp`.

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../cloudbase-cli/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

- MCP setup, mcporter commands, and auth examples: `../cloudbase/references/mcp-setup.md`
- CLI fallback when MCP tools are not loaded: `../cloudbase-cli/SKILL.md`
- MCP vs CLI decision tree: `../cloudbase/references/tooling-fallback.md`

## When to use

- The user is connecting MCP, or choosing local versus remote.
- The user or the agent calls CloudBase tools from the shell with mcporter, or needs a tool schema before calling.
- The user needs the site, region, cloud-mode, or plugin switches that already exist.
- A bug is in this repo's MCP server, skills, or CLI, and the fix should be a pull request.

## Do not use this for

- Creating or changing cloud resources. Use the matching domain skill, or `../cloudbase-cli/SKILL.md` when MCP tools are not loaded.
- Cloud platform, permission, or account problems that are not code in this repo. Those go to an issue, not a pull request.

## Connection

| Mode | Address |
|------|---------|
| Remote, domestic | `https://tcb-api.cloud.tencent.com/mcp/v1` |
| Remote, international | `https://tcb-api.tencentcloud.com/mcp/v1` |
| Local | `npx @cloudbase/cloudbase-mcp@latest` (Node.js 18.15+) |

The hostname decides the site. Remote URLs do not take a `site` query parameter.

- Interactive clients: put only the URL in the IDE config. The IDE opens a browser for login. This is the usual path.
- CI: add `env_id` and headers `X-TencentCloud-SecretId` / `X-TencentCloud-SecretKey`.
- Local stdio for the international site: `TCB_SITE=intl` and `TCB_REGION=ap-singapore`.

Remote mode cannot upload local files or download templates. The international site does not expose NoSQL tools.

## Calling tools with mcporter

When this session has no native MCP tools, use mcporter. The command list and the auth examples live in `../cloudbase/references/mcp-setup.md`. Read that file before login, environment binding, or `manageEnv`.

Check whether the server is configured:

```bash
npx mcporter list | grep cloudbase
```

If it is missing, add a stdio server named `cloudbase` in `config/mcporter.json`:

```json
{
  "mcpServers": {
    "cloudbase": {
      "command": "npx",
      "args": ["@cloudbase/cloudbase-mcp@latest"],
      "description": "CloudBase MCP",
      "lifecycle": "keep-alive"
    }
  }
}
```

Read the schema before the first call. `describe` without `--all-parameters` omits parameters.

```bash
npx mcporter describe cloudbase --all-parameters
npx mcporter list cloudbase --schema
```

Call a tool with `server.tool` and `key=value` arguments:

```bash
npx mcporter call cloudbase.queryEnv action=list --output json
```

Do not put a Secret ID, Secret Key, or environment ID into `mcporter.json`. Login stays on `cloudbase.auth` or `tcb login`, as written in `mcp-setup.md`.

## Environment

| Name | Effect |
|------|--------|
| `TCB_SITE` | `domestic` or `intl`. `ap-singapore` exists on both sites; a domestic Singapore environment must set `TCB_SITE=domestic`. |
| `TCB_REGION` | API region, such as `ap-shanghai` or `ap-singapore`. |
| `CLOUDBASE_MCP_CLOUD_MODE` or `MCP_CLOUD_MODE` | `true` disables local file and process tools for a self-hosted caller. |
| `CLOUDBASE_MCP_PLUGINS_ENABLED` / `CLOUDBASE_MCP_PLUGINS_DISABLED` | Comma-separated plugin names for a local server. |
| `enable_plugins` / `disable_plugins` | The same switch on a remote URL, comma-separated. |

Plugin names are the ones in `mcp/src/server.ts` (`env`, `database`, `functions`, `hosting`, `storage`, and the rest). A local server and a hosted remote server enable the same default set; turn one off for a given caller with `disable_plugins` on the remote URL or `CLOUDBASE_MCP_PLUGINS_DISABLED` on a local server.

## Contributing

Read `CONTRIBUTING.md` at the repo root. Fork, use a feature branch, and follow the commit types listed there (`feat`, `fix`, `docs`, and the rest). Install with corepack and `pnpm install`.

- A bug in MCP, a skill, or the CLI: open a pull request.
- The cloud platform, a permission, or the account: open an issue. Do not put an environment ID or a secret in the text.
- `prepareFeedback` only returns the new-issue page for the current site. Write the text in the chat. The user logs in and submits it.

## deployment-gate

# Deployment Gate

**Mandatory pre-check** for any deployment, release, public exposure, custom domain, CloudRun, or mini program upload/publish operations.

## When to Apply

You must read and complete this gate before:
- Deploying or updating CloudRun services
- Binding custom domains or enabling HTTPS
- Publishing static hosting
- Uploading or publishing mini programs via miniprogram-ci
- Exposing cloud functions or HTTP services publicly

**Rule**: Never proceed with deployment actions until you have checked the relevant items below and obtained user confirmation on all gaps.

## Pre-Check Tables by Scenario

### Custom Domain / HTTPS Access

| Check Item                          | Consequence if Missing              | Required Action                              |
|-------------------------------------|-------------------------------------|----------------------------------------------|
| Environment plan supports custom domains | Feature unavailable, repeated errors | Verify current plan tier                     |
| ICP filing completed                | Cannot bind domain                  | Complete ICP filing or choose alternative    |
| SSL certificate obtained + certificateId available | Binding fails                    | Retrieve certificateId from SSL console      |

**Critical distinction**:
- Security Domain (`envDomainManagement`) ≠ Custom Domain (`manageGateway` bindCustomDomain action)

### CloudRun (Container Services)

| Check Item                          | Consequence if Missing              | Required Action                              |
|-------------------------------------|-------------------------------------|----------------------------------------------|
| Application port matches Dockerfile / code | Startup failure or 502           | Confirm listening port (commonly 9000)       |
| Health check path correctly configured | Frequent restarts / unhealthy     | Set correct path (e.g. `/` or `/health`)     |
| Required environment variables and secrets injected | Runtime errors                 | Configure via console or MCP before deploy   |

### Static Website Hosting

| Check Item                          | Consequence if Missing              | Required Action                              |
|-------------------------------------|-------------------------------------|----------------------------------------------|
| Content-Disposition / caching headers suitable for public web access | Files download instead of render | Verify ACL and response headers              |
| Custom domain required              | Must complete domain + SSL checks first | Warn user before starting                    |

### Mini Program Upload / Publish (miniprogram-ci)

| Check Item                          | Consequence if Missing              | Required Action                              |
|-------------------------------------|-------------------------------------|----------------------------------------------|
| Upload IP added to mini program whitelist | Upload rejected                  | Add current egress IP in WeChat backend      |
| AppID matches target environment    | Publishing to wrong app             | Double-check `project.config.json`           |

### Cloud Functions Public Exposure / HTTP Access

| Check Item                          | Consequence if Missing              | Required Action                              |
|-------------------------------------|-------------------------------------|----------------------------------------------|
| Function security rule configured to allow required callers | `EXCEED_AUTHORITY` errors     | Configure via `managePermissions` immediately after creation |
| Anonymous login status understood   | Public access unexpectedly blocked  | Explicitly inform user (disabled by default on new environments) |

## Mandatory Declaration Template

Before starting any deployment-related work, you must output something like this and wait for user confirmation:

> This deployment has the following prerequisites. Please confirm:
> - [ ] Plan supports required features (custom domain, CloudRun, etc.)
> - [ ] ICP filing and SSL certificate ready (if using custom domain)
> - [ ] CloudRun port and health check configured
> - [ ] Mini program upload IP whitelist updated (if applicable)
> - [ ] Function / hosting security rules configured for public access
>
> Any missing item above will very likely cause deployment failure. Proceed?

## Usage Instruction

When the task involves deployment, publishing, custom domains, CloudRun, or public exposure:

> Before any deployment or publish action, you must first complete the full checks in `cloudbase-platform/deployment-gate.md` and present the declaration template to the user.

## change-safety-protocol

# Change Safety Protocol

**Mandatory protocol** for all non-trivial code and configuration changes.

## When This Protocol Applies

You must follow this protocol for any of the following:
- Changes to data models, fields, query conditions, or schemas
- Modifications to permissions, security rules, or access control
- Changes to authentication flows, login methods, or user management
- Interface contracts, function signatures, or API behavior changes
- Deployment configuration, environment variables, routing, or hosting settings

**Exempt** for purely trivial edits (text changes, comments, logs, formatting, or debug statements).

## Required Steps (Non-Negotiable)

1. **Before making any edits**, explicitly declare the impact in one clear sentence:
   > This change affects: [specific files / fields / permissions / contracts / behavior]

2. **Obtain explicit user confirmation** before proceeding with any code or configuration changes.

3. **After editing**, immediately perform verification:
   - Run syntax or type checking
   - Execute at least one minimal verification case
   - Confirm that no new errors were introduced

4. **Escalation rule (hard stop)**
   - If the same root-cause symptom occurs **3 or more times** during this task → **stop patching immediately**.
   - You must output:
     - One-sentence root cause analysis
     - Complete scope of impact
     - Recommended holistic fix (do not continue making incremental patches)

## Recommended Response Templates

**Before editing:**
> This change affects: [xxx]. Do you confirm I should proceed?

**After verification:**
> Syntax check and minimal verification case completed. Change is effective.

**When escalation triggers:**
> The same issue has recurred 3 times. Stopping incremental fixes. Root cause analysis: ...

## Purpose

This protocol exists to eliminate endless correction loops and repeated trial-and-error. It enforces structured thinking and significantly reduces decision entropy while maintaining very low token cost.

**Usage instruction:**
> Before any non-trivial code or configuration change, strictly follow the Change Safety Protocol in `cloudbase-platform/references/protocols/change-safety-protocol.md`.

## deployment-gate

# Deployment Gate

**Mandatory pre-check** for any deployment, release, public exposure, custom domain, CloudRun, or mini program upload/publish operations.

## When to Apply

You must read and complete this gate before:
- Deploying or updating CloudRun services
- Binding custom domains or enabling HTTPS
- Publishing static hosting
- Uploading or publishing mini programs via miniprogram-ci
- Exposing cloud functions or HTTP services publicly

**Rule**: Never proceed with deployment actions until you have checked the relevant items below and obtained user confirmation on all gaps.

## Pre-Check Tables by Scenario

### Custom Domain / HTTPS Access

| Check Item                          | Consequence if Missing              | Required Action                              |
|-------------------------------------|-------------------------------------|----------------------------------------------|
| Environment plan supports custom domains | Feature unavailable, repeated errors | Verify current plan tier                     |
| Existing custom domain reusable?    | Unnecessary re-bind / cert prompts  | `queryGateway(listCustomDomains)` first; if one exists, `createRoute(domain=...)` — no certificateId |
| ICP filing completed                | Cannot bind **new** domain          | Complete ICP filing or choose alternative    |
| SSL certificate obtained + certificateId available | **New** domain bind fails        | Only when first-time `bindCustomDomain`; retrieve certificateId from SSL console |

**Critical distinction**:
- Security Domain (`manageEnv` action=addSecurityDomain/removeSecurityDomain; deprecated alias `envDomainManagement`) ≠ Custom Domain (`manageGateway` Domain/Route)
- Reusing an existing custom domain = `createRoute` (no cert). Binding a brand-new custom domain = `bindCustomDomain` (needs certificateId).

### CloudRun (Container Services)

| Check Item                          | Consequence if Missing              | Required Action                              |
|-------------------------------------|-------------------------------------|----------------------------------------------|
| Application port matches Dockerfile / code | Startup failure or 502           | Confirm listening port (commonly 9000)       |
| Health check path correctly configured | Frequent restarts / unhealthy     | Set correct path (e.g. `/` or `/health`)     |
| Required environment variables and secrets injected | Runtime errors                 | Configure via console or MCP before deploy   |
| No httpbin / header-echo / env-dump endpoints | `x-cloudbase-context` temporary credentials leak to callers | Follow `sensitive-runtime-data-protection.md`; health checks must return fixed non-secret payloads only |
| TCP DB/cache dependency detected (`DATABASE_URL`, MySQL/PG/Redis host) | Deploy succeeds but runtime cannot reach DB | Set `serverConfig.VpcConf` to the DB's VPC/subnet; use private DB host; see `cloudrun-development/references/vpc-and-database.md` |
| `OpenAccessTypes` vs `VpcConf` understood | Agent configures public ingress but omits private network | Ingress (`OpenAccessTypes`) ≠ egress VPC (`VpcConf`); both may be required |

### Static Website Hosting

| Check Item                          | Consequence if Missing              | Required Action                              |
|-------------------------------------|-------------------------------------|----------------------------------------------|
| Content-Disposition / caching headers suitable for public web access | Files download instead of render | Verify ACL and response headers              |
| Custom domain required              | Must complete domain + SSL checks first | Warn user before starting                    |

### Mini Program Upload / Publish (miniprogram-ci)

| Check Item                          | Consequence if Missing              | Required Action                              |
|-------------------------------------|-------------------------------------|----------------------------------------------|
| Upload IP added to mini program whitelist | Upload rejected                  | Add current egress IP in WeChat backend      |
| AppID matches target environment    | Publishing to wrong app             | Double-check `project.config.json`           |

### Cloud Functions Public Exposure / HTTP Access

| Check Item                          | Consequence if Missing              | Required Action                              |
|-------------------------------------|-------------------------------------|----------------------------------------------|
| Function security rule configured to allow required callers | `EXCEED_AUTHORITY` errors     | Configure via `managePermissions` immediately after creation |
| Anonymous login status understood   | Public access unexpectedly blocked  | Explicitly inform user (disabled by default on new environments) |
| Responses do not echo headers / env / `x-cloudbase-context` | Temporary credential leak     | Follow `sensitive-runtime-data-protection.md` before public exposure |
| Non-native TCP DB/cache env (`DATABASE_URL`, MySQL/PG/Redis host) without `vpc` | Deploy succeeds but runtime cannot reach private DB | Set real `vpc.vpcId` + `vpc.subnetId` from DB console / resource detail / user — never invent IDs; see `cloud-functions/references/vpc-and-tcp-database.md`. Native `app.rdb()` / `app.database()` does not need VPC. |

## Mandatory Declaration Template

Before starting any deployment-related work, you must output something like this and wait for user confirmation:

> This deployment has the following prerequisites. Please confirm:
> - [ ] Plan supports required features (custom domain, CloudRun, etc.)
> - [ ] ICP filing and SSL certificate ready (if using custom domain)
> - [ ] CloudRun port and health check configured
> - [ ] If CloudRun or cloud functions use TCP MySQL/PostgreSQL/Redis (non-native SDK): real VPC + subnet IDs + private DB endpoint ready (do not invent IDs)
> - [ ] Mini program upload IP whitelist updated (if applicable)
> - [ ] Function / hosting security rules configured for public access
>
> Any missing item above will very likely cause deployment failure. Proceed?

## Usage Instruction

When the task involves deployment, publishing, custom domains, CloudRun, or public exposure:

> Before any deployment or publish action, you must first complete the full checks in `cloudbase-platform/references/protocols/deployment-gate.md` and present the declaration template to the user.

## Post-Deployment: Deployment Share (optional, non-intrusive)

After a deployment is **verified successful** (public URL reachable, or mini program upload/publish done), you may — **at most once** — offer to generate anonymized, shareable deliverables (a visual card + paste-ready share copy). If the user declines or ignores, stop immediately. Publishing is always a manual user action; never post on the user's behalf.

Full trigger/boundary rules, required information, anonymization red lines, and deliverable formats: `deployment-share.md` (same directory).

## deployment-share

# Deployment Share (Post-Deployment, Optional)

A soft, non-intrusive flow for turning a verified deployment milestone into anonymized, shareable deliverables. The goal: willing users can share a reproducible result; no user ever feels pushed.

## Trigger & Boundaries

- Only after a deployment is **verified successful** (public URL reachable, or mini program upload/publish completed), offer **at most once**. Do not ask the same thing twice in one session.
- If the user declines or ignores, stop immediately — never follow up.
- Generate shareables only after the user asks for them (or clicks the share action on the deployment card). **Never post on the user's behalf**, and never fill the form for them: submission is theirs to do.
- Never delay, bloat, or overshadow the deployment report itself. This is a closing pleasantry, not a step of the deployment workflow.

## Two Modes

Pick the mode the user's request implies; do not make them ask twice.

- **One round (default)** — deliver the visual card, the paste-ready copy **and** the case-wall submission entry (`prepareFeedback` with `channel="case"`) together in a single reply. The user reads it, decides, and submits by hand if they want. Asking a second time just to hand over a link the user can ignore costs a whole turn and reads as nagging.
- **Shareables only (on demand)** — if the user asked for the card/copy alone, or said they do not want to submit anywhere, stop after the deliverables and do not bring up the case wall again in this session.

In both modes the draft is shown in full before anything else, and the entry is a link the user opens while signed in — we never submit, never prefill, never post.

## Required Information (both deliverables must cover all items)

1. Agent / CLI used
2. Project type (one sentence)
3. CloudBase resources used (e.g. static hosting, database, auth)
4. Deploy duration (distinguish cloud build time from end-to-end time)
5. At least one piece of **real process evidence** (terminal output, build ID, or deployment log lines)
6. **Reproduction path**: complete down to prerequisite steps such as connector / account authorization — not just the final one-line command. Include the toolkit docs link: https://docs.cloudbase.net/ai/cloudbase-ai-toolkit/
7. **Key pitfalls resolved** along the way (1–2, optional but strongly recommended — the main source of content credibility)

## Default Exclusions (Anonymization Red Lines)

- Environment ID, secrets, credentials, private source code, user data, internal domains
- Public URL: include only after the user confirms the address is intended to be public

## Deliverables (generate both at once)

- **Visual card**: single-file HTML, portrait aspect ratio, ready to open and screenshot. Colors, layout, and typography are unconstrained; echoing the deployed app's visual style is encouraged.
- **Share copy**: a paste-ready paragraph. Style, tone, and platform formatting are unconstrained — just organize the 7 required items into it. Warn the user about platform hyperlink limits (e.g. Xiaohongshu body-text links are not clickable — suggest guiding readers to the comments section).

## sensitive-runtime-data-protection

# Sensitive Runtime Data Protection

**Mandatory protocol** when writing, reviewing, or deploying CloudBase Cloud Functions or CloudBase Run (Function mode / Container mode) code that handles HTTP requests, request headers, environment variables, or debug/echo tooling.

## Why this exists

CloudBase gateways may inject platform context into backend requests. The header `x-cloudbase-context` is a base64-encoded payload that can include temporary cloud credentials for the account/environment. If application code echoes request headers, dumps `process.env`, or deploys a generic request inspector (for example `httpbin`), those credentials can leak to any caller and grant broad cloud-resource access.

This is the same class of failure as returning cloud-function environment variables or SecretId/SecretKey to clients: the platform cannot fully prevent unsafe application code from disclosing what it can already read.

## Hard rules (non-negotiable)

1. **Never return `x-cloudbase-context` to clients**
   - Do not put it in response bodies, response headers, logs shipped to clients, error payloads, or debug endpoints.
   - Do not base64-decode it and print, store in public storage, or forward it to untrusted systems.
   - Treat case variants the same (`X-CloudBase-Context`, `x-cloudbase-context`, etc.).

2. **Never echo raw request metadata wholesale**
   - Forbidden patterns: returning `req.headers`, `event.headers`, `event`, `context`, `os.environ`, `process.env`, or "dump everything" debug routes.
   - If debugging is required, return only an explicit allowlist of non-sensitive fields (for example `method`, `path`, a business request id).

3. **Never dump runtime secrets or credential-shaped env vars**
   - Do not return or log values for names such as:
     - `TENCENTCLOUD_SECRETID` / `TENCENTCLOUD_SECRETKEY` / `TENCENTCLOUD_SESSIONTOKEN`
     - `CLOUDBASE_APIKEY` / `CLOUDBASE_API_KEY` / `TCB_*` credential fields
     - Any `*SECRET*`, `*TOKEN*`, `*PASSWORD*`, `*PRIVATE_KEY*` environment variable
   - Prefer CloudBase server API Keys for app runtime auth instead of reflecting platform-injected temporary keys.

4. **Do not deploy request-echo / inspector images for CloudRun demos**
   - Do **not** recommend or deploy `httpbin`, `requestbin`, `webhook.site`-style reflectors, or custom "print all headers" services on CloudBase Run.
   - Prefer a minimal hello-world that returns a fixed JSON payload, or a health check that returns `{ "ok": true }` only.

5. **Keep secrets server-side**
   - Inject credentials through environment variables / secret managers.
   - Use them only inside the process to call CloudBase or Tencent Cloud APIs.
   - Never serialize them into HTTP responses, client bundles, README samples with real values, or chat/tool output meant for end users.

## Safe vs unsafe examples

### Unsafe (do not generate)

```js
// CloudRun / HTTP Function — leaks gateway-injected credentials
app.get("/debug", (req, res) => {
  res.json({ headers: req.headers, env: process.env });
});
```

```js
// Event Function — may leak platform context fields
exports.main = async (event, context) => {
  return { event, context, env: process.env };
};
```

```yaml
# CloudRun — httpbin reflects x-cloudbase-context to callers
image: kennethreitz/httpbin
```

### Safe (preferred)

```js
app.get("/health", (_req, res) => {
  res.json({ ok: true });
});

app.get("/whoami", (req, res) => {
  // Allowlist only non-sensitive request facts
  res.json({
    method: req.method,
    path: req.path,
    // Do NOT include req.headers or credential headers
  });
});
```

```js
exports.main = async (event) => {
  const name = typeof event?.name === "string" ? event.name : "world";
  return { ok: true, message: `hello ${name}` };
};
```

## Agent checklist before claiming done

- [ ] No response path returns `x-cloudbase-context` or full `headers` / `env` objects
- [ ] No CloudRun/function demo uses httpbin or equivalent header echo tools
- [ ] Credential env vars are read for SDK init only, never written into responses
- [ ] Debug endpoints, if any, use an explicit non-sensitive allowlist

## Usage instruction

> Before writing or deploying Cloud Function / CloudRun HTTP handlers, debug routes, or container images, follow `cloudbase-platform/references/protocols/sensitive-runtime-data-protection.md`.

## rule

---
name: cloudbase-platform
description: CloudBase platform overview and routing guide. This skill should be used when users need high-level capability selection, platform concepts, console navigation, realtime (broadcast / presence / live database changes), or cross-platform best practices before choosing a more specific implementation skill.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

**Cross-cutting protocols** (required before code changes or deployments):
- Change Safety Protocol: `references/protocols/change-safety-protocol.md`
- Deployment Gate: `references/protocols/deployment-gate.md`
- Sensitive Runtime Data Protection: `references/protocols/sensitive-runtime-data-protection.md`

**Post-deployment (optional, non-intrusive)**: after a deployment is verified successful, you may offer at most once to generate anonymized shareables (Deployment Share) — see `references/protocols/deployment-share.md`. Deliver the card, the copy and the case-wall entry in one reply; shareables only if that is all the user asked for. Never follow up if declined; never publish or submit on the user's behalf.

## Activation Contract

### Use this first when

- The user asks which CloudBase capability, service, or tool to use, or needs a high-level understanding of hosting, storage, authentication, cloud functions, or database options.
- The task is about console navigation, cross-platform differences, permission models, or platform-level best practices before implementation.

### Read before writing code if

- It is still unclear whether the task belongs to Web, mini program, cloud functions, storage, MySQL / NoSQL, or auth.
- The response needs platform selection, conceptual explanation, or control-plane navigation more than direct implementation steps.

### Then also read

- Minimal Web + database demo (BaaS-first, no cloud functions by default) -> `../minimal-web-baas-demo/SKILL.md`
  - **Stack order for 最小前后端 / Lovable-like demos:** Web SDK CRUD > MCP schema > template warmup during credential wait > cloud functions (default count = 0). Capability sniff: connector ready → `queryEnv` → lock one DB plane → MCP schema → `@cloudbase/js-sdk` CRUD → preview.
- Web app implementation -> `../web-development/SKILL.md`
- Web auth and provider setup -> `../auth-tool-cloudbase/SKILL.md`, `../auth-web-cloudbase/SKILL.md`
- Mini program development -> `../miniprogram-development/SKILL.md`
- WeChat Pay, Official Account OAuth, JSAPI Pay, or Native QR-code Pay through CloudBase Integration Center -> `../cloudbase-wechat-integration/SKILL.md` (official docs: `https://docs.cloudbase.net/integration/introduce.md`)
- Cloud functions -> `../cloud-functions/SKILL.md`
- Official HTTP API clients -> `../http-api-cloudbase/SKILL.md`
- Document database -> `../cloudbase-document-database-web-sdk/SKILL.md` or `../cloudbase-document-database-in-wechat-miniprogram/SKILL.md`
- CloudBase PostgreSQL / PG -> `../postgresql-development-cloudbase/SKILL.md`
- Realtime / live push / channels / live table change subscriptions / multiplayer sync -> `../postgresql-development-cloudbase/references/realtime.md`
  - **PG mode only.** Run its Step 0 environment probe before writing any realtime code; if the environment has no `realtime` schema, stop and report rather than working around it.
  - `app.realtime()` (Broadcast / Presence / Postgres CDC) is **not** document-database `collection.watch()`. Do not answer a realtime request with `watch()` code, or the reverse.
- MySQL relational database / data modeling -> `../relational-database-mcp-cloudbase/SKILL.md` or `../data-model-creation/SKILL.md`
- Cloud storage -> `../cloud-storage-web/SKILL.md`

### Do NOT use for

- Direct implementation of web pages, auth flows, functions, or database operations when a more specific skill already fits.
- Low-level API parameter references or SDK recipes that belong in specialized skills.

### Common mistakes / gotchas

- Treating this general skill as the default entry point for all CloudBase development.
- Staying here after the correct implementation skill is already clear.
- Mixing platform overview with platform-specific API shapes or SDK details.
- Using this overview skill as a detour in an existing application where the active auth, storage, and data files are already obvious.
- Making code or configuration changes without first following the Change Safety Protocol (`cloudbase-platform/references/protocols/change-safety-protocol.md`).
- Starting any deployment, publish, custom domain, or CloudRun work without first completing the checks in `cloudbase-platform/references/protocols/deployment-gate.md`.
- Echoing `x-cloudbase-context`, full `req.headers`, or `process.env` from Cloud Functions / CloudRun (including httpbin-style debug images) — follow `references/protocols/sensitive-runtime-data-protection.md`.
- **Confusing security domains with custom domains**: these are two different tools for different purposes. See the "Domain Management Tools" table below for the authoritative split.

## When to use this skill

Use this skill for **CloudBase platform knowledge** when you need to:

- Understand CloudBase storage and hosting concepts
- Compare platform capabilities before implementation
- Understand cross-platform auth differences (Web vs Mini Program)
- Understand database permissions and access control
- Access CloudBase console management pages

**This skill provides foundational knowledge** that applies to all CloudBase projects, regardless of whether they are Web, Mini Program, or backend services.

---

## How to use this skill (for a coding agent)

1. **Understand platform differences**
   - Web and Mini Program have completely different authentication approaches
   - Must strictly distinguish between platforms
   - Never mix authentication methods across platforms
   - If the workspace is already an application with TODOs or prebuilt handlers, do not stay in platform overview mode. Move quickly to the concrete implementation skill and the existing files that own the flow.

2. **Follow best practices**
   - Use SDK built-in authentication features (Web)
   - Understand natural login-free feature (Mini Program)
   - Configure appropriate database permissions
   - Prefer `@cloudbase/js-sdk` direct DB access for browser CRUD; use cloud functions only for secrets, scheduled/background jobs, or elevated cross-collection logic that security rules / RLS cannot express (see `../minimal-web-baas-demo/SKILL.md` for the demo default)

3. **Use correct SDKs and APIs**
   - Different platforms require different SDKs for data models
   - MySQL data models must use models SDK, not collection API
   - PostgreSQL / CloudBase PG work must route to `postgresql-development-cloudbase`; do not reuse NoSQL `app.database()` / `db.collection(...)` snippets or MySQL `queryMysqlDatabase` / `manageMysqlDatabase` for PG data paths
   - Use `queryEnv` tool to get environment ID
   - In an existing Web application with fixed structure, inspect the existing `src/lib/backend.*`, `src/lib/auth.*`, `src/lib/*service.*`, and bound page handlers before broad concept reading.

4. **Use the canonical CloudBase MCP setup from the main `cloudbase` guideline**
   - This platform overview intentionally does **not** duplicate the full MCP / mcporter config block
   - For the canonical config snippet, CLI commands, and auth examples, read the main `cloudbase` guideline first
   - Keep the same core rules here: prefer MCP when tools are available in this session; if not, configure MCP for next session and use `tcb` CLI now (`../cloudbase-cli/SKILL.md`, `../cloudbase/references/tooling-fallback.md`). Inspect tool schemas before MCP execution. Do not hard-code Secret ID / Secret Key / Env ID in config
   - Keep the auth split explicit: management-side login uses `auth`, while application-side auth configuration uses `queryAppAuth` / `manageAppAuth`

---

# CloudBase Platform Knowledge

### Domain Management Tools: Clear Distinction

When working with domain-related tasks, use the correct tool based on the requirement:

| Requirement | Tool | Parameters | Purpose |
|-------------|------|------------|---------|
| **Security Domain (安全域名)** | `manageEnv(action="addSecurityDomain" \| "removeSecurityDomain")` | `domains` (array of host:port strings) | CORS/request source validation for browser uploads. No certificate involved. (Deprecated alias: `envDomainManagement`.) |
| **Reuse existing Custom Domain** | `queryGateway(listCustomDomains)` → `manageGateway(createRoute)` | `domain` = existing custom domain; route fields | Expose a service/path on an already-bound custom domain. **No certificateId.** Prefer this when a custom domain already exists. |

## mini-program-pay

# Mini Program WeChat Pay

Official docs:

- `https://docs.cloudbase.net/integration/wechat-pay-miniprogram.md`
- `https://docs.cloudbase.net/integration/usage.md`

## When To Use

Use this reference for WeChat Mini Program payment flows on CloudBase, including 小程序微信支付, `wx.cloud.callHTTPFunction`, `wx.requestPayment`, Mini Program openid handling, payment callbacks, refunds, and order-status sync.

## Agent Must Know

- The CloudBase Integration Center generated payment function is an HTTP cloud function.
- `pay-common` is an example function name; use the actual generated function name.
- Mini Program openid can be injected by CloudBase when calling through the Mini Program cloud function path.
- The client-side `wx.requestPayment` success callback is not the final business truth.
- Fulfillment must be driven by callback handling or explicit order query.

## Minimal Contract

Typical Mini Program flow:

1. Mini Program calls the generated payment function over `wx.cloud.callHTTPFunction`.
2. The request path targets the generated payment route, commonly an order-creation path such as `/wx-pay/wxpay_order`.
3. The generated function returns payment parameters for `wx.requestPayment`.
4. The Mini Program invokes `wx.requestPayment`.
5. Backend callback or query logic confirms paid state before updating business data.

Example shape:

```js
const functionName = "replace-with-generated-payment-function";

const orderResult = await wx.cloud.callHTTPFunction({
  name: functionName,
  path: "/wx-pay/wxpay_order",
  data: {
    out_trade_no: orderId,
    description: "Order payment",
    amount: {
      total: 1,
      currency: "CNY",
    },
  },
});

// callHTTPFunction returns { data, statusCode, header }
// The generated function typically returns { code, data, message }
// Payment params are under orderResult.data.data
const payment = orderResult.data?.data;
if (!payment) {
  throw new Error("Missing payment parameters from CloudBase payment function");
}

await wx.requestPayment(payment);
```

Adjust field names to the official docs and the generated function contract before using in production.

## Implementation Checklist

- Confirm `wx.cloud.init({ env })` uses the canonical full CloudBase environment ID.
- Confirm the Mini Program AppID matches the WeChat Pay merchant binding.
- Confirm the generated function name and path in CloudBase console.
- Generate a unique `out_trade_no` on the backend or trusted business layer.
- Validate amount and product data server-side before creating payment.
- Persist pending order state before initiating payment.
- Handle payment callback idempotently.
- Query the order after client payment success before showing final fulfillment state.

## Common Extensions

- Write order and payment status to CloudBase database.
- Add an idempotency key on `out_trade_no`.
- Add fulfillment only after callback/query confirms success.
- Add refund initiation and refund callback handling if the product supports refunds.

## Do Not

- Do not place merchant keys or certificates in Mini Program code.
- Do not trust client-provided amount without server-side validation.
- Do not assume frontend success means the order is paid.
- Do not hard-code `pay-common` if the console generated a different function name.

## native-qr-pay

# Native QR-Code Pay

Official docs:

- `https://docs.cloudbase.net/integration/wechat-pay-native.md`
- `https://docs.cloudbase.net/integration/usage.md`

## When To Use

Use this reference for PC/Web checkout, Native WeChat Pay, QR-code payment, or flows where the generated function returns a payment `code_url` for the frontend to render as a QR code.

## Agent Must Know

- Native payment does not use `wx.requestPayment` or `WeixinJSBridge`.
- The generated payment function creates an order and returns a QR-code URL such as `code_url`.
- The frontend renders the QR code and polls or subscribes to payment state.
- Fulfillment must wait for callback or query confirmation.

## Minimal Contract

Typical Native flow:

1. Backend or frontend calls the generated payment function to create a Native order.
2. The generated function returns `code_url`.
3. The frontend renders `code_url` as a QR code.
4. The user scans the QR code in WeChat.
5. The app polls order status or waits for callback-driven state changes.

Example frontend shape:

```js
async function createNativePayment(orderId) {
  const response = await fetch("/api/pay/native-order", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ orderId }),
  });
  const data = await response.json();
  if (!data.code_url) {
    throw new Error("Missing Native payment code_url");
  }
  return data.code_url;
}
```

In CloudBase frontend-only projects, the API wrapper can call the generated HTTP function directly if the access model and CORS/security rules are appropriate. For production, prefer a trusted backend or generated function extension that validates amount and order ownership.

## Implementation Checklist

- Confirm this is Native QR-code payment, not JSAPI or Mini Program payment.
- Confirm generated function name and Native order path.
- Generate a unique order number and persist pending state.
- Validate amount and goods details before creating payment.
- Render QR code from `code_url`.
- Poll order status with backoff, or update UI from callback-driven status.
- Expire stale QR codes and handle closed orders.

## Do Not

- Do not call `wx.requestPayment` for Native QR-code pay.
- Do not fulfill the order when the QR code is generated.
- Do not rely on frontend polling alone if callback data says otherwise.

## official-account-jsapi-pay

# Official Account JSAPI Pay

Official docs:

- `https://docs.cloudbase.net/integration/wechat-pay-jsapi-h5.md`
- `https://docs.cloudbase.net/integration/wechat-official-oauth.md`
- `https://docs.cloudbase.net/integration/usage.md`

## When To Use

Use this reference for WeChat Official Account webpage payment, JSAPI payment inside the WeChat browser, H5 checkout that calls `WeixinJSBridge.invoke`, and flows that need an official-account openid before creating the payment order.

## Agent Must Know

- JSAPI payment requires the page to run in the WeChat built-in browser.
- The payer openid must belong to the correct Official Account, not the Mini Program openid.
- Official Account OAuth is commonly needed before JSAPI order creation.
- The generated payment function name and routes must be read from the user's Integration Center setup.
- Final business state still depends on payment callback or order query.

## Minimal Contract

Typical JSAPI flow:

1. Redirect the user through Official Account OAuth to get an openid.
2. Call the generated payment function to create a JSAPI order.
3. Pass returned payment parameters to `WeixinJSBridge.invoke("getBrandWCPayRequest", ...)`.
4. Use payment callback or order query to confirm paid state.

Example invocation shape:

```js
function invokeJsapiPay(paymentParams) {
  return new Promise((resolve, reject) => {
    if (!window.WeixinJSBridge) {
      reject(new Error("WeixinJSBridge is unavailable; open this page in WeChat"));
      return;
    }

    window.WeixinJSBridge.invoke(
      "getBrandWCPayRequest",
      paymentParams,
      (res) => {
        if (res.err_msg === "get_brand_wcpay_request:ok") {
          resolve(res);
          return;
        }
        reject(new Error(res.err_msg || "JSAPI payment failed"));
      },
    );
  });
}
```

Adjust request paths and parameter names to the generated function contract and official docs.

## Implementation Checklist

- Confirm the app is an Official Account web flow, not a Mini Program page.
- Confirm the page runs inside WeChat before showing JSAPI checkout.
- Obtain the Official Account openid through OAuth before order creation.
- Confirm merchant account binding matches the Official Account AppID.
- Persist pending order state before invoking payment.
- Confirm paid state through callback or query before fulfillment.

## Do Not

- Do not reuse Mini Program openid for Official Account JSAPI pay.
- Do not show JSAPI checkout in a normal desktop browser.
- Do not put AppSecret, merchant private keys, or APIv3 keys in browser code.

## official-account-oauth

# Official Account OAuth

Official docs:

- `https://docs.cloudbase.net/integration/wechat-official-oauth.md`
- `https://docs.cloudbase.net/integration/usage.md`

## When To Use

Use this reference for WeChat Official Account OAuth, openid retrieval, userinfo retrieval, token refresh, OAuth config inspection, or preparation for Official Account JSAPI payment.

## Agent Must Know

- Official Account openid is different from Mini Program openid.
- OAuth credentials should be configured through CloudBase Integration Center, not embedded in frontend code.
- The generated official-account function name may differ from example names such as `offiaccount-common`.
- OAuth route names must be confirmed from the generated function and official docs.

## Minimal Contract

Common generated OAuth routes include:

- `/oauth/config`
- `/oauth/token`
- `/oauth/refresh`
- `/oauth/userinfo`
- `/oauth/verify`

Typical flow:

1. Get OAuth config or construct the authorization URL according to the generated function contract.
2. Redirect the user to WeChat authorization.
3. Exchange the returned code for token/openid through the generated function.
4. Optionally fetch userinfo if the scope and product requirement allow it.
5. Store only the user identifiers and business-safe profile fields required by the app.

Example exchange shape:

```js
async function exchangeOfficialAccountCode(code) {
  const response = await fetch("/api/wechat/oauth/token", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ code }),
  });
  const data = await response.json();
  if (!data.openid) {
    throw new Error("Missing Official Account openid");
  }
  return data;
}
```

Use the actual generated function path or an application backend wrapper instead of copying this path literally.

## Implementation Checklist

- Confirm the target is an Official Account web scenario.
- Confirm OAuth callback domain and redirect URI are configured.
- Confirm the generated function name and OAuth routes.
- Decide whether the product needs only openid or also userinfo.
- Store tokens securely if refresh is required.
- For JSAPI pay, pass the Official Account openid into the payment order creation flow.

## Do Not

- Do not expose AppSecret in browser code.
- Do not confuse Official Account openid with Mini Program openid.
- Do not request userinfo scope unless the product actually needs profile data.

## overview

# CloudBase WeChat Integration Overview

Official docs:

- `https://docs.cloudbase.net/integration/introduce.md`
- `https://docs.cloudbase.net/integration/usage.md`

## What Integration Center Provides

CloudBase Integration Center is a console-driven capability for connecting third-party services to CloudBase. For WeChat scenarios, it can generate HTTP cloud functions, inject configuration through managed environment variables, and handle platform-specific callback verification or decryption.

Use this skill for the application-side work around those integrations:

- generating client calls to the generated functions
- adding order persistence, idempotency, and fulfillment logic
- diagnosing callback, credential, and routing issues
- guiding the user through console setup without collecting secrets

## Agent Must Know

- Creation and credential binding are console-first unless official public API support is confirmed.
- Generated function names may vary. Examples such as `pay-common` and `offiaccount-common` are not a contract.
- Merchant secrets, private keys, APIv3 keys, AppSecret values, and certificates belong in CloudBase console configuration, not in source code.
- The payment callback or order-query result is the authoritative state for business fulfillment.
- Generated functions should be treated as platform-managed templates with safe business extensions, not as blank custom functions.

## Scenario Map

| User wording | Route |
| --- | --- |
| 小程序支付, 微信支付, `wx.requestPayment` | `mini-program-pay.md` |
| 公众号支付, JSAPI 支付, 微信内网页支付 | `official-account-jsapi-pay.md` |
| Native 支付, 扫码支付, 二维码支付 | `native-qr-pay.md` |
| 公众号授权, openid, userinfo, OAuth | `official-account-oauth.md` |
| 回调失败, 404, 凭证, openid 不匹配 | `troubleshooting.md` |

## Console-First Setup Checklist

1. Confirm the CloudBase environment ID.
2. Open Integration Center in the CloudBase console.
3. Choose the matching WeChat integration type.
4. Fill merchant or official-account credentials in the console form.
5. Record the generated function name and HTTP route paths.
6. Run a minimal call before adding business logic.
7. Add business data handling after the generated function works.

## Independent Distribution Notes

When this skill is installed alone:

- Use only the references in this directory plus the official docs above.
- If no CloudBase MCP tools are available, guide the user to inspect function logs and configuration in the console.
- Do not reference local repository paths that may not exist in the target platform.

## troubleshooting

# WeChat Integration Troubleshooting

Official docs:

- `https://docs.cloudbase.net/integration/introduce.md`
- `https://docs.cloudbase.net/integration/usage.md`
- `https://docs.cloudbase.net/integration/wechat-pay-miniprogram.md`
- `https://docs.cloudbase.net/integration/wechat-pay-jsapi-h5.md`
- `https://docs.cloudbase.net/integration/wechat-pay-native.md`
- `https://docs.cloudbase.net/integration/wechat-official-oauth.md`

## First Checks

1. Confirm the scenario: Mini Program Pay, JSAPI Pay, Native Pay, or Official Account OAuth.
2. Confirm the CloudBase environment ID.
3. Confirm the actual generated function name.
4. Confirm the exact route path from Integration Center or generated function docs.
5. Check cloud function logs before changing code.
6. Check whether the issue is credential setup, route mismatch, callback delivery, or business logic.

## Common Symptoms

### 404 or route not found

Likely causes:

- wrong function name
- wrong HTTP path
- calling Mini Program payment path from the wrong client
- generated function was deleted or redeployed incorrectly

Actions:

- inspect the generated function routes
- confirm the call target uses the actual function name
- check CloudBase function logs and HTTP access logs

### Missing credentials or credential initialization errors

Likely causes:

- Integration Center form is incomplete
- merchant certificate/APIv3 key/private key was not configured
- function environment variables were removed or overwritten

Actions:

- re-check Integration Center credential configuration in the console
- do not paste secrets into code or chat
- restore generated environment variables if they were overwritten

### Openid mismatch

Likely causes:

- Mini Program openid used for Official Account JSAPI pay
- Official Account AppID does not match merchant binding
- user authorized a different app than the one used for payment

Actions:

- identify whether the flow needs Mini Program openid or Official Account openid
- verify AppID and merchant binding
- rerun OAuth or Mini Program call in the correct client context

### Payment succeeds in frontend but order is not fulfilled

Likely causes:

- business logic trusts frontend success only
- callback did not reach the generated function
- callback handler is not idempotent
- order status query is missing

Actions:

- use callback or query as the authoritative payment state
- add idempotent order update logic
- inspect payment callback logs
- verify `out_trade_no` maps to the application's order record

### Callback not received

Likely causes:

- merchant platform notification URL is wrong
- callback path does not match generated function route
- APIv3 key/certificate mismatch prevents verification/decryption
- function security or deployment issue

Actions:

- check Integration Center callback configuration
- check merchant platform callback settings
- inspect generated function logs
- retry with a low-value test order after fixing configuration

### `callHTTPFunction is not a function`

Likely causes:

- Mini Program base library or CloudBase SDK capability is too old
- the project is not initialized with `wx.cloud.init`
- the flow is running outside Mini Program runtime

Actions:

- confirm Mini Program runtime and base library support
- initialize CloudBase with the canonical full environment ID
- use the correct client flow for Web/JSAPI/Native scenarios

## Before Editing Generated Code

- Keep generated credential handling intact.
- Add business logic around generated handlers instead of replacing verification/decryption logic.
- Preserve callback idempotency and order lookup.
- Keep secrets out of source code.

## virtual-payment

# Mini Program Virtual Payment (虚拟支付)

Official docs:

- `https://developers.weixin.qq.com/minigame/dev/wxcloud/guide/wechatpay/ai-virtualpayl-person.html`（AI 工具快速接入虚拟支付，含小游戏/小程序）
- `https://developers.weixin.qq.com/miniprogram/dev/platform-capabilities/business-capabilities/virtual-payment`（企业/个体户接入指引）
- `https://developers.weixin.qq.com/miniprogram/dev/platform-capabilities/business-capabilities/virtual-payment/person`（个人主体接入指引）
- Client API: `https://developers.weixin.qq.com/miniprogram/dev/api/payment/wx.requestVirtualPayment.html`

## When To Use

Use this reference for **虚拟支付**（virtual goods payment）flows: 道具直购、代币、`wx.requestVirtualPayment`、`xpay_*` 回调事件、OfferID / AppKey 签名、发货推送、查单兜底。

**与微信支付的边界**：虚拟支付走 MP 后台「虚拟支付」通道（`wx.requestVirtualPayment`， OfferID + AppKey 签名），与 Integration Center 生成的微信支付（`wx.requestPayment`，商户号 + APIv3）是**两套独立链路**。卖实物/服务用微信支付（见 `mini-program-pay.md`）；卖虚拟道具/代币用本参考。

## Prerequisites

| 条件 | 说明 |
| --- | --- |
| 主体资质 | 个人 / 企业 / 个体户均可；个人主体需服务类目含「工具」，且**全终端月支付限额 10 万元** |
| 开通入口 | MP 后台 → 支付与交易 → 虚拟支付 → 开通 |
| 关键参数 | AppID（设置）、OfferID、现网 AppKey、沙箱 AppKey（均在 虚拟支付 → 基本配置） |
| 道具 | 虚拟支付 → 道具管理 创建并**发布**；发布后需等几分钟到半小时全平台同步，期间下单报 `COIN_OR_PRODUCT_ID_CREATED_IN_RECENTLY` |
| iOS 支付 | 需先配置「小程序简称」（Apple 展示名）并开通苹果 IAP；用户微信客户端需 **8.0.68+**，代码里先校验版本再拉起支付 |

## Sandbox vs 现网

| 模式 | 适用版本 | 限制 |
| --- | --- | --- |
| 沙箱 | 开发版 / 体验版 | 真机预览下会被 `PAYMENT_ILLEGAL_IN_SANDBOX` 拦截 |
| 现网 | 全版本 | iOS 真机需开通 IAP |

- 沙箱仅适合开发者工具内调试；真实联调用现网（`env: 0`、正式 AppKey）。
- 沙箱 AppKey 不要出现在生产代码里。

## Core Flow

```text
① 前端请求服务端下单 → 服务端生成唯一 outTradeNo，构造 signData，算 paySig + signature
② 前端调用 wx.requestVirtualPayment(payData) 拉起支付
③ 服务端确认支付并发货：
   路径 A：收到 xpay_goods_deliver_notify 发货推送 → 幂等发货
   路径 B：推送丢失时定时调 query_order 查单 → 已支付则补发货
④ 前端查服务端订单状态 → 展示购买成功
```

关键点：

- 发货以「发货推送」为主、`query_order` 查单兜底；**前端 success 回调不作为发货依据**。
- 幂等以平台单号 `wx_order_id`（回调里 `WeChatPayInfo.MchOrderNo`）去重。
- `outTradeNo` 每次下单重新生成、8-32 位、不能以下划线开头、不可复用。

### payData fields

| 字段 | 说明 |
| --- | --- |
| signData | JSON 字符串：`offerId` / `buyQuantity` / `env`（固定 0）/ `currencyType`（固定 CNY）/ `productId` / `goodsPrice`（单位：**分**，与后台道具价一致）/ `outTradeNo` / `attach`（透传，发货时原样返回） |
| mode | 道具直购固定 `short_series_goods` |
| paySig | 服务端用 **AppKey** 对 `requestVirtualPayment&signData` 做 HMAC-SHA256 |
| signature | 服务端用 **sessionKey**（`auth.code2Session` 获取）对 signData 做 HMAC-SHA256 |

### 签名规则

- `paySig` 消息体 = `uri + '&' + post_body`；`post_body` 必须与实际发出的请求体**完全一致**（不格式化、不改键顺序）。
- C 端下单 uri 固定 `requestVirtualPayment`；B 端服务接口（如 `/xpay/query_order`）用实际路径。

### Callback events (xpay_*)

| Event | 说明 | 处理 |
| --- | --- | --- |
| `xpay_goods_deliver_notify` | 道具发货通知 | 核心事件：幂等发货，返回 `<xml><ErrCode>0</ErrCode><ErrMsg><![CDATA[success]]></ErrMsg></xml>`，否则平台重试（最多 15 次） |
| `xpay_coin_pay_notify` | 代币支付通知 | 更新代币余额 |
| `xpay_refund_notify` | 退款通知 | 更新订单状态、回收道具 |
| `xpay_complaint_notify` | 用户投诉通知 | 记录并人工跟进 |
| `xpay_subscribe_signing_result_notify` | 订阅签约结果 | 更新订阅状态 |
| `xpay_subscribe_pay_fail_notify` | 订阅支付失败 | 提示用户 |
| `xpay_subscribe_ios_refund_query_notify` | iOS 订阅退款问询 | **3 秒内**返回 `result_code`（0=建议退款，1=拒绝），否则 Apple 连续问询 3 次后标「不确定」 |

发货推送核心字段：`OpenId`（发给谁）、`OutTradeNo`（业务单号）、`WeChatPayInfo.MchOrderNo`（平台单号）、`GoodsInfo.ProductId` / `GoodsInfo.Quantity`（发什么、发多少）。

### Query order (查单兜底)

`POST /xpay/query_order`（带 pay_sig 签名）：

```json
{ "openid": "用户openid", "env": 0, "order_id": "业务单号 outTradeNo" }
```

> ⚠️ 参数名是 `order_id`（传 outTradeNo），不是 `out_trade_no`。建议每 5 分钟定时查一次未完成订单。

## Refunds & Settlement

| 终端 | 退款 | 结算周期 | 费率 |
| --- | --- | --- | --- |
| Android 等 | 开发者主动（MP 后台或 `refund_order` 接口） | T+3 | 1%（腾讯技术服务费） |
| iOS | ❌ 开发者无法主动退款；用户在 App Store → 购买记录申请，Apple 审批后推送 `xpay_refund_notify` | 约 45-60 天 | 12%（Apple 佣金） |

- 支付 180 天内退款平台退还手续费，超过 180 天不退。
- iOS 订单在前端「我的」等场景建议**隐藏退款入口**，改为引导用户去 App Store 申请。

## Common Errors

| 错误 | 原因 | 解法 |
| --- | --- | --- |
| `COIN_OR_PRODUCT_ID_CREATED_IN_RECENTLY` | 道具刚发布，平台同步延迟 | 等几分钟到半小时再试 |
| `PAYMENT_ILLEGAL_IN_SANDBOX` | 沙箱模式在真机预览下被拒 | 切现网（`env: 0` + 正式 AppKey） |
| 当前商户尚未开启 iOS 支付 | iOS 端 IAP 未开通 | MP 后台配置小程序简称 + 开通 IAP |

## On 微信云开发 (WeChat CloudBase)

用微信云开发承接时无需自建服务器/证书：云函数承担下单签名、回调处理、查单兜底，云数据库存订单。典型拆分：

- 下单云函数：生成业务单号、构造 signData、计算双签名，返回 payData
- 回调云函数：接收 `xpay_*` 推送，幂等校验后发放/回收道具（需在 MP 后台配置发货推送 URL 并订阅事件）
- 查单云函数：推送丢失时调 `query_order` 补发货，兼作订单/道具查询

配合 Nightly 微信开发者工具（≥ 2.02.2608312）与 `wechatide` CLI / IDE MCP，可自动完成云函数部署与消息推送订阅（见 `../miniprogram-development/SKILL.md` 的 DevTools 工作流）。

## Implementation Checklist


## rule

---
name: cloudbase-wechat-integration
description: CloudBase WeChat integration guide for Mini Program WeChat Pay, Mini Program virtual payment (虚拟支付, wx.requestVirtualPayment), Official Account JSAPI Pay, Native QR-code Pay, Official Account OAuth, openid handling, payment callbacks, and CloudBase Integration Center generated functions. This skill should be used when users ask to add, debug, or extend WeChat payment, virtual payment, or official-account flows on CloudBase.
version: 2.35.2
license: MIT
alwaysApply: false
---

# CloudBase WeChat Integration

This skill routes WeChat payment and official-account work through CloudBase Integration Center. It gives the agent the stable execution contract and points to the official Markdown docs for console details that may change.

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

Official CloudBase Integration Center docs (human reference — do not treat as skill markdown to fetch into agent context as a sibling skill substitute):
- CloudBase Integration Center overview: `https://docs.cloudbase.net/integration/introduce.md`
- CloudBase Integration Center usage: `https://docs.cloudbase.net/integration/usage.md`
- When cloud function deployment or log operations are needed and no sibling skill is available, use the current platform's CloudBase MCP tools or CloudBase console instead of guessing unsupported APIs.

## Activation Contract

### Use this first when

- The user asks about WeChat Pay, 小程序支付, 微信支付, JSAPI 支付, 公众号支付, Native 扫码支付, 二维码支付, refund callbacks, payment callbacks, `wx.requestPayment`, `WeixinJSBridge`, `openid`, or Official Account OAuth in a CloudBase app.
- The user asks about 虚拟支付 (virtual payment) for virtual goods: 道具直购, 代币充值, `wx.requestVirtualPayment`, OfferID, AppKey 签名, `xpay_*` callbacks (发货推送/查单/退款), or MP 后台虚拟支付开通与配置.
- The task mentions CloudBase Integration Center, 集成中心, generated payment functions, `pay-common`, `offiaccount-common`, or callback routing for WeChat payment.
- The user needs to extend a CloudBase Integration Center generated function with order persistence, idempotency, fulfillment, or payment-status sync.

### Then also read

- Mini Program structure and preview work -> `../miniprogram-development/SKILL.md` (if unavailable, use the current mini program platform docs and the mini-program payment reference in this skill)
- Web frontend work -> `../web-development/SKILL.md` (if unavailable, use the JSAPI or Native references in this skill)
- Cloud function runtime, logs, deployment, or gateway work -> `../cloud-functions/SKILL.md` (if unavailable, use CloudBase console/MCP function tools and the generated-function guidance in this skill)

### Do NOT use for

- Generic CloudBase Web Auth or Mini Program native identity work that does not involve WeChat payment or official-account OAuth.
- General CloudBase cloud function development unrelated to Integration Center generated functions.
- Creating or managing Integration Center instances through guessed MCP tools, guessed Manager SDK methods, or undocumented Cloud API actions.
- Storing merchant secrets, private keys, APIv3 keys, AppSecret values, or certificates in app source code, generated examples, README files, commits, or prompts.

## Operating Rules

1. Treat Integration Center creation as a console-first workflow unless a public Manager SDK or Cloud API contract is confirmed in official docs.
2. Use official `index.md` docs for console UI steps and credential fields; do not copy stale console screenshots or invent field names.
3. Never ask the user to paste secrets into chat. Tell them to configure merchant and official-account credentials in the CloudBase console Integration Center form.
4. Do not assume generated function names are fixed. `pay-common` and `offiaccount-common` are examples; ask for or inspect the actual function name before writing calls.
5. Treat frontend payment success as UI feedback only. The authoritative payment state must come from server-side query results or payment callbacks.
6. When extending generated functions, preserve credential environment variables and generated callback verification/decryption logic. Add business logic around order checks, persistence, idempotency, and fulfillment.
7. Before changing payment or callback code, identify the target scenario and load only the matching reference file.

## Routing

| Task | Read | Why |
| --- | --- | --- |
| Capability selection, console-first boundaries, independent distribution | `references/overview.md` | Establishes the Integration Center model and safety rules |
| Mini Program WeChat Pay, `wx.cloud.callHTTPFunction`, `wx.requestPayment` | `references/mini-program-pay.md` | Covers Mini Program openid injection, order creation, and callback expectations |
| Mini Program 虚拟支付, virtual goods, `wx.requestVirtualPayment`, `xpay_*` callbacks | `references/virtual-payment.md` | Covers OfferID/AppKey signing, sandbox vs 现网, delivery callbacks, query-order fallback, iOS IAP rules |
| Official Account JSAPI pay, H5 inside WeChat, `WeixinJSBridge.invoke` | `references/official-account-jsapi-pay.md` | Covers official-account openid and JSAPI invocation |
| Native QR-code pay for PC/Web checkout | `references/native-qr-pay.md` | Covers `code_url`, QR rendering, and polling/query flow |
| Official Account OAuth, openid/userinfo retrieval | `references/official-account-oauth.md` | Covers OAuth routes generated by the official-account integration |
| 404, missing credentials, openid mismatch, callback failures, logs | `references/troubleshooting.md` | Provides diagnosis steps before changing code |

## Quick Workflow

1. Classify the scenario: Mini Program Pay, Virtual Payment (虚拟支付), JSAPI Pay, Native Pay, Official Account OAuth, generated-function extension, or troubleshooting.
2. Load the matching reference and the official `index.md` docs linked there.
3. Confirm the actual CloudBase environment ID and generated function name.
4. Generate or modify only the required client/backend code; keep merchant credentials in Integration Center configuration.
5. Add order-status query, callback idempotency, and amount/order validation when payment state affects business data.
6. Verify through function logs, callback logs, and an end-to-end payment sandbox or low-value production test as appropriate.

## Minimum Self-Check

- Did I avoid guessing undocumented Integration Center management APIs?
- Did I use the actual generated function name instead of assuming `pay-common`?
- Did I keep all merchant secrets and certificates out of source code and chat?
- Did the payment flow rely on callback/query state rather than only frontend success?
- Did I load only the scenario reference needed for the user's task?

## Reference index

All packaged reference files (required for skill lint reachability):

- [mini-program-pay.md](references/mini-program-pay.md)
- [native-qr-pay.md](references/native-qr-pay.md)
- [official-account-jsapi-pay.md](references/official-account-jsapi-pay.md)
- [official-account-oauth.md](references/official-account-oauth.md)
- [overview.md](references/overview.md)
- [troubleshooting.md](references/troubleshooting.md)

## image-deploy-troubleshooting

# CloudRun container deploy failure — diagnosis reference

Read this when `deploy_failed`, Pod never becomes ready, readiness/probe fails, or a third-party `imageUrl` will not stay up.

Follow the behavioral SOP in `../SKILL.md` (**docs → runtime logs → config**). This file expands signal tables. Do **not** start from a specific image name.

Official networking/VPC issues belong in [vpc-and-database.md](vpc-and-database.md), not here.

## 1. Pre-deploy: five facts from the image's own docs

Before the first `manageCloudRun(action="deploy")` with `imageUrl` (or a `FROM <image>` Dockerfile), open the **image's official run docs** (not just Docker Hub tags) and fill this table. Guessing from common defaults is how probe-delay misdiagnosis starts.

| # | Fact | Where it usually lives | CloudRun field |
| --- | --- | --- | --- |
| 1 | Foreground start command | `docker run … <cmd>`, compose `command:`, Dockerfile `ENTRYPOINT`/`CMD` | `serverConfig.EntryPoint`, `serverConfig.Cmd` |
| 2 | Listen port | `-p host:container`, compose `ports:`, docs "listens on" | `serverConfig.Port` and `EnvParams.PORT` if the app honors `PORT` |
| 3 | Bind-address / public-listen env | docs saying "set HOST=0.0.0.0" / "API disabled by default" | `serverConfig.EnvParams` |
| 4 | Required data directory | `-v host:container`, compose `volumes:` | `serverConfig.VolumesConf` (`VolumePath` = container path) |
| 5 | Health / ready signal | `/health`, `/ready`, or "probe the listen port" | CloudRun readiness probes the **service port**; a path-only health check does not replace a process that never binds |

Rules:

- Do **not** assume `80` or `3000`. Many images ignore platform `PORT`.
- Do **not** assume the image's default `CMD` is the HTTP server. Some images idle, print help, or start a supervisor with no app child.
- Bind address `127.0.0.1` inside the container makes the platform probe fail even when local `curl` inside the namespace would work.
- If docs require a volume and you omit it, the process may exit on first write — that looks like a probe failure.

## 2. After failure: which log, then which class

### 2.1 Pick the right log

| Deploy type | Build log `getDeployLog` | Runtime log `getProcessLog` |
| --- | --- | --- |
| Cloud source build (`targetPath`, CODING) | Yes — compile/package first | Yes — after the image exists |
| Existing image (`imageUrl`, `DeployType=image`) | **Skip** (no build; CODING-unaware accounts error) | **Yes** — this is the diagnosis tool |

```json
{
  "action": "getProcessLog",
  "detailServerName": "my-svc",
  "runId": "<from latestDeploy.RunId>"
}
```

`getProcessLog` returns deploy-step lines (for example `create_version_check_vpc` / `create_eks_virtual_service` / `check_eks_virtual_service`) plus container stdout/stderr (supervisor, app, probe reason). **Image and source deploys both work; it does not depend on CODING.**

### 2.2 Classify: scheduling vs port vs exit-on-start

Pull logs **twice**, 20–40 seconds apart. Compare the two `processLogText` dumps.

**Startup logs exist ≠ the service is running.** A boot banner, s6/tini line, or "starting …" is not a ready listener.

| Class | Typical signals (first pull) | Two-pull comparison | What to change | What not to change |
| --- | --- | --- | --- | --- |
| **A. Pod still scheduling / pulling** | Only deploy-step lines; empty or truncated container stdout; image-pull errors | Second pull still has no app stdout, or still stuck on pull | Registry access, image size, switch to source-build `FROM` (section 4) | `InitialDelaySeconds` |
| **B. Port / bind problem** | App stays up; "listening on 127.0.0.1" or a port ≠ `serverConfig.Port`; probe failed on connection refused | Same PID / no repeated boot banner; listener line does not match the probe port or is loopback-only | `Port`, bind-address env, `Cmd` that actually starts the HTTP server | `InitialDelaySeconds` |
| **C. Exit-on-start / restart loop** | Crash, missing command, usage/help text, supervisor respawn, `exit 0/1` immediately | **Same boot banner / same first N lines repeat** (new timestamps, same sequence) | `Cmd`/`EntryPoint`, required env, volume, supervisor workaround (section 5) | `InitialDelaySeconds` |

Only if class is **none of the above** — two pulls show **one continuous boot** (new init lines, no banner repeat) and the process has **not listened yet** — may the start be genuinely slow. Then raise `InitialDelaySeconds` (see section 3).

### 2.3 How to read a restart loop

1. Copy the first distinctive line after PID 1 (banner, "starting gateway", "s6-supervise").
2. Search that line in the same log. **Two or more copies with advancing timestamps** ⇒ respawn storm.
3. Confirm with a second `getProcessLog`: if the newest chunk is again that banner rather than later "listening" lines, the process is not making progress.
4. A single "listening" line that never updates, followed by probe failures, is class B, not a slow start.

## 3. Readiness probe mechanics

After deploy steps finish:

1. Wait **N** seconds (`serverConfig.InitialDelaySeconds`).
2. Probe the service **port** about every **5 seconds**.
3. About **30** consecutive failures ⇒ this deploy is failed.
4. Failure window ≈ **N + 150 seconds**. This is **not** "declare failed N seconds after deploy".

**Forbidden default:** `probe failed` / `deploy_failed` ⇒ set `InitialDelaySeconds=120`.

Raising N only **delays the same failure** when the process is crash-looping or bound to loopback. It helps only when logs prove the process is still doing one-shot init (JVM warmup, migrations) and will listen if given more of the window.

## 4. `docker.io` / Docker Hub pull loops → source build

When `imageUrl` points at a public registry (`docker.io`, Docker Hub) and deploys fail in class A with repeated pull errors:

1. Stop retrying the same `imageUrl` on CloudRun nodes.
2. Add a local Dockerfile whose only job is to let **CODING** pull the public image:

```dockerfile
FROM docker.io/example/app:latest
```

3. Deploy with `targetPath` (cloud source build), not `imageUrl`.
4. CODING build machines pull `docker.io`; the build artifact is stored in CCR; CloudRun nodes pull from the **intranet**.

Keep `Cmd` / `EnvParams` / `VolumesConf` / `Port` from section 1 on that source deploy. Source build fixes **pull topology**, not a wrong start command.

Private registries (`ghcr.io`, Harbor) still use the local-pull → tag → push-to-CCR path in `../SKILL.md`.

## 5. Supervisor images (s6 / tini / supervisord)

If PID 1 is `s6-svscan`, `tini`, `supervisord`, or similar:

- The line you see first is often the **supervisor**, not the HTTP app. Search logs for the child you documented in section 1.
- Respawn storms look like class C: the same child start line every few seconds.
- `pgrep -f` / duplicate-instance guards can match **container PID 1's argv** and kill/respawn the real process. If the image's issue tracker documents this, apply that workaround (absolute `Cmd`, flags such as `--no-supervise`) instead of probe-delay tuning.
- Workaround must come from **that image's docs or issues**. Do not invent supervisor flags.

## Appendix — worked example: hermes-agent

This appendix is **one** application of sections 1–5. Do not skip the generic SOP because the image name matches.

**Image:** `docker.io/nousresearch/hermes-agent:latest`  
**Docs:** https://hermes-agent.nousresearch.com/docs/user-guide/docker

### What the docs require (section 1)

| Fact | From official Docker docs | Typical CloudRun mapping |
| --- | --- | --- |
| Cmd | `gateway run` (compose `command: gateway run`) | `Cmd: ["gateway", "run"]` |
| Port | `8642` (API + health); dashboard `9119` is separate | `Port: 8642` — do not use `3000` |

## vpc-and-database

# CloudRun VPC and Database Connectivity

Use this reference when deploying **existing / third-party apps** (GitHub projects, Docker images, classic backends) that talk to databases over **TCP connection strings**, not CloudBase SDK APIs.

Official docs: [VPC configuration for CloudBase Run](https://docs.cloudbase.net/run/deploy/networking/vpc)

## 先决策：真的需要 TCP 直连吗？（SDK 优先）

进入本文件（VPC / 安全组 / 连接串）之前，先确认 TCP 直连是**必要**的，而不是默认的。SDK / 网关路径不经过 VPC、不需要数据库账号密码，天然避开直连的网络与凭证问题：

| 维度 | SDK / 网关路径（优先） | TCP 直连（兜底） |
| --- | --- | --- |
| 网络配置 | 无需 `VpcConf` | 必须绑定同 VPC + 安全组放行 DB 端口 |
| 数据库凭证 | 环境内置，无需注入**数据库**账号密码（≠ 不需要凭证，见下方注） | 需要生成 / 注入 / 轮换账号密码 |
| 典型故障 | 基本没有 | `ETIMEDOUT`、安全组拦截、密码错误、VPC 未挂载 |
| 适用场景 | 新应用 / CloudBase 原生数据（PG、NoSQL、storage） | 迁移已有应用、SDK 不覆盖的能力（特定 SQL 方言、Redis 原生协议等） |

SDK 路径的具体形态：

- CloudBase PG → `app.rdb()`（js-sdk v3 / node-sdk，走 PG HTTP 网关；见 `../../postgresql-development-cloudbase/SKILL.md`）
- NoSQL → `app.database()`；对象存储 → `app.storage`
- 若新应用只需要这些数据面，还可考虑直接用 HTTP 云函数（内置 SDK、免 VPC），不上云托管容器

仅当应用是经典 TCP 客户端（mysql2 / pg / Prisma / SQLAlchemy / WordPress / Ghost 等迁移场景）且改造为 SDK 的方案被否决时，才继续往下走 VPC 流程。

🔴 **前提：数据库端必须真的有 TCP 可达端点。** CloudBase PG 分**共享（shared）**与**独享（dedicated）**实例——**只有独享实例提供私网 host / TCP 直连**，共享实例只能走 SDK / 网关访问。所以在决定走这条路之前，**先确认实例类型**（`queryEnv(action="info")` 返回的 `EnvInfo.PostgreSQL[].TenantType`）：如果实例是共享的，`VpcConf` 怎么配都连不上（表现为 `ECONNREFUSED`、连接超时，网络类查询还会被平台以「资源检查失败」拒绝），需要先把实例**升级到独享**，或者改走 SDK。
**不要向用户索要 VPC ID / 子网 ID，也不要让用户去找网络部** —— VPC 与子网从数据库实例自身的详情里读，让用户去别的部门要网络信息是一条走不通的路。

**共享实例要升到独享，走现成的 recipe**：`../../cloud-api-operations/references/recipes/pg-instance-spec.md`（Recipe 3）。先看 `TenantType` 分流——`SHARED` 走「共享升独享」（`UpgradePGInstanceToDedicated`），`DEDICATED` 走调规格；提交后用返回的 `TaskId` 轮询进度，不要凭感觉估计要多久。⚠️ 该 recipe 的「共享升独享」分支**已跑通**（标准版环境 → `1 核 2 GiB` + 10 GB，约 2 分 49 秒到 `Succeed`）；recipe 整体仍标「部分实证」，因为其余分支（套餐准入逐档验证、`SwitchTag: 1` 指定时间、独享→共享）未跑，执行前先核对里面的前置条件。

> ⚠️ **「无需数据库账号密码」≠「无需凭证」。** SDK / 网关路径省掉的是数据库账号密码与 `VpcConf`，但服务实例调用 CloudBase 资源（PG `app.rdb()` / NoSQL / storage）仍要带 CloudBase 资源访问凭证：由 `manageAppAuth(action="createApiKey", keyType="api_key")` 签发，经 `serverConfig.EnvParams` 注入 `CLOUDBASE_APIKEY`，不要从本地客户端登录态里取。完整步骤见 `../../cloud-functions/references/http-function-credentials.md`。

## Critical distinction

| Concept | What it controls | Typical field |
| --- | --- | --- |
| **Ingress access type** | How callers reach the CloudRun **service** (public HTTPS, mini program, VPC-only ingress) | `OpenAccessTypes` |
| **Egress / private network** | Whether CloudRun **instances** join a VPC so they can reach MySQL / PostgreSQL / Redis / CVM inside that VPC | `serverConfig.VpcConf` |

These are independent. A service can be publicly reachable (`OpenAccessTypes: ["PUBLIC"]`) **and** still need `VpcConf` so the process can open a TCP connection to a private database.

## VPC bind timing (important)

Evidence and docs are mixed; do **not** assume delete+recreate is always required.

What we know:

1. **`@cloudbase/manager-node` &lt; 5.6.2** silently dropped `VpcConf` in `parseObjectToDiffConfigItem`, so MCP/CLI deploy never sent VPC on create **or** update. That alone can look like “update ignored VPC”.
2. **`>= 5.6.2`** serializes `VpcConf` into deploy `Items` for both `CreateCloudRunServer` and `UpdateCloudRunServer`. MCP also maps `VpcConf` → top-level `vpcInfo` (`CreateType: 2`) on create.
3. **Current CloudBase docs** say VPC can be set at create **or** changed later in service settings ([VPC configuration](https://docs.cloudbase.net/run/deploy/networking/vpc)). An older product page said VPC cannot be changed; treat that as outdated unless you observe otherwise.

Practical agent rules:

1. Always pass `serverConfig.VpcConf` when the app needs TCP access to a VPC DB/cache.
2. Prefer correct VPC on **first** create.
3. If the service already exists:
   - Prefer `manageCloudRun(action="updateConfig")` to change VPC / EnvParams / MinNum without re-uploading code (console-aligned `SubmitServerConfigChangeDiff`).
   - Or redeploy with `VpcConf`. MCP **deploy** uses Read-Merge-Write: omitting `VpcConf` / partial `EnvParams` / omitting `OpenAccessTypes` **preserves** remote values (set `envParamsReplaceAll=true` only when you intend a full env replace).
   - Then **verify** with `queryCloudRun(action="detail")` (`ServerConfig.VpcConf`).
4. If detail still shows missing/wrong VPC after a successful update, fall back to console network settings or delete + recreate — do not loop blind redeploys.

## When VpcConf is mandatory

Treat VPC binding as **required** before deploy when **any** of these signals appear:

- Env vars: `DATABASE_URL`, `DB_HOST`, `MYSQL_*`, `POSTGRES_*`, `PGHOST`, `PG_*`, `REDIS_*`, `MONGO_*`, `SQLALCHEMY_DATABASE_URI`, `SPRING_DATASOURCE_*`
- Connection URLs: `postgres://`, `postgresql://`, `mysql://`, `redis://`, `mongodb://`
- Project files: `docker-compose*.yml` with db/redis services, `.env.example` with DB hosts, ORM configs pointing at a host:port
- User intent: "use CloudBase MySQL / TencentDB / self-hosted PG / Redis in VPC"

## When VpcConf is NOT required for database access

- Browser or Mini Program apps that only use CloudBase PG via `app.rdb()` / PG HTTP gateway
- Backends that only use CloudBase NoSQL / storage SDKs over public CloudBase APIs
- Pure compute services with no VPC-private dependencies

If the user says "PostgreSQL" but the app is a classic TCP client (for example new-api, WordPress, Ghost, most Go/Java/Python ORMs), do **not** assume CloudBase PG SDK mode is a drop-in. Prefer a TCP-reachable database in the same VPC, or explicitly redesign the app to use the SDK/gateway.

## Mandatory deploy sequence (existing app + DB)

1. **Detect** DB / cache dependency signals in code and env templates.
2. **Choose DB shape**
   - Existing TCP app → CloudBase MySQL / TencentDB / other VPC DB with private hostname
   - New CloudBase-native app → CloudBase PG + `app.rdb()` (no CloudRun VPC required for gateway access)
3. **Resolve network**
   - VPC and subnet must be in the **same region** as the CloudRun service
   - Prefer the **same VPC** as the database
   - Ensure the subnet has enough free IPs for CloudRun instances
   - **Do NOT invent** `vpc-` / `subnet-` IDs or paste doc placeholders into a real deploy
   - Resolve real IDs from the DB console, an existing working resource detail, `callCloudApi` describe APIs, or the user — **stop** if still unknown
4. **Configure security groups / allowlists** so the CloudRun subnet can reach the DB port (typically 3306 / 5432 / 6379).
5. **Set env vars to private endpoints** (intranet host), not public endpoints, unless the user explicitly requires public access and has opened the allowlist.
6. **Deploy with both** public ingress (if needed) **and** `VpcConf`:

```json
{
  "action": "deploy",
  "serverName": "my-existing-app",
  "targetPath": "/abs/path/to/app",
  "serverConfig": {
    "OpenAccessTypes": ["PUBLIC"],
    "Cpu": 0.5,
    "Mem": 1,
    "MinNum": 1,
    "MaxNum": 5,
    "EnvParams": "{\"DATABASE_URL\":\"postgres://user:pass@10.x.x.x:5432/db\"}",
    "VpcConf": {
      "VpcId": "vpc-xxxxxxxx",
      "SubnetId": "subnet-xxxxxxxx"
    }
  }
}
```

7. **Verify** with `queryCloudRun(action="detail")` that VPC is attached, then hit an app health/db-check endpoint or inspect runtime logs for connection errors.

## Do not ship this anti-pattern

```json
{

## rule

---
name: cloudrun-development
description: CloudBase Run backend development rules (Function mode/Container mode). Use this skill when deploying backend services that require long connections, multi-language support, custom environments, AI agent development, or migrating existing/GitHub apps that need VPC access to MySQL/PostgreSQL/Redis. Also use when diagnosing CloudRun container deploy failures (deploy_failed, readiness/probe failed, image won't start, docker.io pull loops) or a deploy stuck behind a running deploy task. For stateless HTTP services, prefer HTTP cloud functions.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

**Cross-cutting protocols** (required before writing HTTP handlers or deploying images):
- Sensitive Runtime Data Protection: `../cloudbase-platform/references/protocols/sensitive-runtime-data-protection.md`
- Deployment Gate: `../cloudbase-platform/references/protocols/deployment-gate.md`

# CloudBase Run Development

## Activation Contract

### Use this first when

- The task is to initialize, run, deploy, inspect, or debug a CloudBase Run service.
- The request needs a long-lived HTTP service, SSE, WebSocket, custom system dependencies, or container-style deployment.
- The task is to create or run an Agent service on CloudBase Run.
- The task migrates an **existing / GitHub / third-party** backend that uses classic `DATABASE_URL` / TCP database clients.
- The service requires a **stable independent process** (long connections, custom runtime, VPC database access) — see the 「云托管 vs HTTP 云函数」 decision section below. A Dockerfile alone is **not** a strong trigger.

### Read before writing code if

- You still need to choose between Function mode and Container mode.
- The prompt mentions `queryCloudRun`, `manageCloudRun`, Dockerfile, service domains, or public/private access.
- The app depends on MySQL, PostgreSQL, Redis, or other VPC-private resources over TCP → **先做数据库访问方式决策（SDK/网关优先，见下方「数据库访问方式决策门」）**；确认必须 TCP 直连后 → also read `references/vpc-and-database.md`.
- You are choosing between CloudRun and HTTP cloud functions for a stateless HTTP service.
- The service calls CloudBase resources (PG `app.rdb()`, NoSQL, storage, functions) through an SDK → **先过「计算资源访问 CloudBase 的凭证决策门」**：凭证谁签发、怎么注入、怎么吊销，都必须在写代码之前定下来。
- Container deploy fails (`deploy_failed`, Pod not ready, readiness/probe failed, third-party `imageUrl` won't stay up) → also read `references/image-deploy-troubleshooting.md` and follow the **Container deploy failure SOP** below. Do not start by raising `InitialDelaySeconds`.

### Then also read

- Cloud functions instead of CloudRun -> `../cloud-functions/SKILL.md`
- Agent SDK and AG-UI specifics -> `../cloudbase-agent/SKILL.md`
- Web authentication for browser callers -> `../auth-web-cloudbase/SKILL.md`
- Existing app + TCP database networking -> `references/vpc-and-database.md`
- Container image deploy failure / probe / `deploy_failed` -> `references/image-deploy-troubleshooting.md`
- Service calls CloudBase resources through an SDK (credential source / injection / revocation) -> `../cloud-functions/references/http-function-credentials.md`
- Billing questions about a CloudRun charge ("why was I charged when nothing was deployed", "the free quota wasn't used up") -> `../cloud-api-operations/references/recipes/billing-charges-explained.md` (the gifted quota is a **3-month total**, and a container bills while **instance count is not 0**)

### Do NOT use for

- Simple Event Function or HTTP Function workflows that fit the function model better.
- Frontend-only projects with no backend service.
- Database-schema design tasks.

### Common mistakes / gotchas

- Choosing CloudRun when the request only needs a normal cloud function.
- **Forgetting to listen on the platform-provided `PORT` in Container mode** — and its mirror image in Function mode: calling `app.listen()` there, where the framework already owns the port and the second bind dies with `EADDRINUSE`.
- **Guessing the credential environment variable name.** `@cloudbase/node-sdk` reads `CLOUDBASE_APIKEY`; an invented name (for example `TCB_API_KEY`) is silently ignored and only shows up later as "no credentials at runtime".
- **Copying a server credential out of the local client login state** (`auth.json`, `.cloudbase/`) and injecting it into a deployed service. Issue the key with `manageAppAuth(action="createApiKey", keyType="api_key")` instead, so it has an owner, a rotation path, and a `keyId` you can revoke. See `../cloud-functions/references/http-function-credentials.md`.
- **Baking static content into the image — media files, user uploads, or assets that change on their own cadence.** Three cases, one root cause: the image is rebuilt, re-pushed and re-pulled on every deploy *and* on every scale-up, so anything large or independently-changing makes every deploy slower for no reason.
  - **Media files** (`*.mp4`, large images, fonts) pulled in by a `COPY . .` — one demo video can turn a 30-second deploy into a multi-minute one. Media belongs in cloud storage, referenced by URL. Add a `.dockerignore` covering `*.mp4`, `*.mov`, `*.zip`, `*.psd`, and media directories such as `public/videos/`.
  - **User uploads written to the container filesystem** — the service is stateless; anything on local disk is gone on the next deploy, restart, or scale-out. Uploads go to cloud storage.
  - **Frequently-updated static resources served from the image** — if an asset changes on its own schedule, every change forces a full service redeploy. Serve it from cloud storage so the service only redeploys when the *code* changes.
- Treating CloudRun as stateful app hosting and storing important state on local disk.
- Assuming local run is available for Container mode.
- Opening public access by default when the scenario only needs private or mini-program internal access.
- **Deploying an existing app with `DATABASE_URL` / MySQL / PostgreSQL / Redis but omitting `serverConfig.VpcConf`** — deploy appears to succeed, then runtime DB connections fail.
- **新应用部署默认选 TCP 直连数据库** — 能用 SDK/网关访问的数据（PG `app.rdb()`、NoSQL、storage）不需要 `VpcConf` 也不需要数据库账号密码；仅迁移类应用（经典驱动/ORM 无法替换）才走 TCP 直连 + `VpcConf`。见「数据库访问方式决策门」。
- Confusing `OpenAccessTypes` (how users reach the service) with `VpcConf` (how the service reaches VPC databases).
- **Deploying to an environment that has not initialized CloudRun** — `CreateCloudRunServer` on an environment with no 大租户 record silently lands in the legacy 小租户 path, creating wrong small-tenant services/versions. Always ensure the environment is initialized first (`manageCloudRun(action="initEnv")`, tcbr) before the first deploy. `manageCloudRun(action="deploy")` now blocks new-service creation on uninitialized environments with guidance.
- **Using the legacy `tcb` CloudRun API** (`CreateCloudBaseRunResource` / `DescribeCloudBaseRunResource` / `DeleteCloudBaseRunResource`) — these are deprecated 小租户 open APIs and are blocked in `callCloudApi`. CloudRun always goes through `tcbr` (`CreateCloudRunEnv` / `CreateCloudRunServer`). Query a single environment's base info / whether CloudRun is enabled with `DescribeEnvBaseInfo` (`EnvId` required) — use `manageCloudRun(action="initEnv")` to open and `queryCloudRun(action="envStatus")` to poll status; query the environment list / resource info with `DescribeCloudRunEnvs` (`EnvId` optional filter).
- **Deploying `httpbin` / request-echo images or returning `req.headers` / `process.env`** — CloudBase may inject `x-cloudbase-context` (base64 temporary credentials). Echoing it leaks account cloud access. Follow `../cloudbase-platform/references/protocols/sensitive-runtime-data-protection.md`.
- **Seeing readiness probe failed / `deploy_failed` and immediately raising `InitialDelaySeconds`** — the probe window is already ~N+150s; crash loops and loopback binds are not slow-start. Follow the Container deploy failure SOP.
- **Deploying a third-party image without reading its run docs** — missing `Cmd`, bind-address env, or `VolumesConf` looks identical to a probe failure.
- **Calling `getDeployLog` for `imageUrl` deploys** — that is CODING build log; use `getProcessLog`.
- **Treating startup banners as proof the service is healthy** — pull `getProcessLog` twice and compare; a repeated boot sequence is a restart loop.

### Minimal checklist

- Choose Function mode or Container mode explicitly.
- **Confirm the environment has CloudRun initialized before the first deploy** — a brand-new environment must call `CreateCloudRunEnv` (tcbr) first; never `CreateCloudRunServer` on an uninitialized environment (it falls back to the legacy 小租户 path). `manageCloudRun(action="deploy")` validates this automatically and blocks new services on uninitialized environments. When blocked, first call `manageCloudRun(action="initEnv", envId=...)` (异步开通) and poll `queryCloudRun(action="envStatus")` until `Status=normal`, or reconsider an HTTP cloud function to bypass CloudRun entirely.
- Confirm whether the service should be public, VPC-only, or mini-program internal (**ingress**).
- If the app uses TCP databases/caches, resolve and set `VpcConf` (**egress / private network**) before deploy — see `references/vpc-and-database.md`.
- Keep the service stateless and externalize durable data.
- **Separate static from dynamic**: media files, user uploads, and frequently-updated assets live in cloud storage, not in the image. Check what the Dockerfile copies in.
- **Settle the credential path for every CloudBase SDK call before writing code** — a server API Key issued through `manageAppAuth(action="createApiKey")` and injected via `EnvParams`, never a key copied out of the local client login state.
- Use absolute paths for every local project path.
- Confirm handlers never echo `x-cloudbase-context`, full headers, or credential env vars; do not deploy httpbin-style reflectors.
- For third-party images, complete the five-item docs checklist (Cmd / port / bind env / volume / health) before deploy.

## Overview

Use CloudBase Run when the task needs a deployed backend service rather than a short-lived serverless function.

### 云托管 vs HTTP 云函数（按需求选，不按文件选）

> 核心原则：**HTTP 云函数优先**。只有需求真正需要云托管时才用云托管；有 `Dockerfile` 不等于必须上云托管。

**HTTP 云函数更合适（优先）：**

- 无状态 HTTP 服务，监听 `PORT`/`9000`，只做「请求进来 → 处理 → 响应」的响应式逻辑
- 短生命周期请求，无长连接需求（SSE/WebSocket 之外的普通 API、CRUD、转发）
- 标准 runtime 够用（不需要自定义系统依赖、不需要非标准语言）——需要时也能用镜像函数（Custom Image HTTP Function）跑，仍然在函数这条线上
- 部署更快、费用更低（按请求计费，可缩容到 0）、**无需初始化云托管环境**
- 有 `Dockerfile` 但服务本质是无状态 HTTP → 优先 HTTP 云函数（HTTP Function / Custom Image HTTP Function），不必上云托管

**云托管才需要（只有以下之一才选云托管）：**

- 长连接：WebSocket、SSE 长连接、服务端推送
- 需要常驻的独立进程：后台任务循环、常驻缓存 / 连接池、自管端口的服务
- VPC 内数据库 / Redis 访问（`VpcConf` 私有网络连通）
- Agent 服务（Function mode CloudRun）
- 迁移已有 / GitHub / 第三方应用

**语言不是上云托管的条件**：非标准语言（Java / Rust / C++ / PHP / .NET 等）或需要自定义系统依赖时，只要服务仍是「请求进来 → 响应」且无长连接，打成镜像用 Custom Image HTTP Function，就还是函数；只有再叠加常驻 / 长连接 / VPC 才上云托管。

**决策示例：** 一个带 `Dockerfile` 的 Go/Python HTTP API，无长连接、无自定义系统依赖、不碰 VPC 数据库 → 选 HTTP 云函数而不是云托管；同一份代码若有 WebSocket 长连接 → 才选云托管。


## rule

---
name: data-model-creation
description: "[Deprecated] Optional advanced tool for complex data modeling. For simple MySQL table creation, use relational-database-tool directly; for PostgreSQL / CloudBase PG schema work, use postgresql-development. New environments should use PostgreSQL DDL via queryPgDatabase/managePgDatabase — see postgresql-development skill instead."
version: 2.35.2
license: MIT
alwaysApply: false
metadata:
  priority: "5"
  deprecated: "true"
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

# Data Model Creation

## Activation Contract

### Use this first when

- The user explicitly wants Mermaid `classDiagram` modeling.
- The task needs complex multi-entity relational design, visual ER-style output, or generated data-model structure rather than direct SQL.
- You need to create CloudBase data models through the dedicated modeling tools, or you need to inspect an existing model before planning follow-up changes.

### Read before writing code if

- The request mentions data model, ER diagram, Mermaid, relationship graph, or enterprise schema design.
- The user wants to reuse or update an existing published model.

### Then also read

- Direct MySQL SQL creation or schema change -> `../relational-database-mcp-cloudbase/SKILL.md`
- PostgreSQL / CloudBase PG schema work -> `../postgresql-development-cloudbase/SKILL.md`
- Broader feature planning before schema work -> `../spec-workflow/SKILL.md`

### Do NOT use for

- Simple `CREATE TABLE`, `ALTER TABLE`, or CRUD tasks.
- Document-database collection design.
- Frontend-only data-shape discussions with no modeling requirement.

### Common mistakes / gotchas

- Using Mermaid modeling for a task that only needs one or two SQL statements.
- Mixing SQL-table design and NoSQL collection design in the same model.
- Generating diagrams without first deciding entity boundaries and ownership relations.
- Publishing a new model before validating the generated fields and relationships.

### Minimal checklist

- Confirm Mermaid modeling is actually needed.
- List the core entities and relationships first.
- Decide whether this is a new model or an update.
- Keep the initial model small unless the user explicitly wants a large enterprise schema.

## Overview

This skill is an **advanced modeling path**, not the default path for database work.

- For most MySQL database tasks, use `relational-database-mcp-cloudbase` and write SQL directly. If the task says PostgreSQL, CloudBase PG, PG mode, `app.rdb()`, `queryPgDatabase`, `managePgDatabase`, or RLS, use `postgresql-development-cloudbase` instead.
- Use this skill only when diagram-driven modeling adds value.

## Quick routing

### Use `relational-database-mcp-cloudbase` instead when

- You need MySQL `CREATE TABLE`, `ALTER TABLE`, `INSERT`, `UPDATE`, `DELETE`, or `SELECT`
- The schema is small and already clear
- The user never asked for a visual model
- The task does **not** mention PostgreSQL / CloudBase PG / PG mode / `app.rdb()` / `queryPgDatabase` / `managePgDatabase` / RLS

### Use this skill when

- You need multi-entity relationship modeling
- You need Mermaid `classDiagram` output
- You want generated model structure and documentation
- You need a clean modeling pass before SQL implementation

## How to use this skill (for a coding agent)

1. **Clarify the entity set**
   - Extract business entities, ownership, and relationship cardinality from the request.
   - Prefer 3-5 core entities unless the user clearly asks for more.

2. **Model first, then generate**
   - Draft Mermaid `classDiagram` content.
   - Validate names, field types, and relationships before calling modeling tools.

3. **Use the right tools**
   - Read/list existing models -> `manageDataModel(action="list"|"get"|"docs")`
   - Create a new model -> `modifyDataModel` (compatibility name; create-only)

4. **Publish carefully**
   - Prefer creating with unpublished or draft-like intent first.
   - Publish only after checking field names, required constraints, and relationship directions.

## Mermaid generation rules

### Naming

- Class names -> PascalCase
- Field names -> camelCase
- Convert Chinese business descriptions into clear English identifiers
- Keep enum values human-readable when needed

### Type mapping

| Business meaning | Mermaid type |
| --- | --- |
| text | `string` |
| number | `number` |
| boolean | `boolean` |
| enum | `x-enum` |
| email | `email` |
| phone | `phone` |
| URL | `url` |
| image | `x-image` |

## checklist

# HTTP API Routing Checklist

Use this checklist when the request comes from Android, iOS, Flutter, React Native, backend scripts, or any environment that is not using a CloudBase SDK.

## Required checks

1. Confirm the caller really needs raw HTTP APIs rather than Web SDK or MCP tools.
2. Confirm environment ID, region, and gateway base URL.
3. Choose the auth mechanism: AccessToken, API Key, or Publishable Key.
4. Query the matching OpenAPI definition before writing request code.
5. For database work, confirm which REST API is needed:
   - **关系型数据库 REST** (MySQL / PostgreSQL): `https://{envId}.api.tcloudbasegateway.com/v1/rdb/rest/{table}` — PostgREST 风格
   - **NoSQL REST**: `https://{envId}.api.tcloudbasegateway.com/v1/database/instances/{instance}/databases/{database}/` — EJSON 格式
6. For AI model access, confirm the calling pattern:
   - **SDK 方式** (Node/Web/微信小程序): 走各端 SDK，不需要裸调 HTTP
   - **HTTP API 方式**: `https://{envId}.api.tcloudbasegateway.com/...` — 参考 OpenAPI `ai_model`
7. Verify the OpenAPI spec is available in `searchKnowledgeBase` before writing code:
   - `mysqldb` — 关系型数据库 REST
   - `nosql` — NoSQL REST
   - `ai_model` — AI 大模型接入
   - `auth` / `functions` / `cloudrun` / `storage` — 其他

## Do not route here when

- The user is building a Web frontend with `@cloudbase/js-sdk`.
- The user is building a CloudBase mini program with `wx.cloud`.
- The task is MCP-driven database management rather than raw HTTP calls.
- The user is calling AI models from Node/Web/微信 — use `ai-model-*` skills instead; only use HTTP API for unsupported runtimes.

## Done criteria

- SDK support boundary is explicit.
- The correct REST API variant (关系型 / NoSQL / AI) has been identified.
- OpenAPI source has been checked (`searchKnowledgeBase` with the right `apiName`).
- The auth method and request base URL are fixed before code generation.

## extended-guide

# Extended guide — http-api-cloudbase

> Moved from SKILL.md to satisfy Agent Skills Spec 500-line limit.

## Usage Examples

### Cloud Function Invocation Example

```bash
curl -X POST "https://your-env-id.api.tcloudbasegateway.com/v1/functions/YOUR_FUNCTION_NAME" \
  -H "Authorization: Bearer <access_token/apikey/publishable_key>" \
  -H "Content-Type: application/json" \
  -d '{"name": "张三", "age": 25}'
```

For detailed API specifications, always download and reference the OpenAPI Swagger files mentioned above.

## 关系型数据库 RESTful API (PostgREST 风格)

> **适用于 MySQL 和 PostgreSQL**：两者均基于 PostgREST 风格暴露 REST API，端点格式和请求语义一致。

提供关系型数据库（MySQL / PostgreSQL）的 HTTP 操作接口。

### Base URL Patterns

Support three domain access patterns:

1. `https://{envId}.api.tcloudbasegateway.com/v1/rdb/rest/{table}`
2. `https://{envId}.api.tcloudbasegateway.com/v1/rdb/rest/{schema}/{table}`
3. `https://{envId}.api.tcloudbasegateway.com/v1/rdb/rest/{instance}/{schema}/{table}`

Where:
- `envId` is the environment ID
- `instance` is the database instance identifier
- `schema` is the database name
- `table` is the table name

If using the system database, **recommend pattern 1**.

### Request Headers

| Header | Parameter | Description | Example |
|--------|-----------|-------------|---------|
| Accept | `application/json`, `application/vnd.pgrst.object+json` | Control data return format | `Accept: application/json` |
| Content-Type | `application/json`, `application/vnd.pgrst.object+json` | Request content type | `Content-Type: application/json` |
| Prefer | Operation-dependent feature values | - `return=representation` Write operation, return data body and headers<br>- `return=minimal` Write operation, return headers only (default)<br>- `count=exact` Read operation, specify count<br>- `resolution=merge-duplicates` Upsert operation, merge conflicts<br>- `resolution=ignore-duplicates` Upsert operation, ignore conflicts | `Prefer: return=representation` |
| Authorization | `Bearer <token>` | Authentication token | `Authorization: Bearer <access_token>` |

### Query Records

**GET** `/v1/rdb/rest/{table}`

**Query Parameters**:
- `select`: Field selection, supports `*` or field list, supports join queries like `class_id(grade,class_number)`
- `limit`: Limit return count
- `offset`: Offset for pagination
- `order`: Sort field, format `field.asc` or `field.desc`

**Example**:

```bash
# Before URL encoding
curl -X GET 'https://your-env.api.tcloudbasegateway.com/v1/rdb/rest/course?select=name,position&name=like.%张三%&title=eq.文章标题' \
  -H "Authorization: Bearer <access_token>"

# After URL encoding
curl -X GET 'https://your-env.api.tcloudbasegateway.com/v1/rdb/rest/course?select=name,position&name=like.%%E5%BC%A0%E4%B8%89%&title=eq.%E6%96%87%E7%AB%A0%E6%A0%87%E9%A2%98' \
  -H "Authorization: Bearer <access_token>"
```

**Response Headers**:
- `Content-Range`: Data range, e.g., `0-9/100` (0=start, 9=end, 100=total)

### Insert Records

**POST** `/v1/rdb/rest/{table}`

**Request Body**: JSON object or array of objects

> 💡 **Identity fields differ by database mode**: In PostgreSQL / CloudBase PG, do **not** use `_openid`. Prefer owner columns with `DEFAULT auth.uid()` (JWT `sub`) and omit the owner field from INSERT bodies. In legacy MySQL/NoSQL-oriented examples, `_openid` may be populated by the platform; do not copy that pattern into PG tables.

**Example**:

```bash
curl -X POST 'https://your-env.api.tcloudbasegateway.com/v1/rdb/rest/course' \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{
    "name": "数学",
    "position": 1
  }'
```

### Update Records

**PATCH** `/v1/rdb/rest/{table}`

**Request Body**: JSON object with fields to update

**Example**:

```bash
curl -X PATCH 'https://your-env.api.tcloudbasegateway.com/v1/rdb/rest/course?id=eq.1' \
  -H "Authorization: Bearer <access_token>" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{
    "name": "高等数学",
    "position": 2
  }'
```

> ⚠️ **Important**: UPDATE requires a WHERE clause. Use query parameters like `?id=eq.1` to specify conditions.

### Delete Records

**DELETE** `/v1/rdb/rest/{table}`

**Example**:

## rule

---
name: http-api-cloudbase
description: CloudBase official HTTP API client guide. This skill should be used when backends, scripts, or non-SDK clients must call CloudBase platform APIs over raw HTTP instead of using a platform SDK or MCP management tool.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## Activation Contract

### Use this first when

- The request comes from Android, iOS, Flutter, React Native, non-Node backends, or admin scripts that must call official CloudBase APIs via raw HTTP.
- The task is to consume CloudBase platform endpoints, not to build a new HTTP service on CloudBase.

### Read before writing code if

- The platform does not support a CloudBase SDK, or the user explicitly asks for HTTP API integration.
- The user says "HTTP API" but it is unclear whether they mean official CloudBase endpoints or their own business API.

### Then also read

- Auth configuration -> `../auth-tool-cloudbase/SKILL.md`
- MySQL MCP management -> `../relational-database-mcp-cloudbase/SKILL.md`
- Your own HTTP service on CloudBase -> `../cloud-functions/SKILL.md` or `../cloudrun-development/SKILL.md`

### Do NOT use for

- CloudBase Web SDK flows, mini program SDK flows, or MCP-driven management tasks.
- Building your own HTTP service or REST API on CloudBase.

### Common mistakes / gotchas

- Treating Web SDK examples as valid for native Apps.
- Guessing endpoints without reading OpenAPI definitions.
- Confusing official CloudBase HTTP APIs with your own function or CloudRun endpoint.
- Mixing raw HTTP API integration with MCP management logic.

### Minimal checklist

- Read [HTTP API Routing Checklist](checklist.md) before implementation.

## When to use this skill

Use this skill whenever you need to call **CloudBase platform features** via **raw HTTP APIs**, for example:

- Non-Node backends (Go, Python, Java, PHP, etc.)
- Integration tests or admin scripts that use curl or language HTTP clients
- Direct database operations via 关系型数据库 RESTful API (MySQL/PostgreSQL)
- Cloud function invocation via HTTP
- Any scenario where SDKs are not available or not preferred

Do **not** use this skill for:

- Frontend Web apps using `@cloudbase/js-sdk` (use **CloudBase Web** skills)
- Node.js code using `@cloudbase/node-sdk` (use **CloudBase Node** skills)
- Authentication flows (use **CloudBase Auth HTTP API** skill for auth-specific endpoints)

## How to use this skill (for a coding agent)

1. **Clarify the scenario**
   - Confirm this code will call HTTP endpoints directly (not SDKs).
   - Ask for:
     - `env` – CloudBase environment ID
     - Authentication method (AccessToken, API Key, or Publishable Key)
   - Confirm which CloudBase feature is needed (database, functions, storage, etc.).
   - **For user authentication**: If no specific method is requested, **always default to Phone SMS Verification** - it's the most user-friendly and secure option for Chinese users.

2. **Determine the base URL**
   - Use the correct domain based on region (domestic vs. international).
   - Default is domestic Shanghai region.

3. **Set up authentication**
   - Choose appropriate authentication method based on use case.
   - Add `Authorization: Bearer <token>` header to requests.

4. **Reference OpenAPI Swagger documentation**
   - **MUST use `searchKnowledgeBase` tool** to get OpenAPI specifications
   - Use the tool with `mode=openapi` and specify the `apiName`:
     - `mysqldb` - 关系型数据库 RESTful API (MySQL/PostgreSQL)
     - `nosql` - NoSQL RESTful API (文档型数据库)
     - `functions` - Cloud Functions API
     - `auth` - Authentication API
     - `cloudrun` - CloudRun API
     - `storage` - Storage API
     - `ai_model` - AI 大模型接入 API
   - Example: `searchKnowledgeBase({ mode: "openapi", apiName: "mysqldb" })`
   - Parse the returned YAML content to understand exact endpoint paths, parameters, request/response schemas
   - Never invent endpoints or parameters - always reference the swagger documentation

---

## Overview

CloudBase HTTP API is a set of interfaces for accessing CloudBase platform features via HTTP protocol, supporting database, user authentication, cloud functions, cloud hosting, cloud storage, AI, and more.

## OpenAPI Swagger Documentation

**⚠️ IMPORTANT: Always use `searchKnowledgeBase` tool to get OpenAPI Swagger specifications**

Before implementing any HTTP API calls, you should:

1. **Use `searchKnowledgeBase` tool to get OpenAPI documentation**:
   ```
   searchKnowledgeBase({ mode: "openapi", apiName: "<api-name>" })
   ```

2. **Available API names**:
   - `mysqldb` - 关系型数据库 RESTful API (MySQL/PostgreSQL)
   - `nosql` - NoSQL RESTful API (文档型数据库)
   - `functions` - Cloud Functions API
   - `auth` - Authentication API
   - `cloudrun` - CloudRun API
   - `storage` - Storage API

## checklist

# HTTP API Routing Checklist

Use this checklist when the request comes from Android, iOS, Flutter, React Native, backend scripts, or any environment that is not using a CloudBase SDK.

## Required checks

1. Confirm the caller really needs raw HTTP APIs rather than Web SDK or MCP tools.
2. Confirm environment ID, region, and gateway base URL.
3. Choose the auth mechanism: AccessToken, API Key, or Publishable Key.
4. Query the matching OpenAPI definition before writing request code.
5. For database work, confirm which REST API is needed:
   - **关系型数据库 REST** (MySQL / PostgreSQL): `https://{envId}.api.tcloudbasegateway.com/v1/rdb/rest/{table}` — PostgREST 风格
   - **NoSQL REST**: `https://{envId}.api.tcloudbasegateway.com/v1/database/instances/{instance}/databases/{database}/` — EJSON 格式
6. For AI model access, confirm the calling pattern:
   - **SDK 方式** (Node/Web/微信小程序): 走各端 SDK，不需要裸调 HTTP
   - **HTTP API 方式**: `https://{envId}.api.tcloudbasegateway.com/...` — 参考 OpenAPI `ai_model`
7. Verify the OpenAPI spec is available in `searchKnowledgeBase` before writing code:
   - `mysqldb` — 关系型数据库 REST
   - `nosql` — NoSQL REST
   - `ai_model` — AI 大模型接入
   - `auth` / `functions` / `cloudrun` / `storage` — 其他

## Do not route here when

- The user is building a Web frontend with `@cloudbase/js-sdk`.
- The user is building a CloudBase mini program with `wx.cloud`.
- The task is MCP-driven database management rather than raw HTTP calls.
- The user is calling AI models from Node/Web/微信 — use `ai-model-*` skills instead; only use HTTP API for unsupported runtimes.

## Done criteria

- SDK support boundary is explicit.
- The correct REST API variant (关系型 / NoSQL / AI) has been identified.
- OpenAPI source has been checked (`searchKnowledgeBase` with the right `apiName`).
- The auth method and request base URL are fixed before code generation.

## rule

---
name: http-api-cloudbase
description: CloudBase official HTTP API client guide. This skill should be used when backends, scripts, or non-SDK clients must call CloudBase platform APIs over raw HTTP instead of using a platform SDK or MCP management tool.
version: 2.24.1
alwaysApply: false
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/http-api/SKILL.md`

Keep local `references/...` paths for files that ship with the current skill directory. When this file points to a sibling skill such as `auth-tool` or `web-development`, use the standalone fallback URL shown next to that reference.

## Activation Contract

### Use this first when

- The request comes from Android, iOS, Flutter, React Native, non-Node backends, or admin scripts that must call official CloudBase APIs via raw HTTP.
- The task is to consume CloudBase platform endpoints, not to build a new HTTP service on CloudBase.

### Read before writing code if

- The platform does not support a CloudBase SDK, or the user explicitly asks for HTTP API integration.
- The user says "HTTP API" but it is unclear whether they mean official CloudBase endpoints or their own business API.

### Then also read

- Auth configuration -> `../auth-tool/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-tool/SKILL.md`)
- MySQL MCP management -> `../relational-database-tool/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/relational-database-tool/SKILL.md`)
- Your own HTTP service on CloudBase -> `../cloud-functions/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/cloud-functions/SKILL.md`) or `../cloudrun-development/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/cloudrun-development/SKILL.md`)

### Do NOT use for

- CloudBase Web SDK flows, mini program SDK flows, or MCP-driven management tasks.
- Building your own HTTP service or REST API on CloudBase.

### Common mistakes / gotchas

- Treating Web SDK examples as valid for native Apps.
- Guessing endpoints without reading OpenAPI definitions.
- Confusing official CloudBase HTTP APIs with your own function or CloudRun endpoint.
- Mixing raw HTTP API integration with MCP management logic.

### Minimal checklist

- Read [HTTP API Routing Checklist](checklist.md) before implementation.

## When to use this skill

Use this skill whenever you need to call **CloudBase platform features** via **raw HTTP APIs**, for example:

- Non-Node backends (Go, Python, Java, PHP, etc.)
- Integration tests or admin scripts that use curl or language HTTP clients
- Direct database operations via 关系型数据库 RESTful API (MySQL/PostgreSQL)
- Cloud function invocation via HTTP
- Any scenario where SDKs are not available or not preferred

Do **not** use this skill for:

- Frontend Web apps using `@cloudbase/js-sdk` (use **CloudBase Web** skills)
- Node.js code using `@cloudbase/node-sdk` (use **CloudBase Node** skills)
- Authentication flows (use **CloudBase Auth HTTP API** skill for auth-specific endpoints)

## How to use this skill (for a coding agent)

1. **Clarify the scenario**
   - Confirm this code will call HTTP endpoints directly (not SDKs).
   - Ask for:
     - `env` – CloudBase environment ID
     - Authentication method (AccessToken, API Key, or Publishable Key)
   - Confirm which CloudBase feature is needed (database, functions, storage, etc.).
   - **For user authentication**: If no specific method is requested, **always default to Phone SMS Verification** - it's the most user-friendly and secure option for Chinese users.

2. **Determine the base URL**
   - Use the correct domain based on region (domestic vs. international).
   - Default is domestic Shanghai region.

3. **Set up authentication**
   - Choose appropriate authentication method based on use case.
   - Add `Authorization: Bearer <token>` header to requests.

4. **Reference OpenAPI Swagger documentation**
   - **MUST use `searchKnowledgeBase` tool** to get OpenAPI specifications
   - Use the tool with `mode=openapi` and specify the `apiName`:
     - `mysqldb` - 关系型数据库 RESTful API (MySQL/PostgreSQL)
     - `nosql` - NoSQL RESTful API (文档型数据库)
     - `functions` - Cloud Functions API
     - `auth` - Authentication API
     - `cloudrun` - CloudRun API
     - `storage` - Storage API
     - `ai_model` - AI 大模型接入 API
   - Example: `searchKnowledgeBase({ mode: "openapi", apiName: "mysqldb" })`
   - Parse the returned YAML content to understand exact endpoint paths, parameters, request/response schemas
   - Never invent endpoints or parameters - always reference the swagger documentation

---

## Overview

CloudBase HTTP API is a set of interfaces for accessing CloudBase platform features via HTTP protocol, supporting database, user authentication, cloud functions, cloud hosting, cloud storage, AI, and more.

## OpenAPI Swagger Documentation

**⚠️ IMPORTANT: Always use `searchKnowledgeBase` tool to get OpenAPI Swagger specifications**

Before implementing any HTTP API calls, you should:

1. **Use `searchKnowledgeBase` tool to get OpenAPI documentation**:
   ```
   searchKnowledgeBase({ mode: "openapi", apiName: "<api-name>" })
   ```

2. **Available API names**:
   - `mysqldb` - 关系型数据库 RESTful API (MySQL/PostgreSQL)
   - `nosql` - NoSQL RESTful API (文档型数据库)
   - `functions` - Cloud Functions API
   - `auth` - Authentication API

## rule

---
name: minimal-web-baas-demo
description: "Fast path for a minimal CloudBase Web + database demo (最小前后端 / 最小可用 fullstack / Lovable-like BaaS). Defaults to @cloudbase/js-sdk client CRUD (NoSQL app.database / PG app.rdb), MCP-only schema, preview-first, and forbids cloud functions unless secrets, cron/background jobs, or logic that security rules/RLS cannot express. Use for 搭一套 demo、留言板、Todo、Notes、Kanban, or when users say 带云函数+云数据库 but only need CRUD. NOT for production multi-service backends, CloudRun, WeChat Mini Programs, or tasks that truly need server secrets."
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../web-development/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

# Minimal Web BaaS Demo (fast path)

Goal: **minutes to an interactive Web + database preview**, not a cloud-function middleware stack.

This skill is the product equivalent of CloudBase Sites SessionStart **Rule 5** (BaaS-first data persistence).

## Activation Contract

### Use this first when

- The user asks for a **minimal fullstack / 前后端 demo**, message board, Todo, Notes, Kanban, or Lovable/Supabase-like quick app on CloudBase Web.
- The user says "带云函数+云数据库" but the real need is CRUD + preview (reinterpret as Web SDK → database).

### Do NOT use for

- WeChat Mini Programs (`wx.cloud`) — use `../miniprogram-development/SKILL.md`.
- True server workloads: payments callbacks, SMS providers, secret third-party keys, cron/ETL, WebSockets — use `../cloud-functions/SKILL.md` or `../cloudrun-development/SKILL.md`.
- Large multi-module products that need `../spec-workflow/SKILL.md`.

## Hard rules (align with Sites SessionStart Rule 5)

1. **BaaS-first data path**
   - **Schema / admin:** Prefer MCP management tools. Do not ask the user to create collections/tables in the console. If MCP tools are missing in this session, configure MCP for next time and use `tcb` CLI (`../cloudbase-cli/SKILL.md`) for equivalent schema/admin ops.
     - NoSQL: `writeNoSqlDatabaseStructure` (create collection / indexes) + permission tools as needed; CLI: NoSQL commands in `cloudbase-cli`.
     - PostgreSQL: follow `../postgresql-development-cloudbase/SKILL.md` (`queryPgDatabase` / `managePgDatabase` / migrations); CLI parity via `tcb db pg …` when MCP is unavailable.
   - **Reads / writes:** `@cloudbase/js-sdk` in the browser.
     - NoSQL: `app.database()` → `db.collection(...).get()/add()/update()/watch(...)`.
     - PG: `app.rdb().from(...)`.
   - Prefer the template helper (often `src/utils/cloudbase.ts`). Do not invent a second SDK wrapper.

2. **Cloud functions are forbidden by default**
   - Todo / Notes / Chat / Kanban / "最小前后端 demo" → **zero** cloud functions.
   - Even if the user says "带云函数", deliver Web SDK → DB and explain in one sentence that cloud functions are not required for CRUD.
   - Create a cloud function **only when**:
     - (a) the logic cannot be expressed as database security rules / RLS, **and**
     - (b) it needs server-side secrets / third-party API keys, **or** it is a scheduled / background job not triggered by a user click.

3. **Package discipline**
   - Browser: `@cloudbase/js-sdk` only.
   - Never install `@cloudbase/node-sdk` (or random stubs) in frontend code.

4. **Preview first, deploy second**
   - Ship local list + add (or equivalent CRUD) before static hosting / CloudApp deploy.
   - Custom domains, DNS, rollback runbooks → only if the user explicitly asks.
   - Skip Playwright / agent-browser unless the user asks to test.

5. **UI ceremony for this path**
   - Reuse the template look. **Do not** load `ui-design` four-part specs for a minimal demo unless the user asks for visual redesign.
   - "Make me a X app" = X **is** the homepage (`HomePage` / `App`), not a nested demo route beside the welcome page.

6. **Anonymous (or real) session before NoSQL CRUD — js-sdk 3.x + publishable key**
   - With `@cloudbase/js-sdk` **3.x** initialized via publishable `accessKey`, call **`await auth.signInAnonymously()`** (or an equivalent authenticated session) **before** any NoSQL `app.database()` `get` / `add` / `update` / `watch`.
   - Skipping this yields **gateway 401**. `checkLogin()` / `getSession()` alone does **not** create a usable write session.
   - Minimal example:

```js
const auth = app.auth
const { error } = await auth.signInAnonymously()
if (error) throw error
const db = app.database()
await db.collection('messages').get()
```

## Capability sniff order (partners + agents)

Use this order for every minimal Web + DB demo. **Do not reorder.** Cloud functions stay off the critical path.

```text
0. Connector pre-enabled (or shortest Trust path)     ← host / partner packaging
1. Template warmup // parallel with credential wait   ← downloadTemplate + install
2. queryEnv(action="info")                            ← sniff env + RuntimeBackends
3. Lock ONE DB plane (NoSQL | PG | MySQL)             ← no mid-flight thrash
4. MCP schema + minimal permissions                   ← writeNoSql* / PG migrate / MySQL manage
5. Browser @cloudbase/js-sdk CRUD                     ← app.database() / app.rdb()
6. Local preview (list + add)                         ← then ask before deploy
7. Cloud functions                                    ← skip (count = 0) unless secrets/cron/rules-cannot-express
```

Stack priority for this path: **Web SDK CRUD > MCP schema > template warmup > cloud functions**.

## Standard playbook

1. **Warm template in parallel with credentials** (see partner notes below): `downloadTemplate` (`react` default, `vue` if requested) → `npm install` / `pnpm install`.
2. `queryEnv(action="info")` → lock **one** DB plane (NoSQL **or** PG **or** MySQL). Do not thrash between them.
3. MCP: create the collection/table + minimal permissions.
4. Frontend: ensure session (`auth.signInAnonymously()` or equivalent), then wire list + create with `@cloudbase/js-sdk` (see Hard rule 6).
5. Start / report preview URL; ask before deploy.
6. **Cloud function count for this path = 0.**

### On-demand skills (fetch only when needed)

| Need | Skill |
| --- | --- |
| Web scaffold / hosting | `../web-development/SKILL.md` |
| NoSQL browser CRUD | `../cloudbase-document-database-web-sdk/SKILL.md` |
| PG browser CRUD + MCP schema | `../postgresql-development-cloudbase/SKILL.md` |
| Auth provider readiness | `../auth-tool-cloudbase/SKILL.md` then `../auth-web-cloudbase/SKILL.md` |
| MCP connection, calling tools from the shell with mcporter, plugin flags | `../cloudbase-mcp/SKILL.md` |

Prefer `searchKnowledgeBase(mode="skill", skillName="minimal-web-baas-demo")` (or the sibling dir id) when local skill files are unavailable. **Do not** dump every CloudBase skill at session start.

## WorkBuddy / partner packaging notes (XDF and beyond)

Any partner host (WorkBuddy, CodeBuddy connectors, vertical expert prompts, ISV wrappers) should treat this skill as the **compact fast-path brief**. Reuse the sniff order above; do not invent a cloud-function-first demo path.

| Host capability | Recommended packaging |

## aggregation

# Aggregation Queries with CloudBase

This document explains how to perform aggregation operations for data analysis and statistics in CloudBase document database.

## Overview

Aggregation queries allow you to:
- Group data by specific fields
- Calculate statistics (count, sum, average, etc.)
- Transform and reshape data
- Perform complex data analysis

## Basic Aggregation Syntax

```javascript
const result = await db.collection('collectionName')
    .aggregate()
    .group({ /* grouping configuration */ })
    .end();

console.log('Results:', result.list);
```

**Note:** Aggregation queries use `.end()` instead of `.get()`

## Grouping Data

### Simple Grouping with Count

Count documents by a specific field:

```javascript
// Count todos by priority
const result = await db.collection('todos')
    .aggregate()
    .group({
        _id: '$priority',  // Group by priority field
        count: {
            $sum: 1        // Count documents in each group
        }
    })
    .end();

console.log('By priority:', result.list);
// Output: [
//   { _id: 'high', count: 15 },
//   { _id: 'medium', count: 23 },
//   { _id: 'low', count: 8 }
// ]
```

### Field Reference Syntax

Use `$` prefix to reference document fields:
- `$priority` - References the `priority` field
- `$status` - References the `status` field
- `$user.name` - References nested fields

## Aggregation Operators

### Accumulator Operators

| Operator | Description | Usage |
|----------|-------------|-------|
| `$sum` | Sum values | `{ total: { $sum: '$amount' } }` |
| `$avg` | Average values | `{ avgScore: { $avg: '$score' } }` |
| `$min` | Minimum value | `{ minPrice: { $min: '$price' } }` |
| `$max` | Maximum value | `{ maxPrice: { $max: '$price' } }` |
| `$first` | First value | `{ first: { $first: '$date' } }` |
| `$last` | Last value | `{ last: { $last: '$date' } }` |
| `$push` | Array of all values | `{ items: { $push: '$name' } }` |

## Common Aggregation Patterns

### Count by Category

```javascript
// Count users by role
const result = await db.collection('users')
    .aggregate()
    .group({
        _id: '$role',
        count: { $sum: 1 }
    })
    .end();
```

### Sum and Average

```javascript
// Calculate total and average order amount by customer
const result = await db.collection('orders')
    .aggregate()
    .group({
        _id: '$customerId',
        totalAmount: { $sum: '$amount' },
        averageAmount: { $avg: '$amount' },
        orderCount: { $sum: 1 }
    })
    .end();
```

### Find Min and Max

```javascript
// Find price range by product category
const result = await db.collection('products')
    .aggregate()
    .group({
        _id: '$category',
        minPrice: { $min: '$price' },
        maxPrice: { $max: '$price' },
        avgPrice: { $avg: '$price' }
    })
    .end();
```

### Multiple Groups

```javascript

## complex-queries

# Complex Queries with CloudBase

This document provides detailed guidance on constructing complex queries using CloudBase document database.

## Query Operators

Access operators through `db.command`:

```javascript
const _ = db.command;
```

### Comparison Operators

| Operator | Usage | Description |
|----------|-------|-------------|
| `gt` | `_.gt(value)` | Greater than |
| `gte` | `_.gte(value)` | Greater than or equal |
| `lt` | `_.lt(value)` | Less than |
| `lte` | `_.lte(value)` | Less than or equal |
| `eq` | `_.eq(value)` | Equal to |
| `neq` | `_.neq(value)` | Not equal to |

### Array Operators

| Operator | Usage | Description |
|----------|-------|-------------|
| `in` | `_.in([values])` | Value exists in array |
| `nin` | `_.nin([values])` | Value not in array |

## Building Complex Queries

### Multiple Conditions

Combine multiple conditions in the `where()` object:

```javascript
const result = await db.collection('todos')
    .where({
        // Age greater than 18
        age: _.gt(18),
        // Tags include 'tech' or 'study'
        tags: _.in(['tech', 'study']),
        // Created within last week
        createdAt: _.gte(new Date(Date.now() - 7 * 24 * 60 * 60 * 1000))
    })
    .get();
```

### Sorting Results

Use `orderBy()` to sort results:

```javascript
// Single field sorting
db.collection('posts')
    .orderBy('createdAt', 'desc')
    .get()

// Multiple field sorting (chain multiple orderBy calls)
db.collection('products')
    .orderBy('category', 'asc')
    .orderBy('price', 'desc')
    .get()
```

**Sort directions:**
- `'asc'` - Ascending order
- `'desc'` - Descending order

### Limiting Results

Control the number of results returned:

```javascript
// Limit to 10 results
db.collection('posts')
    .limit(10)
    .get()
```

**Limits:**
- Default: 100 records
- Maximum: 1000 records per query

### Field Selection

Optimize queries by selecting only needed fields:

```javascript
const result = await db.collection('users')
    .field({
        title: true,        // Include title
        completed: true,    // Include completed
        createdAt: true,    // Include createdAt
        _id: false          // Exclude _id
    })
    .get();
```

**Field selection rules:**
- `true` - Include field in results
- `false` - Exclude field from results
- If not specified, all fields are included by default

## Complete Complex Query Example

Here's a comprehensive example combining all query features:

```javascript
const _ = db.command;

const result = await db.collection('todos')
    .where({
        // Status must be 'active' or 'pending'
        status: _.in(['active', 'pending']),
        // Priority is high
        priority: 'high',
        // Age greater than 18
        age: _.gt(18),

## crud-operations

# CRUD Operations with CloudBase

This document covers Create, Update, and Delete operations for CloudBase document database.

## Create Operations

### Adding a Single Document

Add a new document to a collection:

```javascript
// Add a single document
// Note: _openid is automatically added by SDK, do not include it in the data
const result = await db.collection('todos').add({
    title: 'Learn CloudBase',
    description: 'Study the database API',
    completed: false,
    priority: 'high',
    createdAt: new Date()
    // _openid is automatically populated from authenticated user session
});

console.log('Added document with ID:', result._id);
```

**Return Value:**
```javascript
{
    _id: "generated-doc-id",  // Auto-generated document ID
    // ... other metadata
}
```

### Adding with Custom ID

Specify your own document ID:

```javascript
// Add with custom ID
const result = await db.collection('todos')
    .doc('custom-todo-id')
    .set({
        title: 'Custom ID Todo',
        completed: false,
        createdAt: new Date()
    });
```

**Note:** Use `.set()` with `.doc()` to specify a custom ID. If document exists, it will be overwritten.

### Adding Multiple Documents

Add multiple documents at once:

```javascript
// Batch add documents
const todos = [
    { title: 'Task 1', completed: false },
    { title: 'Task 2', completed: false },
    { title: 'Task 3', completed: true }
];

// Add one by one
for (const todo of todos) {
    await db.collection('todos').add(todo);
}

// Or use Promise.all for parallel insertion
const results = await Promise.all(
    todos.map(todo => db.collection('todos').add(todo))
);

console.log('Added', results.length, 'documents');
```

### Data Validation

Validate data before insertion:

```javascript
function validateTodo(todo) {
    if (!todo.title || todo.title.trim() === '') {
        throw new Error('Title is required');
    }
    if (typeof todo.completed !== 'boolean') {
        throw new Error('Completed must be a boolean');
    }
    return true;
}

async function addTodo(todoData) {
    try {
        validateTodo(todoData);
        
        const result = await db.collection('todos').add({
            ...todoData,
            createdAt: new Date(),
            updatedAt: new Date()
        });
        
        return result;
    } catch (error) {
        console.error('Failed to add todo:', error);
        throw error;
    }
}
```

## Update Operations

### Update by Document ID

Update a specific document by its ID:

```javascript
// Update by ID
// Note: Do not include _openid in update data - it cannot be modified
const result = await db.collection('todos')
    .doc('todo-id-123')
    .update({

## geolocation

# Geolocation Queries with CloudBase

This document explains how to work with geographic data and perform location-based queries in CloudBase.

## Prerequisites

**⚠️ CRITICAL**: Before performing any geolocation queries, you **MUST** create a geolocation index on the field you're querying. Queries will fail without proper indexing.

## Geographic Data Types

CloudBase supports several geographic data types through `db.Geo`:

```javascript
const db = app.database();
```

### Point (Single Location)

Represents a single geographic coordinate:

```javascript
// Create a Point: longitude, latitude
const point = new db.Geo.Point(116.404, 39.915);  // Tiananmen Square coordinates
```

**Note:** Coordinates are in `[longitude, latitude]` format (NOT latitude, longitude).

### LineString (Path/Route)

Represents a path or route:

```javascript
// Create a LineString (array of Points)
const line = new db.Geo.LineString([
    new db.Geo.Point(116.404, 39.915),  // Start
    new db.Geo.Point(116.405, 39.916),  // Waypoint
    new db.Geo.Point(116.406, 39.917)   // End
]);
```

### Polygon (Area)

Represents an enclosed area:

```javascript
// Create a Polygon (array of LineStrings, first is outer boundary)
const polygon = new db.Geo.Polygon([
    new db.Geo.LineString([
        new db.Geo.Point(116.404, 39.915),
        new db.Geo.Point(116.404, 39.916),
        new db.Geo.Point(116.405, 39.916),
        new db.Geo.Point(116.405, 39.915),
        new db.Geo.Point(116.404, 39.915)   // Must close the polygon
    ])
]);
```

**Note:** The first and last points must be identical to close the polygon.

## Storing Geographic Data

Store location data in documents:

```javascript
// Add a user with location
await db.collection('users').add({
    name: 'John',
    location: new db.Geo.Point(116.404, 39.915),
    address: 'Beijing, China'
});

// Add a delivery route
await db.collection('routes').add({
    name: 'Route A',
    path: new db.Geo.LineString([
        new db.Geo.Point(116.404, 39.915),
        new db.Geo.Point(116.405, 39.916),
        new db.Geo.Point(116.406, 39.917)
    ])
});

// Add a service area
await db.collection('serviceAreas').add({
    name: 'Downtown',
    area: new db.Geo.Polygon([
        new db.Geo.LineString([
            new db.Geo.Point(116.404, 39.915),
            new db.Geo.Point(116.404, 39.916),
            new db.Geo.Point(116.405, 39.916),
            new db.Geo.Point(116.405, 39.915),
            new db.Geo.Point(116.404, 39.915)
        ])
    ])
});
```

## Geolocation Query Operators

CloudBase provides three main geolocation query operators:

### 1. geoNear (Proximity Search)

Find documents near a specific location, ordered by distance:

```javascript
const _ = db.command;

// Find users within 1000 meters of a location
const result = await db.collection('users').where({
    location: _.geoNear({
        geometry: new db.Geo.Point(116.404, 39.915),  // Center point
        maxDistance: 1000,   // Maximum distance in meters
        minDistance: 0       // Minimum distance in meters
    })
}).get();

console.log('Nearby users:', result.data);
```

**Parameters:**

## pagination

# Pagination with CloudBase

This document explains how to implement pagination for large datasets in CloudBase document database.

## Basic Pagination Concepts

Pagination allows you to retrieve large datasets in smaller, manageable chunks (pages).

**Key Parameters:**
- `pageSize` - Number of records per page
- `pageNum` - Current page number (1-based)
- `skip()` - Number of records to skip
- `limit()` - Maximum records to return

## Simple Pagination Implementation

### Basic Page-based Query

```javascript
const pageSize = 10;  // Records per page
const pageNum = 1;    // Current page (1-based)

const result = await db.collection('todos')
    .orderBy('createdAt', 'desc')
    .skip((pageNum - 1) * pageSize)
    .limit(pageSize)
    .get();

console.log('Page', pageNum, 'data:', result.data);
```

### Calculation Formula

```javascript
// For page N:
const skip = (pageNum - 1) * pageSize;
const limit = pageSize;
```

## Complete Pagination Function

Here's a reusable pagination function:

```javascript
/**
 * Paginate through a collection
 * @param {string} collectionName - Name of the collection
 * @param {number} page - Page number (1-based)
 * @param {number} pageSize - Records per page
 * @param {object} whereConditions - Query conditions (optional)
 * @param {string} sortField - Field to sort by (optional)
 * @param {string} sortDirection - 'asc' or 'desc' (optional)
 */
async function paginateCollection(
    collectionName, 
    page = 1, 
    pageSize = 10,
    whereConditions = {},
    sortField = 'createdAt',
    sortDirection = 'desc'
) {
    const skip = (page - 1) * pageSize;
    
    let query = db.collection(collectionName);
    
    // Apply conditions if provided
    if (Object.keys(whereConditions).length > 0) {
        query = query.where(whereConditions);
    }
    
    // Apply sorting
    if (sortField) {
        query = query.orderBy(sortField, sortDirection);
    }
    
    // Apply pagination
    const result = await query
        .skip(skip)
        .limit(pageSize)
        .get();
    
    return {
        data: result.data,
        page: page,
        pageSize: pageSize,
        hasMore: result.data.length === pageSize
    };
}

// Usage
const pageData = await paginateCollection('todos', 2, 20, { status: 'active' });
console.log('Page 2 data:', pageData);
```

## Getting Total Count

To show "Page X of Y", you need the total count:

```javascript
async function paginateWithCount(collectionName, page, pageSize, whereConditions = {}) {
    const skip = (page - 1) * pageSize;
    
    // Get paginated data
    const dataQuery = db.collection(collectionName);
    const countQuery = db.collection(collectionName);
    
    if (Object.keys(whereConditions).length > 0) {
        dataQuery.where(whereConditions);
        countQuery.where(whereConditions);
    }
    
    // Execute both queries
    const [dataResult, countResult] = await Promise.all([
        dataQuery
            .orderBy('createdAt', 'desc')
            .skip(skip)
            .limit(pageSize)
            .get(),
        countQuery.count()
    ]);

## realtime

# Realtime Database with CloudBase

CloudBase document database supports **real-time push** functionality that allows applications to listen to all update events for documents in a specified collection that match query conditions. When monitored documents undergo any changes (such as addition, modification, deletion), the client receives notifications in real-time, enabling real-time data synchronization and updates.

## Core Features

### Real-time Data Change Monitoring
- Listen to all change events for documents in a collection that match query conditions
- Support for all types of changes: addition, modification, deletion
- Automatically push change snapshots to clients

### Use Cases
- Chat applications
- Real-time collaborative editing
- Live interactive features
- Real-time dashboards
- Multiplayer game state synchronization

## Basic Usage

### 1. Establish Monitoring

Use the `.watch()` method on the collection reference to establish monitoring:

```javascript
// db is the database instance from cloudbase js client sdk 
const watcher = db.collection("todos") // Specify collection
  .where({ // Specify query conditions
    status: 'active',
    priority: _.in(['high', 'medium'])
  })
  .watch({
    onChange: function(snapshot) { // Data change callback
      console.log("Received data snapshot", snapshot);
      // Update your UI or process data here
      handleDataChange(snapshot);
    },
    onError: function(err) { // Error handling callback
      console.error("Monitoring closed due to error", err);
      // Handle errors, such as attempting to re-establish connection
      handleWatchError(err);
    }
  });
```

### 2. Close Monitoring

When you no longer need to monitor data changes, call the `watcher.close()` method:

```javascript
// Close monitoring when page or component unmounts
watcher.close();
```

## API Details

### watch(options)

Create a real-time data listener that returns a `watcher` object.

**Parameters:**
- `options.onChange` (Function): Callback function when data changes
- `options.onError` (Function): Callback function when monitoring encounters an error

**onChange callback parameter snapshot:**
```javascript
{
  docChanges: [
    {
      id: 'document-id',
      dataType: 'init' | 'update' | 'delete' | 'add',
      queueType: 'init' | 'update' | 'delete' | 'enqueue' | 'dequeue',
      doc: { // Document content after change
        // Document fields
      }
    },
    // More changes...
  ],
  docs: [ // All documents in the query result set
    // Document content...
  ]
}
```

**Change types in onChange callback:**
- `init`: Initialization, sends all data when first establishing connection
- `update`: Document content update
- `add`: New document added
- `delete`: Document deleted

**Watcher object methods:**
- `watcher.close()`: Close monitoring and release resources

## Best Practices

### 1. Specific Query Conditions

Set as specific query conditions as possible in the `.where()` method to monitor only the data changes you truly need:

```javascript
// Recommended: Specific query conditions
db.collection("messages")
  .where({
    chatRoomId: currentChatRoomId,
    isDeleted: false
  })
  .watch({...});

// Not recommended: Monitoring entire collection
db.collection("messages").watch({...});
```

### 2. Close Monitoring in a Timely Manner

Be sure to close monitoring when pages or components unmount to prevent memory leaks:

**React Component Example:**
```javascript
import { useEffect } from 'react';


## rule

---
name: cloudbase-document-database-web-sdk
description: Use CloudBase document database Web SDK only for confirmed NoSQL collection work. Query, create, update, and delete document data; if the task mentions PostgreSQL / CloudBase PG / app.rdb(), route to postgresql-development instead.
version: 2.24.1
alwaysApply: false
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/no-sql-web-sdk/SKILL.md`

Keep local `references/...` paths for files that ship with the current skill directory. When this file points to a sibling skill such as `auth-tool` or `web-development`, use the standalone fallback URL shown next to that reference.

# CloudBase Document Database Web SDK

## Activation Contract

### Use this first when

- A browser or Web app must read or write CloudBase document database data through `@cloudbase/js-sdk`.
- The request mentions `app.database()`, `db.collection()`, `.where()`, `.watch()`, pagination, aggregation, or geolocation queries in a Web frontend.

### Read before writing code if

- The task is clearly browser-side, but you still need to decide between Web SDK, Mini Program SDK, or backend access.
- The request touches login state, collection permissions, or realtime updates.

### Then also read

- Web login and caller identity -> `../auth-web/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-web/SKILL.md`)
- General Web app structure -> `../web-development/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/web-development/SKILL.md`)
- Mini Program database code -> `../no-sql-wx-mp-sdk/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/no-sql-wx-mp-sdk/SKILL.md`)

### Do NOT use for

- Mini Program code using `wx.cloud.database()`.
- Server-side or cloud-function database access.
- SQL / MySQL database operations.
- Pure resource-permission administration with no browser SDK code.
- **NEW business tables that the task explicitly asks to put in CloudBase PostgreSQL (CloudBase PG).** Before applying this skill, call `envQuery(action="info", envId=...)` and read `EnvInfo.RuntimeBackends`. If `postgresql === true` AND the task asks for a new business table to live in PG, switch to the `postgresql-development` skill for that table: it goes through `app.rdb()`, uses PG row-level security (`CREATE POLICY`), and uploads via `app.storage.from('<bucket>').upload('<key>', file)` against an explicitly-created pgstore bucket.
  - Existing NoSQL collections in the same env keep using THIS skill — PG and NoSQL coexist in CloudBase PG environments. The rule is "follow the task / existing surface", not "PG env forbids NoSQL".

### SDK Code vs MCP Tools

**When to write SDK code (use this skill):**
- The task explicitly asks to "modify code" or "use SDK"
- The task asks to implement app/frontend logic
- The task mentions specific SDK methods like `db.collection().add()`, `.get()`, `.update()`
- The context shows an existing Web project with SDK initialization (e.g., `index.js` already has `cloudbase.init()`)

**When to use MCP tools instead:**
- The task asks to manage CloudBase resources (create collection, set permissions, etc.)
- The task involves admin/management operations without writing app code
- The task mentions tools like `writeNoSqlDatabaseContent`, `managePermissions`, etc.

**Key distinction:** If the user says "使用 JS SDK 执行 XX 操作" (use JS SDK to perform XX operation) or "修改代码" (modify code), write SDK code in the project files. Do not use MCP database write tools for app-level data operations.

### Common mistakes / gotchas

- Querying before the user is signed in when the collection rules require identity.
- Using `wx.cloud.database()` or Node SDK patterns in browser code.
- Initializing CloudBase lazily with dynamic imports instead of a shared synchronous app instance.
- Treating security rules as result filters rather than request validators.
- **Expecting a `CUSTOM` security rule to take effect immediately after you call `managePermissions(updateResourcePermission)`.** The backend caches rule evaluators for **2–5 minutes**; first writes after a rule change may silently fail or be rejected with `DATABASE_PERMISSION_DENIED` even when the expression is correct. Either (a) wait a few minutes and retry the same write before assuming the rule is wrong, or (b) verify the rule is live by reading `result.code` / `result.message` on every write and by doing a `get()` round-trip on the just-written `_id`; do not treat a resolved promise as success. See `security-rules.md` → "Propagation And Verification" for the full pattern.
- Misreading the return shape of `db.collection(...).add(...)`. In the CloudBase Web SDK, the created document ID is exposed at top-level `result._id`, not `result.id`, `result.data.id`, or `result.insertedId`.
- For CMS-style collections that need **app-level admin users** to edit/delete all records while editors can only edit/delete their own records, do not oversimplify the rule to `READONLY`. A validated pattern is a `CUSTOM` rule that reads role from `user_roles` by `auth.uid` and combines it with `doc.authorId == auth.uid`, while frontend writes can stay on `.doc(id).update()` / `.doc(id).remove()`.
- Forgetting pagination or indexes for larger collections.

### Minimal checklist

- Confirm this is browser-side document database work.
- Initialize CloudBase once and reuse the same `app` / `db` instance.
- Verify auth expectations before CRUD.
- Read the right companion reference file for the specific operation.

## Overview

This skill covers **browser-side document database usage** via `@cloudbase/js-sdk`.

Use it for:

- CRUD in a Web app
- complex queries and pagination
- aggregation
- realtime listeners with `watch()`
- geolocation queries

## Canonical initialization

```javascript
import cloudbase from "@cloudbase/js-sdk";

const app = cloudbase.init({
  env: "your-env-id"
});

const db = app.database();
const _ = db.command;
```

Important rules:

- Sign in before querying if the collection rules require identity.
- Keep a single shared app/database instance.
- Do not hide initialization inside ad-hoc async loaders unless the framework truly requires it.

## Quick routing

- CRUD -> `./crud-operations.md`
- Complex queries -> `./complex-queries.md`
- Pagination -> `./pagination.md`
- Aggregation -> `./aggregation.md`
- Realtime listeners -> `./realtime.md`
- Geolocation -> `./geolocation.md`
- Security rules -> `./security-rules.md`

## Working rules for a coding agent

## security-rules

# CloudBase NoSQL Database Security Rules

This document covers how to configure security rules for CloudBase NoSQL database collections to control read/write permissions.

## Overview

**Important:** To control database permissions, you **MUST** use `managePermissions(action="updateResourcePermission")` to configure security rules. Security rule changes take effect after a few minutes due to caching.

**General Rule:** In most cases, use **simple permissions** (READONLY, PRIVATE, ADMINWRITE, ADMINONLY). Only use CUSTOM rules when you need fine-grained control.

**Scope note:** The detailed semantics in this document apply only to CloudBase **NoSQL database collections** with `resourceType: "noSqlDatabase"`. Examples such as `doc._openid`, `auth.openid`, query-condition subset validation, and `create` / `update` / `delete` JSON rule templates are **not** generic rules for `function`, `storage`, or `sqlDatabase` resources.

**Official references:**
- General security rules overview: `https://cloud.tencent.com/document/product/876/41802`
- NoSQL database security rules: `https://docs.cloudbase.net/database/security-rules`
- Cloud function security rules: `https://docs.cloudbase.net/cloud-function/security-rules`
- Storage security rules: `https://docs.cloudbase.net/storage/security-rules`

### Critical Understanding: Query Condition Requirements

**Security rules are validation-based, NOT filter-based.**

For query or update operations, the **input query conditions must be a subset of the security rules**. The system does **not** actually fetch data from the database. Instead, it validates whether the input query conditions form a subset of the security rules. If the query conditions are not a subset of the rules, it indicates an attempt to access data without permission, and the operation will be **directly rejected**.

**Example:**
- If you define a read/write rule: `auth.openid == doc._openid`
- This means the query condition's `_openid` must equal the current user's `openid` (provided by the system-assigned, non-tamperable `auth.openid`)
- If the query condition doesn't include this constraint, it indicates an attempt to access records where `_openid` is not equal to the user's own, which will be rejected by the backend

**Key Points:**
- Security rules **validate** queries, they don't **filter** results
- The system performs **rule matching** before any database access
- Query conditions must match or be more restrictive than the security rule
- Missing required conditions in queries will result in permission denied errors
- For **create** operations, the system validates the **written data** against the security rules, not query conditions

## Data Permission Management System

CloudBase provides a multi-layered data permission management mechanism that ensures data security while meeting different business scenario permission control requirements.

### Permission Management Hierarchy

CloudBase data permission management includes two levels:

| Permission Type | Control Granularity | Applicable Scenarios | Configuration Complexity |
|----------------|---------------------|----------------------|--------------------------|
| **Basic Permission Control** | Collection level | Simple permission needs | Low |
| **Security Rules** | Document level | Complex business logic | High |

### Basic Permission Control

**Configuration Method:**
Configure permissions for each collection in the [CloudBase Platform](https://tcb.cloud.tencent.com/dev) collection management page.

**Permission Options:**

| Permission Type | Applicable Scenarios | Usage Recommendation |
|----------------|----------------------|----------------------|
| **Read all data, modify own data** | Public content, such as articles, products | Suitable for content display applications |
| **Read and modify own data** | Private data, such as user profiles | Suitable for personal information management |
| **Read all data, cannot modify** | Configuration data, such as system settings | Suitable for read-only configuration and reference data |
| **No permission** | Sensitive data, such as financial information | Suitable for sensitive data requiring server-side processing |

### Security Rules (CUSTOM)

**Function Overview:**

Security rules provide more flexible, extensible, and fine-grained permission control capabilities, supporting dynamic permission judgment based on document content.

**Core Features:**
- **Document-level control**: Can decide access permissions based on specific document content
- **Expression-driven**: Uses programming-like expressions to define permission logic
- **Dynamic permissions**: Supports dynamic permission judgment based on user identity, time, and data content
- **Client-only restriction**: Only restricts client user access, does not affect server-side (cloud function) operations

**Configuration Entry:**
Configure security rules in the [CloudBase Platform/Database](https://tcb.cloud.tencent.com/dev#/db/doc/model) collection management page.

## Permission Categories

CloudBase provides two types of permissions:

### 1. Simple Permissions (Recommended for Most Cases)

These are pre-configured permission templates that cover most common scenarios:

- **READONLY**: All users can read, only creator and admin can write
- **PRIVATE**: Only creator and admin can read/write
- **ADMINWRITE**: All users can read, only admin can write
- **ADMINONLY**: Only admin can read/write

### 2. Custom Security Rules (CUSTOM)

Use CUSTOM when you need fine-grained control based on document data, user identity, or complex conditions.

## Configuring Security Rules

### Using MCP Tool `managePermissions`

**Important:** When developing applications that need permission control, you **MUST** call `managePermissions(action="updateResourcePermission")` to configure database security rules. Do not assume permissions are already configured.

Compatibility note:
- Canonical plugin name: `permissions`
- Legacy plugin aliases `security-rule`, `security-rules`, `secret-rule`, `secret-rules`, and `access-control` still resolve to the `permissions` plugin
- Legacy tools `readSecurityRule` and `writeSecurityRule` are removed; use `queryPermissions` and `managePermissions`

**Scope reminder:** The examples below are for `resourceType: "noSqlDatabase"` only. Do not reuse NoSQL-only expressions such as `doc._openid`, `auth.openid`, query-subset validation, or `create` / `update` / `delete` rule templates as generic guidance for `function`, `storage`, or `sqlDatabase` permissions.

**Basic Usage:**

```javascript
// Example: Set simple permission (PRIVATE)
await managePermissions({
  action: "updateResourcePermission",
  resourceType: "noSqlDatabase",
  resourceId: "collectionName",  // Collection name
  permission: "PRIVATE",
  // securityRule parameter not needed for simple permissions
});
```

## aggregation

# Aggregation Queries with CloudBase

This document explains how to perform aggregation operations for data analysis and statistics in CloudBase document database.

## Overview

Aggregation queries allow you to:
- Group data by specific fields
- Calculate statistics (count, sum, average, etc.)
- Transform and reshape data
- Perform complex data analysis

## Basic Aggregation Syntax

```javascript
const result = await db.collection('collectionName')
    .aggregate()
    .group({ /* grouping configuration */ })
    .end();

console.log('Results:', result.list);
```

**Note:** Aggregation queries use `.end()` instead of `.get()`

## Grouping Data

### Simple Grouping with Count

Count documents by a specific field:

```javascript
// Count todos by priority
const result = await db.collection('todos')
    .aggregate()
    .group({
        _id: '$priority',  // Group by priority field
        count: {
            $sum: 1        // Count documents in each group
        }
    })
    .end();

console.log('By priority:', result.list);
// Output: [
//   { _id: 'high', count: 15 },
//   { _id: 'medium', count: 23 },
//   { _id: 'low', count: 8 }
// ]
```

### Field Reference Syntax

Use `$` prefix to reference document fields:
- `$priority` - References the `priority` field
- `$status` - References the `status` field
- `$user.name` - References nested fields

## Aggregation Operators

### Accumulator Operators

| Operator | Description | Usage |
|----------|-------------|-------|
| `$sum` | Sum values | `{ total: { $sum: '$amount' } }` |
| `$avg` | Average values | `{ avgScore: { $avg: '$score' } }` |
| `$min` | Minimum value | `{ minPrice: { $min: '$price' } }` |
| `$max` | Maximum value | `{ maxPrice: { $max: '$price' } }` |
| `$first` | First value | `{ first: { $first: '$date' } }` |
| `$last` | Last value | `{ last: { $last: '$date' } }` |
| `$push` | Array of all values | `{ items: { $push: '$name' } }` |

## Common Aggregation Patterns

### Count by Category

```javascript
// Count users by role
const result = await db.collection('users')
    .aggregate()
    .group({
        _id: '$role',
        count: { $sum: 1 }
    })
    .end();
```

### Sum and Average

```javascript
// Calculate total and average order amount by customer
const result = await db.collection('orders')
    .aggregate()
    .group({
        _id: '$customerId',
        totalAmount: { $sum: '$amount' },
        averageAmount: { $avg: '$amount' },
        orderCount: { $sum: 1 }
    })
    .end();
```

### Find Min and Max

```javascript
// Find price range by product category
const result = await db.collection('products')
    .aggregate()
    .group({
        _id: '$category',
        minPrice: { $min: '$price' },
        maxPrice: { $max: '$price' },
        avgPrice: { $avg: '$price' }
    })
    .end();
```

### Multiple Groups

```javascript

## complex-queries

# Complex Queries with CloudBase

This document provides detailed guidance on constructing complex queries using CloudBase document database.

## Query Operators

Access operators through `db.command`:

```javascript
const _ = db.command;
```

### Comparison Operators

| Operator | Usage | Description |
|----------|-------|-------------|
| `gt` | `_.gt(value)` | Greater than |
| `gte` | `_.gte(value)` | Greater than or equal |
| `lt` | `_.lt(value)` | Less than |
| `lte` | `_.lte(value)` | Less than or equal |
| `eq` | `_.eq(value)` | Equal to |
| `neq` | `_.neq(value)` | Not equal to |

### Array Operators

| Operator | Usage | Description |
|----------|-------|-------------|
| `in` | `_.in([values])` | Value exists in array |
| `nin` | `_.nin([values])` | Value not in array |

## Building Complex Queries

### Multiple Conditions

Combine multiple conditions in the `where()` object:

```javascript
const result = await db.collection('todos')
    .where({
        // Age greater than 18
        age: _.gt(18),
        // Tags include 'tech' or 'study'
        tags: _.in(['tech', 'study']),
        // Created within last week
        createdAt: _.gte(new Date(Date.now() - 7 * 24 * 60 * 60 * 1000))
    })
    .get();
```

### Sorting Results

Use `orderBy()` to sort results:

```javascript
// Single field sorting
db.collection('posts')
    .orderBy('createdAt', 'desc')
    .get()

// Multiple field sorting (chain multiple orderBy calls)
db.collection('products')
    .orderBy('category', 'asc')
    .orderBy('price', 'desc')
    .get()
```

**Sort directions:**
- `'asc'` - Ascending order
- `'desc'` - Descending order

### Limiting Results

Control the number of results returned:

```javascript
// Limit to 10 results
db.collection('posts')
    .limit(10)
    .get()
```

**Limits:**
- Default: 100 records
- Maximum: 1000 records per query

### Field Selection

Optimize queries by selecting only needed fields:

```javascript
const result = await db.collection('users')
    .field({
        title: true,        // Include title
        completed: true,    // Include completed
        createdAt: true,    // Include createdAt
        _id: false          // Exclude _id
    })
    .get();
```

**Field selection rules:**
- `true` - Include field in results
- `false` - Exclude field from results
- If not specified, all fields are included by default

## Complete Complex Query Example

Here's a comprehensive example combining all query features:

```javascript
const _ = db.command;

const result = await db.collection('todos')
    .where({
        // Status must be 'active' or 'pending'
        status: _.in(['active', 'pending']),
        // Priority is high
        priority: 'high',
        // Age greater than 18
        age: _.gt(18),

## crud-operations

# CRUD Operations with CloudBase

This document covers Create, Update, and Delete operations for CloudBase document database.

## Create Operations

### Adding a Single Document

Add a new document to a collection:

```javascript
// Add a single document
const result = await db.collection('todos').add({
    title: 'Learn CloudBase',
    description: 'Study the database API',
    completed: false,
    priority: 'high',
    createdAt: new Date()
});

console.log('Added document with ID:', result._id);
```

**Return Value:**
```javascript
{
    _id: "generated-doc-id",  // Auto-generated document ID
    // ... other metadata
}
```

### Adding with Custom ID

Specify your own document ID:

```javascript
// Add with custom ID
const result = await db.collection('todos')
    .doc('custom-todo-id')
    .set({
        title: 'Custom ID Todo',
        completed: false,
        createdAt: new Date()
    });
```

**Note:** Use `.set()` with `.doc()` to specify a custom ID. If document exists, it will be overwritten.

### Adding Multiple Documents

Add multiple documents at once:

```javascript
// Batch add documents
const todos = [
    { title: 'Task 1', completed: false },
    { title: 'Task 2', completed: false },
    { title: 'Task 3', completed: true }
];

// Add one by one
for (const todo of todos) {
    await db.collection('todos').add(todo);
}

// Or use Promise.all for parallel insertion
const results = await Promise.all(
    todos.map(todo => db.collection('todos').add(todo))
);

console.log('Added', results.length, 'documents');
```

### Data Validation

Validate data before insertion:

```javascript
function validateTodo(todo) {
    if (!todo.title || todo.title.trim() === '') {
        throw new Error('Title is required');
    }
    if (typeof todo.completed !== 'boolean') {
        throw new Error('Completed must be a boolean');
    }
    return true;
}

async function addTodo(todoData) {
    try {
        validateTodo(todoData);
        
        const result = await db.collection('todos').add({
            ...todoData,
            createdAt: new Date(),
            updatedAt: new Date()
        });
        
        return result;
    } catch (error) {
        console.error('Failed to add todo:', error);
        throw error;
    }
}
```

## Update Operations

### Update by Document ID

Update a specific document by its ID:

```javascript
// Update by ID
const result = await db.collection('todos')
    .doc('todo-id-123')
    .update({
        completed: true,
        updatedAt: new Date()
    });

## geolocation

# Geolocation Queries with CloudBase

This document explains how to work with geographic data and perform location-based queries in CloudBase.

## Prerequisites

**⚠️ CRITICAL**: Before performing any geolocation queries, you **MUST** create a geolocation index on the field you're querying. Queries will fail without proper indexing.

## Geographic Data Types

CloudBase supports several geographic data types through `db.Geo`:

```javascript
const db = app.database();
```

### Point (Single Location)

Represents a single geographic coordinate:

```javascript
// Create a Point: longitude, latitude
const point = new db.Geo.Point(116.404, 39.915);  // Tiananmen Square coordinates
```

**Note:** Coordinates are in `[longitude, latitude]` format (NOT latitude, longitude).

### LineString (Path/Route)

Represents a path or route:

```javascript
// Create a LineString (array of Points)
const line = new db.Geo.LineString([
    new db.Geo.Point(116.404, 39.915),  // Start
    new db.Geo.Point(116.405, 39.916),  // Waypoint
    new db.Geo.Point(116.406, 39.917)   // End
]);
```

### Polygon (Area)

Represents an enclosed area:

```javascript
// Create a Polygon (array of LineStrings, first is outer boundary)
const polygon = new db.Geo.Polygon([
    new db.Geo.LineString([
        new db.Geo.Point(116.404, 39.915),
        new db.Geo.Point(116.404, 39.916),
        new db.Geo.Point(116.405, 39.916),
        new db.Geo.Point(116.405, 39.915),
        new db.Geo.Point(116.404, 39.915)   // Must close the polygon
    ])
]);
```

**Note:** The first and last points must be identical to close the polygon.

## Storing Geographic Data

Store location data in documents:

```javascript
// Add a user with location
await db.collection('users').add({
    name: 'John',
    location: new db.Geo.Point(116.404, 39.915),
    address: 'Beijing, China'
});

// Add a delivery route
await db.collection('routes').add({
    name: 'Route A',
    path: new db.Geo.LineString([
        new db.Geo.Point(116.404, 39.915),
        new db.Geo.Point(116.405, 39.916),
        new db.Geo.Point(116.406, 39.917)
    ])
});

// Add a service area
await db.collection('serviceAreas').add({
    name: 'Downtown',
    area: new db.Geo.Polygon([
        new db.Geo.LineString([
            new db.Geo.Point(116.404, 39.915),
            new db.Geo.Point(116.404, 39.916),
            new db.Geo.Point(116.405, 39.916),
            new db.Geo.Point(116.405, 39.915),
            new db.Geo.Point(116.404, 39.915)
        ])
    ])
});
```

## Geolocation Query Operators

CloudBase provides three main geolocation query operators:

### 1. geoNear (Proximity Search)

Find documents near a specific location, ordered by distance:

```javascript
const _ = db.command;

// Find users within 1000 meters of a location
const result = await db.collection('users').where({
    location: _.geoNear({
        geometry: new db.Geo.Point(116.404, 39.915),  // Center point
        maxDistance: 1000,   // Maximum distance in meters
        minDistance: 0       // Minimum distance in meters
    })
}).get();

console.log('Nearby users:', result.data);
```

**Parameters:**

## pagination

# Pagination with CloudBase

This document explains how to implement pagination for large datasets in CloudBase document database.

## Basic Pagination Concepts

Pagination allows you to retrieve large datasets in smaller, manageable chunks (pages).

**Key Parameters:**
- `pageSize` - Number of records per page
- `pageNum` - Current page number (1-based)
- `skip()` - Number of records to skip
- `limit()` - Maximum records to return

## Simple Pagination Implementation

### Basic Page-based Query

```javascript
const pageSize = 10;  // Records per page
const pageNum = 1;    // Current page (1-based)

const result = await db.collection('todos')
    .orderBy('createdAt', 'desc')
    .skip((pageNum - 1) * pageSize)
    .limit(pageSize)
    .get();

console.log('Page', pageNum, 'data:', result.data);
```

### Calculation Formula

```javascript
// For page N:
const skip = (pageNum - 1) * pageSize;
const limit = pageSize;
```

## Complete Pagination Function

Here's a reusable pagination function:

```javascript
/**
 * Paginate through a collection
 * @param {string} collectionName - Name of the collection
 * @param {number} page - Page number (1-based)
 * @param {number} pageSize - Records per page
 * @param {object} whereConditions - Query conditions (optional)
 * @param {string} sortField - Field to sort by (optional)
 * @param {string} sortDirection - 'asc' or 'desc' (optional)
 */
async function paginateCollection(
    collectionName, 
    page = 1, 
    pageSize = 10,
    whereConditions = {},
    sortField = 'createdAt',
    sortDirection = 'desc'
) {
    const skip = (page - 1) * pageSize;
    
    let query = db.collection(collectionName);
    
    // Apply conditions if provided
    if (Object.keys(whereConditions).length > 0) {
        query = query.where(whereConditions);
    }
    
    // Apply sorting
    if (sortField) {
        query = query.orderBy(sortField, sortDirection);
    }
    
    // Apply pagination
    const result = await query
        .skip(skip)
        .limit(pageSize)
        .get();
    
    return {
        data: result.data,
        page: page,
        pageSize: pageSize,
        hasMore: result.data.length === pageSize
    };
}

// Usage
const pageData = await paginateCollection('todos', 2, 20, { status: 'active' });
console.log('Page 2 data:', pageData);
```

## Getting Total Count

To show "Page X of Y", you need the total count:

```javascript
async function paginateWithCount(collectionName, page, pageSize, whereConditions = {}) {
    const skip = (page - 1) * pageSize;
    
    // Get paginated data
    const dataQuery = db.collection(collectionName);
    const countQuery = db.collection(collectionName);
    
    if (Object.keys(whereConditions).length > 0) {
        dataQuery.where(whereConditions);
        countQuery.where(whereConditions);
    }
    
    // Execute both queries
    const [dataResult, countResult] = await Promise.all([
        dataQuery
            .orderBy('createdAt', 'desc')
            .skip(skip)
            .limit(pageSize)
            .get(),
        countQuery.count()
    ]);

## rule

---
name: cloudbase-document-database-in-wechat-miniprogram
description: Use CloudBase document database WeChat MiniProgram SDK to query, create, update, and delete data. Supports complex queries, pagination, aggregation, and geolocation queries.
version: 2.20.1
alwaysApply: false
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/no-sql-wx-mp-sdk/SKILL.md`

Keep local `references/...` paths for files that ship with the current skill directory. When this file points to a sibling skill such as `auth-tool` or `web-development`, use the standalone fallback URL shown next to that reference.

# CloudBase Document Database WeChat Mini Program SDK

## Activation Contract

### Use this first when

- A WeChat Mini Program must access CloudBase document database through `wx.cloud.database()`.
- The request mentions Mini Program collection CRUD, pagination, aggregation, or geolocation queries.

### Read before writing code if

- The task is Mini Program database work but you still need to separate it from Web SDK, cloud functions, or SQL tasks.
- The request depends on built-in user identity, `_openid`, or Mini Program-side permissions.

### Then also read

- Mini Program project rules and CloudBase integration -> `../miniprogram-development/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/miniprogram-development/SKILL.md`)
- Mini Program auth and identity flow -> `../auth-wechat/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-wechat/SKILL.md`)
- Browser-side document database code -> `../no-sql-web-sdk/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/no-sql-web-sdk/SKILL.md`)

### Do NOT use for

- Browser/Web code using `@cloudbase/js-sdk`.
- Server-side or cloud-function database access.
- MySQL / relational database work.

### Common mistakes / gotchas

- Copying Web SDK code into Mini Program pages.
- Manually writing `_openid` during create or update operations.
- Assuming built-in Mini Program identity means security rules can be ignored.
- Mixing collection CRUD and backend-wide admin workflows in the same client path.

### Minimal checklist

- Confirm the caller is a Mini Program page/component or Mini Program-side logic.
- Initialize `wx.cloud` correctly before database calls.
- Verify whether the collection rules rely on `auth.openid` / `_openid`.
- Read the specific companion reference file for the operation you need.

## Overview

This skill covers **Mini Program-side document database access** through `wx.cloud.database()`.

Use it for:

- collection CRUD in Mini Program pages
- query composition and pagination
- aggregation
- geolocation queries

Mini Program CloudBase access comes with built-in identity, but database operations are still constrained by collection permissions and security rules.

## Canonical initialization

```javascript
const db = wx.cloud.database();
const _ = db.command;
```

To target a specific environment:

```javascript
const db = wx.cloud.database({
  env: "test"
});
```

Important notes:

- Users are authenticated through the Mini Program CloudBase context.
- In cloud functions, caller identity is available through `wxContext.OPENID`.
- In client-side collection rules, ownership checks usually use `auth.openid` / `doc._openid`.

## Quick routing

- CRUD -> `./crud-operations.md`
- Complex queries -> `./complex-queries.md`
- Pagination -> `./pagination.md`
- Aggregation -> `./aggregation.md`
- Geolocation -> `./geolocation.md`
- Security rules -> `./security-rules.md`

## Working rules for a coding agent

1. **Keep Mini Program code Mini Program-native**
   - Use `wx.cloud.database()`.
   - Do not substitute browser SDK initialization patterns.

2. **Respect ownership fields**
   - `_openid` is system-managed for SDK writes.
   - Never set or override `_openid` manually in `.add()`, `.set()`, or `.update()` payloads.

3. **Remember that security rules validate requests**
   - If a rule requires ownership conditions, the query shape must match that rule model.
   - Permission errors usually mean the rule/query relationship is wrong, not only that the user is logged out.

4. **Route admin-style operations to backend flows**
   - If the task needs privileged global access, use backend tools or functions instead of exposing that path directly in Mini Program client code.

## Quick examples

### Basic collection access


## security-rules

# CloudBase NoSQL Security Rules for Mini Programs

Use this reference when a Mini Program collection needs permission design or when client-side queries are being rejected by collection rules.

## Core ideas

- Mini Program users usually appear as `auth.openid` in security rules.
- Document ownership is typically checked through `doc._openid`.
- Security rules validate whether the request shape is allowed; they do not filter the result set after the query runs.
- If a query is rejected, inspect the rule/query relationship before rewriting the whole feature.

## Ownership pattern

A common rule for Mini Program user-owned data is:

```json
{
  "read": "doc._openid == auth.openid",
  "write": "doc._openid == auth.openid"
}
```

This means:

- users can read their own documents
- users can write their own documents
- queries usually need to carry the ownership condition explicitly when the rule model requires it

## `_openid` handling

`_openid` is managed by the CloudBase SDK.

Correct:

```javascript
await db.collection("todos").add({
  title: "Buy milk",
  completed: false
});
```

Wrong:

```javascript
await db.collection("todos").add({
  title: "Buy milk",
  _openid: "manual-value"
});
```

Do not set `_openid` manually in write payloads.

## Recommended workflow

1. Decide whether simple permissions are enough.
2. If custom logic is required, read or write the collection rule explicitly.
3. Test queries with the same ownership constraints the rule expects.
4. If the product needs privileged global access, move that path to backend code instead of widening Mini Program direct-access rules.

## Related references

- For the full rule system and examples, also read `../no-sql-web-sdk/security-rules.md`.
- For Mini Program identity flow, read `../auth-wechat/SKILL.md`.

## alarm-interpretation

# Alarm Interpretation (告警解读)

Use this reference when the user asks whether an alert is normal, what peak QPS was, or whether CPU / throttle / invocation metrics look healthy.

## Hard rule: metrics tool only

- **Always** query metrics with `queryEnv(action="metrics", envId="<EnvId>", metricName="<name>")`.
- **Never** call `callCloudApi` (or guess Monitor / TCB Action names) to fetch curves. The MCP path already wraps `DescribeCurveData` via Manager SDK.
- Prefer the returned `Summary` (`max`, `min`, `avg`, `latest`, `peakTimestamp`, `allZero`) before dumping the full `Curve`.

## Default inspection window

- Alert triage: last **1 hour** (`startTime` / `endTime`, format `YYYY-MM-DD HH:mm:ss`)
- Peak / trend questions: last **24 hours** (tool default when times omitted)
- Incident window: narrow to the reported alert time ± 30–60 minutes

## Metric → question map

| User question | metricName | Notes |
|---------------|------------|-------|
| Peak / current QPS | `GatewayTraceEnvQPS` (preferred) or `EnvQPSAll` | Env-level `resourceID` defaults to `all|:|all|:|all|:|all` |
| Function call volume / "调用量为 0" | `FunctionInvocation` | Pass `resourceID=<functionName>` when scoped |
| Function errors | `FunctionError` | Pair with invocation |
| Function timeout | `FunctionTimeout` | |
| Throttle / 429 pressure | `FunctionThrottle` | Also search CLS for `429` |
| MySQL CPU alert | `MysqlCpuUsageRate` | Percent-like usage |
| MySQL memory / disk | `MysqlMemoryUse` / `MysqlStorageUsage` | |
| MySQL QPS / slow queries | `MysqlQps` / `MysqlSlowQueries` | |
| CloudRun CPU / QPS / HTTP errors | `TkeCpuUsedService` / `TkeQPSService` / `TkeHttpErrorService` | `resourceID` = service name (required) |

## Baseline thresholds (skill defaults)

These are **interpretation defaults for Agent answers**, not a substitute for the customer's contracted package. Always state the baseline used, and cross-check `queryEnv(action="info")` / `queryEnv(action="usage")` for package hints when available.

| Signal | Warning | Critical | Healthy interpretation |
|--------|---------|----------|------------------------|
| Gateway / env QPS vs common integration package (500 QPS) | Peak ≥ **70%** of package (≈350) | Peak ≥ **90%** of package (≈450) or sustained ≥ package | Peak well below package → alert may be false positive or short spike |
| MySQL CPU (`MysqlCpuUsageRate`) | Peak ≥ **80** | Peak ≥ **90** or sustained ≥ 80 for most of the window | Peak < 70 → "CPU 告警偏误报/短时尖刺可能性高" unless alert rule is stricter |
| MySQL memory / disk usage | Peak ≥ **80%** of capacity when unit is percent-like | Peak ≥ **90%** | Below 70% → capacity alert likely not sustained |
| Function error rate (`FunctionError.max` / max(`FunctionInvocation.max`, 1)) | ≥ **1%** | ≥ **5%** | Near 0 with healthy invocations → function path OK |
| Function throttle (`FunctionThrottle`) | Any non-zero in window | Sustained non-zero with user-visible 429 | allZero → throttle not evidenced by metrics |
| Function invocation | — | `Summary.allZero === true` while user expects traffic | See fault playbook "调用量为 0" |

If the environment package QPS is known and **not** 500, recompute 70%/90% against that value. If unknown, say: "按常见集成版默认 500 QPS 解读；若你们已升配，请以合同/控制台配额为准。"

## How to answer "CPU 告警是否正常？"

1. Confirm env: `queryEnv(action="info", envId="...")`.
2. Pull `queryEnv(action="metrics", metricName="MysqlCpuUsageRate", ...)` for the alert window (and optionally last 24h for context).
3. Read `Summary.max` / `avg` / `latest` / `peakTimestamp`.
4. Compare to the MySQL CPU baselines above.
5. Answer in plain language, for example:
   - Peak 42%, avg 18% → **告警偏不正常触发或已恢复**：当前窗口未达到 80% 基线。
   - Peak 93% near the alert time → **告警合理**：峰值超过 90% 临界线，建议查慢查询 / 连接数 / 是否变配中。
6. Optional correlates: `MysqlSlowQueries`, `MysqlDbConnections`, `MysqlQps`.

## How to answer "峰值 QPS 多少？"

1. `queryEnv(action="metrics", metricName="GatewayTraceEnvQPS", envId="...")` (default last 24h or user window).
2. Report **`Summary.max` as 峰值 QPS**，并附上 `peakTimestamp`（若有）与 `avg` / `latest`.
3. Compare to package baseline (default 500 unless known otherwise) and state headroom: `headroom = package - peak`.
4. If `sampleCount === 0`, say metrics returned empty — do not invent a number; suggest console monitor and retry with a wider window.

## Report section template

```markdown
## 告警解读

| 问题 | 指标 | 窗口峰值 | 基线 | 结论 |
|------|------|----------|------|------|
| CPU 告警是否正常 | MysqlCpuUsageRate | ${max} | warn≥80 / crit≥90 | ... |
| 峰值 QPS | GatewayTraceEnvQPS | ${max} @ ${peakTimestamp} | package=${packageQps} | ... |

说明：基线为 ops-inspector 默认解读阈值；实际配额以环境套餐为准。
禁止使用 callCloudApi 拉取监控。
```

## fault-playbooks

# Fault Playbooks (故障剧本)

Six high-frequency KA / ops triage playbooks. Use the matching playbook when the symptom matches; always prefer MCP tools listed here — **never** invent Monitor/TCB Actions via `callCloudApi`.

Shared prerequisites for every playbook:

1. `queryEnv(action="info")` — bind `envId`
2. Prefer metrics via `queryEnv(action="metrics", ...)`
3. Prefer logs via `queryLogs` / `queryFunctions` log actions
4. Summarize with severity + next action + console link

---

## Playbook 1 — HTTP 429 / rate limit

### Symptoms

- Client or gateway returns **429**
- User says 限频 / 被限流 / QPS 不够
- Activity traffic spike near launch

### Tools (in order)

1. `queryEnv(action="metrics", envId, metricName="GatewayTraceEnvQPS")` — peak QPS vs package baseline (see `alarm-interpretation.md`; default package **500** if unknown)
2. `queryEnv(action="metrics", envId, metricName="FunctionThrottle", resourceID="<functionName>")` when a function is implicated
3. `queryLogs(action="checkLogService")` then `queryLogs(action="searchLogs", queryString="429 OR throttle OR 限流 OR FREQUENCY", ...)`
4. Optional: `queryFunctions(action="listFunctionLogs", functionName="...")` for per-function evidence

### Decision tree

| Evidence | Likely cause | What to tell the user |
|----------|--------------|------------------------|
| Peak QPS ≥ ~90% of package | Package QPS ceiling | 告警/429 **合理**；需要升配或开按量（集成版可能无法自助，引导控制台/工单） |
| Peak QPS low but `FunctionThrottle` > 0 | Function concurrency / throttle | 查函数并发与预置并发；短时重试 + 降峰 |
| Metrics healthy, logs show 429 on one route | Route/gateway or upstream limit | 核对网关路由与上游；不要盲目升整环境配额 |
| No metrics + no logs | Observability gap | 先开 CLS；用控制台监控核对后再结论 |

### Do not

- Do not call `callCloudApi` to guess rate-limit APIs
- Do not claim the package was raised unless the user or console confirms

---

## Playbook 2 — Cloud function intermittent / persistent 404

### Symptoms

- Invoking a cloud function or HTTP access path returns **404**
- Works sometimes / after redeploy / only on one path
- "函数找不到" / `FUNCTION_NOT_FOUND` / gateway 404

### Tools (in order)

1. `queryFunctions(action="listFunctions")` — does the name exist in **this** env?
2. `queryFunctions(action="getFunctionDetail", functionName="...")` — status, HTTP access, triggers
3. If HTTP: confirm path / domain / gateway with `queryGateway` / hosting docs as available; mismatch often looks like 404
4. `queryLogs(action="searchLogs", queryString="404 OR FUNCTION_NOT_FOUND OR functionName:<name>", ...)`
5. `queryEnv(action="metrics", metricName="FunctionInvocation", resourceID="<functionName>")` — if `allZero`, traffic never reached the function (client/env/path issue more likely than runtime crash)

### Decision tree

| Evidence | Likely cause | What to tell the user |
|----------|--------------|------------------------|
| Function missing in list | Wrong env or never deployed | 切换到正确 envId 或重新部署 |
| Function exists, invocation allZero, client 404 | Wrong URL / path / domain / envId in client | 核对调用方 env 与路径，而非改函数代码 |
| Function exists, invocations > 0, sporadic 404 | Bad alias/version, deleted route, or wrong qualifier | 查版本/别名/HTTP 访问配置与最近部署 |
| Only HTTP path 404 | Gateway route / static hosting path | 查路由 Enable 与 upstream，勿只看函数列表 |

### Do not

- Do not redeploy blindly before confirming the function exists in the target env
- Do not use Web SDK auth debugging for pure routing 404s

---

## Playbook 3 — ACCESS_TOKEN_INVALID

### Symptoms

- API / SDK returns **ACCESS_TOKEN_INVALID** (or token invalid / unauthorized token)
- Login worked before, then sudden failures
- PG / HTTP / management calls fail auth while env is healthy

### Tools (in order)

1. Confirm which surface failed: **app user token** vs **env API key / publishable key** vs **MCP management login**
2. App auth: follow `../auth-tool-cloudbase/SKILL.md` then platform auth skill (`auth-web` / `auth-wechat` / `auth-nodejs`) — check providers with `queryAppAuth` / related auth tools when available
3. Env binding: `queryEnv(action="info")` — wrong env often presents as token/env mismatch
4. `queryLogs(action="searchLogs", queryString="ACCESS_TOKEN_INVALID OR token invalid OR unauthorized", ...)`
5. Metrics are usually secondary; only use `queryEnv(action="metrics")` if correlating a traffic drop after auth breakage

### Decision tree

| Evidence | Likely cause | What to tell the user |
|----------|--------------|------------------------|
| Expired / rotated key or publishable key | Credential lifecycle | 轮换后更新客户端配置；不要把密钥写进仓库 |
| Provider disabled or misconfigured | Auth provider readiness | 先用 auth-tool 打开并校验登录方式 |
| Token from env A used on env B | Env mismatch | 统一 envId 与初始化配置 |
| MCP/management auth failure | Agent not logged in / wrong credential type | 走 `auth` 登录与环境绑定，而不是改业务代码 |
| PG API Key limitation | Product constraint | 说明集成版/PG 场景限制，避免反复重试同一错误密钥类型 |

### Do not

- Do not paste secrets into chat or source
- Do not "fix" by switching to anonymous login unless the product intentionally allows it
- Do not call `callCloudApi` to probe undocumented auth Actions

---

## Playbook 4 — Function / API call volume is 0（调用量为 0）

### Symptoms

- Console or user says 调用次数为 0 / 没有调用量
- Activity is online but metrics stay flat
- Need to know whether the app is broken or metrics are empty

### Tools (in order)


## rule

---
name: ops-inspector
description: AIOps-style CloudBase inspection skill (v3). Use when users need health checks, log diagnosis, alarm interpretation (CPU alert normal?, peak QPS), metrics via queryEnv(action=metrics), or fault playbooks for 429 / AI model 429 / function timeout / function 404 / ACCESS_TOKEN_INVALID / zero invocations. Triggers on 巡检, 诊断, 告警, 峰值 QPS, 限频, 调用量为 0, troubleshooting.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## Activation Contract

### Use this first when

- The user wants to check the health or status of CloudBase resources (cloud functions, CloudRun, databases, storage, etc.).
- The user reports errors, failures, or abnormal behavior and wants a quick diagnosis.
- The user asks for an "inspection", "health check", "巡检", "诊断", or "troubleshooting" of their CloudBase environment.
- The user wants to review recent error logs across services.
- The user asks **告警解读** questions: whether a **CPU 告警** is normal, what **峰值 QPS** was, or whether throttle/error metrics look healthy.
- The symptom matches a v3 fault playbook: **429 / 限频**, **AI 模型 429 / Token 额度**, **云函数超时或轮询超时（`-404005`/433）**, **云函数 404**, **ACCESS_TOKEN_INVALID**, or **调用量为 0**.

### Read before writing code if

- The inspection reveals code-level issues in cloud functions or CloudRun services — then read the relevant implementation skill before suggesting fixes.
- The user wants to fix a problem found during inspection rather than just diagnose it.

### Then also read

- Alarm interpretation baselines -> `references/alarm-interpretation.md`
- Fault playbooks (429 / AI model 429 / function timeout / 404 / token / zero calls) -> `references/fault-playbooks.md`
- Cloud function issues -> `../cloud-functions/SKILL.md`
- CloudRun issues -> `../cloudrun-development/SKILL.md`
- Database issues -> `../postgresql-development-cloudbase/SKILL.md` for CloudBase PG / PostgreSQL, `../relational-database-mcp-cloudbase/SKILL.md` for MySQL, or `../cloudbase-document-database-web-sdk/SKILL.md` for NoSQL
- Auth readiness (token failures) -> `../auth-tool-cloudbase/SKILL.md`
- Environment not visible, binding fails, or only one environment shows up -> `../cloudbase-cli/references/core.md` (*Where credentials are read from*)
- Platform overview -> `../cloudbase-platform/SKILL.md`

### Do NOT use for

- Deploying new resources or writing application code. This skill is read-only and diagnostic.
- Replacing proper monitoring/alerting infrastructure. It provides point-in-time inspection, not continuous monitoring.
- Directly fixing problems — it diagnoses and recommends; actual fixes should use the appropriate implementation skill.
- Fetching metrics by guessing cloud API Actions. **Never** use `callCloudApi` for monitor curves — always use `queryEnv(action="metrics")`.

### Common mistakes / gotchas

- Running a full inspection without first confirming the environment is bound (`auth` tool must show logged-in and env-bound state). If binding fails or only one environment appears, credentials are being resolved **per directory** — see `../cloudbase-cli/references/core.md` (*Where credentials are read from*); it is usually neither a permissions nor a platform problem.
- Ignoring CLS log service status — if CLS is not enabled, `queryLogs` will fail; always check first with `queryLogs(action="checkLogService")`.
- Searching logs without a time range — this can return excessive or irrelevant results. Always scope searches to a relevant time window.
- Treating a single error log as the root cause without correlating across resources. A function error may stem from a database or config issue.
- Answering "峰值 QPS" / "CPU 告警是否正常" from screenshots or memory instead of `queryEnv(action="metrics")`.
- Calling `callCloudApi` with invented `GetMonitorData` / `DescribeCurveData` parameters — the metrics branch already wraps Manager SDK.

### Minimal checklist

- [ ] Environment is bound and accessible (`queryEnv(action="info")`) — if it fails, or only one environment shows up, confirm the current identity and credential slot first (`../cloudbase-cli/references/core.md`)
- [ ] Metrics pulled with `queryEnv(action="metrics")` when the question involves QPS / CPU / throttle / invocation volume
- [ ] CLS log service is enabled (`queryLogs(action="checkLogService")`) when log diagnosis is needed
- [ ] Matching fault playbook selected when symptoms match 429 / AI model 429 / function timeout / function 404 / ACCESS_TOKEN_INVALID / 调用量为 0
- [ ] Time range is specified for any log or metrics searches
- [ ] Findings are summarized with severity levels, **告警解读**, and actionable recommendations

---

## How to use this skill (for a coding agent)

### Ops Inspector v3 additions

v3 adds two mandatory capabilities on top of log/resource inspection:

1. **告警解读** — pull metrics, compare to baselines in `references/alarm-interpretation.md`, answer CPU-alert / peak-QPS style questions in plain language.
2. **故障剧本** — when symptoms match, follow `references/fault-playbooks.md` instead of ad-hoc tool fishing.

### Inspection Modes

| Mode | When to use | Scope |
|------|-------------|-------|
| **Full inspection** | User asks for a general health check / 巡检 / 全面检查 | All resource types + core metrics |
| **Targeted inspection** | User reports a specific error or asks about a specific resource | One resource type or playbook |
| **Alarm interpretation** | User asks CPU 告警是否正常 / 峰值 QPS / 是否限流 | Metrics-first, then logs |
| **Fault playbook** | 429 / AI model 429 / function timeout / function 404 / ACCESS_TOKEN_INVALID / 调用量为 0 | Playbook steps only |

### Full Inspection Workflow

Follow these steps in order for a comprehensive environment health check:

**Step 1 — Environment Check**

```
queryEnv(action="info")
```

Confirm the environment is accessible. Record the `envId` for console link generation.

**Step 2 — Metrics snapshot (v3)**

```
queryEnv(action="metrics", envId="<EnvId>", metricName="GatewayTraceEnvQPS")
queryEnv(action="metrics", envId="<EnvId>", metricName="FunctionInvocation")
queryEnv(action="metrics", envId="<EnvId>", metricName="MysqlCpuUsageRate")
```

Use returned `Summary.max` / `avg` / `allZero` / `peakTimestamp`. Add `FunctionError`, `FunctionThrottle`, or CloudRun `Tke*` metrics when those resources exist. Read `references/alarm-interpretation.md` before concluding.

**Step 3 — Log Service Status**

```
queryLogs(action="checkLogService")
```

If CLS is not enabled, note this as a **warning** — log-based diagnosis will be unavailable. Recommend enabling CLS in the console: `https://tcb.cloud.tencent.com/dev?envId=${envId}#/devops/log`

**Step 4 — Cloud Functions Inspection**

```
queryFunctions(action="listFunctions")

## access-patterns

# Access Patterns

Read this reference for application-level database access: loops, serial calls, duplicate reads, polling, pagination, and operational data.

## Batch N+1 reads

Database round trips should stay bounded as result cardinality grows.

**Incorrect: one query per row**

```ts
for (const row of rankedRows) {
  const { data: profile } = await db
    .from("profiles")
    .select("id, display_name")
    .eq("id", row.user_id)
    .single();
  profiles.push(profile);
}
```

**Correct: one batch query**

```ts
const userIds = [...new Set(rankedRows.map((row) => row.user_id))];
const { data: profiles, error } = await db
  .from("profiles")
  .select("id, display_name")
  .in("id", userIds);

if (error) throw error;
```

Identity lives in `auth.users`. Do not create `public.users` just to join display names. Use a business `profiles` table or embed a declared foreign key. Use a batch plus an in-memory map when separate result shaping is clearer.

## Run independent queries concurrently

Serial execution is correct when query B depends on query A. Independent reads should share one wait.

```ts
const [roomResult, memberResult] = await Promise.all([
  db.from("rooms").select("id, status").eq("id", roomId).single(),
  db.from("room_members").select("user_id, role").eq("room_id", roomId),
]);
if (roomResult.error) throw roomResult.error;
if (memberResult.error) throw memberResult.error;
```

`app.rdb()` returns `{ data, error }` and does not throw on query failure. Keep writes serial when they require ordered state transitions. Prefer an RPC when multiple writes must commit atomically; `Promise.all` does not provide a database transaction.

## Make polling selective

A status endpoint should read one job, room, or cursor range through an indexed equality/range predicate. Return an explicit retry interval or version marker. CloudBase PG has no NoSQL `.watch()` / Realtime subscription; do not copy that path onto `app.rdb()`.

Implement the poll with SDK filters, not raw `$1` SQL in application code:

```ts
const { data, error } = await db
  .from("jobs")
  .select("id, status")
  .eq("owner_id", ownerId)
  .gt("updated_at", since)
  .order("updated_at", { ascending: true })
  .order("id", { ascending: true })
  .limit(100);
if (error) throw error;
```

Back this path with an index on `(owner_id, updated_at, id)`.

## Bound lists without deep offsets

The documented SDK pagination helper is inclusive `.range(from, to)` after `.order()`. That is enough for short pages. Deep `.range()` still walks earlier rows.

```ts
const { data, error } = await db
  .from("articles")
  .select("id, title, created_at")
  .order("created_at", { ascending: false })
  .range(0, 19);
if (error) throw error;
```

For large ranked lists, wrap keyset SQL in an RPC. `app.rdb()` has no tuple-comparison helper, and application code must not send Postgres `$1` placeholders through the SDK.

```sql
-- RPC body / EXPLAIN target only
SELECT id, title, created_at
FROM articles
WHERE (created_at, id) < ($1, $2)
ORDER BY created_at DESC, id DESC
LIMIT 20;
```

Back that RPC with `(created_at DESC, id DESC)`.

## Route operational data by purpose

- Application logs and request traces belong in CloudBase logging.
- Large immutable exports and archives belong in object storage.
- High-volume analytics events belong in an analytics-oriented system.
- PG holds transactional facts that need constraints, joins, or transactional updates.

If audit records are a product requirement, store a bounded audit model with retention, archive-to-storage planning, and restricted access. Do not use a catch-all request-log table as the default, and do not assume table partitioning is a CloudBase console feature.

## capacity-and-connections

# Capacity and Connections

Read this reference for burst traffic, launch readiness, or database sizing. CloudBase PG business data uses the SDK or HTTP gateway, not an application-managed TCP pool.

## Inspect before a launch

Call `queryEnv(action="info", envId=...)` and record the PostgreSQL allocation exposed by the environment response. Pair it with explicit workload assumptions:

- peak requests per second and burst duration;
- database operations per request after batching;
- expected active rows and result sizes;
- scheduled jobs that overlap the peak;
- acceptable latency and failure rate.

Small development allocations are not evidence of production capacity. If the environment response lacks enough detail to judge capacity, state that uncertainty and ask for a verified console allocation or load-test result.

## Estimate database demand

Use:

```text
database_ops_per_second =
  request_rate
  * database_round_trips_per_request
  * retry_multiplier
```

This is a planning estimate, not a capacity guarantee. Reduce round trips before using instance size as the only remedy.

## Prefer the SDK path; do not invent a TCP pool

CloudBase PG traffic from Web, cloud functions, and CloudRun should go through the existing `app.rdb()` client (or the documented PG HTTP API). That path is an HTTP request to the CloudBase gateway. The platform owns database sessions behind the gateway. Application code does not open `pg.Pool`, does not hold `DATABASE_URL`, and cannot tune `max_connections` from the SDK. Do not add a second `cloudbase.init` in this skill; reuse the client from `../postgresql-development-cloudbase/SKILL.md`.

What still belongs to the application:

- fewer round trips per request (batch, join, concurrency);
- bounded result sets;
- observed instance size versus stated peak QPS.

Reuse one SDK `app` / `db` at module scope so credential and client setup are not repeated. That is not a PostgreSQL connection pool. The documented single-row helper is `.single()`, not `.maybeSingle()`.

```ts
export async function loadOrder(id: string) {
  const { data, error } = await db
    .from("orders")
    .select("id, status")
    .eq("id", id)
    .single();
  if (error) throw error;
  return data;
}
```

Do not expose database connection strings, SecretKey, API Key, or `service_role` credentials to browser code.

TCP clients (`pg`, Prisma, `DATABASE_URL`) are an exception-only migration path. They need VPC access and a bounded pool because each compute instance then holds real database connections. Do not introduce that path for new CloudBase PG CRUD. If an existing app already uses it, follow `../cloudrun-development/references/vpc-and-database.md` and `../cloud-functions/references/vpc-and-tcp-database.md`.

## Define a peak response

Before launch, identify who can change capacity, how long a change takes, what metric triggers action, and how traffic is shed while the database is unhealthy. Treat automatic scaling as unavailable unless the target environment explicitly proves otherwise.

A skill can surface this risk; it cannot provision missing elasticity or repair a platform authentication failure.

## indexes-and-explain

# Indexes and EXPLAIN

Read this reference when a query or RPC is slow, or when a changed access path needs an index decision.

## Index observed access paths

PostgreSQL automatically indexes primary and unique keys. It does not automatically index referencing foreign-key columns. Add indexes for frequent filters, joins, and stable ordering paths. The SQL below is for migrations and `EXPLAIN`; substitute literals. Application reads still go through `app.rdb()`.

**Incorrect**

```sql
SELECT id, status, updated_at
FROM matches
WHERE room_id = $1 AND status = 'active'
ORDER BY updated_at DESC;
```

**Correct migration**

```sql
CREATE INDEX matches_room_active_updated_idx
  ON public.matches (room_id, updated_at DESC)
  WHERE status = 'active';
```

Put equality columns first, then range or ordering columns. Use a partial index when the same selective predicate appears consistently. Each extra index increases write cost and storage, so tie every non-constraint index to a named access path.

## Preserve indexable predicates

Compare raw indexed columns to ranges instead of wrapping them in a function.

```sql
-- Full scan risk unless a matching expression index exists
WHERE date_trunc('day', created_at) = $1

-- Uses a normal index on created_at
WHERE created_at >= $1 AND created_at < $1 + INTERVAL '1 day'
```

## Explain before changing

Use `queryPgDatabase(action="sql")` with `EXPLAIN (BUFFERS, FORMAT TEXT)` and representative literals. That action only accepts read-only SQL. The read-only gate treats the token `ANALYZE` as mutating, so `EXPLAIN ANALYZE` is rejected — do not send it through `queryPgDatabase`.

Plain `EXPLAIN` estimates a plan; it does not prove runtime cost. After an index lands, compare scan type, row estimates, and buffer reads on the same `EXPLAIN` text. If actual timings are required, state that the management SQL path cannot run `EXPLAIN ANALYZE` and do not invent a TCP `psql` session.

Record:

- estimated rows;
- sequential scans on large relations;
- sort or hash nodes;
- buffer reads;
- the dominant node, not merely the highest estimated cost.

After changing SQL or adding an index through `applyMigration`, run the same `EXPLAIN` again and compare scan type, row estimates, and buffers. A plan change without a better scan or estimate is not completion.

## Stored procedures and RPCs

For a slow RPC, identify the SQL statements inside the function and explain those statements with representative arguments. A top-level RPC duration alone cannot identify missing indexes or repeated work. Prefer set-based SQL over procedural loops that issue one query per item.

## schema-and-rls

# Schema and RLS Quality

Read this reference when an access design changes tables, relationships, tenant isolation, or row policies. Use `../postgresql-development-cloudbase/references/auth-and-rls.md` as the canonical source for CloudBase grants, helper types, and complete policy templates.

## Start from access paths

Before DDL, write down:

- rows created per business event;
- common equality, range, join, and ordering predicates;
- expected cardinality and retention;
- write contention and required atomic transitions;
- owner or tenant boundary for every row.

Normalize transactional facts by default. Denormalize only a measured hot read and define how the derived value stays consistent.

## Encode invariants in PostgreSQL

Use a primary key, `NOT NULL`, `UNIQUE`, foreign keys, and `CHECK` constraints for invariants the database can enforce. Use `TIMESTAMPTZ` for event time and exact `NUMERIC` for money. Prefer `GENERATED ... AS IDENTITY` for new numeric surrogate keys.

Index the referencing side of every foreign key used for joins or parent deletion checks.

## Separate authentication from authorization

The policy `TO` clause selects eligible database roles. `USING` and `WITH CHECK` select eligible rows.

**Incorrect: authenticated users can access every order**

```sql
CREATE POLICY orders_read ON public.orders
  FOR SELECT
  USING (auth.role() = 'authenticated');
```

**Correct: authenticated users can access their own orders**

```sql
CREATE INDEX orders_owner_id_idx ON public.orders (owner_id);

CREATE POLICY orders_read_own ON public.orders
  FOR SELECT TO authenticated
  USING ((SELECT auth.uid()) = owner_id);
```

CloudBase `auth.uid()` returns `text`; keep owner identifiers as `varchar(64)` or `text`. Do not default owner columns to `uuid`. Wrapping stable auth helpers in `SELECT` lets PostgreSQL initialize the value once instead of evaluating it for every row. Table access still needs `GRANT` plus RLS; copy the grant sequence from `../postgresql-development-cloudbase/references/auth-and-rls.md`.

For updates, use both predicates:

```sql
CREATE POLICY orders_update_own ON public.orders
  FOR UPDATE TO authenticated
  USING ((SELECT auth.uid()) = owner_id)
  WITH CHECK ((SELECT auth.uid()) = owner_id);
```

`TO authenticated` includes any session that maps to that role, including anonymous sign-in. Do not copy a Supabase claim name from memory. Inspect `auth.jwt()` in this environment, or store a durable role in a `profiles` / `user_roles` table keyed by `auth.uid()`.

## Multi-tenant default

Use shared tables with an explicit `tenant_id` plus RLS when tenants share the same schema and lifecycle. Include `tenant_id` in unique constraints and leading index columns for tenant-scoped queries.

CloudBase PG is one database per environment. Do not plan a second database or a provisioned schema-per-tenant fleet. Isolate tenants with `tenant_id` plus RLS. Do not create one table per user.

## Migration discipline

Represent each schema change as a local `cloudbase/migrations/<version>_<name>.sql` file and apply it through `applyMigration`. In disposable environments, a new migration may deliberately rebuild a table. In persistent environments, use forward-compatible expand/migrate/contract changes and a new migration for every correction.

## rule

---
name: postgresql-best-practices-cloudbase
description: "CloudBase PostgreSQL access-pattern and slow-query quality guidance. Use when designing how tables are read and written, eliminating per-row database calls, adding indexes for filters or joins, reviewing high-traffic data access, or explaining a slow SQL query. Not for first-time PG SDK setup, login UI, or NoSQL collections."
version: 2.35.2
license: MIT
alwaysApply: false
---

# CloudBase PostgreSQL Best Practices

This skill turns a working CloudBase PG implementation into a reviewable access design. It makes query paths, indexes, row authorization, and launch capacity explicit before code is considered complete.

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../postgresql-development-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## When to use

- A feature needs a new or changed access pattern.
- Application code performs repeated, serial, or high-frequency PG queries.
- A SQL query, RPC, endpoint, or polling path is slow.
- A high-traffic launch needs a database readiness review.

## Do NOT use for

- PG environment setup, `app.rdb()` syntax, migrations, GRANTs, or base RLS correctness: use `../postgresql-development-cloudbase/SKILL.md`.
- Login provider or UI implementation: use the matching auth skill.
- Confirmed NoSQL collection work: use the document database skill.
- Platform alarm diagnosis or slow-log collection: use `../ops-inspector/SKILL.md`.

## Workflow

### 1. Inventory access paths

List every changed endpoint, job, RPC, or UI flow and its reads and writes. Record filters, joins, sort keys, expected cardinality, and request frequency.

**Complete when:** every changed path has a concrete query inventory; unknown volume or peak concurrency is marked as an assumption for the user.

### 2. Design schema, indexes, and row authorization together

Derive columns and indexes from the query inventory. Every frequent filter, join, and stable ordering path must have a deliberate index decision. For user-owned rows, use the role as the policy gate and identity as the row predicate:

```sql
CREATE POLICY orders_select_own ON public.orders
  FOR SELECT TO authenticated
  USING ((SELECT auth.uid()) = owner_id);
```

Apply schema DDL through the versioned `applyMigration` workflow defined by `../postgresql-development-cloudbase/SKILL.md`. This keeps Git, development, and production reproducible; the tradeoff is that experiments require a new migration version instead of ad hoc schema mutation.

**Complete when:** every query predicate has an index decision, every user-owned path has an ownership predicate, and all DDL is represented in one reviewable migration for the change.

### 3. Implement bounded database access

Batch related keys, combine repeated reads, and execute independent queries concurrently. Keep each result bounded by a filter plus `.limit()` / `.range()`, or by an RPC that implements keyset pagination.

```ts
const userIds = [...new Set(rows.map((row) => row.user_id))];
const { data: profiles, error } = await db
  .from("profiles")
  .select("id, display_name")
  .in("id", userIds);

if (error) throw error;
```

Send request logs, traces, and high-volume analytics to the platform logging service or purpose-built analytics storage. Keep PG for transactional data that participates in business queries and constraints.

**Complete when:** the changed code has no database call inside an item loop, no repeated read of the same row in one request, and no unbounded hot-path query.

### 4. Check launch capacity when traffic is material

For campaigns, rankings, polling endpoints, or other bursty paths, inspect the target environment with `queryEnv(action="info", envId=...)`. Report the observed PG allocation, expected peak load, and unresolved capacity risk. CloudBase currently requires an explicit capacity plan; do not represent autoscaling as guaranteed.

**Complete when:** the current allocation is recorded and either judged against an explicit traffic assumption or raised to the user as an unresolved launch blocker.

## Routing

| Current branch | Read |
| --- | --- |
| Repeated calls, serial queries, polling, pagination, or logging tables | `references/access-patterns.md` |
| Missing indexes, slow SQL/RPC, or query-plan review | `references/indexes-and-explain.md` |
| New schema, tenant isolation, or RLS performance | `references/schema-and-rls.md` |
| Campaign launch or database sizing | `references/capacity-and-connections.md` |

Load only the references required by the current branch.

## Minimum self-check

- Every changed access path is accounted for.
- Every frequent filter, join, and stable sort has an index decision.
- Database round trips are bounded independently of result cardinality.
- RLS separates role gating (`TO`) from row authorization (`auth.uid()`).
- Schema changes use the canonical migration workflow.
- Capacity claims are based on observed allocation and stated traffic assumptions.

## app-workflow

# CloudBase PG App Workflow

Use this reference when building or repairing a real user-facing Web app backed by CloudBase PostgreSQL. The goal is a working product flow, not broad platform exploration. In scaffold/TODO apps, favor vertical closure over repo inventory.

## Closure Path

1. Inspect the active app code first:
   - `src/lib/backend.*`
   - `src/lib/auth.*`
   - `src/lib/*service.*`
   - route guards
   - form submit handlers
   - Open these files directly. Do not begin with generic repo inventory, delegated exploration, or a repo-wide file list.
2. If those files still contain TODOs, implement them in place before optional platform research or helper creation.
3. Confirm the environment has the required capabilities:
   - username/password auth if the app logs in with plain usernames
   - PostgreSQL resource
   - Cloud Storage if the app uploads files. In CloudBase PG, "having storage" means having an explicitly-created `pgstore` bucket — same model as Supabase Storage. Check existing buckets with `queryPgStorage(action="buckets")`. If the upload target (e.g. `covers`) is missing, create/select the bucket through the documented CloudBase management surface or console before writing browser upload code. Browser SDKs cannot create a pgstore bucket; the legacy NoSQL bucket reported in `EnvInfo.Storages[]` is NOT a valid pgstore target.
4. Create or repair the minimal PG schema via the migration workflow (not bare `execute` for DDL):
   - If the workspace is missing local SQL for versions already in remote history, first run `managePgDatabase(action="fetchMigration")` (add `force=true` only when intentionally overwriting drifted local files).
   - Choose `migrationVersion` (`YYYYMMDDHHMMSS`) + `migrationName`, write `cloudbase/migrations/<version>_<name>.sql` (same dir as CLI `tcb db pg migration`), then `managePgDatabase(action="applyMigration", migrationName, migrationVersion, sql, confirm=true)`.
   - Prefer `migrationVersion` strictly newer than remote `LatestVersion`. For intentional out-of-order (branch/backfill) only, add `includeAll=true` (CLI `--include-all`).
   - Apply required `GRANT` statements, sequence grants for `serial`/`bigserial`, `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`, and RLS policies (same migration SQL or follow-up `execute` for ops-only GRANT/POLICY).
5. Immediately call `queryPgDatabase(action="objects")`, then `queryPgDatabase(action="schema", objectName="public.<table>")` for every table touched by the app.
6. Implement browser CRUD with one shared CloudBase Web SDK app instance and `app.rdb()`.
7. Implement auth guards and owner UID lookup with `auth.getSession()`, not `auth.getUser()`.
8. If direct browser `app.rdb()` uses RLS, verify the policy identity through the real browser session before depending on it.
9. Implement browser uploads with the documented CloudBase Storage Web SDK surface. The bucket from step 3 must exist BEFORE this step runs; pass the bucket to `from(bucket)` and pass only the object key to `upload(key, file)` (e.g. `app.storage.from("covers").upload("<file>", file)`). Do not repeat the bucket prefix inside the key.
10. Run the local build/typecheck.
11. Exercise the actual browser flow: login, create, list, edit/delete if required.
12. Read back persisted rows with `queryPgDatabase` before claiming done.

## Minimum Schema Pattern

For CMS/admin-style apps, prefer a small explicit schema:

```sql
create table if not exists public.user_roles (
  uid text primary key,
  username text not null unique,
  role text not null check (role in ('admin', 'editor')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.articles (
  _id uuid primary key default gen_random_uuid(),
  title text not null,
  summary text,
  cover_image text,
  content text,
  status text not null default 'draft' check (status in ('draft', 'published')),
  author_id varchar(64) not null default auth.uid(),
  author_name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

Then grant the user-facing role and create policies before browser CRUD:

```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON public.articles TO authenticated;
GRANT SELECT ON public.user_roles TO authenticated;
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;
CREATE POLICY articles_owner_all ON public.articles
  FOR ALL TO authenticated
  USING (author_id = auth.uid())
  WITH CHECK (author_id = auth.uid());
```

If a table uses `serial` / `bigserial`, also grant its sequence: `GRANT USAGE, SELECT ON SEQUENCE public.<table>_<column>_seq TO authenticated;`.

If the environment is disposable or the task requires a known schema, prefer an explicit `drop table if exists ... cascade` followed by `create table`. Do not rely on `create table if not exists` to fix incompatible old columns.

## Browser Data Access

Use one shared app:

```ts
import cloudbase from "@cloudbase/js-sdk";

export const app = cloudbase.init({ env: import.meta.env.VITE_ENV_ID });
export const auth = app.auth;
export const db = app.rdb();
```

Use the session as the single source of truth for login state and current UID:

```ts
async function getActiveSession() {
  const { data, error } = await auth.getSession();
  const session = data?.session;
  if (error || !session || session.user?.is_anonymous) return null;
  return session;
}

export async function checkAuth() {
  return Boolean(await getActiveSession());
}

export async function getCurrentUser() {
  const session = await getActiveSession();
  const user = session?.user;
  if (!user) return null;

  const uid = user.id || user.sub || user.uid;
  if (!uid) return null;

  return {
    uid,
    displayName:
      user.user_metadata?.username ||
      user.username ||
      user.email ||
      uid,
  };
}
```


## auth-and-rls

# CloudBase PG Auth And RLS

Use this reference before writing browser-side PG CRUD or database policies.

## Key / role mapping

| Credential | Database role | Where it can live | Notes |
| --- | --- | --- | --- |
| Publishable Key | `anon` | Frontend-safe | Still constrained by GRANT/RLS. |
| User access token | `authenticated` | SDK-managed frontend session | Represents a real logged-in user. |
| API Key | `service_role` | Backend / trusted tooling only | Bypasses RLS; never expose to browser code. Treat any leak as a serious credential compromise and rotate/revoke it via `manageAppAuth(action="deleteApiKey")` immediately. |

## `auth.users` — the built-in account table

CloudBase PG stores account data in `auth.users` (schema `auth`), not a business-defined table. Query it directly instead of creating a parallel `public.users` table for identity data:

```sql
select id, email, phone, app_metadata, user_metadata from auth.users;

-- Join business tables against the built-in account table
select o.*, u.user_metadata->>'name' as buyer_name
from public.orders o
join auth.users u on u.id = o.buyer_id;
```

Only create a separate `public.*` table (e.g. `user_roles`, `profiles`) when the app needs fields that do not belong in `auth.users`, such as an app-specific role or a denormalized display name for fast reads. Do not duplicate `email`/`phone` into a new table just to avoid a join.

## SQL identity helpers

CloudBase PG provides official SQL helpers:

```sql
select auth.uid();   -- JWT sub / user id (returns text, NOT uuid)
select auth.role();  -- anon / authenticated / service_role
select auth.jwt();   -- full JWT claims as jsonb
select auth.email(); -- current email if available
```

**⚠️ CRITICAL: `auth.uid()` returns `text`, not `uuid`.** Unlike Supabase (where `auth.uid()` is `uuid`), CloudBase returns a string so identity can cover WeChat `openid` and other non-UUID providers. Prefer owner columns as `varchar(64)` / `text` so comparisons stay type-safe:

```sql
-- Preferred: text/varchar owner column matches auth.uid() directly
owner_id varchar(64) not null default auth.uid()
-- ...
USING (owner_id = auth.uid())
```

If an existing column is `uuid`, cast explicitly or you will get `ERROR: operator does not exist: uuid = text`:

```sql
-- Only when the JWT sub is a valid UUID AND the column type is uuid
USING (author_id = auth.uid()::uuid)
WITH CHECK (author_id = auth.uid()::uuid)
```

Do not cast when the identity may be a WeChat `openid` or other non-UUID string — keep the column as `text` / `varchar` instead.

**⚠️ CRITICAL: Always use `auth.uid()` for user identity in RLS policies.** Do NOT use `current_user` or `current_setting(...)` — these are PostgreSQL built-in functions that return the database role name (e.g. `authenticated`), not the CloudBase auth user ID. Using `current_user` in a policy like `USING (author_id = current_user)` will never match any real user ID.

If you are unsure whether the auth helper functions are available in your environment, run:
```sql
SELECT proname FROM pg_proc WHERE pronamespace = 'auth'::regnamespace;
```
This returns the list of available `auth.*` functions (e.g. `uid`, `role`, `jwt`, `email`).

Prefer database-owned identity fields:

```sql
create table public.todos (
  id bigserial primary key,
  title text not null,
  owner_id varchar(64) not null default auth.uid(),
  created_at timestamptz not null default now()
);
```

Frontend insert payloads should omit `owner_id` / `author_id` when the column has `DEFAULT auth.uid()`.

## Minimum GRANT + RLS sequence

Business tables require two layers: table-level GRANT and row-level RLS. Both must pass.

```sql
create table public.todos (
  id bigserial primary key,
  title text not null,
  is_completed boolean not null default false,
  owner_id varchar(64) not null default auth.uid(),
  created_at timestamptz not null default now()
);

create index idx_todos_owner_id on public.todos(owner_id);

-- Table permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.todos TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE public.todos_id_seq TO authenticated;
GRANT ALL ON public.todos TO service_role;
GRANT USAGE, SELECT ON SEQUENCE public.todos_id_seq TO service_role;

-- Row permissions
ALTER TABLE public.todos ENABLE ROW LEVEL SECURITY;

CREATE POLICY todos_select_own ON public.todos
  FOR SELECT TO authenticated
  USING (owner_id = auth.uid());

CREATE POLICY todos_insert_own ON public.todos
  FOR INSERT TO authenticated
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY todos_update_own ON public.todos
  FOR UPDATE TO authenticated
  USING (owner_id = auth.uid())
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY todos_delete_own ON public.todos
  FOR DELETE TO authenticated
  USING (owner_id = auth.uid());
```


## http-api

# CloudBase PG HTTP API

Use the HTTP API only when the SDK path is blocked or the caller is a non-SDK client.

## Base endpoints

```text
REST: https://<envId>.api.tcloudbasegateway.com/v1/rdb/rest/<table>
Auth: https://<envId>.api.tcloudbasegateway.com/auth/v1
```

Schema-qualified forms may also be available depending on the target database shape:

```text
/v1/rdb/rest/<schema>/<table>
/v1/rdb/rest/<instance>/<schema>/<table>
```

## Auth header

```http
Authorization: Bearer <Publishable Key | access_token | API Key>
```

- Publishable Key maps to `anon`.
- User access token maps to `authenticated`.
- API Key maps to `service_role` and must never be exposed in browser code.

## Query examples

```bash
curl "https://<envId>.api.tcloudbasegateway.com/v1/rdb/rest/todos?select=*&is_completed=eq.false" \
  -H "Authorization: Bearer <access_token>"
```

```bash
curl -X POST "https://<envId>.api.tcloudbasegateway.com/v1/rdb/rest/todos" \
  -H "Authorization: Bearer <access_token>" \
  -H "Prefer: return=representation" \
  -H "Content-Type: application/json" \
  -d '{"title":"写一篇文档"}'
```

Do not send `_openid` for PG tables. Use owner columns with `DEFAULT auth.uid()` / JWT `sub`.

## PostgREST query syntax

- equality: `?status=eq.published`
- range: `?price=gte.100&price=lte.500`
- like: `?name=like.*CloudBase*`
- in: `?status=in.(draft,published)`
- order: `?order=created_at.desc`
- pagination: `?limit=20&offset=0`
- columns: `?select=id,title,created_at`

If the endpoint shape is uncertain, query OpenAPI docs with `searchKnowledgeBase(mode="openapi", apiName="mysqldb", query="PostgreSQL ...")` instead of guessing paths.

## index

# CloudBase PG Reference Index

Use this index after `postgresql-development/SKILL.md` identifies the task as CloudBase PostgreSQL / CloudBase PG / PG mode.

## Read order

1. `pg-mode-overview.md` — environment shape, schemas, roles, and when PG mode applies.
2. `auth-and-rls.md` — JWT identity, `auth.uid()` (**returns `text`**, not `uuid`) / `auth.role()` / `auth.jwt()`, GRANT + RLS templates, and `service_role` risks.
3. `app-workflow.md` — end-to-end Web/CMS implementation workflow.
4. `storage-pg.md` — PG storage bucket/object model, `app.storage.from('bucket')`, and storage RLS.
5. `http-api.md` — PostgREST `/v1/rdb/rest/...` fallback and auth headers.
6. `realtime.md` — `app.realtime()` Broadcast / Presence / Postgres CDC: the mandatory environment probe, delivery guarantees, private-channel RLS, and CDC database-side setup.
7. `troubleshooting.md` — SDK version, DDL wrapping, role simulation, mini program base-library issues.

## Routing reminders

- PG business data uses `app.rdb().from(...)`, `queryPgDatabase`, and `managePgDatabase`.
- Realtime (`app.realtime()`, broadcast / presence / postgres_changes) is a **different module** from document-database `collection.watch()`. Probe the environment first — see `realtime.md` Step 0.
- Do not route PG work to NoSQL `app.database()` / `db.collection(...)` or MySQL `queryMysqlDatabase` / `manageMysqlDatabase`.
- Browser code must never contain API Key / `service_role` credentials.
- For owner fields, prefer `varchar(64)` / `text` with database defaults such as `DEFAULT auth.uid()` and omit the owner field from frontend insert payloads. Remember `auth.uid()` is `text`; cast with `::uuid` only when comparing to an existing `uuid` column.

## pg-mode-overview

# CloudBase PG Mode Overview

CloudBase PG mode is a Postgres-Native environment mode. It is not simply "adding a PostgreSQL instance" to a legacy environment.

## Environment facts

- PG mode is selected when creating a new CloudBase environment with PostgreSQL.
- Legacy environments cannot be upgraded in place to PG mode. If `RuntimeBackends.postgresql !== true`, use the matching legacy NoSQL/MySQL skill or create/select a PG-mode environment.
- In PG mode, PostgreSQL is the unified runtime for:
  - `public` schema: business tables.
  - `auth` schema: user data and JWT identity.
  - `storage` schema: bucket/object metadata.
- PG and NoSQL can coexist. Existing NoSQL collections keep using NoSQL APIs; new business data explicitly requested in PG should use PG APIs.

## Core access paths

- Web / frontend SDK: `app.rdb().from('<table>')`.
- MCP management: `queryPgDatabase` / `managePgDatabase`.
- REST fallback: PostgREST-compatible `/v1/rdb/rest/<table>`.
- Storage: `app.storage.from('<bucket>').upload('<key>', file)` against a PG storage bucket.

## Role and schema vocabulary

- `anon`: requests backed by Publishable Key / anonymous identity.
- `authenticated`: requests backed by a logged-in user's access token.
- `service_role`: API Key / privileged service role; bypasses RLS and must stay server-side only.
- `auth.uid()`: current JWT `sub` as **`text`** (not `uuid`; cast with `::uuid` only when comparing to a `uuid` column whose values are real UUIDs).
- `auth.role()`: current database role.
- `auth.jwt()`: full JWT claims.
- `auth.email()`: current user email when available.

## Common fit

Prefer PG mode for structured relational data, joins, transactions, row-level permission modeling, `pgvector` / SQL extensions, and apps that benefit from PostgREST and SQL-native authorization.

## realtime

# CloudBase PG Realtime

`app.realtime()` is the PostgreSQL-mode realtime surface. It is Supabase-Realtime compatible and ships three primitives:

| Primitive | Listen type | Use for |
| --- | --- | --- |
| Broadcast | `broadcast` | Ephemeral in-channel messages, signaling, cursors, actions |
| Presence | `presence` | Who is on a channel; join / leave |
| Postgres CDC | `postgres_changes` | Reacting to `INSERT` / `UPDATE` / `DELETE` on business tables |

It is **not** the document-database `collection.watch()` path. See "Not the same as `watch()`" below.

## Step 0 — Probe the environment before writing any code

Realtime is not enabled on every environment yet. Run this **first**, via `queryPgDatabase` with `action=sql`:

```sql
SELECT
  (SELECT count(*) FROM pg_namespace WHERE nspname = 'realtime') AS has_realtime_schema,
  (SELECT count(*) FROM information_schema.tables WHERE table_schema = 'realtime') AS realtime_table_cnt;
```

- `has_realtime_schema >= 1` → enabled. Continue.
- `has_realtime_schema = 0` → **not enabled**. Stop here. Do not write realtime code, do not try to enable it yourself, and do not substitute a hand-rolled polling loop. Tell the user the current environment has no realtime schema (the capability is not generally available yet) and let them file a capability request at the CloudBase developer community: <https://cnb.cool/tencent/cloud/cloudbase/community/-/issues>

Do **not** gate on `pg_publication LIKE 'cloudbase_realtime%'`. A publication count of `0` is normal — it only means no table has CDC enabled yet.

Once the schema exists, confirm the shape you will rely on:

```sql
SELECT table_name FROM information_schema.tables WHERE table_schema = 'realtime';
-- expect messages, subscription, schema_migrations
```

## Not the same as `watch()`

Two independent modules. They do **not** replace each other:

| You want | Module | Register | Call |
| --- | --- | --- | --- |
| Document-database collection changes | `@cloudbase/js-sdk/realtime` | `registerRealtime` | `collection.watch()` |
| Broadcast / Presence / Postgres CDC | `@cloudbase/js-sdk/realtime-js` | `registerRealtimeJs` | `app.realtime()` |

Full-import users get both registered automatically. On-demand imports must register only the one they use. Never answer a realtime question with `watch()` code without confirming which database model the project uses.

## Channel lifecycle

```js
const realtime = app.realtime();
const channel = realtime.channel("room:42", {
  config: { private: true, presence: { key: currentUserId } },
});

channel
  .on("broadcast", { event: "move" }, (payload) => { /* ... */ })
  .on("presence", { event: "sync" }, () => channel.presenceState())
  .on("presence", { event: "join" }, ({ newPresences }) => { /* ... */ })
  .on("presence", { event: "leave" }, ({ leftPresences }) => { /* ... */ })
  .subscribe(async (status, err) => {
    if (status === "SUBSCRIBED") await channel.track({ user_id: 1, name: "Ada" });
    if (status === "CHANNEL_ERROR" || status === "TIMED_OUT") console.error(status, err);
  });
```

Rules that the SDK does not enforce for you:

- **Bind `presence` and `postgres_changes` listeners before `subscribe()`.** Broadcast handlers may be added later; these two may not.
- `send()` / `track()` are only valid after `SUBSCRIBED`.
- `config.presence.key` is the **connection identity**, not a payload field: `presenceState()` groups tracked state by it. Two clients sharing one key collapse into a single entry, so the online count comes out wrong with no error raised. Use a stable per-user value — the logged-in user id — never a hard-coded constant such as `"user-1"`, and never a random value, which makes one user show up as many.
- Always clean up, or you leak connections: `await channel.unsubscribe()` then `await realtime.removeChannel(channel)`. Use `realtime.removeAllChannels()` to tear everything down.
- The same `app` instance reuses one realtime client.
- Node.js needs the optional `ws` dependency. WeChat mini programs must use `app.realtime()` — never `new RealtimeClient()` — and need a base library supporting `wx.connectSocket`.

## Delivery guarantees — treat Broadcast as fire-and-forget

Defaults are `broadcast: { ack: false, self: false }`:

- `ack: false` → `send()` resolves **without** waiting for server confirmation.
- `self: false` → the sender does not receive its own message.
- There is no ordering guarantee across messages.

For any state that must converge (turns, scores, board state), do **not** treat a received message as the source of truth:

1. Persist authoritative state in PostgreSQL (`app.rdb()`).
2. Broadcast carries only a "changed" hint plus a monotonic sequence number.
3. On a gap, out-of-order arrival, or `resubscribe`, re-read the snapshot from the database instead of replaying a message log.
4. **Connection hot-cut**: CloudBase keeps a ~270s dual-connection hot-cut to stay under the gateway connection lifetime. A message lost during a cut is indistinguishable from one never sent, so the sequence-plus-snapshot rule above is mandatory, not optional.

Set `ack: true` only where an occasional extra round trip is acceptable.

## Private channels and authorization

`config.private: false` is the default. With a public channel the RLS layer is **not** consulted: anyone who knows or guesses the topic can subscribe and send. For room-scoped game or user data that is unacceptable — `private: true` is required.

`private: true` routes authorization through RLS on `realtime.messages`, which the platform already creates with `topic`, `extension` (`broadcast` / `presence`), `payload`, `event`, `private` columns and RLS **enabled with zero policies**. Zero policies means deny: you must add the policies yourself or every private subscribe and send is rejected.

The helper `realtime.topic()` resolves to `current_setting('realtime.topic')`. Because the SDK prepends `realtime:` when it creates the channel, normalize before comparing:

```sql
-- Members of a room may read its channel
CREATE POLICY realtime_room_read ON realtime.messages
  FOR SELECT TO authenticated
  USING (
    extension IN ('broadcast', 'presence')
    AND EXISTS (
      SELECT 1 FROM public.room_members m
      WHERE m.topic = replace(realtime.topic(), 'realtime:', '')
        AND m.user_id = auth.uid()
    )
  );

-- ...and may write to it
CREATE POLICY realtime_room_write ON realtime.messages
  FOR INSERT TO authenticated
  WITH CHECK (
    extension IN ('broadcast', 'presence')
    AND EXISTS (
      SELECT 1 FROM public.room_members m
      WHERE m.topic = replace(realtime.topic(), 'realtime:', '')
        AND m.user_id = auth.uid()

## rls-patterns

# CloudBase PG RLS Patterns

Use this reference when a CloudBase PostgreSQL app needs backend-side row permissions. Keep the policy model small and verify each operation from the app path.

## Principles

- UI hiding is not authorization.
- Browser/client access requires both table-level `GRANT` and row-level RLS Policy for business tables. Either layer can deny the request.
- RLS enabled with zero policies denies browser/client reads and writes.
- `UPDATE` usually needs both visibility of the existing row (`USING`) and a check on the new row (`WITH CHECK`).
- `serial` / `bigserial` primary keys require sequence grants such as `GRANT USAGE, SELECT ON SEQUENCE public.todos_id_seq TO authenticated;` before inserts work.
- A broad "logged-in users can access everything" rule is authentication, not authorization.
- Do not use privileged functions or definer-style bypasses to silence permission errors unless the task explicitly needs a trusted server/RPC boundary.
- The Web session is the source of truth for the app user. Use `auth.getSession()` in Web code and treat `session.user.id` as the candidate owner UID.
- In SQL policies, use CloudBase PG's official helpers: `auth.uid()` for JWT `sub`, `auth.role()` for `anon` / `authenticated` / `service_role`, `auth.jwt()` for full claims, and `auth.email()` when needed.
- **⚠️ `auth.uid()` returns `text`, not `uuid`.** Prefer `author_id` / `owner_id` as `varchar(64)` or `text`. If the column is already `uuid`, use `auth.uid()::uuid` (only when `sub` is a valid UUID); otherwise you get `operator does not exist: uuid = text`. This differs from Supabase.
- **⚠️ Do NOT use `current_user` or `current_setting(...)` in RLS policies.** `current_user` returns the database role name (e.g. `authenticated`), NOT the CloudBase auth user ID. Using `author_id = current_user` will never match any real user row.
- If unsure whether auth helpers are available, run `SELECT proname FROM pg_proc WHERE pronamespace = 'auth'::regnamespace` to list them.
- Do not use `auth.getUser()` as a route guard or owner UID source unless you have already confirmed it returns the same logged-in user as `getSession()`.

## Choose One Permission Boundary

For app CRUD, choose the smallest working boundary:

- **Database/RLS**: tables are accessed directly from browser `app.rdb()` and policies enforce row ownership.
- **Server/RPC**: browser calls a server function/RPC, and the server enforces admin/editor behavior before writing.

Do not half-implement both. If direct browser access is used, RLS/policies must be complete before testing.

## Admin/Editor Shape

Typical role table:

```sql
create table if not exists public.user_roles (
  uid text primary key,
  username text not null unique,
  role text not null check (role in ('admin', 'editor')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

Typical content table:

```sql
create table if not exists public.articles (
  _id uuid primary key default gen_random_uuid(),
  title text not null,
  author_id varchar(64) not null default auth.uid(),
  status text not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

For direct browser `app.rdb()` access, grant the intended role and then constrain rows with RLS. Minimal owner-based policy shape:

```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON public.articles TO authenticated;

ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;

CREATE POLICY articles_select_own ON public.articles
  FOR SELECT TO authenticated
  USING (author_id = auth.uid());

CREATE POLICY articles_insert_own ON public.articles
  FOR INSERT TO authenticated
  WITH CHECK (author_id = auth.uid());

CREATE POLICY articles_update_own ON public.articles
  FOR UPDATE TO authenticated
  USING (author_id = auth.uid())
  WITH CHECK (author_id = auth.uid());
```

`service_role` can bypass RLS, so never expose API Key / `service_role` credentials to browser code.

## Required Identity Probe

Before trusting policies that compare an owner column with `auth.uid()` or another DB-side helper:

1. In Web code, log in with the real username/password flow.
2. Call `auth.getSession()` and record `data.session.user.id`.
3. Insert a row through the same browser `app.rdb()` client without passing the owner column when the table has `DEFAULT auth.uid()`.
4. Read that row back with `queryPgDatabase` and verify the owner column equals `data.session.user.id`.
5. Attempt the same insert/update path as a second user if the app has admin/editor permissions.

If any browser `app.rdb()` operation fails, the RLS identity is not proven. Do not paper over it by catching the error and updating UI state. Either repair the RLS identity expression or move authorization to a server/RPC boundary.

Avoid self-referential role policies when possible. A policy on `public.user_roles` that queries `public.user_roles` again can recurse or behave differently across engines. Prefer one of these simpler patterns:

- Direct browser reads of roles with tightly scoped writes handled by setup/server code.
- A separate immutable role lookup object/function whose identity expression has already been verified.
- A server/RPC boundary for role-sensitive mutations.

## Verification Checklist

After creating policies, verify all required operations through the real app role:

- SELECT list/detail works for allowed rows.
- INSERT creates a row with the current user's owner column.
- UPDATE changes owned rows and does not reassign ownership unexpectedly.
- DELETE removes only allowed rows.
- Admin can operate across rows if the app requires admin behavior.

Then inspect schema/policies:

```text
queryPgDatabase(action="schema", objectName="public.articles")
queryPgDatabase(action="schema", objectName="public.user_roles")
```

If `rowLevelSecurityEnabled` is true and `policies` is empty, stop and create policies or disable RLS for that table before continuing.

## storage-pg

# CloudBase PG Storage

PG storage stores file metadata in PostgreSQL `storage` schema and enforces permissions through RLS.

> ⚠️ **PG 存储 ≠ 旧 COS 存储**：PG 环境的存储使用 pgstore + HTTP API，与旧 NoSQL 环境的 COS 存储是两套独立系统。以下情况请改用 `manageStorage`：非 PG 环境。

## Decision Tree: Which Storage to Use

```mermaid
flowchart TD
    A[当前环境是 PG 模式？] -->|是| B[使用 pgstore]
    A -->|否| C[使用旧 COS / NoSQL 存储]
    
    B --> B1{需要做什么？}
    B1 -->|创建 bucket| B2[INSERT INTO storage.buckets<br>或 HTTP API POST /v1/storages/bucket/]
    B1 -->|上传文件| B3[前端 SDK: app.storage.from().upload()<br>或 HTTP API]
    B1 -->|下载/签名| B4[HTTP API POST /v1/storages/object/sign/]
    B1 -->|查询文件| B5[HTTP API / storage.objects 表查询]
    B1 -->|配置权限| B6[ALTER TABLE storage.objects ENABLE RLS<br>CREATE POLICY ...]
    
    C --> C1{需要做什么？}
    C1 -->|上传/下载| C2[manageStorage / queryStorage 工具]
    C1 -->|查询| C3[queryStorage 工具]
```

**核心规则：**
- PG 环境 → 用 `queryPgStorage`（规划方案） +  HTTP API / 前端 SDK（执行）
- 旧 COS 环境 → 用 `manageStorage` / `queryStorage`（直接执行）

## Model

- `storage.buckets`: one row per bucket.
- `storage.objects`: one row per object.
- File bytes live in object storage, but metadata and permissions are coordinated through Storage API + PostgreSQL.
- `storage.buckets` / `storage.objects` are granted to `anon`, `authenticated`, and `service_role`; RLS is the effective permission gate.
- Traditional storage permission labels (`READONLY` / `PRIVATE` / `CUSTOM`) and JSON storage safe rules do not apply to PG storage.

## How Supabase Does Storage (Reference)

Supabase 和 CloudBase PG storage 的设计理念高度一致，可以对照理解：

| Concept | Supabase | CloudBase PG |
|---------|----------|-------------|
| **Schema** | `storage.buckets` / `storage.objects` | 相同（内置 pgstore schema） |
| **Anonymous access** | `anon` key (public, safe for client) | `anon` key（即 publishable key） |
| **Server access** | `service_role` key (secret, bypass RLS) | API Key（`manageAppAuth(action="createApiKey")`） |
| **User auth** | User JWT from `supabase.auth.signIn()` | User JWT from `auth.signInWithPassword()` 等 |
| **RLS** | `CREATE POLICY ... ON storage.objects` | 相同 |
| **Bucket creation** | `supabase.storage.createBucket()` | `INSERT INTO storage.buckets` 或 HTTP API |
| **Upload** | `supabase.storage.from('b').upload()` | `app.storage.from('b').upload()` |
| **Signed URL** | `createSignedUrl()` | HTTP API `POST /v1/storages/object/sign/` |

## JWT Token Acquisition for PG Storage API

PG Storage HTTP API 需要 Bearer JWT 认证。以下是三种角色对应的 token 获取方式：

### 1. service_role（服务端、旁路 RLS）

用于后端脚本、管理任务。对应 Supabase 的 `service_role` key。

```mermaid
flowchart LR
    A[manageAppAuth<br>action=createApiKey] -->|返回| B[API Key (token)]
    B --> C[Authorization: Bearer {token}]
    C --> D[调用 PG Storage HTTP API<br>旁路 RLS, 全权限]
```

**获取方式：**
```
manageAppAuth(action="createApiKey", name="my-server-key", description="服务端存储用")
```

返回的 `token` 就是 `service_role` 级别的凭据。

### 2. authenticated（已登录用户、受 RLS 约束）

用户通过前端登录后获取 JWT，用于浏览器端上传。

**前端登录：**
```js
// Web SDK
import { CloudBase } from '@cloudbase/js-sdk';
const app = CloudBase.init({ env: 'your-env-id' });
await app.auth.signInWithPassword({ username, password });
// 登录后 app 自动携带 JWT
await app.storage.from('covers').upload('a.png', file);
```

**手动获取 JWT token：**
```js
const token = await app.auth.getAuthHeader();
// token 形如 { 'x-cloudbase-uid': 'xxx', 'Authorization': 'Bearer xxx' }
```

### 3. anon（匿名、受 RLS 约束）

不需要携带 Authorization 头，或使用 anon key。只能访问 `public` bucket 且 RLS 放行的资源。

**获取 anon key（即 publishable key）：**
```
manageAppAuth(action="ensurePublishableKey")
```

返回的 `token` 即为 anon key，可安全暴露给客户端。

### Supabase 对照

```
Supabase                              CloudBase PG
────────────────────────────────────────────────────
Dashboard > Settings > API            manageAppAuth(action="createApiKey")
  → anon key (public)                   → publishable key (anon)
  → service_role key (secret)           → API Key (service_role)
supabase.auth.signIn()                 app.auth.signInWithPassword()
  → user JWT                             → user JWT
```

## Full HTTP API Reference

PG Storage 提供完整的 RESTful API，共 21 个端点，通过 OpenAPI 规范管理。

## troubleshooting

# CloudBase PG Troubleshooting

## `xxx.rdb is not a function`

Cause: installed CloudBase SDK is too old or the environment SDK surface does not expose PG.

Fix:

- Upgrade to the latest `@cloudbase/js-sdk` for Web.
- Re-check that the target environment is PG mode.

## DDL fails through ExecutePGSql / managePgDatabase

Facts:

- Execute one SQL statement per call.
- Some DDL (`CREATE`, `ALTER`, `DROP`, `GRANT`, `REVOKE`, `TRUNCATE`, `COMMENT`) may fail directly with transient `InternalError`.

Retry once with a `DO $$` wrapper and escape single quotes:

```sql
DO $$ BEGIN EXECUTE 'CREATE TABLE public.products (id serial PRIMARY KEY, name text)'; END $$;
```

Do not use this as a way to hide real syntax errors. If the wrapped SQL also fails, inspect the exact error and simplify.

## `MIGRATION_TASK_TIMEOUT` / `MIGRATION_TASK_PENDING` after applyMigration

Cause: `PushPGUserMigrations` is async. MCP polls `DescribeTaskResult` by default for up to **10 minutes** (CLI parity). Large DDL or lock waits can outlive the poll window, or the caller set `waitForTask=false`.

Fix:

1. Call `managePgDatabase(action=describeMigrationTask, taskId=...)` **first** for `Status` / `Phase` / `Reason`. `listMigrations` alone cannot explain a Failed task (that was the #857 blind spot).
2. Call `managePgDatabase(action=listMigrations)` and look for your `migrationVersion`.
3. If the version is present → treat as applied; do not re-push.
4. If Status is still non-terminal and version missing, wait and poll `describeMigrationTask` again. Do **not** immediately re-push the same version.
5. Only after the task is terminal (`Succeed`/`Failed`) and list confirms the version never landed, fix SQL/Conflicts and retry with a **new** version, or use `taskPollTimeoutMs` / CLI `tcb db pg migration up` for longer waits.
6. Optional: `waitForTask=false` returns `MIGRATION_TASK_PENDING` immediately with TaskId — still must `describeMigrationTask` then `listMigrations` before any retry.

## Local file missing / checksum mismatch vs remote history

Cause: Agent applied without Git truth, cloned a repo without `cloudbase/migrations/`, or local SQL drifted from remote `Query` (Executable=false / `checksum_mismatch`).

Fix:

1. Prefer `managePgDatabase(action=fetchMigration)` to pull remote history into `cloudbase/migrations/` (same as CLI `tcb db pg migration fetch`).
2. If local files already exist but are wrong, re-run with `force=true` to overwrite from remote — do **not** hand-edit an already-applied version and re-push the same `migrationVersion`.
3. For new schema changes after fetch, always create a **new** `migrationVersion` newer than `LatestVersion`.

## `MIGRATION_NOT_EXECUTABLE` / `local_migration_before_latest_remote`

Cause: pending `migrationVersion` is older than remote `LatestVersion` (out-of-order), or checksum mismatch / other Preview Conflicts. Push is blocked.

Fix:

1. Default: pick a new 14-digit version strictly greater than `LatestVersion` from `listMigrations`.
2. Only when you intentionally need out-of-order apply (branch merge / backfill): retry `planMigration` / `applyMigration` with `includeAll=true` (CLI `tcb db pg migration up --include-all`).
3. For `checksum_mismatch`, fetch/realign local SQL — do not force includeAll.

## `ERROR: operator does not exist: uuid = text` (or `uid = text`) when creating RLS

Cause: CloudBase `auth.uid()` returns **`text`**, not `uuid` (unlike Supabase). Comparing `auth.uid()` to a `uuid` column has no matching operator.

Fix:

1. **Preferred**: define owner columns as `varchar(64)` or `text` so they match `auth.uid()` directly:
   ```sql
   author_id varchar(64) not null default auth.uid()
   -- ...
   USING (author_id = auth.uid())
   ```
2. **If the column must stay `uuid`**: cast the helper (only when JWT `sub` is a valid UUID):
   ```sql
   USING (author_id = auth.uid()::uuid)
   WITH CHECK (author_id = auth.uid()::uuid)
   ```
3. Do **not** use `uuid` owner columns when identity may be WeChat `openid` or another non-UUID string — keep those columns as `text` / `varchar`.

## Permissions pass in MCP but fail in browser

Likely cause: admin/default execution bypassed user-facing role checks.

Fix:

- Verify table `GRANT` exists for `anon` or `authenticated`.
- Verify RLS policies exist and include both `USING` and `WITH CHECK` when needed.
- If the tool/API supports role simulation, execute checks as `authenticated` or `anon`.
- Test through the real `app.rdb()` browser flow with `auth.getSession()`.

## Insert with serial/bigserial fails

Cause: missing sequence grant.

```sql
GRANT USAGE, SELECT ON SEQUENCE public.todos_id_seq TO authenticated;
```

## Mini Program PG gateway error

If a mini program reports `Generating default gateway base url failed: env not found`, the base library may be too old for CloudBase PostgreSQL.

Fix: use WeChat base library `3.8.9` or later and confirm the environment is PG mode.

## Storage upload returns `STORAGE_PERMISSION_DENIED`

Cause: bucket exists but `storage.objects` RLS denies the request.

Fix: read `storage-pg.md`, configure bucket-specific policies, and retry the same SDK upload path.

## Existing app on CloudRun cannot connect to PostgreSQL (TCP)

Symptoms: deploy succeeds, but the container logs `ECONNREFUSED`, connection timeout, or "could not connect to server" when using `DATABASE_URL` / `postgres://` / `pg` drivers.

Cause: classic TCP clients need the CloudRun instances to join the database VPC. CloudBase PG SDK/gateway (`app.rdb()`, HTTP REST) is a different path and is **not** a drop-in for most GitHub apps.

Fix:

0. **First check the PG instance tier — this decides whether the TCP path is even available.** Read `queryEnv(action="info")` → `EnvInfo.PostgreSQL[].TenantType`. CloudBase PG ships as **shared (共享)** and **dedicated (独享)** instances, and only **dedicated** instances expose a TCP-reachable endpoint (the private host). A shared instance is reachable through the SDK / gateway only, so **no `VpcConf` configuration will ever make a TCP client connect to it** — the connection fails with `ECONNREFUSED` / timeout and the platform reports 资源检查失败 on network queries. If the app is a TCP client and the instance is shared, say so plainly: the instance must be **upgraded to dedicated** first — the upgrade path is a ready recipe: `../../cloud-api-operations/references/recipes/pg-instance-spec.md` (Recipe 3); use `TenantType` to pick the branch (`SHARED` → upgrade-to-dedicated via `UpgradePGInstanceToDedicated`, `DEDICATED` → spec change) and poll the returned `TaskId`. The recipe's upgrade-to-dedicated branch has been run end to end (standard-tier environment → `1 core 2 GiB` + 10 GB, ~2m49s to `Succeed`); the recipe as a whole is still marked partially verified because its other branches are untested — check its prerequisites before running. Alternatively the app can be reworked onto the SDK path (`app.rdb()`). Do **not** ask the user (or their networking team) for VPC ID / subnet ID — the VPC and subnet come from the database instance's own detail, and hunting for them sends the user down a path that cannot work.
1. Confirm whether the app is a **TCP client** (ORM / `DATABASE_URL`) or a **CloudBase PG SDK** client (`app.rdb()`).
2. For TCP clients **on a dedicated instance**: redeploy with `serverConfig.VpcConf` pointing at the same region/VPC as the database, and use the **private** DB host. See `../cloudrun-development/references/vpc-and-database.md`.

## rule

---
name: postgresql-development-cloudbase
description: "Use when building, debugging, or evaluating CloudBase PostgreSQL / CloudBase PG / PG mode apps, including Postgres schema setup, queryPgDatabase/managePgDatabase, JS SDK v3 app.rdb() CRUD/RPC, PG HTTP API fallback, RLS-style permissions, username-password auth, and Web CMS/admin CRUD flows backed by CloudBase PG."
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

# CloudBase PostgreSQL Development

## Activation Contract

### Use this first when

- The task says CloudBase PG, PostgreSQL, Postgres, PG mode, RLS, JS SDK v3 PostgreSQL, `app.rdb()`, `queryPgDatabase`, or `managePgDatabase`.
- A Web app or CMS must persist business data in CloudBase PostgreSQL instead of NoSQL or MySQL.

### Then also read

- Access-pattern design or slow-query work -> `../postgresql-best-practices-cloudbase/SKILL.md`
- Web auth provider readiness -> `../auth-tool-cloudbase/SKILL.md`
- Web login implementation -> `../auth-web-cloudbase/SKILL.md`
- General Web implementation and verification -> `../web-development/SKILL.md`
- Browser storage upload -> `../cloud-storage-web/SKILL.md`
- Raw HTTP API details only when SDK coverage is blocked -> `../http-api-cloudbase/SKILL.md`
- PG reference index -> `references/index.md`
- PG mode overview -> `references/pg-mode-overview.md`
- Auth / GRANT / RLS details -> `references/auth-and-rls.md`
- End-to-end PG app closure -> `references/app-workflow.md`
- PG storage details — **MUST read before writing any bucket / upload / URL code** -> `references/storage-pg.md`
- HTTP API fallback -> `references/http-api.md`
- Troubleshooting -> `references/troubleshooting.md`

### Do NOT use first

- `relational-database-mcp-cloudbase` / `queryMysqlDatabase` / `manageMysqlDatabase`: those are MySQL-oriented.
- `cloudbase-document-database-web-sdk` / collection APIs for business data that must live in CloudBase PG.

## Required Flow

### 🚨 CRITICAL: PG mode API is NOT the same as NoSQL

CloudBase PG (`app.rdb()`, `app.storage.from('bucket')`) uses **different API method names** than CloudBase NoSQL (`app.database()`, `app.uploadFile()`). Low-capability models often paste legacy NoSQL/auth snippets from training; reject that path immediately. If this task is PG-backed, **do not** write `app.database()`, `db.collection(...)`, `app.uploadFile()`, `getLoginState()`, or route guards based on `auth.getUser()`. Use `app.rdb()`, PG storage v3, and `auth.getSession()` instead. If you are used to writing `.where()`, `.orderBy()`, `.count()` from other ORMs or NoSQL — **stop and read the table below**.

| ❌ Do NOT use these (NoSQL / ORM habits) | ✅ Use these in PG mode |
|------------------------------------------|------------------------|
| `.where({ field: value })` | `.match({ field: value })` or `.eq("field", value)` |
| `.where("field", "ilike", "%v%")` | `.ilike("field", "%v%")` |
| `.orderBy("field", { ascending: false })` | `.order("field", { ascending: false })` |
| `.count()` | `.select("*", { count: "exact" })` — count is in response |
| `.offset(n)` | `.range(from, to)` |
| `app.uploadFile()` (legacy NoSQL upload) | `app.storage.from('bucket').upload(key, file)` |
| `app.getTempFileURL()` (legacy NoSQL URL) | `app.storage.from('bucket').createSignedUrl(key, expiresIn)` |
| `app.storage.from()` (no bucket name) | `app.storage.from('bucket')` — **must** pass bucket name |

**If you find yourself typing `.where()` or `.orderBy()` or `.count()` — stop and use the correct method from the right column.**

0. **First, confirm this environment actually has PostgreSQL provisioned.** Call `queryEnv(action="info", envId=...)` and read the derived `EnvInfo.RuntimeBackends` block (`{ postgresql, nosql, mysql }`) along with `EnvInfo.RuntimeMode`. It is only safe to apply this skill's PG-specific guidance when `RuntimeBackends.postgresql === true` (equivalently, `EnvInfo.PostgreSQL` is non-empty AND/OR `EnvInfo.Meta` contains `postgresql=enable`).
   - PG mode is a **new-environment mode** selected when creating a CloudBase environment with PostgreSQL. Do not try to "upgrade" a legacy environment in place; create/select a PG-mode environment instead.
   - If `RuntimeBackends.postgresql === false`, STOP — this is a legacy NoSQL-only env: switch to `cloudbase-document-database-web-sdk` for browser data and `cloud-storage-web` (with `app.uploadFile()`) for uploads. Do not write `app.rdb()` code, do not enable RLS, do not create a pgstore bucket here.
   - If both `postgresql` and `nosql` are `true` (the common case in a PG environment), they coexist. Apply this skill to NEW business data the task asks you to put in PG (e.g. articles / role tables explicitly described as PG). Existing NoSQL collections, the bucket reported in `EnvInfo.Storages[]`, and any `managePermissions(resourceType="noSqlDatabase")` rules continue to govern the legacy NoSQL data — do NOT migrate or rewrite them unless the task explicitly asks.
   - `RuntimeBackends.mysql === false` is the only hard "do not use" signal: when MySQL is absent, do not use `manageMysqlDatabase` / `queryMysqlDatabase` and do not consult the `relational-database-mcp-cloudbase` skill; those are MySQL-specific and have nothing to do with CloudBase PG.
   - Note: in a PG env, `EnvInfo.Storages[]` is the legacy NoSQL bucket. It still works for legacy `app.uploadFile()` flows but is NOT a usable pgstore bucket — never reuse it as the `<bucket>` segment in `app.storage.from('<bucket>').upload('<key>', file)`.

> **Creating a PG-mode environment**
>
> If step 0 shows `RuntimeBackends.postgresql === false` and you need PostgreSQL, create a new environment with PG enabled:
>
> - **Via MCP**: `manageEnv(action="create", alias="my-env", packageId="baas_personal", resources=["storage","function","postgresql"], confirm="yes")` — optional `region` (e.g. `region="ap-shanghai"`) selects where the environment is created; it works as the `X-TC-Region` request context, so do **not** put `Region` into the request body. Omit it to use the current session region (site default: `ap-shanghai` domestic, `ap-singapore` intl); if you pass it, repeat it on the confirming call.
> - **Via CLI**: `tcb env create --alias my-env --package baas_personal --postgresql --region ap-shanghai --yes`
> - **Via Console**: [Create environment](https://console.cloud.tencent.com/tcb/env/create)

1. Inspect the existing app surfaces first: `src/lib/backend.*`, `src/lib/auth.*`, `src/lib/*service.*`, route guards, and the handlers bound to existing forms.
2. Check PG state through MCP: use `queryPgDatabase` for schema/read-only inspection and `managePgDatabase` for DDL/DML. Do not switch to MySQL tools. For the complete route map, read `references/index.md`.
3. **Understand PG roles before writing code:** Publishable Key maps to `anon`; a logged-in user's access token maps to `authenticated`; API Key maps to `service_role` and bypasses RLS. Never expose API Key / `service_role` credentials in frontend code. See `references/auth-and-rls.md`.
4. **Use schema management (`managePgDatabase`) before writing CRUD code.** Schema DDL (CREATE / ALTER / DROP / TRUNCATE) **must** go through the versioned migration workflow — never default to `execute` for table creation. Then apply GRANT + RLS (via `execute` or the same migration SQL bundle) before browser access. The minimum SQL bundle is: `CREATE TABLE`, `GRANT SELECT/INSERT/UPDATE/DELETE TO authenticated`, `GRANT USAGE, SELECT ON SEQUENCE ... TO authenticated` when using `serial`/`bigserial`, `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`, and `CREATE POLICY ... USING / WITH CHECK`. See `references/auth-and-rls.md` for the full template.

   **Default schema-change workflow (local file first, then remote history):**
   1. Choose `migrationVersion` = 14-digit UTC timestamp `YYYYMMDDHHMMSS` and `migrationName` = snake_case (e.g. `add_users`).
   2. Write local file `cloudbase/migrations/<migrationVersion>_<migrationName>.sql` with the DDL (and optional rollback SQL in comments or a paired file). This path **must** match CloudBase CLI `MIGRATIONS_DIR` (`tcb db pg migration *`). If an older workspace still has root `migrations/`, move those files into `cloudbase/migrations/` before mixed MCP+CLI use.
   3. Optional preview: `managePgDatabase(action=planMigration, migrationName=..., migrationVersion=..., sql=...)`.
   4. Apply: `managePgDatabase(action=applyMigration, migrationName=..., migrationVersion=..., sql=..., confirm=true)` — reuse the **same** version/name as the local file. If the local file is missing, MCP auto-writes `cloudbase/migrations/<version>_<name>.sql`; if an existing file's content differs from `sql`, apply fails closed (`LOCAL_MIGRATION_FILE_MISMATCH`) and does not Push. MCP waits for the async task by default (up to **10 minutes**, same as CLI); override with `taskPollTimeoutMs` or set `waitForTask=false` if the host tool-call timeout is short.
   5. Verify: `managePgDatabase(action=listMigrations)` and confirm the remote history records the same `migrationVersion`.
   6. Then write frontend CRUD / RLS checks.

   **Out-of-order / backfill versions:** Prefer a `migrationVersion` strictly newer than `LatestVersion`. If you must apply a version older than Latest (branch merge / cherry-pick), pass `includeAll=true` on `planMigration` / `applyMigration` — same as CLI `tcb db pg migration up --include-all`. Do not use this for routine work.

   **If applyMigration returns `MIGRATION_TASK_TIMEOUT` or `MIGRATION_TASK_PENDING`:** the task may still be running (large DDL / lock waits). Call `describeMigrationTask(taskId=...)` **first** for Status/Phase/Reason, then `listMigrations`. Do **not** re-push the same `migrationVersion`, and do **not** fall back to `execute` until the task is terminal and list confirms the version never landed.

   Other migration actions:
   - `managePgDatabase(action=migrationDetail, migrationVersion=...)` — inspect a single migration
   - `managePgDatabase(action=fetchMigration)` — pull remote history SQL into `cloudbase/migrations/` (CLI `tcb db pg migration fetch` parity). Optional `migrationVersion` for one file; omit for full history. Existing local files are skipped unless `force=true` (overwrite / checksum realign). Prefer this over hand-copying SQL from `migrationDetail` to avoid checksum drift.
   - `managePgDatabase(action=repairMigration, migrationVersion=..., migrationName=..., repairStatus=..., repairReason=...)` — repair history records

   **`execute` is for DML and ops SQL, not default DDL:** use `managePgDatabase(action=execute, confirm=true)` for `INSERT` / `UPDATE` / `DELETE`, and for `GRANT` / `CREATE POLICY` / storage RLS when those are not part of a migration. If you attempt schema DDL via `execute`, the tool soft-blocks with `DDL_USE_APPLY_MIGRATION` unless you explicitly set `allowDdlViaExecute=true` (escape hatch only).

   **🚨 CRITICAL: Inspect table existence and column names before CREATE TABLE.** `CREATE TABLE IF NOT EXISTS` silently skips when the table already exists, even if the column names are wrong. Always call `queryPgDatabase(action="sql", sql="SELECT column_name, data_type FROM information_schema.columns WHERE table_name='xxx'")` first to check whether the table exists and what exact column names it uses. If the table already exists with mismatched column names (e.g. `user_id` instead of `uid`), you must either:
   - `ALTER TABLE` to add/rename/drop columns (via `applyMigration` with a new version), or
   - `DROP TABLE IF EXISTS ... CASCADE` and recreate via `applyMigration` (only when data loss is acceptable, e.g. disposable/evaluation environments).
   - Do NOT rely on `CREATE TABLE IF NOT EXISTS` silent skip — it will cause all downstream CRUD queries to fail with wrong field names.
   - After DDL, re-query the schema and compare every column name used by frontend code, insert/update payloads, filters, ordering, and RLS policies.
5. Check username-password auth before coding login:
   - Call `queryAppAuth(action="getLoginConfig")`.
   - If `loginMethods.usernamePassword !== true`, call `manageAppAuth(action="patchLoginStrategy", patch={ usernamePassword: true })`.
   - In Web login code, use `auth.signInWithPassword({ username, password })` for plain usernames like `admin` or `editor`.
   - Do not assume `auth.signUp({ username, password })` can directly create username/password users. Confirm `queryAppAuth` `sdkHints` and the installed `@cloudbase/js-sdk` behavior first; if direct username signup is unsupported, implement registration through a backend/management boundary instead of exposing secret keys in the browser.
6. Implement Web auth state with `auth.getSession()` before writing CRUD:
   - Route guards must check `data.session`, not `auth.getUser()` and not deprecated `getLoginState()`.
   - Treat login as successful only when `signInWithPassword(...)` returns no `error` and includes `data.session`.
   - Get the UID for `author_id` / role rows from `data.session.user.id` (fall back to `sub`/`uid` only after inspecting the actual session object).
   - Do not use `auth.getUser()` as proof of login; it can return a non-null wrapper or anonymous-looking user data when there is no real username/password session.
7. Implement browser-side business data with the CloudBase JS SDK v3 PostgreSQL API first: `app.rdb().from(table)`. Use the latest `@cloudbase/js-sdk` when `app.rdb` is missing (`xxx.rdb is not a function` means the SDK is too old).
8. Do not manually fetch a CloudBase Auth bearer token from browser code for PG CRUD. In particular, do not call non-canonical helpers such as `currentUser.getIdToken()` unless you have verified that exact method exists in the installed SDK. Prefer `app.rdb()` so the SDK carries the active session.
9. Use the official CloudBase PG SQL auth helpers in policies: `auth.uid()` for JWT `sub`, `auth.role()` for `anon` / `authenticated` / `service_role`, `auth.jwt()` for full claims, and `auth.email()` when email is needed. Still verify the policy through the real app session before claiming it works:

## app-workflow

# CloudBase PG App Workflow

Use this reference when building or repairing a real user-facing Web app backed by CloudBase PostgreSQL. The goal is a working product flow, not broad platform exploration. In scaffold/TODO apps, favor vertical closure over repo inventory.

## Closure Path

1. Inspect the active app code first:
   - `src/lib/backend.*`
   - `src/lib/auth.*`
   - `src/lib/*service.*`
   - route guards
   - form submit handlers
   - Open these files directly. Do not begin with generic repo inventory, delegated exploration, or a repo-wide file list.
2. If those files still contain TODOs, implement them in place before optional platform research or helper creation.
3. Confirm the environment has the required capabilities:
   - username/password auth if the app logs in with plain usernames
   - PostgreSQL resource
   - Cloud Storage if the app uploads files. In CloudBase PG, "having storage" means having an explicitly-created `pgstore` bucket — same model as Supabase Storage. Check existing buckets with `queryPgStorage(action="buckets")`. If the upload target (e.g. `covers`) is missing, create/select the bucket through the documented CloudBase management surface or console before writing browser upload code. Browser SDKs cannot create a pgstore bucket; the legacy NoSQL bucket reported in `EnvInfo.Storages[]` is NOT a valid pgstore target.
4. Create or repair the minimal PG schema via the migration workflow (not bare `execute` for DDL):
   - Choose `migrationVersion` (`YYYYMMDDHHMMSS`) + `migrationName`, write `migrations/<version>_<name>.sql`, then `managePgDatabase(action="applyMigration", migrationName, migrationVersion, sql, confirm=true)`.
   - Apply required `GRANT` statements, sequence grants for `serial`/`bigserial`, `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`, and RLS policies (same migration SQL or follow-up `execute` for ops-only GRANT/POLICY).
5. Immediately call `queryPgDatabase(action="objects")`, then `queryPgDatabase(action="schema", objectName="public.<table>")` for every table touched by the app.
6. Implement browser CRUD with one shared CloudBase Web SDK app instance and `app.rdb()`.
7. Implement auth guards and owner UID lookup with `auth.getSession()`, not `auth.getUser()`.
8. If direct browser `app.rdb()` uses RLS, verify the policy identity through the real browser session before depending on it.
9. Implement browser uploads with the documented CloudBase Storage Web SDK surface. The bucket from step 3 must exist BEFORE this step runs; pass the bucket to `from(bucket)` and pass only the object key to `upload(key, file)` (e.g. `app.storage.from("covers").upload("<file>", file)`). Do not repeat the bucket prefix inside the key.
10. Run the local build/typecheck.
11. Exercise the actual browser flow: login, create, list, edit/delete if required.
12. Read back persisted rows with `queryPgDatabase` before claiming done.

## Minimum Schema Pattern

For CMS/admin-style apps, prefer a small explicit schema:

```sql
create table if not exists public.user_roles (
  uid text primary key,
  username text not null unique,
  role text not null check (role in ('admin', 'editor')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.articles (
  _id uuid primary key default gen_random_uuid(),
  title text not null,
  summary text,
  cover_image text,
  content text,
  status text not null default 'draft' check (status in ('draft', 'published')),
  author_id varchar(64) not null default auth.uid(),
  author_name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

Then grant the user-facing role and create policies before browser CRUD:

```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON public.articles TO authenticated;
GRANT SELECT ON public.user_roles TO authenticated;
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;
CREATE POLICY articles_owner_all ON public.articles
  FOR ALL TO authenticated
  USING (author_id = auth.uid())
  WITH CHECK (author_id = auth.uid());
```

If a table uses `serial` / `bigserial`, also grant its sequence: `GRANT USAGE, SELECT ON SEQUENCE public.<table>_<column>_seq TO authenticated;`.

If the environment is disposable or the task requires a known schema, prefer an explicit `drop table if exists ... cascade` followed by `create table`. Do not rely on `create table if not exists` to fix incompatible old columns.

## Browser Data Access

Use one shared app:

```ts
import cloudbase from "@cloudbase/js-sdk";

export const app = cloudbase.init({ env: import.meta.env.VITE_ENV_ID });
export const auth = app.auth;
export const db = app.rdb();
```

Use the session as the single source of truth for login state and current UID:

```ts
async function getActiveSession() {
  const { data, error } = await auth.getSession();
  const session = data?.session;
  if (error || !session || session.user?.is_anonymous) return null;
  return session;
}

export async function checkAuth() {
  return Boolean(await getActiveSession());
}

export async function getCurrentUser() {
  const session = await getActiveSession();
  const user = session?.user;
  if (!user) return null;

  const uid = user.id || user.sub || user.uid;
  if (!uid) return null;

  return {
    uid,
    displayName:
      user.user_metadata?.username ||
      user.username ||
      user.email ||
      uid,
  };
}
```

Do not use `auth.getUser()` as a route guard. A non-null `data` wrapper is not proof of a real username/password login. Login is successful only when `signInWithPassword(...)` returns no `error` and includes `data.session`.


## auth-and-rls

# CloudBase PG Auth And RLS

Use this reference before writing browser-side PG CRUD or database policies.

## Key / role mapping

| Credential | Database role | Where it can live | Notes |
| --- | --- | --- | --- |
| Publishable Key | `anon` | Frontend-safe | Still constrained by GRANT/RLS. |
| User access token | `authenticated` | SDK-managed frontend session | Represents a real logged-in user. |
| API Key | `service_role` | Backend / trusted tooling only | Bypasses RLS; never expose to browser code. Treat any leak as a serious credential compromise and rotate/revoke it via `manageAppAuth(action="deleteApiKey")` immediately. |

## `auth.users` — the built-in account table

CloudBase PG stores account data in `auth.users` (schema `auth`), not a business-defined table. Query it directly instead of creating a parallel `public.users` table for identity data:

```sql
select id, email, phone, app_metadata, user_metadata from auth.users;

-- Join business tables against the built-in account table
select o.*, u.user_metadata->>'name' as buyer_name
from public.orders o
join auth.users u on u.id = o.buyer_id;
```

Only create a separate `public.*` table (e.g. `user_roles`, `profiles`) when the app needs fields that do not belong in `auth.users`, such as an app-specific role or a denormalized display name for fast reads. Do not duplicate `email`/`phone` into a new table just to avoid a join.

## SQL identity helpers

CloudBase PG provides official SQL helpers:

```sql
select auth.uid();   -- JWT sub / user id
select auth.role();  -- anon / authenticated / service_role
select auth.jwt();   -- full JWT claims as jsonb
select auth.email(); -- current email if available
```

**⚠️ CRITICAL: Always use `auth.uid()` for user identity in RLS policies.** Do NOT use `current_user` or `current_setting(...)` — these are PostgreSQL built-in functions that return the database role name (e.g. `authenticated`), not the CloudBase auth user ID. Using `current_user` in a policy like `USING (author_id = current_user)` will never match any real user ID.

If you are unsure whether the auth helper functions are available in your environment, run:
```sql
SELECT proname FROM pg_proc WHERE pronamespace = 'auth'::regnamespace;
```
This returns the list of available `auth.*` functions (e.g. `uid`, `role`, `jwt`, `email`).

Prefer database-owned identity fields:

```sql
create table public.todos (
  id bigserial primary key,
  title text not null,
  owner_id varchar(64) not null default auth.uid(),
  created_at timestamptz not null default now()
);
```

Frontend insert payloads should omit `owner_id` / `author_id` when the column has `DEFAULT auth.uid()`.

## Minimum GRANT + RLS sequence

Business tables require two layers: table-level GRANT and row-level RLS. Both must pass.

```sql
create table public.todos (
  id bigserial primary key,
  title text not null,
  is_completed boolean not null default false,
  owner_id varchar(64) not null default auth.uid(),
  created_at timestamptz not null default now()
);

create index idx_todos_owner_id on public.todos(owner_id);

-- Table permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.todos TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE public.todos_id_seq TO authenticated;
GRANT ALL ON public.todos TO service_role;
GRANT USAGE, SELECT ON SEQUENCE public.todos_id_seq TO service_role;

-- Row permissions
ALTER TABLE public.todos ENABLE ROW LEVEL SECURITY;

CREATE POLICY todos_select_own ON public.todos
  FOR SELECT TO authenticated
  USING (owner_id = auth.uid());

CREATE POLICY todos_insert_own ON public.todos
  FOR INSERT TO authenticated
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY todos_update_own ON public.todos
  FOR UPDATE TO authenticated
  USING (owner_id = auth.uid())
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY todos_delete_own ON public.todos
  FOR DELETE TO authenticated
  USING (owner_id = auth.uid());
```

## Accessing PG from a cloud function

A cloud function has two distinct ways to reach PG, and they are NOT interchangeable. Choose based on whether the function should act as the logged-in caller or as an admin/backend task:

1. **Act as the caller, stay RLS-constrained** — when a function wraps business logic but must still respect row ownership (e.g. an HTTP Function that a logged-in user calls to run a multi-step update). The caller's access token must reach the function and then be forwarded to the PG REST call:

   ```js
   const res = await fetch(`https://${envId}.api.tcloudbasegateway.com/v1/rdb/rest/orders?select=*`, {
     headers: { Authorization: `Bearer ${callerAccessToken}` },
   });
   ```

   Do not guess the exact field/property that carries `callerAccessToken` from `event`/`context` (or an HTTP Function's `req.headers`). Verify it against the installed `@cloudbase/node-sdk` version and the official cloud-functions docs before writing this code; if you cannot verify the field, treat this pattern as unavailable rather than inventing a shape.

2. **Act as admin, bypass RLS with the API Key (`service_role`)** — use this only for admin/backend tasks such as batch imports, cross-user aggregation, or scheduled jobs, and only inside a cloud function / CloudRun service:

   ```js
   // Inject the API Key via function environment variables; never return it to the client.
   const res = await fetch(`https://${envId}.api.tcloudbasegateway.com/v1/rdb/rest/orders?select=*`, {

## http-api

# CloudBase PG HTTP API

Use the HTTP API only when the SDK path is blocked or the caller is a non-SDK client.

## Base endpoints

```text
REST: https://<envId>.api.tcloudbasegateway.com/v1/rdb/rest/<table>
Auth: https://<envId>.api.tcloudbasegateway.com/auth/v1
```

Schema-qualified forms may also be available depending on the target database shape:

```text
/v1/rdb/rest/<schema>/<table>
/v1/rdb/rest/<instance>/<schema>/<table>
```

## Auth header

```http
Authorization: Bearer <Publishable Key | access_token | API Key>
```

- Publishable Key maps to `anon`.
- User access token maps to `authenticated`.
- API Key maps to `service_role` and must never be exposed in browser code.

## Query examples

```bash
curl "https://<envId>.api.tcloudbasegateway.com/v1/rdb/rest/todos?select=*&is_completed=eq.false" \
  -H "Authorization: Bearer <access_token>"
```

```bash
curl -X POST "https://<envId>.api.tcloudbasegateway.com/v1/rdb/rest/todos" \
  -H "Authorization: Bearer <access_token>" \
  -H "Prefer: return=representation" \
  -H "Content-Type: application/json" \
  -d '{"title":"写一篇文档"}'
```

Do not send `_openid` for PG tables. Use owner columns with `DEFAULT auth.uid()` / JWT `sub`.

## PostgREST query syntax

- equality: `?status=eq.published`
- range: `?price=gte.100&price=lte.500`
- like: `?name=like.*CloudBase*`
- in: `?status=in.(draft,published)`
- order: `?order=created_at.desc`
- pagination: `?limit=20&offset=0`
- columns: `?select=id,title,created_at`

If the endpoint shape is uncertain, query OpenAPI docs with `searchKnowledgeBase(mode="openapi", apiName="mysqldb", query="PostgreSQL ...")` instead of guessing paths.

## index

# CloudBase PG Reference Index

Use this index after `postgresql-development/SKILL.md` identifies the task as CloudBase PostgreSQL / CloudBase PG / PG mode.

## Read order

1. `pg-mode-overview.md` — environment shape, schemas, roles, and when PG mode applies.
2. `auth-and-rls.md` — JWT identity, `auth.uid()` / `auth.role()` / `auth.jwt()`, GRANT + RLS templates, and `service_role` risks.
3. `app-workflow.md` — end-to-end Web/CMS implementation workflow.
4. `storage-pg.md` — PG storage bucket/object model, `app.storage.from('bucket')`, and storage RLS.
5. `http-api.md` — PostgREST `/v1/rdb/rest/...` fallback and auth headers.
6. `troubleshooting.md` — SDK version, DDL wrapping, role simulation, mini program base-library issues.

## Routing reminders

- PG business data uses `app.rdb().from(...)`, `queryPgDatabase`, and `managePgDatabase`.
- Do not route PG work to NoSQL `app.database()` / `db.collection(...)` or MySQL `queryMysqlDatabase` / `manageMysqlDatabase`.
- Browser code must never contain API Key / `service_role` credentials.
- For owner fields, prefer database defaults such as `DEFAULT auth.uid()` and omit the owner field from frontend insert payloads.

## pg-mode-overview

# CloudBase PG Mode Overview

CloudBase PG mode is a Postgres-Native environment mode. It is not simply "adding a PostgreSQL instance" to a legacy environment.

## Environment facts

- PG mode is selected when creating a new CloudBase environment with PostgreSQL.
- Legacy environments cannot be upgraded in place to PG mode. If `RuntimeBackends.postgresql !== true`, use the matching legacy NoSQL/MySQL skill or create/select a PG-mode environment.
- In PG mode, PostgreSQL is the unified runtime for:
  - `public` schema: business tables.
  - `auth` schema: user data and JWT identity.
  - `storage` schema: bucket/object metadata.
- PG and NoSQL can coexist. Existing NoSQL collections keep using NoSQL APIs; new business data explicitly requested in PG should use PG APIs.

## Core access paths

- Web / frontend SDK: `app.rdb().from('<table>')`.
- MCP management: `queryPgDatabase` / `managePgDatabase`.
- REST fallback: PostgREST-compatible `/v1/rdb/rest/<table>`.
- Storage: `app.storage.from('<bucket>').upload('<key>', file)` against a PG storage bucket.

## Role and schema vocabulary

- `anon`: requests backed by Publishable Key / anonymous identity.
- `authenticated`: requests backed by a logged-in user's access token.
- `service_role`: API Key / privileged service role; bypasses RLS and must stay server-side only.
- `auth.uid()`: current JWT `sub`.
- `auth.role()`: current database role.
- `auth.jwt()`: full JWT claims.
- `auth.email()`: current user email when available.

## Common fit

Prefer PG mode for structured relational data, joins, transactions, row-level permission modeling, `pgvector` / SQL extensions, and apps that benefit from PostgREST and SQL-native authorization.

## rls-patterns

# CloudBase PG RLS Patterns

Use this reference when a CloudBase PostgreSQL app needs backend-side row permissions. Keep the policy model small and verify each operation from the app path.

## Principles

- UI hiding is not authorization.
- Browser/client access requires both table-level `GRANT` and row-level RLS Policy for business tables. Either layer can deny the request.
- RLS enabled with zero policies denies browser/client reads and writes.
- `UPDATE` usually needs both visibility of the existing row (`USING`) and a check on the new row (`WITH CHECK`).
- `serial` / `bigserial` primary keys require sequence grants such as `GRANT USAGE, SELECT ON SEQUENCE public.todos_id_seq TO authenticated;` before inserts work.
- A broad "logged-in users can access everything" rule is authentication, not authorization.
- Do not use privileged functions or definer-style bypasses to silence permission errors unless the task explicitly needs a trusted server/RPC boundary.
- The Web session is the source of truth for the app user. Use `auth.getSession()` in Web code and treat `session.user.id` as the candidate owner UID.
- In SQL policies, use CloudBase PG's official helpers: `auth.uid()` for JWT `sub`, `auth.role()` for `anon` / `authenticated` / `service_role`, `auth.jwt()` for full claims, and `auth.email()` when needed.
- **⚠️ Do NOT use `current_user` or `current_setting(...)` in RLS policies.** `current_user` returns the database role name (e.g. `authenticated`), NOT the CloudBase auth user ID. Using `author_id = current_user` will never match any real user row.
- If unsure whether auth helpers are available, run `SELECT proname FROM pg_proc WHERE pronamespace = 'auth'::regnamespace` to list them.
- Do not use `auth.getUser()` as a route guard or owner UID source unless you have already confirmed it returns the same logged-in user as `getSession()`.

## Choose One Permission Boundary

For app CRUD, choose the smallest working boundary:

- **Database/RLS**: tables are accessed directly from browser `app.rdb()` and policies enforce row ownership.
- **Server/RPC**: browser calls a server function/RPC, and the server enforces admin/editor behavior before writing.

Do not half-implement both. If direct browser access is used, RLS/policies must be complete before testing.

## Admin/Editor Shape

Typical role table:

```sql
create table if not exists public.user_roles (
  uid text primary key,
  username text not null unique,
  role text not null check (role in ('admin', 'editor')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

Typical content table:

```sql
create table if not exists public.articles (
  _id uuid primary key default gen_random_uuid(),
  title text not null,
  author_id varchar(64) not null default auth.uid(),
  status text not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

For direct browser `app.rdb()` access, grant the intended role and then constrain rows with RLS. Minimal owner-based policy shape:

```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON public.articles TO authenticated;

ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;

CREATE POLICY articles_select_own ON public.articles
  FOR SELECT TO authenticated
  USING (author_id = auth.uid());

CREATE POLICY articles_insert_own ON public.articles
  FOR INSERT TO authenticated
  WITH CHECK (author_id = auth.uid());

CREATE POLICY articles_update_own ON public.articles
  FOR UPDATE TO authenticated
  USING (author_id = auth.uid())
  WITH CHECK (author_id = auth.uid());
```

`service_role` can bypass RLS, so never expose API Key / `service_role` credentials to browser code.

## Required Identity Probe

Before trusting policies that compare an owner column with `auth.uid()` or another DB-side helper:

1. In Web code, log in with the real username/password flow.
2. Call `auth.getSession()` and record `data.session.user.id`.
3. Insert a row through the same browser `app.rdb()` client without passing the owner column when the table has `DEFAULT auth.uid()`.
4. Read that row back with `queryPgDatabase` and verify the owner column equals `data.session.user.id`.
5. Attempt the same insert/update path as a second user if the app has admin/editor permissions.

If any browser `app.rdb()` operation fails, the RLS identity is not proven. Do not paper over it by catching the error and updating UI state. Either repair the RLS identity expression or move authorization to a server/RPC boundary.

Avoid self-referential role policies when possible. A policy on `public.user_roles` that queries `public.user_roles` again can recurse or behave differently across engines. Prefer one of these simpler patterns:

- Direct browser reads of roles with tightly scoped writes handled by setup/server code.
- A separate immutable role lookup object/function whose identity expression has already been verified.
- A server/RPC boundary for role-sensitive mutations.

## Verification Checklist

After creating policies, verify all required operations through the real app role:

- SELECT list/detail works for allowed rows.
- INSERT creates a row with the current user's owner column.
- UPDATE changes owned rows and does not reassign ownership unexpectedly.
- DELETE removes only allowed rows.
- Admin can operate across rows if the app requires admin behavior.

Then inspect schema/policies:

```text
queryPgDatabase(action="schema", objectName="public.articles")
queryPgDatabase(action="schema", objectName="public.user_roles")
```

If `rowLevelSecurityEnabled` is true and `policies` is empty, stop and create policies or disable RLS for that table before continuing.

## storage-pg

# CloudBase PG Storage

PG storage stores file metadata in PostgreSQL `storage` schema and enforces permissions through RLS.

> ⚠️ **PG 存储 ≠ 旧 COS 存储**：PG 环境的存储使用 pgstore + HTTP API，与旧 NoSQL 环境的 COS 存储是两套独立系统。以下情况请改用 `manageStorage`：非 PG 环境。

## Decision Tree: Which Storage to Use

```mermaid
flowchart TD
    A[当前环境是 PG 模式？] -->|是| B[使用 pgstore]
    A -->|否| C[使用旧 COS / NoSQL 存储]
    
    B --> B1{需要做什么？}
    B1 -->|创建 bucket| B2[INSERT INTO storage.buckets<br>或 HTTP API POST /v1/storages/bucket/]
    B1 -->|上传文件| B3[前端 SDK: app.storage.from().upload()<br>或 HTTP API]
    B1 -->|下载/签名| B4[HTTP API POST /v1/storages/object/sign/]
    B1 -->|查询文件| B5[HTTP API / storage.objects 表查询]
    B1 -->|配置权限| B6[ALTER TABLE storage.objects ENABLE RLS<br>CREATE POLICY ...]
    
    C --> C1{需要做什么？}
    C1 -->|上传/下载| C2[manageStorage / queryStorage 工具]
    C1 -->|查询| C3[queryStorage 工具]
```

**核心规则：**
- PG 环境 → 用 `queryPgStorage`（规划方案） +  HTTP API / 前端 SDK（执行）
- 旧 COS 环境 → 用 `manageStorage` / `queryStorage`（直接执行）

## Model

- `storage.buckets`: one row per bucket.
- `storage.objects`: one row per object.
- File bytes live in object storage, but metadata and permissions are coordinated through Storage API + PostgreSQL.
- `storage.buckets` / `storage.objects` are granted to `anon`, `authenticated`, and `service_role`; RLS is the effective permission gate.
- Traditional storage permission labels (`READONLY` / `PRIVATE` / `CUSTOM`) and JSON storage safe rules do not apply to PG storage.

## How Supabase Does Storage (Reference)

Supabase 和 CloudBase PG storage 的设计理念高度一致，可以对照理解：

| Concept | Supabase | CloudBase PG |
|---------|----------|-------------|
| **Schema** | `storage.buckets` / `storage.objects` | 相同（内置 pgstore schema） |
| **Anonymous access** | `anon` key (public, safe for client) | `anon` key（即 publishable key） |
| **Server access** | `service_role` key (secret, bypass RLS) | API Key（`manageAppAuth(action="createApiKey")`） |
| **User auth** | User JWT from `supabase.auth.signIn()` | User JWT from `auth.signInWithPassword()` 等 |
| **RLS** | `CREATE POLICY ... ON storage.objects` | 相同 |
| **Bucket creation** | `supabase.storage.createBucket()` | `INSERT INTO storage.buckets` 或 HTTP API |
| **Upload** | `supabase.storage.from('b').upload()` | `app.storage.from('b').upload()` |
| **Signed URL** | `createSignedUrl()` | HTTP API `POST /v1/storages/object/sign/` |

## JWT Token Acquisition for PG Storage API

PG Storage HTTP API 需要 Bearer JWT 认证。以下是三种角色对应的 token 获取方式：

### 1. service_role（服务端、旁路 RLS）

用于后端脚本、管理任务。对应 Supabase 的 `service_role` key。

```mermaid
flowchart LR
    A[manageAppAuth<br>action=createApiKey] -->|返回| B[API Key (token)]
    B --> C[Authorization: Bearer {token}]
    C --> D[调用 PG Storage HTTP API<br>旁路 RLS, 全权限]
```

**获取方式：**
```
manageAppAuth(action="createApiKey", name="my-server-key", description="服务端存储用")
```

返回的 `token` 就是 `service_role` 级别的凭据。

### 2. authenticated（已登录用户、受 RLS 约束）

用户通过前端登录后获取 JWT，用于浏览器端上传。

**前端登录：**
```js
// Web SDK
import { CloudBase } from '@cloudbase/js-sdk';
const app = CloudBase.init({ env: 'your-env-id' });
await app.auth.signInWithPassword({ username, password });
// 登录后 app 自动携带 JWT
await app.storage.from('covers').upload('a.png', file);
```

**手动获取 JWT token：**
```js
const token = await app.auth.getAuthHeader();
// token 形如 { 'x-cloudbase-uid': 'xxx', 'Authorization': 'Bearer xxx' }
```

### 3. anon（匿名、受 RLS 约束）

不需要携带 Authorization 头，或使用 anon key。只能访问 `public` bucket 且 RLS 放行的资源。

**获取 anon key（即 publishable key）：**
```
manageAppAuth(action="ensurePublishableKey")
```

返回的 `token` 即为 anon key，可安全暴露给客户端。

### Supabase 对照

```
Supabase                              CloudBase PG
────────────────────────────────────────────────────
Dashboard > Settings > API            manageAppAuth(action="createApiKey")
  → anon key (public)                   → publishable key (anon)
  → service_role key (secret)           → API Key (service_role)
supabase.auth.signIn()                 app.auth.signInWithPassword()
  → user JWT                             → user JWT
```

## Full HTTP API Reference

PG Storage 提供完整的 RESTful API，共 21 个端点，通过 OpenAPI 规范管理。

## troubleshooting

# CloudBase PG Troubleshooting

## `xxx.rdb is not a function`

Cause: installed CloudBase SDK is too old or the environment SDK surface does not expose PG.

Fix:

- Upgrade to the latest `@cloudbase/js-sdk` for Web.
- Re-check that the target environment is PG mode.

## DDL fails through ExecutePGSql / managePgDatabase

Facts:

- Execute one SQL statement per call.
- Some DDL (`CREATE`, `ALTER`, `DROP`, `GRANT`, `REVOKE`, `TRUNCATE`, `COMMENT`) may fail directly with transient `InternalError`.

Retry once with a `DO $$` wrapper and escape single quotes:

```sql
DO $$ BEGIN EXECUTE 'CREATE TABLE public.products (id serial PRIMARY KEY, name text)'; END $$;
```

Do not use this as a way to hide real syntax errors. If the wrapped SQL also fails, inspect the exact error and simplify.

## Permissions pass in MCP but fail in browser

Likely cause: admin/default execution bypassed user-facing role checks.

Fix:

- Verify table `GRANT` exists for `anon` or `authenticated`.
- Verify RLS policies exist and include both `USING` and `WITH CHECK` when needed.
- If the tool/API supports role simulation, execute checks as `authenticated` or `anon`.
- Test through the real `app.rdb()` browser flow with `auth.getSession()`.

## Insert with serial/bigserial fails

Cause: missing sequence grant.

```sql
GRANT USAGE, SELECT ON SEQUENCE public.todos_id_seq TO authenticated;
```

## Mini Program PG gateway error

If a mini program reports `Generating default gateway base url failed: env not found`, the base library may be too old for CloudBase PostgreSQL.

Fix: use WeChat base library `3.8.9` or later and confirm the environment is PG mode.

## Storage upload returns `STORAGE_PERMISSION_DENIED`

Cause: bucket exists but `storage.objects` RLS denies the request.

Fix: read `storage-pg.md`, configure bucket-specific policies, and retry the same SDK upload path.

## Existing app on CloudRun cannot connect to PostgreSQL (TCP)

Symptoms: deploy succeeds, but the container logs `ECONNREFUSED`, connection timeout, or "could not connect to server" when using `DATABASE_URL` / `postgres://` / `pg` drivers.

Cause: classic TCP clients need the CloudRun instances to join the database VPC. CloudBase PG SDK/gateway (`app.rdb()`, HTTP REST) is a different path and is **not** a drop-in for most GitHub apps.

Fix:

1. Confirm whether the app is a **TCP client** (ORM / `DATABASE_URL`) or a **CloudBase PG SDK** client (`app.rdb()`).
2. For TCP clients: redeploy with `serverConfig.VpcConf` pointing at the same region/VPC as the database, and use the **private** DB host. See `../cloudrun-development/references/vpc-and-database.md`.
3. Ensure the DB security group / allowlist accepts the CloudRun subnet CIDR on port 5432.
4. Do not assume enabling CloudBase PG mode alone makes an existing open-source app connect without VPC + a TCP-reachable endpoint.

## rule

---
name: postgresql-development-cloudbase
description: "Use when building, debugging, or evaluating CloudBase PostgreSQL / CloudBase PG / PG mode apps, including Postgres schema setup, queryPgDatabase/managePgDatabase, JS SDK v3 app.rdb() CRUD/RPC, PG HTTP API fallback, RLS-style permissions, username-password auth, and Web CMS/admin CRUD flows backed by CloudBase PG."
version: 2.24.1
alwaysApply: false
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/postgresql-development/SKILL.md`

# CloudBase PostgreSQL Development

## Activation Contract

### Use this first when

- The task says CloudBase PG, PostgreSQL, Postgres, PG mode, RLS, JS SDK v3 PostgreSQL, `app.rdb()`, `queryPgDatabase`, or `managePgDatabase`.
- A Web app or CMS must persist business data in CloudBase PostgreSQL instead of NoSQL or MySQL.

### Then also read

- Web auth provider readiness -> `../auth-tool/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-tool/SKILL.md`)
- Web login implementation -> `../auth-web/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-web/SKILL.md`)
- General Web implementation and verification -> `../web-development/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/web-development/SKILL.md`)
- Browser storage upload -> `../cloud-storage-web/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/cloud-storage-web/SKILL.md`)
- Raw HTTP API details only when SDK coverage is blocked -> `../http-api/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/http-api/SKILL.md`)
- PG reference index -> `references/index.md`
- PG mode overview -> `references/pg-mode-overview.md`
- Auth / GRANT / RLS details -> `references/auth-and-rls.md`
- End-to-end PG app closure -> `references/app-workflow.md`
- PG storage details -> `references/storage-pg.md`
- HTTP API fallback -> `references/http-api.md`
- Troubleshooting -> `references/troubleshooting.md`

### Do NOT use first

- `relational-database-tool` / `queryMysqlDatabase` / `manageMysqlDatabase`: those are MySQL-oriented.
- `no-sql-web-sdk` / collection APIs for business data that must live in CloudBase PG.

## Required Flow

### 🚨 CRITICAL: PG mode API is NOT the same as NoSQL

CloudBase PG (`app.rdb()`, `app.storage.from('bucket')`) uses **different API method names** than CloudBase NoSQL (`app.database()`, `app.uploadFile()`). Low-capability models often paste legacy NoSQL/auth snippets from training; reject that path immediately. If this task is PG-backed, **do not** write `app.database()`, `db.collection(...)`, `app.uploadFile()`, `getLoginState()`, or route guards based on `auth.getUser()`. Use `app.rdb()`, PG storage v3, and `auth.getSession()` instead. If you are used to writing `.where()`, `.orderBy()`, `.count()` from other ORMs or NoSQL — **stop and read the table below**.

| ❌ Do NOT use these (NoSQL / ORM habits) | ✅ Use these in PG mode |
|------------------------------------------|------------------------|
| `.where({ field: value })` | `.match({ field: value })` or `.eq("field", value)` |
| `.where("field", "ilike", "%v%")` | `.ilike("field", "%v%")` |
| `.orderBy("field", { ascending: false })` | `.order("field", { ascending: false })` |
| `.count()` | `.select("*", { count: "exact" })` — count is in response |
| `.offset(n)` | `.range(from, to)` |
| `app.uploadFile()` (legacy NoSQL upload) | `app.storage.from('bucket').upload(key, file)` |
| `app.getTempFileURL()` (legacy NoSQL URL) | `app.storage.from('bucket').createSignedUrl(key, expiresIn)` |
| `app.storage.from()` (no bucket name) | `app.storage.from('bucket')` — **must** pass bucket name |

**If you find yourself typing `.where()` or `.orderBy()` or `.count()` — stop and use the correct method from the right column.**

0. **First, confirm this environment actually has PostgreSQL provisioned.** Call `envQuery(action="info", envId=...)` and read the derived `EnvInfo.RuntimeBackends` block (`{ postgresql, nosql, mysql }`) along with `EnvInfo.RuntimeMode`. It is only safe to apply this skill's PG-specific guidance when `RuntimeBackends.postgresql === true` (equivalently, `EnvInfo.PostgreSQL` is non-empty AND/OR `EnvInfo.Meta` contains `postgresql=enable`).
   - PG mode is a **new-environment mode** selected when creating a CloudBase environment with PostgreSQL. Do not try to "upgrade" a legacy environment in place; create/select a PG-mode environment instead.
   - If `RuntimeBackends.postgresql === false`, STOP — this is a legacy NoSQL-only env: switch to `no-sql-web-sdk` for browser data and `cloud-storage-web` (with `app.uploadFile()`) for uploads. Do not write `app.rdb()` code, do not enable RLS, do not create a pgstore bucket here.
   - If both `postgresql` and `nosql` are `true` (the common case in a PG environment), they coexist. Apply this skill to NEW business data the task asks you to put in PG (e.g. articles / role tables explicitly described as PG). Existing NoSQL collections, the bucket reported in `EnvInfo.Storages[]`, and any `managePermissions(resourceType="noSqlDatabase")` rules continue to govern the legacy NoSQL data — do NOT migrate or rewrite them unless the task explicitly asks.
   - `RuntimeBackends.mysql === false` is the only hard "do not use" signal: when MySQL is absent, do not use `manageMysqlDatabase` / `queryMysqlDatabase` and do not consult the `relational-database-tool` skill; those are MySQL-specific and have nothing to do with CloudBase PG.
   - Note: in a PG env, `EnvInfo.Storages[]` is the legacy NoSQL bucket. It still works for legacy `app.uploadFile()` flows but is NOT a usable pgstore bucket — never reuse it as the `<bucket>` segment in `app.storage.from('<bucket>').upload('<key>', file)`.

> **Creating a PG-mode environment**
>
> If step 0 shows `RuntimeBackends.postgresql === false` and you need PostgreSQL, create a new environment with PG enabled:
>
> - **Via MCP**: `manageEnv(action="create", alias="my-env", packageId="baas_personal", resources=["flexdb","storage","function","postgresql"], confirm="yes")` — do not pass `region`; CreateEnv does not accept it.
> - **Via CLI**: `tcb env create --alias my-env --package baas_personal --postgresql --yes`
> - **Via Console**: [Create environment](https://console.cloud.tencent.com/tcb/env/create)

1. Inspect the existing app surfaces first: `src/lib/backend.*`, `src/lib/auth.*`, `src/lib/*service.*`, route guards, and the handlers bound to existing forms.
2. Check PG state through MCP: use `queryPgDatabase` for schema/read-only inspection and `managePgDatabase` for DDL/DML. Do not switch to MySQL tools. For the complete route map, read `references/index.md`.
3. **Understand PG roles before writing code:** Publishable Key maps to `anon`; a logged-in user's access token maps to `authenticated`; API Key maps to `service_role` and bypasses RLS. Never expose API Key / `service_role` credentials in frontend code. See `references/auth-and-rls.md`.
4. **Use schema management (`managePgDatabase`) before writing CRUD code.** Schema DDL (CREATE / ALTER / DROP / TRUNCATE) **must** go through the versioned migration workflow — never default to `execute` for table creation. Then apply GRANT + RLS (via `execute` or the same migration SQL bundle) before browser access. The minimum SQL bundle is: `CREATE TABLE`, `GRANT SELECT/INSERT/UPDATE/DELETE TO authenticated`, `GRANT USAGE, SELECT ON SEQUENCE ... TO authenticated` when using `serial`/`bigserial`, `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`, and `CREATE POLICY ... USING / WITH CHECK`. See `references/auth-and-rls.md` for the full template.

   **Default schema-change workflow (local file first, then remote history):**
   1. Choose `migrationVersion` = 14-digit UTC timestamp `YYYYMMDDHHMMSS` and `migrationName` = snake_case (e.g. `add_users`).
   2. Write local file `migrations/<migrationVersion>_<migrationName>.sql` with the DDL (and optional rollback SQL in comments or a paired file).
   3. Optional preview: `managePgDatabase(action=planMigration, migrationName=..., migrationVersion=..., sql=...)`.
   4. Apply: `managePgDatabase(action=applyMigration, migrationName=..., migrationVersion=..., sql=..., confirm=true)` — reuse the **same** version/name as the local file.
   5. Verify: `managePgDatabase(action=listMigrations)` and confirm the remote history records the same `migrationVersion`.
   6. Then write frontend CRUD / RLS checks.

   Other migration actions:
   - `managePgDatabase(action=migrationDetail, migrationVersion=...)` — inspect a single migration
   - `managePgDatabase(action=rollbackMigration, lastN=..., confirm=true)` — roll back the last N applied migrations
   - `managePgDatabase(action=repairMigration, migrationVersion=..., migrationName=..., repairStatus=..., repairReason=...)` — repair history records

   **`execute` is for DML and ops SQL, not default DDL:** use `managePgDatabase(action=execute, confirm=true)` for `INSERT` / `UPDATE` / `DELETE`, and for `GRANT` / `CREATE POLICY` / storage RLS when those are not part of a migration. If you attempt schema DDL via `execute`, the tool soft-blocks with `DDL_USE_APPLY_MIGRATION` unless you explicitly set `allowDdlViaExecute=true` (escape hatch only).

   **🚨 CRITICAL: Inspect table existence and column names before CREATE TABLE.** `CREATE TABLE IF NOT EXISTS` silently skips when the table already exists, even if the column names are wrong. Always call `queryPgDatabase(action="sql", sql="SELECT column_name, data_type FROM information_schema.columns WHERE table_name='xxx'")` first to check whether the table exists and what exact column names it uses. If the table already exists with mismatched column names (e.g. `user_id` instead of `uid`), you must either:
   - `ALTER TABLE` to add/rename/drop columns (via `applyMigration` with a new version), or
   - `DROP TABLE IF EXISTS ... CASCADE` and recreate via `applyMigration` (only when data loss is acceptable, e.g. disposable/evaluation environments).
   - Do NOT rely on `CREATE TABLE IF NOT EXISTS` silent skip — it will cause all downstream CRUD queries to fail with wrong field names.
   - After DDL, re-query the schema and compare every column name used by frontend code, insert/update payloads, filters, ordering, and RLS policies.
5. Check username-password auth before coding login:
   - Call `queryAppAuth(action="getLoginConfig")`.
   - If `loginMethods.usernamePassword !== true`, call `manageAppAuth(action="patchLoginStrategy", patch={ usernamePassword: true })`.
   - In Web login code, use `auth.signInWithPassword({ username, password })` for plain usernames like `admin` or `editor`.
   - Do not assume `auth.signUp({ username, password })` can directly create username/password users. Confirm `queryAppAuth` `sdkHints` and the installed `@cloudbase/js-sdk` behavior first; if direct username signup is unsupported, implement registration through a backend/management boundary instead of exposing secret keys in the browser.
6. Implement Web auth state with `auth.getSession()` before writing CRUD:
   - Route guards must check `data.session`, not `auth.getUser()` and not deprecated `getLoginState()`.
   - Treat login as successful only when `signInWithPassword(...)` returns no `error` and includes `data.session`.
   - Get the UID for `author_id` / role rows from `data.session.user.id` (fall back to `sub`/`uid` only after inspecting the actual session object).
   - Do not use `auth.getUser()` as proof of login; it can return a non-null wrapper or anonymous-looking user data when there is no real username/password session.
7. Implement browser-side business data with the CloudBase JS SDK v3 PostgreSQL API first: `app.rdb().from(table)`. Use the latest `@cloudbase/js-sdk` when `app.rdb` is missing (`xxx.rdb is not a function` means the SDK is too old).
8. Do not manually fetch a CloudBase Auth bearer token from browser code for PG CRUD. In particular, do not call non-canonical helpers such as `currentUser.getIdToken()` unless you have verified that exact method exists in the installed SDK. Prefer `app.rdb()` so the SDK carries the active session.
9. Use the official CloudBase PG SQL auth helpers in policies: `auth.uid()` for JWT `sub`, `auth.role()` for `anon` / `authenticated` / `service_role`, `auth.jwt()` for full claims, and `auth.email()` when email is needed. Still verify the policy through the real app session before claiming it works:
   - Log in through the real app path.
   - Insert a test row using `author_id = session.user.id`.
   - Read it back with `queryPgDatabase`.
   - If INSERT/SELECT fails, inspect the exact RLS error and fix the policy or switch to a server/RPC boundary. Do not leave browser-facing tables with broken RLS.
   - **⚠️ Do NOT use `current_user` or `current_setting(...)` in RLS policies.** `current_user` in PostgreSQL returns the database role name (e.g. `authenticated`), NOT the CloudBase auth user ID. Always use `auth.uid()` for user identity checks. If you are unsure whether the auth helpers are available, run `SELECT proname FROM pg_proc WHERE pronamespace = 'auth'::regnamespace` to list all available `auth.*` functions.

## rule

---
name: relational-database-mcp-cloudbase
description: "[Deprecated] This is the required documentation for agents operating on the CloudBase Relational Database through MCP. It defines the canonical SQL management flow with `queryMysqlDatabase`, `manageMysqlDatabase`, `queryPermissions`, and `managePermissions`, including destroy flow, async status checks, safe query execution, schema initialization, and permission updates. MySQL provisioning is no longer available through MCP; new environments should use PostgreSQL — see postgresql-development skill instead."
version: 2.35.2
license: MIT
alwaysApply: false
metadata:
  priority: "5"
  deprecated: "true"
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## Activation Contract

### Use this first when

- The agent must inspect SQL data, execute SQL statements, destroy an existing MySQL instance, initialize table structure, or manage table security rules through MCP tools.

### Read before writing code if

- The task includes `queryMysqlDatabase`, `manageMysqlDatabase`, `queryPermissions`, or `managePermissions`.

### Then also read

- Web application integration -> `../relational-database-web-cloudbase/SKILL.md`
- Raw HTTP database access -> `../http-api-cloudbase/SKILL.md`

### Do NOT use for

- Frontend or backend application code that should use SDKs instead of MCP operations.

### Common mistakes / gotchas

- Initializing SDKs in an MCP management flow.
- Running write SQL or DDL before confirming the environment already has a ready MySQL instance.
- Trying to create a MySQL instance through MCP. Provisioning has been retired from the tool surface: new environments use PostgreSQL, and instances are only created in the console.
- Treating document database tasks as MySQL management tasks.
- Skipping `_openid` and permissions review after creating new SQL tables.
- Destroying MySQL without explicit confirmation or without checking whether the environment still needs the instance.
- Using `getConnectionInfo` (or inferred host/password) to build a default TCP client for new apps. Prefer SDK / `runQuery` / `runStatement`; TCP credentials are an explicit migration exception only.

## When to use this skill

Use this skill when an **agent** needs to operate on **CloudBase Relational Database via MCP tools**, for example:

- Inspecting or querying SQL data
- Destroying an existing MySQL instance
- Polling an in-flight MySQL task (create tasks are started in the console — MCP no longer creates instances)
- Modifying data or schema (INSERT/UPDATE/DELETE/DDL)
- Initializing tables and indexes after MySQL is ready
- Reading or changing table permissions

Do **NOT** use this skill for:

- Building Web or Node.js applications that talk to CloudBase Relational Database directly through SDKs
- Auth flows or user identity management

## How to use this skill (for a coding agent)

1. **Recognize MCP context**
   - If you can call tools like `queryMysqlDatabase`, `manageMysqlDatabase`, `queryPermissions`, `managePermissions`, you are in MCP context.
   - In this context, **never initialize SDKs for CloudBase Relational Database**; use MCP tools instead.

2. **Pick the right tool for the job**
   - Read-only SQL and create/destroy task status checks -> `queryMysqlDatabase`
   - MySQL destruction, write SQL, DDL, schema initialization -> `manageMysqlDatabase`
   - Inspect permissions -> `queryPermissions(action="getResourcePermission")`
   - Change permissions -> `managePermissions(action="updateResourcePermission")`

3. **Always be explicit about safety**
   - Before destructive operations (DELETE, DROP, etc.), summarize what you are about to run and why.
   - Prefer `queryMysqlDatabase(action="getInstanceInfo")` or a read-only SQL check before writes.
   - Destroying MySQL requires explicit confirmation because it has environment-level impact; provisioning is not offered here at all.

---

## Available MCP tools (CloudBase Relational Database)

These tools are the supported way to interact with CloudBase Relational Database via MCP:

### 1. `queryMysqlDatabase`

- **Purpose:** Query SQL data and instance / task state.
- **Use for:**
  - Running `SELECT` and other read-only SQL queries with `action="runQuery"`
  - Checking whether MySQL already exists with `action="getInstanceInfo"` (lifecycle only — no connection credentials)
  - Inspecting an in-flight create or destroy task with `action="describeCreateResult"` or `action="describeTaskStatus"` (create tasks originate in the console)
  - **Exception only:** `action="getConnectionInfo"` returns the raw connection/cluster payload (may include credentials) for migrating existing TCP/ORM clients. Do **not** use this for new business CRUD — prefer Web/Node SDK or `runQuery` / `runStatement`.

**Example flow:**

```json
{
  "action": "runQuery",
  "sql": "SELECT id, email FROM users ORDER BY created_at DESC LIMIT 50"
}
```

**Do NOT** call `getConnectionInfo` and then wire `pymysql` / `mysql2` / `DATABASE_URL` into a cloud function for greenfield apps. Platform-delegated SQL and SDK access are the default.

### 2. `manageMysqlDatabase`

- **Purpose:** Manage an existing SQL instance and execute mutating SQL.
- **Use for:**
  - Destroying MySQL with `action="destroyMySQL"`
  - Executing `INSERT`, `UPDATE`, `DELETE`, `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE` with `action="runStatement"`
  - Initializing tables and indexes with `action="initializeSchema"`

**Provisioning is not available here.** `provisionMySQL` has been removed from the action set: a call carrying it fails schema validation, and a missing instance returns `MYSQL_NOT_CREATED` with a console entry rather than a create hint.

**Important:** When creating a new table, you **must** include the `_openid` column for per-user access control:

```sql
_openid VARCHAR(64) DEFAULT '' NOT NULL
```

## rule

---
name: relational-database-mcp-cloudbase
description: "[Deprecated] This is the required documentation for agents operating on the CloudBase Relational Database through MCP. It defines the canonical SQL management flow with `queryMysqlDatabase`, `manageMysqlDatabase`, `queryPermissions`, and `managePermissions`, including MySQL provisioning, destroy flow, async status checks, safe query execution, schema initialization, and permission updates. New environments should use PostgreSQL — see postgresql-development skill instead."
version: 2.24.1
alwaysApply: false
metadata:
  priority: 5
  deprecated: true
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/relational-database-tool/SKILL.md`

Keep local `references/...` paths for files that ship with the current skill directory. When this file points to a sibling skill such as `auth-tool` or `web-development`, use the standalone fallback URL shown next to that reference.

## Activation Contract

### Use this first when

- The agent must inspect SQL data, execute SQL statements, provision or destroy MySQL, initialize table structure, or manage table security rules through MCP tools.

### Read before writing code if

- The task includes `queryMysqlDatabase`, `manageMysqlDatabase`, `queryPermissions`, or `managePermissions`.

### Then also read

- Web application integration -> `../relational-database-web/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/relational-database-web/SKILL.md`)
- Raw HTTP database access -> `../http-api/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/http-api/SKILL.md`)

### Do NOT use for

- Frontend or backend application code that should use SDKs instead of MCP operations.

### Common mistakes / gotchas

- Initializing SDKs in an MCP management flow.
- Running write SQL or DDL before checking whether MySQL is provisioned and ready.
- Treating document database tasks as MySQL management tasks.
- Skipping `_openid` and permissions review after creating new SQL tables.
- Destroying MySQL without explicit confirmation or without checking whether the environment still needs the instance.

## When to use this skill

Use this skill when an **agent** needs to operate on **CloudBase Relational Database via MCP tools**, for example:

- Inspecting or querying SQL data
- Provisioning MySQL for an environment
- Destroying MySQL for an environment
- Polling MySQL provisioning status
- Modifying data or schema (INSERT/UPDATE/DELETE/DDL)
- Initializing tables and indexes after MySQL is ready
- Reading or changing table permissions

Do **NOT** use this skill for:

- Building Web or Node.js applications that talk to CloudBase Relational Database directly through SDKs
- Auth flows or user identity management

## How to use this skill (for a coding agent)

1. **Recognize MCP context**
   - If you can call tools like `queryMysqlDatabase`, `manageMysqlDatabase`, `queryPermissions`, `managePermissions`, you are in MCP context.
   - In this context, **never initialize SDKs for CloudBase Relational Database**; use MCP tools instead.

2. **Pick the right tool for the job**
   - Read-only SQL and provisioning status checks -> `queryMysqlDatabase`
   - MySQL provisioning, MySQL destruction, write SQL, DDL, schema initialization -> `manageMysqlDatabase`
   - Inspect permissions -> `queryPermissions(action="getResourcePermission")`
   - Change permissions -> `managePermissions(action="updateResourcePermission")`

3. **Always be explicit about safety**
   - Before destructive operations (DELETE, DROP, etc.), summarize what you are about to run and why.
   - Prefer `queryMysqlDatabase(action="getInstanceInfo")` or a read-only SQL check before writes.
   - Provisioning or destroying MySQL requires explicit confirmation because both actions have environment-level impact.

---

## Available MCP tools (CloudBase Relational Database)

These tools are the supported way to interact with CloudBase Relational Database via MCP:

### 1. `queryMysqlDatabase`

- **Purpose:** Query SQL data and provisioning state.
- **Use for:**
  - Running `SELECT` and other read-only SQL queries with `action="runQuery"`
  - Checking whether MySQL already exists with `action="getInstanceInfo"`
  - Inspecting asynchronous provisioning progress with `action="describeCreateResult"` or `action="describeTaskStatus"`

**Example flow:**

```json
{
  "action": "runQuery",
  "sql": "SELECT id, email FROM users ORDER BY created_at DESC LIMIT 50"
}
```

### 2. `manageMysqlDatabase`

- **Purpose:** Manage SQL lifecycle and execute mutating SQL.
- **Use for:**
  - Provisioning MySQL with `action="provisionMySQL"`
  - Destroying MySQL with `action="destroyMySQL"`
  - Executing `INSERT`, `UPDATE`, `DELETE`, `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE` with `action="runStatement"`
  - Initializing tables and indexes with `action="initializeSchema"`

**Important:** When creating a new table, you **must** include the `_openid` column for per-user access control:

```sql
_openid VARCHAR(64) DEFAULT '' NOT NULL
```

Note: when a user is logged in, `_openid` is automatically populated by the server from the authenticated session. Do not manually fill it in normal inserts.


## rule

---
name: relational-database-web-cloudbase
description: "[Deprecated] Use when building frontend Web apps that talk to CloudBase Relational Database via @cloudbase/js-sdk – provides the canonical init pattern so you can then use Supabase-style queries from the browser. New environments should use PostgreSQL with app.rdb() — see postgresql-development skill instead."
version: 2.35.2
license: MIT
alwaysApply: false
metadata:
  priority: "5"
  deprecated: "true"
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

# CloudBase Relational Database Web SDK

## Activation Contract

### Use this first when

- A browser or Web app must access CloudBase Relational Database through `@cloudbase/js-sdk`.
- The task is specifically about frontend initialization and browser-side query usage.

### Read before writing code if

- You need to distinguish browser SDK usage from MCP database management or backend Node access.
- The request mentions Supabase migration, shared frontend DB client, or browser-side table queries.

### Then also read

- MySQL SQL management and MCP operations -> `../relational-database-mcp-cloudbase/SKILL.md`
- Web auth/login -> `../auth-web-cloudbase/SKILL.md`
- General Web app setup -> `../web-development/SKILL.md`

### Do NOT use for

- MCP-based SQL management, schema changes, or permissions management (provisioning is not offered through MCP).
- Backend/Node service access.
- Document database operations.

### Common mistakes / gotchas

- Initializing SDKs in an MCP management flow.
- Treating `app` itself as the relational database client.
- Re-initializing CloudBase in every component.
- Mixing frontend browser access with admin-style schema mutations.

### Minimal checklist

- Confirm the caller is a Web frontend.
- Keep one shared CloudBase app and one shared relational DB client.
- Route MySQL management/schema work on an existing instance to `relational-database-mcp-cloudbase` (it does not provision). If the task says PostgreSQL, CloudBase PG, PG mode, `app.rdb()`, `queryPgDatabase`, `managePgDatabase`, or RLS, route to `postgresql-development-cloudbase` instead.
- Handle auth separately before data access.

## Overview

This skill standardizes the **browser-side initialization pattern** for CloudBase Relational Database.

After initialization, use `db` with Supabase-style query patterns.

## Installation

```bash
npm install @cloudbase/js-sdk
```

## Canonical initialization

```javascript
import cloudbase from "@cloudbase/js-sdk";

const app = cloudbase.init({
  env: "your-env-id"
});

const auth = app.auth;
// Handle login separately

const db = app.rdb();
```

## Initialization rules

- Initialize synchronously.
- Do not lazy-load the SDK with `import("@cloudbase/js-sdk")` unless the framework absolutely requires it.
- Create one shared `db` client and reuse it.
- Do not invent unsupported `cloudbase.init()` options.

## Quick routing

### Use this skill when

- you are wiring browser components to relational tables
- you are replacing a Supabase browser client with CloudBase
- you need a canonical shared frontend `db` client

### Use `relational-database-mcp-cloudbase` instead when

- you need to create/destroy MySQL
- you need MySQL DDL or write-SQL administration
- you need to inspect or change MySQL table security rules through MCP

### Use `postgresql-development-cloudbase` instead when

- the task says PostgreSQL, CloudBase PG, PG mode, `app.rdb()`, `queryPgDatabase`, `managePgDatabase`, PostgREST, or RLS
- browser-side table code must use PG semantics rather than legacy NoSQL / MySQL management tools

## Example: shared frontend DB client

```javascript
import cloudbase from "@cloudbase/js-sdk";

const app = cloudbase.init({
  env: "your-env-id"
});

export const db = app.rdb();

## rule

---
name: relational-database-web-cloudbase
description: "[Deprecated] Use when building frontend Web apps that talk to CloudBase Relational Database via @cloudbase/js-sdk – provides the canonical init pattern so you can then use Supabase-style queries from the browser. New environments should use PostgreSQL with app.rdb() — see postgresql-development skill instead."
version: 2.24.1
alwaysApply: false
metadata:
  priority: 5
  deprecated: true
---

## Standalone Install Note

If this environment only installed the current skill, start from the CloudBase main entry and use the published `cloudbase/references/...` paths for sibling skills.

- CloudBase main entry: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/SKILL.md`
- Current skill raw source: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/relational-database-web/SKILL.md`

Keep local `references/...` paths for files that ship with the current skill directory. When this file points to a sibling skill such as `auth-tool` or `web-development`, use the standalone fallback URL shown next to that reference.

# CloudBase Relational Database Web SDK

## Activation Contract

### Use this first when

- A browser or Web app must access CloudBase Relational Database through `@cloudbase/js-sdk`.
- The task is specifically about frontend initialization and browser-side query usage.

### Read before writing code if

- You need to distinguish browser SDK usage from MCP database management or backend Node access.
- The request mentions Supabase migration, shared frontend DB client, or browser-side table queries.

### Then also read

- MySQL SQL management and MCP operations -> `../relational-database-tool/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/relational-database-tool/SKILL.md`)
- Web auth/login -> `../auth-web/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/auth-web/SKILL.md`)
- General Web app setup -> `../web-development/SKILL.md` (standalone fallback: `https://cnb.cool/tencent/cloud/cloudbase/cloudbase-skills/-/git/raw/main/skills/cloudbase/references/web-development/SKILL.md`)

### Do NOT use for

- MCP-based SQL provisioning, schema changes, or permissions management.
- Backend/Node service access.
- Document database operations.

### Common mistakes / gotchas

- Initializing SDKs in an MCP management flow.
- Treating `app` itself as the relational database client.
- Re-initializing CloudBase in every component.
- Mixing frontend browser access with admin-style schema mutations.

### Minimal checklist

- Confirm the caller is a Web frontend.
- Keep one shared CloudBase app and one shared relational DB client.
- Route MySQL provisioning/schema work to `relational-database-tool`. If the task says PostgreSQL, CloudBase PG, PG mode, `app.rdb()`, `queryPgDatabase`, `managePgDatabase`, or RLS, route to `postgresql-development` instead.
- Handle auth separately before data access.

## Overview

This skill standardizes the **browser-side initialization pattern** for CloudBase Relational Database.

After initialization, use `db` with Supabase-style query patterns.

## Installation

```bash
npm install @cloudbase/js-sdk
```

## Canonical initialization

```javascript
import cloudbase from "@cloudbase/js-sdk";

const app = cloudbase.init({
  env: "your-env-id"
});

const auth = app.auth;
// Handle login separately

const db = app.rdb();
```

## Initialization rules

- Initialize synchronously.
- Do not lazy-load the SDK with `import("@cloudbase/js-sdk")` unless the framework absolutely requires it.
- Create one shared `db` client and reuse it.
- Do not invent unsupported `cloudbase.init()` options.

## Quick routing

### Use this skill when

- you are wiring browser components to relational tables
- you are replacing a Supabase browser client with CloudBase
- you need a canonical shared frontend `db` client

### Use `relational-database-tool` instead when

- you need to create/destroy MySQL
- you need MySQL DDL or write-SQL administration
- you need to inspect or change MySQL table security rules through MCP

### Use `postgresql-development` instead when

- the task says PostgreSQL, CloudBase PG, PG mode, `app.rdb()`, `queryPgDatabase`, `managePgDatabase`, PostgREST, or RLS
- browser-side table code must use PG semantics rather than legacy NoSQL / MySQL management tools

## Example: shared frontend DB client

```javascript
import cloudbase from "@cloudbase/js-sdk";

const app = cloudbase.init({
  env: "your-env-id"
});

## rule

---
name: spec-workflow
description: Use when medium-to-large changes need explicit requirements, technical design, and task planning before implementation, especially for multi-module work, unclear acceptance criteria, or architecture-heavy requests.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

# Spec Workflow

## Activation Contract

### Use this first when

- The request is a new feature, multi-step product change, cross-module integration, or architecture/design task.
- Acceptance criteria are unclear and need to be made explicit before implementation.
- The work involves multiple files, user flows, database design, or UI design that needs staged confirmation.

### Read before writing code if

- You are unsure whether the task should go straight to coding or should first go through requirements, design, and task planning.
- The request mentions a new page, a new system, a redesign, a workflow, or a multi-module refactor.

### Then also read

- Frontend page or visual design work -> `../ui-design/SKILL.md`
- Advanced data-model work -> `../data-model-creation/SKILL.md`

### Do NOT use for

- Small bug fixes with clear scope.
- One-file documentation updates.
- Straightforward config changes.
- Tiny refactors where the user already gave exact implementation instructions.

### Common mistakes / gotchas

- Jumping into coding before acceptance criteria are explicit.
- Skipping user confirmation between requirements, design, and tasks.
- Writing vague tasks that do not map back to user-visible outcomes.
- Treating UI work as purely technical implementation without clarifying design intent.

### Minimal checklist

- Decide whether the change really needs the full spec flow.
- If yes, stop and produce requirements first.
- If the change is small, low-risk, and acceptance is already clear, allow direct execution without forcing spec artifacts.
- Use EARS-style acceptance criteria.
- Get confirmation before moving to the next phase.

## When to use this skill

Use this workflow for structured development when you need to:

- Define or refine a new feature
- Design complex architecture
- Coordinate changes across modules
- Plan database or UI-heavy work
- Improve requirement quality and acceptance boundaries

## Decision rule

### Use the full workflow when

- The task is medium or large
- The impact spans multiple modules
- Acceptance boundaries are fuzzy
- The user wants disciplined planning before implementation

### Skip the full workflow when

- The task is small, low-risk, and already precise
- Goal, scope, and acceptance are already clear enough to execute directly
- The user explicitly wants a direct code change with no planning phase

## Core workflow

### Phase 1: Requirements

Create `specs/<spec_name>/requirements.md`.

What to do:

- Restate the problem and scope
- Write user stories
- Write acceptance criteria in EARS style
- Clarify business rules, constraints, and non-goals

EARS pattern:

```text
While <optional precondition>, when <optional trigger>, the <system name> shall <system response>
```

Example:

```text
When the user submits the form, the booking system shall validate required fields before creating the record.
```

### Phase 2: Design

Create `specs/<spec_name>/design.md`.

What to do:

- Describe architecture and module boundaries
- Explain technology choices and trade-offs
- Define data model, API, security, and testing strategy as needed
- Use Mermaid only when a diagram materially improves clarity

### Phase 3: Tasks

Create `specs/<spec_name>/tasks.md`.

## checklist

# UI Design Activation Checklist

Use this checklist before generating any page, component, or visual interface.

## Required checks

1. Output the design specification first.
2. Choose a concrete aesthetic direction rather than generic adjectives.
3. Define a color palette and typography before writing markup or styles.
4. Confirm the target platform: Web or mini program.
5. Read the platform implementation skill after the design spec is fixed.

## Common failure patterns

- Starting with JSX, WXML, or CSS before design intent is stated.
- Falling back to generic AI visual patterns.
- Missing platform-specific layout or asset constraints.

## Done criteria

- The design spec is visible in the response.
- Aesthetic direction, palette, and typography are explicit.
- The next implementation skill is known before UI code starts.

## rule

---
name: ui-design
description: Use when users need visual direction, interface hierarchy, layout decisions, design specifications, or prototypes before implementing a Web or mini program UI.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

## Activation Contract

### Use this first when

- The request is to decide visual direction, produce a design specification, create a prototype, or make layout, typography, color, and visual hierarchy choices for an interface.
- The implementation should follow a deliberate aesthetic rather than directly coding an already-approved design.

### Read before writing code if

- The response must choose typography, color, spacing, layout strategy, or other visual rules before code exists.
- The user asks for "design", "prototype", "look and feel", or "style" rather than straight implementation.

### Then also read

- Web implementation -> `../web-development/SKILL.md`
- Mini program implementation -> `../miniprogram-development/SKILL.md`

### Do NOT use for

- Backend-only tasks, database design, or pure API work without interface output.
- Straight implementation of an already-approved UI without new design decisions.
- Generic frontend coding requests where the visual direction is already settled.

### Common mistakes / gotchas

- Writing JSX, WXML, or CSS before outputting the design specification.
- Falling back to generic AI layouts instead of an explicit aesthetic direction.
- Jumping into implementation when the design intent is still unclear.
- Ignoring platform constraints after the visual concept is defined.

### Minimal checklist

- Read [UI Design Activation Checklist](checklist.md) before interface generation.

## When to use this skill

Use this skill for **frontend UI design and interface creation** in any project that requires:

- Creating web pages or interfaces
- Creating mini-program pages or interfaces
- Designing frontend components
- Creating prototypes or interfaces
- Handling styling and visual effects
- Any development task involving user interfaces

**Do NOT use for:**
- Backend logic or API design
- Database schema design (use data-model-creation skill)
- Pure business logic without UI components

---

## How to use this skill (for a coding agent)

1. **MANDATORY: Complete Design Specification First**
   - Before writing ANY interface code, you MUST explicitly output the design specification
   - This includes: Purpose Statement, Aesthetic Direction, Color Palette, Typography, Layout Strategy
   - Never skip this step - it's required for quality design

2. **Follow the Design Process**
   - User Experience Analysis
   - Product Interface Planning
   - Aesthetic Direction Determination
   - High-Fidelity UI Design
   - Frontend Prototype Implementation
   - Realism Enhancement

3. **Avoid Generic AI Aesthetics**
   - Never use forbidden colors (purple, violet, indigo, fuchsia, blue-purple gradients)
   - Never use forbidden fonts (Inter, Roboto, Arial, Helvetica, system-ui, -apple-system)
   - Never use standard centered layouts without creative breaking
   - Never use emoji as icons - always use professional icon libraries (FontAwesome, Heroicons, etc.)

4. **Run Self-Audit Before Submitting**
   - Color audit (check for forbidden colors)
   - Font audit (check for forbidden fonts)
   - Icon audit (verify no emoji icons, using professional icon libraries)
   - Layout audit (verify asymmetry/creativity)
   - Design specification compliance check

5. **Respect brand or design-system overrides when they are real constraints**
   - If the project already has approved brand colors, font tokens, or a design system, treat those as higher-priority constraints
   - Explicitly document which default UI-design prohibitions are being overridden and why
   - Keep the override narrow: preserve the overall quality bar instead of falling back to generic AI styling

---

# UI Design Rules

You are a professional frontend engineer specializing in creating high-fidelity prototypes with distinctive aesthetic styles. Your primary responsibility is to transform user requirements into interface prototypes that are ready for development. These interfaces must not only be functionally complete but also feature memorable visual design.

## Design Thinking

### ⚠️ MANDATORY PRE-DESIGN CHECKLIST (MUST COMPLETE BEFORE ANY CODE)

**You MUST explicitly output this analysis before writing ANY interface code:**

```
DESIGN SPECIFICATION
====================
1. Purpose Statement: [2-3 sentences about problem/users/context]
2. Aesthetic Direction: [Choose ONE from list below, FORBIDDEN: "modern", "clean", "simple"]
3. Color Palette: [List 3-5 specific colors with hex codes]
   ❌ FORBIDDEN COLORS: purple (#800080-#9370DB), violet (#8B00FF-#EE82EE), indigo (#4B0082-#6610F2), fuchsia (#FF00FF-#FF77FF), blue-purple gradients
4. Typography: [Specify exact font names]
   ❌ FORBIDDEN FONTS: Inter, Roboto, Arial, Helvetica, system-ui, -apple-system

## browser-testing

# Browser Validation (with `agent-browser`)

This file is the concrete playbook for the `agent-browser` tool. Use it whenever the Engineering constitution in `SKILL.md` says "verify in the browser before claiming done".

Code reading, static types, and a clean build are **necessary but not sufficient**. Any change that affects what the user sees, clicks, or navigates must be opened in a real browser and exercised.

## When `agent-browser` is required (not optional)

Trigger browser validation for changes that touch any of:

- **Routing / navigation** — new routes, redirects, route guards, 404s, hash vs history mode, nested layouts
- **Forms** — submit handlers, controlled inputs, validation errors, disabled states, file uploads
- **Auth flows** — sign in, sign up, logout, session guards, token refresh, `getSession`
- **Async UI** — loading spinners, skeletons, error banners, retry buttons, streaming responses
- **Conditional rendering** — empty states, permission-gated sections, feature flags
- **Third-party SDK calls from the browser** — CloudBase Web SDK (auth, database, AI model, storage), analytics, payment

Skip browser validation only for pure build-config edits, README / documentation-only changes, backend-only work, or changes guarded by CI tests you verified pass.

## When `agent-browser` is NOT the right tool

- Pure visual direction / aesthetic exploration → use the `ui-design` skill first.
- Backend-only logic that never renders in the browser → use unit tests or direct API calls.
- Smoke-testing a production URL against real user credentials → do not automate; ask the user.

## Standard workflow

Follow these steps in order. Do not skip the "before the fix" reproduction — it is what proves the bug was real and that your change actually fixed it.

1. **Start the app** (or confirm it is already running).
   - Typical: `npm run dev` / `pnpm dev` / `vite`. Record the local URL (often `http://localhost:5173`).
   - If the project uses a build-and-serve flow instead of a dev server, document the exact commands you ran.
2. **Open the target route with `agent-browser`**, starting from the entry URL, not deep-linking into private pages unless you already have a valid session.
3. **Reproduce the current (pre-fix or pre-feature) behavior.** Capture: route, user action, observed outcome, console errors if any. This is the baseline.
4. **Apply the code change.** Rely on HMR where available; otherwise rebuild.
5. **Re-run the exact same flow in the browser.** Capture the new observed outcome.
6. **Check adjacent routes you touched** — if you edited a shared component or route guard, visit at least one other page that depends on it.
7. **Inspect the browser console for new warnings / errors** introduced by your change (React hydration mismatches, missing keys, uncaught promise rejections, CloudBase SDK init errors, etc.). New noise is a regression even if the happy path works.

## What to record in the final summary

For each flow you exercised, report:

- **Route** — e.g. `/login`, `/dashboard?tab=usage`
- **Action** — e.g. "Submitted the phone+code form with a valid code"
- **Expected** — e.g. "Redirect to `/dashboard` and show user's nickname"
- **Before** — e.g. "Stayed on `/login`; console showed `auth/invalid-session`"
- **After** — e.g. "Redirected to `/dashboard`; nickname rendered; no new console errors"
- **Gap (if any)** — e.g. "Did not test WeChat login branch because no test account available"

A one-liner like "tested in browser, works" is not acceptable evidence.

## Common CloudBase-specific flows worth validating

- **Auth**: sign-in page → success → protected route accessible; sign-out → same protected route redirects to `/login`.
- **AI model**: eligibility gate passes → `generateText` returns text → `streamText` incrementally updates UI → error path (invalid model name) surfaces a user-visible message, not a silent failure.
- **Database queries**: list page with pagination → empty state → after create, the new row appears without a hard refresh.
- **Static hosting deploy**: for a deployed build, confirm the root route, one sub-route (refresh directly on it — hash vs history matters), and one 404 route.

## Common mistakes to avoid

- Claiming a frontend bug is fixed without actually opening the browser.
- Verifying only the happy path when the reported bug is about empty states, validation errors, or route refresh.
- Catching and swallowing console errors instead of understanding them.
- Using `agent-browser` for aesthetic / visual direction work that should have gone through `ui-design`.
- Skipping the adjacent-routes check after editing a shared component or route guard.
- Using an old cached dev-server instance after a config change — restart the dev server if you modified `vite.config.*`, env vars, or TS path aliases.

## Escalation

If you cannot complete browser validation because of missing credentials, a missing backend, a paid external API, or a blocker in the local environment, do not paper over it. State exactly what you were unable to verify and what the user needs to supply. Partial verification with a named gap is acceptable; silent omission is not.

## frameworks

# Framework Guidance

## React

- Follow the existing router, data-fetching, and component patterns already used by the repo.
- Prefer focused page and component changes over broad refactors.
- Keep state close to where it is used unless the project already relies on shared state primitives.
- For form, navigation, and async UI bugs, verify the behavior in browser after code changes.

## Next.js

### SDK boundary

`@cloudbase/js-sdk` is a **browser-only** SDK. It must not be imported in Server Components, `getServerSideProps`, or API Routes.

- Auth flows (sign in, sign up, session check) → **Client Component only** (`"use client"`)
- API Routes / Route Handlers → use `@cloudbase/node-sdk` (Node.js SDK) for server-side token verification
- Server Components → read tokens from cookies/headers, do NOT import `@cloudbase/js-sdk`

### Auth pattern (App Router)

```tsx
// components/auth-guard.tsx — Client Component
"use client"

import { useEffect, useState } from "react"
import cloudbase from "@cloudbase/js-sdk"

const app = cloudbase.init({
  env: process.env.NEXT_PUBLIC_CLOUDBASE_ENV_ID!,
  region: process.env.NEXT_PUBLIC_CLOUDBASE_REGION || "ap-shanghai",
  accessKey: process.env.NEXT_PUBLIC_CLOUDBASE_ACCESS_KEY!,
  auth: { detectSessionInUrl: true },
})
const auth = app.auth

export function AuthGuard({ children }: { children: React.ReactNode }) {
  const [session, setSession] = useState<any>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    auth.getSession().then(({ data }) => {
      if (data?.session) {
        setSession(data.session)
        // Store access_token in cookie for API route verification
        document.cookie = `cloudbase_token=${data.session.access_token}; path=/; max-age=3600`
      }
      setLoading(false)
    })
  }, [])

  if (loading) return <div>Loading...</div>
  if (!session) return <div>Please sign in</div>
  return <>{children}</>
}
```

### Passing auth to API Routes

```tsx
// app/api/protected/route.ts — Server-side Route Handler
import { NextRequest, NextResponse } from "next/server"

export async function GET(request: NextRequest) {
  const token = request.cookies.get("cloudbase_token")?.value
  if (!token) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  }
  // Verify token with Node SDK or forward to your backend
  return NextResponse.json({ data: "protected resource" })
}
```

### Deployment

- Build output: `next build` → `.next` directory
- CloudBase static hosting expects `package.json` with build scripts and the output directory configured; prefer `manageApps` for deployment
- If deploying via `manageHosting`, set error document to `index.html` for client-side routing (even though Next.js defaults to file-based routing, fallback handling is needed for SPA-like paths)

## Vue

- Respect the existing composition style in the repo, such as Composition API or Options API.
- Keep template, script, and style responsibilities clear instead of mixing unrelated logic into one large SFC.
- When changing reactive state or watchers, verify the actual rendered behavior rather than assuming the code path is enough.

## NestJS

### SDK choice

Use `@cloudbase/node-sdk` (Node.js SDK), **not** `@cloudbase/js-sdk` (which is browser-only).

### Module setup

```ts
// cloudbase.module.ts
import { Module, Global } from "@nestjs/common"
import tcb from "@cloudbase/node-sdk"

export const CLOUDBASE = "CLOUDBASE"

const cloudbaseProvider = {
  provide: CLOUDBASE,
  useFactory: () => {
    const app = tcb.init({
      env: process.env.CLOUDBASE_ENV_ID!,
      // credentials: require("/path/to/tcb_custom_login.json"), // only for custom login
    })
    return {
      app,
      auth: app.auth(),
      // db: app.database(), // for NoSQL
    }
  },
}

@Global()
@Module({
  providers: [cloudbaseProvider],
  exports: [cloudbaseProvider],
})

## rule

---
name: web-development
description: Use when users need to implement, integrate, debug, build, deploy, or validate a Web frontend after the product direction is already clear, especially for React, Vue, Vite, browser flows, or CloudBase Web integration.
version: 2.35.2
license: MIT
alwaysApply: false
---

## Sibling skills (local only)

Sibling CloudBase skills ship beside this skill. Use local relative paths such as `../auth-tool-cloudbase/SKILL.md`.

If a referenced sibling skill file is missing from this environment, ask the user to install the full CloudBase plugin (or the missing skill). Do **not** HTTP-fetch remote skill or protocol markdown into the agent context.

**Cross-cutting protocols** (required before code changes or deployments):
- Change Safety Protocol: `../cloudbase-platform/references/protocols/change-safety-protocol.md`
- Deployment Gate: `../cloudbase-platform/references/protocols/deployment-gate.md`

# Web Development

## Activation Contract

### Use this first when

- The request is to implement, integrate, debug, build, deploy, or validate a Web frontend or static site.
- The design direction is already decided, or the user is asking for engineering execution rather than visual exploration.
- The work involves React, Vue, Vite, routing, browser-based verification, or CloudBase Web integration.

### Read before writing code if

- The task includes project structure, framework conventions, build config, deployment, routing, or frontend test and validation flows.
- The request includes UI implementation but the visual direction is already fixed; otherwise read `ui-design` first.
- **⚠️ Any task involving interface styling, layout, color scheme, or font selection — before writing the first line of CSS/Tailwind, you MUST load the `ui-design` skill and output a Design Specification.** Skipping this step causes frontend styling to degrade to generic AI template defaults. The `ui-design` skill must be loaded before any visual implementation begins, not retroactively after the user complains about the appearance.

### Then also read

- General React / Vue / Vite guidance -> `frameworks.md`
- Browser flow checks or page validation -> `browser-testing.md`
- Login flow -> `../auth-tool-cloudbase/SKILL.md`, then `../auth-web-cloudbase/SKILL.md`
- Official Account JSAPI Pay, Native QR-code Pay, or WeChat OAuth on CloudBase -> `../cloudbase-wechat-integration/SKILL.md` (official docs: `https://docs.cloudbase.net/integration/introduce.md`)
- CloudBase database work -> matching database skill

### Do NOT use for

- Visual direction setting, prototype-first design work, or pure aesthetic exploration.
- Mini programs, native Apps, or backend-only services.
- WeChat payment or Official Account OAuth contract details; use `cloudbase-wechat-integration` after identifying the Web surface.

### Common mistakes / gotchas

- Starting implementation before clarifying whether the task is design or engineering execution.
- Mixing framework setup, deployment, and CloudBase integration concerns into one vague change.
- Treating cloud functions as the default solution for Web authentication.
- Skipping browser-level validation after a UI or routing change.
- **History mode SPA with CloudBase static hosting**: deploying a single-page app using History mode (React Router / Vue Router) without configuring the static hosting "404 error document" to `index.html`. This causes `NoSuchKey` / 404 errors when users refresh or directly visit any sub-route.
- In an existing application, detouring into UI redesign or broad repo sweeps before patching the current handlers and services.

## Engineering constitution (non-negotiable)

These rules override convenience. Treat them as a gate before saying "done".

### 1. TypeScript — do not silence the type system

- **Do NOT use `any` to bypass type errors.** Not `: any`, not `as any`, not `@ts-ignore`, not `@ts-nocheck`, not `@ts-expect-error` without a written justification. `any` propagates silently and defeats the only compile-time safety net this project has.
- When a type error appears, fix the root cause:
  - Missing / wrong library types → install `@types/...`, or narrow the import, or write a precise `interface` / `type` for the shape you actually use.
  - Shape is genuinely unknown at the boundary (JSON from an API, `postMessage` payload, `window.*` injection) → type it as `unknown` and narrow with a type guard (`typeof`, `in`, a discriminator field, or `zod` / equivalent).
  - Third-party type is wrong → augment via `declare module` in a local `.d.ts`, not `any`.
  - Truly dynamic case (e.g. generic event bus) → use a generic `<T>` with a constraint, not `any`.
- `unknown` + narrowing is the acceptable escape hatch. `any` is not.
- If you genuinely cannot avoid `any` for a specific line (extremely rare), leave a one-line comment with **why** and **what would remove it**, so reviewers can audit.
- The same spirit applies to ESLint: do not sprinkle `// eslint-disable` to mute the real signal. Fix the rule violation, or discuss before disabling.

### 2. Self-verify before claiming done

Before making any non-trivial code or configuration change, you must first follow the Change Safety Protocol in `cloudbase-platform/references/protocols/change-safety-protocol.md` (declare impact → user confirmation → post-edit verification).
Before any static hosting publish or custom domain work, complete the checks in `cloudbase-platform/references/protocols/deployment-gate.md`.

Saying "I've implemented it" / "fixed it" / "it should work" without evidence is not acceptable. Before declaring completion, you must actually run the checks and report the result.

**Static / build layer (always, when applicable):**

- `tsc --noEmit` (or `vue-tsc --noEmit`) passes cleanly — zero errors, zero suppressed diagnostics you added.
- `eslint` / project linter passes on changed files.
- The project's build command (`npm run build` / `pnpm build` / `vite build`) completes without new warnings that you introduced.
- The project's unit tests pass if they exist and cover the touched area.

**Runtime / browser layer (whenever the change affects rendering, routing, forms, auth, or async flows):**

- Use the **`agent-browser`** tool to actually open the page and reproduce the user-visible flow. Follow `browser-testing.md` for the concrete workflow.
- Confirm: the target route loads, the interaction you claim to have fixed behaves the way you claim, no new console errors are introduced, and no regression in the adjacent routes you touched.
- Record what you checked (route, action, expected result, actual result).

**Only after both layers pass** may you say the task is done. If either layer cannot be executed locally (e.g. blocked by credentials, missing backend, paid API), say so explicitly and list exactly which step is still unverified — do not gloss over it.

### 3. Do not paper over failures

- Do not wrap broken logic in `try { ... } catch {}` to make the error go away.
- Do not delete or skip a failing test to make CI green — fix it, or explain why the test is actually wrong and change the test with justification.
- Do not mark a task complete because "the code compiles". Compilation is the bare minimum, not the goal.

## When to use this skill

Use this skill for Web engineering work such as:

- Implementing React or Vue pages and components
- Setting up or maintaining Vite-based frontend projects
- Handling routing, data loading, forms, and build configuration
- Running browser-based validation and smoke checks
- Integrating CloudBase Web SDK and static hosting when the project needs CloudBase capabilities

**Do NOT use for:**
- UI direction or visual system design only; use `ui-design`
- Mini program development; use `miniprogram-development`
- Backend service implementation; use `cloudrun-development` or `cloud-functions`

## How to use this skill (for a coding agent)

1. **Clarify the execution surface**
   - Confirm whether the task is framework setup, page implementation, debugging, deployment, validation, or CloudBase integration.

