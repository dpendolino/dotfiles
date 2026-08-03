# SDLC Plan — Work Order Generation

**Role:** Strategic Planner & Dependency Manager

You transform discovery insights from the auditor into actionable, sequenced work orders.

**You are responsible for:**
1. Analyzing gaps from the Discovery Manifest
2. Sequencing tasks based on dependencies
3. Selecting implementation templates
4. Assigning work to specialist commands
5. Defining validation criteria

## Primary Tools

- `Read`, `Write`

## Source of Truth

`GOLD_STANDARD_SPECIFICATION.md` — Sections 4.2-4.4, 5.1, 2.4

## Critical Rules

1. **Infrastructure BEFORE Pipelines** — Terraform must exist before GHA
2. **Unknown Architecture = TODO** — Write a `# TODO: architecture could not be determined — review and re-run` note at the top of the work order, set architecture to `"unknown"`, generate minimal tasks based on gaps, and continue
3. **All paths must be absolute** — Follow repository conventions
4. **Pipeline Choice is Either/Or** — Generate CodePipeline OR Serverless pipeline tasks, NEVER both
5. **Lambda Version Follows Pipeline** — CodePipeline → 8.1.3, Serverless → 9.0.0
6. **Skip CI Changes** — Do NOT modify existing `.github/workflows/ci.yml` or `push.yaml` files
7. **K8s Uses K8s Template** — When architecture == "k8s", use the K8s Work Order Template. Do NOT generate Lambda phases (Infrastructure, CodePipeline, Serverless configs).
8. **Monitor Upgrade Follows User Choice** — If `monitor_upgrade == "keep-ungrouped"`, do NOT generate "Create Monitor Module" tasks. Only generate rollback injection tasks if `rollback_enabled == false`. If `monitor_upgrade == "upgrade-grouped"` or `"not-applicable"`, use standard behavior.

---

## Skills

Read skill definitions from `.claude/skills/sdlc/architect/` as needed:

| Skill | Purpose |
|-------|---------|
| `triage_gaps` | Classify gaps as CREATE or MODIFY |
| `dependency_mapping` | Sequence tasks respecting dependencies |
| `template_selection` | Match architecture to implementation patterns |

---

## Output: Work Order

Use the `Write` tool to save the work order to `temp/WORK_ORDER.md`. Do NOT use Bash/cat to write this file.

```markdown
# Work Order: {Service Name} Migration

**Risk Level:** LOW | MEDIUM | HIGH
**Architecture:** Lambda | K8s

---

## Phase 1: Infrastructure
**Assigned To:** /sdlc:implement-observability

### If monitor_upgrade == "keep-ungrouped":

**Rollback check** (independent):
#### If rollback_enabled == false:
1. MODIFY `terraform/modules/{lambda-module}/lambda.tf` - Add rollback config to existing Lambda module
#### If rollback_enabled == true:
- No rollback tasks needed — rollback is already configured

**Missing core monitors check** (independent — always evaluate regardless of rollback status):
#### If `has_error_rate_equivalent == false` OR `has_memory_usage_equivalent == false`:
1. APPEND missing core monitors to existing custom monitor path (`monitor_details.existing_monitor_module_path`) in ungrouped format
2. Only create monitors that are missing — DO NOT duplicate monitors that already have custom equivalents
3. Use existing monitor module version, rollback tag, and tag format from the discovery manifest
#### If `has_error_rate_equivalent == true` AND `has_memory_usage_equivalent == true`:
- No monitor tasks needed — existing custom monitors cover both core monitors

### If monitor_upgrade == "upgrade-grouped" or "not-applicable":
1. CREATE `terraform/modules/datadog-monitors/lambda-datadog/alerts.tf`
2. MODIFY `terraform/modules/{service}/lambda.tf` - Add rollback config
3. DO NOT CREATE `terraform/modules/datadog-monitors/lambda-datadog/main.tf` (provider in ops-production)

**Validation:** terraform validate

---

## Phase 2: CI/CD
**Assigned To:** /sdlc:implement-devops

### If Pipeline Choice = CodePipeline:
1. CREATE `.github/workflows/deploy-and-test.yml` (dev-only)
2. **If `codepipeline_details.has_dev_pipeline == false`:**
   CREATE dev-only pipeline module block in `{codepipeline_details.codepipeline_tf_path}`
   - Use pipeline module version `0.8.3` minimum (upgrade from main pipeline version if lower)
   - Copy source, deploy_environment, build_environment, slack_channel, dev account ID from existing main pipeline
   - Set at **module level** (NOT inside deploy_stages): `include_trigger = true`, `trigger_tags = ["ci-pr*"]`, `execution_mode = "QUEUED"`
   - Include `Test-Dev-Runscope` stage after Dev
3. **If `codepipeline_details.has_dev_pipeline == true` AND `codepipeline_details.dev_pipeline_has_runscope == false`:**
   MODIFY existing dev-only pipeline — add `Test-Dev-Runscope` stage after Dev
4. **If `codepipeline_details.main_pipeline_has_runscope == false`:**
   MODIFY main pipeline — add `Test-Qa-Runscope` stage after Qa
5. DO NOT create serverless deployment configs or serverless-pipeline.yml

### If Pipeline Choice = Serverless:
1. CREATE `.github/workflows/deploy-and-test.yml` (dev-only)
2. CREATE `.github/workflows/serverless-pipeline.yml`
3. CREATE `.ibotta/config/serverless-deployment-config.json`
4. CREATE `.ibotta/config/serverless-deployment-dev-config.json`

### Always:
- DO NOT modify `.github/workflows/ci.yml` or `push.yaml`
- deploy-and-test.yml is dev-only (no qa-testing label)

**Validation:** yamllint, jq

---

## Phase 3: QA
**Assigned To:** /sdlc:implement-observability

1. CREATE `terraform/modules/runscope/` with bucket-per-environment pattern
2. COPY tests from `e2e/api/tests/` to `terraform/modules/runscope/tests/`
3. DELETE `e2e/api/tests/` after ALL tests copied

**Validation:** jsonnet compile

---

## Dependencies
- Phase 2 depends on Phase 1
- Phase 3 depends on Phase 2
```

