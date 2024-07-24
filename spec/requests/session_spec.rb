require "swagger_helper"
require "auth_context"

RSpec.describe "Session", type: :request do
  include_context "auth"

  path "/current-account" do
    get "Retrieves the currently logged account" do
      tags "Session"
      consumes "application/json"
      produces "application/json"
      security [bearer_auth: []]

      response 200, "success" do
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/User"}}
        run_test!
      end
    end
  end
end
