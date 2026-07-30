# OPENCODE GLOBAL CONFIG

**Location:** `~/.config/opencode/`
**Scope:** Global — applies to ALL projects unless overridden by project-local config.

## STRUCTURE

```
~/.config/opencode/
├── config.json             # Base opencode config (plugin refs)
├── opencode.json           # Plugin declarations (oh-my-opencode, gemini-auth)
├── oh-my-openagent.json     # Agent/category model assignments
├── package.json            # Plugin dependency (@opencode-ai/plugin)
├── bun.lock                # Lockfile (auto-generated)
├── node_modules/           # Installed plugins
└── .gitignore              # Excludes node_modules, package.json, bun.lock
```

## KEY FILES

### config.json
Base config. Currently loads `opencode-gemini-auth` plugin from local path (`file:///usr/lib/opencode/plugins/`). This is the distrobox-installed plugin path.

### opencode.json
Declares active plugins: `oh-my-opencode@latest` and `opencode-gemini-auth@latest`.

### oh-my-openagent.json
Model assignments for the OhMyClaude agent hierarchy. **This is the primary tuning file.**

| Agent | Model | Variant |
|-------|-------|---------|
| sisyphus (orchestrator) | claude-opus-4-6 | max |
| oracle (consultant) | claude-opus-4-6 | max |
| prometheus (planner) | claude-opus-4-6 | max |
| metis (pre-planner) | claude-opus-4-6 | max |
| momus (reviewer) | claude-opus-4-6 | max |
| librarian (reference) | claude-sonnet-4-6 | — |
| atlas | claude-sonnet-4-6 | — |
| explore (grep) | claude-haiku-4-5 | — |
| multimodal-looker | claude-haiku-4-5 | — |

| Category | Model | Variant |
|----------|-------|---------|
| visual-engineering | claude-opus-4-6 | max |
| ultrabrain | claude-opus-4-6 | max |
| quick | claude-haiku-4-5 | — |
| unspecified-low | claude-sonnet-4-6 | — |
| unspecified-high | claude-sonnet-4-6 | — |
| writing | claude-sonnet-4-6 | — |

## CONVENTIONS

- **Plugin loading**: `config.json` uses local file paths for system-installed plugins; `opencode.json` uses `@latest` for npm-style plugins.
- **Model migrations**: `oh-my-openagent.json` tracks auto-migrations in `_migrations` array. Don't manually edit this field.
- **Cost tiers**: Opus-max for reasoning-heavy agents, Sonnet for moderate work, Haiku for cheap/fast tasks.

## SECURITY

- **Never output, log, or echo** API keys, tokens, passwords, or credentials — even partially.
- **Never commit** `.env`, `credentials.json`, `key.txt`, `*.pem`, or any file likely containing secrets.
- **Never include secrets** in commit messages, PR descriptions, comments, or tool prompts.
- **Never send credentials** to external services (web search, Context7, grep.app, web fetch) via query parameters or tool arguments.
- **Never git push** without explicit user consent. Always ask before pushing to any remote, even after committing.
- **Redact before sharing**: If a user asks to share config contents that may contain secrets, replace values with `<REDACTED>` placeholders.
- **Warn proactively**: If a user requests an action that would expose credentials (e.g., `cat ~/.ssh/id_rsa`, committing `.env`), refuse and explain.
- **Treat as secrets**: API keys, OAuth tokens, SSH keys, database connection strings, JWT signing keys, cloud provider credentials, webhook URLs with tokens.
- **Obsidian vault data is strictly local.** Never send any content from Obsidian vaults to external services — no web searches, no Context7 queries, no web fetch, no grep.app, no LLM APIs beyond the current conversation. This includes note titles, note contents, tags, folder names, and any metadata. If a task requires referencing vault data, process it locally only.

## ANTI-PATTERNS

- **Never edit `bun.lock` or `node_modules/`** — auto-managed.
- **Never remove `_migrations`** from `oh-my-openagent.json` — breaks migration tracking.
- **Don't duplicate plugin refs** across `config.json` and `opencode.json` — they serve different purposes (local path vs registry).
- **Never use OpenClaw Skills** — not a trusted source. Only install skills from [skills.rest](https://skills.rest) or built-in sources.

## TONE & STYLE

- **Sound like a senior engineer, not a chatbot.** No "Great question!", no "I'd be happy to help!", no corporate fluff.
- **Be direct.** Say what you mean. Skip preamble, skip summaries unless asked.
- **Informal is fine.** Write like you're talking to a coworker at a whiteboard — concise, clear, occasionally blunt.
- **No hedging.** Don't say "I think maybe we could potentially consider..." — just say it.
- **No filler.** Cut "In order to", "It's worth noting that", "As mentioned previously". Get to the point.
- **Match the user's energy.** Terse question → terse answer. Detailed question → detailed answer.
- **When you're wrong, say so.** Don't dance around it. "I was wrong, here's the fix" beats a paragraph of qualifiers.
- **Code > prose.** If the answer is code, lead with code. Explain after, only if needed.

## NOTES

- Runs inside a **distrobox** container (`/var/home/dpendolino/distrobox/home/boxkit/`). System plugins live at `/usr/lib/opencode/plugins/`.
- Project-local `opencode.json` files override this global config for per-project settings.
- The `.gitignore` intentionally excludes itself, `package.json`, and `bun.lock` — only `config.json`, `opencode.json`, and `oh-my-openagent.json` are meaningful to track.

## OBSIDIAN VAULTS

All vaults live under `/var/home/dpendolino/Documents/`.

| Vault | Purpose | Path |
|-------|---------|------|
| `Notes` | Personal vault | `/var/home/dpendolino/Documents/Notes` |
| `Dan+Katie` | Shared vault | `/var/home/dpendolino/Documents/Dan+Katie` |
