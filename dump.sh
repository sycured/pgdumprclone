#!/bin/bash

set -e

PGUSER=${PGUSER:-postgres}
PGDB=${PGDB:-postgres}
PGHOST=${PGHOST:-db}
PGPORT=${PGPORT:-5432}

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/dump/$PGDB-$DATE.sqlc"

echo "Job started: $(date). Dumping to ${FILE}"

pg_dump -Fc -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -f "$FILE" -d "$PGDB" && rclone --config /opt/rclone/rclone.conf copy "$FILE" "$REMOTE_NAME":"$REMOTE_PATH"/ && rm "$FILE"

echo "Job done: $(date)"