---
name: google-docs
description: Use this skill when the user mentions Google Docs, documents, creating or editing a document, or reading document content. Triggers on terms like Google Docs, document, doc, write document, read document.
allowed-tools: [Bash, Read, Write, Glob, Grep]
---

# Google Docs

Work with Google Docs documents using the `gws` CLI.

## Prerequisites

If any `gws` command fails with "command not found", install it with `brew install googleworkspace-cli`. If it fails with an authentication error, run `gws auth login` in a real terminal (needs a browser; cannot run from inside pi).

## Command Reference

All commands output JSON by default. Add `--format table` for human-readable output. Use `gws schema docs.documents.get` (or any method name) to discover all available parameters.

### Get a document

```bash
gws docs documents get \
  --params '{"documentId": "DOCUMENT_ID"}' 2>/dev/null
```

Returns the full document structure including title, body content, headers, footers, and tabs. The response is a large JSON object — pipe to `jq` to extract what you need.

### Extract plain text from a document

The API returns structured content, not plain text. Extract readable text with:

```bash
gws docs documents get --params '{"documentId": "DOCUMENT_ID"}' 2>/dev/null \
  | jq -r '
    if .tabs then
      .tabs[] |
      "--- Tab: \(.tabProperties.title // "Untitled") ---",
      ([.documentTab.body.content[]? | select(.paragraph) | .paragraph.elements[]? | select(.textRun) | .textRun.content] | join(""))
    else
      [.body.content[]? | select(.paragraph) | .paragraph.elements[]? | select(.textRun) | .textRun.content] | join("")
    end'
```

### Create a document

```bash
gws docs documents create \
  --json '{"title": "Meeting Notes 2026-04-23"}' 2>/dev/null
```

Returns the new document metadata including `documentId`.

### Modify a document (batchUpdate)

All document modifications (insert text, replace text, add images, tables, formatting) use `batchUpdate`:

```bash
gws docs documents batchUpdate \
  --params '{"documentId": "DOCUMENT_ID"}' \
  --json '{"requests": [{"insertText": {"location": {"index": 1}, "text": "Introduction\n\nThis document covers...\n"}}]}' 2>/dev/null
```

### Common batchUpdate requests

**Insert text at a position:**
```json
{"insertText": {"location": {"index": 1}, "text": "Hello World\n"}}
```

**Replace text throughout the document:**
```json
{"replaceAllText": {"containsText": {"text": "PLACEHOLDER", "matchCase": true}, "replaceText": "Actual Value"}}
```

**Insert a table:**
```json
{"insertTable": {"location": {"index": 1}, "rows": 3, "columns": 2}}
```

**Insert an image:**
```json
{"insertInlineImage": {"location": {"index": 1}, "uri": "https://example.com/image.png", "objectSize": {"width": {"magnitude": 200, "unit": "PT"}, "height": {"magnitude": 100, "unit": "PT"}}}}
```

**Bold text:**
```json
{"updateTextStyle": {"range": {"startIndex": 1, "endIndex": 12}, "textStyle": {"bold": true}, "fields": "bold"}}
```

## Helpers

```bash
# Append text to a document
gws docs +write --document DOCUMENT_ID --text "New paragraph text"
```

## Tab Support

Google Docs can have multiple tabs. The `get` response includes a `tabs` array. Always check for tabs when reading a document — content may be spread across them.

## Common Patterns

### Create a document with content

```bash
DOC_ID=$(gws docs documents create --json '{"title": "Project Proposal"}' 2>/dev/null \
  | jq -r '.documentId')

gws docs documents batchUpdate \
  --params "{\"documentId\": \"$DOC_ID\"}" \
  --json '{"requests": [{"insertText": {"location": {"index": 1}, "text": "Project Proposal\n\nOverview\n\nThis proposal outlines the requirements.\n"}}]}' 2>/dev/null

echo "Created: https://docs.google.com/document/d/$DOC_ID/edit"
```

### Replace placeholders in a template

```bash
gws docs documents batchUpdate \
  --params '{"documentId": "COPY_DOC_ID"}' \
  --json '{"requests": [
    {"replaceAllText": {"containsText": {"text": "{{CLIENT}}", "matchCase": true}, "replaceText": "Acme Corp"}},
    {"replaceAllText": {"containsText": {"text": "{{DATE}}", "matchCase": true}, "replaceText": "2026-04-23"}}
  ]}' 2>/dev/null
```

## Execution Instructions

When the user asks to work with Google Docs:

1. Identify the document ID from the URL. The ID is the long string between `/d/` and `/edit`.
2. **Always check for tabs** when reading a document — content may span multiple tabs.
3. Use `gws docs` commands via bash to perform the operation.
4. When reading documents, extract and present the text content in a readable format.
5. When creating or editing documents, provide the document URL in the output.
6. For complex formatting, use `batchUpdate` with multiple requests.

$ARGUMENTS
