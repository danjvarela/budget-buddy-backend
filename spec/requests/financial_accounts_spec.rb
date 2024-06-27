require "swagger_helper"
require "auth_context"

RSpec.describe "Financial Accounts", type: :request do
  include_context "auth"

  path "/financial_accounts" do
    post "Creates a new financial account" do
      tags "Financial Accounts"
      consumes "application/json"
      produces "application/json"
      parameter name: :financial_account, in: :body, schema: {"$ref" => "#/components/schemas/create_financial_account_params"}
      security [bearer_auth: []]
      request_body_example value: {name: "Cash", amount: 30.0, description: "Cash on hand"}, name: :example

      response 201, "financial account created" do
        schema "$ref" => "#/components/schemas/financial_account"
        let(:financial_account) { attributes_for :financial_account }
        run_test!
      end

      response 422, "failed to create financial account" do
        schema "$ref" => "#/components/schemas/resource_creation_error"
        example "application/json", :example, {errors: {name: ["can't be blank"]}}
        let(:financial_account) { {**attributes_for(:financial_account), name: nil} }
        run_test!
      end
    end

    get "Gets all financial accounts associated to the logged in account" do
      tags "Financial Accounts"
      consumes "application/json"
      produces "application/json"
      security [bearer_auth: []]

      response 200, "financial accounts returned" do
        schema type: :array, items: {"$ref" => "#/components/schemas/financial_account"}
        run_test!
      end
    end
  end

  path "/financial_accounts/{id}" do
    get "Gets the details of a financial account" do
      tags "Financial Accounts"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 200, "financial account returned" do
        schema "$ref" => "#/components/schemas/financial_account"
        let(:id) { create(:financial_account).id }
        run_test!
      end

      response 404, "financial account not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
        let(:id) { 1000000 }
        run_test!
      end
    end

    put "Updates a financial account" do
      tags "Financial Accounts"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :new_attributes, in: :body, schema: {"$ref" => "#/components/schemas/update_financial_account_params"}
      security [bearer_auth: []]

      response 200, "financial account updated" do
        schema "$ref" => "#/components/schemas/financial_account"
        let(:financial_account) { create :financial_account }
        let(:id) { financial_account.id }
        let(:new_attributes) { {name: generate(:financial_account_name)} }
        run_test!
      end

      response 404, "financial account not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
        let(:id) { 100000 }
        let(:new_attributes) { {name: generate(:financial_account_name)} }
        run_test!
      end
    end

    delete "deletes a financial account" do
      tags "Financial Accounts"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 204, "financial account deleted" do
        let(:id) { create(:financial_account).id }
        run_test!
      end

      response 404, "financial account not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
        let(:id) { 100000 }
        run_test!
      end
    end
  end
end
