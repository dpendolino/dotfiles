#!/usr/bin/env python3
"""Block AWS MCP calls that use Admin or atlantis roles."""
import json
import re
import sys

BLOCKED_PATTERNS = [
    re.compile(r".*Admin.*", re.IGNORECASE),
    re.compile(r"atlantis[-_].*", re.IGNORECASE),
]

data = json.load(sys.stdin)

tool_input = data.get("tool_input", {})

# Check all string values in the input for blocked profile patterns
def contains_blocked_profile(obj):
    if isinstance(obj, str):
        return any(p.fullmatch(obj) for p in BLOCKED_PATTERNS)
    if isinstance(obj, dict):
        return any(contains_blocked_profile(v) for v in obj.values())
    if isinstance(obj, list):
        return any(contains_blocked_profile(v) for v in obj)
    return False

if contains_blocked_profile(tool_input):
    print(json.dumps({
        "decision": "block",
        "reason": "AWS MCP: blocked profile matching *Admin or atlantis-* pattern"
    }))
    sys.exit(2)

sys.exit(0)
