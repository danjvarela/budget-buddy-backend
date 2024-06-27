require "rails_helper"

RSpec.describe Account, type: :model do
  context "associations" do
    subject { build(:account) }
    it { should have_many(:financial_accounts) }
    it { should have_many(:categories) }
  end
end
