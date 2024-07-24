require "swagger_helper"
require "auth_context"

RSpec.describe "Transfers", type: :request do
  include_context "auth"

  path "/transfers" do
    post "Creates a new transfer transaction" do
      tags "Transfers"
      consumes "application/json"
      produces "application/json"
      parameter name: :transfer, in: :body, schema: {"$ref" => "#/components/schemas/CreateTransferParams"}
      security [bearer_auth: []]
      request_body_example value: {
        fromFinancialAccountId: 1,
        toFinancialAccountId: 2,
        description: "ATM Withdrawal",
        amount: 190.0,
        date: "2023-12-18T04:09:53.000Z"
      }, name: :example

      response 201, "transfer transaction created" do
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/TransferTransaction"}}
        let(:transfer) {
          from_financial_account = create :financial_account, user: logged_user
          to_financial_account = create :financial_account, user: logged_user
          a = attributes_for :transfer_transaction, user_id: logged_user.id, from_financial_account_id: from_financial_account.id, to_financial_account_id: to_financial_account.id
          camelize_keys(a)
        }

        run_test!
      end

      response 422, "failed to create transfer transaction" do
        schema "$ref" => "#/components/schemas/ResourceCreationError"
        example "application/json", :example, {errors: {fromFinancialAccountId: ["can't be blank"]}}
        let(:transfer) {
          a = attributes_for :transfer_transaction, user_id: logged_user.id, from_financial_account_id: nil, to_financial_account_id: nil
          camelize_keys(a)
        }
        run_test!
      end
    end

    get "Gets all transfer transactions associated to the logged in user" do
      tags "Transfers"
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
      parameter name: :fromFinancialAccountId, in: :query, type: :integer, required: false
      parameter name: :toFinancialAccountId, in: :query, type: :integer, required: false

      response 200, "transfer transactions returned" do
        schema type: :object, properties: {
          **SwaggerSchemas::PAGINATION_DATA_PROPERTIES,
          data: {
            type: :array,
            items: {"$ref" => "#/components/schemas/TransferTransaction"}
          }
        }
        run_test!
      end
    end
  end

  path "/transfers/{id}" do
    get "Gets the details of a transfer transaction" do
      tags "Transfers"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 200, "transfer transaction returned" do
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/TransferTransaction"}}
        let(:id) { create(:transfer_transaction, user: logged_user).id }
        run_test!
      end

      response 404, "transfer not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 1000000 }
        run_test!
      end
    end

    put "Updates an transfer transaction" do
      tags "Transfers"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :new_attributes, in: :body, schema: {"$ref" => "#/components/schemas/UpdateTransferParams"}
      security [bearer_auth: []]

      response 200, "transfer updated" do
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/TransferTransaction"}}
        let(:transfer) { create(:transfer_transaction, user: logged_user) }
        let(:id) { transfer.id }
        let(:new_attributes) { {amount: transfer.amount + 1} }
        run_test!
      end

      response 404, "transfer not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 100000 }
        let(:new_attributes) { {amount: 100} }
        run_test!
      end
    end

    delete "deletes a transfer" do
      tags "Transfers"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 204, "transfer deleted" do
        let(:id) { create(:transfer_transaction, user: logged_user).id }
        run_test!
      end

      response 404, "transfer not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 100000 }
        run_test!
      end
    end
  end
end
