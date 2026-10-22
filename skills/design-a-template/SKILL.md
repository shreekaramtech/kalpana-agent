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

Calls are paid from the workspace's render credits; the guide, maths and measuring tools are free. Fewer, larger calls cost less.

## 4. Check before you finish

- Fix every `layout_issues` entry an edit returns.
- Run `check_layout`, then look at a preview (`preview: true` on the last edit, or `render_design`, zoomed with `node_id` for small text). Confirm a reported problem in the picture before changing the design.
- Try the longest copy you expect in the text layers, render, then put the sample copy back.
- For other sizes, `duplicate` the finished page with the new width and height, render it, and change only what that size needs.

## 5. Save and hand over

- `set_template_info` last: a name, a one or two sentence description of the intent, audience and platforms, and a description per input with its length limit ("Headline: 2 lines, about 45 characters"). It saves every change.
- Give the user the template's link or id, and tell them they can fill it with data in the Kalpana app or through the batch connection.
- If a tool or the guide got in the way, call `send_feedback` with what happened and what would have helped. Leave out the user's content (copy, names, images, brand details). Skip it when nothing got in the way.

## When something goes wrong

- `undo` reverts the latest change of a design.
- "was changed in Kalpana": someone edited it in the app. Read it with `get_design` before the next change.
- "needs an active subscription" or "need render credits": tell the user where to fix it in Kalpana and stop.
- A connection covers one workspace. If the user names another, ask them to reconnect and choose it.
