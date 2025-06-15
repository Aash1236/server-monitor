#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="./debug.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo ">>> Script started at $(date)"
source config.cfg
source utils.sh

TODAY=$(date +%F)
JSON_LOG="logs/reports-$TODAY.json"
TXT_REPORT="reports/summary-$TODAY.txt"

check_cpu
check_mem
check_disk
check_top_processes
check_docker_stats

mkdir -p logs reports

#JSON logs
cat <<EOF > $JSON_LOG
{
    "date": "$TODAY",
    "cpu_usage": "$CPU_USAGE",
    "memory_usage": "$MEM_USAGE",
    "disk_usage": "$DISK_USAGE",
    "top_processes": "$(echo "$TOP_PROCESSES" | sed 's/"/\\"/g')",
    "docker_stats": "$(echo "$DOCKER_STATS" | sed 's/"/\\"/g')"
}
EOF

#text summary
{
    echo "===== Health Summary ($TODAY) ====="
    echo "CPU Usage   : $CPU_USAGE%"
    echo "Memory Usage: $MEM_USAGE%"
    echo "Disk Usage  : $DISK_USAGE%"
    echo
    echo "Top 5 Processes:"
    echo "$TOP_PROCESSES"
    echo
    echo "Docker Container Stats:"
    echo "$DOCKER_STATS"
} > "$TXT_REPORT"

#send alerts
alert() {
    # echo "$1" | mail -s "⚠️ SERVER ALERT: $1%" "$EMAIL"
    local message="$1"
    curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\": \"\`\`\`$message\`\`\`\"}" "$SLACK_WEBHOOK"
}

if [[ $CPU_USAGE -gt $CPU_THRESHOLD || $MEM_USAGE -gt $MEM_THRESHOLD || $DISK_USAGE -gt $DISK_THRESHOLD ]]; then
    alert "$(cat "$TXT_REPORT")"
fi
