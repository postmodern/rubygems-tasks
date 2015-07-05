require 'spec_helper'
require 'rubygems/tasks/project'

describe Gem::Tasks::Project do
  let(:rubygems_project_dir) { File.join(PROJECTS_DIR,'rubygems-project') }
  let(:rubygems_project)     { described_class.new(rubygems_project_dir)   }

  let(:rubygems_multi_project_dir) do
    File.join(PROJECTS_DIR,'rubygems-multi-project')
  end

  let(:rubygems_multi_project) do
    described_class.new(rubygems_multi_project_dir)
  end

  let(:bundler_project_dir) { File.join(PROJECTS_DIR,'bundler-project') }
  let(:bundler_project)     { described_class.new(bundler_project_dir)   }

  describe "directories" do
    let(:directory) { rubygems_project_dir }

    it "should map paths to #{described_class} instances" do
      project = described_class.directories[directory]

      expect(project.root).to eq(directory)
    end
  end

  describe "#name" do
    subject { rubygems_project }

    it "should use the name of the directory" do
      expect(subject.name).to eq('rubygems-project')
    end
  end

  describe "#scm" do
    subject { bundler_project }

    it "should detect the SCM used" do
      expect(subject.scm).to eq(:git)
    end
  end

  describe "#gemspecs" do
    context "with single-gemspec project" do
      subject { rubygems_project }

      it "should load the single-gemspec" do
        expect(subject.gemspecs.values.map(&:name)).to eq(%w[rubygems-project])
      end
    end

    context "with multi-gemspec project" do
      subject { rubygems_multi_project }

      it "should load all gemspecs" do
        expect(subject.gemspecs.values.map(&:name)).to match_array(%w[
          rubygems-project
          rubygems-project-lite
        ])
      end
    end
  end

  describe "#primary_gemspec" do
    context "with single-gemspec project" do
      subject { rubygems_project }

      it "should match the directory name to the gemspec" do
        expect(subject.primary_gemspec).to eq(subject.name)
      end
    end

    context "with multi-gemspec project" do
      subject { rubygems_multi_project }

      it "should pick the first gemspec" do
        expect(subject.primary_gemspec).to eq('rubygems-project')
      end
    end
  end

  describe "#gemspec" do
    context "with single-gemspec project" do
      subject { rubygems_project }

      it "should default the directory name to the gemspec" do
        expect(subject.gemspec.name).to eq(subject.name)
      end

      it "should raise an ArgumentError for unknown gemspec names" do
        expect { subject.gemspec('foo') }.to raise_error(ArgumentError)
      end
    end

    context "with multi-gemspec project" do
      subject { rubygems_multi_project }

      it "should default the first gemspec" do
        expect(subject.gemspec.name).to eq('rubygems-project')
      end

      it "should allow accessing alternate gemspecs" do
        alternate = 'rubygems-project-lite'

        expect(subject.gemspec(alternate).name).to eq(alternate)
      end
    end
  end

  describe "#builds" do
    subject { rubygems_multi_project }

    it "should group builds by gemspec name" do
      expect(subject.builds.keys).to be == subject.gemspecs.keys
    end

    it "should map a package format to a pkg/ path" do
      packages = subject.builds['rubygems-project']

      expect(packages['tar.gz']).to eq('pkg/rubygems-project-1.2.3.tar.gz')
    end

    context "with single-gemspec project" do
      subject { rubygems_project }

      it "should only have a key for the single-gemspec" do
        expect(subject.builds.keys).to eq(%w[rubygems-project])
      end
    end

    context "with multi-gemspec project" do
      subject { rubygems_multi_project }

      it "should have keys for each gemspec" do
        expect(subject.builds.keys).to match_array(%w[
          rubygems-project
          rubygems-project-lite
        ])
      end
    end
  end

  describe "#bundler?" do
    context "with Bundler" do
      subject { bundler_project }

      it "should detect the 'Gemfile' file" do
        expect(subject.bundler?).to be_truthy
      end
    end

    context "without Bundler" do
      subject { rubygems_project }

      it "should be false" do
        expect(subject.bundler?).to be_falsey
      end
    end
  end
end
