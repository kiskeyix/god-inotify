# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'god/inotify/version'

Gem::Specification.new do |spec|
  spec.name          = "god-inotify"
  spec.version       = God::Inotify::VERSION
  spec.authors       = ["Luis Mondesi"]
  spec.email         = ["lemsx1@gmail.com"]

  spec.summary       = %q{System for quickly adding watches to god.}
  spec.description   = %q{Allows you to quickly add watches to god by creating YAML files in /etc/god/processes or Ruby .god files in /etc/god/conf.d.}
  spec.homepage      = "https://github.com/kiskeyix/god-inotify"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
#   if spec.respond_to?(:metadata)
#     spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
#   else
#     raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
#   end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "god"
  spec.add_runtime_dependency "rb-inotify"
end