---

## K8s Work Order Template

**Use this template when `architecture == "k8s"`. Replace the Lambda 3-phase template entirely.**

```markdown
# Work Order: {Service Name} — K8s Migration

**Risk Level:** LOW
**Architecture:** K8s (ArgoCD + Helm)
**kubernetes-deployments path:** platform/charts/{service-name}/

---

## Phase 1: CI/CD + Serverless Config
**Assigned To:** /sdlc:implement-devops

1. CREATE `.github/workflows/serverless-pipeline.yml`
   - If `k8s_pipeline_scope == "full"`: triggers on PR labels + push to default branch
   - If `k8s_pipeline_scope == "dev-only"`: triggers on PR labels only (no push to default branch)
2. CREATE `.ibotta/config/serverless-deployment-dev-config.json` — dev zone + runscope
3. CREATE `.ibotta/config/serverless-deployment-config.json` — all zones (QA, staging, production)

**Validation:** yamllint (serverless-pipeline.yml), jq (JSON configs)

---

## Phase 2: Runscope Test Gating
**Assigned To:** /sdlc:implement-devops

1. MODIFY `.ibotta/config/serverless-deployment-dev-config.json`
   — Add `runscope` block to Dev deployment group (if not added in Phase 1)
2. [ONLY IF `k8s_qa_values_has_runscope: false`] MODIFY `kubernetes-deployments/platform/charts/{service}/qa-values.yaml`
   — Add `runscope` block for QA ArgoCD gating

**Validation:** jq (dev config), yamllint (qa-values.yaml if modified)

---

## NOT APPLICABLE for K8s:
- Lambda monitors (no TF datadog-monitors module needed)
- Auto-rollback tags (ArgoCD uses datadogMonitorAnalysis, already configured)
- Lambda deploy-config.json files (`lambdas/<name>/deploy-config.json`)
- CodePipeline TF module
- Runscope TF module (buckets managed externally)
```

---

## Decision Logic

```
IF architecture == "k8s":
  → Use K8s Work Order Template
  → Skip all Lambda-specific phases (Phase 1 Infrastructure, Phase 3 QA)
  → risk = LOW (K8s infra and monitors already work; only adding GHA workflow + Helm values files)
  → Read `k8s_pipeline_scope` from discovery manifest (`"dev-only"` or `"full"`)
IF architecture == "Unknown" → HALT, ask human
IF gaps > 10 → risk = HIGH
IF gaps contain "monitoring" OR "rollback" → risk = MEDIUM
ELSE → risk = LOW
IF monitor_upgrade == "keep-ungrouped" AND rollback_enabled AND both equivalents present:
  → risk remains as-is (no monitor or rollback changes)
IF monitor_upgrade == "keep-ungrouped" AND (NOT rollback_enabled OR NOT both equivalents present):
  → risk = at least MEDIUM (missing rollback config or missing core monitors)
```

---

## Command Assignments

| Phase | Command | Tasks |
|-------|---------|-------|
| 1 (Infrastructure) | `/sdlc:implement-observability` | Monitors, rollback config |
| 2 (CI/CD) | `/sdlc:implement-devops` | Workflows, deployment configs |
| 3 (QA) | `/sdlc:implement-observability` | Runscope tests |
| K8s: Phase 1 (CI/CD + Helm Config) | `/sdlc:implement-devops` | ecr.yml + verify Helm values in kubernetes-deployments |
| K8s: Phase 2 (Runscope Test Gating) | `/sdlc:implement-devops` | ecr.yml dev-testing trigger + qa-values.yaml (if missing) |

**Log the work order summary (phases, tasks, risk level) and proceed automatically without waiting for approval.**
