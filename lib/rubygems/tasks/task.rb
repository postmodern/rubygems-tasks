require 'rubygems/tasks/project'
require 'rubygems/tasks/printing'

require 'rake/tasklib'

module Gem
  class Tasks
    class Task < Rake::TaskLib

      include Printing

      def initialize
        @project = Project.directories[Dir.pwd]
      end

      #
      # The task name for the class.
      #
      # @return [String]
      #   The task name for the class.
      #
      def self.task_name
        @task_name ||= name.split('::').last.downcase
      end

      protected

      def run(command,*arguments)
        show_command = [command, *arguments].join(' ')

        debug show_command

        unless system(command,*arguments)
          error "Command failed: #{show_command}"
          abort
        end

        return true
      end

      def gem(command,*arguments)
        run 'gem', command, *arguments
      end

      def bundle(command,*arguments)
        run 'bundler', command, *arguments
      end

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
      def multi_task(prefix,names)
        task prefix => names.map { |name| "#{prefix}:#{name}" }
      end

      def gemspec_tasks(prefix)
        multi_task prefix, @project.gemspecs.keys
      end

    end
  end
end
