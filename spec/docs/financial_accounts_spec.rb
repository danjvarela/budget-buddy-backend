require "swagger_helper"

RSpec.describe "Financial Accounts", type: :request do
  path "/financial_accounts" do
    post "Creates a new financial account" do
      tags "Financial Account"
      consumes "application/json"
      produces "application/json"
      parameter in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string, description: "The new email."},
          amount: {type: :number},
          description: {type: :string}
        },
        required: ["name", "amount"]
      }
      security [bearer_auth: []]

      response 201, "new financial account created" do
        run_test!
      end
    end
  end
end
