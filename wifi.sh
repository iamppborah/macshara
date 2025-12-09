#!/bin/bash

SSID="${SSID}"
PASSWORD="${PASSWORD}"

if [ -z "$SSID" ]; then
    echo "Error: SSID environment variable is not set"
    exit 1
fi

if [ -z "$PASSWORD" ]; then
    echo "Error: PASSWORD environment variable is not set"
    exit 1
fi

echo "SSID: $SSID"
echo "PASSWORD: ${PASSWORD}"


INTERFACE="en0"
MAX_TIME=250
SECONDS=0
WAIT=5


printf "Trying to connect to Wi-Fi network %s using below commands \033[1m↓\033[0m\n" "$SSID"
printf "\033[1mnetworksetup -setairportpower %s off\033[0m\n" "$INTERFACE"
printf "\033[1mnetworksetup -setairportpower %s on\033[0m\n" "$INTERFACE"
printf "\033[1mnetworksetup -setairportnetwork %s <SSID> <PASSWORD>\033[0m\n" "$INTERFACE"

while [ $SECONDS -lt $MAX_TIME ]; do
    networksetup -setairportpower $INTERFACE off
    networksetup -setairportpower $INTERFACE on
    networksetup -setairportnetwork $INTERFACE $SSID $PASSWORD >stdout_pipe &
    PID=$!

    while kill -0 $PID 2>/dev/null; do
        printf "\033[KPID: %s | Elapsed Time: %ss\r" "$PID" "$SECONDS"
        sleep 1
    done

    wait $PID
    EXIT_STATUS=$?

    OUTPUT=$(cat stdout_pipe)

    if [ $EXIT_STATUS -eq 0 ]; then
        if echo "$OUTPUT" | grep -Eiq "Could not find network|Failed to join network"; then
            printf "\033[KError: Could not find Wi-Fi network %s. Retrying...\r" "$SSID"
            sleep $WAIT
        else
            printf "Command succeeded with PID: %s and exit status: %s\n" "$PID" "$EXIT_STATUS"
            echo "Exiting..."
            rm stdout_pipe
            exit 0
        fi
    else
        printf "\033[KCommand failed with PID: %s and exit status: %s. Retrying...\r" "$PID" "$EXIT_STATUS"
        sleep $WAIT
    fi

    if [ $SECONDS -ge $MAX_TIME ]; then
        printf "Maximum retry time of %ss reached.\n" "$MAX_TIME"
        echo "Exiting..."
        rm stdout_pipe
        exit 1
   fi
done

