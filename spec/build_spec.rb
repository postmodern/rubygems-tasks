require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/build'

describe Gem::Tasks::Build do
  include_context "rake"

  describe "#initialize" do
    context "when given no keyword arguments" do
      it "must initialize #gem by default" do
        expect(subject.gem).to be_a(Gem::Tasks::Build::Gem)
      end

      it "must not initialize #tar by default" do
        expect(subject.tar).to be(nil)
      end

      it "must not initialize #zip by default" do
        expect(subject.zip).to be(nil)
      end
    end

    context "when given `gem: true`" do
      subject { described_class.new(gem: true) }

      it "must initialize #gem" do
        expect(subject.gem).to be_a(Gem::Tasks::Build::Gem)
      end
    end

    context "when given `gem: false`" do
      subject { described_class.new(gem: false) }

      it "must not initialize #gem" do
        expect(subject.gem).to be(nil)
      end
    end

    context "when given `tar: true`" do
      subject { described_class.new(tar: true) }

      it "must initialize #tar" do
        expect(subject.tar).to be_a(Gem::Tasks::Build::Tar)
      end
    end

    context "when given `tar: false`" do
      subject { described_class.new(tar: false) }

      it "must not initialize #tar" do
        expect(subject.tar).to be(nil)
      end
    end

    context "when given `zip: true`" do
      subject { described_class.new(zip: true) }

      it "must initialize #zip" do
        expect(subject.zip).to be_a(Gem::Tasks::Build::Zip)
      end
    end

    context "when given `zip: false`" do
      subject { described_class.new(zip: false) }

      it "must not initialize #zip" do
        expect(subject.zip).to be(nil)
      end
    end
  end
end
