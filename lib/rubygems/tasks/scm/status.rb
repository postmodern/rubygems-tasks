require 'rubygems/tasks/task'

module Gem
  class Tasks
    module SCM
      #
      # The `scm:status` task.
      #
      class Status < Task

        #
        # Initializes the `status` task.
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
        # Defines the `status` task.
        #
        def define
          namespace :scm do
            task :status do
              status = self.status

              unless status.strip.empty?
                error "Project has uncommitted changes!"
                puts status
                abort
              end
            end
          end

          # do not allow tagging releases when the repository is dirty
          task 'scm:tag' => 'scm:status'

          # do not allow pushing commits when the repository is dirty
          task 'scm:push' => 'scm:status'

          # do not allow building packages when the repository is dirty
          task :build => 'scm:status'

          # do not allow pushing gems when the repository is dirty
          task :push => 'scm:status'
        end

        #
        # Checks the status of the project repository.
        #
        # @return [String]
        #   The status of the project repository.
        #
        def status
          case @project.scm
          when :git then `git status --short --untracked-files=no`
          when :hg  then `hg status --quiet`
          when :svn then `svn status --quiet`
          else            ''
          end
        end

      end
    end
  end
end
