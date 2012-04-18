require 'rubygems/tasks/task'

require 'digest'

module Gem
  class Tasks
    module Sign
      class Task < Tasks::Task

        #
        # Defines signing tasks for the various packages.
        #
        def define
          name = self.class.task_name

          @project.builds.each do |build,packages|
            packages.each do |format,path|
              namespace :sign do
                namespace name do 
                  namespace build do
                    task format => path do
                      sign(path)
                    end
                  end
                end
              end
            end

            multi_task "sign:#{name}:#{build}", packages.keys

            task "sign:#{name}" => "sign:#{name}:#{build}"
            task :sign          => "sign:#{name}:#{build}"
          end
        end

        protected

        #
        # Signs a package.
        #
        # @param [String] path
        #   The path to the package.
        #
        # @abstract
        #
        def sign(path)
        end

      end
    end
  end
end
