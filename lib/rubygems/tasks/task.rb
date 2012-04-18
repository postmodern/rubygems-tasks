require 'rubygems/tasks/project'

require 'rake/tasklib'

module Gem
  class Tasks
    class Task < Rake::TaskLib

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

      #
      # @param [String] name
      #
      # @return [Gem::Specification]
      #
      def gemspec(name=nil)
        name ||= @project.name

        unless (gemspec = @project.gemspecs[name])
          fail "could not find gemspec: #{name.dump}"
        end

        return gemspec
      end

      def gem(command,*arguments)
        sh 'gem', command, *arguments
      end

      def bundle(command,*arguments)
        sh 'bundler', command, *arguments
      end

      def task_defined?(name)
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
      #   multi_task 'pkg:tar', @project.gemspecs.keys
      #
      def multi_task(namespace,names)
        task(namespace, :name) do |t,args|
          if args.name
            Rake::Task["#{namespace}:#{args.name}"].invoke
          else
            names.each do |name|
              Rake::Task["#{namespace}:#{name}"].invoke
            end
          end
        end
      end

    end
  end
end
