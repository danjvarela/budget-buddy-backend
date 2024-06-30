RSpec.shared_context "auth" do
  let(:logged_user) {
    user = create :user
    user.verified!
    user
  }

  let(:Authorization) {
    post "/login", params: {email: logged_user.email, password: logged_user.password}, as: :json
    response.headers["Authorization"]
  }
end
