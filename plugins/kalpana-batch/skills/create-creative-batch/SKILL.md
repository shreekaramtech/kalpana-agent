---
name: create-creative-batch
description: >-
  Use whenever the user wants to work with Kalpana: browse or find design templates, turn a list or spreadsheet into personalized images (one design per row), pick images from their asset library, or check on batches and download finished designs. Covers building renderer-ready rows, validating them, creating a batch, running it with credit confirmation, and handling access errors.
---

# Kalpana: templates to personalized designs

Kalpana turns one template into many designs: each **row** of a **batch** fills the template's inputs (text, images) and renders one image. You fill templates; you never edit designs.

This connection renders **images** (PNG, JPEG, WebP) and, from animated templates, **videos** (MP4, GIF): `create_batch` with `outputFormat` mp4 or gif renders each row's whole motion, and costs credits by the video's length and size. An animated template rendered as an image shows one moment of its motion (`stillTime`). Layout, font and design changes happen in the Kalpana app or through the Kalpana designer connection, not here; a template's ID is the same on both.

## Ground rules

- **One workspace per connection.** The user chose it when connecting, and every tool works in it; `get_workspace` shows which one, with the user's role and the domains image URLs may come from. If they name another workspace, or a tool asks them to reconnect, tell them to reconnect Kalpana and choose that workspace. Don't retry or work around it.
- **Their role limits what you can do.** If a tool says they lack permission, explain that their role in that workspace doesn't allow it (e.g. a Viewer can't create batches).
- **Confirm before changing anything.** Get a yes right before `create_batch`. Get a separate yes right before `run_batch`, and state the exact `creditCost` in that request.
- Never guess IDs. Use the IDs tools return.
- Download links expire. Don't present them as permanent.

## 1. Find the template

- "Show my templates" → `search_templates` with no `query` (most recently updated first).
- "Something for Diwali sale" → `search_templates` with `query`. Add `width`/`height` for a size ("Instagram story" = 1080×1920).
- Show a few options by name with their `previewUrl`, and their `openUrl` when the user wants to open one in Kalpana. To judge fit yourself, call `inspect_image` on the preview. If more than one is plausible, ask; don't pick silently.

## 2. Learn its inputs

Call `get_template_inputs`. If it reports that the template is animated, tell the user and share the link it gives; don't look for a workaround. Each input has a `key`, an `id`, a `label`, a `type` (`text` or `image`), an optional `defaultValue`, and image `dimensions`. `rowExample` is a whole ready row.

Rows are keyed by each input's **`key`**: the layer's name (case doesn't matter) or its id. Values are plain. Include only the inputs you're changing; anything left out keeps the template default.

```json
{ "Headline": "Flat 40% off", "Product photo": "red-sneaker.jpg" }
```

- Text: a string, or `{ "text": "…", "visible": false }`. Keep the user's exact wording, spelling, currency and locale.
- Styled text: when an input lists `styles` (s1, s2, ...), mark each run with its style, as in its `valueExample`: `"<s1>Flat</s1> <s2>40% off</s2>"`. Pick the style by its `sample` and colour (the accent is usually s2). Untagged text renders in s1.
- Image: a string that is an asset id, the image's file name (with or without extension) or a designer image key. The image must be in the **same workspace** as the template (see step 3).
- Hide a layer with `{ "visible": false }`.
- **Shared names:** when two layers have the same name, `get_template_inputs` gives each a `key` that is its id and marks it `sharedName: true`. A row using the shared name is refused with `ambiguous_layer` and both ids. Fill each layer by id, and tell the user that two layers share a name so they can rename one in Kalpana.

### Framing images

An image input fills a fixed slot (`dimensions`). You can control how the picture sits in it, just like the batch builder:

```json
{ "asset": "red-sneaker.jpg", "fit": "cover", "zoom": 1.3, "panX": 0, "panY": -0.1 }
```

- `fit`: `cover` fills the slot and crops the edges (default, best for photos). `contain` shows the whole image, leaving empty space (best for logos and product cut-outs). `stretch` distorts the image; avoid it unless asked.
- `zoom` (0.2–4, default 1) zooms about the slot centre. `panX`/`panY` (−1 to 1) move the image by a fraction of the slot; positive moves it right or down.
- Leave out `asset` to keep the template's own image and only reframe it.
- When you don't have a reason to reframe, send just the asset as a string and let the template's fit apply (`get_template_inputs` shows it as `fit`).
- Frame deliberately: compare the image's shape with the slot's `dimensions`, and after rendering check an output with `inspect_image`. If a face or product is cut off, adjust and create a corrected batch rather than guessing up front for every row.

## 3. Resolve images (only if an image input changes)

- "Use the summer collection" → `search_assets` with no filter lists every collection; then `search_assets` with `collection` set to its full name (ignoring case) or ID.
- "The red sneaker photo" → `search_assets` with `query` (matches filenames).
- "Show me my images" → `search_assets` with no filter (most recent first).
- Rows take an image's asset id or its file name, so a name you got from `search_assets` can go straight into a row. If two images share a file name the row is refused with `asset_ambiguous`; use the asset id.
- Confirm your picks by showing their previews or checking them with `inspect_image`, especially against the input's `dimensions`. A tall photo in a wide slot will crop; use `fit`, `zoom` and `panX`/`panY` (above) to fix it.
- An image that isn't in Kalpana yet: `upload_images` with no files gives a link for the user to drop it into (then `search_assets` finds it). If you hold the files yourself, pass `files`, PUT each to its `uploadUrl`, then call again with `done`; the reply gives each image's `id`, the asset id a row takes. Confirm before uploading.

## 4. Build rows from the user's data

- A pasted list, table or CSV becomes one row per entry. Map each column to an input by meaning (label and description), and state the mapping back briefly: "Name → headline, Price → price_tag".
- Ask about columns that match no input, and about inputs the user may want filled but gave no data for. Never invent values.
- Maximum 500 rows per batch. For more, split into batches and say so.
- For a sheet with many rows, send `columns` (the layer keys, like the sheet's header) and each row as an array of cells in that order; it keeps the request small. Put values that are the same on every row (a logo, a call to action) in `defaults` once. A `null` cell keeps the template's own value.

## 5. Validate, create, run

1. `validate_batch` with the rows. Fix the reported `issues` (by `rowIndex`, `field` and `code`), or ask the user for missing values. Repeat until valid. Check `rows` in the result: it shows each row as the server understood it, with images resolved to an asset id and file name. If `sharedNames` is present, tell the user which layer names are shared.
2. Summarize: template, workspace, row count, what changes versus stays default, and output format (png default; jpeg/webp on request). Get confirmation, then call `create_batch` with a clear `name`. This makes a draft; nothing renders and no credits are spent.
3. Tell the user the batch was created and its `creditCost`. Ask whether to start rendering. Only after an explicit yes, call `run_batch`.
   - Not enough credits: say so plainly and suggest topping up in Kalpana. The draft stays available to run later.

## 6. Status and results

- "How's my batch?" → `get_batch`. Report completed / failed / processing out of the total. Don't poll in a tight loop; check again when the user asks, or at most a few times with pauses.
- "What have I run lately?" → `list_batches` (filter by `templateId` if given).
- "Show me the results" → `get_batch_outputs` (paged, up to 20). Share the download links, and use `inspect_image` on one or two if the user wants you to review them. Report failed rows rather than hiding them.

## Privacy

Never ask for or reveal access tokens, scene JSON, or other people's batch data. If something isn't found, it may not exist or may be outside what this connection can see. Say that; don't try to get around it.
