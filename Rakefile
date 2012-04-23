require 'rubygems'
require 'rake'

lib_dir = File.expand_path('lib',File.dirname(__FILE__))
$LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'rubygems/tasks'
Gem::Tasks.new(
  :build => {:gem => true, :tar => true},
  :sign  => {:checksum => true, :pgp => true}
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

require 'net/https'
require 'uri'

DOWNLOAD_URI = 'http://cloud.github.com/downloads/postmodern/rubygems-tasks/'
PROJECTS_DIR = File.join('data','projects')
PROJECTS     = %w[rubygems-project rubygems-multi-project bundler-project]

directory PROJECTS_DIR

PROJECTS.each do |project|
  project_file = "#{project}.tar.gz"
  project_path = File.join(PROJECTS_DIR,project_file)
  project_dir  = File.join(PROJECTS_DIR,project)

  file project_path => PROJECTS_DIR do
    Net::HTTP.get_response(URI(DOWNLOAD_URI + project_file)) do |response|
      size, total = 0, response.header['Content-Length'].to_i

      puts ">>> Downloading to #{project_file} to #{project_path} ..."

      File.open(project_path,"wb") do |file|
        response.read_body do |chunk|
          file.write(chunk)

          size += chunk.size
          printf "\r>>> [%d / %d] %d%% ...", size, total, ((size * 100) / total)
        end
      end

      puts
    end
  end

  task project_dir => project_path do
    unless File.directory?(project_dir)
      sh 'tar', 'xzf', project_path, '-C', PROJECTS_DIR
    end
  end

  task 'data:projects' => project_dir
end

task :spec => 'data:projects'
