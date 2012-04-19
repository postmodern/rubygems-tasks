require 'rake'

shared_context "rake" do
  let(:rake)   { Rake::Application.new   }
  before(:all) { Rake.application = rake }
end
