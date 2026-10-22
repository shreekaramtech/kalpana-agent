# Kalpana for AI agents

Let Claude, ChatGPT, Cursor or any MCP client design [Kalpana](https://kalpana.one) templates from a brief, then fill them from a list or spreadsheet and render personalized banners, ads and listing images in bulk.

This repository holds Kalpana's agent plugins, skills and client configuration for its two hosted MCP servers. It contains no credentials: every user signs in with their own Kalpana account.

| Server | URL | For |
| --- | --- | --- |
| Batch | `https://mcp.kalpana.one/mcp/batch` | Fill templates with data, render images and videos, fetch the results |
| Designer | `https://mcp.kalpana.one/mcp/designer` | Design and edit the templates themselves |

`https://mcp.kalpana.one/mcp` still serves the batch server for connections made before it moved.

## Install

**Claude Code**

```
/plugin marketplace add shreekaramtech/kalpana-agent
/plugin install kalpana-batch@kalpana
/plugin install kalpana-designer@kalpana
```

Or connect the servers alone:

```
claude mcp add --transport http kalpana https://mcp.kalpana.one/mcp/batch
claude mcp add --transport http kalpana-designer https://mcp.kalpana.one/mcp/designer
```

**Gemini CLI**

```
gemini extensions install https://github.com/shreekaramtech/kalpana-agent
```

**Skills only (Cursor, Windsurf, Codex and other agents that read skills)**

```
npx skills add shreekaramtech/kalpana-agent
```

**Claude, ChatGPT and other clients**

Add a custom connector with either URL above. The client opens Kalpana's sign-in page the first time it connects.

**Any MCP client (JSON config)**

```json
{
  "mcpServers": {
    "kalpana": {
      "type": "http",
      "url": "https://mcp.kalpana.one/mcp/batch"
    },
    "kalpana-designer": {
      "type": "http",
      "url": "https://mcp.kalpana.one/mcp/designer"
    }
  }
}
```

## Setup

1. Create a free account at [app.kalpana.one](https://app.kalpana.one/signup). New accounts get free render credits.
2. Add a template to a workspace, or let the designer make one.
3. Connect. Sign-in is OAuth: you choose the workspace the agent works in, and your role there decides what it can do. No API key is pasted anywhere. The designer needs an active Kalpana plan.

## What the agent can do

**Batch server (18 tools):** find templates and see their inputs (`search_templates`, `get_template_inputs`), find or add images (`list_asset_collections`, `search_assets`, `upload_images`, `inspect_image`), check rows before anything is created (`validate_batch`), create, edit, run and cancel batches (`create_batch`, `update_batch`, `update_job`, `run_batch`, `cancel_batch`, `cancel_job`), and follow them and fetch the results (`list_batches`, `get_batch`, `get_batch_jobs`, `get_batch_outputs`, `list_workspaces`). Running a batch spends render credits, always after the agent tells you the exact cost.

**Designer server (41 tools):** build layer trees with layout flows, text, shapes, images, charts and motion; measure text, colour and geometry exactly; check layouts and render previews; save the template with its input descriptions. The full list is at [docs.kalpana.one/mcp/designer-tools](https://docs.kalpana.one/mcp/designer-tools).

**Skills**

- `create-creative-batch`: find a template, map the user's data to its inputs, validate, create a draft, run it after confirming the credit cost, and share the results.
- `design-a-template`: gather a brief, follow the designer's guide, build in few calls, check the render, and save the template ready for batches.

## Layout

```
.claude-plugin/marketplace.json   lists both plugins (Claude Code marketplace)
plugins/kalpana-batch/            batch plugin: Claude and Codex manifests, server config, skill
plugins/kalpana-designer/         designer plugin: Claude and Codex manifests, server config, skill
skills/                           the skills (source; scripts/sync-skills.sh copies them into the plugins)
gemini-extension.json, GEMINI.md  Gemini CLI extension with both servers
registry/                         MCP Registry entries, one per server
glama.json                        Glama ownership
assets/                           logos
```

Edit skills in `skills/`, then run `./scripts/sync-skills.sh`. CI fails when a plugin's copy differs.

## Links

- Product: https://kalpana.one
- MCP servers: https://kalpana.one/mcp
- Setup docs: https://docs.kalpana.one/mcp/quickstart
- Support: support@kalpana.one
- Privacy: https://kalpana.one/privacy

## License

MIT
