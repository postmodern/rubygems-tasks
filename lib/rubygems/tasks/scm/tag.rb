require 'rubygems/tasks/task'

module Gem
  class Tasks < Rake::TaskLib
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

              unless tag!(tag)
                abort "Could not create tag #{tag}"
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
        # @return [Array<String>]
        #
        def tags
          case @project.scm
          when :git then `git tag`.split($/)
          when :hg  then `hg tags`.split($/)
          when :svn then Dir['tags/*/'].map { |dir| File.dirname(dir) }
          else           []
          end
        end

        #
        # @param [String] name
        #
        # @return [Boolean]
        #
        def tag!(name)
          case @project.scm
          when :git then sh 'git', 'tag', name
          when :hg  then sh 'hg', 'tag', name
          when :svn
            tag_dir = File.join('tags',name)

            mkdir_p 'tags'
            cp_r    'trunk', tag_dir

            return sh 'svn', 'add', tag_dir
          else
            true
          end
        end

      end
    end
  end
end
