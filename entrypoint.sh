#!/bin/sh

export PGB_USER=postgres

export PGB_LOG=${PGB_LOG:-/var/log/pgbouncer}
export PGB_PID=${PGB_PID:-/var/run/pgbouncer}
export PGB_CONFIG_DIR=${PGB_CONFIG_DIR:-/etc/pgbouncer}

export PGB_INI=$PGB_CONFIG_DIR/pgbouncer.ini
export PIDFILE=$PGB_PID/pgbouncer.pid
export LOGFILE=$PGB_LOG/pgbouncer.log

adduser ${PGB_USER}
mkdir -p ${PGB_LOG}
mkdir -p ${PGB_PID}
mkdir -p ${PGB_CONFIG_DIR}
chmod -R 755 ${PGB_LOG}
chmod -R 755 ${PGB_PID}
chown -R ${PGB_USER}:${PGB_USER} ${PGB_LOG}
chown -R ${PGB_USER}:${PGB_USER} ${PGB_PID}

if [ -n "$AUTH_FILE_CONTENT" ]; then
    AUTH_FILE=$PGB_CONFIG_DIR/userlist.txt
    echo "Created: $AUTH_FILE"
    echo "$AUTH_FILE_CONTENT" > $AUTH_FILE
fi

if [ ! -f "$PGB_INI" ]; then
       
    DB_HOST=${DB_HOST:?"Setup pgbouncer config error! You must set DB_HOST env"}
    DB_PORT=${DB_PORT:-5432}
    DB_USER=${DB_USER:-postgres}

    echo "Created pgbouncer config: $PGB_INI"

cat <<EOF | sed -e '/^$/d' > $PGB_INI

# pgbouncer.ini
# The configuration file is in “ini” format. Section names are between “[” and “]”. 
# Lines starting with “;” or “#” are taken as comments and ignored. 
# The characters “;” and “#” are not recognized when they appear later in the line.

# Full Documentation - https://pgbouncer.github.io/config.html

[databases]
* = host=${DB_HOST} port=${DB_PORT} user=${DB_USER} ${DB_PASSWORD:+password=${DB_PASSWORD}}

[pgbouncer]

;;; Administrative settings
${LOGFILE:+logfile = ${LOGFILE}}
${PIDFILE:+pidfile = ${PIDFILE}}

;;; Connections settings to wait for clients
listen_addr = 0.0.0.0
${LISTEN_PORT:+listen_port = ${LISTEN_PORT:-6432}}
${UNIX_SOCKET_DIR:+unix_socket_dir = ${UNIX_SOCKET_DIR:-/tmp}}
${UNIX_SOCKET_MODE:+unix_socket_mode = ${UNIX_SOCKET_MODE:-0777}}
${UNIX_SOCKET_GROUP:+unix_socket_group = ${UNIX_SOCKET_GROUP}}

;;; TLS settings for accepting clients
${CLIENT_TLS_SSLMODE:+client_tls_sslmode = ${CLIENT_TLS_SSLMODE}}
${CLIENT_TLS_CA_FILE:+client_tls_ca_file = ${CLIENT_TLS_CA_FILE}}
${CLIENT_TLS_KEY_FILE:+client_tls_key_file = ${CLIENT_TLS_KEY_FILE}}
${CLIENT_TLS_CERT_FILE:+client_tls_cert_file = ${CLIENT_TLS_CERT_FILE}}
${CLIENT_TLS_CIPHERS:+client_tls_ciphers = ${CLIENT_TLS_CIPHERS}}
${CLIENT_TLS_PROTOCOLS:+client_tls_protocols = ${CLIENT_TLS_PROTOCOLS}}
${CLIENT_TLS_DHEPARAMS:+client_tls_dheparams = ${CLIENT_TLS_DHEPARAMS}}
${CLIENT_TLS_ECDHCURVE:+client_tls_ecdhcurve = ${CLIENT_TLS_ECDHCURVE}}

;;; TLS settings for connecting to backend databases
${SERVER_TLS_SSLMODE:+server_tls_sslmode = ${SERVER_TLS_SSLMODE}}
${SERVER_TLS_CA_FILE:+server_tls_ca_file = ${SERVER_TLS_CA_FILE}}
${SERVER_TLS_KEY_FILE:+server_tls_key_file = ${SERVER_TLS_KEY_FILE}}
${SERVER_TLS_CERT_FILE:+server_tls_cert_file = ${SERVER_TLS_CERT_FILE}}
${SERVER_TLS_PROTOCOLS:+server_tls_protocols = ${SERVER_TLS_PROTOCOLS}}
${SERVER_TLS_CIPHERS:+server_tls_ciphers = ${SERVER_TLS_CIPHERS}}

;;; Authentication settings
${AUTH_TYPE:-auth_type = ${AUTH_TYPE:-any}}
${AUTH_FILE:+auth_file = ${AUTH_FILE}}
${AUTH_HBA_FILE:+auth_hba_file = ${AUTH_HBA_FILE}}
${AUTH_QUERY:+auth_query = ${AUTH_QUERY}}

;;; Users allowed into database 'pgbouncer'
${ADMIN_USERS:+admin_users = ${ADMIN_USERS}}
${STATS_USERS:+stats_users = ${STATS_USERS}}

