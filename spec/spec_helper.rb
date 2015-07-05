require 'rspec'
require 'fileutils'
require 'tmpdir'

# clear the $RUBYCONSOLE env variable
ENV.delete('RUBYCONSOLE')

RSpec.configure do |rspec|
  rspec.before(:suite) do
    PROJECTS_DIR = Dir.mktmpdir('rubygems-tasks')

    Dir[File.join(File.dirname(__FILE__),'projects','*')].each do |src|
      dest = File.join(PROJECTS_DIR,File.basename(src))

      FileUtils.cp_r(src,dest)
      Dir.chdir(dest) do
        system 'git init -q'
        system 'git config --local user.email test@example.com'
        system 'git config --local user.name Test'
        system 'git add .'
        system 'git commit -q -a -m "Initial commit"'
      end
    end
  end

  rspec.after(:suite) do
    FileUtils.rm_rf(PROJECTS_DIR)
  end
end
