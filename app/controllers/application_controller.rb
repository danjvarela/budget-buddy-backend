class ApplicationController < ActionController::API
  include Pundit::Authorization
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  private

  def render_not_found
    render json: {error: "resource not found"}, status: :not_found
  end

  def not_authorized
    render json: {error: "you are not authorized to do this action"}, status: :forbidden
  end

  def authenticate
    rodauth.require_account
  end

  def current_user
    rodauth.rails_account
  end

  def camelize_keys(obj)
    obj.deep_transform_keys { |key| key.to_s.camelize(:lower).to_sym }
  end
end
