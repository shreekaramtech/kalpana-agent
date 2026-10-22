# Kalpana One agent plugin

Let Claude, ChatGPT, Cursor or any MCP client design [Kalpana One](https://kalpana.one) templates from a brief, then fill them from a list or spreadsheet and render personalized banners, ads and listing images in bulk.

This repository holds the plugin, its skills and the client configuration for Kalpana One's two hosted MCP servers. It contains no credentials: every user signs in with their own Kalpana account.

| Server | URL | For |
| --- | --- | --- |
| Batch | `https://mcp.kalpana.one/mcp/batch` | Fill templates with data, render images and videos, fetch the results |
| Designer | `https://mcp.kalpana.one/mcp/designer` | Design and edit the templates themselves |

`https://mcp.kalpana.one/mcp` still serves the batch server for connections made before it moved.

## Install

**Claude Code**

```
/plugin marketplace add shreekaramtech/kalpana-one-agent
/plugin install kalpana-one@kalpana-one
```

Or connect the servers alone:

```
claude mcp add --transport http kalpana https://mcp.kalpana.one/mcp/batch
claude mcp add --transport http kalpana-designer https://mcp.kalpana.one/mcp/designer
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
.claude-plugin/plugin.json        Claude plugin manifest
.claude-plugin/marketplace.json   lets this repository act as its own Claude marketplace
.codex-plugin/plugin.json         Codex and ChatGPT plugin manifest
.mcp.json                         Claude Code server config (both hosted servers, OAuth)
plugin.json, mcp.json             agent-plugins.org manifest and config (Cursor; batch server)
skills/create-creative-batch/     filling templates with data
skills/design-a-template/         designing templates
assets/                           logos
```

## Links

- Product: https://kalpana.one
- MCP servers: https://kalpana.one/mcp
- Setup docs: https://docs.kalpana.one/mcp/quickstart
- Support: support@kalpana.one
- Privacy: https://kalpana.one/privacy

## License

MIT
