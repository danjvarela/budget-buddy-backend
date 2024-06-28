require "swagger_helper"
require "auth_context"

RSpec.describe "Authentication", type: :request do
  path "/create-account" do
    post "Creates an unverified account. Sends a verification email to the provided email address." do
      tags "Authentication"
      consumes "application/json"
      parameter name: :account, in: :body, schema: {
        type: :object,
        properties: {
          email: {type: :string},
          password: {type: :string},
          passwordConfirm: {type: :string}
        },
        required: ["email", "password", "passwordConfirm"]
      }
      request_body_example value: {
        email: "example01@email.com",
        password: "123qwe123",
        passwordConfirm: "123qwe123"
      }

      response 200, "unverified account has been created" do
        let(:account) {
          a = attributes_for :account
          camelize_keys({**a, passwordConfirm: a[:password]})
        }
        run_test!
      end
    end
  end

  path "/verify-account" do
    post "Verifies an account. The `key` is contained in the link that was sent to the user's email during account creation" do
      tags "Authentication"
      consumes "application/json"
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          key: {type: :string, description: "The `key` is contained in the link that was sent to the user's email during account creation"}
        },
        required: ["key"]
      }

      response 200, "account has been verified" do
        pending
      end
    end
  end

  path "/login" do
    post "Logs in to an existing, verified account." do
      tags "Authentication"
      consumes "application/json"
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: {type: :string},
          password: {type: :string}
        },
        required: ["email", "password"]
      }
      request_body_example value: {
        email: "example01@email.com",
        password: "123qwe123"
      }

      response 200, "user has been logged in" do
        let(:credentials) {
          a = create :account
          {email: a.email, password: a.password}
        }
        run_test!
      end
    end
  end

  path "/logout" do
    post "Logs out the current session. Include the `global_logout` attribute and pass any value to logout of all sessions, otherwise don't include it in the request body." do
      tags "Authentication"
      consumes "application/json"
      parameter name: :options, in: :body, schema: {
        type: :object,
        properties: {
          global_logout: {type: :string, description: "Include this attribute and pass any value to logout of all sessions, otherwise don't include it in the request body."}
        }
      }
      security [bearer_auth: []]

      response 200, "user has been logged out" do
        include_context "auth"
        let(:options) { {} }
        run_test!
      end
    end
  end

  path "/verify-account-resend" do
    post "Resends account verification email. Note that there is a 5-minute delay between resends." do
      tags "Authentication"
      consumes "application/json"
      parameter name: :options, in: :body, schema: {
        type: :object,
        properties: {
          email: {type: :string}
        },
        required: ["email"]
      }

      response 200, "email verification has been resent" do
        pending
      end
    end
  end
end
