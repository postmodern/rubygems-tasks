require 'rubygems/tasks/task'

module Gem
  class Tasks
    module SCM
      class Push < Task

        def initialize(options={})
          super()

          yield self if block_given?
          define
        end

        def define
          namespace :scm do
            task :push do
              status "Pushing commits ..."

              unless push!
                error "Could not push commits"
              end
            end
          end
        end

        #
        # @return [Boolean]
        #
        def push!
          case @project.scm
          when :git then run 'git', 'push', '--tags'
          when :hg  then run 'hg', 'push'
          else           true
          end
        end

      end
    end
  end
end
