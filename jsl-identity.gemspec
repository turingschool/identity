require File.expand_path("../lib/jsl/identity/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "jsl-identity"
  s.version     = Jsl::Identity::VERSION
  s.authors     = ["Josh Cheek"]
  s.email       = ["josh@turing.io"]
  s.homepage    = "https://github.com/turingschool/identity"
  s.summary     = %q{Client to allow services to retrieve user identity data for Jumpstart Lab}
  s.description = %q{Client to allow services to retrieve user identity data for Jumpstart Lab. Currently, this is pulled from asquared, but eventually will hopefully be extracted into its own service}
  s.files       = `git ls-files`.split("\n")

  s.test_files    = []
  s.executables   = []
  s.require_paths = ["lib"]

  s.add_dependency 'surrogate',   '~> 0.8.0'
end
