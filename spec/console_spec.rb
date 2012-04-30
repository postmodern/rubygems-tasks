require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/console'

describe Gem::Tasks::Console do
  describe "#console" do
    include_context "rake"

    if RUBY_VERSION < '1.9'
      let(:default_options) { %w[-Ilib -rrubygems -rrubygems/tasks] }
    else
      let(:default_options) { %w[-Ilib -rrubygems/tasks.rb]            }
    end

    let(:custom_command)  { 'ripl'             }
    let(:custom_options)  { %w[-Ivendor -rfoo] }

    context "defaults" do
      it "should run `irb`" do
        subject.should_receive(:run).with('irb',*default_options)

        subject.console
      end

      context "when project.bundler? == true" do
        it "should use `bundle exec`" do
          subject.project.stub!(:bundler?).and_return(true)
          subject.should_receive(:run).with(
            'bundle', 'exec', 'irb', *default_options
          )

          subject.console
        end
      end
    end

    context "with custom command" do
      subject { described_class.new(:command => custom_command) }

      it "should run the custom console" do
        subject.should_receive(:run).with(custom_command,*default_options)

        subject.console
      end

      context "when project.bundler? == true" do
        it "should use `bundle exec`" do
          subject.project.stub!(:bundler?).and_return(true)
          subject.should_receive(:run).with(
            'bundle', 'exec', custom_command, *default_options
          )

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
