# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gv/common/version'

Gem::Specification.new do |spec|
  spec.name          = "gv-common"
  spec.version       = GV::Common::VERSION
  spec.authors       = ["Onur Uyar"]
  spec.email         = ["me@onuruyar.com"]
  spec.summary       = %q{GreenValley Shared Library}
  spec.homepage      = "https://github.com/green-valley/gv-common"
  spec.license       = "Unlicense"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_dependency "activesupport"
  spec.add_dependency "sticks-pipe"  
  spec.add_dependency "commander"
end
