#!/bin/bash

set -euo pipefail

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/dump/$PGDB-$DATE.sqlc"

echo "Job started: $(date). Dumping to ${FILE}"

pg_dump -Fc -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -f "$FILE" -d "$PGDB" && rclone --config /opt/rclone/rclone.conf copy "$FILE" "$REMOTE_NAME":"$REMOTE_PATH"/ && rm "$FILE"

if [[ -n "$OLDER_THAN" ]]; then
    rclone delete "$REMOTE_NAME":"$REMOTE_PATH"/ --min-age "$OLDER_THAN"
fi

echo "Job done: $(date)"