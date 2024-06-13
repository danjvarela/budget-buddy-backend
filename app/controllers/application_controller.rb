class ApplicationController < ActionController::API
  after_action :set_jwt_token

  private

  # send jwt token back after each request
  def set_jwt_token
    if rodauth.use_jwt? && rodauth.valid_jwt?
      response.headers["Authorization"] = rodauth.session_jwt
    end
  end
end
