require 'rubygems/tasks/task'

module Gem
  class Tasks
    #
    # The `push` task.
    #
    class Push < Task

      # The rubygems host to push gems to.
      attr_accessor :host

      #
      # Initializes the `push` task.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :host
      #   The rubygems host to push gems to.
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
        task :validate

        namespace :push do
          @project.builds.each do |build,packages|
            path = packages[:gem]

            task build => [:validate, path] do
              if @host
                status "Pushing #{File.basename(path)} to #{@host} ..."
              else
                status "Pushing #{File.basename(path)} ..."
              end

              push(path)
            end
          end
        end

        gemspec_tasks :push

        # backwards compatibility for Hoe
        task :publish => :push
      end

      #
      # Pushes the gem by running `gem push`.
      #
      # @param [String] path
      #   The path to the `.gem` file.
      #
      # @return [Boolean]
      #   Specifies whether `gem push` was successful or not.
      #
      # @api semipublic
      #
      def push(path)
        arguments = ['gem', 'push', path]
        arguments.push('--host', @host) if @host

        return run(*arguments)
      end

    end
  end
end
