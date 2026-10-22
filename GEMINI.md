# Kalpana

Kalpana turns templates into finished creatives in bulk. This extension connects two hosted MCP servers:

- `kalpana-designer` designs and edits templates: layers, layout flows, text, images, charts and motion. It needs an active Kalpana plan.
- `kalpana-batch` fills templates with data and renders images and videos, one per row of a batch.

A template's id is the same on both.

## Signing in

Both servers answer an unauthenticated call with a 401 that points at their OAuth metadata, so Gemini CLI opens a browser the first time a tool runs. Sign in with your Kalpana account and choose the workspace the agent should work in. No API key is stored in this extension.

## How to work

- Designing: follow `skills/design-a-template/SKILL.md`. Read `design_guide` first, build in few calls, check the render, and finish with `set_template_info`.
- Filling: follow `skills/create-creative-batch/SKILL.md`. Read the template's inputs, check rows with `validate_batch`, create a draft, and run it only after the user agrees to the exact credit cost.
- Ask before anything that writes. Running a batch and most designer calls spend the workspace's render credits.
- If a tool says the user's role or plan does not allow something, tell the user and stop; do not retry.
