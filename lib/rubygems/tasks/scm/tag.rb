require 'rubygems/tasks/task'

module Gem
  class Tasks
    module SCM
      #
      # The `scm:tag` task.
      #
      class Tag < Task

        # Default format for versions
        DEFAULT_FORMAT = '%s'

        # The format for version tags.
        #
        # @return [String, Proc]
        #   The format String or Proc.
        #
        attr_accessor :format

        #
        # Initializes the `scm:tag` task.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String, Proc] :format (DEFAULT_FORMAT)
        #   The format String or Proc for version tags.
        #
        def initialize(options={})
          super()

          @format = options.fetch(:format,DEFAULT_FORMAT)

          yield self if block_given?
          define
        end

        #
        # Defines the `scm:tag` task.
        #
        def define
          namespace :scm do
            task :tag, [:name] do |t,args|
              tag = if args.name
                      args.name
                    else
                      version_tag(@project.primary_gemspec.version)
                    end

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
        # Creates a tag.
        #
        # @param [String] name
        #   The name of the tag.
        #
        # @return [Boolean]
        #   Specifies whether the tag was successfully created.
        #
        def tag!(name)
          case @project.scm
          when :git then run 'git', 'tag', name
          when :hg  then run 'hg', 'tag', name
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

            FileUtils.mkdir_p tags_dir
            FileUtils.cp_r '.', tag_dir

            return run('svn', 'add', tag_dir)
          else
            true
          end
        end

      end
    end
  end
end
