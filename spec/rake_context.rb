require 'rake'

shared_context "rake" do
  before(:all) do
    Rake.verbose(false)
    Rake.application = Rake::Application.new
  end
end
