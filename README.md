# Dotfiles

Personal configuration files.

## Pi Coding Agent

The `pi/` directory contains configuration for [pi](https://github.com/earendil-works/pi-coding-agent) -- my AI coding agent.

### What's tracked

- `settings.json` -- default model, provider, theme
- `extensions/` -- custom extensions (permission gates, git checkpoints, plan mode, etc.)
- `prompts/` -- reusable prompt templates (`/review`, `/refactor`, `/debug`, etc.)
- `skills/` -- agent skills (currently empty, ready for skills)
- `.gitignore` -- ensures `auth.json` and `sessions/` are never committed

### What's NOT tracked (local only)

- `auth.json` -- API keys (kept in `~/.pi/agent/`)
- `sessions/` -- conversation history (kept in `~/.pi/agent/`)

### Install

```bash
./pi/install.sh
```

This symlinks tracked config into `~/.pi/agent/` while preserving local auth and sessions.

### Extensions included

| Extension | Purpose |
|-----------|---------|
| `permission-gate.ts` | Confirms before dangerous bash commands |
| `protected-paths.ts` | Blocks writes to `.env`, `.git/`, `node_modules/`, etc. |
| `git-checkpoint.ts` | Stash checkpoints at each turn for `/fork` restore |
| `auto-commit-on-exit.ts` | Auto-commits on session exit |
| `custom-compaction.ts` | Smarter conversation compaction with summaries |
| `status-line.ts` | Footer status: model, turn count, token usage |
| `plan-mode/` | Read-only plan mode with step tracking |
| `self-improve.ts` | `/pi-status`, `/pi-reload`, `/pi-extensions` commands |
| `commands.ts` | `/commands` -- list all available slash commands |

### Prompt templates

| Template | Usage |
|----------|-------|
| `/review [file]` | Review staged git changes |
| `/refactor <file>` | Refactor for readability/performance |
| `/debug <error>` | Root cause analysis and fix |
| `/tests <file>` | Generate comprehensive tests |
| `/docs <module>` | Write documentation |
| `/architecture [scope]` | Analyze system design |

## Neovim

LazyVim configuration.

- `neovim/` -- LazyVim config (`init.lua`, `lua/`, `lazy-lock.json`, etc.)
- Install: copy or symlink `neovim/` to `~/.config/nvim/`

## Terminal

### Ghostty

- `ghostty/config` -- `theme = Kanagawa Wave`
- Install: copy or symlink to `~/.config/ghostty/config`

## Shell

### Zsh

- `zsh/.zshrc` -- oh-my-zsh with kanagawa theme, nvm, bun, pipx, LM Studio, opencode PATH
- Install: copy or symlink to `~/.zshrc`

### tmux

- `tmux/.tmux.conf` -- kanagawa/wave theme, ukiyo plugins, tmux-ukiyo
- Install: copy or symlink to `~/.tmux.conf`

## Herdr

- `herdr/config.toml` -- herdr config (theme: kanagawa, onboarding: false)
- Install: copy or symlink to `~/.config/herdr/config.toml`

## GitHub CLI

- `gh/config.yml` -- gh CLI settings (git protocol: https, aliases, etc.)
- Install: copy or symlink to `~/.config/gh/config.yml`
- Note: `hosts.yml` is not tracked (contains user login state)

## OpenCode

- `opencode/cli.json` -- theme, session, diff settings
- `opencode/opencode.json` -- provider configs (Ollama local, Headroom proxy), MCP servers
- Install: copy or symlink `opencode/` to `~/.config/opencode/`
- Note: `bun.lock`, `node_modules/`, and any future lockfiles are gitignored
