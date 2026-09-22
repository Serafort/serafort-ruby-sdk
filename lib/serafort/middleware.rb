# frozen_string_literal: true

module Serafort
  class Middleware
    def initialize(app, options = {})
      @app = app
      @client = options[:client] || Serafort.client
      @public_routes = options[:public_routes] || Serafort.configuration.public_routes
    end

    def call(env)
      req = Rack::Request.new(env)

      if public_route?(req.path_info)
        return @app.call(env)
      end

      auth_header = env["HTTP_AUTHORIZATION"]
      if auth_header && auth_header.start_with?("Bearer ")
        token = auth_header[7..].strip
        begin
          user = @client.validate_token(token)
          env["serafort.user"] = user
          env["serafort.token"] = token
        rescue StandardError => e
          # Token was present but failed validation
          return [401, { "Content-Type" => "application/json" }, [{ error: "Unauthorized", message: e.message }.to_json]]
        end
      end

      @app.call(env)
    end

    private

    def public_route?(path)
      @public_routes.any? do |pattern|
        if pattern.end_with?("/*")
          prefix = pattern[0..-3]
          path == prefix || path.start_with?("#{prefix}/")
        else
          path == pattern
        end
      end
    end
  end
end
