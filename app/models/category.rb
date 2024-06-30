class Category < ApplicationRecord
  has_many :transactions, dependent: :nullify
  belongs_to :user
  enum :category_type, expense: 1, income: 2
  validates :name, presence: true, uniqueness: {scope: [:user_id, :category_type], case_sensitive: false}
  validates :category_type, presence: true
end
