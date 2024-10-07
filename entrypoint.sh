#!/bin/sh

check_bundle() {
    bundle config set path /gems && bundle check || bundle install -j "$(nproc)"
}

cd /app || exit

export BOOTSTRAP_VERSION="${BOOTSTRAP_VERSION:-~>5.3}"

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
        check_bundle
        if [ ! -s .internal_test_app/Gemfile.lock ]; then
            bundle exec rake engine_cart:generate
        fi
        exec bundle exec rake engine_cart:server['-b 0.0.0.0']
        ;;

    test)
        check_bundle
        bundle exec rake engine_cart:generate
        exec bundle exec rake spec
        ;;
    rubocop)
        check_bundle
        bundle exec rubocop
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
