class SessionsController < ProtectedResourceController
  # retrieves the currently logged account
  def current_account
    render json: ActiveModelSerializers::SerializableResource.new(current_user).serializable_hash
  end
end
