#!/bin/zsh

BASELINE="$HOME/.ports_baseline"
CURRENT="$HOME/.ports_current"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../logs/edr.log"
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")

# Get current listening ports
lsof -nP -iTCP -sTCP:LISTEN | awk '{print $1,$9}' | sort > "$CURRENT"

# First run → create baseline
if [ ! -f "$BASELINE" ]; then
    cp "$CURRENT" "$BASELINE"
    echo "[INIT] Baseline created."
    exit 0
fi

# Compare (clean output)
DIFF=$(comm -13 "$BASELINE" "$CURRENT" \
    | grep -v "127.0.0.1")

if [ -n "$DIFF" ]; then
    echo "⚠️ PORT CHANGE DETECTED"
    echo "$DIFF"

    while IFS= read -r port; do
        echo "{\"timestamp\":\"$TIMESTAMP\",\"type\":\"port\",\"event\":\"port_change\",\"data\":\"$port\"}" >> "$LOG_FILE" 
    done <<< "$DIFF"

    osascript -e 'display notification "Port change detected" with title "EDR Alert"'

    cp "$CURRENT" "$BASELINE"
fi
