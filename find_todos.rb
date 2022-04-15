#!/usr/bin/env ruby

require 'yaml'
require 'fileutils'

# this utility checks staged files and compares them against
# the files listed in `.rubocop_todo.yml` that have 'pending'
# rubocop violations to be fixed.  It produces a report
# that shows whether any of those staged files requires
# attention

verbose = false
ARGV.each do |a|
  verbose = true if a == '-v'
  next unless a == 'install-hook'
  if File.exist?('.git/hooks/pre-commit')
    warn 'pre-commit hook already installed'
    exit 1
  end
  unless File.directory?('.git/hooks')
    warn "We don't appear to be in a git directory"
    exit 1
  end
  FileUtils.cp(__FILE__, '.git/hooks/pre-commit')
  File.chmod(0o700, '.git/hooks/pre-commit')
  puts 'Installed this file as pre-commit hook'
  exit 0
end

unless File.exist?('.rubocop_todo.yml')
  warn 'No .rubocop_todo.yml present.  Regenerating'
  `bundle exec rubocop --auto-gen-config`
end

todos = File.open('.rubocop_todo.yml') do |f|
  YAML.safe_load(f)
end

pending_files = todos.each_with_object({}) do |(cop, details), m|
  details.fetch('Exclude', []).each do |filename|
    m[filename] ||= []
    m[filename] << cop
  end
end

staged = `git diff --name-only --cached`.split

commands = []
staged.select { |f| pending_files.key?(f) }.each do |f|
  puts "#{f} is staged and lists #{pending_files[f]}.size violations in todo" if verbose
  commands << "bundle exec rubocop -a #{f}"
end

unless commands.empty?
  warn 'Some files you are about to commit are listed in .rubocop_todo.yml'
  warn 'Please fix the reported issues before committing'
  warn "You can autofix many issues with the following:\n\n"
  commands.each { |c| warn c }
  warn "\n\nWhen you're done fixing up these files, you should regenerate"\
       "\nthe .rubocop_todo.yml file with:\n\n"\
       "bundle exec rubocop --regenerate-todo"
  exit 1
end
