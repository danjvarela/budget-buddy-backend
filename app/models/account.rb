class Account < ApplicationRecord
  # include Rodauth::Rails.model
  include Rodauth::Model(RodauthApp.rodauth)
  enum :status, unverified: 1, verified: 2, closed: 3
  has_many :financial_accounts, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :transactions, dependent: :destroy
end
