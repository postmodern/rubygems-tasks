gem 'rspec', '~> 2.4'
require 'rspec'

PROJECTS_DIR = File.join('data','projects')
PROJECT_DIRS = lambda { |name| File.join(PROJECTS_DIR,name) }

unless File.directory?(PROJECTS_DIR)
  abort "Please run `rake data:projects` before running the specs!"
end

RSpec.configure do |spec|
  spec.before(:suite) do
    # clear the $RUBYCONSOLE env variable
    ENV['RUBYCONSOLE'] = nil
  end
end
