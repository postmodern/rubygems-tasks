require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/scm/status'

describe Gem::Tasks::SCM::Status do
  describe "#status" do
    context "git" do
      include_context "rake"

      it "should run `git status --untracked-files=no`" do
        allow(subject.project).to receive(:scm).and_return(:git)

        expect(subject).to receive(:run).with(
          'git', 'status', '--untracked-files=no'
        )

        subject.status
      end
    end

    context "hg" do
      include_context "rake"

      it "should run `hg status --quiet`" do
        allow(subject.project).to receive(:scm).and_return(:hg)

        expect(subject).to receive(:run).with(
          'hg', 'status', '--quiet'
        )

        subject.status
      end
    end

    context "svn" do
      include_context "rake"

      it "should run `svn status --quiet`" do
        allow(subject.project).to receive(:scm).and_return(:svn)

        expect(subject).to receive(:run).with(
          'svn', 'status', '--quiet'
        )

        subject.status
      end
    end
  end
end
