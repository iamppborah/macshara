#!/usr/bin/env bash
set -euo pipefail

CLI_PATH="/Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli"
SUDOERS_FILE="/etc/sudoers.d/selfcontrol-cli-nopasswd"
USER_NAME="$(id -un)"

if [[ ! -f "$CLI_PATH" ]]; then
  echo "Error: SelfControl CLI not found at $CLI_PATH"
  echo "Please ensure SelfControl is installed in your Applications folder."
  exit 1
fi

echo "Setting up passwordless sudo for SelfControl..."
echo "You may be prompted for your Mac password to authorize this change."

# Create a temporary file to hold our rule
TMP_FILE=$(mktemp)
echo "$USER_NAME ALL=(ALL) NOPASSWD: $CLI_PATH" > "$TMP_FILE"

# Check syntax to ensure we don't break sudo
if sudo visudo -c -f "$TMP_FILE" >/dev/null 2>&1; then
    # If syntax is valid, move it into the sudoers.d directory
    sudo bash -c "cat '$TMP_FILE' > '$SUDOERS_FILE'"
    sudo chmod 0440 "$SUDOERS_FILE"
    sudo chown root:wheel "$SUDOERS_FILE"
    echo "Success! NOPASSWD entry added at $SUDOERS_FILE"
else
    echo "Error: Syntax check failed. Aborting to protect your sudo configuration."
    rm -f "$TMP_FILE"
    exit 1
fi

rm -f "$TMP_FILE"
