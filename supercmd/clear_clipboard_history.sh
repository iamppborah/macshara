#!/usr/bin/env bash
set -euo pipefail

APP_NAME="SuperCmd"
DATA_DIR="$HOME/Library/Application Support/SuperCmd/clipboard-history"

quit_app() {
  printf 'Closing %s...\n' "$APP_NAME"
  osascript -e "tell application \"$APP_NAME\" to quit" >/dev/null 2>&1 || true
  sleep 1
  pkill -x "$APP_NAME" >/dev/null 2>&1 || true
}

clear_history() {
  printf 'Clearing clipboard history at %s...\n' "$DATA_DIR"
  rm -rf "$DATA_DIR"
  mkdir -p "$DATA_DIR"
}

start_app() {
  printf 'Restarting %s...\n' "$APP_NAME"
  open -a "$APP_NAME"
}

main() {
  quit_app
  clear_history
  start_app
  printf 'Done. Fresh clipboard history started.\n'
}

main
