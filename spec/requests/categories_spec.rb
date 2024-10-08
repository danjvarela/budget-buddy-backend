require "swagger_helper"
require "auth_context"

RSpec.describe "Categories", type: :request do
  include_context "auth"

  path "/categories" do
    post "Creates a new category" do
      tags "Categories"
      consumes "application/json"
      produces "application/json"
      parameter name: :category, in: :body, schema: {"$ref" => "#/components/schemas/CreateCategoryParams"}
      security [bearer_auth: []]
      request_body_example value: {name: "Transportation", categoryType: "expense"}, name: :example

      response 201, "category created" do
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/Category"}}
        let(:category) { camelize_keys(attributes_for(:category)) }
        run_test!
      end

      response 422, "failed to create category" do
        schema "$ref" => "#/components/schemas/ResourceCreationError"
        example "application/json", :example, {errors: {name: ["can't be blank"]}}
        let(:category) { camelize_keys({**attributes_for(:category), name: nil}) }
        run_test!
      end
    end

    get "Gets all categories associated to the logged in user" do
      tags "Categories"
      consumes "application/json"
      produces "application/json"
      security [bearer_auth: []]
      parameter name: :categoryType, in: :query, type: :string, description: "This is type of category to query. It can be `income` or `expense`. The request will return all the categories for the logged in user if this is not specified or its value is null."

      response 200, "categories returned" do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: {"$ref" => "#/components/schemas/Category"}
          }
        }
        let(:categoryType) { "income" }
        run_test!
      end
    end
  end

  path "/categories/{id}" do
    get "Gets the details of a category" do
      tags "Categories"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 200, "category returned" do
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/Category"}}
        let(:id) { create(:category, user: logged_user).id }
        run_test!
      end

      response 404, "category not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 1000000 }
        run_test!
      end
    end

    put "Updates a category" do
      tags "Categories"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :new_attributes, in: :body, schema: {"$ref" => "#/components/schemas/UpdateCategoryParams"}
      security [bearer_auth: []]

      response 200, "category updated" do
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/Category"}}
        let(:category) { create :category, user: logged_user }
        let(:id) { category.id }
        let(:new_attributes) { {name: generate(:category_name)} }
        run_test!
      end

      response 404, "category not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 100000 }
        let(:new_attributes) { {name: generate(:category_name)} }
        run_test!
      end
    end

    delete "deletes a category" do
      tags "Categories"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      security [bearer_auth: []]

      response 204, "category deleted" do
        let(:id) { create(:category, user: logged_user).id }
        run_test!
      end

      response 404, "category not found" do
        schema "$ref" => "#/components/schemas/ResourceNotFoundError"
        let(:id) { 100000 }
        run_test!
      end
    end
  end
end
