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
        @project.gemspecs.each_key do |name|
          namespace :console do
            task name do |t,args|
              console(name)
            end
          end
        end

        desc "Spawns an Interactive Ruby Console"
        task :console => "console:#{@project.primary_gemspec_name}"
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
      def arguments(name=@project.primary_gemspec_name)
        unless (gemspec = @project.gemspecs[name.to_s])
          raise(ArgumentError,"unknown gemspec name: #{name}")
        end

        arguments = [@command]

        # add -I options for lib/ or ext/ directories
        arguments.push(*gemspec.require_paths.map { |dir| "-I#{dir}" })

        # push on additional options
        arguments.push(*@options)

        if @project.bundler?
          # use `bundle console` unless were were using custom command/options
          if (@command == DEFAULT_CONSOLE && @options.empty?)
            arguments = ['bundle', 'console']
          else
            arguments.unshift('bundle', 'exec')
          end
        end

        return arguments
      end

      #
      # Runs the console command.
      #
      # @param [Symbol, String] name
      #   The name of the gemspec to load.
      #
      # @return [Array<String>]
      #   The arguments to run the console command.
      #
      def console(name=@project.primary_gemspec_name)
        run(*arguments(name))
      end

    end
  end
end
