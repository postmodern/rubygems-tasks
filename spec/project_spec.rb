require 'spec_helper'
require 'rubygems/tasks/project'

describe Gem::Tasks::Project do
  let(:rubygems_project) do
    described_class.new(PROJECT_DIRS['rubygems-project'])
  end

  let(:rubygems_multi_project) do
    described_class.new(PROJECT_DIRS['rubygems-multi-project'])
  end

  let(:bundler_project) do
    described_class.new(PROJECT_DIRS['bundler-project'])
  end

  describe "directories" do
    it "should map paths to #{described_class} instances" do
      directory = PROJECT_DIRS['rubygems-project']
      project   = described_class.directories[directory]

      project.root.should == directory
    end
  end

  describe "#name" do
    subject { rubygems_project }

    it "should use the name of the directory" do
      subject.name.should == 'rubygems-project'
    end
  end

  describe "#scm" do
    subject { bundler_project }

    it "should detect the SCM used" do
      subject.scm.should == :git
    end
  end

  describe "#gemspecs" do
    context "with single-gemspec project" do
      subject { rubygems_project }

      it "should load the single-gemspec" do
        subject.gemspecs.values.map(&:name).should == %w[rubygems-project]
      end
    end

    context "with multi-gemspec project" do
      subject { rubygems_multi_project }

      it "should load all gemspecs" do
        subject.gemspecs.values.map(&:name).should =~ %w[
          rubygems-project
          rubygems-project-lite
        ]
      end
    end
  end

  describe "#primary_gemspec" do
    context "with single-gemspec project" do
      subject { rubygems_project }

      it "should match the directory name to the gemspec" do
        subject.primary_gemspec.should == subject.name
      end
    end

    context "with multi-gemspec project" do
      subject { rubygems_multi_project }

      it "should pick the first gemspec" do
        subject.primary_gemspec.should == 'rubygems-project'
      end
    end
  end

  describe "#gemspec" do
    context "with single-gemspec project" do
      subject { rubygems_project }

      it "should default the directory name to the gemspec" do
        subject.gemspec.name.should == subject.name
      end

      it "should return nil for unknown gemspec names" do
        subject.gemspec('foo').should be_nil
      end
    end

    context "with multi-gemspec project" do
      subject { rubygems_multi_project }

      it "should default the first gemspec" do
        subject.gemspec.name.should == 'rubygems-project'
      end

      it "should allow accessing alternate gemspecs" do
        alternate = 'rubygems-project-lite'

        subject.gemspec(alternate).name.should == alternate
      end
    end
  end

  describe "#builds" do
    subject { rubygems_multi_project }

    it "should group builds by gemspec name" do
      subject.builds.keys.should == subject.gemspecs.keys
    end

    it "should map a package format to a pkg/ path" do
      packages = subject.builds['rubygems-project']

      packages['tar.gz'].should == 'pkg/rubygems-project-1.2.3.tar.gz'
    end

    context "with single-gemspec project" do
      subject { rubygems_project }

      it "should only have a key for the single-gemspec" do
        subject.builds.keys.should == %w[rubygems-project]
      end
    end

    context "with multi-gemspec project" do
      subject { rubygems_multi_project }

      it "should have keys for each gemspec" do
        subject.builds.keys.should =~ %w[
          rubygems-project
          rubygems-project-lite
        ]
      end
    end
  end

  describe "#bundler?" do
    context "with Bundler" do
      subject { bundler_project }

      it "should detect the 'Gemfile' file" do
        subject.bundler?.should be_true
      end
    end

    context "without Bundler" do
      subject { rubygems_project }

      it "should be false" do
        subject.bundler?.should be_false
      end
    end
  end
end
