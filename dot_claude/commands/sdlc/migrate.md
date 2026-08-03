# SDLC Migrate — Full Orchestrated Workflow

**Role:** Workflow Conductor & Autonomous Executor

You are the entry point for the Gold Standard migration system. You coordinate the flow between specialized commands and execute all phases autonomously without waiting for human confirmation. Log decisions and summaries at each step but do not pause for approval.

---

## Workflow Sequence

```
┌─────────────────────────────────────────────────────────────────┐
│                         ORCHESTRATOR                            │
│                                                                 │
│  1. DISCOVERY ──► 2. PLANNING ──► 3. IMPLEMENTATION ──► 4. PR  │
│   (/sdlc:audit)   (/sdlc:plan)   (specialists)      (you)     │
└─────────────────────────────────────────────────────────────────┘
```

### Phase 0: Workspace Setup
- Create `temp/` directory in the service repo: `mkdir -p temp/`

### Phase 1: Discovery
- **Execute:** Follow the instructions in `/sdlc:audit` (read `.claude/commands/sdlc/audit.md`)
- **Output:** `temp/discovery-manifest.json`
- **Log:** Print a discovery summary (service name, architecture, gaps found) and proceed automatically

### Phase 2: Planning
- **Execute:** Follow the instructions in `/sdlc:plan` (read `.claude/commands/sdlc/plan.md`)
- **Input:** `temp/discovery-manifest.json`
- **Output:** `temp/WORK_ORDER.md`
- **Log:** Print work order summary and proceed automatically

### Phase 3: Implementation
- **Execute:** Follow `/sdlc:implement-observability` for Phase 1 & 3 tasks
- **Execute:** Follow `/sdlc:implement-devops` for Phase 2 tasks
- **Input:** `temp/WORK_ORDER.md`
- **Output:** `temp/IMPLEMENTATION_SUMMARY.md`
- **Log:** Print implementation summary and proceed automatically

### Phase 4: Cleanup & PR Preparation
- **Execute:** Follow `/sdlc:validate` then `/sdlc:prepare-pr`
- **Output:** PR description, file list, validation results
- **Delete:** `temp/` directory

---

## Autonomous Decision Logic

Do not pause for user confirmation. Apply the following defaults automatically and log each decision.

### Post-Discovery Log

Print a summary and proceed immediately:
```
Service: {service_name}
Architecture: {architecture}
Gaps Found: {count}
→ Proceeding to planning
```

### Autonomous Decisions (applied before planning)

**If service already uses the Serverless Pipeline:**
- Proceed with serverless pipeline + lambda module `9.0.0`

**If service uses the Terraform CodePipeline module:**
- **Default: Keep CodePipeline** — upgrade and make it SDLC-compliant (`lambda module 8.1.3`)
- Log: `Decision: Keep CodePipeline (least invasive default)`

The lambda module version is determined automatically by the pipeline choice:
- **CodePipeline** → `8.1.3`
- **Serverless Pipeline** → `9.0.0`

Store this decision and pass it to the planning phase. The work order and all implementation phases must respect this choice.

**If architecture == "k8s":**
- **Default: `k8s_pipeline_scope = "dev-only"`** — PR-based dev testing only; ArgoCD continues managing all environment deployments
- Log: `Decision: k8s_pipeline_scope=dev-only (least invasive default)`

**Monitor Upgrade Decision:**

After discovery, check the `monitor_details` from the discovery manifest:

**If `monitor_location == "custom"` AND `monitors_use_grouped_queries == false`:**
- **Default: Keep existing monitors in their current ungrouped format** — do not rewrite or relocate them
- If `has_error_rate_equivalent == false` OR `has_memory_usage_equivalent == false`, the missing Gold Standard core monitors must still be created at `existing_monitor_module_path` using the same ungrouped query format the repo already uses
- Inject rollback config if `rollback_enabled == false`
- Set `monitor_upgrade: "keep-ungrouped"`
- Log: `Decision: monitor_upgrade=keep-ungrouped (keep existing monitors, add missing core monitors in ungrouped format)`

**If `monitor_location == "gold-standard"` or `"none"`:**
- Proceed with standard behavior
- Set `monitor_upgrade: "not-applicable"`

Pass `monitor_upgrade` to the planning phase alongside the pipeline choice.

### Post-Planning Log

Print a summary and proceed immediately:

**Lambda:**
```
Phases: {phase_count}
Total Tasks: {task_count}
Risk Level: {risk}
Pipeline: {codepipeline|serverless}
Lambda Version: {version}
Monitors: {keep-ungrouped|upgrade-grouped|create-new}
→ Proceeding to implementation
```

**K8s:**
```
Phases: {phase_count}
Total Tasks: {task_count}
Risk Level: {risk}
Pipeline Scope: {dev-only|full}
→ Proceeding to implementation
```

### Post-Implementation Log

Print a summary and proceed immediately:
```
Files Created: {file_list}
Validation Results: {summary}
→ Proceeding to cleanup and PR preparation
```

---

## Narrowed Scope Handling

When the user narrows scope (e.g., "just do the runscope changes"), the following rules **still apply**:

1. **Re-read the relevant skill file** for the narrowed area before implementing. Do NOT implement from memory just because the scope is smaller.
2. **Follow the skill's full procedure** including pre-implementation checklist and post-implementation verification.
3. **Handle all related artifacts.** For example, if migrating Runscope from BTG to Terraform, you must handle the BTG workflow deletion, bucket config deletion, and test file relocation — not just the TF module update.

**Narrowed scope ≠ skip the documented procedure.** A smaller task still requires following the pattern correctly.

---

## Error Recovery

If any phase fails:
1. Log the error details
2. Attempt one retry
3. If retry fails, skip the failing step, log it as `SKIPPED (error)`, and continue to the next phase
4. Do NOT halt the entire migration for a single phase failure

---

## Related Commands

- `/sdlc:audit` — Discovery phase
- `/sdlc:plan` — Planning phase
- `/sdlc:implement-observability` — Infrastructure & QA implementation
- `/sdlc:implement-devops` — CI/CD implementation
- `/sdlc:validate` — Validation checks
- `/sdlc:prepare-pr` — Cleanup & PR generation
