require 'rubygems/tasks/task'

module Gem
  class Tasks
    #
    # The `push` task.
    #
    class Push < Task

      # The rubygems host to push gems to.
      #
      # @return [String, nil]
      attr_accessor :host

      # The rubygems API key.
      #
      # @return [String, nil]
      #
      # @since 0.3.0
      attr_accessor :key

      #
      # Initializes the `push` task.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String, nil] :host
      #   The rubygems host to push gems to.
      #
      # @option options [String, nil] :key
      #   An optional rubygems API key.
      #
      def initialize(options={})
        super()

        @host = options[:host]
        @key  = options[:key]

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
        arguments.push('--key',   @key) if @key
        arguments.push('--host', @host) if @host

        return run(*arguments)
      end

    end
  end
end
