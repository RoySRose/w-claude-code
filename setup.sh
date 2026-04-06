#!/bin/bash
# setup.sh - Sync Claude Code plugins on a new machine
# Usage: cd ~/.claude && ./setup.sh

set -e

echo "=== Claude Code Plugin Sync ==="

# Register marketplaces
echo "[1/2] Registering marketplaces..."
claude plugins marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode.git 2>/dev/null || true

# Install plugins
echo "[2/2] Installing plugins..."
claude plugins install frontend-design@claude-plugins-official 2>/dev/null || true
claude plugins install superpowers@claude-plugins-official 2>/dev/null || true
claude plugins install oh-my-claudecode@omc 2>/dev/null || true

echo ""
echo "Done! Plugins installed. settings.json is already synced via git."
