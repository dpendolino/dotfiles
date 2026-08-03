#!/usr/bin/env python3
"""
Check for unassigned ENGSEC support tickets in Jira.

Usage:
    PYTHONPATH="/Users/daniel.pendolino/.claude/plugins/marketplaces/ibotta/plugins/atlassian-api/src" \
    uv run --with requests python3 ~/.claude/scripts/check-engsec-support.py
"""

import sys
from datetime import datetime, timedelta

try:
    from atlassian import JiraClient, AtlassianConfig
except ImportError:
    print("❌ Error: atlassian module not found.")
    print("Make sure PYTHONPATH is set correctly:")
    print('  PYTHONPATH="/Users/daniel.pendolino/.claude/plugins/marketplaces/ibotta/plugins/atlassian-api/src"')
    sys.exit(1)

def main():
    config = AtlassianConfig.from_env()
    jira = JiraClient(config)

    # Search for unassigned support tickets
    jql = '''project = ENGSEC
        AND labels = support
        AND status not in (Done, Closed, Resolved, "Won't Do")
        AND assignee is EMPTY
        ORDER BY created DESC'''

    print("🎫 ENGSEC Unassigned Support Tickets\n")
    print("="*100)

    try:
        result = jira.search_issues(
            jql,
            fields=["summary", "status", "priority", "created", "updated",
                    "issuetype", "reporter", "description"],
            max_results=50
        )

        total = result.get('total', 0)
        issues = result.get('issues', [])

        if total == 0:
            print("\n✅ No unassigned support tickets! Queue is clear.\n")
        else:
            print(f"\n⚠️  Found {total} unassigned support ticket(s):\n")

            # Calculate "new" threshold (last 7 days)
            seven_days_ago = datetime.utcnow() - timedelta(days=7)

            for issue in issues:
                key = issue['key']
                fields = issue['fields']

                summary = fields.get('summary', 'No summary')
                status = fields.get('status', {}).get('name', 'Unknown')
                priority = fields.get('priority', {}).get('name', 'None') if fields.get('priority') else 'None'
                issue_type = fields.get('issuetype', {}).get('name', 'Unknown')
                created = fields.get('created', '')
                created_date = created[:10] if created else 'Unknown'
                updated_date = fields.get('updated', '')[:10] if fields.get('updated') else 'Unknown'

                reporter = fields.get('reporter')
                reporter_name = reporter.get('displayName', 'Unknown') if reporter else 'Unknown'

                # Check if ticket is "new" (created in last 7 days)
                is_new = False
                if created:
                    created_dt = datetime.fromisoformat(created.replace('Z', '+00:00'))
                    is_new = created_dt.replace(tzinfo=None) > seven_days_ago

                new_badge = "🆕 " if is_new else ""

                # Extract description snippet
                description = fields.get('description', {})
                desc_snippet = ""
                if description and isinstance(description, dict):
                    content = description.get('content', [])
                    for block in content:
                        if block.get('type') == 'paragraph':
                            for item in block.get('content', []):
                                if item.get('type') == 'text':
                                    text = item.get('text', '').strip()
                                    if text:
                                        desc_snippet = text[:150]
                                        break
                        if desc_snippet:
                            break

                print(f"{new_badge}[{key}] {summary}")
                print(f"  Type: {issue_type} | Status: {status} | Priority: {priority}")
                print(f"  Reporter: {reporter_name}")
                print(f"  Created: {created_date} | Updated: {updated_date}")
                if desc_snippet:
                    print(f"  Description: {desc_snippet}...")
                print(f"  Link: https://ibotta.atlassian.net/browse/{key}")
                print()

            if total > 50:
                print(f"(Showing first 50 of {total} results)")

        print("="*100)

    except Exception as e:
        print(f"❌ Error searching Jira: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == '__main__':
    main()
