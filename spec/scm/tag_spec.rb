require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/scm/tag'

describe Gem::Tasks::SCM::Tag do
  let(:version) { '1.2.3' }

  describe "#version_tag" do
    context "default" do
      include_context "rake"

      it "should not have a prefix or suffix" do
        subject.version_tag(version).should == version
      end
    end

    context "with format String" do
      include_context "rake"

      let(:format) { 'v%s' }

      subject { described_class.new(:format => format) }

      it "should apply the format String to the version" do
        subject.version_tag(version).should == "v#{version}"
      end
    end

    context "with format Proc" do
      include_context "rake"

      let(:format) { proc { |ver| "REL_" + ver.tr('.','_') } }

      subject { described_class.new(:format => format) }

      it "should call the format Proc with the version" do
        subject.version_tag(version).should == "REL_1_2_3"
      end
    end
  end
end
