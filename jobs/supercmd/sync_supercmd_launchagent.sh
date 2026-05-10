#!/usr/bin/env bash
set -euo pipefail

LABEL="com.macshara.supercmd.clear-clipboard-history"
SCRIPT_PATH="/Users/iamppborah/Developer/personal/macshara/supercmd/clear_clipboard_history.sh"
PLIST_SOURCE="/Users/iamppborah/Developer/personal/macshara/jobs/supercmd/com.macshara.supercmd.clear-clipboard-history.plist"
PLIST_TARGET="$HOME/Library/LaunchAgents/$LABEL.plist"
GUI_DOMAIN="gui/$(id -u)"

[[ -f "$SCRIPT_PATH" ]] || { printf 'Error: script not found: %s\n' "$SCRIPT_PATH" >&2; exit 1; }
[[ -f "$PLIST_SOURCE" ]] || { printf 'Error: plist not found: %s\n' "$PLIST_SOURCE" >&2; exit 1; }

mkdir -p "$HOME/Library/LaunchAgents"

chmod +x "$SCRIPT_PATH"
plutil -lint "$PLIST_SOURCE"

launchctl bootout "$GUI_DOMAIN" "$PLIST_TARGET" >/dev/null 2>&1 || true
rm -f "$PLIST_TARGET"
ln -s "$PLIST_SOURCE" "$PLIST_TARGET"

launchctl bootstrap "$GUI_DOMAIN" "$PLIST_TARGET"
launchctl enable "$GUI_DOMAIN/$LABEL"
launchctl print "$GUI_DOMAIN/$LABEL" >/dev/null

printf 'Synced LaunchAgent: %s\n' "$LABEL"
printf 'Script permission fixed: %s\n' "$SCRIPT_PATH"
printf 'Plist linked at: %s\n' "$PLIST_TARGET"
