---
name: google-sheets
description: Use this skill when the user mentions Google Sheets, spreadsheets, reading or writing cells, appending rows, or working with tabular data in Google Sheets. Triggers on terms like spreadsheet, sheet, cells, rows, columns, Google Sheets.
allowed-tools: [Bash, Read, Write, Glob, Grep]
---

# Google Sheets

Work with Google Sheets spreadsheets using the `gws` CLI.

## Prerequisites

If any `gws` command fails with "command not found", install it with `brew install googleworkspace-cli`. If it fails with an authentication error, run `gws auth login` in a real terminal (needs a browser; cannot run from inside pi).

## Command Reference

All commands output JSON by default. Add `--format table` for human-readable output. Filter stderr noise with `2>/dev/null` when piping to `jq`.

Use `gws schema sheets.spreadsheets.values.get` (or any method name) to discover all available parameters.

### Read values from a range

```bash
gws sheets spreadsheets values get \
  --params '{"spreadsheetId": "SPREADSHEET_ID", "range": "Sheet1!A1:Z100"}' 2>/dev/null
```

Returns `{"range": "...", "majorDimension": "ROWS", "values": [["header1", ...], ["val1", ...], ...]}`.

Optional parameters: `valueRenderOption` (`FORMATTED_VALUE`, `UNFORMATTED_VALUE`, `FORMULA`), `dateTimeRenderOption`.

### Read multiple ranges at once

```bash
gws sheets spreadsheets values batchGet \
  --params '{"spreadsheetId": "SPREADSHEET_ID", "ranges": ["Sheet1!A1:D10", "Sheet2!A1:B5"]}' 2>/dev/null
```

### Write values to a range

```bash
gws sheets spreadsheets values update \
  --params '{"spreadsheetId": "SPREADSHEET_ID", "range": "Sheet1!A1", "valueInputOption": "USER_ENTERED"}' \
  --json '{"values": [["Name", "Email"], ["Alice", "alice@example.com"]]}' 2>/dev/null
```

`valueInputOption`: `USER_ENTERED` (parses formulas and dates) or `RAW` (stores as-is).

### Append rows after existing data

```bash
gws sheets spreadsheets values append \
  --params '{"spreadsheetId": "SPREADSHEET_ID", "range": "Sheet1!A:Z", "valueInputOption": "USER_ENTERED"}' \
  --json '{"values": [["Bob", "bob@example.com", "Designer"]]}' 2>/dev/null
```

### Write to multiple ranges at once

```bash
gws sheets spreadsheets values batchUpdate \
  --params '{"spreadsheetId": "SPREADSHEET_ID"}' \
  --json '{"valueInputOption": "USER_ENTERED", "data": [{"range": "Sheet1!A1:B1", "values": [["Name", "Score"]]}, {"range": "Sheet1!A2:B2", "values": [["Alice", 95]]}]}' 2>/dev/null
```

### Clear a range

```bash
gws sheets spreadsheets values clear \
  --params '{"spreadsheetId": "SPREADSHEET_ID", "range": "Sheet1!B2:D10"}' 2>/dev/null
```

### Get spreadsheet metadata

```bash
gws sheets spreadsheets get \
  --params '{"spreadsheetId": "SPREADSHEET_ID"}' 2>/dev/null
```

Returns title, sheet names, and properties. Add `"includeGridData": true` to get cell data.

### Create a spreadsheet

```bash
gws sheets spreadsheets create \
  --json '{"properties": {"title": "Q1 Report"}, "sheets": [{"properties": {"title": "Revenue"}}, {"properties": {"title": "Expenses"}}]}' 2>/dev/null
```

### Structural changes (add/delete sheets, formatting)

Use `batchUpdate` for operations beyond reading and writing values:

```bash
gws sheets spreadsheets batchUpdate \
  --params '{"spreadsheetId": "SPREADSHEET_ID"}' \
  --json '{"requests": [{"addSheet": {"properties": {"title": "Summary"}}}]}' 2>/dev/null
```

## Helpers

```bash
# Quick read
gws sheets +read --spreadsheet SPREADSHEET_ID --range "Sheet1!A1:D10"

# Quick read as table
gws sheets +read --spreadsheet SPREADSHEET_ID --range "Sheet1!A1:D10" --format table

# Append a single row (comma-separated values)
gws sheets +append --spreadsheet SPREADSHEET_ID --values 'Alice,100,true'

# Append multiple rows (JSON array)
gws sheets +append --spreadsheet SPREADSHEET_ID --json-values '[["Alice", 100], ["Bob", 200]]'
```

## Execution Instructions

When the user asks to work with Google Sheets:

1. Identify the spreadsheet ID from the URL. The ID is the long string between `/d/` and `/edit`.
2. Prefer the `+read` and `+append` helpers for simple operations.
3. Use `gws sheets spreadsheets values` commands for advanced operations (batchGet, batchUpdate, clear).
4. Present tabular results as markdown tables when appropriate.
5. If the operation modifies data, confirm what was changed and provide the spreadsheet URL.
6. Sheets with special characters in the name (spaces, quotes) must be wrapped in single quotes inside the range string, e.g. `"range": "'My Sheet'!A1:Z100"`.

$ARGUMENTS
