require 'rubygems/tasks/scm/status'
require 'rubygems/tasks/scm/tag'
require 'rubygems/tasks/scm/push'

module Gem
  class Tasks
    class SCM

      # The {Status scm:status} task.
      #
      # @return [Status, nil]
      #
      # @since 0.3.0
      attr_reader :status

      # The {Tag scm:tag} task.
      #
      # @return [Tag, nil]
      #
      # @since 0.3.0
      attr_reader :tag

      # The {Push scm:push} task.
      #
      # @return [Push, nil]
      #
      # @since 0.3.0
      attr_reader :push

      #
      # Initializes the `scm:*` tasks.
      #
      # @param [Boolean] status
      #   Enables or disables the {SCM::Status scm:status} task.
      #
      # @param [Boolean] tag
      #   Enables or disables the {SCM::Tag scm:tag} task.
      #
      # @param [Boolean] push
      #   Enables or disables the {SCM::Push scm:push} task.
      #
      def initialize(status: true, tag: true, push: true)
        @status = (Status.new if status)
        @tag    = (Tag.new    if tag)
        @push   = (Push.new   if push)
      end

    end
  end
end
