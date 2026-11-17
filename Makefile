.DEFAULT_GOAL := help
.PHONY: help sync sync-configs sync-brew sync-vscode sync-macos diff status install install-all dry-run

help: ## List commands
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-14s %s\n", $$1, $$2}'

sync: sync-configs sync-brew sync-vscode sync-macos ## Copy everything from this machine into the repo, then show git status
	@git status --short

sync-configs: ## Copy config files listed in configs.txt into the repo
	@scripts/sync.sh configs

sync-brew: ## Regenerate Brewfile
	@scripts/sync.sh brew

sync-vscode: ## Regenerate vscode/extensions.txt
	@scripts/sync.sh vscode

sync-macos: ## Re-export macOS app preferences
	@scripts/sync.sh macos

diff: ## List configs whose live copy differs from the repo (changes nothing)
	@scripts/sync.sh diff

status: diff ## Show drift and uncommitted changes
	@git status --short

install: ## Symlink configs from the repo into place (backs up existing files)
	@./install.sh

install-all: ## install + Homebrew + VS Code extensions + macOS prefs
	@./install.sh --all

dry-run: ## Preview install without changing anything
	@./install.sh --dry-run --all
