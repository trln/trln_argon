module TrlnArgon
  # Utility classes for use outside of a running application
  class Utilities < Thor::Group
    include Thor::Actions
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
