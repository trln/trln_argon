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
    say_status('info', '================================', :magenta)
    say_status('info', 'Generating Blacklight w/o assets', :magenta)
    say_status('info', '================================', :magenta)

    # Skip the default BL assets generator via --skip-assets:
    generate 'blacklight:install', '--devise', '--skip-solr', '--skip-assets'

    # We need to explicitly specify BL8's Sprockets assets generator, else
    # BL will assume we want to use Propshaft or Importmap. See:
    # https://github.com/projectblacklight/blacklight/blob/release-8.x/lib/generators/blacklight/assets_generator.rb
    # https://github.com/projectblacklight/blacklight/blob/release-8.x/lib/generators/blacklight/assets/sprockets_generator.rb
    say_status('info', '========================================', :magenta)
    say_status('info', 'Generating Blacklight assets w/Sprockets', :magenta)
    say_status('info', '========================================', :magenta)
    generate 'blacklight:assets:sprockets'
  end

  def install_engine
    say_status('info', '============================', :magenta)
    say_status('info', 'Generating TRLN Argon engine', :magenta)
    say_status('info', '============================', :magenta)
    generate 'trln_argon:install'
  end
end
