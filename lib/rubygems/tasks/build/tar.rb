require 'rubygems/tasks/build/task'

module Gem
  class Tasks
    module Build
      #
      # The `build:tar` task.
      #
      class Tar < Task

        #
        # Initializes the `build:tar` task.
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
        # Defines the `build:tar` task.
        #
        def define
          build_task :tar, 'tar.gz'
        end

        #
        # Builds a `.tar.gz` archive.
        #
        # @param [String] path
        #   The path for the `.tar.gz` archive.
        #
        # @param [Gem::Specification] gemspec
        #   The gemspec to generate the archive from.
        #
        # @api semipublic
        #
        def build(path,gemspec)
          run 'tar', 'czf', path, *gemspec.files
        end

      end
    end
  end
end
