# Serafort SDK for Ruby & Rails

Enterprise IAM, OAuth2/OIDC, Multi-Tenant Isolation, Rack Middleware, and Wildcard RBAC for Ruby and Rails applications.

## Features

- 💎 **Rails Engine / Railtie**: Auto-mounts `Serafort::Middleware` and injects `current_user`, `authenticate_serafort!`, and `require_permission!` into ActionController.
- 🚀 **Faraday HTTP with Retries**: Built-in exponential backoff on network failures and rate limits.
- 🛡️ **Wildcard RBAC**: `current_user.has_permission?('org:*')` evaluation.
- 🏢 **Multi-Tenant Isolation**: Zero-leakage multi-tenant separation.
- ⚡ **Local JWKS Caching**: Caches public signing keys with configurable leeway.

## Installation

Add to your application's `Gemfile`:

```ruby
gem 'serafort', '~> 0.1.0'
```

And run:

```bash
bundle install
```

## Quick Start

### 1. Configure Initializer (`config/initializers/serafort.rb`)

```ruby
Serafort.configure do |config|
  config.endpoint = ENV["SERAFORT_ENDPOINT"] || "https://api.serafort.com"
  config.client_id = ENV["SERAFORT_CLIENT_ID"]
  config.client_secret = ENV["SERAFORT_CLIENT_SECRET"]
end
```

### 2. Protect Rails Controllers

```ruby
class DashboardController < ApplicationController
  before_action :authenticate_serafort!
  before_action -> { require_permission!("org:*") }

  def index
    render json: {
      user_id: current_user.user_id,
      tenant_id: current_user.tenant_id
    }
  end
end
```

## Contributing

### Requirements

- Ruby 3.2+ (3.0+ supported per `serafort.gemspec`, CI targets 3.2)
- Bundler

```bash
bundle install
bundle exec rspec
```

### Git hooks

This repo ships a portable pre-commit hook under `.githooks/pre-commit` that runs a Ruby syntax check (`ruby -c`) on staged `.rb` files and `bundle exec rspec` before every commit. It is **not** installed automatically — enable it once per clone with:

```bash
git config core.hooksPath .githooks
```

There is no Husky setup here: Husky is an npm-ecosystem tool that hooks into `package.json`/`node_modules`, and this is a pure Ruby gem with no Node.js tooling involved. A plain POSIX shell script wired through `core.hooksPath` is the idiomatic equivalent for a Ruby repo and keeps the gem dependency-free.

### CI

Every push and pull request against `main` runs `bundle exec rspec` on Ruby 3.2 via GitHub Actions (`.github/workflows/ci.yml`). RuboCop is not yet part of this gem's toolchain (no `rubocop` dependency is declared in the `Gemfile`/gemspec), so it is intentionally omitted from CI and the pre-commit hook until it's added.
