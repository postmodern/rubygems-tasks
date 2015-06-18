require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/sign/pgp'

describe Gem::Tasks::Sign::PGP do
  describe "#sign" do
    include_context "rake"

    let(:path) { File.join('pkg','foo-1.2.3.gem') }

    it "should run `gpg --sign --detach-sign --armor ...`" do
      expect(subject).to receive(:run).with(
        'gpg', '--sign', '--detach-sign', '--armor', path
      )

      subject.sign(path)
    end
  end
end
