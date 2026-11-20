---
name: google-markdown-to-gdoc
description: Use this skill when the user wants to render a markdown file into a Google Doc using native styles, or update an already-rendered doc from a changed markdown source. Triggers on phrases like "render this markdown as a Google Doc", "format my plan as a doc", "update the doc from my MD", "convert markdown to a Google Doc with formatting", "publish this MD to a GDoc". Diff-based update preserves Drive comments on unchanged blocks.
allowed-tools: [Bash, Read, Write, Glob, Grep]
---

# Markdown → Google Doc

Render a markdown file into a Google Doc with native paragraph styles, lists, tables, and callout-style containers. On rerun, only the blocks whose markdown source changed get re-rendered — Drive comments anchored to unchanged blocks survive.

## Prerequisites

If the script's `gws` invocation fails with "command not found" or an authentication error, run `gws auth login` in a real terminal (needs a browser; cannot run from inside pi).

## When to use this skill vs. the `docs` skill

| Goal | Use |
|---|---|
| Insert one block, read one field, replace placeholder text | `docs` skill (raw `gws docs documents` calls) |
| Render a whole markdown file as a styled doc | **this skill** |
| Re-publish a markdown file into a doc, preserving comments | **this skill** (default mode does paragraph-level diff) |

## Invocation

The script lives at the installed plugin path:

```bash
python ~/.pi/agent/skills/google-markdown-to-gdoc/scripts/md_to_gdoc.py \
  --doc-id <GOOGLE_DOC_ID> \
  --markdown <path/to/file.md>
```

Flags:

| Flag | Behavior |
|---|---|
| `--doc-id <ID>` | The long string between `/d/` and `/edit` in the doc's URL. Required. |
| `--markdown <PATH>` | Path to the markdown source. Required. |
| `--rebuild` | Force a full clear-and-rebuild instead of diff-update. Use after major restructuring or when the doc's existing tags are stale. |
| `--dry-run` | Print the planned diff (replace/insert/delete counts per opcode) without sending any writes. Useful for previewing impact before a destructive rerun. |

The doc ID is the long string between `/d/` and `/edit` in the doc's URL.

## Supported markdown

- **Headings** — `#`, `##`, `###` → TITLE / HEADING_1 / HEADING_2 / HEADING_3. The first `#` is promoted to TITLE.
- **Paragraphs** with inline **bold**, *italic*, `inline code` (green Courier on light gray), `[labelled links](url)`, and autolinks `<https://...>` / `<mailto:...>`.
- **Unordered lists** (`- item` / `* item`) with visual nesting via 2-space indent.
- **Ordered lists** (`1. item`) with visual nesting. (Docs API can't set list `startNumber` post-creation, so a list that starts at `3.` will render as `1.`.)
- **Fenced code blocks** with optional language label.
- **Multi-line blockquotes** — each `> ` line is its own indented italic paragraph.
- **Horizontal rules** — rendered as a row of em-dashes (Docs API has no native HR element).
- **Tables** (`|...|...|` with a `|---|` divider row for header detection) — bold + shaded header row.
- **Container fences** `:::kind args` … `:::` with depth-tracked nesting:
  - `:::callout info|warning|note|success|error` — colored borderLeft + paragraph shading.
  - `:::checklist` — `BULLET_CHECKBOX` bullets; `[ ]` / `[x]` prefixes are stripped (Docs API doesn't expose checked state, items render unchecked).
  - `:::columns N` — wraps inner blocks in a `CONTINUOUS` section break with N-column layout. N is clamped to 2–4.
  - `:::toc` — placeholder paragraph (Docs API has no native TOC insertion).

## How update-in-place works

Each top-level block is hashed and tagged in the doc via a `mdgdoc:<hash>` namedRange after it's rendered. On rerun:

1. The script reads the doc's existing `namedRanges`.
2. It diffs the existing hash sequence against the new markdown's hash sequence using `difflib.SequenceMatcher`.
3. Only blocks whose hash changed get deleted and re-rendered (with a fresh namedRange).
4. Unchanged blocks are left untouched — Drive comments anchored to them survive.

If the doc has no `mdgdoc:` namedRanges (first run, or a doc the script has never touched), the script falls back to a full clear-and-rebuild and tags everything.

## What is a "block"?

A block is one top-level markdown element — a paragraph, heading, list, table, fenced code block, blockquote, horizontal rule, or `:::` container. Each block becomes a contiguous run of paragraphs in the doc and gets its own `mdgdoc:<hash>` namedRange covering that whole range.

Practically, when editing the live doc: text *inside* the paragraphs the script created is **inside a block** and is safe to edit. The empty paragraph between two rendered blocks (often what you get when you press Enter at the end of a section to start a new line) is **between blocks**. Use Google Docs' "Show non-printing characters" or the structure pane to make these boundaries visible if you're unsure.

## Known limitations

- Manual edits inside an unchanged tagged block are preserved on rerun. Content inserted *between* blocks (in the gap between two namedRanges — usually the blank line you add by hitting Enter at the end of a section) can be displaced or deleted when an adjacent block is replaced. Keep manual additions inside a block, not between them.
- Tables are populated cell-by-cell, one batchUpdate per cell. Fine for the small tables typical in plan docs; would be slow for large tables.
- The diff is content-based: any change to a block's source MD — even whitespace — re-renders that block and drops Drive comments anchored to its specific text. Comments anchored to *other* blocks survive.
- Nested list items get extra `indentStart` but keep the level-0 glyph (disc, `1.`, etc.). The Docs API treats `Bullet.nestingLevel` as output-only.
- Ordered lists always render starting at `1`. The leading number is parsed but ignored.
- `:::toc` emits a placeholder paragraph; the Docs API has no programmatic TOC insertion.

## Execution Instructions

When the user asks to render or update a Google Doc from a markdown file:

1. Identify the doc ID from the URL — the long string between `/d/` and `/edit`.
2. Confirm the markdown file exists and is readable before invoking the script.
3. If this is a rerun on an existing doc and the user has substantial edits in the doc itself, recommend `--dry-run` first so they can preview which blocks would be replaced.
4. Invoke the script with `--doc-id` and `--markdown` (add `--rebuild` only when explicitly requested or when the user says the existing doc structure is wrong).
5. Surface the doc URL in the output.
6. If the run output mentions specific replaced ranges and the user has comments on the doc, warn them that comments on the replaced blocks were dropped — comments on untouched blocks survive.

## Example: render a plan into a fresh doc

```bash
# Create a doc, then format a local markdown file into it.
DOC_ID=$(gws docs documents create --json '{"title": "Q3 Plan"}' 2>/dev/null \
  | jq -r '.documentId')

python ~/.pi/agent/skills/google-markdown-to-gdoc/scripts/md_to_gdoc.py \
  --doc-id "$DOC_ID" \
  --markdown ~/plans/q3.md

echo "Doc: https://docs.google.com/document/d/$DOC_ID/edit"
```

## Example: preview a rerun before applying

```bash
python ~/.pi/agent/skills/google-markdown-to-gdoc/scripts/md_to_gdoc.py \
  --doc-id "$DOC_ID" \
  --markdown ~/plans/q3.md \
  --dry-run
```

Output shows which blocks would be replaced, inserted, or deleted — no writes are sent.

## Example: force a clean rebuild

```bash
python ~/.pi/agent/skills/google-markdown-to-gdoc/scripts/md_to_gdoc.py \
  --doc-id "$DOC_ID" \
  --markdown ~/plans/q3.md \
  --rebuild
```

$ARGUMENTS
