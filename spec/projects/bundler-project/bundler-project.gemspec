# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundler-project/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Postmodern"]
  gem.email         = ["postmodern.mod3@gmail.com"]
  gem.description   = %q{An example Ruby project using Bundler}
  gem.summary       = %q{Example Bundler project}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bundler-project"
  gem.require_paths = ["lib"]
  gem.version       = Bundler::Project::VERSION
end
