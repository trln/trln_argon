require 'blacklight'
require 'blacklight_advanced_search'

module TrlnArgon
  class Engine < ::Rails::Engine
    isolate_namespace TrlnArgon

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configuration=(configuration)
      @configuration = configuration
    end

    def self.configure
      yield configuration
    end

    class Configuration

      attr_accessor :rollup_field,
                    :preferred_record_field,
                    :preferred_record_value,
                    :local_institution,
                    :local_records_field,
                    :local_records_values,
                    :apply_local_filter_by_default,
                    :application_name

      def initialize
        @rollup_field                  = "rollup_id"
        @preferred_record_field        = "owner"
        @preferred_record_value        = "duke"
        @local_institution             = "duke"
        @local_records_field           = "owner"
        @local_records_values          = ["duke", "trln"]
        @apply_local_filter_by_default = "true"
        @application_name              = "TRLN Argon"
      end

    end

  end
end
