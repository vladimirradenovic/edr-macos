#!/bin/zsh

BASELINE="$HOME/.proc_baseline"
CURRENT="$HOME/.proc_current"

LOGFILE="$HOME/edr.log"
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S")

# Capture full command lines
ps aux | awk '{for(i=11;i<=NF;i++) printf $i " "; print ""}' | sort | uniq > "$CURRENT"

# First run → create baseline
if [ ! -f "$BASELINE" ]; then
    cp "$CURRENT" "$BASELINE"
    echo "[INIT] Process baseline created."
    exit 0
fi

# -----------------------------
# Filtering logic
# -----------------------------

INTERESTING_PATHS="^/Users/|^/opt/homebrew/"

WHITELIST="Google Chrome|OpenVPN|AddressBook|biomesyncd|ReportMemoryException|XProtect|cfprefsd|distnoted|mDNSResponder|syslogd|coreaudiod|bluetoothd|notifyd"

DIFF=$(comm -13 "$BASELINE" "$CURRENT" \
    | grep -E "$INTERESTING_PATHS" \
    | grep -Ev "$WHITELIST" \
    | grep -v "edr_runner.sh" \
    | grep -v "process_monitor.sh" \
    | grep -v "ps aux" \
    | grep -v "awk" \
    | grep -v "sort" \
    | grep -v "uniq" \
    | grep -v "zsh")

# Normalize Python path
DIFF=$(echo "$DIFF" | sed 's|/opt/homebrew/.*/Python|python3|g')

# Trim trailing spaces + remove empty lines
DIFF=$(echo "$DIFF" | sed 's/[[:space:]]*$//' | sed '/^\s*$/d')

# -----------------------------
# Detection
# -----------------------------

if [ -n "$DIFF" ]; then
    echo "⚠️ NEW PROCESS DETECTED"
    echo "$DIFF"

    while IFS= read -r proc; do
        echo "{\"timestamp\":\"$TIMESTAMP\",\"type\":\"process\",\"event\":\"new_process\",\"data\":\"$proc\"}" >> "$LOGFILE"
    done <<< "$DIFF"

    osascript -e 'display notification "New process detected" with title "EDR Alert"'

    cp "$CURRENT" "$BASELINE"
fi
