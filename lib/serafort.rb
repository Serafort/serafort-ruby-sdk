# frozen_string_literal: true

require_relative "serafort/version"
require_relative "serafort/configuration"
require_relative "serafort/user_context"
require_relative "serafort/cache"
require_relative "serafort/client"
require_relative "serafort/middleware"

if defined?(Rails::Railtie)
  require_relative "serafort/rails/controller_additions"
  require_relative "serafort/rails/railtie"
end

module Serafort
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def client
      @client ||= Client.new(configuration)
    end

    def reset!
      @configuration = Configuration.new
      @client = nil
    end
  end
end
