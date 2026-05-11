#!/usr/bin/env bash
set -euo pipefail

LABEL="com.macshara.supercmd.clear-clipboard-history"
PLIST_TARGET="$HOME/Library/LaunchAgents/$LABEL.plist"
GUI_DOMAIN="gui/$(id -u)"

launchctl bootout "$GUI_DOMAIN/$LABEL" >/dev/null 2>&1 || true
launchctl bootout "$GUI_DOMAIN" "$PLIST_TARGET" >/dev/null 2>&1 || true

if [[ -L "$PLIST_TARGET" || -f "$PLIST_TARGET" ]]; then
  rm -f "$PLIST_TARGET"
  printf 'Removed LaunchAgent link: %s\n' "$PLIST_TARGET"
else
  printf 'No LaunchAgent link found at: %s\n' "$PLIST_TARGET"
fi

printf 'LaunchAgent removed: %s\n' "$LABEL"
