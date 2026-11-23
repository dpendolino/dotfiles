---
name: google-drive
description: Use this skill when the user mentions Google Drive, files, folders, uploading, downloading, sharing, or file management. Triggers on terms like Google Drive, files, folders, upload, download, share, file management.
allowed-tools: [Bash, Read, Write, Glob, Grep]
---

# Google Drive

Work with Google Drive files and folders using the `gws` CLI.

## Prerequisites

If any `gws` command fails with "command not found", install it with `brew install googleworkspace-cli`. If it fails with an authentication error, run `gws auth login` in a real terminal (needs a browser; cannot run from inside pi).

## Command Reference

All commands output JSON by default. Add `--format table` for human-readable output. Use `gws schema drive.files.list` (or any method name) to discover all available parameters.

### List files

```bash
gws drive files list \
  --params '{"pageSize": 10, "fields": "files(id, name, mimeType, createdTime, modifiedTime, parents)"}' 2>/dev/null
```

### Search files

```bash
# By name
gws drive files list \
  --params '{"q": "name contains '\''budget'\''", "pageSize": 20}' 2>/dev/null

# By MIME type (spreadsheets only)
gws drive files list \
  --params '{"q": "mimeType = '\''application/vnd.google-apps.spreadsheet'\''", "pageSize": 20}' 2>/dev/null

# In a specific folder
gws drive files list \
  --params '{"q": "'\''FOLDER_ID'\'' in parents", "pageSize": 20}' 2>/dev/null
```

### Get file metadata

```bash
gws drive files get \
  --params '{"fileId": "FILE_ID", "fields": "*"}' 2>/dev/null
```

### Download a file

```bash
gws drive files download \
  --params '{"fileId": "FILE_ID"}' --output /tmp/downloaded_file 2>/dev/null
```

### Export a Google Workspace file

Export Google Docs, Sheets, or Slides to other formats:

```bash
# Export Doc as PDF
gws drive files export \
  --params '{"fileId": "DOC_ID", "mimeType": "application/pdf"}' --output /tmp/document.pdf 2>/dev/null

# Export Sheet as CSV
gws drive files export \
  --params '{"fileId": "SHEET_ID", "mimeType": "text/csv"}' --output /tmp/data.csv 2>/dev/null
```

### Upload a file

```bash
# Upload using the helper (simplest)
gws drive +upload /tmp/report.txt --parent FOLDER_ID

# Upload with a custom name
gws drive +upload /tmp/report.txt --name "Q2 Report.txt" --parent FOLDER_ID

# Or use the API directly
gws drive files create \
  --json '{"name": "Report.txt", "parents": ["FOLDER_ID"]}' \
  --upload /tmp/report.txt 2>/dev/null
```

### Create a folder

```bash
gws drive files create \
  --json '{"name": "Q2 Reports", "mimeType": "application/vnd.google-apps.folder"}' 2>/dev/null
```

To create inside a specific parent folder, add `"parents": ["PARENT_FOLDER_ID"]`.

### Copy a file

```bash
gws drive files copy \
  --params '{"fileId": "SOURCE_FILE_ID"}' \
  --json '{"name": "Copy of Document", "parents": ["DEST_FOLDER_ID"]}' 2>/dev/null
```

### Move a file

Moving requires updating the file's parents:

```bash
gws drive files update \
  --params '{"fileId": "FILE_ID", "addParents": "NEW_FOLDER_ID", "removeParents": "OLD_FOLDER_ID"}' 2>/dev/null
```

### Delete a file

```bash
gws drive files delete \
  --params '{"fileId": "FILE_ID"}' 2>/dev/null
```

### Share a file

```bash
gws drive permissions create \
  --params '{"fileId": "FILE_ID"}' \
  --json '{"type": "user", "role": "reader", "emailAddress": "colleague@example.com"}' 2>/dev/null
```

Roles: `reader`, `writer`, `commenter`. Types: `user`, `group`, `domain`, `anyone`.

## MIME Type Reference

| Type | MIME Type |
|------|-----------|
| Folder | `application/vnd.google-apps.folder` |
| Google Doc | `application/vnd.google-apps.document` |
| Google Sheet | `application/vnd.google-apps.spreadsheet` |
| Google Slides | `application/vnd.google-apps.presentation` |

## Common Patterns

### Create a folder and capture its ID

```bash
FOLDER_ID=$(gws drive files create \
  --json '{"name": "2026 Reports", "mimeType": "application/vnd.google-apps.folder"}' 2>/dev/null \
  | jq -r '.id')
```

### Search and list files as a table

```bash
gws drive files list \
  --params '{"q": "name contains '\''report'\'' and name contains '\''2026'\''", "pageSize": 50}' \
  --format table 2>/dev/null
```

## Execution Instructions

When the user asks to work with Google Drive:

1. Determine the operation: listing, searching, uploading, downloading, sharing, or organizing files.
2. Prefer the `+upload` helper for file uploads — it auto-detects MIME type.
3. Use `gws drive` commands via bash for all other operations.
4. When listing files, format results as a clean table with name, type, and modified date.
5. When uploading or creating files, provide the file URL or ID in the output.
6. For delete operations, confirm with the user before executing.
7. For file uploads, write content to `/tmp/` first, then upload.

$ARGUMENTS
