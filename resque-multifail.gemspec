# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque/multifail/version'

Gem::Specification.new do |spec|
  spec.name          = 'resque-multifail'
  spec.version       = Resque::Multifail::VERSION
  spec.authors       = ['Hayden Ball']
  spec.email         = ['hayden@sparkseat.com']

  spec.summary       = 'Allow Resque jobs to fail occasionally'
  spec.homepage      = 'https://github.com/sparkseat/resque-multifail'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'resque'
end
