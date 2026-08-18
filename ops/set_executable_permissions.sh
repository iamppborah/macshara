#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FILES=()
while IFS= read -r file_path; do
  FILES+=("$file_path")
done < <(find "$PROJECT_ROOT/ops" -type f -name "*.sh" | sort)

FILES+=("$PROJECT_ROOT/supercmd/clear_clipboard_history.sh")

for file_path in "${FILES[@]}"; do
  if [[ -f "$file_path" ]]; then
    chmod +x "$file_path"
    printf 'Executable: %s\n' "$file_path"
  else
    printf 'Skipped (missing): %s\n' "$file_path"
  fi
done
