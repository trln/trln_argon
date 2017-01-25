require 'blacklight'

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
                    :apply_local_filter_by_default,

      def initialize
        @rollup_field                  = "rollup_key"
        @preferred_record_field        = "institution"
        @preferred_record_value        = "duke"
        @local_institution             = "duke"
        @apply_local_filter_by_default = "true"
      end

    end

  end
end
