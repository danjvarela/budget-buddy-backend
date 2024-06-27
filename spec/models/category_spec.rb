require "rails_helper"

RSpec.describe Category, type: :model do
  context "validations" do
    subject { build(:category) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:account_id).case_insensitive }
    it { should validate_presence_of(:category_type) }
  end

  context "associations" do
    subject { build(:category) }
    it { should belong_to(:account) }
  end
end
