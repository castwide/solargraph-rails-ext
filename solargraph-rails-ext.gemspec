# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'solargraph-rails-ext/version'

Gem::Specification.new do |spec|
  spec.name          = "solargraph-rails-ext"
  spec.version       = SolargraphRailsExt::VERSION
  spec.authors       = ["Fred Snyder"]
  spec.email         = ["fsnyder@castwide.com"]

  spec.summary       = %q{Solargraph for Rails}
  spec.description   = %q{An extension to add the Rails runtime environment to Solargraph.}
  spec.homepage      = "http://solargraph.org"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*']
  spec.require_paths = ["lib"]
  spec.executables   = ['solargraph-rails-ext']
  spec.add_dependency 'solargraph', '~> 0.14.0'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.2.1"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'simplecov', '~> 0.14'
end
