class SessionsController < ProtectedResourceController
  # retrieves the currently logged account
  def current_account
    render json: ActiveModelSerializers::SerializableResource.new(logged_account).serializable_hash
  end
end
