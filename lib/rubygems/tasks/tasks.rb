require 'rubygems/tasks/console'
require 'rubygems/tasks/build'
require 'rubygems/tasks/install'
require 'rubygems/tasks/scm'
require 'rubygems/tasks/push'

require 'rake/tasklib'

module Gem
  #
  # Defines basic Rake tasks for managing and releasing projects.
  #
  class Tasks < Rake::TaskLib

    TASKS = [
      [:console,    Console],
      [:build_gem,  Build::Gem],
      [:build_tar,  Build::Tar],
      [:build_zip,  Build::Zip],
      [:install,    Install],
      [:scm_status, SCM::Status],
      [:scm_tag,    SCM::Tag],
      [:scm_push,   SCM::Push],
      [:push,       Push]
    ]

    #
    # The `console` task.
    #
    # @return [Console]
    #
    attr_reader :console

    #
    # The `build:gem` task.
    #
    # @return [Build::Gem]
    #
    attr_reader :build_gem

    #
    # The `build:tar` task.
    #
    # @return [Build::Tar]
    #
    attr_reader :build_tar

    #
    # The `build:zip` task.
    #
    # @return [Build::Zip]
    #
    attr_reader :build_zip

    #
    # The `install` task.
    #
    # @return [Install]
    #
    attr_reader :install

    #
    # The `scm:status` task/
    #
    # @return [SCM::Status]
    #
    attr_reader :scm_status

    #
    # The `scm:tag` task.
    #
    # @return [SCM::Tag]
    #
    attr_reader :scm_tag

    #
    # The `scm:push` task.
    #
    # @return [SCM::Push]
    #
    attr_reader :scm_push

    #
    # The `push` task.
    #
    # @return [Push]
    #
    attr_reader :push

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
    # @yield [tasks]
    #   If a block is given, it will be passed the newly created tasks,
    #   before they are fully defined.
    #
    # @yieldparam [Tasks] tasks
    #   The newly created tasks.
    #
    def initialize(options={})
      TASKS.each do |name,task_class|
        task = case (task_options = options[name])
               when true, nil
                 task_class.new
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
        :build, 'scm:tag', 'scm:push', :push
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
