require_relative 'task'

module Gem
  class Tasks
    class Sign
      #
      # The `sign:pgp` task.
      #
      class PGP < Task

        #
        # Initializes the `sign` task.
        #
        def initialize
          super()

          yield self if block_given?
          define
        end

        #
        # Defines the `sign:pgp` task.
        #
        def define
          super(:pgp)

          task :pgp => 'sign:pgp'
        end

        #
        # PGP signs a package.
        #
        # @param [String] path
        #   The path to the package.
        #
        # @api semipublic
        #
        def sign(path)
          status "Signing #{File.basename(path)} ..."

          run 'gpg', '--sign', '--detach-sign', '--armor', path
        end

      end
    end
  end
end
