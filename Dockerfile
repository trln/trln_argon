FROM ruby:2.7.5 AS app_bootstrap

RUN apt-get update && apt-get install -y nodejs vim tree

FROM app_bootstrap AS builder

COPY ./Gemfile ./trln_argon.gemspec ./VERSION ./bundler_config.rb /build/

COPY lib/trln_argon/version.rb /build/lib/trln_argon/version.rb

WORKDIR /build

RUN tree

RUN $(./bundler_config.rb path /gems) && bundle install -j $(nproc)

FROM app_bootstrap

COPY --from=builder /gems /gems
COPY ./bundler_config.rb .

RUN $(./bundler_config.rb path /gems)

WORKDIR /app

EXPOSE 3000

ENV ENGINE_CART_RAILS_OPTIONS="--skip-webpack-install --skip-javascript"

ENV BOOTSTRAP_VERSION="~> 4.1"

# allows setting options for caching HTTP operations
# used in unit testing with 'vcr', a ruby framework for recording
# http interactions.  see https://bibwild.wordpress.com/2017/02/07/ruby-vcr-easy-trick-for-easy-re-record/
ENV VCR='once'

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# need to bind to 0.0.0.0 for the port bind to work
CMD ["start"]
