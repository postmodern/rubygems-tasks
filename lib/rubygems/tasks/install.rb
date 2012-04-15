require 'rubygems/tasks/task'

module Gem
  class Tasks < Rake::TaskLib
    class Install < Task

      def initialize(options={})
        super()

        yield self if block_given?
        define
      end

      def define
        namespace :install do
          @project.each_package(:gem) do |build,path|
            task build => path do
              sh 'gem', 'install', path
            end
          end
        end

        desc "Installs all built gem packages"
        multi_task 'install', @project.builds

        task :install_gem => :install # backwards compatibility with Hoe
      end

    end
  end
end
