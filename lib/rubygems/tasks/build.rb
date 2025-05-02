require 'rubygems/tasks/build/tar'
require 'rubygems/tasks/build/gem'
require 'rubygems/tasks/build/zip'

module Gem
  class Tasks
    #
    # Collection of all `build:*` tasks.
    #
    # * {Build::Gem build:gem}
    # * {Build::Tar build:tar}
    # * {Build::Zip build:zip}
    #
    class Build

      # The {Gem build:gem} task.
      #
      # @return [Gem, nil]
      #
      # @since 0.3.0
      attr_reader :gem

      # The {Tar build:tar} task.
      #
      # @return [Tar, nil]
      #
      # @since 0.3.0
      attr_reader :tar

      # The {Zip build:zip} task.
      #
      # @return [Zip, nil]
      #
      # @since 0.3.0
      attr_reader :zip

      #
      # Initializes the `build:` tasks.
      #
      # @param [Boolean] gem
      #   Enables or disables the {Build::Gem build:gem} task.
      #
      # @param [Boolean] tar
      #   Enables or disables the {Build::Tar build:tar} task.
      #
      # @param [Boolean] zip
      #   Enables or disables the {Build::Zip build:zip} task.
      #
      # @since 0.3.0
      #
      def initialize(gem: true, tar: nil, zip: nil)
        @gem = Gem.new if gem
        @tar = Tar.new if tar
        @zip = Zip.new if zip
      end

    end
  end
end
