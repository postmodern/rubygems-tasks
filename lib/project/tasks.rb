require 'scm'

require 'rake/tasklib'
require 'digest/sha1'
require 'set'

module Project
  #
  # Defines basic Rake tasks for managing and releasing projects.
  #
  class Tasks < Rake::TaskLib

    # Specifies the [gemcutter](http://github.com/rubygems/gemcutter#readme)
    # host or if pushing gems to [rubygems.org](http://rubygems.org/)
    # is enabled.
    attr_accessor :gemcutter

    # Prefix for release tags (default: `v`).
    attr_accessor :tag_prefix

    # The loaded gemspec of the project.
    attr_reader :gemspec

    # The files of the project.
    attr_reader :files

    # The directories to add to `$LOAD_PATHS`.
    attr_reader :load_paths

    # The SCM the project uses.
    attr_reader :scm

    #
    # Initializes the project tasks.
    #
    # @param [Hash] options
    #   Additional options for the tasks.
    #
    # @option options [String] :root (Dir.pwd)
    #   The optional root directory for the project.
    #
    # @option options [String, Boolean] :gemcutter (true)
    #   Specifies the
    #   [gemcutter](http://github.com/rubygems/gemcutter#readme)
    #   server to push built Gems to. If `:gemcutter` is a Boolean value, it
    #   will enable or disable pushing to
    #   [rubygems.org](http://rubygems.org/).
    #
    # @yield [tasks]
    #   If a block is given, it will be passed the newly created tasks,
    #   before they are fully defined.
    #
    # @yieldparam [Tasks] tasks
    #   The newly created tasks.
    #
    def initialize(options={})
      @root = File.join(Dir.pwd,options.fetch(:root,''))
      @scm = begin
               SCM.new(@root)
             rescue
             end

      @name = File.basename(@root)
      @version = options[:version]

      @files = Set[]
      @load_paths = []

      @gemcutter = options.fetch(:gemcutter,true)
      @bundler   = File.file?('Gemfile')

      @tag_prefix = options.fetch(:tag_prefix,'v')

      if (@gemspec = load_gemspec)
        @name    = @gemspec.name
        @version = @gemspec.version

        @gemspec.files.each { |path| @files << path }
        @load_paths += @gemspec.require_paths
      else
        if @scm
          @scm.files { |path| @files << path }
        else
          Dir.glob('{**/}{.*,*}') do |path|
            @files << path if File.file?(path)
          end
        end

        @load_paths += Dir['{ext,lib}']
      end

      @release_name = "#{@name}-#{@version}"

      define
    end

    protected

    def load_gemspec
      require 'rubygems'

      paths = ["#{@name}.gemspec"] + Dir['*.gemspec']

      paths.each do |path|
        if File.file?(path)
          return Gem::Specification.load(path)
        end
      end

      return nil
    end

    #
    # Defines tasks used during development.
    #
    def define_core_tasks
      namespace :build do
        directory 'pkg'

        task :tar => ['pkg'] do
          run 'tar', '-czf', pkg_file('tar.gz'), *@files
        end
      end

      desc "Builds #{@release_name}"
      task :build

      desc "Installs #{@release_name}"
      task :install => :build

      desc "Releases #{@release_name}"
      task :release => :build

      desc "Start IRB with all runtime dependencies loaded"
      task :console, [:script] do |t,args|
        original_load_path = $LOAD_PATH

        if @bundler
          require 'bundler'
          Bundler.setup(:default)
        end

        # add the project code directories to the $LOAD_PATH
        @load_paths.each do |dir|
          $LOAD_PATH.unshift(File.join(@root,dir))
        end

        # clear ARGV so IRB is not confused
        ARGV.clear

        require 'irb'

        # set the optional script to run
        IRB.conf[:SCRIPT] = args.script
        IRB.start

        # return the $LOAD_PATH to it's original state
        $LOAD_PATH.reject! do |path|
          !(original_load_path.include?(path))
        end
      end

      desc 'Displays the current version'
      task :version do
        puts @version
      end
    end
    
    def define_scm_tasks
      task :status do
        changes = @scm.status

        unless changes.empty?
          legend = @scm.class::STATUSES.invert

          puts "The following files were modified:"
          changes.each do |path,status|
            puts "#{legend[status]}\t#{path}"
          end
          puts

          abort "The project has uncommitted changes!"
        end
      end
      task :build => :status

      namespace :release do
        task :tag do
          # ensure the repository is not out-of-sync
          unless @scm.push
            abort "Could not push changes"
          end

          tag_name = "#{@tag_prefix}#{@version}"

          unless @scm.tag(tag_name)
            abort "Could not create tag #{tag_name}"
          end

          @scm.push(:tags => true)
        end
      end
      task :release => 'release:tag'
    end

    #
    # Defines the RubyGems specific tasks.
    #
    def define_rubygem_tasks
      @gem_pkg = pkg_file('gem')

      namespace :build do
        task :gem => ['pkg'] do
          builder = Gem::Builder.new(@gemspec)

          mv builder.build, @gem_pkg
        end
      end

      task :build => 'build:gem'
      task :gem   => 'build:gem' # backwards compatibility with Hoe

      namespace :install do
        task :gem => ['build:gem'] do
          unless File.file?(@gem_pkg)
            abort "Could not find #{@gem_pkg}!"
          end

          gem 'install', @gem_pkg
        end

        unless @bundler
          desc 'Installs missing dependencies'
          task :deps do
            install_missing_dependency = lambda { |dep|
              install_dependency(dep) unless Gem.available?(dep)
            }

            @gemspec.runtime_dependencies.each(&install_missing_dependency)
            @gemspec.development_dependencies.each(&install_missing_dependency)
          end
        end
      end
      task :install     => 'install:gem'
      task :install_gem => 'install:gem' # backwards compatibility with Hoe

      if @gemcutter
        namespace :release do
          task :gem => 'build:gem' do
            unless File.file?(@gem_pkg)
              abort "Could not find #{@gem_pkg}!"
            end

            arguments = []

            if @gemcutter.kind_of?(String)
              arguments << '--host' << @gemcutter
            end

            gem 'push', @gem_pkg, *arguments
          end
        end

        task :release => ['release:gem']
      end
    end

    #
    # Defines the project tasks.
    #
    def define
      define_core_tasks
      define_scm_tasks     if @scm
      define_rubygem_tasks if @gemspec
    end

    def pkg_file(ext)
      File.join('pkg',"#{@name}-#{@version}.#{ext}")
    end

    #
    # Runs a program with optional arguments.
    #
    # @param [String] program
    #   The program to run.
    #
    # @param [Array<String>] arguments
    #   Optional arguments.
    #
    # @return [true]
    #   The program was executed successfully.
    #
    def run(program,*arguments)
      show_command = ([program] + arguments).join(' ')

      unless rake_system(program,*arguments)
        abort "Command failed: #{show_command}"
      end

      return true
    end

    #
    # Runs a RubyGems command.
    #
    # @param [Array<String>]
    #   The arguments to pass to RubyGems.
    #
    # @return [true]
    #   The command was executed successfully.
    #
    # @see #run
    #
    def gem(*arguments)
      run(RUBY,'-S','gem',*arguments)
    end

    #
    # Installs a dependency.
    #
    # @param [Gem::Dependency] dep
    #   The RubyGems dependency to be installed.
    #
    # @return [true]
    #   Specifies that the dependency was successfully installed.
    #
    def install_dependency(dep)
      arguments = []

      # enable install pre-releases
      arguments << '--prerelease' if dep.prerelease?

      # specify the version requirements
      dep.versions.each { |v| arguments << '--version' << v }

      gem 'install', dep.name, *arguments
    end

  end
end
