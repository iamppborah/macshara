#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SOURCE_DIR="$PROJECT_ROOT/linearmouse"
TARGET_DIR="$HOME/.config/linearmouse"
SOURCE_FILE="$SOURCE_DIR/linearmouse.json"
TARGET_FILE="$TARGET_DIR/linearmouse.json"

mkdir -p "$HOME/.config"

if [[ -L "$SOURCE_DIR" ]]; then
  rm -f "$SOURCE_DIR"
  mkdir -p "$SOURCE_DIR"
elif [[ ! -d "$SOURCE_DIR" ]]; then
  mkdir -p "$SOURCE_DIR"
fi

if [[ -f "$TARGET_FILE" && ! -f "$SOURCE_FILE" ]]; then
  cp "$TARGET_FILE" "$SOURCE_FILE"
fi

[[ -d "$SOURCE_DIR" ]] || { printf 'Error: missing source directory: %s\n' "$SOURCE_DIR" >&2; exit 1; }

if [[ -L "$TARGET_DIR" ]]; then
  if [[ "$(readlink "$TARGET_DIR")" == "$SOURCE_DIR" ]]; then
    printf 'Linearmouse config already symlinked: %s -> %s\n' "$TARGET_DIR" "$SOURCE_DIR"
    exit 0
  fi
  rm -f "$TARGET_DIR"
elif [[ -e "$TARGET_DIR" ]]; then
  rm -rf "$TARGET_DIR"
fi

ln -s "$SOURCE_DIR" "$TARGET_DIR"
printf 'Symlinked linearmouse config path: %s -> %s\n' "$TARGET_DIR" "$SOURCE_DIR"
