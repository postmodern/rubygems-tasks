require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/console'

describe Gem::Tasks::Console do
  describe "#console" do
    include_context "rake"

    let(:command)         { 'ripl'                        }
    let(:default_options) { %w[-Ilib -rrubygems/tasks.rb] }
    let(:custom_options)  { %w[-Ivendor -rfoo]            }

    context "defaults" do
      it "should run `irb`" do
        subject.should_receive(:run).with('irb',*default_options)

        subject.console
      end

      context "when project.bundler? == true" do
        it "should use `bundle console`" do
          subject.project.stub!(:bundler?).and_return(true)
          subject.should_receive(:run).with('bundle', 'console')

          subject.console
        end
      end
    end

    context "with custom command" do
      subject { described_class.new(:command => command) }

      it "should run the custom console" do
        subject.should_receive(:run).with(command,*default_options)

        subject.console
      end

      context "when project.bundler? == true" do
        it "should use `bundle exec`" do
          subject.project.stub!(:bundler?).and_return(true)
          subject.should_receive(:run).with('bundle', 'exec', command, *default_options)

          subject.console
        end
      end
    end

    context "with custom options" do
      subject { described_class.new(:options => custom_options) }

      it "should pass custom options to `irb`" do
        subject.should_receive(:run).with('irb', *(default_options + custom_options))

        subject.console
      end

      context "when project.bundler? == true" do
        it "should use `bundle exec ...`" do
          subject.project.stub!(:bundler?).and_return(true)
          subject.should_receive(:run).with('bundle', 'exec', 'irb', *(default_options + custom_options))

          subject.console
        end
      end
    end
  end
end
