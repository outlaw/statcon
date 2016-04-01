# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'statcon/version'

Gem::Specification.new do |spec|
  spec.name          = "statcon"
  spec.version       = Statcon::VERSION
  spec.authors       = ["Jacob Evans"]
  spec.email         = ["jacob@dekz.net"]

  spec.summary       = %q{Generate status pages for your github projects}
  spec.description   = %q{Generate status pages for your github projects}
  spec.homepage      = "http://github.com/outlaw/status"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://gems.in.jqdev.net"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'middleman'
  spec.add_dependency 'bourbon'
  spec.add_dependency 'neat'
  spec.add_dependency 'font-awesome-sass'
  spec.add_dependency 'octokit'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
