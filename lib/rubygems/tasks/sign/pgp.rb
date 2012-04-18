require 'rubygems/tasks/sign/task'

module Gem
  class Tasks
    module Sign
      class PGP < Task

        #
        # Initializes the `sign` task.
        #
        # @param [Hash] options
        #   Digest options.
        #
        def initialize(options={})
          super()

          yield self if block_given?
          define
        end

        #
        # Defines the `sign:pgp` task.
        #
        def define
          super

          task :pgp => 'sign:pgp'
        end

        protected

        #
        # PGP signs a package.
        #
        # @param [String] path
        #   The path to the package.
        #
        def sign(path)
          sh 'gpg', '--sign', path
        end

      end
    end
  end
end
