RSpec.shared_context "auth" do
  let(:logged_account) {
    create :account
  }

  let(:Authorization) {
    post "/login", params: {email: logged_account.email, password: logged_account.password}, as: :json
    response.headers["Authorization"]
  }
end
