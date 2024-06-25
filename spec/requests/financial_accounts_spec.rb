require "rails_helper"
require "auth_context"

RSpec.describe "financial accounts", type: :request do
  include_context "auth"

  describe "GET /financial_accounts" do
    it "renders a successful response" do
      create :financial_account
      get financial_accounts_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /financial_accounts/:id" do
    it "renders a successful response" do
      financial_account = create :financial_account
      get financial_account_url(financial_account), headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /financial_accounts" do
    context "with valid parameters" do
      let(:valid_attributes) { attributes_for :financial_account }

      it "creates a new FinancialAccount" do
        expect {
          post financial_accounts_url,
            params: {financial_account: valid_attributes}, headers: valid_headers, as: :json
        }.to change(FinancialAccount, :count).by(1)
      end

      it "renders a JSON response with the new financial_account" do
        post financial_accounts_url,
          params: {financial_account: valid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) {
        {**attributes_for(:financial_account), amount: nil}
      }

      it "does not create a new FinancialAccount" do
        expect {
          post financial_accounts_url,
            params: {financial_account: invalid_attributes}, as: :json
        }.to change(FinancialAccount, :count).by(0)
      end

      it "renders a JSON response with errors for the new financial_account" do
        post financial_accounts_url,
          params: {financial_account: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /financial_account/:id" do
    context "with valid parameters" do
      it "updates the requested financial_account" do
        financial_account = create :financial_account
        new_attributes = attributes_for :financial_account
        patch financial_account_url(financial_account),
          params: {financial_account: new_attributes}, headers: valid_headers, as: :json
        financial_account.reload
        expect(financial_account.name).to eq(new_attributes[:name])
      end

      it "renders a JSON response with the financial_account" do
        financial_account = create :financial_account
        new_attributes = attributes_for :financial_account
        patch financial_account_url(financial_account),
          params: {financial_account: new_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the financial_account" do
        financial_account = create :financial_account
        invalid_attributes = {amount: nil}
        patch financial_account_url(financial_account),
          params: {financial_account: invalid_attributes}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /financial_account/:id" do
    it "destroys the requested financial_account" do
      financial_account = create :financial_account
      expect {
        delete financial_account_url(financial_account), headers: valid_headers, as: :json
      }.to change(FinancialAccount, :count).by(-1)
    end
  end
end
