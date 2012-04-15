require 'rake/tasklib'

module Gem
  class Tasks < Rake::TaskLib
    class Project

      SCM_DIRS = {
        :git => '.git',
        :hg  => '.hg',
        :svn => '.svn'
      }

      PKG_DIR = 'pkg'

      attr_reader :root

      attr_reader :name

      attr_reader :scm

      attr_reader :gemspecs

      attr_reader :gems

      def initialize(root=Dir.pwd)
        @root = root
        @name = File.basename(@root)

        @scm, _ = SCM_DIRS.find do |scm,dir|
                    File.directory?(File.join(@root,dir))
                  end

        Dir.chdir(@root) do
          @gemspecs = Hash[glob('*.gemspec').map { |path|
            [File.basename(path).chomp('.gemspec'), Specification.load(path)]
          }]
        end

        @bundler = File.file?(File.join(@root,'Gemfile'))
      end

      def self.directories
        @@directories ||= Hash.new do |hash,key|
          hash[key] = new(key)
        end
      end

      def glob(pattern)
        Dir.glob(File.join(@root,pattern))
      end

      def bundler?
        @bundler
      end

      def builds
        @gemspecs.keys
      end

      def package(build,format)
        unless (gemspec = @gemspecs[build])
          raise("could not find gemspec: #{build.dump}")
        end

        return File.join(PKG_DIR,"#{gemspec.name}-#{gemspec.version}.#{format}")
      end

      def each_package(format)
        builds.each do |build|
          yield build, package(build,format)
        end
      end

    end
  end
end
