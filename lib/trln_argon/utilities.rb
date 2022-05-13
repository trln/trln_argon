module TrlnArgon
  # Utility classes for use outside of a running application
  class Utilities < Thor::Group
    include Thor::Actions

    def install_blacklight_asset_path
      content_file = File.join(__dir__, '..', 'generators', 'trln_argon', 'templates', 'assets_initializer_fragment.rb')
      unless File.exist?(content_file)
        path = File.expand_path(content_file)
        raise(IOError, "unable to locate template at #{path} for Blacklight 7+ asset configuration")
      end

      destination = File.join('config/initializers/assets.rb')
      File.open(destination, 'w') {} unless File.exist?(destination)

      # heuristic for seeing if we've already inserted this
      return if IO.read(destination).include?('Bundler.rubygems.find_name')

      insert_into_file(destination, before: '# Add additional assets to the asset load path.') do
        File.read(content_file)
      end
    end

    # rubocop:disable Metrics/MethodLength
    def repackage_blacklight_javascript
      bl_gem = Bundler.rubygems.find_name('blacklight').first
      blpath = bl_gem.full_gem_path
      # this is where the source javascript in later versions of BL7 is
      # put before it's compiled; we are effectively going to override this
      # process natively using classic sprockets syntax
      bl_js_dir = File.join(blpath, 'app', 'javascript', 'blacklight')
      unless File.exist?(bl_js_dir)
        warn "#{bl_js_dir} does not exist."\
          "\n Customized asset compilation will not be available."\
          "\nCheck the blacklight version release notes."
        exit 1
      end
      filenames = Dir.entries(bl_js_dir)
                     .select { |f| f.end_with?('.js') }
                     .reject { |f| f.start_with?('autocomplete') }
      filenames.unshift('core.js') if filenames.include?('core.js')

      inserts = ["// this file generated from Blacklight #{bl_gem.version} via TrlnArgon::Utilities.",
                 '// Changes may be overwritten!',
                 '']
      filenames.uniq.each_with_object(inserts) do |i, c|
        c << "//= require 'blacklight/#{i}'"
      end
      create_file 'app/assets/javascripts/blacklight/blacklight.js', inserts.join("\n")
    end
    # rubocop:enable Metrics/MethodLength
  end
end
