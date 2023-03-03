#!/usr/bin/env bash
layout_postgres() {
    echo "Initializing Postgres..."
    export PGDATA="$(direnv_layout_dir)/postgres"
    export PGHOST="$PGDATA"

    if [[ ! -d "$PGDATA" ]]; then
        initdb
        rm "$PGDATA/postgresql.conf"
        echo "listen_addresses = ''" >> "$PGDATA/postgresql.conf"
        echo "unix_socket_directories = '$PGHOST'" >> "$PGDATA/postgresql.conf"
        echo "CREATE DATABASE $USER;" | postgres --single -E postgres
    fi
}
