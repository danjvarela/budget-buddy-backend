require "swagger_helper"

RSpec.describe "Authentication", type: :request do
  path "/create-account" do
    post "Creates an unverified account. Sends a verification email to the provided email address." do
      tags "Authentication"
      consumes "application/json"
      parameter in: :body, schema: {
        type: :object,
        properties: {
          :email => {type: :string},
          :password => {type: :string},
          "password-confirm" => {type: :string}
        },
        required: ["email", "password", "password-confirm"]
      }
      request_body_example value: {
        email: "example01@gmail.com",
        password: "samplePassword",
        "password-confirm": "samplePassword"
      }

      response 200, "unverified account has been created" do
        run_test!
      end
    end
  end

  path "/verify-account" do
    post "Verifies an account. The `key` is contained in the link that was sent to the user's email during account creation" do
      tags "Authentication"
      consumes "application/json"
      parameter in: :body, schema: {
        type: :object,
        properties: {
          key: {type: :string, description: "The `key` is contained in the link that was sent to the user's email during account creation"}
        },
        required: ["key"]
      }

      response 200, "account has been verified" do
        run_test!
      end
    end
  end

  path "/login" do
    post "Logs in to an existing, verified account." do
      tags "Authentication"
      consumes "application/json"
      parameter in: :body, schema: {
        type: :object,
        properties: {
          email: {type: :string},
          password: {type: :string}
        },
        required: ["email", "password"]
      }

      response 200, "user has been logged in" do
        run_test!
      end
    end
  end

  path "/logout" do
    post "Logs out the current session. Include the `global_logout` attribute and pass any value to logout of all sessions, otherwise don't include it in the request body." do
      tags "Authentication"
      consumes "application/json"
      parameter in: :body, schema: {
        type: :object,
        properties: {
          global_logout: {type: :string, description: "Include this attribute and pass any value to logout of all sessions, otherwise don't include it in the request body."}
        }
      }

      response 200, "user has been logged out" do
        run_test!
      end
    end
  end

  path "/verify-account-resend" do
    post "Resends account verification email. Note that there is a 5-minute delay between resends." do
      tags "Authentication"
      consumes "application/json"
      parameter in: :body, schema: {
        type: :object,
        properties: {
          email: {type: :string}
        },
        required: ["email"]
      }

      response 200, "email verification has been resent" do
        run_test!
      end
    end
  end
end
