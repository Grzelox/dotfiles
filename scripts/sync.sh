#!/usr/bin/env bash
# Copy live configs on this machine back into the repo (the reverse of install.sh).
#
# Usage: scripts/sync.sh <configs|brew|vscode|macos|diff>
#   configs  copy every file in configs.txt from $HOME into the repo
#   brew     regenerate Brewfile
#   vscode   regenerate vscode/extensions.txt
#   macos    re-export macos/*.plist (machine-specific keys stripped)
#   diff     list configs whose live copy differs from the repo (changes nothing)

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES"

# Prints "<repo path>\t<absolute live path>" for each entry in configs.txt
mappings() {
  while IFS='|' read -r repo live; do
    repo="$(echo "$repo" | sed 's/^ *//;s/ *$//')"; live="$(echo "$live" | sed 's/^ *//;s/ *$//')"
    case "$repo" in ''|\#*) continue ;; esac
    printf '%s\t%s\n' "$repo" "$HOME/$live"
  done < configs.txt
}

sync_configs() {
  echo "Syncing configs into $DOTFILES"
  mappings | while IFS=$'\t' read -r repo live; do
    if [ -L "$live" ] && [ "$(readlink "$live")" = "$DOTFILES/$repo" ]; then
      echo "  [LINKED] $repo (already the repo file)"
    elif [ -d "$live" ]; then
      rsync -a --delete --exclude .DS_Store --exclude .git "$live/" "$repo/"
      echo "  [SYNC]   $repo/"
    elif [ -f "$live" ]; then
      mkdir -p "$(dirname "$repo")"
      cp "$live" "$repo"
      echo "  [SYNC]   $repo"
    else
      echo "  [MISSING] $live"
    fi
  done
}

diff_configs() {
  mappings | while IFS=$'\t' read -r repo live; do
    if [ ! -e "$live" ]; then echo "  missing  $live"
    elif [ -L "$live" ] && [ "$(readlink "$live")" = "$DOTFILES/$repo" ]; then :
    elif ! diff -rq -x .DS_Store -x .git "$repo" "$live" >/dev/null 2>&1; then echo "  changed  $repo"
    fi
  done
}

sync_brew() {
  echo "Regenerating Brewfile"
  brew bundle dump --file=Brewfile --force --no-vscode
}

sync_vscode() {
  echo "Regenerating vscode/extensions.txt"
  local code
  code="$(command -v code || echo "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code")"
  "$code" --list-extensions > vscode/extensions.txt
}

sync_macos() {
  echo "Re-exporting macOS app preferences"
  for plist in macos/*.plist; do
    domain="$(basename "$plist" .plist)"
    defaults export "$domain" "$plist"
    echo "  [EXPORT] $domain"
  done
  # Strip install IDs, update timestamps, window frames and per-display history
  python3 -I - macos/*.plist <<'EOF'
import plistlib, re, sys
noise = re.compile(r'^(MSAppCenter|remote_id|remote_tokens|support_|updater_\w+_ts|SULastCheckTime|'
                   r'SUSkippedVersion|SUUpdateGroupIdentifier|SUUpdateRelaunchingMarker|SUHasLaunchedBefore|'
                   r'lastConnected@|lastUnseen@|NSWindow Frame|updateFound|updateBuild|updateVersion|lastVersion)')
for path in sys.argv[1:]:
    with open(path, 'rb') as f:
        data = plistlib.load(f)
    for key in [k for k in data if noise.match(k)]:
        del data[key]
    with open(path, 'wb') as f:
        plistlib.dump(data, f, sort_keys=True)
EOF
}

case "${1:-}" in
  configs) sync_configs ;;
  brew) sync_brew ;;
  vscode) sync_vscode ;;
  macos) sync_macos ;;
  diff) diff_configs ;;
  *) sed -n '2,10p' "$0"; exit 1 ;;
esac
