require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/scm/tag'

describe Gem::Tasks::SCM::Tag do
  let(:version) { '1.2.3' }

  describe "#version_tag" do
    context "defaults" do
      include_context "rake"

      it "should have a 'v' prefix" do
        expect(subject.version_tag(version)).to eq("v#{version}")
      end
    end

    context "with format String" do
      include_context "rake"

      let(:format) { 'release-%s' }

      subject { described_class.new(format: format) }

      it "should apply the format String to the version" do
        expect(subject.version_tag(version)).to eq("release-#{version}")
      end
    end

    context "with format Proc" do
      let(:format) { proc { |ver| "REL_" + ver.tr('.','_') } }

      subject { described_class.new(format: format) }

      it "should call the format Proc with the version" do
        expect(subject.version_tag(version)).to eq("REL_1_2_3")
      end
    end
  end

  describe "#tag!" do
    let(:name)    { "v#{version}"        }
    let(:message) { "Tagging #{name}"    }

    context "git" do
      context "without signing" do
        include_context "rake"

        subject { described_class.new(sign: false) }

        it "should run `git tag`" do
          allow(subject.project).to receive(:scm).and_return(:git)

          expect(subject).to receive(:run).with(
            'git', 'tag', '-m', message, name
          )

          subject.tag!(name)
        end
      end

      context "signing" do
        include_context "rake"

        subject { described_class.new(sign: true) }

        it "should run `git tag -s`" do
          allow(subject.project).to receive(:scm).and_return(:git)

          expect(subject).to receive(:run).with(
            'git', 'tag', '-m', message, '-s', name
          )

          subject.tag!(name)
        end
      end
    end

    context "hg" do
      context "without signing" do
        include_context "rake"

        subject { described_class.new(sign: false) }

        it "should run `hg tag`" do
          allow(subject.project).to receive(:scm).and_return(:hg)

          expect(subject).to receive(:run).with(
            'hg', 'tag', '-m', message, name
          )

          subject.tag!(name)
        end
      end

      context "with signing" do
        include_context "rake"

        subject { described_class.new(sign: true) }

        it "should run `hg sign` then `hg tag`" do
          allow(subject.project).to receive(:scm).and_return(:hg)

          expect(subject).to receive(:run).with(
            'hg', 'sign', '-m', "Signing #{name}"
          )
          expect(subject).to receive(:run).with(
            'hg', 'tag', '-m', message, name
          )

          subject.tag!(name)
        end
      end
    end
  end
end
