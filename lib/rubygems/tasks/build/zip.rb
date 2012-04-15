require 'rubygems/tasks/build/task'

module Gem
  class Tasks < Rake::TaskLib
    module Build
      class Zip < Task

        def initialize(options={})
          super()

          yield self if block_given?
          define :zip
        end

        def build(path,gemspec)
          sh 'zip', '-q', path, *gemspec.files
        end

      end
    end
  end
end
