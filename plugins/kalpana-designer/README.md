# Kalpana Designer

Design editable [Kalpana](https://kalpana.one) templates from a brief: social posts, banners, ads, carousels and stories, with layout flows, text that fits, your fonts and images, charts and motion. Every template it makes is ready to fill with data in bulk through Kalpana Batch.

This plugin connects your agent to Kalpana's hosted designer server and adds the `design-a-template` skill, which guides the agent to:

1. Gather a short brief: the intent, the platforms and sizes, and the brand.
2. Read the designer's guide, then build the whole design in a few calls.
3. Check the layout and look at rendered previews before finishing.
4. Save the template with a description of each input and its length limit.

## What it connects to

- One remote MCP server: `https://mcp.kalpana.one/mcp/designer` (Streamable HTTP), run by Shreekaram Technologies, the makers of Kalpana.
- Sign-in is OAuth with your own Kalpana account. You choose one workspace when you connect, and your role in it decides what the agent can do. No API key or credential is stored in this plugin.
- The plugin runs nothing on your machine. It sends only the tool calls the agent makes (layers, text, image keys, the short description of each change) to Kalpana's server. Kalpana keeps a record of each tool call to run and improve the tools, as its privacy policy describes.

## Requirements

A Kalpana account at [app.kalpana.one](https://app.kalpana.one) with an active plan. Designer calls are paid from the workspace's render credits; the guide and measuring tools are free.

## Links

- Docs: https://docs.kalpana.one/mcp/designer
- Privacy policy: https://kalpana.one/privacy
- Support: support@kalpana.one

Licensed under the MIT License.
