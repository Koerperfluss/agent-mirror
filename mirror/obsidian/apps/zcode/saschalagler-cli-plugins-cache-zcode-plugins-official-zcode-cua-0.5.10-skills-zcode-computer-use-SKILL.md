---
app: zcode
quelle: "saschalagler/cli/plugins/cache/zcode-plugins-official/zcode-cua/0.5.10/skills/zcode-computer-use/SKILL.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: zcode-computer-use
description: Main-agent-only desktop control through accessibility-first semantic actions with visual pixel fallback only when accessibility cannot reach the target.
---

# ZCode Computer Use

Main agent only. Never delegate Computer Use to a subagent.

## Core loop

Observe once, act once, then verify.

1. If readiness is unknown, call `request_access` once.
2. Resolve the app with `list_apps`; use `open_application` only when needed.
3. Call `get_app_state`. Start with the accessibility tree and no screenshot.
4. If the target has an accessibility element, use an element action. This is the primary path because it is semantic, precise, background-safe, and does not steal the user's focus.
5. Only when accessibility cannot locate or express the target, request a window
   screenshot or full screenshot and use a frame-bound coordinate action.
6. Prefer `return_state="compact"` when the action supports it. Otherwise observe
   again only when verification is required.

Do not run both the accessibility and visual workflows for the same action.
Do not activate or focus an app merely to make a semantic action work.
Honor tool capabilities and fail-closed results.

## Choose the target

There are two authoritative target forms:

- Element: `{"type":"element","state_id":"<state_id>","index":<index>}`
- Coordinate: `{"type":"coordinate","x":<x>,"y":<y>}`

Use an element target whenever the observed accessibility tree contains the
target. Use only an action advertised by the element.
Never translate image pixels into an element target.

Use a coordinate target only for a point chosen from the latest returned image.
Submit only `x` and `y`. Do not attach an `app_ref`, `state_id`, coordinate-space
name, or extra transform to it. An optional explicit `frame_id` exists only for
backward compatibility; never invent one.

### Frame-bound coordinates

Choose `x` and `y` only by looking at the current returned raster.
Submit those integers unchanged; CUA binds the current raster internally.
CUA owns every transform from the returned raster to native dispatch.

When visual fallback begins, discard coordinate-like numbers from earlier text or accessibility results.
They are not part of the visual task.

Act directly on the current raster when the target is clear.
Do not call `zoom` routinely.
Zoom is not part of the normal flow.
Use `zoom` only when the target is too small or ambiguous to select confidently.
For a Zoom result, choose the point in that returned child raster and submit only its pixels.

## Action strategy

- Accessibility element action is always preferred. It avoids focus changes and
  real-pointer movement.
- `strategy="a11y"` requires an accessibility action and fails closed otherwise.
- For a coordinate target, `strategy="auto"` may use an actionable accessibility
  hit first and otherwise follows the tool's declared fallback behavior.
- `strategy="event"` forces the raw coordinate path on tools that expose it. Use
  it only when accessibility cannot perform the intended action or the task
  explicitly requires visual pixel interaction.

On macOS, verified app/window-scoped raw dispatch is designed not to move the
real cursor or steal focus. Linux and Windows may require the target window to
be foreground for raw input. Never bypass a stale-frame, changed-owner,
occlusion, permission, or capability refusal.

A coordinate refusal may report that windows covering the point were skipped, or
name an owner other than the app you expected. Those windows are invisible
overlays belonging to the user's environment. Raise the window you meant to act on
with `open_application(activate=true, confirm_focus_steal=true)`, observe again,
and retry. Do not move, resize, or close the reported windows.

## Text and keyboard

Prefer `set_value` for editable elements. It is semantic and background-safe.
Use `select_text` and `perform_action` for element capabilities exposed by the
current state.

Never send targetless `type` or `key`; scope them with an element target or
`app_ref` as allowed by the tool schema. Preserve a returned `window_id` in
`app_ref` so the runtime can verify and retain window scope.
macOS uses `cmd`; Linux and Windows use `ctrl`.
Use `hold_key` for a duration; use `key` for a normal chord or repeated presses.

Platform app references:

- macOS: prefer `bundle_id`, otherwise `pid`.
- Windows: use AUMID in `bundle_id` for packaged apps; otherwise `name` or `pid`.
- Linux: use `name` or `pid`; do not invent a bundle id.

## Outcome and retry safety

`action_sent=true` means the action may already have happened. Never blindly
replay it. Retry a non-idempotent action only when `action_sent=false`.

Use returned post-state or a fresh `get_app_state` to verify the result. Old
`state_id` values become stale after an element write. When
`state_sync_status="refresh_required"`, call `get_app_state` before another
element write. A changed tree is not by itself proof that this action caused the
change; prefer target-specific verification fields when present.

Call `stop_computer_control` to stop the active control session. Do not continue
after the kill switch, denied access, or a non-retryable readiness result.

## Tool surface

Tool schemas are authoritative for arguments and supported strategies. The 30
tools are grouped as follows:

- Observe and resolve: `list_apps`, `open_application`, `list_windows`,
  `get_app_state`, `screenshot`, `zoom`, `list_displays`, `switch_display`,
  `cursor_position`
- Pointer: `left_click`, `double_click`, `triple_click`, `right_click`,
  `middle_click`, `scroll`, `left_click_drag`, `mouse_move`, `left_mouse_down`,
  `left_mouse_up`
- Text and keyboard: `type`, `set_value`, `select_text`, `key`, `hold_key`
- Semantic: `perform_action`
- Runtime: `request_access`, `stop_computer_control`, `wait`, `read_clipboard`,
  `write_clipboard`

Do not infer unsupported arguments from this guide. Read the live tool schema,
prefer the accessibility path, and use screenshot pixels only as the fallback.
