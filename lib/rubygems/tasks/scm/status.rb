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
              if dirty?
                error "Project has uncommitted changes!"

                status
                abort
              end
            end
          end

          # alias the `check` task to scm:status
          task :check => 'scm:status'

          # do not allow tagging releases when the repository is dirty
          task 'scm:tag' => 'scm:status'

          # do not allow pushing commits when the repository is dirty
          task 'scm:push' => 'scm:status'

          # do not allow pushing gems when the repository is dirty
          task :push => 'scm:status'
        end

        #
        # Checks the status of the project repository.
        #
        # @return [Boolean]
        #   Specifies whether the repository is dirty.
        #
        # @since 0.3.0
        #
        def dirty?
          status = case @project.scm
                   when :git then `git status --porcelain --untracked-files=no`
                   when :hg  then `hg status --quiet`
                   when :svn then `svn status --quiet`
                   else            ''
                   end

          return !status.chomp.empty?
        end

        #
        # Displays the status of the project repository.
        #
        # @api semipublic
        #
        def status
          case @project.scm
          when :git then run 'git', 'status', '--untracked-files=no'
          when :hg  then run 'hg', 'status', '--quiet'
          when :svn then run 'svn', 'status', '--quiet'
          end
        end

      end
    end
  end
end
