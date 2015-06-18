require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/install'

describe Gem::Tasks::Install do
  describe "#install" do
    let(:path) { 'pkg/foo-1.2.3.gem' }

    it "should use `gem install -q`" do
      expect(subject).to receive(:run).with('gem', 'install', '-q', path)

      subject.install(path)
    end
  end
end
