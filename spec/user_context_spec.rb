# frozen_string_literal: true

require "spec_helper"

RSpec.describe Serafort::UserContext do
  let(:user) do
    described_class.new(
      user_id: "usr_ruby_007",
      tenant_id: "tenant_rails",
      roles: ["admin", "developer"],
      permissions: ["org:*", "billing:read"]
    )
  end

  describe "#has_permission?" do
    it "matches wildcard permissions" do
      expect(user.has_permission?("org:members:invite")).to be true
      expect(user.has_permission?("org:settings:update")).to be true
    end

    it "matches exact permissions" do
      expect(user.has_permission?("billing:read")).to be true
    end

    it "rejects missing permissions" do
      expect(user.has_permission?("billing:write")).to be false
      expect(user.has_permission?("system:root")).to be false
    end

    it "matches global wildcard *" do
      super_user = described_class.new(
        user_id: "usr_super",
        tenant_id: "tenant_rails",
        permissions: ["*"]
      )
      expect(super_user.has_permission?("any:permission:here")).to be true
    end
  end

  describe "#has_role?" do
    it "returns true for assigned roles" do
      expect(user.has_role?("admin")).to be true
      expect(user.has_role?("developer")).to be true
    end

    it "returns false for unassigned roles" do
      expect(user.has_role?("superadmin")).to be false
    end
  end

  describe "#has_tenant?" do
    it "checks tenant isolation" do
      expect(user.has_tenant?("tenant_rails")).to be true
      expect(user.has_tenant?("other_tenant")).to be false
    end
  end

  describe ".from_jwt_payload" do
    it "parses JWT claims into UserContext" do
      payload = {
        "sub" => "usr_jwt_123",
        "tenant_id" => "tenant_acme",
        "roles" => ["manager"],
        "permissions" => ["org:*"]
      }

      parsed = described_class.from_jwt_payload(payload)
      expect(parsed.user_id).to eq("usr_jwt_123")
      expect(parsed.tenant_id).to eq("tenant_acme")
      expect(parsed.roles).to include("manager")
      expect(parsed.has_permission?("org:delete")).to be true
    end
  end
end
