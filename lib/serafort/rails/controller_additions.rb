# frozen_string_literal: true

module Serafort
  module Rails
    module ControllerAdditions
      def current_user
        request.env["serafort.user"]
      end

      def authenticate_serafort!
        unless current_user
          render json: { error: "Unauthorized", message: "Authentication required" }, status: :unauthorized
        end
      end

      def require_permission!(permission)
        authenticate_serafort!
        return if performed?

        unless current_user.has_permission?(permission)
          render json: { error: "Forbidden", message: "Missing required permission: #{permission}" }, status: :forbidden
        end
      end

      def require_role!(role)
        authenticate_serafort!
        return if performed?

        unless current_user.has_role?(role)
          render json: { error: "Forbidden", message: "Missing required role: #{role}" }, status: :forbidden
        end
      end
    end
  end
end
