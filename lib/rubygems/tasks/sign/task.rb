require 'rubygems/tasks/task'

require 'digest'

module Gem
  class Tasks < Rake::TaskLib
    module Sign
      class Task < Tasks::Task

        #
        # Defines signing tasks for the various packages.
        #
        def define
          sign_task :gem
          sign_task :tar
          sign_task 'tar_gz',  'tar.gz'
          sign_task 'tar_bz2', 'tar.bz2'
          sign_task 'tar_xz',  'tar.xz'
          sign_task :zip
        end

        protected

        #
        # Defines the signing task.
        #
        # @param [Symbol, String] package
        #   The package format to sign.
        #
        # @param [String] extname
        #   The file extension for the package format.
        #
        def sign_task(package,extname=package)
          name = self.class.task_name

          if task_defined?("build:#{package}")
            namespace :sign do
              namespace name do
                namespace package do
                  @project.each_package(extname) do |build,path|
                    task build => path do
                      sign(path)
                    end
                  end
                end
              end
            end

            multi_task "sign:#{name}:#{package}", @project.builds

            task "sign:#{name}" => "sign:#{name}:#{package}"
            task :sign          => "sign:#{name}:#{package}"
          end
        end

        #
        # Signs a package.
        #
        # @param [String] path
        #   The path to the package.
        #
        # @abstract
        #
        def sign(path)
        end

      end
    end
  end
end
