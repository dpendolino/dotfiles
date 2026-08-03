# SDLC Validate — File Validation Suite

Run validation checks on all generated Gold Standard files.

## Prerequisites

Before running validation, read `temp/discovery-manifest.json` to extract actual paths:
- `terraform_layout.modules_base_path` — base path for TF modules (default: `terraform/modules/`)
- `runscope_path` — path to runscope module (default: `terraform/modules/runscope/`)
- `monitor_details.custom_monitor_path` — path to monitor modules

All validation commands below use `{modules_base}` and `{runscope_path}` as placeholders — substitute with the actual discovered paths from the manifest.

## Validation Steps

### 1. Terraform Validation

```bash
cd {modules_base}/datadog-monitors && terraform validate
cd {runscope_path} && terraform validate
```

Use the `Bash` tool to run these commands. Substitute `{modules_base}` and `{runscope_path}` with actual paths from the discovery manifest.

### 2. YAML Validation

```bash
yamllint .github/workflows/*.yml
```

If `yamllint` is not available, use `Read` to inspect workflow files and verify structure manually.

### 3. JSON Validation

```bash
jq . .ibotta/config/*.json
```

Use the `Bash` tool. Verify all JSON files parse without errors.

### 4. Jsonnet Compilation

```bash
for f in {runscope_path}/templates/*.jsonnet; do
  jsonnet "$f" > /dev/null
done
```

> Substitute `{runscope_path}` with the actual path from the discovery manifest.

Use the `Bash` tool. Each template must compile without errors.

### 5. Rollback Tag Verification

Use `Grep` to search for `datadog-rollback-enabled:true` in `*.tf` files. Verify that all core Lambda monitors include this tag.

### 6. Deployment Strategy Verification

Use `Grep` to search for `deploymentStrategy` in `.ibotta/config/*.json`. Verify:
- Dev/QA environments use `instant`
- Production environments use `10-percent-every-minute`

---

## Output

Present results as:

```markdown
## Validation Results

| Check | Status |
|-------|--------|
| terraform validate ({modules_base}/datadog-monitors) | PASS/FAIL |
| terraform validate ({runscope_path}) | PASS/FAIL |
| YAML lint | PASS/FAIL |
| JSON parse | PASS/FAIL |
| Jsonnet compile | PASS/FAIL |
| Rollback tags present | PASS/FAIL |
| Deployment strategies correct | PASS/FAIL |

**Overall:** PASS/FAIL
```

If any check fails, report the specific error and suggest a fix.
