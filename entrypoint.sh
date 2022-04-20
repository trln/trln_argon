#!/bin/sh

cd /app || exit

export BOOTSTRAP_VERSION=${BOOTSTRAP_VERSION:-'~>5.1'}

PIDFILE=.internal_test_app/tmp/pids/server.pid

if [ -e "${PIDFILE}" ]; then
    rm "$PIDFILE"
fi

case $1 in 
    clean) 
        rm -rf .internal_test_app
        echo "Test application removed. You can start this container again to get a freshly generated application"
        ;;
    start)
        if [ ! -s .internal_test_app/Gemfile.lock ]; then
            bundle exec rake engine_cart:generate
        fi
        exec bundle exec rake engine_cart:server['-b 0.0.0.0']
        ;;

    test)
        bundle exec rake engine_cart:generate
        exec bundle exec rake spec
        ;;
    update)
        # generates a new Gemfile.lock
        exec bundle update
        ;;
    shell)
        exec /bin/bash;;
    *) 
        exec "$@"
        ;;
esac

