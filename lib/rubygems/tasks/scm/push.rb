require 'rubygems/tasks/task'

module Gem
  class Tasks < Rake::TaskLib
    module SCM
      class Push < Task

        def initialize(options={})
          super()

          yield self if block_given?
          define
        end

        def define
          namespace :scm do
            task :push do |t,args|
              unless push!
                abort "Could not push commits"
              end
            end
          end
        end

        #
        # @return [Boolean]
        #
        def push!
          case @project.scm
          when :git then sh 'git', 'push', '--tags'
          when :hg  then sh 'hg', 'push'
          else           true
          end
        end

      end
    end
  end
end
