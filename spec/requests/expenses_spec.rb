require "swagger_helper"
require "auth_context"

RSpec.describe "expenses", type: :request do
  include_context "auth"

  path "/expenses" do
    post "Creates a new expense" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      parameter name: :expense, in: :body, schema: {"$ref" => "#/components/schemas/create_expense_params"}
      security [bearer_auth: []]
      request_body_example value: {
        amount: 100.00,
        description: "Dinner",
        date: "2023-08-25T07:25:59.000Z",
        financialAccountId: 1,
        categoryAccountId: 1
      }, name: :example

      response 201, "expense created" do
        schema "$ref" => "#/components/schemas/expense"
        let(:expense) {
          category = create :category
          financial_account = create :financial_account
          camelize_keys({
            **attributes_for(:expense),
            financial_account_id: financial_account.id,
            category_id: category.id
          })
        }
        run_test!
      end

      response 422, "failed to create expense" do
        schema "$ref" => "#/components/schemas/resource_creation_error"
        example "application/json", :example, {errors: {date: ["can't be blank"]}}
        let(:expense) { camelize_keys({**attributes_for(:expense), date: nil}) }
        run_test!
      end
    end

    get "Gets all expenses associated to the logged in account" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      security [bearer_auth: []]

      response 200, "expenses returned" do
        schema type: :array, items: {"$ref" => "#/components/schemas/expense"}
        run_test!
      end
    end
  end

  path "/expenses/{id}" do
    get "Gets the details of a expense" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 200, "expense returned" do
        schema "$ref" => "#/components/schemas/expense"
        let(:id) { create(:expense).id }
        run_test!
      end

      response 404, "expense not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
        let(:id) { 1000000 }
        run_test!
      end
    end

    put "Updates a expense" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :new_attributes, in: :body, schema: {"$ref" => "#/components/schemas/update_expense_params"}
      security [bearer_auth: []]

      response 200, "expense updated" do
        schema "$ref" => "#/components/schemas/expense"
        let(:expense) { create :expense }
        let(:id) { expense.id }
        let(:new_attributes) { {categoryId: create(:category).id} }
        run_test!
      end

      response 404, "expense not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
        let(:id) { 100000 }
        let(:new_attributes) { {categoryId: create(:category).id} }
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
        let(:id) { create(:expense).id }
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
