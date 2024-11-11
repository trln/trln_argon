$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'trln_argon/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'trln_argon'
  s.version     = File.read('VERSION')
  s.authors     = ['Cory Lown']
  s.email       = ['cory.lown@duke.edu']
  s.homepage    = 'https://github.com/trln/'
  s.summary     = 'TRLN Argon is a Rails Engine that bootstraps a Blacklight catalog '\
                  'designed for use with the TRLN shared catalog index.'
  s.description = 'TRLN Argon is a Rails Engine that bootstraps a Blacklight catalog '\
                  'designed for use with the TRLN shared catalog index.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 7.1', '< 7.2'
  s.add_dependency 'blacklight', '~> 8.0'
  s.add_dependency 'blacklight_advanced_search', '~> 8.0.0.alpha2'
  s.add_dependency 'blacklight-hierarchy', '~> 6.3'
  s.add_dependency 'blacklight_range_limit', '~> 8'
  s.add_dependency 'git', '>= 1.11.0', "< 2"
  s.add_dependency 'rails_autolink', '~> 1.1'
  s.add_dependency 'library_stdnums', '~> 1.6'
  s.add_dependency 'font-awesome-rails', '~> 4.7'
  s.add_dependency 'coffee-rails', '~> 4.2'
  s.add_dependency 'rsolr', '>= 1.0', '< 3'
  s.add_dependency 'addressable', '~> 2.5'
  s.add_dependency 'sprockets', '~> 4.0'
  s.add_dependency 'trln-chosen-rails', '1.30.0'
  s.add_dependency 'citeproc-ruby', '~> 1.1'
  s.add_dependency 'csl-styles', '~> 1.0'
  s.add_dependency 'bibtex-ruby', '>= 4.4.6', '< 7'
  s.add_dependency 'jquery-rails', '~> 4.6'

  s.add_development_dependency 'rspec-rails', '~> 6'
  s.add_development_dependency 'capybara', '~> 3.29'
  s.add_development_dependency 'pry', '~> 0.14'
  s.add_development_dependency 'rubocop', '~> 1.0'
  s.add_development_dependency 'rubocop-rspec', '~> 2.5'
  s.add_development_dependency 'webmock', '~> 3.7'
  s.add_development_dependency 'vcr', '~> 5.0'
  s.add_development_dependency 'engine_cart', '~> 2.2'
  s.add_development_dependency 'listen'
  s.add_development_dependency 'rake', '~> 13'

  # Ruby 3.x compatibility: some gems and their dependencies need to be
  # pinned to specific versions to work with different Ruby 3.x versions

  # Ruby 3.0
  # =================
  if Gem::Requirement.new('< 3.1').satisfied_by?(Gem::Version.new(RUBY_VERSION))
    s.add_dependency 'sqlite3', '< 1.7'

    s.add_dependency 'dartsass-sprockets', '< 3.1.0'
    s.add_dependency 'sass-embedded', '<= 1.69.5'
    s.add_dependency 'uri', '< 1.0'
    s.add_dependency 'dartsass-ruby', '>= 3.0.2'

  # Ruby 3.1
  # =================
  elsif Gem::Requirement.new('< 3.2').satisfied_by?(Gem::Version.new(RUBY_VERSION))
    s.add_dependency 'dartsass-sprockets'
    s.add_dependency 'sass-embedded', '<= 1.70'
    s.add_dependency 'uri', '< 1.0'

  # Ruby 3.2+
  # =================
  else
    s.add_dependency 'dartsass-sprockets'
  end
end
