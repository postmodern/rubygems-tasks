require 'rubygems/tasks/task'

module Gem
  class Tasks
    #
    # The `console` task.
    #
    class Console < Task

      # The default Interactive Ruby Console
      DEFAULT_CONSOLE = 'irb'

      # The default command to run
      DEFAULT_COMMAND = (ENV['RUBYCONSOLE'] || DEFAULT_CONSOLE)

      # The Ruby Console command
      attr_accessor :command

      # Additional options for the Ruby Console
      attr_accessor :options

      #
      # Initializes the `console` task.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String, Array] :command (DEFAULT_COMMAND)
      #   The Ruby Console command to run.
      #
      # @option options [Array] :options
      #   Additional options for the Ruby Console.
      #
      def initialize(options={})
        super()

        @command = options.fetch(:command,DEFAULT_COMMAND)
        @options = Array(options[:options])

        yield self if block_given?
        define
      end

      #
      # Defines the `console` task.
      #
      def define
        @project.gemspecs.each do |name,gemspec|
          namespace :console do
            task name do |t,args|
              arguments  = [@command, *@options]
              arguments += gemspec.require_paths.map { |dir| "-I#{dir}" }

              if @project.bundler?
                if @command == DEFAULT_CONSOLE
                  run 'bundle', 'console'
                else
                  run 'bundle', 'exec', *arguments
                end
              else
                run *arguments
              end
            end
          end
        end

        desc "Spawns an Interactive Ruby Console"
        task :console => "console:#{@project.gemspecs.keys.first}"
      end

    end
  end
end
