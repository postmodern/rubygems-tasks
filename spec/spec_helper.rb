require 'rspec'

PROJECTS_DIR = File.expand_path('../projects',__FILE__)
PROJECT_DIRS = lambda { |name| File.join(PROJECTS_DIR,name) }

# clear the $RUBYCONSOLE env variable
ENV['RUBYCONSOLE'] = nil

RSpec.configure do |rspec|
  rspec.before(:suite) do
    Dir[File.join(PROJECTS_DIR,'*')].each do |dir|
      Dir.chdir(dir) do
        system 'git init'
        system 'git config --local user.email test@example.com'
        system 'git config --local user.name Test'
        system 'git add .'
        system 'git commit -q -m "Initial commit"'
      end
    end
  end

  rspec.after(:suite) do
    Dir[File.join(PROJECTS_DIR,'*')].each do |dir|
      FileUtils.rm_rf(File.join(dir,'.git'))
    end
  end
end
