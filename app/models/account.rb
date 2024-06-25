class Account < ApplicationRecord
  # include Rodauth::Rails.model
  include Rodauth::Model(RodauthApp.rodauth)
  enum :status, unverified: 1, verified: 2, closed: 3
  has_many :financial_accounts, dependent: :destroy
end
