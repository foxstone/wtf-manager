#!/bin/bash

cd /shared/

CURRENT_DATE=$(date +%Y-%m-%d)
LOG_DIR="$HOME/Projects/codebase-knowledge-logs/$CURRENT_DATE"
mkdir -p "$LOG_DIR"

DATE_STAMP=$(date +%Y-%m-%d_%H-%M-%S)

pkill -f "opencode run --command generate-legacy-api-artifacts" 2>/dev/null
pkill -f "opencode run --command generate-ng-frontend-artifacts" 2>/dev/null
pkill -f "opencode run --command generate-platform-api-artifacts" 2>/dev/null

opencode run --command generate-legacy-api-artifacts > "$LOG_DIR/legacy-api_$DATE_STAMP.log" 2>&1 &
opencode run --command generate-ng-frontend-artifacts > "$LOG_DIR/ng-frontend_$DATE_STAMP.log" 2>&1 &
opencode run --command generate-ng-frontend-artifacts > "$LOG_DIR/platform-api_$DATE_STAMP.log" 2>&1 &

echo "Done. Logs in $LOG_DIR"