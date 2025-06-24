# frozen_string_literal: true

require_relative 'task'

module Gem
  class Tasks
    #
    # The `release` task.
    #
    class Release < Task

      #
      # Initializes the `release` task.
      #
      def initialize
        super()

        yield self if block_given?
        define
      end

      #
      # Defines the `release` task.
      #
      def define
        @project.gemspecs.each_key do |name|
          task :release => [
            "build:#{name}",
            'scm:tag',
            'scm:push',
            "push:#{name}",
            "sign:#{name}"
          ].select { |name| task?(name) }
        end

        desc "Performs a release"
        task :release => [
          :build,
          'scm:tag',
          'scm:push',
          :push,
          :sign
        ].select { |name| task?(name) }
      end

    end
  end
end
