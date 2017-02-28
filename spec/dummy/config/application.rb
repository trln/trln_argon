require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "trln_argon"

module Dummy
  class Application < Rails::Application

  config.before_configuration do
      env_file = File.join(Rails .root, 'config', 'local_env.yml')
      if File.exists?(env_file)
        YAML.load_file(env_file).each { |key, value| ENV[key.to_s] = value }
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

