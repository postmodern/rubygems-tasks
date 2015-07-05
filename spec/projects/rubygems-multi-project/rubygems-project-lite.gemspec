# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubygems/project/version'

Gem::Specification.new do |gem|
  gem.name          = "rubygems-project-lite"
  gem.version       = Rubygems::Project::VERSION
  gem.authors       = ["Postmodern"]
  gem.email         = ["postmodern.mod3@gmail.com"]
  gem.description   = %q{An example of a RubyGems project (lite edition)}
  gem.summary       = %q{Example RubyGems project}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = []
  gem.test_files    = []
  gem.require_paths = ["lib"]
end
