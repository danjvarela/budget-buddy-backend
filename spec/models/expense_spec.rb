require "rails_helper"

RSpec.describe Category, type: :model do
  context "validations" do
    subject { build(:expense) }
    it { should validate_presence_of(:date) }
  end

  context "associations" do
    subject { build(:expense) }
    it { should belong_to(:account) }
    it { should belong_to(:financial_account) }
    it { should belong_to(:category) }
  end
end
