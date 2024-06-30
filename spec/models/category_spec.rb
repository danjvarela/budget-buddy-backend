require "rails_helper"

RSpec.describe Category, type: :model do
  context "validations" do
    subject { build(:category) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to([:user_id, :category_type]).case_insensitive }
    it { should validate_presence_of(:category_type) }
  end

  context "associations" do
    subject { build(:category) }
    it { should belong_to(:user) }
    it { should have_many(:transactions).dependent(:nullify) }
  end
end
