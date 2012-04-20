require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/install'

describe Gem::Tasks::Install do
  describe "#arguments" do
    let(:path) { 'pkg/foo-1.2.3.gem' }

    it "should use `gem install`" do
      subject.arguments(path)[0,2].should == %w[gem install]
    end

    it "should include -q" do
      subject.arguments(path).should include('-q')
    end

    it "should include the path" do
      subject.arguments(path).last.should == path
    end
  end
end
