require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/scm/tag'

describe Gem::Tasks::SCM::Tag do
  let(:version) { '1.2.3' }

  describe "#version_tag" do
    context "defaults" do
      include_context "rake"

      it "should have a 'v' prefix" do
        subject.version_tag(version).should == "v#{version}"
      end
    end

    context "with format String" do
      include_context "rake"

      let(:format) { 'release-%s' }

      subject { described_class.new(:format => format) }

      it "should apply the format String to the version" do
        subject.version_tag(version).should == "release-#{version}"
      end
    end

    context "with format Proc" do
      let(:format) { proc { |ver| "REL_" + ver.tr('.','_') } }

      subject { described_class.new(:format => format) }

      it "should call the format Proc with the version" do
        subject.version_tag(version).should == "REL_1_2_3"
      end
    end
  end

  describe "#tag!" do
    let(:name)    { "v#{version}"        }
    let(:message) { "Tagging #{name}"    }

    context "git" do
      include_context "rake"

      it "should run `git tag`" do
        subject.project.stub!(:scm).and_return(:git)
        subject.should_receive(:run).with('git', 'tag', '-m', message, name)

        subject.tag!(name)
      end
    end

    context "hg" do
      include_context "rake"

      it "should run `hg tag`" do
        subject.project.stub!(:scm).and_return(:hg)
        subject.should_receive(:run).with('hg', 'tag', '-m', message, name)

        subject.tag!(name)
      end
    end
  end
end
