require "rails_helper"

RSpec.describe Account, type: :model do
  context "associations" do
    subject { build(:account) }
    it { should have_many(:financial_accounts).dependent(:destroy) }
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:expenses).dependent(:destroy) }
    it { should have_many(:transactions).dependent(:destroy) }
  end
end
