require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/scm'

describe Gem::Tasks::SCM do
  include_context "rake"

  describe "#initialize" do
    context "when given no keyword arguments" do
      it "must initialize #status by default" do
        expect(subject.status).to be_a(Gem::Tasks::SCM::Status)
      end

      it "must initialize #tag by default" do
        expect(subject.tag).to be_a(Gem::Tasks::SCM::Tag)
      end

      it "must initialize #push by default" do
        expect(subject.push).to be_a(Gem::Tasks::SCM::Push)
      end
    end

    context "when given `status: true`" do
      subject { described_class.new(status: true) }

      it "must initialize #status" do
        expect(subject.status).to be_a(Gem::Tasks::SCM::Status)
      end
    end

    context "when given `status: false`" do
      subject { described_class.new(status: false) }

      it "must not initialize #status" do
        expect(subject.status).to be(nil)
      end
    end

    context "when given `tag: true`" do
      subject { described_class.new(tag: true) }

      it "must initialize #tag" do
        expect(subject.tag).to be_a(Gem::Tasks::SCM::Tag)
      end
    end

    context "when given `tag: false`" do
      subject { described_class.new(tag: false) }

      it "must not initialize #tag" do
        expect(subject.tag).to be(nil)
      end
    end

    context "when given `push: true`" do
      subject { described_class.new(push: true) }

      it "must initialize #push" do
        expect(subject.push).to be_a(Gem::Tasks::SCM::Push)
      end
    end

    context "when given `push: false`" do
      subject { described_class.new(push: false) }

      it "must not initialize #push" do
        expect(subject.push).to be(nil)
      end
    end
  end
end
