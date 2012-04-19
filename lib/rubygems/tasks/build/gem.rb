require 'rubygems/tasks/build/task'

require 'rubygems/builder'
require 'fileutils'

module Gem
  class Tasks
    module Build
      #
      # The `build:gem` task.
      #
      class Gem < Task

        #
        # Initializes the `build:gem` task.
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
        # Defines the `build:gem` task.
        #
        def define
          build_task :gem

          # backwards compatibility for Gem::PackageTask
          task :gem => 'build:gem'

          # backwards compatibility for Hoe
          task :package => 'build:gem'
        end

        #
        # Builds the `.gem` package.
        #
        # @param [String] path
        #   The path for the `.gem` package.
        #
        # @param [Gem::Specification] gemspec
        #   The gemspec to build the `.gem` package from.
        #
        def build(path,gemspec)
          builder = ::Gem::Builder.new(gemspec)

          FileUtils.mv builder.build, Project::PKG_DIR
        end

      end
    end
  end
end
