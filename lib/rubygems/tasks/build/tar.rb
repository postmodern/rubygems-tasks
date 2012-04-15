require 'rubygems/tasks/build/task'

module Gem
  class Tasks < Rake::TaskLib
    module Build
      class Tar < Task

        FLAGS = {
          :bz2 => 'j',
          :gz  => 'x',
          :xz  => 'J'
        }

        attr_accessor :format

        #
        # @option options [Symbol] :format (:bz2)
        #   Format of the tar archive.
        #
        #   * `:bz2`
        #   * `:gz`
        #   * `:xz`
        #
        def initialize(options={})
          super()

          @format = options.fetch(:format,:bz2)

          yield self if block_given?

          @flag = FLAGS[@format]

          extname = 'tar'
          extname << ".#{@format}" if @format

          define :tar, extname
        end

        def build(path,gemspec)
          flags = 'c'
          flags << FLAGS[@format]
          flags << 'f'

          sh 'tar', flags, path, *gemspec.files
        end

      end
    end
  end
end
