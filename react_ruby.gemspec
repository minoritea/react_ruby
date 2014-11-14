# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'react_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "react_ruby"
  spec.version       = ReactRuby::VERSION
  spec.authors       = ["minoritea"]
  spec.email         = ["minorityland@gmail.com"]
  spec.summary       = %q{ A React(react.js) template engine for ruby }
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/minoritea/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~> 3.0"

  spec.add_runtime_dependency 'execjs', '~> 2.0'
end
