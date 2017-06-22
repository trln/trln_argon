$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "trln_argon/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "trln_argon"
  s.version     = TrlnArgon::VERSION
  s.authors     = ["Cory Lown"]
  s.email       = ["cory.lown@duke.edu"]
  s.homepage    = "https://github.com/trln/"
  s.summary     = "TRLN Argon is a Rails Engine that bootstraps a Blacklight catalog designed for use with the TRLN shared catalog index."
  s.description = "TRLN Argon is a Rails Engine that bootstraps a Blacklight catalog designed for use with the TRLN shared catalog index."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"
  s.add_dependency "blacklight", "~> 6.7"
  s.add_dependency "blacklight_advanced_search", "~> 6.2"
  s.add_dependency 'rails_autolink', '~> 1.1'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.5"
  s.add_development_dependency "capybara"
  s.add_development_dependency "engine_cart"
  s.add_development_dependency "better_errors"
  s.add_development_dependency "binding_of_caller"
end
