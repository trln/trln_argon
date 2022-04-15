require 'blacklight'
require 'blacklight_advanced_search'
require 'blacklight-hierarchy'
require 'blacklight_range_limit'
require 'rails_autolink'
require 'library_stdnums'
require 'openurl'
require 'font-awesome-rails'
require 'bootstrap-select-rails'
# require 'chosen-rails'
require 'rsolr'
require 'addressable'

module TrlnArgon
  class Engine < ::Rails::Engine
    engine_name 'trln_argon'

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
                    :argon_code_mappings_dir,
                    :solr_fields,
                    :citation_formats,
                    :code_mappings,
                    :refworks_url,
                    :root_url,
                    :article_search_url,
                    :contact_url,
                    :feedback_url,
                    :sort_order_in_holding_list,
                    :number_of_location_facets,
                    :number_of_items_index_view,
                    :number_of_items_show_view,
                    :paging_limit,
                    :facet_paging_limit,
                    :unc_latest_received_url,
                    :solr_cache_exp_time,
                    :allow_open_search,
                    :open_search_q_min_length,
                    :worldcat_cite_base_url,
                    :worldcat_cite_api_key

      # rubocop:disable Metrics/MethodLength
      def initialize
        @local_institution_code        = 'unc'
        @application_name              = 'TRLN Argon'
        @argon_code_mappings_dir       = Rails.root.join('config', 'mappings')
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
        @citation_formats = 'apa, mla, chicago, harvard, turabian'
        @feedback_url = ''
        @sort_order_in_holding_list = 'unc, duke, ncsu, nccu, trln'
        @number_of_location_facets = '10'
        @number_of_items_index_view = '3'
        @number_of_items_show_view = '6'
        @paging_limit = '250'
        @facet_paging_limit = '50'
        @unc_latest_received_url = 'https://webcat.lib.unc.edu/search/.%<local_id>s/.%<local_id>s/,,,/cr%<holdings_id>s'
        @solr_cache_exp_time = '12.hours'
        @allow_open_search = 'true'
        @open_search_q_min_length = '4'
      end
      # rubocop:enable Metrics/MethodLength

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
