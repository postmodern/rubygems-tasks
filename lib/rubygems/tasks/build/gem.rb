require 'rubygems/tasks/build/task'

require 'rubygems/builder'

module Gem
  class Tasks
    module Build
      class Gem < Task

        def initialize(options={})
          super()

          yield self if block_given?
          define
        end

        def define
          build_task :gem

          # backwards compatibility for Gem::PackageTask
          task :gem => 'build:gem'

          # backwards compatibility for Hoe
          task :package => 'build:gem'
        end

        def build(path,gemspec)
          builder = ::Gem::Builder.new(gemspec)

          mv builder.build, Project::PKG_DIR
        end

      end
    end
  end
end
