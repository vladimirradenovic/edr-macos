#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

$SCRIPT_DIR/process_monitor.sh &
$SCRIPT_DIR/port_monitor.sh &
$SCRIPT_DIR/file_monitor.sh &

wait
