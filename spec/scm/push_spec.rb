require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/scm/push'

describe Gem::Tasks::SCM::Push do
  describe "#push!" do
    context "when the project's SCM type is :git" do
      it "should run `git push --tags`" do
        allow(subject.project).to receive(:scm).and_return(:git)
        expect(subject).to receive(:run).with('git', 'push')
        expect(subject).to receive(:run).with('git', 'push', '--tags')

        subject.push!
      end
    end

    context "when the project's SCM type is :hg" do
      it "should run `hg push`" do
        allow(subject.project).to receive(:scm).and_return(:hg)
        expect(subject).to receive(:run).with('hg', 'push')

        subject.push!
      end
    end

    context "when the project's SCM type is :svn" do
      it "should return true" do
        allow(subject.project).to receive(:scm).and_return(:svn)

        expect(subject.push!).to eq(true)
      end
    end
  end
end
