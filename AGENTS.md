# AGENTS.md — chezmoi dotfiles

> Context file for AI coding agents operating in this repository.
> This is a [chezmoi](https://github.com/twpayne/chezmoi) dotfiles repo managing
> configs across macOS (work laptop) and Linux (personal: RedDwarf, Prometheus).

## Repository Structure

```
.chezmoi.toml.tmpl          # chezmoi config (age encryption, per-host data)
.chezmoiignore              # per-host file exclusions (Go text/template)
.chezmoiscripts/            # run_once / run_after lifecycle scripts
bin/                        # executable shell scripts (~/.local/bin)
dot_*                       # files deployed to $HOME (dot_ prefix → .)
private_dot_config/         # ~/.config/ tree (fish, nvim, wezterm, i3, etc.)
  fish/                     # Fish shell: config.fish.tmpl, conf.d/, functions/, completions/
  nvim/                     # Neovim: LazyVim-based config (Lua)
  wezterm/                  # WezTerm terminal config (Lua)
  kitty/                    # Kitty terminal config
  i3/, sway/, polybar/      # Linux window managers
  starship.toml             # Cross-shell prompt
darwin_packages.txt         # Homebrew packages for macOS
linux_packages.txt          # Pacman packages for Arch Linux
```

## Chezmoi Concepts

- **`dot_` prefix**: Stripped and replaced with `.` at deploy time.
- **`private_` prefix**: Sets restrictive file permissions (0700 dirs, 0600 files).
- **`executable_` prefix**: Sets executable bit on deployed file.
- **`.tmpl` suffix**: File processed as Go `text/template` before deployment.
- **Template data**: Defined in `.chezmoi.toml.tmpl` per host (email, signing key, OS).
- **Encryption**: Uses `age` with per-machine recipient keys.
- **Apply command**: `chezmoi apply` deploys from source to `$HOME`.
- **Diff command**: `chezmoi diff` shows pending changes before apply.

## Build / Lint / Test Commands

No traditional build system. Validation commands:

```bash
# Verify chezmoi templates parse correctly
chezmoi execute-template < .chezmoi.toml.tmpl

# Diff: preview what chezmoi would change
chezmoi diff

# Apply: deploy dotfiles to $HOME
chezmoi apply

# Apply single file
chezmoi apply ~/.config/fish/config.fish

# Lint shell scripts
shellcheck bin/*.sh .chezmoiscripts/*.sh

# Lint Lua (neovim config)
stylua --check private_dot_config/nvim/

# Format Lua
stylua private_dot_config/nvim/

# Pre-commit hooks (runs on commit)
pre-commit run --all-files

# Secret scanning
detect-secrets scan --baseline .secrets.baseline
detect-secrets audit .secrets.baseline
```

## Code Style Guidelines

### Shell Scripts (Bash)

- Shebang: `#!/bin/bash` (or `#!/bin/sh` for POSIX scripts).
- Use `set -eu` for safety (`-e` exit on error, `-u` exit on unset vars).
- Quote all variable expansions: `"$var"`, `"${var}"`.
- Use `[[ ]]` for conditionals in bash, `[ ]` for POSIX sh.
- Functions: `function_name() { ... }` (snake_case).
- Indent with 4 spaces (observed convention).
- Use `command -v` to check for executables, not `which`.

### Fish Shell

- Config entry: `private_dot_config/fish/config.fish.tmpl` (templated per OS).
- Use `type -q <cmd>` to check command availability before use.
- Use `fish_add_path` for PATH modifications, `set -x` for exports.
- Aliases in `conf.d/aliases.fish`, functions in `functions/`.
- Completions in `completions/`.
- No `export` keyword; use `set -gx VAR value`.

### Lua (Neovim / WezTerm)

- Formatter: **StyLua** (config in `.stylua.toml` and `nvim/stylua.toml`).
- Indent: 2 spaces.
- Max line width: 120 characters.
- Quote style: double quotes (auto-prefer).
- Line endings: Unix (LF).
- Neovim plugin structure follows LazyVim conventions:
  - Entry point: `init.lua` → `config/lazy.lua`.
  - Plugins: one file per plugin or group in `lua/plugins/`.
  - Options: `lua/config/options.lua`.
  - Keymaps: `lua/config/keymaps.lua`.
  - Return a table from each plugin file.

### Chezmoi Templates (Go text/template)

- Use `{{ if eq .chezmoi.os "darwin" }}` for OS-conditional blocks.
- Use `{{ if eq .chezmoi.hostname "..." }}` for host-conditional blocks.
- Template data comes from `.chezmoi.toml.tmpl` `[data]` section.
- End conditionals with `{{ end }}` or `{{- end }}` (trim whitespace).
- Use `-` in delimiters (`{{-` / `-}}`) to control whitespace.

### TOML / YAML Config Files

- Follow upstream application conventions for each tool.
- Use comments to explain non-obvious settings.
- Group related settings together.

## Pre-commit Hooks

Configured in `.pre-commit-config.yaml`:
- **trailing-whitespace**: Removes trailing whitespace.
- **end-of-file-fixer**: Ensures files end with newline.
- **check-yaml**: Validates YAML syntax.
- **check-added-large-files**: Prevents large file commits.
- **secrets-detect**: Runs `detect-secrets audit` against `.secrets.baseline`.

## Git Conventions

- Commit messages: imperative mood, lowercase start, < 72 chars.
- Examples from history: `update blink`, `add refactor custom prompt`, `switch from nvchad to lazyvim`.
- No conventional-commits prefix required (though `feat(scope):` used occasionally).
- No branching strategy enforced; commits directly to main.

## Secrets Management

- **Age encryption** for sensitive files (SSH keys, etc.).
- Recipients listed in `.chezmoi.toml.tmpl` (one per machine).
- **Bitwarden** integration for runtime secrets (e.g., borg passphrase).
- `.secrets.baseline` tracks known false positives for `detect-secrets`.
- Never commit plaintext secrets. Age-encrypt or use Bitwarden lookups.

## Multi-Host Awareness

Three target machines with different configs:

| Hostname | OS | Notes |
|---|---|---|
| `MACBOOKPRO-GX2KLQW3FG` | macOS (darwin) | Work laptop (Ibotta) |
| `RedDwarf` | Linux (Arch) | Personal desktop |
| `Prometheus` | Linux (Arch) | Personal server |

Host-specific logic lives in:
- `.chezmoiignore` (file inclusion/exclusion per host).
- `.chezmoi.toml.tmpl` (data: email, GPG signing key).
- `.tmpl` files (conditional blocks for OS/host).

When editing templates, preserve all host conditionals. Test changes
against the template syntax: `chezmoi execute-template < file.tmpl`.

## Agent Rules

- **Never run `chezmoi apply`** without user confirmation. Preview with `chezmoi diff` first.
- **Never modify `.chezmoi.toml.tmpl` encryption keys** or age recipients.
- **Never commit secrets** in plaintext. Check `.secrets.baseline` if flagged.
- **Preserve host conditionals.** Edits to `.tmpl` files must not break other hosts.
- **Run `shellcheck`** on any modified shell script before reporting done.
- **Run `stylua --check`** on any modified Lua file before reporting done.
- **Test templates** with `chezmoi execute-template` after editing `.tmpl` files.
