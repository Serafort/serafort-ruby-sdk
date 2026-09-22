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
