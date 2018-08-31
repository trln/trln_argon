require 'rails/generators'

module TrlnArgon
  class RemoveSolrMarcGenerator < Rails::Generators::Base

    def cleanup_gemfile
      gemfile = 'Gemfile'

      lines_to_remove = [/.*gem 'rsolr'.*$/,
                         /.*gem 'blacklight-marc'.*$/]

      lines_to_remove.each do |remove_marker|
        gsub_file(gemfile, /#{remove_marker}/, '')
      end
    end

    def cleanup_blacklight_scss
      blacklight_scss = 'app/assets/stylesheets/blacklight.scss'
      lines_to_remove = [/\s*.*'blacklight_marc'.*$/]

      lines_to_remove.each do |remove_marker|
        gsub_file(blacklight_scss, /#{remove_marker}/, '')
      end
    end

    def cleanup_catalog_controller
      catalog_controller = 'app/controllers/catalog_controller.rb'
      lines_to_remove = [/ +include Blacklight::Marc::Catalog.*$/]

      lines_to_remove.each do |remove_marker|
        gsub_file(catalog_controller, /#{remove_marker}/, '')
      end
    end

    def cleanup_routes
      routes = 'config/routes.rb'
      lines_to_remove = [/ +Blacklight::Marc\.add_routes\(self\)/,
                         / +get "trln\/:id", to: "trln#show", as: "trln_solr_document".*$/]
      lines_to_remove.each do |remove_marker|
        gsub_file(routes, /#{remove_marker}/, '')
      end
    end

    def cleanup_solr_document
      solr_document = 'app/models/solr_document.rb'
      lines_to_remove = [/ +\# The following shows how to setup this blacklight document to display marc documents.*$/,
                         / +extension_parameters\[:marc_source_field\] = :marc_display.*$/,
                         / +extension_parameters\[:marc_format_type\] = :marcxml.*/,
                         /\s+use_extension\(\sBlacklight::Solr::Document::Marc\)\sdo\s\|document\|.*\n
                          \s+document\.key\?\(\s:marc_display\s+\).*\n\s+end.*$/x,
                         /\s+field_semantics\.merge!\(.*\n\s+:title\s=\>\s"title_display",.*\n
                          \s+:author\s=\>\s"author_display",.*\n\s+:language\s=\>\s"language_facet",.*\n
                          \s+:format\s=\>\s"format".*\n\s+\).*$/x]

      lines_to_remove.each do |remove_marker|
        gsub_file(solr_document, /#{remove_marker}/, '')
      end
    end

    def remove_files
      marc_indexer = 'app/models/marc_indexer.rb'
      File.delete(marc_indexer) if File.exist?(marc_indexer)
      FileUtils.rm_rf('solr')
      FileUtils.rm_rf('config/translation_maps')
    end
  end
end
