#!/usr/bin/env bash

layout_mkcert() {
    NAME="$1"
    PORT="$2"
    CERTS="$(direnv_layout_dir)/certs"
    if [ ! -d $CERTS ]; then
        mkdir -p $CERTS
        mkcert -install
        mkcert $NAME 
        mv "$NAME.pem" "$NAME-key.pem" $CERTS
    fi

    CADDYFILE="$(direnv_layout_dir)/Caddyfile"
    cat <<- EOF > $CADDYFILE
    $NAME {
        reverse_proxy $PORT
        tls $CERTS/$NAME.pem $CERTS/$NAME-key.pem
    }
EOF

    export CERTS
    export CADDYFILE
}
