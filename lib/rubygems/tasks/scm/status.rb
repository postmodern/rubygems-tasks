require 'rubygems/tasks/task'

module Gem
  class Tasks < Rake::TaskLib
    module SCM
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
                puts status
                fail "Project has uncommitted changes!"
              end
            end
          end
        end

        #
        # Checks the status of the project repository.
        #
        # @return [String]
        #   The status of the project repository.
        #
        def status
          case @project.scm
          when :git then `git status`
          when :hg  then `hg status`
          when :svn then `svn status`
          else            ''
          end
        end

      end
    end
  end
end