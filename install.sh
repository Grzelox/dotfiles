#!/usr/bin/env bash
# Dotfiles installer: symlinks tracked configs into place.
#
# Usage:
#   ./install.sh              symlink all configs (existing files are backed up)
#   ./install.sh --dry-run    show what would happen, change nothing
#   ./install.sh --brew       also run `brew bundle` from the Brewfile
#   ./install.sh --vscode     also install VS Code extensions from vscode/extensions.txt
#   ./install.sh --macos      also import macOS app preferences from macos/*.plist
#   ./install.sh --all        everything above

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0 DO_BREW=0 DO_VSCODE=0 DO_MACOS=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --brew) DO_BREW=1 ;;
    --vscode) DO_VSCODE=1 ;;
    --macos) DO_MACOS=1 ;;
    --all) DO_BREW=1 DO_VSCODE=1 DO_MACOS=1 ;;
    -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

# Runs a command, or does nothing in --dry-run (status lines still print).
run() { [ "$DRY_RUN" = 1 ] || "$@"; }
[ "$DRY_RUN" = 1 ] && echo "(dry run: nothing will be changed)"

# link <path in repo> <target path>
link() {
  local src="$DOTFILES/$1" dest="$2"
  if [ ! -e "$src" ]; then echo "  [SKIP] $1 (not in repo)"; return; fi
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "  [OK]   $dest"
    return
  fi
  run mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "  [BACKUP] $dest -> $dest.backup-$STAMP"
    run mv "$dest" "$dest.backup-$STAMP"
  fi
  run ln -s "$src" "$dest"
  echo "  [LINK] $dest -> $src"
}

echo "Linking configs from $DOTFILES"

# Mappings live in configs.txt: "<repo path> | <path relative to $HOME>"
while IFS='|' read -r repo live; do
  repo="$(echo "$repo" | sed 's/^ *//;s/ *$//')"; live="$(echo "$live" | sed 's/^ *//;s/ *$//')"
  case "$repo" in ''|\#*) continue ;; esac
  link "$repo" "$HOME/$live"
done < "$DOTFILES/configs.txt"

# Pi has its own installer (keeps auth.json and sessions local)
if [ "$DRY_RUN" = 1 ]; then
  echo "  would run: pi/install.sh"
else
  bash "$DOTFILES/pi/install.sh"
fi

if [ "$DO_BREW" = 1 ]; then
  echo "Installing Homebrew packages"
  run brew bundle --file="$DOTFILES/Brewfile"
fi

if [ "$DO_VSCODE" = 1 ]; then
  echo "Installing VS Code extensions"
  CODE="$(command -v code || echo "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code")"
  while read -r ext; do
    [ -n "$ext" ] && run "$CODE" --install-extension "$ext" --force
  done < "$DOTFILES/vscode/extensions.txt"
fi

if [ "$DO_MACOS" = 1 ]; then
  # Plists are imported, not symlinked: cfprefsd replaces symlinked plists.
  echo "Importing macOS app preferences (quit the apps first)"
  for plist in "$DOTFILES"/macos/*.plist; do
    domain="$(basename "$plist" .plist)"
    run defaults import "$domain" "$plist"
    echo "  [IMPORT] $domain"
  done
fi

echo "[DONE]"
