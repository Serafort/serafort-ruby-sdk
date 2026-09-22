# frozen_string_literal: true

module Serafort
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "serafort.insert_middleware" do |app|
        app.middleware.use Serafort::Middleware
      end

      initializer "serafort.controller_additions" do
        ActiveSupport.on_load(:action_controller) do
          include Serafort::Rails::ControllerAdditions
        end
      end
    end
  end
end
