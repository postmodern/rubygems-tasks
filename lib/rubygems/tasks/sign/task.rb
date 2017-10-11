require 'rubygems/tasks/task'

require 'digest'

module Gem
  class Tasks
    module Sign
      class Task < Tasks::Task

        #
        # Defines signing tasks for the various packages.
        #
        # @param [Symbol] name
        #   The name for the `sign:` task.
        #
        def define(name)
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

            namespaced_tasks "sign:#{name}:#{build}", packages.keys

            task "sign:#{name}"  => "sign:#{name}:#{build}"
            task "sign:#{build}" => "sign:#{name}:#{build}"

            desc "Signs all packages" unless task?(:sign)
            task :sign           => "sign:#{name}:#{build}"
          end
        end

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
