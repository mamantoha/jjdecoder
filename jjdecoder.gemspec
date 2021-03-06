# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jjdecoder/version'

Gem::Specification.new do |spec|
  spec.name          = "jjdecoder"
  spec.version       = JJDecoder::VERSION
  spec.authors       = ["Anton Maminov"]
  spec.email         = ["anton.linux@gmail.com"]

  spec.summary       = %q{Ruby decoder for jjencode.}
  spec.description   = %q{Ruby version of the jjdecode function for JJEncoded string.}
  spec.homepage      = "https://github.com/mamantoha/jjdecoder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
