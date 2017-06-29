require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

require 'engine_cart/rake_task'
EngineCart.fingerprint_proc = EngineCart.rails_fingerprint_proc

Dir.glob('./tasks/*.rake').each { |f| load f }
Dir.glob('./lib/tasks/*.rake').each { |f| load f }

task default: %i[rubocop ci]
