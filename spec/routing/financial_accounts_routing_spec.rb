require "rails_helper"

RSpec.describe FinancialAccountsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/financial_accounts").to route_to("financial_accounts#index")
    end

    it "routes to #show" do
      expect(get: "/financial_accounts/1").to route_to("financial_accounts#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/financial_accounts").to route_to("financial_accounts#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/financial_accounts/1").to route_to("financial_accounts#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/financial_accounts/1").to route_to("financial_accounts#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/financial_accounts/1").to route_to("financial_accounts#destroy", id: "1")
    end
  end
end
