module Gem
  class Tasks
    #
    # Provides helper methods for printing messages.
    #
    # @api semipublic
    #
    module Printing

      # ANSI 'bright' color code
      ANSI_BRIGHT = "\e[1m"

      # ANSI 'clear' color code
      ANSI_CLEAR = "\e[0m"

      # ANSI 'green' color code
      ANSI_GREEN = "\e[32m"

      # ANSI 'yellow' color code
      ANSI_YELLOW = "\e[33m"

      # ANSI 'red' color code
      ANSI_RED = "\e[31m"

      # Prefix for all status messages
      STATUS_PREFIX = if $stdout.tty?
                        "#{ANSI_GREEN}#{ANSI_BRIGHT}>>>#{ANSI_CLEAR}"
                      else
                        ">>>"
                      end

      # Prefix for all debugging messages
      DEBUG_PREFIX = if $stderr.tty?
                        "#{ANSI_YELLOW}#{ANSI_BRIGHT}>>>#{ANSI_CLEAR}"
                     else
                       ">>>"
                     end

      # Prefix for all error messages
      ERROR_PREFIX = if $stderr.tty?
                        "#{ANSI_RED}#{ANSI_BRIGHT}!!!#{ANSI_CLEAR}"
                     else
                       "!!!"
                     end

      protected

      #
      # Prints a status message.
      #
      # @param [String] message
      #   The message to print.
      #
      def status(message)
        if Rake.verbose
          $stdout.puts "#{STATUS_PREFIX} #{message}"
        end
      end

      #
      # Prints a debugging message.
      #
      # @param [String] message
      #   The message to print.
      #
      def debug(message)
        if (Rake.verbose && Rake.application.options.trace)
          $stderr.puts "#{DEBUG_PREFIX} #{message}"
        end
      end

      #
      # Prints an error message and exits.
      #
      # @param [String] message
      #   The message to print.
      #
      def error(message)
        $stderr.puts "#{ERROR_PREFIX} #{message}"
      end

      private

      #
      # The FileUtils output method.
      #
      # @param [String] message
      #   The FileUtils message to print.
      #
      # @since 0.2.1
      #
      def fu_output_message(message)
        debug(message)
      end

    end
  end
end
