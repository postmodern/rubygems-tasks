require 'rubygems/tasks/task'

module Gem
  class Tasks
    module SCM
      class Tag < Task

        # Default format for versions
        DEFAULT_FORMAT = '%s'

        attr_accessor :format

        def initialize(options={})
          super()

          @format = options.fetch(:format,DEFAULT_FORMAT)

          yield self if block_given?
          define
        end

        def define
          namespace :scm do
            task :tag, [:name] do |t,args|
              tag = if args.name
                      args.name
                    else
                      version_tag(gemspec.version)
                    end

              status "Tagging #{tag} ..."

              unless tag!(tag)
                error "Could not create tag #{tag}"
              end
            end
          end
        end

        #
        # @raise [TypeError]
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
        # @param [String] name
        #
        # @return [Boolean]
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

            mkdir_p tags_dir
            cp_r    '.', tag_dir

            return run('svn', 'add', tag_dir)
          else
            true
          end
        end

      end
    end
  end
end
