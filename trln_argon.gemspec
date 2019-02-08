$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'trln_argon/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'trln_argon'
  s.version     = TrlnArgon::VERSION
  s.authors     = ['Cory Lown']
  s.email       = ['cory.lown@duke.edu']
  s.homepage    = 'https://github.com/trln/'
  s.summary     = 'TRLN Argon is a Rails Engine that bootstraps a Blacklight catalog '\
                  'designed for use with the TRLN shared catalog index.'
  s.description = 'TRLN Argon is a Rails Engine that bootstraps a Blacklight catalog '\
                  'designed for use with the TRLN shared catalog index.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5'
  s.add_dependency 'blacklight', '~> 6.16'
  s.add_dependency 'blacklight_advanced_search', '~> 6.2'
  s.add_dependency 'blacklight-hierarchy', '~> 1.1.0'
  s.add_dependency 'blacklight_range_limit', '~> 6.3'
  s.add_dependency 'git', '~> 1.3.0'
  s.add_dependency 'rails_autolink', '~> 1.1'
  s.add_dependency 'library_stdnums', '~> 1.6'
  s.add_dependency 'openurl', '~>1.0'
  s.add_dependency 'font-awesome-rails', '~> 4.7'
  s.add_dependency 'bootstrap-select-rails', '~> 1.12'
  s.add_dependency 'chosen-rails', '~> 1.8'
  s.add_dependency 'rsolr', '>= 1.0', '< 3'
  s.add_dependency 'addressable', '~> 2.5'

  # no version specified for sqlite3 because engine_cart 2.2
  # will otherwise use an incompatible version when generating
  # the internal rails app (rails 5.2.3 required for sqlite3 1.4.0)
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'rubocop', '~> 0.49.1'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'engine_cart', '~> 2.2'
  s.add_development_dependency 'better_errors', '~> 2.1.1'
  s.add_development_dependency 'binding_of_caller'
end
