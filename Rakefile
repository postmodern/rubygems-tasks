require 'rubygems'
require 'rake'

lib_dir = File.expand_path('lib',File.dirname(__FILE__))
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'rubygems/tasks'
Gem::Tasks.new(
  :checksum  => true,
  :build_tar => {:format => :gz},
  :sign_checksum => true,
  :sign_pgp  => true
)

begin
  gem 'rspec', '~> 2.4'
  require 'rspec/core/rake_task'
  
  RSpec::Core::RakeTask.new
rescue LoadError
  task :spec do
    abort "Please run `gem install rspec` to install RSpec."
  end
end
task :test => :spec
task :default => :spec

begin
  gem 'yard', '~> 0.7'
  require 'yard'

  YARD::Rake::YardocTask.new  
rescue LoadError => e
  task :yard do
    abort 'Please run `gem install yard` to install YARD.'
  end
end
