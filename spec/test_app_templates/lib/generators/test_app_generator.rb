require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root './spec/test_app_templates'

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application

  def add_gems
    gem 'blacklight', '~> 8.0'

    if RUBY_VERSION < '3.0'
      # Hack for https://github.com/cbeer/engine_cart/issues/125
      gsub_file 'Gemfile', /^gem ["']sqlite3["'].*$/, 'gem "sqlite3", "< 1.7"'
    end

    Bundler.with_clean_env do
      run 'bundle install'
    end
  end

  def run_blacklight_generator
    say_status('warning', 'GENERATING BL', :yellow)

    generate 'blacklight:install', '--devise', '--skip-solr'
  end

  def install_engine
    generate 'trln_argon:install'
  end
end
