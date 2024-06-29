require "rails_helper"

RSpec.describe TransactionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/transactions").to route_to("transactions#index")
    end

    it "routes to #destroy" do
      expect(delete: "/transactions/1").to route_to("transactions#destroy", id: "1")
    end
  end
end
