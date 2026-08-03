---
name: engsec-support
description: Check for new unassigned ENGSEC support tickets
skill: engsec-support
---

Check for new, unassigned support tickets in the ENGSEC Jira project that need triage.

Searches for tickets with:
- Project: ENGSEC
- Label: support
- Status: Open (not Done/Closed/Resolved/Won't Do)
- Assignee: Empty (unassigned)

Displays results with new tickets (< 7 days old) highlighted.
