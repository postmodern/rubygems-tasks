require 'rubygems/tasks/task'

module Gem
  class Tasks < Rake::TaskLib
    class Push < Task

      PKG_DIR = 'pkg'

      attr_accessor :host

      def initialize(options={})
        super()

        @host = options[:host]

        yield self if block_given?
        define
      end

      def define
        namespace :push do
          @project.each_package(:gem) do |build,path|
            task build => path do
              arguments = []
              arguments << '--host' << @host if @host

              sh 'gem', 'push', @gem, *arguments
            end
          end
        end

        desc "Pushes all gems"
        multi_task 'push', @project.builds
      end

    end
  end
end
