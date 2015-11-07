# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dvd_ripper/version'

Gem::Specification.new do |spec|
  spec.name          = "dvd_ripper"
  spec.version       = DvdRipper::VERSION
  spec.authors       = ["matthew-nichols"]
  spec.email         = ["matt@nichols.link"]

  spec.summary       = %q{Quickly rip and tag DVDs}
  spec.description   = %q{A command-line utility that makes it easy to rip and tag DVDs. Just install and run the utility. Then insert a DVD and follow prompts. Repeat.}
  spec.homepage      = "https://github.com/mattnichols/dvd_ripper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = ["dvd_ripper"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'thor', '~> 0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6.0'
  spec.add_runtime_dependency 'themoviedb', '~> 0.0.20'
  spec.add_runtime_dependency 'imdb', '~> 0.8.1'
  spec.add_runtime_dependency 'rb-fsevent', '~> 0.9.4'
  spec.add_runtime_dependency 'levenshtein', '~> 0.2.2'
  spec.add_runtime_dependency 'atomic-parsley-ruby', '~> 0.0.5' #, :git => 'https://github.com/cparratto/atomic-parsley-ruby.git'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
