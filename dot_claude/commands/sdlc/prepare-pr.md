# SDLC Prepare PR — Cleanup & PR Generation

Generate a comprehensive PR description and clean up the workspace for commit.

## Skills

Read skill definitions from `.claude/skills/sdlc/orchestrator/` as needed:

| Skill | File | Purpose |
|-------|------|---------|
| `prepare_pr` | `prepare_pr.md` | Generate PR description and validate all files |
| `cleanup_workspace` | `cleanup_workspace.md` | Remove temp files and duplicates before commit |

---

## Process

### Step 1: Run Validation

Execute `/sdlc:validate` checks first. If any check fails, report to user before proceeding.

### Step 2: Workspace Cleanup

Read `.claude/skills/sdlc/orchestrator/cleanup_workspace.md` for detailed cleanup logic.

**Always Remove:**
- `temp/` directory and all contents

**Conditional Remove:**
- `e2e/api/tests/*.json` — ONLY if ALL tests exist in `terraform/modules/runscope/tests/`
- `terraform/modules/datadog-monitors/lambda-datadog/main.tf` — ONLY if empty or only contains provider block

### Step 3: Generate PR Description

Read `.claude/skills/sdlc/orchestrator/prepare_pr.md` for detailed PR generation logic.

Collect all changed files via `Bash` (`git status --porcelain`), categorize them, and generate a PR description.

### Step 4: Output Results

Print the cleanup report and PR description. Proceed without waiting for confirmation.

---

## Output

```markdown
## Cleanup Report
- Directories removed: {list}
- Files removed: {list}
- Files kept: {list}

## PR Description
{generated PR markdown}
```
