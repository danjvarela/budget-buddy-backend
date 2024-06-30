require "swagger_helper"
require "auth_context"

RSpec.describe "Expenses", type: :request do
  include_context "auth"

  path "/expenses" do
    post "Creates a new expense" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      parameter name: :expense, in: :body, schema: {"$ref" => "#/components/schemas/create_expense_params"}
      security [bearer_auth: []]
      request_body_example value: {
        financialAccountId: 1,
        categoryId: 1,
        description: "Food",
        amount: 190.0,
        date: "2023-12-18T04:09:53.000Z"
      }, name: :example

      response 201, "expense transaction created" do
        schema "$ref" => "#/components/schemas/expense_transaction"
        let(:expense) {
          financial_account = create :financial_account, account: logged_account
          category = create :category, account: logged_account
          a = attributes_for :expense_transaction, account_id: logged_account.id, financial_account_id: financial_account.id, category_id: category.id
          camelize_keys(a)
        }

        run_test!
      end

      response 422, "failed to create expense transaction" do
        schema "$ref" => "#/components/schemas/resource_creation_error"
        example "application/json", :example, {errors: {category_id: ["can't be blank"]}}
        let(:expense) {
          financial_account = create :financial_account, account: logged_account
          a = attributes_for :expense_transaction, account_id: logged_account.id, financial_account_id: financial_account.id, category_id: nil
          camelize_keys(a)
        }
        run_test!
      end
    end

    get "Gets all expense transactions associated to the logged in account" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      security [bearer_auth: []]

      response 200, "expense transactions returned" do
        schema type: :array, items: {"$ref" => "#/components/schemas/expense_transaction"}
        run_test!
      end
    end
  end

  path "/expenses/{id}" do
    get "Gets the details of an expense transaction" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 200, "expense transaction returned" do
        schema "$ref" => "#/components/schemas/expense_transaction"
        let(:id) { create(:expense_transaction, account: logged_account).id }
        run_test!
      end

      response 404, "expense not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
        let(:id) { 1000000 }
        run_test!
      end
    end

    put "Updates an expense transaction" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :new_attributes, in: :body, schema: {"$ref" => "#/components/schemas/update_expense_params"}
      security [bearer_auth: []]

      response 200, "expense updated" do
        schema "$ref" => "#/components/schemas/expense_transaction"
        let(:expense) { create(:expense_transaction, account: logged_account) }
        let(:id) { expense.id }
        let(:new_attributes) { {amount: expense.amount + 1} }
        run_test!
      end

      response 404, "expense not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
        let(:id) { 100000 }
        let(:new_attributes) { {amount: 100} }
        run_test!
      end
    end

    delete "deletes a expense" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 204, "expense deleted" do
        let(:id) { create(:expense_transaction, account: logged_account).id }
        run_test!
      end

      response 404, "expense not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
        let(:id) { 100000 }
        run_test!
      end
    end
  end
end
