require 'rubygems'

require 'rake'

lib_dir = File.expand_path('lib',File.dirname(__FILE__))
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'rubygems/tasks'
Gem::Tasks.new(
  build: {gem: true, tar: true},
  sign:  {checksum: true, pgp: true}
)

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :test => :spec
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
