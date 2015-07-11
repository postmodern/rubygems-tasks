require 'rubygems/tasks/task'

module Gem
  class Tasks
    #
    # The `install` task.
    #
    class Install < Task

      #
      # Initializes the `install` task.
      #
      # @param [Hash] options
      #   Additional options.
      #
      def initialize(options={})
        super()

        yield self if block_given?
        define
      end

      #
      # Defines the `install` task.
      #
      def define
        namespace :install do
          @project.builds.each do |build,packages|
            path = packages[:gem]

            task build => path do
              status "Installing #{File.basename(path)} ..."

              install(path)
            end
          end
        end

        desc "Installs all built gem packages"
        gemspec_tasks :install

        task :install_gem => :install # backwards compatibility with Hoe
      end

      #
      # Pushes the gem by running `gem install`.
      #
      # @param [String] path
      #   The path to the `.gem` file.
      #
      # @return [Boolean]
      #   Specifies whether `gem install` was successful or not.
      #
      # @api semipublic
      #
      def install(path)
        gem 'install', '-q', path
      end

    end
  end
end
