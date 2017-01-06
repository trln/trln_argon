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
                    :preferred_record_value

      def initialize
        @rollup_field           = "rollup_key"
        @preferred_record_field = "institution"
        @preferred_record_value = "duke"
      end

    end

  end
end
