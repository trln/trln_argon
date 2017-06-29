task :ci do
  ENV['environment'] = 'test'
  Rake::Task['engine_cart:generate'].invoke
  Rake::Task['spec'].invoke
end
