require "swagger_helper"
require "auth_context"
require "swagger_schemas"

RSpec.describe "Expenses", type: :request do
  include_context "auth"

  path "/expenses" do
    post "Creates a new expense transaction" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      parameter name: :expense, in: :body, schema: {"$ref" => "#/components/schemas/CreateExpenseParams"}
      security [bearer_auth: []]
      request_body_example value: {
        financialAccountId: 1,
        categoryId: 1,
        description: "Food",
        amount: 190.0,
        date: "2023-12-18T04:09:53.000Z"
      }, name: :example

      response 201, "expense transaction created" do
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/ExpenseTransaction"}}
        let(:expense) {
          financial_account = create :financial_account, user: logged_user
          category = create :category, user: logged_user
          a = attributes_for :expense_transaction, user_id: logged_user.id, financial_account_id: financial_account.id, category_id: category.id
          camelize_keys(a)
        }

        run_test!
      end

      response 422, "expense transaction creation failed" do
        schema "$ref" => "#/components/schemas/ResourceCreationError"
        example "application/json", :example, {errors: {category_id: ["can't be blank"]}}
        let(:expense) {
          financial_account = create :financial_account, user: logged_user
          a = attributes_for :expense_transaction, user_id: logged_user.id, financial_account_id: financial_account.id, category_id: nil
          camelize_keys(a)
        }
        run_test!
      end
    end

    get "Gets all expense transactions associated to the logged in user" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      security [bearer_auth: []]
      parameter name: :fromDate, in: :query, type: :string, description: "Format: YYYY-MM-DD", required: false
      parameter name: :toDate, in: :query, type: :string, description: "Format: YYYY-MM-DD", required: false
      parameter name: :descriptionContains, in: :query, type: :string, required: false
      parameter name: :page, in: :query, type: :string, description: "The page number", required: false
      parameter name: :perPage, in: :query, type: :string, description: "The number of results per page", required: false
      parameter name: :sort, in: :query, type: :string, description: "Example: `date asc`, `description desc`", required: false
      parameter name: :categoryId, in: :query, type: :integer, required: false
      parameter name: :financialAccountId, in: :query, type: :integer, required: false

      response 200, "expense transactions returned" do
        schema type: :object, properties: {
          **SwaggerSchemas::PAGINATION_DATA_PROPERTIES,
          data: {
            type: :array,
            items: {"$ref" => "#/components/schemas/ExpenseTransaction"}
          }
        }

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
        let(:descriptionContains) { "" }
        let(:page) { 1 }
        let(:perPage) { 2 }
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
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/ExpenseTransaction"}}
        let(:id) { create(:expense_transaction, user: logged_user).id }
        run_test!
      end

      response 404, "expense transaction not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 1000000 }
        run_test!
      end
    end

    put "Updates an expense transaction" do
      tags "Expenses"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :new_attributes, in: :body, schema: {"$ref" => "#/components/schemas/UpdateExpenseParams"}
      security [bearer_auth: []]

      response 200, "expense transaction updated" do
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/ExpenseTransaction"}}
        let(:expense) { create(:expense_transaction, user: logged_user) }
        let(:id) { expense.id }
        let(:new_attributes) { {amount: expense.amount + 1} }
        run_test!
      end

      response 404, "expense transaction not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
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

      response 204, "expense transaction deleted" do
        let(:id) { create(:expense_transaction, user: logged_user).id }
        run_test!
      end

      response 404, "expense transaction not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 100000 }
        run_test!
      end
    end
  end
end
