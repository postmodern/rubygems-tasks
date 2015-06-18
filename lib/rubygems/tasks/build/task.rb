require 'rubygems/tasks/task'

module Gem
  class Tasks
    module Build
      class Task < Tasks::Task

        #
        # @param [String] path
        #
        # @param [Gem::Specification] gemspec
        #
        # @abstract
        #
        def build(path,gemspec)
        end

        protected

        #
        # Defines build task(s) for file type.
        #
        # @param [Symbol] name
        #   The name for the task(s).
        #
        # @param [String, Symbol] extname
        #   The file extension for the resulting files.
        #
        # @api semipublic
        #
        def build_task(name,extname=name)
          directory Project::PKG_DIR

          task :validate

          @project.builds.each do |build,packages|
            gemspec = @project.gemspecs[build]
            path    = packages[extname]

            # define file tasks, so the packages are not needless re-built
            file(path => [Project::PKG_DIR, *gemspec.files]) do
              invoke :validate

              status "Building #{File.basename(path)} ..."

              build(path,gemspec)
            end

            task "build:#{name}:#{build}" => path
            task "build:#{build}"         => "build:#{name}:#{build}"
          end

          gemspec_tasks "build:#{name}"

          desc "Builds all packages" unless task?(:build)
          task :build => "build:#{name}"
        end

      end
    end
  end
end
