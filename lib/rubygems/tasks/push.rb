require 'rubygems/tasks/task'

module Gem
  class Tasks
    #
    # The `push` task.
    #
    class Push < Task

      # The Gemcutter host to push gems to.
      attr_accessor :host

      #
      # Initializes the `push` task.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :host
      #   The Gemcutter host to push gems to.
      #
      def initialize(options={})
        super()

        @host = options[:host]

        yield self if block_given?
        define
      end

      #
      # Defines the `push` task.
      #
      def define
        namespace :push do
          @project.builds.each do |build,packages|
            path = packages[:gem]

            task build => path do
              if @host
                status "Pushing #{File.basename(path)} to #{@host} ..."
              else
                status "Pushing #{File.basename(path)} ..."
              end

              run(path)
            end
          end
        end

        gemspec_tasks :push

        # backwards compatibility for Hoe
        task :publish => :push
      end

      #
      # Command arguments for pushing the gem.
      #
      # @param [String] path
      #   The path to the `.gem` to push.
      #
      # @return [Array<String>]
      #   Command arguments.
      #
      def arguments(path)
        arguments = ['gem', 'push', path]
        arguments.unshift('--host', @host) if @host

        return arguments
      end

      #
      # Pushes the gem by running `gem push`.
      #
      # @param [String] path
      #   The path to the `.gem` file.
      #
      # @return [Boolean]
      #   Specifies whether `gem push` was successfull or not.
      #
      def run(path)
        super(*arguments(path))
      end

    end
  end
end
