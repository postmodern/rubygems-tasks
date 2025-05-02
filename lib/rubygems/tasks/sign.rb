require_relative 'sign/checksum'
require_relative 'sign/pgp'

module Gem
  class Tasks
    class Sign

      # The {Checksum sign:checksum} task.
      #
      # @return [Checksum, nil]
      #
      # @since 0.3.0
      attr_reader :checksum

      # The {PGP sign:pgp} task.
      #
      # @return [PGP, nil]
      #
      # @since 0.3.0
      attr_reader :pgp

      #
      # Initializes the `scm:*` tasks.
      #
      # @param [Boolean] checksum
      #   Enables or disables the {Checksum sign:checksum} task.
      #
      # @param [Boolean] pgp
      #   Enables or disables the {PGP sign:pgp} task.
      #
      # @since 0.3.0
      #
      def initialize(checksum: nil, pgp: nil)
        @checksum = (Checksum.new if checksum)
        @pgp      = (PGP.new      if pgp)
      end

    end
  end
end
