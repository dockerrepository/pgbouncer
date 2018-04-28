# PgBouncer
[![Build Status](https://travis-ci.org/dockerrepository/pgbouncer.svg?branch=master)](https://travis-ci.org/dockerrepository/pgbouncer)

PgBouncer is a lightweight connection pooler for PostgreSQL.
Docker repository for [PgBouncer](https://pgbouncer.github.io) with latest releases.

# Instalation

    $ docker pull dockerrepository/pgbouncer:latest

# Usage Examples
PgBouncer can run using Environment variables or volume with `pgbouncer.ini`

## Using environment variables

    $ docker run -p 6432:6432 \
    -e DB_HOST=127.0.0.1 \ 
    -e PG_USER=postgres \
    AUTH_FILE_CONTENT='"<db_user>" "<password db_user>"' \
    --name pgbouncer dockerrepository/pgbouncer:latest

### Default variables values:
    
    PG_USER=postgres
    PGB_LOG=/var/log/pgbouncer
    LOGFILE=/var/log/pgbouncer/pgbouncer.log
    PGB_PID=/var/run/pgbouncer
    PIDFILE=/var/run/pgbouncer/pgbouncer.pid
    PGB_CONFIG_DIR=/etc/pgbouncer
    PGB_INI=/etc/pgbouncer/pgbouncer.ini
    PG_PORT=5432


## Using volumes

    $ docker run -p 6432:6432 -v <dir-pgbouncer-ini>:/etc/pgbouncer \ --name pgbouncer dockerrepository/pgbouncer:latest
    
## Test Connection

    $ psql -h localhost -U <username> -d <database>

## Execute commands in a running container

    $ docker exec pgbouncer <command>

### PgBouncer help

    $ docker exec pgbouncer pgbouncer --help
    