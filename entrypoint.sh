#!/bin/bash

set -euo pipefail

COMMAND=${1:-dump-cron}
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
PGUSER=${PGUSER:-postgres}
PGDB=${PGDB:-postgres}
PGHOST=${PGHOST:-db}
PGPORT=${PGPORT:-5432}
REMOTE_NAME=${REMOTE_NAME:-minio}
REMOTE_PATH=${REMOTE_PATH:-pg_dump}


if [[ "${COMMAND}" == 'dump' ]]; then
    exec /dump.sh
elif [[ "${COMMAND}" == 'dump-cron' ]]; then
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "${LOGFIFO}" ]]; then
        mkfifo "${LOGFIFO}"
    fi
    CRON_ENV="PGUSER='${PGUSER}'\nPGDB='${PGDB}'\nPGHOST='${PGHOST}'\nPGPORT='${PGPORT}'\nREMOTE_NAME='${REMOTE_NAME}'\nREMOTE_PATH='${REMOTE_PATH}'"
    if [[ -n "${PGPASSWORD}" ]]; then
        CRON_ENV="$CRON_ENV\nPGPASSWORD='${PGPASSWORD}'"
    fi

    if [[ -n "$OLDER_THAN" ]]; then
        CRON_ENV="$CRON_ENV\nOLDER_THAN='$OLDER_THAN'"
    fi

    echo -e "$CRON_ENV\n$CRON_SCHEDULE /dump.sh > $LOGFIFO 2>&1" | crontab -
    # crontab -l
    cron
    tail -f "$LOGFIFO"
else
    echo "Unknown command $COMMAND"
    echo "Available commands: dump, dump-cron"
    exit 1
fi