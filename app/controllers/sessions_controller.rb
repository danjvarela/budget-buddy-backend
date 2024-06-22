class SessionsController < ApplicationController
  before_action :authenticate

  # retrieves the currently logged account
  def current_account
    account = AccountSerializer.new(rodauth.rails_account).serializable_hash
    render json: {data: account[:data][:attributes]}
  end
end
