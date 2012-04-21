require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/scm/push'

describe Gem::Tasks::SCM::Push do
  describe "#push!" do
    context "git" do
      it "should run `git push --tags`" do
        subject.project.stub!(:scm).and_return(:git)
        subject.should_receive(:run).with('git', 'push', '--tags')

        subject.push!
      end
    end

    context "hg" do
      it "should run `hg push`" do
        subject.project.stub!(:scm).and_return(:hg)
        subject.should_receive(:run).with('hg', 'push')

        subject.push!
      end
    end

    context "otherwise" do
      it "should return true" do
        subject.project.stub!(:scm).and_return(:svn)

        subject.push!.should == true
      end
    end
  end
end
