#!/bin/sh

export RAILS_ENV='production'
export SECRET_KEY_BASE='fbc70110b6b435eb3419f51cdbeebb6d872689bb834dd14e4b491a046755bb7a'
bundle exec rake assets:precompile
bundle exec puma -d
