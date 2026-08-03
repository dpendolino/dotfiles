#!/bin/bash
# Quick wrapper to check ENGSEC support tickets

PYTHONPATH="/Users/daniel.pendolino/.claude/plugins/marketplaces/ibotta/plugins/atlassian-api/src" \
uv run --with requests python3 ~/.claude/scripts/check-engsec-support.py "$@"
