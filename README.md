# pg_dump with rclone

## Usage

Attach a target PostgreSQL container to this container and mount a volume to `/dump` folder.

Backups will appear in this volume.

Optionally set up cron job schedule (default is `0 1 * * *` - runs every day at 1:00 am).

## Environment Variables:

| Variable        | Required? | Default   | Description                                            |
|-----------------|:----------|:----------|:-------------------------------------------------------|
| `PGUSER`        | Required  | postgres  | The user for accessing the database                    |
| `PGPASSWORD`    | Optional  |           | The password for accessing the database                |
| `PGDB`          | Optional  | postgres  | The name of the database                               |
| `PGHOST`        | Optional  | db        | The hostname of the database                           |
| `PGPORT`        | Optional  | `5432`    | The port for the database                              |
| `CRON_SCHEDULE` | Required  | 0 1 * * * | The cron schedule at which to run the pg_dump          |
| `REMOTE_NAME`   | Rquired   | minio     | Rclone remote name                                     |
| `REMOTE_PATH`   | Required  | pg_dump   | Folder where to upload dumps                           |
| `OLDER_THAN`    | Optional  |           | Delete all backups older than this duration (ex. 366d) |

Docker Compose
==============

Example with docker-compose:

```yaml
database:
  image: postgres:14
  volumes:
    - ./persistent/data:/var/lib/postgresql/data
  environment:
    - POSTGRES_PASSWORD=S0m3Passw0rdHere
    - POSTGRES_DB=postgres
  restart: unless-stopped

postgres-backup:
  image: sycured/pg_dump:latest
  container_name: postgres-backup
  links:
    - database:db # Maps as "db"
  environment:
    - PGUSER=postgres
    - PGPASSWORD=SumPassw0rdHere
    - CRON_SCHEDULE=0 3 * * * # Every day at 3am
    - PGDB=postgres # The name of the database to dump 
  #  - PGHOST=db # The hostname of the PostgreSQL database to dump
  volumes:
    - ./persistent/data:/dump
```