require_relative 'tasks/console'
require_relative 'tasks/build'
require_relative 'tasks/install'
require_relative 'tasks/scm'
require_relative 'tasks/push'
require_relative 'tasks/release'
require_relative 'tasks/sign'

require 'rake/tasklib'

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

    # The {Build build:\*} tasks.
    #
    # @return [Build]
    attr_reader :build

    # The {SCM scm:\*} tasks.
    #
    # @return [SCM]
    attr_reader :scm

    # The {Sign sign:\*} tasks.
    #
    # @return [Sign]
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
    # @param [Hash{Symbol => Boolean}] build
    #   Enables or disables the `build` tasks. Additional keyword arguments
    #   can be passed to the individual build tasks via a Hash.
    #
    # @option build [Boolean] :gem (true)
    #   Enables or disables the {Build::Gem build:gem} task.
    #
    # @option build [Boolean] :tar
    #   Enables or disables the {Build::Tar build:tar} task.
    #
    # @option build [Boolean] :zip
    #   Enables or disables the {Build::Zip build:zip} task.
    #
    # @param [Hash{Symbol => Boolean}] scm
    #   Enables or disables the `scm` tasks. Additional keyword arguments
    #   can be passed to the individual scm tasks via a Hash.
    #
    # @option scm [Boolean] :status (true)
    #   Enables or disables the {SCM::Status scm:status} task.
    #
    # @option scm [Boolean] :tag (true)
    #   Enables or disables the {SCM::Tag scm:tag} task.
    #
    # @option scm [Boolean] :push (true)
    #   Enables or disables the {SCM::Push scm:push} task.
    #
    # @param [Hash{Symbol => Boolean}] sign
    #   Enables or disables the `sign` tasks. Additional keyword arguments
    #   can be passed to the individual sign tasks via a Hash.
    #
    # @option sign [Boolean] :checksum
    #   Enables or disables the {Sign::Checksum sign:checksum} task.
    #
    # @option sign [Boolean] :pgp
    #   Enables or disables the {Sign::PGP sign:pgp} task.
    #
    # @param [Boolean] console
    #   Enables or disables the {Console console} task.
    #
    # @param [Boolean] install
    #   Enables or disables the {Install install} task.
    #
    # @param [Boolean] push
    #   Enables or disables the {Push push} task.
    #
    # @param [Boolean] release
    #   Enables or disables the {Release release} task.
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
    def initialize(build:   {},
                   scm:     {},
                   sign:    {},
                   console: true,
                   install: true,
                   push:    true,
                   release: true)
      @scm   = SCM.new(**scm)
      @build = Build.new(**build)
      @sign  = Sign.new(**sign)

      @console = (Console.new if console)
      @install = (Install.new if install)
      @push    = (Push.new    if push)
      @release = (Release.new if release)

      yield self if block_given?
    end

  end
end
