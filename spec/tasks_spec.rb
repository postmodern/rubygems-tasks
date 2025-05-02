require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks'

describe Gem::Tasks do
  include_context "rake"

  describe "#initialize" do
    context "when given no keyword arguments" do
      describe '#build' do
        subject { super().build }

        it { is_expected.to be_a(Gem::Tasks::Build) }
      end

      describe '#scm' do
        subject { super().scm }

        it { is_expected.to be_a(Gem::Tasks::SCM) }
      end

      describe '#sign' do
        subject { super().sign }

        it { is_expected.to be_a(Gem::Tasks::Sign) }
      end

      describe '#console' do
        subject { super().console }

        it { is_expected.to be_kind_of(Gem::Tasks::Console) }
      end

      describe '#install' do
        subject { super().install }

        it { is_expected.to be_kind_of(Gem::Tasks::Install) }
      end

      describe '#push' do
        subject { super().push }

        it { is_expected.to be_kind_of(Gem::Tasks::Push)    }
      end

      describe '#release' do
        subject { super().release }

        it { is_expected.to be_kind_of(Gem::Tasks::Release) }
      end
    end

    context "when given `console: false`" do
      subject { described_class.new(console: false) }

      describe '#console' do
        subject { super().console }

        it { is_expected.to be_nil }
      end
    end

    context "when given `install: false`" do
      subject { described_class.new(install: false) }

      describe '#install' do
        subject { super().install }

        it { is_expected.to be_nil }
      end
    end

    context "when given `push: false`" do
      subject { described_class.new(push: false) }

      describe '#push' do
        subject { super().push }

        it { is_expected.to be_nil }
      end
    end

    context "when given `release: false`" do
      subject { described_class.new(release: false) }

      describe '#release' do
        subject { super().release }

        it { is_expected.to be_nil }
      end
    end
  end
end
