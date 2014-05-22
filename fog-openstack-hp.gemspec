# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require './lib/fog/openstackhp/version'

Gem::Specification.new do |spec|
  spec.name          = "fog-openstack-hp"
  spec.version       = Fog::OpenStackHp::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Mike Hagedorn"]
  spec.email         = ["mike@silverchairsolutions.com"]
  spec.summary       = %q{HP specific extensions to openstack}
  spec.description   = %q{Wrapper layer for HP secret sauce on top of OpenstackCommon.}
  spec.homepage      = ""
  spec.license       = "Apache2"

  spec.files         = Dir.glob(File.join("lib", "**", "*.rb"))
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency('fog-core')
  spec.add_dependency('fog-openstack-core')
  spec.add_dependency('fog-json')
  spec.add_dependency('faraday')
  spec.add_dependency('multi_json')
  spec.add_dependency('net-scp', '~>1.1')
  spec.add_dependency('net-ssh', '>=2.1.3')

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency('minitest')
  spec.add_development_dependency('vcr')
  spec.add_development_dependency('minitest-vcr')
  spec.add_development_dependency('webmock','<1.16')
  spec.add_development_dependency('minitest-reporters')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('guard-minitest')
end
