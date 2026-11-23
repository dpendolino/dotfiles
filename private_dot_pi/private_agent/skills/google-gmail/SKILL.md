---
name: google-gmail
description: Use this skill when the user mentions Gmail, email, inbox, sending or replying to messages, or checking unread mail. Triggers on terms like email, inbox, send an email, reply, forward, unread, Gmail.
allowed-tools: [Bash, Read, Write, Glob, Grep]
---

# Gmail

Work with Gmail using the `gws` CLI.

## Prerequisites

If any `gws` command fails with "command not found", install it with `brew install googleworkspace-cli`. If it fails with an authentication error (including a scope error — Gmail scopes are not granted by default), run `gws auth login --scopes "https://www.googleapis.com/auth/gmail.modify,https://www.googleapis.com/auth/gmail.send"` in a real terminal (needs a browser; cannot run from inside pi). This re-auth is additive with Drive/Sheets/Calendar/Docs/Slides/Forms scopes already granted.

## Helpers (prefer these over raw API calls)

```bash
# Unread inbox summary
gws gmail +triage
gws gmail +triage --max 5 --query 'from:boss'
gws gmail +triage --format json | jq '.[].subject'

# Read a message
gws gmail +read --id MESSAGE_ID
gws gmail +read --id MESSAGE_ID --headers
gws gmail +read --id MESSAGE_ID --format json | jq '.body'

# Send
gws gmail +send --to alice@example.com --subject 'Hello' --body 'Hi Alice!'
gws gmail +send --to alice@example.com --subject 'Report' --body 'See attached' -a report.pdf
gws gmail +send --to alice@example.com --subject 'Draft' --body 'Hi!' --draft   # save as draft, do not send

# Reply (handles threading automatically)
gws gmail +reply --message-id MESSAGE_ID --body 'Thanks, got it!'
gws gmail +reply-all --message-id MESSAGE_ID --body 'Thanks all!'

# Forward
gws gmail +forward --message-id MESSAGE_ID --to dave@example.com --body 'FYI'
```

All helpers accept `--dry-run` to preview the request without sending, and `--html` to treat `--body` as an HTML fragment (no `<html>`/`<body>` wrapper needed).

## Raw API access

For anything the helpers don't cover (labels, threads, filters, search), use the `users` resource directly. Use `gws schema gmail.users.messages.list` (or any method name) to discover parameters.

```bash
# Search messages
gws gmail users messages list \
  --params '{"userId": "me", "q": "is:unread from:boss", "maxResults": 20}' 2>/dev/null

# Get raw message metadata
gws gmail users messages get \
  --params '{"userId": "me", "id": "MESSAGE_ID", "format": "metadata"}' 2>/dev/null

# List labels
gws gmail users labels list --params '{"userId": "me"}' 2>/dev/null
```

## Execution Instructions

When the user asks to work with Gmail:

1. Prefer `+triage`, `+read`, `+send`, `+reply`, `+reply-all`, `+forward` — they handle MIME, threading, and quoting correctly.
2. **Always confirm recipients, subject, and body with the user before sending** — sending is irreversible. Use `--draft` if the user is unsure, or `--dry-run` to preview.
3. When reading/triaging, present sender, subject, date, and a short snippet — not the full raw payload.
4. If a command fails with a scope/permission error, tell the user to re-run `gws auth login` with the gmail scopes (see Prerequisites) in a real terminal — do not attempt to work around it.

$ARGUMENTS
