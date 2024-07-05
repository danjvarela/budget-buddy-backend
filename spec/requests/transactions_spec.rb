require "swagger_helper"
require "auth_context"

RSpec.describe "Transactions", type: :request do
  include_context "auth"

  path "/transactions" do
    get "Gets all transactions associated with the currently logged user" do
      tags "Transactions"
      consumes "application/json"
      produces "application/json"
      security [bearer_auth: []]

      response 200, "success" do
        schema type: :array, items: {"$ref": "#/components/schemas/Transaction"}
        run_test!
      end
    end
  end

  path "/transactions/{id}" do
    delete "Deletes an income, expense, or transfer transaction" do
      tags "Transactions"
      consumes "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 204, "transaction successfully deleted" do
        let(:id) {
          create(:expense_transaction, user: logged_user).id
        }
        run_test!
      end

      response 404, "transaction not found" do
        let(:id) { 10000 }
        run_test!
      end
    end
  end
end
