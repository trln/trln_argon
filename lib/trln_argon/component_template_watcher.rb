module TrlnArgon
  # Helper that allows creation of listeners for updates to Blacklight
  # component templates.
  class ComponentTemplateWatcher
    attr_reader :watch_paths

    def initialize(base_watch_dir = File.expand_path('../..', __dir__))
      @gem_base = base_watch_dir
      @watch_paths = ENV.fetch('BLACKLIGHT_COMPONENT_DIRS', 'app/components/blacklight').split(':').map(&:strip) 
    end

    # returns an array of listeners on the watch paths
    # Listeners must be started by the client
    def listeners
      watch_paths.map do |pth|
        gem_path_dir = File.join(@gem_base, pth)
        Listen.to(gem_path_dir, only: /\.html\.erb$/) do |modded, added, removed|
          Rails.logger.warn("[#{self.class}] : updates: changed => #{modded}, added: #{added}, removed: #{removed}")
          (modded + added).each do |f|
            dest = Rails.root.join(pth, File.basename(f))
            Rails.logger.info("Updating #{f} to #{dest}")
            FileUtils.copy_file(f, dest)
          end
        end
      end
    end

    def start!
      listeners.each(&:start)
    end
  end
end
