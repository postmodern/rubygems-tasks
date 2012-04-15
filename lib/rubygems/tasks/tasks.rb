require 'rubygems/tasks/console'
require 'rubygems/tasks/build'
require 'rubygems/tasks/install'
require 'rubygems/tasks/scm'
require 'rubygems/tasks/push'
require 'rubygems/tasks/sign'

require 'rake/tasklib'

module Gem
  #
  # Defines basic Rake tasks for managing and releasing projects.
  #
  class Tasks < Rake::TaskLib

    #
    # Initializes the project tasks.
    #
    # @param [Hash{Symbol => Hash}] options
    #   Additional options for each task.
    #
    # @option options [Hash] :console
    #   Options for the {Console console} task.
    #
    # @option options [Hash] :build_gem
    #   Options for the {Build::Gem build:gem} task.
    #
    # @option options [Hash] :build_tar
    #   Options for the {Build::Tar build:tar} task.
    #
    # @option options [Hash] :build_zip
    #   Options for the {Build::Zip build:zip} task.
    #
    # @option options [Hash] :install
    #   Options for the {Install install} task.
    #
    # @option options [Hash] :scm_status
    #   Options for the {SCM::Status scm:status} task.
    #
    # @option options [Hash] :scm_tag
    #   Options for the {SCM::Tag scm:tag} task.
    #
    # @option options [Hash] :scm_push
    #   Options for the {SCM::Push scm:push} task.
    #
    # @option options [Hash] :push
    #   Options for the {Push push} task.
    #
    # @option options [Hash] :checksum
    #   Options for the {Checksum checksum} task.
    #
    # @yield [tasks]
    #   If a block is given, it will be passed the newly created tasks,
    #   before they are fully defined.
    #
    # @yieldparam [Tasks] tasks
    #   The newly created tasks.
    #
    def initialize(options={})
      Tasks.registered.each do |name,task_class,enabled|
        task = case (task_options = options[name])
               when true
                 task_class.new
               when nil
                 task_class.new if enabled
               when Hash
                 task_class.new(task_options)
               when false
                 nil
               else
                 raise(ArgumentError,"invalid :#{name} options: #{task_options.inspect}")
               end

        instance_variable_set("@#{name}",task)
      end

      yield self if block_given?
      define
    end

    #
    # The registered Tasks.
    #
    # @return [Array<(Symbol, Class, Boolean)>]
    #   The registered tasks, including name, class and whether the task is
    #   enabled by default.
    #
    def Tasks.registered
      @@registered ||= []
    end

    #
    # Registers a Task.
    #
    # @param [Symbol] name
    #   The variable name for the Task.
    #
    # @param [#initialize(Hash)] task_class
    #   The Task class.
    #
    # @param [Boolean] enabled
    #   Specifies whether the Task is enabled by default.
    #
    def Tasks.register(name,task_class,enabled=false)
      registered << [name, task_class, enabled]
      attr_reader name
    end

    register :console,    Console,     true
    register :build_gem,  Build::Gem,  true
    register :build_tar,  Build::Tar,  true
    register :build_zip,  Build::Zip,  true
    register :install,    Install,     true
    register :scm_status, SCM::Status, true
    register :scm_tag,    SCM::Tag,    true
    register :scm_push,   SCM::Push,   true
    register :push,       Push,        true

    register :sign_checksum,   Sign::Checksum
    register :sign_pgp,        Sign::PGP

    #
    # Defines the dependencies between the enabled tasks.
    #
    def define
      if task?('scm:status')
        # do not allow tagging releases when the repository is dirty
        task 'scm:tag' => 'scm:status' if task?('scm:tag')

        # do not allow pushing commits when the repository is dirty
        task 'scm:push' => 'scm:status' if task?('scm:push')

        # do not allow pushing gems when the repository is dirty
        task :push => 'scm:status' if task?(:push)
      end

      desc "Performs a release"
      task :release => [
        :build, 'scm:tag', 'scm:push', :push, :checksum
      ].select { |name| task?(name) }
    end

    #
    # @param [Symbol] name
    #
    # @return [Boolean]
    #
    def task?(name)
      Rake::Task.task_defined?(name)
    end

  end
end
