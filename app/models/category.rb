class Category < ApplicationRecord
  has_many :expenses, dependent: :destroy
  belongs_to :account
  enum :category_type, [:expense, :income]
  validates :name, presence: true, uniqueness: {scope: :account_id, case_sensitive: false}
  validates :category_type, presence: true
end
