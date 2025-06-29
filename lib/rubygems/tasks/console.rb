# frozen_string_literal: true

require_relative 'task'

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
      #
      # @return [String]
      attr_accessor :command

      # Additional options for the Ruby Console
      #
      # @return [Array<String>]
      attr_accessor :options

      #
      # Initializes the `console` task.
      #
      # @param [String] command
      #   The Ruby Console command to run.
      #
      # @param [Array<String>] options
      #   Additional options for the Ruby Console.
      #
      def initialize(command: DEFAULT_COMMAND, options: [])
        super()

        @command = command
        @options = options

        yield self if block_given?
        define
      end

      #
      # Defines the `console` task.
      #
      def define
        @project.gemspecs.each_key do |name|
          namespace :console do
            task(name) { console(name) }
          end
        end

        desc "Spawns an Interactive Ruby Console"
        task :console => "console:#{@project.primary_gemspec}"
      end

      #
      # Builds the complete arguments for the console command.
      #
      # @param [Symbol, String] name
      #   The name of the gemspec to load.
      #
      # @return [Array<String>]
      #   The arguments for the console command.
      #
      # @api semipublic
      #
      def console(name=nil)
        gemspec = @project.gemspec(name)

        require_paths = gemspec.require_paths
        require_file  = gemspec.name.gsub('-',File::SEPARATOR)

        arguments = [@command]

        # add -I options for lib/ or ext/ directories
        arguments.push(*require_paths.map { |dir| "-I#{dir}" })

        # add an -r option to require the library
        arguments.push("-r#{require_file}")

        # push on additional options
        arguments.push(*@options)

        if @project.bundler?
          # run under `bundle exec`
          arguments.unshift('bundle', 'exec')
        end

        return run(*arguments)
      end

    end
  end
end
