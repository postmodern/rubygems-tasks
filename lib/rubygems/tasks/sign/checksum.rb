require 'rubygems/tasks/sign/task'

require 'digest'

module Gem
  class Tasks
    module Sign
      #
      # The `sign:checksum` task.
      #
      class Checksum < Task

        # Enables or disables MD5 checksums.
        attr_writer :md5

        # Enables or disables SHA1 checksums.
        attr_writer :sha1

        # Enables or disables SHA2 checksums.
        attr_writer :sha2

        # Enables or disables SHA512 checksums.
        attr_writer :sha512

        #
        # Initializes the `sign:checksum` task.
        #
        # @param [Hash] options
        #   Digest options.
        #
        # @option options [Boolean] :md5 (true)
        #   Specifies whether MD5 checksums are enabled.
        #
        # @option options [Boolean] :sha1 (true)
        #   Specifies whether SHA1 checksums are enabled.
        #
        # @option options [Boolean] :sha2 (false)
        #   Specifies whether SHA2 checksums are enabled.
        #
        # @option options [Boolean] :sha512 (false)
        #   Specifies whether SHA512 checksums are enabled.
        #
        def initialize(options={})
          super()

          @md5    = options.fetch(:md5,   true)
          @sha1   = options.fetch(:sha1,  true)
          @sha2   = options.fetch(:sha2,  false)
          @sha512 = options.fetch(:sha512,false)

          yield self if block_given?
          define
        end

        #
        # Specifies whether MD5 checksums are enabled.
        #
        # @return [Boolean]
        #
        def md5?; @md5; end

        #
        # Specifies whether SHA1 checksums are enabled.
        #
        # @return [Boolean]
        #
        def sha1?; @sha1; end

        #
        # Specifies whether SHA2 checksums are enabled.
        #
        # @return [Boolean]
        #
        def sha2?; @sha2; end

        #
        # Specifies whether SHA512 checksums are enabled.
        #
        # @return [Boolean]
        #
        def sha512?; @sha512; end

        #
        # Defines the `sign:checksum` tasks.
        #
        def define
          super(:checksum)

          task :checksum => 'sign:checksum'
        end

        #
        # Prints the checksums of a package.
        #
        # @param [String] path
        #   The path to the package.
        #
        # @api semipublic
        #
        def sign(path)
          status "Checksums for #{File.basename(path)}:"

          puts
          puts "  md5:    #{Digest::MD5.file(path)}"    if @md5
          puts "  sha1:   #{Digest::SHA1.file(path)}"   if @sha1
          puts "  sha2:   #{Digest::SHA2.file(path)}"   if @sha2
          puts "  sha512: #{Digest::SHA512.file(path)}" if @sha512
          puts
        end

      end
    end
  end
end
