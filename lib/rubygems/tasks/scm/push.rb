require 'rubygems/tasks/task'

module Gem
  class Tasks
    module SCM
      #
      # The `scm:push` task.
      #
      class Push < Task

        #
        # Initializes the `scm:push` task.
        #
        # @param [Hash] options
        #   Additional options.
        #
        def initialize(options={})
          super()

          yield self if block_given?
          define
        end

        #
        # Defines the `scm:push` task.
        #
        def define
          task :validate

          namespace :scm do
            task :push => :validate do
              status "Pushing commits ..."

              unless push!
                error "Could not push commits"
              end
            end
          end
        end

        #
        # Pushes commits.
        #
        # @return [Boolean]
        #   Specifies whether the commits were successfully pushed.
        #
        # @api semipublic
        #
        def push!
          case @project.scm
          when :git
            run 'git', 'push'
            run 'git', 'push', '--tags'
          when :hg 
            run 'hg', 'push'
          else
            true
          end
        end

      end
    end
  end
end
