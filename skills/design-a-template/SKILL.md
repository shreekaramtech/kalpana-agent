---
name: design-a-template
description: >-
  Use whenever the user wants Kalpana to design or change a template: a social post, banner, ad, carousel, slide or story, a new size of an existing design, or motion on a design. Covers gathering a brief, reading the designer's guide, building in few calls, checking the render, saving the template and handing it to the batch connection.
---

# Kalpana: designing templates

The Kalpana designer connection builds editable templates in the user's workspace. Every text and image layer becomes an input that batches fill later, so a good template works for any row, not just the sample. Filling templates with data and rendering images is the batch connection's job (`create-creative-batch`); a template's id is the same on both.

## 1. Brief first

Before the first layer, know:

- **Intent:** a casual post, awareness, a conversion ad, an event, an explainer or carousel. It decides how much copy and what the hero is.
- **Platforms and sizes:** feed 1080×1080 or 1080×1350, story 1080×1920, landscape 1920×1080 or 1200×628. One template with a page per size keeps a campaign together.
- **Brand:** name, logo, colours, fonts, tone. Use the workspace's own logos and product photos (`find_images`) and fonts (`list_fonts`).
- **Message:** the one thing the audience should take away, the copy and the call to action.

Take what the user already said; ask only for what this kind of work needs, in one short message. A quick post needs intent, size and brand, not an interview.

## 2. Read the guide

Call `design_guide` once before the first design. It is the source of truth for the model, layout flows, text sizing, naming, motion and what is free or paid. Follow it over anything here.

## 3. Build in few calls

1. `create_design` with the size and a name for the template.
2. One `create_layers` call for the whole layer tree, children nested under their frames, each layer given an id and a name that says what it holds ("Headline", "Product photo", "Price"). Those names become the batch columns.
3. Put a column layout flow on the page frame and let one part (usually the product) fill the space left, so longer copy or another size does not break the layout.
4. Fix in one `update_layers` call with a list of updates.
5. Carousels and series: one page per slide. Build the first, `duplicate` it into the same template (its page id once per copy), then change what every slide shares in one `update_layers` call with `page_ids` (up to 5 pages). The copies keep their layer ids; each page's result and preview come back in the reply.

Calls are paid from the workspace's render credits; the guide, maths and measuring tools are free. Fewer, larger calls cost less.

## 4. Check before you finish

- Fix every `layout_issues` entry an edit returns.
- Run `check_layout`, then look at a preview (`preview: true` on the last edit, or `render_design`, zoomed with `node_id` for small text). Confirm a reported problem in the picture before changing the design.
- Try the longest copy you expect in the text layers, render, then put the sample copy back.
- For other sizes, `duplicate` the finished page with the new width and height, render it, and change only what that size needs.

## Colour maths

Work colours out instead of guessing; do the sums in your head, in a scratch pad or with `calculate`.

- **Contrast (WCAG).** For each colour, turn every channel (0-255) into x = c/255, then linear = x <= 0.04045 ? x/12.92 : ((x + 0.055)/1.055)^2.4. Luminance L = 0.2126 R + 0.7152 G + 0.0722 B. Contrast = (lighter L + 0.05) / (darker L + 0.05), from 1 to 21. Body text needs 4.5 or more; large text (24px+, or 18.66px+ bold) needs 3.
- **Readable text on a colour.** Work out the contrast of white (L = 1) and of near-black (#111111, L ≈ 0.0056) on it and take the higher, or test the brand's own text colours the same way.
- **Shades and tints.** Mixing a colour toward another by t moves each channel: c + (target - c) × t. A tint mixes toward white (255), a shade toward black (0). For a 50-900 scale with the colour at 500, tint by 0.92, 0.84, 0.68, 0.5, 0.26 for 50-400 and shade by 0.14, 0.3, 0.46, 0.62 for 600-900.
- **When light text on a brand colour falls short**, use the brand's deeper shade of that colour rather than a new one.
- `check_layout` reports text whose contrast falls short in the design itself; confirm with `render_design`.

Example: white on #FF5A1F. Channels 255, 90, 31 give linear 1, 0.102, 0.0137, so L = 0.2126 + 0.0731 + 0.0010 = 0.287. Contrast with white = 1.05 / 0.337 = 3.1: fine for a 32px headline, too low for 16px body text, so use a deeper shade or dark text.

## 5. Save and hand over

- `set_template_info` last: a name, a one or two sentence description of the intent, audience and platforms, and a description per input with its length limit ("Headline: 2 lines, about 45 characters"). It saves every change.
- Give the user the template's link or id, and tell them they can fill it with data in the Kalpana app or through the batch connection.
- Feedback with `send_feedback`: when you hit a snag with a tool or the guide, send it then, while the details are fresh, with what happened and what would have helped. At the end, send anything else you have to report or suggest. Leave out the user's content (copy, names, images, brand details). Skip it when there is nothing to say.

## When something goes wrong

- `undo` reverts the latest change of a design.
- "was changed in Kalpana": someone edited it in the app. Read it with `get_design` before the next change.
- "needs an active subscription" or "need render credits": tell the user where to fix it in Kalpana and stop.
- A connection covers one workspace. If the user names another, ask them to reconnect and choose it.
