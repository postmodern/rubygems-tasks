require 'rubygems/tasks/build/task'

require 'set'

module Gem
  class Tasks
    module Build
      class Tar < Task

        def initialize(options={})
          super()

          yield self if block_given?

          define
        end

        def define
          build_task :tar, 'tar.gz'
        end

        def build(path,gemspec)
          run 'tar', 'czf', path, *gemspec.files
        end

      end
    end
  end
end