;;; Pooler Settings
${POOL_MODE:-pool_mode = ${POOL_MODE:-session}}
${SERVER_RESET_QUERY:+server_reset_query = ${SERVER_RESET_QUERY}}
${SERVER_RESET_QUERY_ALWAYS:+server_reset_query_always = ${SERVER_RESET_QUERY_ALWAYS}}
${IGNORE_STARTUP_PARAMETERS:+ignore_startup_parameters = ${IGNORE_STARTUP_PARAMETERS}}
${SERVER_CHECK_QUERY:+server_check_query = ${SERVER_CHECK_QUERY}}
${SERVER_CHECK_DELAY:+server_check_delay = ${SERVER_CHECK_DELAY}}
${APPLICATION_NAME_ADD_HOST:+application_name_add_host = ${APPLICATION_NAME_ADD_HOST}}
${MAX_CLIENT_CONN:+max_client_conn = ${MAX_CLIENT_CONN}}
${DEFAULT_POOL_SIZE:+default_pool_size = ${DEFAULT_POOL_SIZE}}
${MIN_POOL_SIZE:+min_pool_size = ${MIN_POOL_SIZE}}
${RESERVE_POOL_SIZE:+reserve_pool_size = ${RESERVE_POOL_SIZE}}
${RESERVE_POOL_TIMEOUT:+reserve_pool_timeout = ${RESERVE_POOL_TIMEOUT}}
${MAX_DB_CONNECTIONS:+max_db_connections = ${MAX_DB_CONNECTIONS}}
${MAX_USER_CONNECTIONS:+max_user_connections = ${MAX_USER_CONNECTIONS}}
${SERVER_ROUND_ROBIN:+server_round_robin = ${SERVER_ROUND_ROBIN}}

;;; Logging
${SYSLOG:+syslog = ${SYSLOG}}
${SYSLOG_FACILITY:+syslog_facility = ${SYSLOG_FACILITY}}
${SYSLOG_IDENT:+syslog_ident = ${SYSLOG_IDENT}}
${LOG_CONNECTIONS:+log_connections = ${LOG_CONNECTIONS}}
${LOG_DISCONNECTIONS:+log_disconnections = ${LOG_DISCONNECTIONS}}
${LOG_POOLER_ERRORS:+log_pooler_errors = ${LOG_POOLER_ERRORS}}
${STATS_PERIOD:+stats_period = ${STATS_PERIOD}}
${VERBOSE:+verbose = ${VERBOSE}}

;;; Timeouts
${SERVER_LIFETIME:+server_lifetime = ${SERVER_LIFETIME}}
${SERVER_IDLE_TIMEOUT:+server_idle_timeout = ${SERVER_IDLE_TIMEOUT}}
${SERVER_CONNECT_TIMEOUT:+server_connect_timeout = ${SERVER_CONNECT_TIMEOUT}}
${SERVER_LOGIN_RETRY:+server_login_retry = ${SERVER_LOGIN_RETRY}}

;;; Dangerous Timeouts.
${QUERY_TIMEOUT:+query_timeout = ${QUERY_TIMEOUT}}
${QUERY_WAIT_TIMEOUT:+query_wait_timeout = ${QUERY_WAIT_TIMEOUT}}
${CLIENT_IDLE_TIMEOUT:+client_idle_timeout = ${CLIENT_IDLE_TIMEOUT}}
${CLIENT_LOGIN_TIMEOUT:+client_login_timeout = ${CLIENT_LOGIN_TIMEOUT}}
${AUTODB_IDLE_TIMEOUT:+autodb_idle_timeout = ${AUTODB_IDLE_TIMEOUT}}
${SUSPEND_TIMEOUT:+suspend_timeout = ${SUSPEND_TIMEOUT}}
${IDLE_TRANSACTION_TIMEOUT:+idle_transaction_timeout = ${IDLE_TRANSACTION_TIMEOUT}}

;;; Low-level tuning options
${PKT_BUF:+pkt_buf = ${PKT_BUF}}
${LISTEN_BACKLOG:+listen_backlog = ${LISTEN_BACKLOG}}
${SBUF_LOOPCNT:+sbuf_loopcnt = ${SBUF_LOOPCNT}}
${MAX_PACKET_SIZE:+max_packet_size = ${MAX_PACKET_SIZE}}

;;; networking options, for info: man 7 tcp
${TCP_DEFER_ACCEPT:+tcp_defer_accept = ${TCP_DEFER_ACCEPT}}
${TCP_SOCKET_BUFFER:+tcp_socket_buffer = ${TCP_SOCKET_BUFFER}}
${TCP_KEEPALIVE:+tcp_keepalive = ${TCP_KEEPALIVE}}
${TCP_KEEPCNT:+tcp_keepcnt = ${TCP_KEEPCNT}}
${TCP_KEEPIDLE:+tcp_keepidle = ${TCP_KEEPIDLE}}
${TCP_KEEPINTVL:+tcp_keepintvl = ${TCP_KEEPINTVL}}
${DNS_MAX_TTL:+dns_max_ttl = ${DNS_MAX_TTL}}
${DNS_ZONE_CHECK_PERIOD:+dns_zone_check_period = ${DNS_ZONE_CHECK_PERIOD}}
${DNS_NXDOMAIN_TTL:+dns_nxdomain_ttl = ${DNS_NXDOMAIN_TTL}}

;;; Random stuff
${DISABLE_PQEXEC:+disable_pqexec = ${DISABLE_PQEXEC}}
${CONFFILE:+conffile = ${CONFFILE}}
${SERVICE_NAME:+service_name = ${SERVICE_NAME}}
${JOB_NAME:+job_name = ${JOB_NAME}}
EOF
fi

cat $PGB_INI

echo -e "\n\n>>> PgBouncer started\n"
exec /bin/pgbouncer -u $PGB_USER $PGB_INI