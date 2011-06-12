#!/usr/bin/env ruby

require 'yaml'
require 'rubygems' # To have Gem::Specification

raise 'Requires gem argument' unless ARGV.size == 1
gem_name = ARGV[0]

spec_yaml = open("|gem specification #{gem_name} --remote") do |f|
  f.read
end
if (spec_yaml =~ /\AERROR:\s+Unknown\s+gem\s+/)
  STDERR.puts spec
  exit
end

spec = YAML::load spec_yaml
p spec
if spec.respond_to? :description
  puts spec.description
elsif spec.respond_to? :[]
  puts spec['description']
end
