require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

Dir.glob('./tasks/*.rake').each { |f| load f }
Dir.glob('./lib/tasks/*.rake').each { |f| load f }

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'engine_cart/rake_task'
EngineCart.fingerprint_proc = EngineCart.rails_fingerprint_proc

task :ci do
  ENV['environment'] = 'test'
  Rake::Task['engine_cart:generate'].invoke
  Rake::Task['spec'].invoke
end
