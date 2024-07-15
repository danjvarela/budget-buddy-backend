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
      parameter name: :fromDate, in: :query, type: :string, description: "Format: YYYY-MM-DD"
      parameter name: :toDate, in: :query, type: :string, description: "Format: YYYY-MM-DD"

      response 200, "success" do
        schema type: :array, items: {"$ref": "#/components/schemas/Transaction"}

        def create_transactions
          financial_account = create :financial_account, user: logged_user
          category = create :category, category_type: "expense", user: logged_user
          5.times do |n|
            create :transaction, transaction_type: "expense", user: logged_user, financial_account: financial_account, category: category, date: DateTime.now - n.day
          end
        end

        let(:fromDate) {
          create_transactions
          logged_user.transactions.expense.first.date
        }
        let(:toDate) {
          logged_user.transactions.expense.last.date
        }
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
