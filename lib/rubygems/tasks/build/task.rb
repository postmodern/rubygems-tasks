require 'rubygems/tasks/task'

require 'rubygems/builder'

module Gem
  class Tasks
    module Build
      class Task < Tasks::Task

        protected

        def build_task(name,extname=name)
          directory Project::PKG_DIR

          @project.builds.each do |build,packages|
            namespace :build do
              namespace name do
                gemspec = @project.gemspecs[build]
                path    = packages[extname]

                # define file tasks, so the packages are not needless re-built
                file(path => [Project::PKG_DIR, *gemspec.files]) do
                  status "Building #{File.basename(path)} ..."

                  build(path,gemspec)
                end

                task build => path
              end
            end

            task "build:#{build}" => "build:#{name}:#{build}"
          end

          gemspec_tasks "build:#{name}"

          desc "Builds all packages"
          task :build => "build:#{name}"
        end

        #
        # @param [String] path
        #
        # @param [Gem::Specification] gemspec
        #
        # @abstract
        #
        def build(path,gemspec)
        end

      end
    end
  end
end
