require 'rake'

shared_context "rake" do
  let(:rake)   { Rake::Application.new   }

  before(:all) do
    Rake.verbose(false)
    Rake.application = rake
  end
end
