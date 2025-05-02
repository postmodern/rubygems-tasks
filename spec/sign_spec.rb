require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/sign'

describe Gem::Tasks::Sign do
  include_context "rake"

  describe "#initialize" do
    context "when given no keyword arguments" do
      it "must not initialize #checksum by default" do
        expect(subject.checksum).to be(nil)
      end

      it "must not initialize #pgp by default" do
        expect(subject.pgp).to be(nil)
      end
    end

    context "when given `checksum: true`" do
      subject { described_class.new(checksum: true) }

      it "must initialize #checksum" do
        expect(subject.checksum).to be_a(Gem::Tasks::Sign::Checksum)
      end
    end

    context "when given `checksum: false`" do
      subject { described_class.new(checksum: false) }

      it "must not initialize #checksum" do
        expect(subject.checksum).to be(nil)
      end
    end

    context "when given `pgp: true`" do
      subject { described_class.new(pgp: true) }

      it "must initialize #pgp" do
        expect(subject.pgp).to be_a(Gem::Tasks::Sign::PGP)
      end
    end

    context "when given `pgp: false`" do
      subject { described_class.new(pgp: false) }

      it "must not initialize #pgp" do
        expect(subject.pgp).to be(nil)
      end
    end
  end
end
