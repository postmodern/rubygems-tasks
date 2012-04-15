require 'rubygems/tasks/task'

require 'digest'

module Gem
  class Tasks < Rake::TaskLib
    class Checksum < Task

      attr_writer :md5

      attr_writer :sha1

      attr_writer :sha2

      attr_writer :sha512

      #
      # Initializes the `checksum` task.
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
      # Defines the `checksum` task.
      #
      def define
        checksum_task :gem                 if task_defined?('build:gem')
        checksum_task :tar                 if task_defined?('build:tar')
        checksum_task 'tar:gz',  'tar.gz'  if task_defined?('build:tar:gz')
        checksum_task 'tar:bz2', 'tar.bz2' if task_defined?('build:tar:bz2')
        checksum_task 'tar:xz',  'tar.xz'  if task_defined?('build:tar:xz')
        checksum_task :zip                 if task_defined?('build:zip')
      end

      protected

      #
      # Defines the `checksum` tasks for a package.
      #
      # @param [Symbol] name
      #   The package name.
      #
      # @param [String] extname
      #   The optional file extension for the package.
      #   
      def checksum_task(name,extname=name)
        namespace :checksum do
          namespace(name) do
            @project.each_package(extname) do |build,path|
              task build => "build:#{name}" do
                puts File.basename(path) + ':'
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

        desc "Checksums the #{name} packages"
        multi_task "checksum:#{name}", @project.builds

        task :checksum => "checksum:#{name}"
      end

    end
  end
end
