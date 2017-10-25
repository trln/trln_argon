require 'git'
require 'singleton'

module TrlnArgon
  class MappingsGitFetcher
    attr_reader :repo_dir

    GIT_URL = 'https://github.com/trln/argon_code_mappings'.freeze

    REPO_NAME = 'argon_mappings'.freeze

    def initialize(options = {})
      @repo_base = options[:repo_base] || 'config/mappings'
      @repo_dir = File.join(@repo_base, REPO_NAME)
      @branch = options[:branch] || 'master'
      begin
        @url = options[:git_url] || ::Rails.configuration.code_mappings[:git_url]
      rescue NoMethodError
        @url = GIT_URL
        Rails.logger.error('Unable to find configuration key `mappings_git_url`')
        Rails.logger.error('You need to specify this in the configuration file')
        Rails.logger.error("for your environment e.g. config/#{::Rails.env}.rb")
        Rails.logger.error("e.g. `config.mappings_git_url = 'https://github.com/myorg/mappings.git'`")
      end
    end

    def clone
      @git = Git.clone(@url, REPO_NAME, path: @repo_base)
    end

    def refresh
      if File.directory?(File.join(@repo_dir, '.git'))
        @git ||= Git.init(@repo_dir)
        @git.pull('origin', @branch)
      else
        clone
      end
    end
  end

  class Lookups
    attr_reader :directory

    KEYS = {
      library: 'library location',
      location: 'shelving location'
    }.freeze

    PATH_COMPONENTS = %i[library location].freeze

    FILENAMES = {
      location_holdings: 'location_item_holdings.json',
      location_facet: 'location_facet.json'
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
      ctx.nil? || ctx.empty? ? path : ctx
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
        inst_mappings['library'].each do |k, v|
          facets[k] ||= v
        end
        inst_mappings['facet'] = facets
      end
      mappings
    end

    private

    def parse_holdings!(filename, inst_mappings)
      lookups = read_json(filename)

      library_mappings = (inst_mappings['library'] ||= {})
      libraries = lookups.fetch(KEYS[:library], {})
      library_mappings.update(libraries)

      locations = lookups.fetch(KEYS[:location], {})
      location_mappings = (inst_mappings['location'] ||= {})
      location_mappings.update(locations)
    end

    def read_json(filename)
      File.exist?(filename) ? File.open(filename) { |f| JSON.parse(f.read) } : {}
    end
  end

  # Mappings for library/location names, statuses, etc.
  class LookupManager
    include Singleton

    CACHE_KEY = 'TrlrArgon::LookupManager::Lookups'.freeze

    class << self
      attr_writer :fetcher

      def fetcher
        @fetcher ||= TrlnArgon::MappingsGitFetcher.new
      end
    end

    def reload
      self.class.fetcher.refresh
      Rails.cache.delete(CACHE_KEY)
    end

    def map(path)
      lookups.lookup(path)
    end

    def lookups
      Rails.cache.fetch(CACHE_KEY, expires_in: 24.hours) do
        self.class.fetcher.refresh
        @lookups ||= Lookups.new(self.class.fetcher.repo_dir)
      end
    end
  end
end
