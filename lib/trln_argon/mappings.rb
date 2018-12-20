require 'git'
require 'singleton'

module TrlnArgon
  module Loggable
    def logger
      @logger ||= Rails.logger
    end
  end

  class MappingsGitFetcher
    include Loggable

    attr_reader :repo_dir

    GIT_URL = 'https://github.com/trln/argon_code_mappings'.freeze

    REPO_NAME = 'argon_mappings'.freeze

    def initialize(options = {})
      @repo_base = options.fetch(:repo_base, 'config/mappings')
      @repo_dir = File.join(@repo_base, REPO_NAME)
      @branch = options[:branch] || 'master'
      begin
        @url = options[:git_url] || ::Rails.configuration.code_mappings[:git_url]
      rescue NoMethodError
        @url = GIT_URL
        logger.error('Unable to find configuration key `mappings_git_url`')
        logger.error('You need to specify this in the configuration file')
        logger.error("for your environment e.g. config/#{::Rails.env}.rb")
        logger.error("e.g. `config.mappings_git_url = 'https://github.com/myorg/mappings.git'`")
      end
    end

    def clone
      logger.info("Initial clone of code mappings from #{@url} to #{@repo_base}")
      @git = Git.clone(@url, REPO_NAME, path: @repo_base)
    end

    def refresh
      if File.directory?(File.join(@repo_dir, '.git'))
        @git ||= Git.init(@repo_dir)
        do_pull = false
        logger.info("Repository #{@url} has already been cloned")

        head_fetch_file = File.join(@repo_dir, '.git', 'FETCH_HEAD')

        if File.exist?(head_fetch_file)
          # this method might get called in a loop when, e.g. creating
          # an engine_cart instance, so we need a very short term cache.
          do_pull = File.stat(head_fetch_file).mtime < (Time.now - 2.minutes)
        end

        if do_pull
          logger.info("Pulling changes from #{@url}")
          @git.pull('origin', @branch)
        else
          logger.warn("Not pulling changes from #{@url} because it was updated in the last 2 minutes")
        end
      else
        clone
      end
    end
  end

  class Lookups
    include Loggable

    attr_reader :directory

    KEYS = {
      loc_b: 'loc_b',
      loc_n: 'loc_n'
    }.freeze

    PATH_COMPONENTS = %i[loc_b loc_n].freeze

    FILENAMES = {
      location_holdings: 'location_item_holdings.json',
      location_facet: 'location_facet.json',
      url_template: 'url_template.json'
    }.freeze

    def initialize(base = '.')
      @directory = base
      reload!
    end

    # looks up a display value given a path of the form
    # "[inst_code].[lookup_type].[code]", e.g.
    # `unc.location_facet.uncgrar' looks up the code to be used when displaying
    # the location facet
    def lookup(path)
      parts = path.split('.')
      ctx = @mappings
      parts.each do |k|
        ctx = ctx[k]
        break if ctx.nil? || ctx.empty?
      end
      ctx.nil? ? path : ctx
    end

    def mappings
      @mappings ||= load
    end

    def reload!
      logger.info("Reloading code mappings from #{@directory}")
      @mappings = load
    end

    def load
      logger.info('load() called on mappings')
      mappings = {}
      Dir.foreach(@directory) do |dir_entry|
        path = File.expand_path(File.join(@directory, dir_entry))
        next unless File.directory?(path) && dir_entry =~ /^[a-z]/

        inst_mappings = mappings[File.basename(path)] = {}
        lhf = File.join(path, FILENAMES[:location_holdings])
        parse_holdings!(lhf, inst_mappings)
        lff = File.join(path, FILENAMES[:location_facet])
        facets = read_json(lff)
        urlt = File.join(path, FILENAMES[:url_template])
        url_templates = read_json(urlt)
        inst_mappings['loc_b'].each do |k, v|
          facets[k] ||= v
        end
        inst_mappings['facet'] = facets
        inst_mappings['url_template'] = url_templates
      end
      mappings
    end

    private

    def parse_holdings!(filename, inst_mappings)
      lookups = read_json(filename)

      loc_b_mappings = (inst_mappings['loc_b'] ||= {})
      locations_broad = lookups.fetch(KEYS[:loc_b], {})
      loc_b_mappings.update(locations_broad)

      locations_narrow = lookups.fetch(KEYS[:loc_n], {})
      loc_n_mappings = (inst_mappings['loc_n'] ||= {})
      loc_n_mappings.update(locations_narrow)
    end

    def read_json(filename)
      File.exist?(filename) ? File.open(filename) { |f| JSON.parse(f.read) } : {}
    end
  end

  # Mappings for loc_b/loc_n names, statuses, etc.
  class LookupManager
    include Loggable
    include Singleton

    # key under which the 'canary' value will be stored
    # in the cache; if we stored the lookups in the
    # cache directly, they would need to be deserialized on each access
    CACHE_KEY = 'TrlrArgon::LookupManager::Lookups::Canary'.freeze

    attr_reader :dev_reload_file

    class << self
      attr_writer :fetcher

      def fetcher
        @fetcher ||= TrlnArgon::MappingsGitFetcher.new
      end
    end

    def initialize
      if Rails.env == 'development'
        @dev_reload_file = File.join(Rails.root, 'tmp', 'reload-code-mappings')
        logger.info(%q(development mode -- argon code mappings loaded at
startup and when #{@dev_reload_file} is seen.))
      end

      reload
      lookups
    end

    # Refreshes mappings from git and reloads
    # cached lookups.
    # @see CACHE_KEY
    def reload
      self.class.fetcher.refresh
      Rails.cache.delete(CACHE_KEY)
    end

    def map(path)
      lookups.lookup(path)
    end

    def check_cache
      if Rails.env == 'development'
        if File.exist?(@dev_reload_file)
          logger.info("Found #{@dev_reload_file}, reloading argon code mappings")
          @lookups = nil
          File.unlink(@dev_reload_file)
          logger.info(%q(Removed #{@dev_reload_file}, use
'bundle exec rake trln_argon:reload_code_mappings if you want to
reload mappings again))
        end
        return true
      end

      Rails.cache.fetch(CACHE_KEY, expires_in: 24.hours) do |_|
        logger.info('Standard cache period for code mappings expired')
        @lookups = nil # .reload! if @lookups
        Time.now.to_s
      end
    end

    def lookups
      check_cache
      @lookups ||= Lookups.new(self.class.fetcher.repo_dir)
    end
  end
end
