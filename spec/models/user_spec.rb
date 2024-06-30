require "rails_helper"

RSpec.describe User, type: :model do
  context "associations" do
    subject { build(:user) }
    it { should have_many(:financial_accounts).dependent(:destroy) }
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:transactions).dependent(:destroy) }
  end
end
