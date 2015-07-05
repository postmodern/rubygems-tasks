require 'rubygems/tasks/console'
require 'rubygems/tasks/build'
require 'rubygems/tasks/install'
require 'rubygems/tasks/scm'
require 'rubygems/tasks/push'
require 'rubygems/tasks/release'
require 'rubygems/tasks/sign'

require 'rake/tasklib'
require 'ostruct'

module Gem
  #
  # Defines basic Rake tasks for managing and releasing projects:
  #
  # * {Build::Gem build:gem}
  # * {Build::Tar build:tar}
  # * {Build::Zip build:zip}
  # * {SCM::Status scm:status}
  # * {SCM::Push scm:push}
  # * {SCM::Tag scm:tag}
  # * {Console console}
  # * {Install install}
  # * {Push push}
  # * {Release release}
  # * {Sign::Checksum sign:checksum}
  # * {Sign::PGP sign:pgp}
  #
  class Tasks

    #
    # The `build` tasks.
    #
    # @return [OpenStruct]
    #   The collection of `build` tasks.
    #
    attr_reader :build

    #
    # The `scm` tasks.
    #
    # @return [OpenStruct]
    #   The collection of `scm` tasks.
    #
    attr_reader :scm

    #
    # The `sign` tasks.
    #
    # @return [OpenStruct]
    #   The collection of `sign` tasks.
    #
    attr_reader :sign

    # The {Console console} task.
    attr_reader :console

    # The {Install install} task.
    attr_reader :install

    # The {Push push} task.
    attr_reader :push

    # The {Release release} task.
    attr_reader :release

    #
    # Initializes the project tasks.
    #
    # @param [Hash{Symbol => Hash}] options
    #   Enables or disables individual tasks.
    #
    # @option options [Hash{Symbol => Boolean}] :build
    #   Enables or disables the `build` tasks.
    #
    # @option options [Hash{Symbol => Boolean}] :scm
    #   Enables or disables the `scm` tasks.
    #
    # @option options [Boolean] :console (true)
    #   Enables or disables the {Console console} task.
    #
    # @option options [Boolean] :install (true)
    #   Enables or disables the {Install install} task.
    #
    # @option options [Boolean] :push (true)
    #   Enables or disables the {Push push} task.
    #
    # @option options [Boolean] :release (true)
    #   Enables or disables the {Release release} task.
    #
    # @option options [Hash{Symbol => Boolean}] :sign
    #   Enables or disables the `sign` tasks.
    #
    # @yield [tasks]
    #   If a block is given, it will be passed the newly created tasks,
    #   before they are fully defined.
    #
    # @yieldparam [Tasks] tasks
    #   The newly created tasks.
    #
    # @example Enables building of `.gem` and `.tar.gz` packages:
    #   Gem::Tasks.new(build: {gem: true, tar: true})
    #
    # @example Disables pushing `.gem` packages to [rubygems.org](rubygems.org):
    #   Gem::Tasks.new(push: false)
    #
    # @example Configures the version tag format:
    #   Gem::Tasks.new do |tasks|
    #     tasks.scm.tag.format = "release-%s"
    #   end
    #
    def initialize(options={})
      build_options = options.fetch(:build,{})
      scm_options   = options.fetch(:scm,{})
      sign_options  = options.fetch(:sign,{})

      @scm   = OpenStruct.new
      @build = OpenStruct.new
      @sign  = OpenStruct.new

      if build_options
        @build.gem = (Build::Gem.new if build_options.fetch(:gem,true))
        @build.tar = (Build::Tar.new if build_options[:tar])
        @build.zip = (Build::Zip.new if build_options[:zip])
      end

      if scm_options
        @scm.status = (SCM::Status.new if scm_options.fetch(:status,true))
        @scm.tag    = (SCM::Tag.new    if scm_options.fetch(:tag,true))
        @scm.push   = (SCM::Push.new   if scm_options.fetch(:push,true))
      end

      if sign_options
        @sign.checksum = (Sign::Checksum.new if sign_options[:checksum])
        @sign.pgp      = (Sign::PGP.new      if sign_options[:pgp])
      end

      @console = (Console.new if options.fetch(:console,true))
      @install = (Install.new if options.fetch(:install,true))
      @push    = (Push.new    if options.fetch(:push,true))
      @release = (Release.new if options.fetch(:release,true))

      yield self if block_given?
    end

  end
end
