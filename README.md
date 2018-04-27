# PgBouncer

Docker image with latest release of pgbouncer https://pgbouncer.github.io/


# Instalation

    $> docker pull dockerrepository/pgbouncer:latest

# Usage

    $> docker run -v "$PWD":/etc/pgbouncer --rm --name pgbouncer dockerrepository/pgbouncer:latest

# Execute command in a running container

    $> docker exec pgbouncer pgbouncer --help