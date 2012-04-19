require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/tasks'

describe Gem::Tasks do
  describe "#initialize" do
    context "default options" do
      include_context "rake"

      its(:build)      { should be_kind_of(OpenStruct)             }
      its('build.gem') { should be_kind_of(Gem::Tasks::Build::Gem) }
      its('build.tar') { should be_nil                             }
      its('build.zip') { should be_nil                             }

      its(:scm)         { should be_kind_of(OpenStruct)              }
      its('scm.status') { should be_kind_of(Gem::Tasks::SCM::Status) }
      its('scm.push')   { should be_kind_of(Gem::Tasks::SCM::Push)   }
      its('scm.tag')    { should be_kind_of(Gem::Tasks::SCM::Tag)    }

      its(:sign)           { should be_kind_of(OpenStruct) }
      its('sign.checksum') { should be_nil                 }
      its('sign.pgp')      { should be_nil                 }

      its(:console) { should be_kind_of(Gem::Tasks::Console) }
      its(:install) { should be_kind_of(Gem::Tasks::Install) }
      its(:push)    { should be_kind_of(Gem::Tasks::Push)    }
      its(:release) { should be_kind_of(Gem::Tasks::Release) }
    end

    context ":build => {:gem => false}" do
      include_context "rake"

      subject { described_class.new(:build => {:gem => false}) }

      its('build.gem') { should be_nil }
    end

    context ":build => {:tar => true}" do
      include_context "rake"

      subject { described_class.new(:build => {:tar => true}) }

      its('build.tar') { should be_kind_of(Gem::Tasks::Build::Tar) }
    end

    context ":build => {:zip => true}" do
      include_context "rake"

      subject { described_class.new(:build => {:zip => true}) }

      its('build.zip') { should be_kind_of(Gem::Tasks::Build::Zip) }
    end

    context ":scm => {:status => false}" do
      include_context "rake"

      subject { described_class.new(:scm => {:status => false}) }

      its('scm.status') { should be_nil }
    end

    context ":scm => {:push => false}" do
      include_context "rake"

      subject { described_class.new(:scm => {:push => false}) }

      its('scm.push') { should be_nil }
    end

    context ":scm => {:tag => false}" do
      include_context "rake"

      subject { described_class.new(:scm => {:tag => false}) }

      its('scm.tag') { should be_nil }
    end

    context ":sign => {:checksum => true}" do
      include_context "rake"

      subject { described_class.new(:sign => {:checksum => true}) }

      its('sign.checksum') { should be_kind_of(Gem::Tasks::Sign::Checksum) }
    end

    context ":sign => {:pgp => true}" do
      include_context "rake"

      subject { described_class.new(:sign => {:pgp => true}) }

      its('sign.pgp') { should be_kind_of(Gem::Tasks::Sign::PGP) }
    end

    context ":console => false" do
      include_context "rake"

      subject { described_class.new(:console => false) }

      its(:console) { should be_nil }
    end

    context ":install => false" do
      include_context "rake"

      subject { described_class.new(:install => false) }

      its(:install) { should be_nil }
    end

    context ":push => false" do
      include_context "rake"

      subject { described_class.new(:push => false) }

      its(:push) { should be_nil }
    end

    context ":release => false" do
      include_context "rake"

      subject { described_class.new(:release => false) }

      its(:release) { should be_nil }
    end
  end
end
