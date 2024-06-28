class SessionsController < ProtectedResourceController
  # retrieves the currently logged account
  def current_account
    render json: AccountSerializer.new(logged_account).serializable_hash
  end
end
