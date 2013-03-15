require 'rubygems/tasks/task'

module Gem
  class Tasks
    module SCM
      #
      # The `scm:tag` task.
      #
      class Tag < Task

        # Default format for versions
        DEFAULT_FORMAT = 'v%s'

        # The format for version tags.
        #
        # @return [String, Proc]
        #   The format String or Proc.
        #
        attr_accessor :format

        # Enables or disables PGP signing of tags.
        # 
        # @param [Boolean] value
        #   The new value.
        #
        # @since 0.2.0
        #
        attr_writer :sign

        #
        # Initializes the `scm:tag` task.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String, Proc] :format (DEFAULT_FORMAT)
        #   The format String or Proc for version tags.
        #
        # @option options [Boolean] :sign
        #   Enables PGP signing of tags.
        #
        def initialize(options={})
          super()

          @format = options.fetch(:format,DEFAULT_FORMAT)
          @sign   = options[:sign]

          yield self if block_given?
          define
        end

        #
        # Defines the `scm:tag` task.
        #
        def define
          task :validate

          namespace :scm do
            task :tag, [:name] => :validate do |t,args|
              tag = (args.name || version_tag(@project.gemspec.version))

              status "Tagging #{tag} ..."

              unless tag!(tag)
                error "Could not create tag #{tag}"
              end
            end
          end
        end

        #
        # Formats the version into a version tag.
        #
        # @param [String] version
        #   The version to be formatted.
        #
        # @return [String]
        #   The tag for the version.
        #
        # @raise [TypeError]
        #   {#format} was not a String or a Proc.
        #
        # @api semipublic
        #
        def version_tag(version)
          case @format
          when String
            (@format % version)
          when Proc
            @format[version]
          else
            raise(TypeError,"tag format must be a String or Proc")
          end
        end

        #
        # Indicates whether new tags will be signed.
        #
        # @return [Boolean]
        #   Specifies whether new tags will be signed.
        #
        # @note
        #   If {#sign=} has not been set, {#sign?} will determine if tag signing
        #   has been enabled globally by calling the following commands:
        #
        #   * Git: `git config user.signingkey`
        #   * Mercurial: `hg showconfig extensions hgext gpg`
        #
        # @api semipublic
        #
        # @since 0.2.0
        #
        def sign?
          if @sign.nil?
            @sign = case @project.scm
                    when :git
                      !`git config user.signingkey`.chomp.empty?
                    when :hg
                      !`hg showconfig extensions.hgext.gpg`.empty?
                    else
                      false
                    end
          end

          return @sign
        end

        #
        # Creates a tag.
        #
        # @param [String] name
        #   The name of the tag.
        #
        # @return [Boolean]
        #   Specifies whether the tag was successfully created.
        #
        # @api semipublic
        #
        def tag!(name)
          message = "Tagging #{name}"

          case @project.scm
          when :git then
            arguments = ['-m', message]
            arguments << '-s' if sign?
            arguments << name

            run 'git', 'tag', *arguments
          when :hg  then
            if sign?
              # sign the change-set, then tag the release
              run 'hg', 'sign', '-m', "Signing #{name}"
            end

            run 'hg', 'tag', '-m', message, name
          when :svn
            branch   = File.basename(@project.root)
            tags_dir = if branch == 'trunk'
                         # we are in trunk/
                         File.join('..','tags')
                       else
                         # must be within branches/$name/
                         File.join('..','..','tags')
                       end

            tag_dir = File.join(tag_dirs,name)

            run 'svn', 'mkdir', '--parents', tag_dir
            run 'svn', 'cp', '*', tag_dir
            run 'svn', 'commit', '-m', message, tag_dir
          else
            true
          end
        end

      end
    end
  end
end
