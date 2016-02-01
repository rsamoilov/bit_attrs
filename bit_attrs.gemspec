# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bit_attrs/version'

Gem::Specification.new do |spec|
  spec.name          = "bit_attrs"
  spec.version       = BitAttrs::VERSION
  spec.authors       = ["Roman Samoilov"]
  spec.email         = ["rsamoilov@yandex.ua"]

  spec.summary       = %q{Store a set of boolean values as a bitmask in one field. Works well with ActiveRecord, DataMapper, Virtus or POROs.}
  spec.homepage      = "https://github.com/rsamoilov/bit_attrs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha", "~> 1.1"
end
