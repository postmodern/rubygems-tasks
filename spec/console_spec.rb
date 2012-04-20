require 'spec_helper'
require 'rake_context'

require 'rubygems/tasks/console'

describe Gem::Tasks::Console do
  describe "#arguments" do
    let(:command) { 'ripl'             }
    let(:options) { %w[-Ivendor -rfoo] }

    context "defaults" do
      include_context "rake"

      it "should run irb" do
        subject.arguments.first.should == 'irb'
      end

      it "should include -I options" do
        subject.arguments.should include('-Ilib')
      end

      context "when project.bundler? == true" do
        it "should use `bundle console`" do
          subject.project.stub!(:bundler?).and_return(true)

          subject.arguments.should == %w[bundle console]
        end
      end
    end

    context "with custom command" do
      include_context "rake"

      subject { described_class.new(:command => command) }

      it "should run the custom console" do
        subject.arguments.first.should == command
      end

      it "should still include -I options" do
        subject.arguments.should include('-Ilib')
      end

      context "when project.bundler? == true" do
        it "should use `bundle exec`" do
          subject.project.stub!(:bundler?).and_return(true)

          subject.arguments[0,2].should == %w[bundle exec]
        end
      end
    end

    context "with custom options" do
      include_context "rake"

      subject { described_class.new(:options => options) }

      it "should include the custom options" do
        subject.arguments.should include(*options)
      end

      it "should still include -I options" do
        subject.arguments.should include('-Ilib')
      end

      context "when project.bundler? == true" do
        it "should use `bundle exec ...`" do
          subject.project.stub!(:bundler?).and_return(true)

          subject.arguments[0,2].should == %w[bundle exec]
        end
      end
    end
  end
end
