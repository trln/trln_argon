# the following is added by the generator when installing the app

bl_dir = Bundler.rubygems.find_name('blacklight').first.full_gem_path
assets_path = File.join(bl_dir, 'app', 'javascript')
Rails.application.config.assets.paths << assets_path

# end auto-inserted asset paths

