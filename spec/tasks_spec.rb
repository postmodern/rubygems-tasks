require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks'

describe Gem::Tasks do
  describe "#initialize" do
    context "default options" do
      include_context "rake"

      describe '#build' do
        subject { super().build }
        it { is_expected.to be_kind_of(OpenStruct)             }
      end

      describe '#build' do
        subject { super().build }
        describe '#gem' do
          subject { super().gem }
          it { is_expected.to be_kind_of(Gem::Tasks::Build::Gem) }
        end
      end

      describe '#build' do
        subject { super().build }
        describe '#tar' do
          subject { super().tar }
          it { is_expected.to be_nil                             }
        end
      end

      describe '#build' do
        subject { super().build }
        describe '#zip' do
          subject { super().zip }
          it { is_expected.to be_nil                             }
        end
      end

      describe '#scm' do
        subject { super().scm }
        it { is_expected.to be_kind_of(OpenStruct)              }
      end

      describe '#scm' do
        subject { super().scm }
        describe '#status' do
          subject { super().status }
          it { is_expected.to be_kind_of(Gem::Tasks::SCM::Status) }
        end
      end

      describe '#scm' do
        subject { super().scm }
        describe '#push' do
          subject { super().push }
          it { is_expected.to be_kind_of(Gem::Tasks::SCM::Push)   }
        end
      end

      describe '#scm' do
        subject { super().scm }
        describe '#tag' do
          subject { super().tag }
          it { is_expected.to be_kind_of(Gem::Tasks::SCM::Tag)    }
        end
      end

      describe '#sign' do
        subject { super().sign }
        it { is_expected.to be_kind_of(OpenStruct) }
      end

      describe '#sign' do
        subject { super().sign }
        describe '#checksum' do
          subject { super().checksum }
          it { is_expected.to be_nil                 }
        end
      end

      describe '#sign' do
        subject { super().sign }
        describe '#pgp' do
          subject { super().pgp }
          it { is_expected.to be_nil                 }
        end
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

    context "build: {gem: false}" do
      include_context "rake"

      subject { described_class.new(build: {gem: false}) }

      describe '#build' do
        subject { super().build }
        describe '#gem' do
          subject { super().gem }
          it { is_expected.to be_nil }
        end
      end
    end

    context "build: {tar: true}" do
      include_context "rake"

      subject { described_class.new(build: {tar: true}) }

      describe '#build' do
        subject { super().build }
        describe '#tar' do
          subject { super().tar }
          it { is_expected.to be_kind_of(Gem::Tasks::Build::Tar) }
        end
      end
    end

    context "build: {zip: true}" do
      include_context "rake"

      subject { described_class.new(build: {zip: true}) }

      describe '#build' do
        subject { super().build }
        describe '#zip' do
          subject { super().zip }
          it { is_expected.to be_kind_of(Gem::Tasks::Build::Zip) }
        end
      end
    end

    context "scm: {status: false}" do
      include_context "rake"

      subject { described_class.new(scm: {status: false}) }

      describe '#scm' do
        subject { super().scm }
        describe '#status' do
          subject { super().status }
          it { is_expected.to be_nil }
        end
      end
    end

    context "scm: {push: false}" do
      include_context "rake"

      subject { described_class.new(scm: {push: false}) }

      describe '#scm' do
        subject { super().scm }
        describe '#push' do
          subject { super().push }
          it { is_expected.to be_nil }
        end
      end
    end

    context "scm: {tag: false}" do
      include_context "rake"

      subject { described_class.new(scm: {tag: false}) }

      describe '#scm' do
        subject { super().scm }
        describe '#tag' do
          subject { super().tag }
          it { is_expected.to be_nil }
        end
      end
    end

    context "sign: {checksum: true}" do
      include_context "rake"

      subject { described_class.new(sign: {checksum: true}) }

      describe '#sign' do
        subject { super().sign }
        describe '#checksum' do
          subject { super().checksum }
          it { is_expected.to be_kind_of(Gem::Tasks::Sign::Checksum) }
        end
      end
    end

    context "sign: {pgp: true}" do
      include_context "rake"

      subject { described_class.new(sign: {pgp: true}) }

      describe '#sign' do
        subject { super().sign }
        describe '#pgp' do
          subject { super().pgp }
          it { is_expected.to be_kind_of(Gem::Tasks::Sign::PGP) }
        end
      end
    end

    context "console: false" do
      include_context "rake"

      subject { described_class.new(console: false) }

      describe '#console' do
        subject { super().console }
        it { is_expected.to be_nil }
      end
    end

    context "install: false" do
      include_context "rake"

      subject { described_class.new(install: false) }

      describe '#install' do
        subject { super().install }
        it { is_expected.to be_nil }
      end
    end

    context "push: false" do
      include_context "rake"

      subject { described_class.new(push: false) }

      describe '#push' do
        subject { super().push }
        it { is_expected.to be_nil }
      end
    end

    context "release: false" do
      include_context "rake"

      subject { described_class.new(release: false) }

      describe '#release' do
        subject { super().release }
        it { is_expected.to be_nil }
      end
    end
  end
end
