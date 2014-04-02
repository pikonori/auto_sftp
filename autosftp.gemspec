# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autosftp/version'

Gem::Specification.new do |spec|
  spec.name          = "autosftp"
  spec.version       = Autosftp::VERSION
  spec.authors       = ["hirabaru"]
  spec.email         = ["hirabaru@n-create.co.jp"]
  spec.description   = %q{"sftp automatically"}
  spec.summary       = %q{"autosftp"}
  spec.homepage      = "https://github.com/pikonori/auto_sftp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "net-ssh", "2.6.7"
  spec.add_dependency "net-sftp", "2.1.2"
  spec.add_dependency "fssm", "0.2.10"
  spec.add_dependency "thor", "~> 0.19.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
