# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smash_ruby/version'
require 'smash_ruby/tournament'
require 'smash_ruby/request'
require 'smash_ruby/phase'
require 'smash_ruby/pool'
require 'smash_ruby/player'
require 'smash_ruby/set'
require 'smash_ruby/errors/error_handler'
require 'smash_ruby/errors/not_found_error'
require 'smash_ruby/errors/unknown_error'

Gem::Specification.new do |spec|
  spec.name          = "smash_ruby"
  spec.version       = SmashRuby::VERSION
  spec.authors       = ["Nate Piche"]
  spec.email         = ["nate.f.piche@gmail.com"]

  spec.summary       = %q{Wrapper for the smash.gg API}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "faraday"
  spec.add_dependency "json"
  spec.add_dependency "dry-monads"
end
