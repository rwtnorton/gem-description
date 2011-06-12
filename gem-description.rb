#!/usr/bin/env ruby

#
# Displays the description of a remote gem on stdout.
#

require 'yaml'
require 'rubygems' # To have Gem::Specification for deserialization
require 'rubygems/commands/specification_command'
require 'rubygems/user_interaction' # For Gem::StreamUI
require 'stringio'

gem_name = ARGV[0]

#
# Make a remote call for the gem specification.
#
cmd = Gem::Commands::SpecificationCommand.new
cmd.options[:domain] = :remote
cmd.options[:args]   = [ gem_name ]

# Open a string buffer for the command to populate with the spec.
spec_yaml = ''
out_str_io = StringIO.open(spec_yaml, 'w')
cmd.use_ui(Gem::StreamUI.new(STDIN, out_str_io, STDERR)) { cmd.execute }
out_str_io.close

abort "Aborting: gem specification empty" if spec_yaml.empty?
spec = YAML::load spec_yaml

#
# This should deserialize to a Gem::Specification but if
# the YAML spec string lacks the '--- !ruby/object:Gem::Specification' line,
# it might deserialize to a Hash (maybe???).
#
if spec.respond_to? :description
  puts spec.description
elsif spec.respond_to? :[]
  puts spec['description']
else
  puts "Hmm, not sure what to do with this..."
  p spec
end
