gem 'rspec', '~> 2.4'
require 'rspec'

RSpec.configure do |spec|
  spec.before(:suite) do
    # clear the $RUBYCONSOLE env variable
    ENV['RUBYCONSOLE'] = nil
  end
end
