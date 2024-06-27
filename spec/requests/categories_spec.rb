require "swagger_helper"
require "auth_context"

RSpec.describe "Categories", type: :request do
  include_context "auth"

  path "/categories" do
    post "Creates a new category" do
      tags "Categories"
      consumes "application/json"
      produces "application/json"
      parameter name: :category, in: :body, schema: {"$ref" => "#/components/schemas/create_category_params"}
      security [bearer_auth: []]
      request_body_example value: {name: "Transportation", category_type: "expense"}, name: :example

      response 201, "category created" do
        schema "$ref" => "#/components/schemas/category"
        let(:category) { attributes_for :category }
        run_test!
      end

      response 422, "failed to create category" do
        schema "$ref" => "#/components/schemas/resource_creation_error"
        example "application/json", :example, {errors: {name: ["can't be blank"]}}
        let(:category) { {**attributes_for(:category), name: nil} }
        run_test!
      end
    end

    get "Gets all categories associated to the logged in account" do
      tags "Categories"
      consumes "application/json"
      produces "application/json"
      security [bearer_auth: []]

      response 200, "categories returned" do
        schema type: :array, items: {"$ref" => "#/components/schemas/category"}
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
        schema "$ref" => "#/components/schemas/category"
        let(:id) { create(:category).id }
        run_test!
      end

      response 404, "category not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
        let(:id) { 1000000 }
        run_test!
      end
    end

    put "Updates a category" do
      tags "Categories"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :new_attributes, in: :body, schema: {"$ref" => "#/components/schemas/base_category"}
      security [bearer_auth: []]

      response 200, "category updated" do
        schema "$ref" => "#/components/schemas/category"
        let(:category) { create :category }
        let(:id) { category.id }
        let(:new_attributes) { {name: generate(:category_name)} }
        run_test!
      end

      response 404, "category not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
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
        let(:id) { create(:category).id }
        run_test!
      end

      response 404, "category not found" do
        schema "$ref" => "#/components/schemas/resource_not_found_error"
        let(:id) { 100000 }
        run_test!
      end
    end
  end
end