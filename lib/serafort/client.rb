# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "jwt"
require "json"

module Serafort
  class Client
    attr_reader :config, :cache

    def initialize(config = nil)
      @config = config || Serafort.configuration
      @cache = Cache.new
      @http = Faraday.new(url: @config.endpoint) do |f|
        f.request :retry, max: 3, interval: 0.1, backoff_factor: 2
        f.adapter Faraday.default_adapter
      end
    end

    def validate_token(token)
      jwks_data = fetch_jwks
      jwk_set = JWT::JWK::Set.new(jwks_data)

      decoded_tokens = JWT.decode(
        token,
        nil,
        true,
        {
          algorithms: ["RS256", "ES256"],
          jwks: jwk_set,
          exp_leeway: @config.leeway
        }
      )

      payload = decoded_tokens.first
      UserContext.from_jwt_payload(payload)
    rescue JWT::DecodeError => e
      raise "Token validation failed: #{e.message}"
    end

    def get_access_token(scope: "")
      raise "Client ID and Secret required for M2M communication" unless @config.client_id && @config.client_secret

      cache_key = "m2m:#{@config.client_id}:#{scope}"
      @cache.fetch(cache_key, ttl: 3300) do
        res = @http.post("oauth/token") do |req|
          req.headers["Content-Type"] = "application/x-www-form-urlencoded"
          req.body = URI.encode_www_form(
            grant_type: "client_credentials",
            client_id: @config.client_id,
            client_secret: @config.client_secret,
            scope: scope
          )
        end

        raise "OAuth token request failed with status #{res.status}" unless res.success?

        data = JSON.parse(res.body)
        data["access_token"] || raise("No access_token in response")
      end
    end

    private

    def fetch_jwks
      @cache.fetch("jwks_keys", ttl: @config.jwks_cache_ttl) do
        res = @http.get(".well-known/jwks.json")
        raise "Failed to fetch JWKS with status #{res.status}" unless res.success?

        JSON.parse(res.body)
      end
    end
  end
end
