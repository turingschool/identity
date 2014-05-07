require File.expand_path("../lib/jsl-identity/lib/jsl/identity/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "jsl-identity"
  s.version     = Jsl::Identity::VERSION
  s.authors     = ["Josh Cheek"]
  s.email       = ["josh@jumpstartlab.com"]
  s.homepage    = "https://github.com/JumpstartLab/asquared/lib/jsl-identity"
  s.summary     = %q{Client to allow services to retrieve user identity data for Jumpstart Lab}
  s.description = %q{Client to allow services to retrieve user identity data for Jumpstart Lab. Currently, this is pulled from asquared, but eventually will hopefully be extracted into its own service}

  s.files = %w[
    README.md
    jsl-identity.gemspec
    lib/jsl-identity/lib/jsl/identity/errors.rb
    lib/jsl-identity/lib/jsl/identity/mock/user.rb
    lib/jsl-identity/lib/jsl/identity/mock/user_repository.rb
    lib/jsl-identity/lib/jsl/identity/test.rb
    lib/jsl-identity/lib/jsl/identity/user.rb
    lib/jsl-identity/lib/jsl/identity/user_repository.rb
    lib/jsl-identity/lib/jsl/identity/version.rb
    lib/jsl-identity/lib/jsl/identity/web_clients/rack.rb
    lib/jsl-identity/lib/jsl/identity/web_clients/net_http.rb
    lib/jsl-identity/lib/jsl/identity.rb
  ]


  s.test_files    = []
  s.executables   = []
  s.require_paths = ["lib/jsl-identity/lib"]

  s.add_dependency 'surrogate',   '~> 0.7.0'
end
