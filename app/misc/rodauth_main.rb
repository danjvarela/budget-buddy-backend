require "sequel/core"

class RodauthMain < Rodauth::Rails::Auth
  configure do
    # List of authentication features that are loaded.
    enable :create_account, :verify_account,
      :login, :logout, :reset_password, :change_password, :change_password_notify, :internal_request,
      :change_login, :verify_login_change, :close_account, :omniauth, :active_sessions, :jwt, :session_expiration

    omniauth_provider :google_oauth2, Rails.application.credentials.google_oauth2["client_id"], Rails.application.credentials.google_oauth2["client_secret"], {
      name: :google,
      redirect_uri: "#{Rails.application.credentials.frontend[:url]}/auth/google/callback",
      provider_ignores_state: true
    }

    omniauth_authorize_url_key "authorize_url"
    omniauth_error_type_key "error_type"

    session_inactivity_deadline 60 * 10
    max_session_lifetime 60 * 10

    # See the Rodauth documentation for the list of available config options:
    # http://rodauth.jeremyevans.net/documentation.html

    # ==> General
    # Initialize Sequel and have it reuse Active Record's database connection.
    db Sequel.postgres(extensions: :activerecord_connection, keep_reference: false)

    # Avoid DB query that checks accounts table schema at boot time.
    convert_token_id_to_integer? { User.columns_hash["id"].type == :integer }

    # Change prefix of table and foreign key column names from default "account"
    accounts_table :users
    verify_account_table :user_verification_keys
    verify_login_change_table :user_login_change_keys
    reset_password_table :user_password_reset_keys
    # remember_table :user_remember_keys

    # The secret key used for hashing public-facing tokens for various features.
    # Defaults to Rails `secret_key_base`, but you can use your own secret key.
    # hmac_secret "273669715caef1957ecabcd2030920a61cfe0651a9136d38b7dea63f816a5f3f0bb283da3d5919f3677d80f0c9e80b3a11e41a987ab1809db1f5483e917a65d1"
    active_sessions_table :user_active_session_keys
    active_sessions_account_id_column :user_id

    omniauth_identities_table :user_identities
    omniauth_identities_account_id_column :user_id

    jwt_secret { hmac_secret }

    # Accept nly JSON requests.
    only_json? true

    already_an_account_with_this_login_message { "an account with this email already exists" }

    email_subject_prefix "Budget Buddy - "

    verify_account_email_subject "Request to verify your account"
    reset_password_email_subject "Request to change your password"
    verify_login_change_email_subject "Request to change your email"
    password_changed_email_subject "Password change"

    password_confirm_param "password_confirm"
    new_password_param "new_password"

    email_from "dan@danvarela.com"

    login_does_not_meet_requirements_message do
      "invalid email#{", #{login_requirement_message}" if login_requirement_message}"
    end

    # Handle login and password confirmation fields on the client side.
    # require_password_confirmation? false
    # require_login_confirmation? false

    # Use path prefix for all routes.
    # prefix "/auth"

    # Specify the controller used for view rendering, CSRF, and callbacks.
    rails_controller { RodauthController }

    # Make built-in page titles accessible in your views via an instance variable.
    title_instance_variable :@page_title

    # Store account status in an integer column without foreign key constraint.
    account_status_column :status

    # Store password hash in a column instead of a separate table.
    account_password_hash_column :password_hash

    # Set password when creating account instead of when verifying.
    verify_account_set_password? false

    # Change some default param keys.
    login_param "email"
    login_confirm_param "email-confirm"

    # password_confirm_param "confirm_password"

    no_matching_login_message "account with this email does not exist"
    verify_login_change_error_flash "Unable to verify change of email"
    verify_login_change_notice_flash	"You email has been changed successfully"

    # Redirect back to originally requested location after authentication.
    # login_return_to_requested_location? true
    # two_factor_auth_return_to_requested_location? true # if using MFA

    # Autologin the user after they have reset their password.
    # reset_password_autologin? true

    # Delete the account record when the user has closed their account.
    # delete_account_on_close? true

    # Redirect to the app from login and registration pages if already logged in.
    # already_logged_in { redirect login_redirect }

    # ==> Emails
    # Use a custom mailer for delivering authentication emails.
    create_reset_password_email do
      RodauthMailer.reset_password(self.class.configuration_name, account_id, reset_password_key_value)
    end
    create_verify_account_email do
      RodauthMailer.verify_account(self.class.configuration_name, account_id, verify_account_key_value)
    end
    verify_account_email_link do
      "#{Rails.application.credentials.frontend[:url]}/auth/verify-account?key=#{token_param_value(verify_account_key_value)}"
    end
    verify_login_change_email_link do
      "#{Rails.application.credentials.frontend[:url]}/auth/verify-email-change?key=#{token_param_value(verify_login_change_key_value)}"
    end
    create_verify_login_change_email do |_login|
      RodauthMailer.verify_login_change(self.class.configuration_name, account_id, verify_login_change_key_value)
    end
    create_password_changed_email do
      RodauthMailer.password_changed(self.class.configuration_name, account_id)
    end
    # create_reset_password_notify_email do
    #   RodauthMailer.reset_password_notify(self.class.configuration_name, account_id)
    # end
    # create_email_auth_email do
    #   RodauthMailer.email_auth(self.class.configuration_name, account_id, email_auth_key_value)
    # end
    # create_unlock_account_email do
    #   RodauthMailer.unlock_account(self.class.configuration_name, account_id, unlock_account_key_value)
    # end
    send_email do |email|
      # queue email delivery on the mailer after the transaction commits
      db.after_commit { email.deliver_later }
    end

    # ==> Flash
    # Override default flash messages.
    # create_account_notice_flash "Your account has been created. Please verify your account by visiting the confirmation link sent to your email address."
    # require_login_error_flash "Login is required for accessing this page"
    # login_notice_flash nil

    # ==> Validation
    # Override default validation error messages.
    # no_matching_login_message "user with this email address doesn't exist"
    # already_an_account_with_this_login_message "user with this email address already exists"
    # password_too_short_message { "needs to have at least #{password_minimum_length} characters" }
    # login_does_not_meet_requirements_message { "invalid email#{", #{login_requirement_message}" if login_requirement_message}" }

    # Passwords shorter than 8 characters are considered weak according to OWASP.
    password_minimum_length 8
    # bcrypt has a maximum input length of 72 bytes, truncating any extra bytes.
    password_maximum_bytes 72

    # Custom password complexity requirements (alternative to password_complexity feature).
    # password_meets_requirements? do |password|
    #   super(password) && password_complex_enough?(password)
    # end
    # auth_class_eval do
    #   def password_complex_enough?(password)
    #     return true if password.match?(/\d/) && password.match?(/[^a-zA-Z\d]/)
    #     set_password_requirement_error_message(:password_simple, "requires one number and one special character")
    #     false
    #   end
    # end

    # ==> Remember Feature
    # Remember all logged in users.
    # after_login { remember_login }

    # Or only remember users that have ticked a "Remember Me" checkbox on login.
    # after_login { remember_login if param_or_nil("remember") }

    # Extend user's remember period when remembered via a cookie
    # extend_remember_deadline? true

    # ==> Hooks
    # Validate custom fields in the create account form.
    # before_create_account do
    #   throw_error_status(422, "name", "must be present") if param("name").empty?
    # end

    # Perform additional actions after the account is created.
    # after_create_account do
    #   Profile.create!(account_id: account_id, name: param("name"))
    # end

    # Do additional cleanup after the account is closed.
    # after_close_account do
    #   Profile.find_by!(account_id: account_id).destroy
    # end

    # ==> Deadlines
    # Change default deadlines for some actions.
    # verify_account_grace_period 3.days.to_i
    # reset_password_deadline_interval Hash[hours: 6]
    # verify_login_change_deadline_interval Hash[days: 2]
    # remember_deadline_interval Hash[days: 30]
  end
end
