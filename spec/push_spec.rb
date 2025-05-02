require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/push'

describe Gem::Tasks::Push do
  describe "#push" do
    include_context "rake"

    let(:path) { 'pkg/foo-1.2.3.gem' }

    context "defaults" do
      it "must use `gem push`" do
        expect(subject).to receive(:run).with('gem', 'push', path)

        subject.push(path)
      end
    end

    context "with custom :host" do
      let(:host) { 'internal.company.com' }

      subject { described_class.new(host: host) }

      it "must include the --host option" do
        expect(subject).to receive(:run).with('gem', 'push', path, '--host', host)

        subject.push(path)
      end
    end

    context "with custom :key" do
      let(:key) { '098f6bcd4621d373cade4e832627b4f6' }

      subject { described_class.new(key: key) }

      it "should include the --key option" do
        expect(subject).to receive(:run).with('gem', 'push', path, '--key', key)

        subject.push(path)
      end
    end
  end
end
