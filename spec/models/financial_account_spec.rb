require "rails_helper"

RSpec.describe FinancialAccount, type: :model do
  context "validations" do
    subject { build(:financial_account) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
  end

  context "associations" do
    subject { build(:financial_account) }
    it { should belong_to(:user) }
    it { should have_many(:transactions).dependent(:nullify) }
    it { should have_many(:transfer_transactions_as_origin).with_foreign_key("from_financial_account_id").class_name("Transaction").dependent(:nullify).inverse_of("from_financial_account") }
    it { should have_many(:transfer_transactions_as_receiver).with_foreign_key("to_financial_account_id").class_name("Transaction").dependent(:nullify).inverse_of("to_financial_account") }
  end
end
