require "rails_helper"
require "auth_context"

RSpec.describe "financial accounts", type: :request do
  include_context "auth"

  describe "GET /current-account" do
    it "renders a successful response" do
      get "/current-account", headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end
end
