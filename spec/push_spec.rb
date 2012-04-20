require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/push'

describe Gem::Tasks::Push do
  describe "#arguments" do
    let(:path) { 'pkg/foo-1.2.3.gem' }

    context "defaults" do
      include_context "rake"

      it "should use `gem push`" do
        subject.arguments(path)[0,2].should == %w[gem push]
      end
    end

    context "with custom :host" do
      include_context "rake"

      let(:host) { 'internal.company.com' }

      subject { described_class.new(:host => host) }

      it "should include the --host option" do
        subject.arguments(path).should include('--host', host)
      end
    end
  end
end
