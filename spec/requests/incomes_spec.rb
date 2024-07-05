require "swagger_helper"
require "auth_context"

RSpec.describe "Incomes", type: :request do
  include_context "auth"

  path "/incomes" do
    post "Creates a new income transaction" do
      tags "Incomes"
      consumes "application/json"
      produces "application/json"
      parameter name: :income, in: :body, schema: {"$ref" => "#/components/schemas/CreateIncomeParams"}
      security [bearer_auth: []]
      request_body_example value: {
        financialAccountId: 1,
        categoryId: 1,
        description: "Salar",
        amount: 190.0,
        date: "2023-12-18T04:09:53.000Z"
      }, name: :example

      response 201, "income transaction created" do
        schema "$ref" => "#/components/schemas/IncomeTransaction"
        let(:income) {
          financial_account = create :financial_account, user: logged_user
          category = create :category, user: logged_user, category_type: "income"
          a = attributes_for :income_transaction, user_id: logged_user.id, financial_account_id: financial_account.id, category_id: category.id
          camelize_keys(a)
        }

        run_test!
      end

      response 422, "income transaction creation failed" do
        schema "$ref" => "#/components/schemas/ResourceCreationError"
        example "application/json", :example, {errors: {category_id: ["can't be blank"]}}
        let(:income) {
          financial_account = create :financial_account, user: logged_user
          a = attributes_for :income_transaction, user_id: logged_user.id, financial_account_id: financial_account.id, category_id: nil
          camelize_keys(a)
        }
        run_test!
      end
    end

    get "Gets all income transactions associated to the logged in user" do
      tags "Incomes"
      consumes "application/json"
      produces "application/json"
      security [bearer_auth: []]

      response 200, "income transactions returned" do
        schema type: :array, items: {"$ref" => "#/components/schemas/IncomeTransaction"}
        run_test!
      end
    end
  end

  path "/incomes/{id}" do
    get "Gets the details of an income transaction" do
      tags "Incomes"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 200, "income transaction returned" do
        schema "$ref" => "#/components/schemas/IncomeTransaction"
        let(:id) { create(:income_transaction, user: logged_user).id }
        run_test!
      end

      response 404, "income transaction not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 1000000 }
        run_test!
      end
    end

    put "Updates an income transaction" do
      tags "Incomes"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :new_attributes, in: :body, schema: {"$ref" => "#/components/schemas/UpdateIncomeParams"}
      security [bearer_auth: []]

      response 200, "income transaction updated" do
        schema "$ref" => "#/components/schemas/IncomeTransaction"
        let(:income) { create(:income_transaction, user: logged_user) }
        let(:id) { income.id }
        let(:new_attributes) { {amount: income.amount + 1} }
        run_test!
      end

      response 404, "income transaction not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 100000 }
        let(:new_attributes) { {amount: 100} }
        run_test!
      end
    end

    delete "deletes a income" do
      tags "Incomes"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 204, "income transaction deleted" do
        let(:id) { create(:income_transaction, user: logged_user).id }
        run_test!
      end

      response 404, "income transaction not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 100000 }
        run_test!
      end
    end
  end
end
