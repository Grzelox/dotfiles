#!/usr/bin/env bash
# Pi config symlink installer
# Links dotfiles/pi/* into ~/.pi/agent/ while preserving local auth and sessions

set -e

PI_AGENT_DIR="${HOME}/.pi/agent"
DOTFILES_PI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing pi config from ${DOTFILES_PI_DIR}"

# Ensure ~/.pi/agent exists
mkdir -p "${PI_AGENT_DIR}"

# Link directories
for dir in extensions prompts skills; do
    src="${DOTFILES_PI_DIR}/${dir}"
    dest="${PI_AGENT_DIR}/${dir}"

    if [ -L "${dest}" ]; then
        echo "  [OK] ${dir} already symlinked"
    elif [ -d "${dest}" ]; then
        echo "  [WARN] ${dir} exists as a real directory -- backing up to ${dir}.backup"
        mv "${dest}" "${dest}.backup"
        ln -s "${src}" "${dest}"
        echo "  [OK] ${dir} symlinked"
    else
        ln -s "${src}" "${dest}"
        echo "  [OK] ${dir} symlinked"
    fi
done

# Link settings.json (but never overwrite auth.json or sessions/)
if [ -f "${PI_AGENT_DIR}/settings.json" ] && [ ! -L "${PI_AGENT_DIR}/settings.json" ]; then
    echo "  [WARN] settings.json exists -- backing up to settings.json.backup"
    mv "${PI_AGENT_DIR}/settings.json" "${PI_AGENT_DIR}/settings.json.backup"
fi

if [ -L "${PI_AGENT_DIR}/settings.json" ]; then
    echo "  [OK] settings.json already symlinked"
else
    ln -s "${DOTFILES_PI_DIR}/settings.json" "${PI_AGENT_DIR}/settings.json"
    echo "  [OK] settings.json symlinked"
fi

# Ensure auth.json and sessions/ exist locally (not in dotfiles)
if [ ! -f "${PI_AGENT_DIR}/auth.json" ]; then
    echo '{"providers":{}}' > "${PI_AGENT_DIR}/auth.json"
    echo "  [OK] Created empty auth.json (local only)"
fi

mkdir -p "${PI_AGENT_DIR}/sessions"
echo "  [OK] Ensured sessions/ directory exists (local only)"

echo ""
echo "[DONE] Pi config installed. Restart pi or run /reload to apply changes."
echo "   Local files: ${PI_AGENT_DIR}/auth.json, ${PI_AGENT_DIR}/sessions/"
echo "   Tracked files: ${DOTFILES_PI_DIR}/"
