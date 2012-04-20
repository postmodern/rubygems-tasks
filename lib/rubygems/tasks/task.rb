require 'rubygems/tasks/project'
require 'rubygems/tasks/printing'

require 'rake/tasklib'

module Gem
  class Tasks
    class Task < Rake::TaskLib

      include Printing

      #
      # Project metadata.
      #
      # @return [Project]
      #
      attr_reader :project

      #
      # Initializes the task.
      #
      def initialize
        @project = Project.directories[Dir.pwd]
      end

      #
      # The task name for the class.
      #
      # @return [String]
      #   The task name for the class.
      #
      # @api public
      #
      def self.task_name
        @task_name ||= name.split('::').last.downcase
      end

      protected

      #
      # Runs a command.
      #
      # @param [String] command
      #   The command to run.
      #
      # @param [Array<String>] arguments
      #   Additional arguments for the command.
      #
      # @return [Boolean]
      #   Specifies whether the command was successful.
      #
      # @api semipublic
      #
      def run(command,*arguments)
        show_command = [command, *arguments].join(' ')

        debug show_command

        unless system(command,*arguments)
          error "Command failed: #{show_command}"
          abort
        end

        return true
      end

      #
      # Runs a `gem` command.
      #
      # @param [String] command
      #   The `gem` command to run.
      #
      # @param [Array<String>] command
      #   Additional arguments for the command.
      #
      # @return [Boolean]
      #   Specifies whether the command was successful.
      #
      # @api semipublic
      #
      def gem(command,*arguments)
        run 'gem', command, *arguments
      end

      #
      # Runs a `bundle` command.
      #
      # @param [String] command
      #   The `bundle` command to run.
      #
      # @param [Array<String>] arguments
      #   Additional arguments for the command.
      #
      # @return [Boolean]
      #   Specifies whether the command was successful.
      #
      # @api semipublic
      #
      def bundle(command,*arguments)
        run 'bundler', command, *arguments
      end

      #
      # Determines if a task was defined.
      #
      # @param [Symbol, String] name
      #   The task name to search for.
      #
      # @return [Boolean]
      #   Specifies whether the task was defined.
      #
      # @api semipublic
      #
      def task?(name)
        Rake::Task.task_defined?(name)
      end

      #
      # Defines a task that will invoke one or all of the specifies tasks
      # within the namespace.
      #
      # @param [String] namespace
      #   The namespace of the sub-tasks to call.
      #
      # @param [Array<Symbol>] names
      #   The names of the sub-tasks.
      #
      # @example
      #   gemspec_tasks 'pkg:tar'
      #
      # @api semipublic
      #
      def multi_task(prefix,names)
        task prefix => names.map { |name| "#{prefix}:#{name}" }
      end

      #
      # Defines a task that will execute tasks for each gemspec.
      #
      # @param [Symbol, String] name
      #   The name for the task.
      #
      # @api semipublic
      #
      def gemspec_tasks(name)
        multi_task name, @project.gemspecs.keys
      end

    end
  end
end
