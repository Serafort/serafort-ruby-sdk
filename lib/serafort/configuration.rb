# frozen_string_literal: true

module Serafort
  class Configuration
    attr_accessor :endpoint, :client_id, :client_secret, :jwks_cache_ttl, :leeway, :public_routes

    def initialize
      @endpoint = ENV["SERAFORT_ENDPOINT"] || "https://api.serafort.com"
      @client_id = ENV["SERAFORT_CLIENT_ID"]
      @client_secret = ENV["SERAFORT_CLIENT_SECRET"]
      @jwks_cache_ttl = 86_400
      @leeway = 60
      @public_routes = []
    end
  end
end
