#!/bin/zsh

BASELINE="$HOME/.file_baseline"
CURRENT="$HOME/.file_current"

WATCH_DIRS="/opt/homebrew/bin /usr/local/bin /tmp"

find $WATCH_DIRS -type f -perm -111 2>/dev/null | sort > "$CURRENT"

if [ ! -f "$BASELINE" ]; then
    cp "$CURRENT" "$BASELINE"
    echo "[INIT] File baseline created."
    exit 0
fi

WHITELIST="\.DS_Store|\.cache|\.tmp|gems|\.git"

DIFF=$(comm -13 "$BASELINE" "$CURRENT" \
    | grep -Ev "$WHITELIST" \
    | grep -v "^/tmp/.*\.tmp")

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../logs/edr.log"
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")

if [ -n "$DIFF" ]; then
    echo "⚠️ NEW EXECUTABLE DETECTED"
    echo "$DIFF"

    while IFS= read -r file; do
        echo "{\"timestamp\":\"$TIMESTAMP\",\"type\":\"file\",\"event\":\"new_binary\",\"data\":\"$file\"}" >> "$LOG_FILE" 
    done <<< "$DIFF"

    osascript -e 'display notification "New binary detected" with title "EDR Alert"'

    cp "$CURRENT" "$BASELINE"
fi
