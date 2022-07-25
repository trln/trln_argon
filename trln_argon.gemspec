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

  s.add_dependency 'rails', '~> 6'
  s.add_dependency 'blacklight', '~> 7.0'
  s.add_dependency 'blacklight_advanced_search', '~> 7'
  s.add_dependency 'blacklight-hierarchy', '~> 4'
  s.add_dependency 'blacklight_range_limit', '~> 7'
  s.add_dependency 'git', '>= 1.11.0', "< 2"
  s.add_dependency 'rails_autolink', '~> 1.1'
  s.add_dependency 'library_stdnums', '~> 1.6'
  s.add_dependency 'openurl', '~>1.0'
  s.add_dependency 'font-awesome-rails', '~> 4.7'
  s.add_dependency 'chosen-rails', '~> 1.10'
  s.add_dependency 'coffee-rails', '~> 4.2'
  s.add_dependency 'rsolr', '>= 1.0', '< 3'
  s.add_dependency 'addressable', '~> 2.5'
  s.add_dependency 'sprockets', '~> 3.0'

  # no version specified for sqlite3 because engine_cart 2.2
  # will otherwise use an incompatible version when generating
  # the internal rails app (rails 5.2.3 required for sqlite3 1.4.0)
  s.add_development_dependency 'rspec-rails', '~> 5'
  s.add_development_dependency 'capybara', '~> 3.29'
  s.add_development_dependency 'pry', '~> 0.14'
  s.add_development_dependency 'rubocop', '~> 1.0'
  s.add_development_dependency 'rubocop-rspec', '~> 2.5'
  s.add_development_dependency 'webmock', '~> 3.7'
  s.add_development_dependency 'vcr', '~> 5.0'
  s.add_development_dependency 'engine_cart', '~> 2.2'
  s.add_development_dependency 'listen'
  s.add_development_dependency 'better_errors', '~> 2.9.1'
  s.add_development_dependency 'binding_of_caller', '~> 1.0'
  s.add_development_dependency 'rake', '~> 13'
end
