# Temporary local override of the plugin's assets generator, See:
# https://github.com/projectblacklight/blacklight_range_limit/blob/main/lib/generators/blacklight_range_limit/assets_generator.rb

# TODO: remove this file once the plugin is capable of running its install generator
# without failing when yarn/importmap are unsupported.
require 'rails/generators'
require 'rails/generators/base'

module BlacklightRangeLimit
  class AssetsGenerator < Rails::Generators::Base
    # Do nothing -- we don't want the assets generator to run because we
    # we are using neither importmap-rails nor yarn, and the generator fails
    # in that case.
  end
end
