require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/console'

describe Gem::Tasks::Console do
  describe "#console" do
    include_context "rake"

    let(:default_options) { %w[-Ilib -rrubygems/tasks] }

    let(:custom_command)  { 'ripl'             }
    let(:custom_options)  { %w[-Ivendor -rfoo] }

    context "defaults" do
      context "when project.bundler? == false" do
        before do
          allow(subject.project).to receive(:bundler?).and_return(false)
        end

        it "should run `irb`" do
          expect(subject).to receive(:run).with('irb',*default_options)

          subject.console
        end
      end

      context "when project.bundler? == true" do
        before do
          allow(subject.project).to receive(:bundler?).and_return(true)
        end

        it "should use `bundle exec`" do
          expect(subject).to receive(:run).with(
            'bundle', 'exec', 'irb', *default_options
          )

          subject.console
        end
      end
    end

    context "with custom command" do
      subject { described_class.new(:command => custom_command) }

      context "when project.bundler? == false" do
        before do
          allow(subject.project).to receive(:bundler?).and_return(false)
        end

        it "should run the custom console" do
          expect(subject).to receive(:run).with(custom_command,*default_options)

          subject.console
        end
      end

      context "when project.bundler? == true" do
        before do
          allow(subject.project).to receive(:bundler?).and_return(true)
        end

        it "should use `bundle exec`" do
          expect(subject).to receive(:run).with(
            'bundle', 'exec', custom_command, *default_options
          )

          subject.console
        end
      end
    end

    context "with custom options" do
      subject { described_class.new(:options => custom_options) }

      context "when project.bundler? == false" do
        before do
          allow(subject.project).to receive(:bundler?).and_return(false)
        end

        it "should pass custom options to `irb`" do
          expect(subject).to receive(:run).with('irb', *(default_options + custom_options))

          subject.console
        end
      end

      context "when project.bundler? == true" do
        before do
          allow(subject.project).to receive(:bundler?).and_return(true)
        end

        it "should use `bundle exec ...`" do
          expect(subject).to receive(:run).with('bundle', 'exec', 'irb', *(default_options + custom_options))

          subject.console
        end
      end
    end
  end
end
