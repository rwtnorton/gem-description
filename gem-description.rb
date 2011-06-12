#!/usr/bin/env ruby

#
# Displays the description of a remote gem on stdout.
#

require 'yaml'
require 'rubygems' # To have Gem::Specification for deserialization

raise 'Requires gem argument' unless ARGV.size == 1
gem_name = ARGV[0]

#
# Make a remote call for the gem specification.
#
spec_yaml = `gem specification #{gem_name} --remote`
if spec_yaml.empty?
  STDERR.puts "Unable to gather gem specification"
  exit
end

spec = YAML::load spec_yaml

#
# This should deserialize to a Gem::Specification but if
# it lacks the '--- !ruby/object:Gem::Specification' line,
# it could deserialize to a Hash.
#
if spec.respond_to? :description
  puts spec.description
elsif spec.respond_to? :[]
  puts spec['description']
else
  puts "Hmm, not sure what to do with this..."
  p spec
end
