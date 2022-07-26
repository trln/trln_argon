task :ci do
  ENV['environment'] = 'test'
  Rake::Task['engine_cart:generate'].invoke
  Rake::Task['spec'].invoke
end

namespace :trln_argon do
  desc 'Refreshes code mappings from github and reloads the cache'
  task(reload_code_mappings: :environment) do
    require 'trln_argon/mappings'
    puts 'Expiring cached lookups'
    if Rails.env == 'development'
      puts 'Development environment, creating mappings reload trigger file'
      reload_file = TrlnArgon::LookupManager.instance.dev_reload_file
      FileUtils.touch(reload_file)
    end
    TrlnArgon::LookupManager.instance.reload
    puts 'Reloaded mappings from github'
  end

  desc('Repacackages Blacklight JS without their autocomplete')
  task(regenerate_blacklight_js: :environment) do
    require 'trln_argon'
    puts 'Regenerating /app/javascript/blacklight/blacklight.js with local modifications'
    utils = TrlnArgon::Utilities.new
    utils.repackage_blacklight_javascript
    puts 'Ensuring config/initializers/assets.rb has correct path for BL JS assets'
    utils.install_blacklight_asset_path
  end

  desc('Copy overridden Blacklight::Component templates into application directory')
  task(:copy_viewcomponent_templates) do
    require 'trln_argon'
    utils = TrlnArgon::Utilities.new
    results = utils.find_view_component_template_overrides
    puts results
  end

  namespace :solr do
    require 'trln_argon/field'
    require 'trln_argon/fields'

    desc 'list missing field definitions'
    task 'missing_fields' do
      Rake::Task['trln_argon:solr:all_fields'].invoke
      Rake::Task['trln_argon:solr:defined_fields'].invoke
      missing_fields = @all_fields.reject do |n|
        @defined_fields.include?(n) || n.end_with?('_t') || n.end_with?('_str') || n == '_version_'
      end
      if missing_fields.present?
        puts missing_fields
      else
        puts 'No missing fields.'
      end
    end

    desc 'list all Solr fields'
    task :list_all_fields do
      Rake::Task['trln_argon:solr:all_fields'].invoke
      puts @all_fields
    end

    desc 'list all Solr fields defined in TRLN Argon'
    task :list_defined_fields do
      Rake::Task['trln_argon:solr:defined_fields'].invoke
      puts @defined_fields
    end

    desc 'reload mapping codes (locations)'
    desc 'get all fields defined in TRLN Argon'
    task defined_fields: :environment do
      include TrlnArgon::Fields
      @defined_fields = TrlnArgon::Fields.solr_field_names
    end

    desc 'get all Solr fields'
    task all_fields: :environment do
      def blacklight_config
        CatalogController.blacklight_config
      end

      class SolrFieldsTestClass < CatalogController
        include Blacklight::SearchHelper

        blacklight_config.configure do |config|
          config.solr_path = 'admin/luke'
        end
      end
      controller = SolrFieldsTestClass.new

      response, = controller.search_results(numTerms: 0)

      puts 'all_fields source repository:'
      puts blacklight_config.connection_config[:url]

      @all_fields = response['fields'].map { |field_name, _| field_name }
    end
  end
end
