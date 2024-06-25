require "rails_helper"

RSpec.describe FinancialAccount, type: :model do
  context "validations" do
    subject { build(:financial_account) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:amount) }
  end

  context "associations" do
    subject { build(:financial_account) }
    it { should belong_to(:account) }
  end
end
