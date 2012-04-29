require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/scm/status'

describe Gem::Tasks::SCM::Status do
  describe "#status" do
    context "git" do
      include_context "rake"

      it "should run `git status --untracked-files=no`" do
        subject.project.stub!(:scm).and_return(:git)

        subject.should_receive(:run).with(
          'git', 'status', '--untracked-files=no'
        )

        subject.status
      end
    end

    context "hg" do
      include_context "rake"

      it "should run `hg status --quiet`" do
        subject.project.stub!(:scm).and_return(:hg)

        subject.should_receive(:run).with(
          'hg', 'status', '--quiet'
        )

        subject.status
      end
    end

    context "svn" do
      include_context "rake"

      it "should run `svn status --quiet`" do
        subject.project.stub!(:scm).and_return(:svn)

        subject.should_receive(:run).with(
          'svn', 'status', '--quiet'
        )

        subject.status
      end
    end
  end
end
