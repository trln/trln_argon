require 'git'
require 'singleton'
require 'fileutils'

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

    DEFAULT_BRANCHES = %w[main master].freeze

    def initialize(options = {})
      @repo_base = options.fetch(:repo_base, 'config/mappings')
      @repo_dir = File.join(@repo_base, REPO_NAME)
      begin
        @url = options[:git_url] || ::Rails.configuration.code_mappings[:git_url]

        # CHANGED: Added .map to normalize remote branch names. Some versions of
        # the git gem return full ref names like "refs/heads/main" instead of just
        # "main", which caused .find below to always return nil, ultimately passing
        # nil to Git#checkout and corrupting the HEAD file.
        remote_branches = Git.ls_remote(@url)['branches'].keys
                                                         .map { |b| b.sub('refs/heads/', '') }

        if options[:branch]
          logger.info("Using '#{options[:branch]}' branch for mappings")
          @branch = options[:branch]
        else
          @branch = DEFAULT_BRANCHES.find { |b| remote_branches.include?(b) }
        end

        # CHANGED: Added nil guard for @branch. If .find returns nil (e.g.
        # because no DEFAULT_BRANCHES matched), the original code would silently
        # pass nil to Git#checkout, which writes a binary HEAD file and causes
        # the "no candidates for merging" error on the next pull. Fall back to
        # 'main' and log an error instead.
        if @branch.nil?
          logger.error("Could not determine a valid branch from remote. " \
                         "Remote branches found: #{remote_branches.inspect}. " \
                         "Falling back to 'main'.")
          @branch = 'main'
        end

        unless remote_branches.include?(@branch)
          logger.error("The repository at #{@url} does not contain a branch " \
                         "named '#{@branch}'. We only found: #{remote_branches}")
        end
      rescue NoMethodError
        @url = GIT_URL
        # CHANGED: Changed = to ||= so an explicitly supplied branch option is
        # not overwritten when falling into the rescue path.
        @branch ||= 'main'
        logger.error('Unable to find configuration key `mappings_git_url`')
        logger.error('You need to specify this in the configuration file')
        logger.error("for your environment e.g. config/#{::Rails.env}.rb")
        logger.error("e.g. `config.mappings_git_url = 'https://github.com/myorg/mappings.git'`")
      end
    end

    def clone
      logger.info("Initial clone of code mappings from #{@url} to #{@repo_base}")

      # CHANGED: Remove any existing incomplete or corrupted directory before
      # cloning. Git#clone will not clone into a non-empty existing directory.
      FileUtils.rm_rf(@repo_dir)

      # CHANGED: Pass the branch to clone so the desired branch is checked out
      # during the initial clone.
      @git = Git.clone(
        @url,
        REPO_NAME,
        path: @repo_base,
        branch: @branch
      )
    end

    # rubocop:disable Metrics/PerceivedComplexity
    def refresh
      git_directory = File.join(@repo_dir, '.git')

      if File.directory?(git_directory)
        logger.debug("Repository #{@repo_dir} appears to be a .git repo")

        begin
          # CHANGED: Git.open can raise ArgumentError when the directory contains
          # a damaged or incomplete .git directory. This must be inside the rescue
          # block; otherwise the existing rescue around fetch does not catch it.
          @git ||= Git.open(@repo_dir)

          head_fetch_file = File.join(git_directory, 'FETCH_HEAD')

          do_fetch = if File.exist?(head_fetch_file)
                       File.stat(head_fetch_file).mtime < (Time.now - 24.hours)
                     else
                       true
                     end

          if do_fetch
            logger.info("Fetching changes from #{@url}/#{@branch} to #{@repo_dir}")

            # CHANGED: Use fetch and reset instead of pull. This avoids the merge
            # step that produced "There are no candidates for merging."
            @git.fetch('origin')
            @git.checkout(@branch)
            @git.reset_hard("origin/#{@branch}")
          else
            logger.debug(
              "Skipping fetch because #{@repo_dir} was updated within the last 24 hours"
            )
          end
        rescue ArgumentError, Git::GitExecuteError => e
          # CHANGED: Catch ArgumentError from Git.open as well as git command
          # failures. An existing .git directory is not necessarily a valid
          # working tree.
          logger.error(
            "Git repository is invalid or refresh failed: #{e.message}. " \
              'Removing it and cloning again.'
          )

          @git = nil
          clone
        end
      else
        clone
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity
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
      @mappings = load
    end

    def load
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
        logger.info("development mode -- argon code mappings loaded at
startup and when #{@dev_reload_file} exists.")
      end

      reload
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

    # rubocop:disable Layout/LineLength
    def check_cache
      # in dev mode, allow for expiring the cache via external command
      if Rails.env == 'development' && File.exist?(dev_reload_file)
        logger.info("Found #{@dev_reload_file}, reloading argon code mappings")
        @lookups = nil
        File.unlink(@dev_reload_file)
        logger.info("Removed #{@dev_reload_file}, use\n\nbundle exec rake trln_argon:reload_code_mappings\n\nif you want to reload mappings again")
      end

      Rails.cache.fetch(CACHE_KEY, expires_in: 24.hours) do |_|
        logger.info('Location code mappings not found in cache, reloading')
        @lookups = nil # .reload! if @lookups
        Time.now.to_s
      end
    end
    # rubocop:enable Layout/LineLength

    def lookups
      check_cache
      @lookups ||= Lookups.new(self.class.fetcher.repo_dir)
    end
  end
end
