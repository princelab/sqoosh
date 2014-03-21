# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sqoosh/version'

Gem::Specification.new do |spec|
  spec.name          = "sqoosh"
  spec.version       = Sqoosh::VERSION
  spec.authors       = ["John T. Prince"]
  spec.email         = ["jtprince@gmail.com"]
  spec.summary       = %q{Simple Quantitation Of Omics Slightly Handy}
  spec.description   = %q{Simple scheme for label-free quantitative proteomics.  The aim is to do something simple that works okay.  No effort is made to be particularly fast, beautiful, or sophisticated.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  [
    ["mspire", "~> 0.10.7.1"],
    ["andand", "~> 1.3.3"],
    ["binneroc", "~> 0.0.2"],
  ].each do |args|
    spec.add_dependency(*args)
  end

  [
    ["bundler", "~> 1.5.3"],
    ["gnuplot"],
    ["rake"],
    ["rspec", "~> 2.14.1"], 
    ["rdoc", "~> 4.1.0"], 
    ["simplecov", "~> 0.8.2"],
  ].each do |args|
    spec.add_development_dependency(*args)
  end

end
