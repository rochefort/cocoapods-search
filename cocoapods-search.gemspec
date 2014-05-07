# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods/search/version'

Gem::Specification.new do |spec|
  spec.name          = "cocoapods-search"
  spec.version       = Cocoapods::Search::VERSION
  spec.authors       = ["rochefort"]
  spec.email         = ["terasawan@gmail.com"]
  spec.summary       = "search cocopods while sorting by github score"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/rochefort/cocoapods-search"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'mechanize', '~> 2.7.3'
  spec.add_dependency 'thor',      '~> 0.18.1'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec',       '~> 2.14.1'
  spec.add_development_dependency 'guard',       '~> 2.6.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.2.8'
  spec.add_development_dependency 'webmock',     '~> 1.17.4'

end
