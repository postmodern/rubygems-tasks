# frozen_string_literal: true

require_relative 'task'

module Gem
  class Tasks
    class Build
      #
      # The `build:zip` task.
      #
      class Zip < Task

        #
        # Initializes the `build:zip` task.
        #
        def initialize
          super()

          yield self if block_given?
          define
        end

        #
        # Defines the `build:zip` task.
        #
        def define
          build_task :zip
        end

        #
        # Builds the `.zip` archive.
        #
        # @param [String] path
        #   The path for the `.zip` archive.
        #
        # @param [Gem::Specification] gemspec
        #   The gemspec to build the archive from.
        #
        # @api semipublic
        #
        def build(path,gemspec)
          run 'zip', '-q', path, *gemspec.files
        end

      end
    end
  end
end
