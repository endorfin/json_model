# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_model/version'

Gem::Specification.new do |spec|
  spec.name          = "json_model"
  spec.version       = JsonModel::VERSION
  spec.authors       = ["René Kersten"]
  spec.email         = ["rene.kersten@gmail.com"]

  spec.summary       = %q{persist your model data to a .json file}
  spec.homepage      = "https://github.com/endorfin/json_model"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.0.10"
  spec.add_development_dependency "coveralls"
end
