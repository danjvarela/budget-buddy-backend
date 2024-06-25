RSpec.shared_context "auth" do
  before :all do
    @account = create :account
    post "/login", params: {email: @account.email, password: @account.password}, as: :json
    @token = response.headers["Authorization"]
  end

  let(:account) { create :account }

  let(:valid_headers) {
    {
      Authorization: "Bearer #{@token}"
    }
  }

  let(:account) { @account }
end
