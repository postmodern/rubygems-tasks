require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/scm/status'

describe Gem::Tasks::SCM::Status do
  include_context "rake"

  describe "#status" do
    context "when the project's SCM type is :git" do
      it "must run `git status --untracked-files=no`" do
        allow(subject.project).to receive(:scm).and_return(:git)

        expect(subject).to receive(:run).with(
          'git', 'status', '--untracked-files=no'
        )

        subject.status
      end
    end

    context "when the project's SCM type is :hg" do
      it "must run `hg status --quiet`" do
        allow(subject.project).to receive(:scm).and_return(:hg)

        expect(subject).to receive(:run).with(
          'hg', 'status', '--quiet'
        )

        subject.status
      end
    end

    context "when the project's SCM type is :svn" do
      it "must run `svn status --quiet`" do
        allow(subject.project).to receive(:scm).and_return(:svn)

        expect(subject).to receive(:run).with(
          'svn', 'status', '--quiet'
        )

        subject.status
      end
    end
  end
end
