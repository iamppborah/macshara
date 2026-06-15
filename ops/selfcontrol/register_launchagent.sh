#!/usr/bin/env bash
set -euo pipefail

LABEL="com.macshara.selfcontrol.flow-sync"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SCRIPT_PATH="$PROJECT_ROOT/selfcontrol/flow_selfcontrol_sync.sh"
PLIST_SOURCE="$PROJECT_ROOT/jobs/selfcontrol/$LABEL.plist"
PLIST_TARGET="$HOME/Library/LaunchAgents/$LABEL.plist"
GUI_DOMAIN="gui/$(id -u)"
LOG_DIR="$PROJECT_ROOT/logs/selfcontrol"

[[ -f "$SCRIPT_PATH" ]] || { printf 'Error: script not found: %s\n' "$SCRIPT_PATH" >&2; exit 1; }
[[ -f "$PLIST_SOURCE" ]] || { printf 'Error: plist not found: %s\n' "$PLIST_SOURCE" >&2; exit 1; }

mkdir -p "$HOME/Library/LaunchAgents" "$LOG_DIR"

chmod +x "$SCRIPT_PATH"
plutil -lint "$PLIST_SOURCE"

launchctl bootout "$GUI_DOMAIN/$LABEL" >/dev/null 2>&1 || true
launchctl bootout "$GUI_DOMAIN" "$PLIST_TARGET" >/dev/null 2>&1 || true
rm -f "$PLIST_TARGET"
ln -s "$PLIST_SOURCE" "$PLIST_TARGET"

launchctl bootstrap "$GUI_DOMAIN" "$PLIST_TARGET"
launchctl enable "$GUI_DOMAIN/$LABEL"
launchctl print "$GUI_DOMAIN/$LABEL" >/dev/null

printf 'Registered LaunchAgent: %s\n' "$LABEL"
printf 'Script permission fixed: %s\n' "$SCRIPT_PATH"
printf 'Plist linked at: %s\n' "$PLIST_TARGET"
printf 'Logs directory ensured: %s\n' "$LOG_DIR"
