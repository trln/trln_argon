source 'https://rubygems.org'

# Declare your gem's dependencies in trln_argon.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

# BEGIN ENGINE_CART BLOCK
# engine_cart: 2.6.0
# engine_cart stanza: 2.5.0
# the below comes from engine_cart, a gem used to test this Rails engine gem in the context of a Rails app.
file = File.expand_path('Gemfile', ENV['ENGINE_CART_DESTINATION'] || ENV['RAILS_ROOT'] || File.expand_path('.internal_test_app', File.dirname(__FILE__)))

if File.exist?(file)
  begin
    eval_gemfile file
  rescue Bundler::GemfileError => e
    Bundler.ui.warn '[EngineCart] Skipping Rails application dependencies:'
    Bundler.ui.warn e.message
  end
else
  Bundler.ui.warn "[EngineCart] Unable to find test application dependencies in #{file}, using placeholder dependencies"

  # TRLN CUSTOMIZATION:
  # We'll use the Rails --skip-javascript flag so when generated we
  # won't get the default JS files in app/javascript. We are sticking
  # with Sprockets for now; our JS is in app/assets/javascripts.
  # We also run --skip-bundle to avoid running `bundle install` upon the
  # initial creation of the Rails app. We'll run it later in our generator
  # steps after customizing the Gemfile.
  ENV['ENGINE_CART_RAILS_OPTIONS'] = '--skip-javascript --skip-bundle'

  if ENV['RAILS_VERSION']
    if ENV['RAILS_VERSION'] == 'edge'
      gem 'rails', github: 'rails/rails'
      ENV['ENGINE_CART_RAILS_OPTIONS'] = '--edge --skip-turbolinks --skip-javascript'
    else
      gem 'rails', ENV['RAILS_VERSION']
    end
  end
end
# END ENGINE_CART BLOCK
