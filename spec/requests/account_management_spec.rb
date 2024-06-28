require "swagger_helper"
require "auth_context"

RSpec.describe "Authentication", type: :request do
  path "/change-login" do
    post "Requests change of account email. Sends confirmation email to the new email." do
      tags "Account Management"
      consumes "application/json"
      parameter name: :email_change_params, in: :body, schema: {
        type: :object,
        properties: {
          email: {type: :string, description: "The new email."},
          password: {type: :string}
        },
        required: ["email", "password"]
      }
      security [bearer_auth: []]

      response 200, "change email link has been sent to the new email" do
        include_context "auth"
        let(:email_change_params) {
          {
            email: generate(:account_email),
            password: logged_account.password
          }
        }
        run_test!
      end
    end
  end

  path "/verify-login-change" do
    post "Changes the account email. The `key` is contained in the link that was sent to the new email when the change of email was requested." do
      tags "Account Management"
      consumes "application/json"
      parameter in: :body, schema: {
        type: :object,
        properties: {
          key: {type: :string, description: "The `key` is contained in the link that was sent to the new email when the change of email was requested."}
        },
        required: ["key"]
      }

      response 200, "account email has been changed" do
        pending
      end
    end
  end

  path "/change-password" do
    post "Changes account password. `password` here is the old password." do
      tags "Account Management"
      consumes "application/json"
      parameter name: :password_details, in: :body, schema: {
        type: :object,
        properties: {
          password: {type: :string, description: "The old password"},
          newPassword: {type: :string},
          passwordConfirm: {type: :string}
        },
        required: ["password", "newPassword", "passwordConfirm"]
      }
      security [bearer_auth: []]

      response 200, "password has been changed" do
        include_context "auth"
        let(:password_details) {
          {
            password: logged_account.password,
            newPassword: "newPassword123",
            passwordConfirm: "newPassword123"
          }
        }
        run_test!
      end
    end
  end

  path "/reset-password-request" do
    post "Requests change of account password. Sends a password reset link to the current email." do
      tags "Account Management"
      consumes "application/json"
      parameter name: :reset_password_params, in: :body, schema: {
        type: :object,
        properties: {
          email: {type: :string}
        },
        required: ["email"]
      }

      response 200, "password reset link has been sent to the email" do
        include_context "auth"
        let(:reset_password_params) {
          {email: logged_account.email}
        }
        run_test!
      end
    end
  end

  path "/reset-password" do
    post "Changes the account password. The `key` is contained in the password reset link that was sent the account email." do
      tags "Account Management"
      consumes "application/json"
      parameter in: :body, schema: {
        type: :object,
        properties: {
          password: {type: :string},
          "password-confirm": {type: :string},
          key: {type: :string, description: "The `key` is contained in the password reset link that was sent the account email."}
        },
        required: ["password", "password-confirm", "key"]
      }

      response 200, "password reset link has been sent to the email" do
        pending
      end
    end
  end

  path "/close-account" do
    post "Closes the account. Note that there is not endpoint for reopening the account." do
      tags "Account Management"
      consumes "application/json"
      parameter name: :close_account_params, in: :body, schema: {
        type: :object,
        properties: {
          password: {type: :string}
        },
        required: ["password"]
      }
      security [bearer_auth: []]

      response 200, "account has been closed" do
        include_context "auth"
        let(:close_account_params) { {password: logged_account.password} }
        run_test!
      end
    end
  end
end
