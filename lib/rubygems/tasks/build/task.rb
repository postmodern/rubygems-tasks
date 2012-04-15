require 'rubygems/tasks/task'

require 'rubygems/builder'

module Gem
  class Tasks < Rake::TaskLib
    module Build
      class Task < Tasks::Task

        def define(name,extname=name)
          directory Project::PKG_DIR

          namespace :build do
            namespace name do
              @project.each_package(extname) do |build,path|
                gemspec = @project.gemspecs[build]

                # define file tasks, so the packages are not needless re-built
                file(path => [Project::PKG_DIR, *gemspec.files]) do
                  build(path,gemspec)
                end

                task build => path
              end
            end
          end

          desc "Builds all #{extname} packages"
          multi_task "build:#{name}", @project.builds

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
