class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render json: {errors: "resource not found"}, status: :not_found
  end

  def authenticate
    rodauth.require_account
  end

  def logged_account
    rodauth.rails_account
  end

  # adds the account id
  # useful so that user will not add the account_id to
  # the params if the user is logged in
  def include_account_id(obj)
    {**obj, account_id: logged_account.id}.deep_symbolize_keys
  end
end
