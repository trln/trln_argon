require 'rails/generators'

module TrlnArgon
  class UpgradeGenerator < Rails::Generators::Base
    def cleanup_catalog_controller
      catalog_controller = 'app/controllers/catalog_controller.rb'

      lines_to_remove = [/ +config.show.partials.*$/,
                         / +config.autocomplete_enabled.*$/,
                         / +config.autocomplete_path.*$/]

      lines_to_remove.each do |remove_marker|
        gsub_file(catalog_controller, /#{remove_marker}/, '')
      end
    end

    def cleanup_search_builder
      search_builder = 'app/models/search_builder.rb'

      lines_to_remove = [/ +include TrlnArgon::TrlnSearchBuilderBehavior.*$/,
                         / +self.default_processor_chain += .*$/]

      lines_to_remove.each do |remove_marker|
        gsub_file(search_builder, /#{remove_marker}/, '')
      end
    end

    def cleanup_solr_document
      solr_document = 'app/models/solr_document.rb'

      lines_to_remove = [/ +SolrDocument.use_extension(TrlnArgon::Document::Ris).*$/,
                         / +SolrDocument.use_extension(TrlnArgon::Document::Email).*$/]
      lines_to_remove.each do |remove_marker|
        gsub_file(solr_document, /#{remove_marker}/, '')
      end
    end

    def run_latest_generator
      generate 'trln_argon:install'
    end
  end
end
