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
      # @param [Array<String>] arguments
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
      # Explicitly invokes a task.
      #
      # @param [Symbol, String] name
      #   The name of the task.
      #
      # @api semipublic
      #
      # @since 0.2.2
      #
      def invoke(name)
        Rake.application[name].invoke
      end

      #
      # Defines a task that will invoke one or all of the specifies tasks
      # within the namespace.
      #
      # @param [String] prefix
      #   The namespace of the sub-tasks to call.
      #
      # @param [Array<Symbol>] subtasks
      #   The names of the sub-tasks.
      #
      # @example
      #   namespaced_tasks 'pkg:tar', @project.gemspecs.keys
      #
      # @api semipublic
      #
      def namespaced_tasks(prefix,subtasks)
        task prefix => subtasks.map { |subtask| "#{prefix}:#{subtask}" }
      end

      #
      # Defines a task that will execute tasks for each gemspec.
      #
      # @param [Symbol, String] prefix
      #   The name for the task.
      #
      # @api semipublic
      #
      def gemspec_tasks(prefix)
        namespaced_tasks prefix, @project.gemspecs.keys
      end

    end
  end
end
