class SessionsController < ApplicationController
  before_action :authenticate

  # retrieves the currently logged account
  def current_account
    render json: AccountSerializer.new(rodauth.rails_account).serializable_hash
  end
end
