# Kalpana Batch

Fill your [Kalpana](https://kalpana.one) templates from a list or spreadsheet and render personalized banners, ads, listing images and videos in bulk.

This plugin connects your agent to Kalpana's hosted batch server and adds the `create-creative-batch` skill, which walks the agent through the safe flow:

1. Find a template and read its inputs.
2. Turn the user's list, spreadsheet or message into rows keyed by layer name.
3. Check every row with `validate_batch` before anything is created.
4. Create a draft batch and state its exact credit cost.
5. Render it only after the user agrees to that cost, then share the finished files.

## What it connects to

- One remote MCP server: `https://mcp.kalpana.one/mcp/batch` (Streamable HTTP), run by Shreekaram Technologies, the makers of Kalpana.
- Sign-in is OAuth with your own Kalpana account. You choose one workspace when you connect, and your role in it decides what the agent can do. No API key or credential is stored in this plugin.
- The plugin runs nothing on your machine. It sends only the tool calls the agent makes (template ids, row values, image names) to Kalpana's server, and Kalpana's API does the work.

## Requirements

A Kalpana account at [app.kalpana.one](https://app.kalpana.one) with at least one template. Rendering spends the workspace's render credits; nothing renders until the user approves the stated cost.

## Links

- Docs: https://docs.kalpana.one/mcp/quickstart
- Privacy policy: https://kalpana.one/privacy
- Support: support@kalpana.one

Licensed under the MIT License.
