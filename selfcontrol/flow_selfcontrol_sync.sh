#!/usr/bin/env bash

POLL_INTERVAL=5
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[$(date)] Started Flow <-> SelfControl sync monitor..."

while true; do
    if pgrep -x "Flow" > /dev/null; then
        CURRENT_PHASE=$(osascript -e 'tell application "Flow" to getPhase' || echo "")
        if [ "$CURRENT_PHASE" = "Flow" ]; then
            SC_STATUS=$(/Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli is-running 2>&1 || echo "NO")
            if [[ "$SC_STATUS" == *"NO"* ]]; then
                echo "[$(date)] Pomodoro phase detected! Starting SelfControl for 25 mins..."
                END_DATE=$(date -u -v+25M +"%Y-%m-%dT%H:%M:%SZ")
                TARGET_UID=$(id -u)
                
                # Sync the plain text blocklist to SelfControl's internal preferences
                BLOCKLIST_PATH="$SCRIPT_DIR/blocklist.selfcontrol"
                if [ -f "$BLOCKLIST_PATH" ]; then
                    DOMAIN_ARGS=()
                    while IFS= read -r domain || [ -n "$domain" ]; do
                        # Skip empty lines and comments
                        [[ -z "$domain" || "$domain" == \#* ]] && continue
                        # Remove leading/trailing whitespace
                        domain="$(echo -e "${domain}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
                        [[ -n "$domain" ]] && DOMAIN_ARGS+=("$domain")
                    done < "$BLOCKLIST_PATH"
                    if [ ${#DOMAIN_ARGS[@]} -gt 0 ]; then
                        defaults write org.eyebeam.SelfControl Blocklist -array "${DOMAIN_ARGS[@]}"
                    fi
                fi

                # Assuming `sudo visudo` has NOPASSWD entry for selfcontrol-cli
                sudo /Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli --uid "$TARGET_UID" start --enddate "$END_DATE"
            fi
        fi
    fi
    sleep "$POLL_INTERVAL"
done
