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
              arguments = []

              if @host
                arguments << '--host' << @host

                status "Pushing #{File.basename(path)} to #{@host} ..."
              else
                status "Pushing #{File.basename(path)} ..."
              end

              run 'gem', 'push', path, *arguments
            end
          end
        end

        gemspec_tasks :push

        # backwards compatibility for Hoe
        task :publish => :push
      end

    end
  end
end
