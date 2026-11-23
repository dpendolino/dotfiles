---
name: google-slides
description: Use this skill when the user mentions Google Slides, presentations, slide decks, or creating/editing slides. Triggers on terms like Google Slides, presentation, slide deck, slides, keynote alternative.
allowed-tools: [Bash, Read, Write, Glob, Grep]
---

# Google Slides

Work with Google Slides presentations using the `gws` CLI.

## Prerequisites

If any `gws` command fails with "command not found", install it with `brew install googleworkspace-cli`. If it fails with an authentication error, run `gws auth login` in a real terminal (needs a browser; cannot run from inside pi).

## Command Reference

All commands output JSON by default. Add `--format table` for human-readable output. Use `gws schema slides.presentations.get` (or any method name) to discover all available parameters.

### Get a presentation

```bash
gws slides presentations get \
  --params '{"presentationId": "PRESENTATION_ID"}' 2>/dev/null
```

Returns the full presentation structure including all slides, layouts, and masters.

### Get a specific page/slide

```bash
gws slides presentations pages get \
  --params '{"presentationId": "PRESENTATION_ID", "pageObjectId": "SLIDE_OBJECT_ID"}' 2>/dev/null
```

### Create a presentation

```bash
gws slides presentations create \
  --json '{"title": "Q2 Review"}' 2>/dev/null
```

Returns the new presentation metadata including `presentationId`.

### Modify a presentation (batchUpdate)

All slide modifications use `batchUpdate`:

```bash
gws slides presentations batchUpdate \
  --params '{"presentationId": "PRESENTATION_ID"}' \
  --json '{"requests": [REQUEST_LIST]}' 2>/dev/null
```

### Common batchUpdate requests

**Add a slide:**
```json
{"createSlide": {"slideLayoutReference": {"predefinedLayout": "TITLE_AND_BODY"}, "insertionIndex": 1}}
```

Layouts: `BLANK`, `TITLE`, `TITLE_AND_BODY`, `TITLE_AND_TWO_COLUMNS`, `TITLE_ONLY`, `SECTION_HEADER`, `MAIN_POINT`, `BIG_NUMBER`.

**Delete a slide:**
```json
{"deleteObject": {"objectId": "SLIDE_OBJECT_ID"}}
```

**Duplicate a slide:**
```json
{"duplicateObject": {"objectId": "SLIDE_OBJECT_ID"}}
```

**Replace text across all slides:**
```json
{"replaceAllText": {"containsText": {"text": "{{QUARTER}}", "matchCase": true}, "replaceText": "Q2 2026"}}
```

**Insert text into a shape:**
```json
{"insertText": {"objectId": "SHAPE_ID", "text": "Key Findings", "insertionIndex": 0}}
```

**Create a text box:**
```json
{"createShape": {"shapeType": "TEXT_BOX", "elementProperties": {"pageObjectId": "SLIDE_ID", "size": {"width": {"magnitude": 400, "unit": "PT"}, "height": {"magnitude": 50, "unit": "PT"}}, "transform": {"scaleX": 1, "scaleY": 1, "translateX": 100, "translateY": 100, "unit": "PT"}}}}
```

**Insert an image:**
```json
{"createImage": {"url": "https://example.com/chart.png", "elementProperties": {"pageObjectId": "SLIDE_ID", "size": {"width": {"magnitude": 600, "unit": "PT"}, "height": {"magnitude": 300, "unit": "PT"}}, "transform": {"scaleX": 1, "scaleY": 1, "translateX": 50, "translateY": 200, "unit": "PT"}}}}
```

**Replace shapes with an image:**
```json
{"replaceAllShapesWithImage": {"containsText": {"text": "{{LOGO}}", "matchCase": true}, "imageUrl": "https://example.com/logo.png", "imageReplaceMethod": "CENTER_INSIDE"}}
```

## Common Patterns

### Inspect slide structure

```bash
gws slides presentations get --params '{"presentationId": "PRESENTATION_ID"}' 2>/dev/null \
  | jq -r '"Title: \(.title)",
    (.slides | to_entries[] |
      "\nSlide \(.key + 1) (ID: \(.value.objectId))",
      (.value.pageElements[]? | select(.shape.text) |
        "  \(.objectId): \([.shape.text.textElements[]? | select(.textRun) | .textRun.content] | join("") | gsub("\n"; "") | .[0:80])"))'
```

### Populate a template

```bash
# Copy template via Drive first
COPY_ID=$(gws drive files copy \
  --params '{"fileId": "TEMPLATE_PRES_ID"}' \
  --json '{"name": "Client Proposal: Acme"}' 2>/dev/null \
  | jq -r '.id')

# Replace all placeholders
gws slides presentations batchUpdate \
  --params "{\"presentationId\": \"$COPY_ID\"}" \
  --json '{"requests": [
    {"replaceAllText": {"containsText": {"text": "{{CLIENT}}", "matchCase": true}, "replaceText": "Acme Corporation"}},
    {"replaceAllText": {"containsText": {"text": "{{DATE}}", "matchCase": true}, "replaceText": "2026-04-23"}},
    {"replaceAllText": {"containsText": {"text": "{{PRICE}}", "matchCase": true}, "replaceText": "$50,000"}}
  ]}' 2>/dev/null

echo "Proposal: https://docs.google.com/presentation/d/$COPY_ID/edit"
```

## Execution Instructions

When the user asks to work with Google Slides:

1. Identify the presentation ID from the URL. The ID is the long string between `/d/` and `/edit`.
2. Use `gws slides` commands via bash to perform the operation.
3. When inspecting presentations, describe the slide structure and content clearly.
4. When creating or editing presentations, provide the presentation URL in the output.
5. For template-based workflows, use `gws drive files copy` first, then modify the copy.

$ARGUMENTS
