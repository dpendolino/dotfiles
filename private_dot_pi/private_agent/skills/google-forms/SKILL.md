---
name: google-forms
description: Use this skill when the user mentions Google Forms, surveys, questionnaires, form responses, or collecting feedback. Triggers on terms like Google Forms, survey, form, questionnaire, responses, feedback form.
allowed-tools: [Bash, Read, Write, Glob, Grep]
---

# Google Forms

Work with Google Forms using the `gws` CLI.

## Prerequisites

If any `gws` command fails with "command not found", install it with `brew install googleworkspace-cli`. If it fails with an authentication error, run `gws auth login` in a real terminal (needs a browser; cannot run from inside pi).

## Command Reference

All commands output JSON by default. Add `--format table` for human-readable output. Use `gws schema forms.forms.get` (or any method name) to discover all available parameters.

### Get a form

```bash
gws forms forms get \
  --params '{"formId": "FORM_ID"}' 2>/dev/null
```

Returns the form structure including title, description, all questions (items), and settings.

### Create a form

```bash
gws forms forms create \
  --json '{"info": {"title": "Team Feedback Survey", "documentTitle": "Team Feedback Survey"}}' 2>/dev/null
```

Returns the new form metadata including `formId` and `responderUri` (the URL to share with respondents).

### Add or modify questions (batchUpdate)

All structural changes to a form use `batchUpdate`:

```bash
gws forms forms batchUpdate \
  --params '{"formId": "FORM_ID"}' \
  --json '{"requests": [REQUEST_LIST]}' 2>/dev/null
```

### Common batchUpdate requests

**Add a short text question:**
```json
{"createItem": {"item": {"title": "What is your name?", "questionItem": {"question": {"required": true, "textQuestion": {"paragraph": false}}}}, "location": {"index": 0}}}
```

**Add a multiple choice question:**
```json
{"createItem": {"item": {"title": "How would you rate this?", "questionItem": {"question": {"required": true, "choiceQuestion": {"type": "RADIO", "options": [{"value": "Excellent"}, {"value": "Good"}, {"value": "Fair"}, {"value": "Poor"}]}}}}, "location": {"index": 1}}}
```

Choice types: `RADIO` (single select), `CHECKBOX` (multi select), `DROP_DOWN`.

**Add a paragraph text question:**
```json
{"createItem": {"item": {"title": "Additional comments", "questionItem": {"question": {"required": false, "textQuestion": {"paragraph": true}}}}, "location": {"index": 2}}}
```

**Add a scale question:**
```json
{"createItem": {"item": {"title": "Rate your experience", "questionItem": {"question": {"required": true, "scaleQuestion": {"low": 1, "high": 5, "lowLabel": "Poor", "highLabel": "Excellent"}}}}, "location": {"index": 3}}}
```

**Update form description:**
```json
{"updateFormInfo": {"info": {"description": "Please complete this survey by end of week."}, "updateMask": "description"}}
```

**Delete an item:**
```json
{"deleteItem": {"location": {"index": 0}}}
```

**Move an item:**
```json
{"moveItem": {"originalLocation": {"index": 0}, "newLocation": {"index": 2}}}
```

### List form responses

```bash
gws forms forms responses list \
  --params '{"formId": "FORM_ID"}' 2>/dev/null
```

Returns all responses with timestamps and answer data. Each response contains `answers` keyed by question ID.

### Get a single response

```bash
gws forms forms responses get \
  --params '{"formId": "FORM_ID", "responseId": "RESPONSE_ID"}' 2>/dev/null
```

## Common Patterns

### Create a survey with multiple question types

```bash
FORM_ID=$(gws forms forms create \
  --json '{"info": {"title": "Sprint Retrospective", "documentTitle": "Sprint Retrospective"}}' 2>/dev/null \
  | jq -r '.formId')

gws forms forms batchUpdate \
  --params "{\"formId\": \"$FORM_ID\"}" \
  --json '{"requests": [
    {"createItem": {"item": {"title": "What went well?", "questionItem": {"question": {"required": true, "textQuestion": {"paragraph": true}}}}, "location": {"index": 0}}},
    {"createItem": {"item": {"title": "What could be improved?", "questionItem": {"question": {"required": true, "textQuestion": {"paragraph": true}}}}, "location": {"index": 1}}},
    {"createItem": {"item": {"title": "Sprint rating", "questionItem": {"question": {"required": true, "scaleQuestion": {"low": 1, "high": 5, "lowLabel": "Poor", "highLabel": "Excellent"}}}}, "location": {"index": 2}}}
  ]}' 2>/dev/null

echo "Form: https://docs.google.com/forms/d/$FORM_ID/edit"
```

### Map question IDs to titles

```bash
gws forms forms get --params '{"formId": "FORM_ID"}' 2>/dev/null \
  | jq -r '"Form: \(.info.title // "Untitled")",
    (.items[]? | "  [\(.questionItem.question.questionId // "n/a")] \(.title // "(no title)")")'
```

## Execution Instructions

When the user asks to work with Google Forms:

1. Identify the form ID from the URL. The ID is the long string between `/d/` and `/edit` or `/viewform`.
2. Use `gws forms` commands via bash to perform the operation.
3. When reading forms, present the structure clearly with question titles and types.
4. When reading responses, map question IDs to titles using the form structure for readable output.
5. When creating or editing forms, provide the form URL in the output.
6. Share the responder URL (`responderUri` from the form object) when the user wants to distribute the form.

$ARGUMENTS
