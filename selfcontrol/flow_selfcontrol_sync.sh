#!/usr/bin/env bash

POLL_INTERVAL=5
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOCKLIST_PATH="$SCRIPT_DIR/blocklist.selfcontrol"

echo "[$(date)] Started Flow <-> SelfControl sync monitor..."

while true; do
    if pgrep -x "Flow" > /dev/null; then
        CURRENT_PHASE=$(osascript -e 'tell application "Flow" to get phase' 2>/dev/null || echo "")
        if [ "$CURRENT_PHASE" = "Flow" ]; then
            # Assuming `sudo visudo` has NOPASSWD entry for selfcontrol-cli
            SC_STATUS=$(sudo /Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli is-running 2>/dev/null || echo "NO")
            if [[ "$SC_STATUS" == *"NO"* ]]; then
                echo "[$(date)] Pomodoro phase detected! Starting SelfControl for 25 mins..."
                END_DATE=$(date -u -v+25M +"%Y-%m-%dT%H:%M:%SZ")
                TARGET_UID=$(id -u)
                sudo /Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli --uid "$TARGET_UID" start --blocklist "$BLOCKLIST_PATH" --enddate "$END_DATE"
            fi
        fi
    fi
    sleep "$POLL_INTERVAL"
done
