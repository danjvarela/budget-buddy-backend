class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render json: {error: "resource not found"}, status: :not_found
  end

  def authenticate
    rodauth.require_account
  end

  def current_user
    rodauth.rails_account
  end
end
