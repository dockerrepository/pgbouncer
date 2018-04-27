#!/bin/sh

export PGB_LOG=/var/log/pgbouncer
export PGB_PID=/var/run/pgbouncer
export PGB_INI=/etc/pgbouncer/pgbouncer.ini
export PGB_CONFIG_DIR=/etc/pgbouncer
export PGB_USER=postgres

if [ "$2" != "" ]; then
    if [ "$2" = "pgbouncer" ]; then
        exec $@ -u $PGB_USER $PGB_INI
    else
        exec "$@"
    fi
    exit
fi

if [ ! -f "$PGB_INI" ]; then
    echo "Not found file: $PGB_INI"
    exit
fi

adduser ${PGB_USER}
mkdir -p ${PGB_LOG}
mkdir -p ${PGB_PID}
chmod -R 755 ${PGB_LOG}
chmod -R 755 ${PGB_PID}
chown -R ${PGB_USER}:${PGB_USER} ${PGB_LOG}
chown -R ${PGB_USER}:${PGB_USER} ${PGB_PID}

echo "Starting..."
exec /bin/pgbouncer -u $PGB_USER $PGB_INI