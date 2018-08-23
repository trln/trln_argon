require 'blacklight'
require 'blacklight_advanced_search'
require 'blacklight-hierarchy'
require 'rails_autolink'
require 'library_stdnums'
require 'openurl'
require 'font-awesome-rails'
require 'bootstrap-select-rails'
require 'chosen-rails'
require 'traject'

module TrlnArgon
  class Engine < ::Rails::Engine
    attr_writer :configuration

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield configuration
    end

    class Configuration
      attr_accessor :local_institution_code,
                    :application_name,
                    :solr_fields,
                    :code_mappings,
                    :refworks_url,
                    :root_url,
                    :article_search_url,
                    :contact_url,
                    :feedback_url

      # rubocop:disable MethodLength
      def initialize
        @local_institution_code        = 'unc'
        @application_name              = 'TRLN Argon'
        @solr_fields =
          field_constants(default_fields.merge(override_fields).deep_symbolize_keys)
        @refworks_url =
          'http://www.refworks.com.libproxy.lib.unc.edu/express/ExpressImport.asp?' \
          'vendor=SearchUNC&filter=RIS%20Format&encoding=65001&url='
        @root_url = 'https://discovery.trln.org'
        @article_search_url =
          'http://libproxy.lib.unc.edu/login?'\
          'url=http://unc.summon.serialssolutions.com/search?'\
          's.secure=f&s.ho=t&s.role=authenticated&s.ps=20&s.q='
        @contact_url = 'https://library.unc.edu/ask/'
        @feedback_url = ''
      end

      private

      def field_constants(field_settings)
        field_settings.each do |key, value|
          unless TrlnArgon::Fields.const_defined?(key)
            TrlnArgon::Fields.const_set(key, TrlnArgon::Field.new(value[:solr_field], value[:label]))
          end
        end
      end

      def default_fields
        @default_fields ||= load_yaml_file(solr_field_defaults_file_path) || {}
      end

      def override_fields
        @override_fields ||= load_yaml_file(solr_field_overrides_file_path) || {}
      end

      def load_yaml_file(file_path)
        YAML.load_file(file_path) if File.exist?(file_path)
      end

      def solr_field_defaults_file_path
        File.join(File.dirname(__FILE__), 'solr_field_defaults.yml')
      end

      def solr_field_overrides_file_path
        File.join(Rails.root, '/config/solr_field_overrides.yml')
      end
    end
  end
end
