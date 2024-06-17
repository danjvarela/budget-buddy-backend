class Account < ApplicationRecord
  include Rodauth::Rails.model
  include Rodauth::Model(RodauthApp.rodauth)
  enum :status, unverified: 1, verified: 2, closed: 3
end
