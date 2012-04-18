require 'rubygems/tasks/build/task'

module Gem
  class Tasks
    module Build
      class Zip < Task

        def initialize(options={})
          super()

          yield self if block_given?
          define
        end

        def define
          build_task :zip
        end

        def build(path,gemspec)
          sh 'zip', '-q', path, *gemspec.files
        end

      end
    end
  end
end
