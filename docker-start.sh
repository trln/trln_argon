#!/bin/bash

# since wer're running in a container, generally
# engine_cart won't have the chance to clean up after itself
# and this pid file will straggle, preventing startup

rm -f .internal_test_app/tmp/pids/server.pid 

bundle exec rake engine_cart:server['-b 0.0.0.0']
