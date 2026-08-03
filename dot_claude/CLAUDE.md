# Global Claude Instructions — opencode

> These instructions apply across all projects unless overridden by project-specific CLAUDE.md files.

## General Coding Principles

- **Clarity over cleverness** — Write explicit, readable code that serves as documentation.
- **Declarative over imperative** — Prefer declarative patterns where possible.
- **Security by default** — Never add escape hatches, opt-outs, or `*` wildcards for IAM/RBAC.
- **Fail closed** — When in doubt, deny. Missing config = secure default, not open default.
- **Minimal changes** — Change only what's necessary. Don't refactor while fixing bugs.

## Code Style

### File Organization
- Group by domain/feature, not by file type.
- Co-locate tests with source files.
- Keep modules small and focused — one responsibility per module.

### Naming Conventions

| Element          | Convention                  | Example                        |
|------------------|-----------------------------|--------------------------------|
| Files            | snake_case (Go: snake_case) | `pod_security_policy.go`       |
| Functions        | camelCase / PascalCase (Go) | `validatePolicy` / `NewClient` |
| Constants        | UPPER_SNAKE_CASE            | `MAX_RETRY_COUNT`              |
| Terraform resources | snake_case with prefix   | `ibotta_platform_vpc`          |
| K8s resources    | kebab-case                  | `workload-controller`          |
| Env variables    | UPPER_SNAKE_CASE            | `DATADOG_API_KEY`              |

### Imports / Dependencies
- Group imports: stdlib → external → internal. Separate with blank line.
- Pin dependency versions explicitly (go.mod, requirements.txt, package-lock.json).
- Prefer stdlib and well-maintained OSS over custom implementations.
- No wildcard imports (`from foo import *`).

### Types and Interfaces
- Use strong typing everywhere. No `any`, `interface{}` without justification.
- Define explicit types/structs for API contracts — never pass raw maps/dicts.
- Validate inputs at boundaries (API handlers, CLI args, webhook receivers).

### Error Handling
- **Never** swallow errors silently (`catch(e) {}`, `_ = err`).
- Wrap errors with context: `fmt.Errorf("creating resource: %w", err)`.
- Use structured logging (JSON) with consistent fields: `level`, `msg`, `err`, `component`.
- Return errors to callers; let the top-level handler decide on logging/alerting.

### Security-Specific
- No secrets in code — use external secret management (AWS Secrets Manager, k8s Secrets).
- Never commit `.env`, credentials, or certificates.
- All RBAC policies must follow least-privilege.
- Container images: pin to digest, not `:latest`.
- Network policies: default-deny, explicitly allow.

### Terraform Style
- Use `terraform fmt` canonical style.
- Every resource needs `tags` with at minimum: `team`, `environment`, `managed-by`.
- Modules expose variables with `description` and `type` — no untyped variables.
- Use `validation` blocks on variables where possible.
- State stored remotely (S3 + DynamoDB locking).

### Kubernetes Manifests
- Always set resource requests and limits.
- Always set `securityContext` (non-root, read-only rootfs, drop all capabilities).
- Use `PodDisruptionBudget` for any production workload.
- Labels: `app.kubernetes.io/name`, `app.kubernetes.io/component`, `app.kubernetes.io/managed-by`.

## Testing

- **Unit tests** co-located with source.
- **Integration tests** in dedicated `tests/` or `*_integration_test.go` files.
- Test names describe behavior: `Test<Function>_<Behavior>`.
- Mock external dependencies (AWS, Datadog API) — never call real APIs in unit tests.
- Terraform: use `terraform plan` diffing and/or Terratest.

## Git Conventions

- Branch naming: `<type>/<short-description>` (e.g., `feat/workload-controller`, `fix/rbac-policy`).
- Commit messages: imperative mood, < 72 chars. E.g., `Add pod security admission webhook`.
- PR descriptions: include **what**, **why**, and **how to test**.
- Squash merge to main.

## Observability (Ibotta Context)

- **Datadog** is the observability platform.
- Use `pup` CLI for querying logs, metrics, monitors, SLOs.
- Structured logs → Datadog log pipeline. Use consistent `service`, `env`, `version` tags.
- Custom metrics: prefix with `ibotta.platform.*`.
- Dashboards and monitors defined as code (Terraform datadog provider or Datadog API).

---

## Hard Constraints — Never Violate These

### Never Do

- **No pushing to GitHub.** Never run `git push`, `gh pr create`, or any command that sends data to a remote. Only commit locally when explicitly asked.
- **No leaking credentials.** Never write secrets, API keys, tokens, passwords, or certificates into any file — including code, configs, logs, comments, or commit messages.
- **No committing sensitive files.** Never stage or commit `.env`, `*.pem`, `*.key`, `credentials.json`, `kubeconfig`, or any file likely containing secrets.
- **No executing destructive commands.** Never run `rm -rf`, `git push --force`, `terraform destroy`, `kubectl delete namespace`, or anything irreversible without explicit user confirmation.
- **No modifying git config.** Never change `user.name`, `user.email`, or any git configuration.
- **No bypassing safety checks.** Never use `--no-verify`, `--force`, `--skip-hooks`, or equivalent flags that skip validation.
- **No exfiltrating data.** Never send repository content, environment variables, or file contents to external URLs, APIs, or services.
- **No installing global packages.** Never run `npm install -g`, `pip install` outside a venv, or anything that modifies the system globally.
- **No using DevOpsAdmin AWS profile.** Never use `--profile DevOpsAdmin` or `AWS_PROFILE=DevOpsAdmin` in any AWS CLI command or SDK configuration.

### Always Do

- **Ask before large changes.** If a task touches 5+ files or involves architectural decisions, confirm the approach first.
- **Verify before reporting done.** Run linters, type checks, or tests on changed files before claiming completion.
- **Preserve existing behavior.** When fixing bugs, change the minimum necessary. Never refactor while fixing.
- **Flag security concerns.** If you see hardcoded secrets, overly permissive IAM/RBAC, or missing input validation in existing code, raise it immediately.

---

## Context: Staff Security Engineer — Platform Team

**Role**: Staff Security Engineer on Platform Team at Ibotta
**Goals**:
1. Embed automatic security guardrails (compliance by default)
2. Publish stable security contracts (enforce posture, don't block velocity)
3. Self-service compliance reporting (eliminate manual audit toil)

**Key infrastructure**: Kubernetes, AWS (Lambda coexistence), Terraform (IaC), Datadog (observability/HPA metrics).

The platform serves both human developers and agentic systems — design APIs accordingly.
