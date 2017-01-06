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

  s.add_development_dependency "sqlite3"
end
