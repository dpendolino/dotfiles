---
name: google-calendar
description: Use this skill when the user mentions Google Calendar, events, meetings, schedule, appointments, or wants to check availability. Triggers on terms like calendar, events, meetings, schedule, invite, recurring.
allowed-tools: [Bash, Read, Write, Glob, Grep]
---

# Google Calendar

Work with Google Calendar events using the `gws` CLI.

## Prerequisites

If any `gws` command fails with "command not found", install it with `brew install googleworkspace-cli`. If it fails with an authentication error, run `gws auth login` in a real terminal (needs a browser; cannot run from inside pi).

## Timezone

Derive the user's timezone from the current datetime injected at the start of the prompt. Use it for `timeMin`, `timeMax`, and event `timeZone` fields.

## Command Reference

All commands output JSON by default. Add `--format table` for human-readable output. Use `gws schema calendar.events.list` (or any method name) to discover all available parameters.

### List events

```bash
gws calendar events list \
  --params '{"calendarId": "primary", "maxResults": 10, "singleEvents": true, "orderBy": "startTime", "timeMin": "START_DATETIME", "timeMax": "END_DATETIME"}' 2>/dev/null
```

Key parameters:
- `calendarId`: `"primary"` for the user's main calendar, or a specific calendar ID
- `singleEvents`: `true` expands recurring events into individual instances
- `orderBy`: `"startTime"` (requires `singleEvents: true`) or `"updated"`
- `q`: text search filter

### Get a single event

```bash
gws calendar events get \
  --params '{"calendarId": "primary", "eventId": "EVENT_ID"}' 2>/dev/null
```

### Create an event

```bash
gws calendar events insert \
  --params '{"calendarId": "primary"}' \
  --json '{
    "summary": "Team Standup",
    "description": "Daily sync",
    "start": {"dateTime": "2026-04-24T09:00:00-06:00"},
    "end": {"dateTime": "2026-04-24T09:30:00-06:00"},
    "attendees": [{"email": "alice@example.com"}, {"email": "bob@example.com"}]
  }' 2>/dev/null
```

For all-day events, use `date` instead of `dateTime`: `"start": {"date": "2026-04-24"}`.

### Create a recurring event

```bash
gws calendar events insert \
  --params '{"calendarId": "primary"}' \
  --json '{
    "summary": "Weekly 1:1",
    "start": {"dateTime": "2026-04-28T14:00:00-06:00"},
    "end": {"dateTime": "2026-04-28T14:30:00-06:00"},
    "recurrence": ["RRULE:FREQ=WEEKLY;BYDAY=MO"],
    "attendees": [{"email": "manager@example.com"}]
  }' 2>/dev/null
```

### Update an event

```bash
gws calendar events patch \
  --params '{"calendarId": "primary", "eventId": "EVENT_ID"}' \
  --json '{"summary": "Updated Meeting Title", "description": "New description"}' 2>/dev/null
```

Use `patch` (not `update`) to send only the fields you want to change.

### Delete an event

```bash
gws calendar events delete \
  --params '{"calendarId": "primary", "eventId": "EVENT_ID"}' 2>/dev/null
```

### List calendars

```bash
gws calendar calendarList list 2>/dev/null
```

Returns all calendars accessible to the user with their IDs, names, and colors.

## Helpers

```bash
# Quick agenda view
gws calendar +agenda --today
gws calendar +agenda --tomorrow
gws calendar +agenda --week --format table

# Quick event creation (--end is required, there is no --duration flag)
gws calendar +insert --summary "Lunch" \
  --start "2026-04-24T12:00:00-06:00" \
  --end "2026-04-24T13:00:00-06:00"

# Add a Google Meet link
gws calendar +insert --summary "Review" \
  --start "2026-04-24T14:00:00-06:00" \
  --end "2026-04-24T14:30:00-06:00" \
  --attendee alice@example.com --meet
```

## Execution Instructions

When the user asks to work with Google Calendar:

1. Determine the date range or specific event the user is asking about.
2. Derive the timezone from the injected datetime at the start of the prompt.
3. Prefer the `+agenda` helper for read operations — it's simpler and handles timezone automatically.
4. Use `gws calendar events` commands for create, update, and delete operations.
5. Format events clearly with date, time, title, and attendees when displaying results.
6. When creating events, confirm the details before running if the user was vague about specifics.
7. For delete operations, confirm with the user before executing.

$ARGUMENTS
