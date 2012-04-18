module Gem
  class Tasks
    module Printing

      ANSI_BRIGHT = "\e[1m"
      ANSI_CLEAR  = "\e[0m"
      ANSI_GREEN  = "\e[32m"
      ANSI_YELLOW = "\e[33m"
      ANSI_RED    = "\e[31m"

      STATUS_PREFIX = if $stdout.tty?
                        "#{ANSI_GREEN}#{ANSI_BRIGHT}>>>#{ANSI_CLEAR}"
                      else
                        ">>>"
                      end

      DEBUG_PREFIX = if $stderr.tty?
                        "#{ANSI_YELLOW}#{ANSI_BRIGHT}>>>#{ANSI_CLEAR}"
                     else
                       ">>>"
                     end

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
        $stdout.puts "#{STATUS_PREFIX} #{message}"
      end

      #
      # Prints a debugging message.
      #
      # @param [String] message
      #   The message to print.
      #
      def debug(message)
        if Rake.application.options.trace
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

    end
  end
end
