# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pravigo/duration/version'

Gem::Specification.new do |spec|
  spec.name          = "pravigo-duration"
  spec.version       = Pravigo::Duration::VERSION
  spec.authors       = ["Rich Hall"]
  spec.email         = ["rich@pravigo.org"]
  spec.summary       = %q{manipulate iso8601 durations}
  spec.description   = %q{Pravigo::Duration extends ActiveSupport::Duration class to add iso8601 support}
  spec.homepage      = "http://richhall.github.com/pravigo-duration"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "active_support/time"

end

