# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_streak_check/version'

Gem::Specification.new do |spec|
  spec.name          = "github_streak_check"
  spec.version       = GithubStreakCheck::VERSION
  spec.authors       = ["Yutaka HARA"]
  spec.email         = ["yutaka.hara+github@gmail.com"]
  spec.description   = %q{Checks if you already done today's commit}
  spec.summary       = %q{Checks if you already done today's commit for GitHub's "Longest Streak" feature.}
  spec.homepage      = "https://github.com/yhara/github_streak_check"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "pony", "~> 1.5.1"
  spec.add_runtime_dependency "activesupport", "~> 4.0.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "fakeweb", "~> 1.3.0"
  spec.add_development_dependency "timecop", "~> 0.6.3"
end
