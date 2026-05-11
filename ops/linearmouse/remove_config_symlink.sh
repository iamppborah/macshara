#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TARGET_DIR="$PROJECT_ROOT/linearmouse"
RESTORE_DIR="$HOME/.config/linearmouse"

if [[ -L "$TARGET_DIR" ]]; then
  rm -f "$TARGET_DIR"
  mkdir -p "$RESTORE_DIR"
  printf 'Unlinked linearmouse repo path: %s\n' "$TARGET_DIR"
  printf 'Ensured local config directory exists: %s\n' "$RESTORE_DIR"
elif [[ -e "$TARGET_DIR" ]]; then
  printf 'No symlink removed; existing path is not a symlink: %s\n' "$TARGET_DIR"
else
  printf 'No symlink found at: %s\n' "$TARGET_DIR"
fi
