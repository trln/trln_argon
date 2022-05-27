#!/usr/bin/env ruby

require 'bundler'

# checks version of bundler in use
# so we can set the path appropriately

if Gem::Version.new(Bundler::VERSION) > Gem::Version.new('2.0')
    puts "bundle config set #{ARGV.join(' ')}"
else
    puts "bundle config #{ARGV.join(' ')}"
end
    
