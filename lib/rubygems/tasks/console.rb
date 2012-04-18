require 'rubygems/tasks/task'

module Gem
  class Tasks
    class Console < Task

      # The default Interactive Ruby Console
      DEFAULT_CONSOLE = 'irb'

      # The default command to run
      DEFAULT_COMMAND = (ENV['RUBYCONSOLE'] || DEFAULT_CONSOLE)

      # The Ruby Console command
      attr_accessor :command

      #
      # Initializes the `console` task.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String, Array] :command (DEFAULT_COMMAND)
      #   The Ruby Console command to run.
      #
      def initialize(options={})
        super()

        @command = options.fetch(:command,DEFAULT_COMMAND)

        yield self if block_given?
        define
      end

      def define
        desc "Spawns an Interactive Ruby Console (#{@command})"
        task :console, [:gemspec] do |t,args|
          load_paths = gemspec(args.gemspec).require_paths
          arguments  = [@command] + load_paths.map { |dir| "-I#{dir}" }

          if @project.bundler?
            if @command == DEFAULT_CONSOLE
              system 'bundle', 'console'
            else
              system 'bundle', 'exec', *arguments
            end
          else
            system *arguments
          end
        end
      end

    end
  end
end
