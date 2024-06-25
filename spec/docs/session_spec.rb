require "swagger_helper"

RSpec.describe "Session", type: :request do
  path "/current-account" do
    get "Retrieves the currently logged account" do
      tags "Session"
      consumes "application/json"
      security [bearer_auth: []]

      response 200, "" do
        run_test!
      end
    end
  end
end
