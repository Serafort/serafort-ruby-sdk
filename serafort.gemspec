# frozen_string_literal: true

require_relative "lib/serafort/version"

Gem::Specification.new do |spec|
  spec.name = "serafort"
  spec.version = Serafort::VERSION
  spec.authors = ["Serafort Engineering"]
  spec.email = ["engineering@serafort.com"]

  spec.summary = "Enterprise IAM, OAuth2/OIDC, Multi-Tenant Isolation, and Wildcard RBAC for Ruby & Rails."
  spec.description = "Official Ruby SDK and Rails Railtie for Serafort IAM platform."
  spec.homepage = "https://github.com/Serafort/serafort-ruby-sdk"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 2.0"
  spec.add_dependency "faraday-retry", ">= 2.0"
  spec.add_dependency "jwt", ">= 2.7"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
end
