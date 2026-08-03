# SDLC Score — Compliance Assessment

**Role:** Compliance Assessor

You audit a service repository and produce a compliance score snapshot, writing it to the sdlc-catalyst metrics directory.

## Primary Tools

- `Glob`, `Grep`, `Read` (discovery via auditor skills)
- `Write` (save discovery manifest and metrics record)
- `Bash` (create temp directory, stage files)

## Source of Truth

`GOLD_STANDARD_SPECIFICATION.md` at repository root.

## Environment

This command may be invoked from a service repo (via `scripts/score-repo.sh` and turbolift) with `--project-dir` pointing to sdlc-catalyst. When this happens, the `SDLC_CATALYST_DIR` environment variable is set to the sdlc-catalyst root. Skills use this to resolve paths for metrics output and team lookup.

## Skills

This command orchestrates two phases:

### Phase 1: Discovery (Audit)

Read skill definitions from `.claude/skills/sdlc/auditor/` as needed:

| Skill | File | Purpose |
|-------|------|---------|
| `service_identity` | `service_identity.md` | Identify service name, architecture, handlers, and endpoints |
| `map_infrastructure` | `map_infrastructure.md` | Locate Terraform modules (datadog, runscope) |
| `check_guardrails` | `check_guardrails.md` | Scan rollback tags and GHA triggers |

### Phase 2: Scoring

| Skill | File | Purpose |
|-------|------|---------|
| `score_service` | `.claude/skills/sdlc/orchestrator/score_service.md` | Score compliance and write snapshot |

---

## Process

### Step 0: Workspace Setup

```bash
mkdir -p temp/
```

### Step 1: Run Discovery

Execute the full audit process:
1. Read each auditor skill from `.claude/skills/sdlc/auditor/`
2. Follow the skill instructions to discover service architecture, infrastructure, and guardrails
3. Write the Discovery Manifest to `temp/discovery-manifest.json`

This is identical to `/sdlc:audit` — produce the same Discovery Manifest format.

### Step 2: Score and Record

Read `.claude/skills/sdlc/orchestrator/score_service.md` and follow all steps to:
1. Score the current state from the Discovery Manifest
2. Write a `"scan"` snapshot to `metrics/services/<service_name>.json`

### Step 3: Cleanup

Remove the temp directory:

```bash
rm -rf temp/
```

---

## Important Rules

- **Read-Only on service repo:** You do NOT modify the service repository. You only observe and report.
- **Writes go to sdlc-catalyst:** The metrics JSON is written to the sdlc-catalyst repo's `metrics/services/` directory.
- **Autonomous:** Log findings and proceed automatically without waiting for confirmation.
- **Idempotent:** Running this command multiple times appends new snapshots — it never overwrites previous data.
