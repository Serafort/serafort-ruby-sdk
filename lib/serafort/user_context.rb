# frozen_string_literal: true

module Serafort
  class UserContext
    attr_reader :user_id, :tenant_id, :roles, :permissions, :claims

    def initialize(user_id:, tenant_id:, roles: [], permissions: [], claims: {})
      @user_id = user_id
      @tenant_id = tenant_id
      @roles = roles || []
      @permissions = permissions || []
      @claims = claims || {}
    end

    def self.from_jwt_payload(payload)
      new(
        user_id: payload["sub"] || payload["user_id"] || "",
        tenant_id: payload["tenant_id"] || "",
        roles: payload["roles"] || [],
        permissions: payload["permissions"] || [],
        claims: payload
      )
    end

    def has_permission?(required)
      @permissions.each do |perm|
        return true if perm == "*" || perm == required
        if perm.end_with?(":*")
          prefix = perm[0..-3]
          return true if required.start_with?("#{prefix}:") || required == prefix
        end
      end
      false
    end

    def has_role?(role)
      @roles.include?(role)
    end

    def has_tenant?(tenant)
      @tenant_id == tenant
    end
  end
end
